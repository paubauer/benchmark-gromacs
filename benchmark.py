from __future__ import print_function
#import openmm.app as app
#import openmm as mm
#import openmm.unit as unit
from datetime import datetime
import os
from argparse import ArgumentParser

def timeIntegration(context, steps, initialSteps):
    """Integrate a Context for a specified number of steps, then return how many seconds it took."""
    if initialSteps:
        context.getIntegrator().step(initialSteps) # Make sure everything is fully initialized
        context.getState(getEnergy=True)
    start = datetime.now()
    context.getIntegrator().step(steps)
    context.getState(getEnergy=True)
    end = datetime.now()
    elapsed = end-start
    return elapsed.seconds + elapsed.microseconds*1e-6

def downloadAmberSuite():
    """Download and extract Amber benchmark to Amber20_Benchmark_Suite/ in current directory."""
    dirname = 'Amber20_Benchmark_Suite'
    url = 'https://ambermd.org/Amber20_Benchmark_Suite.tar.gz'
    if not os.path.exists(dirname):
        import urllib.request
        print('Downloading', url)
        filename, headers = urllib.request.urlretrieve(url, filename='Amber20_Benchmark_Suite.tar.gz')
        import tarfile
        print('Extracting', filename)
        tarfh = tarfile.open(filename, 'r:gz')
        tarfh.extractall(path=dirname)
    return dirname
    
def runOneTest(testName, options):
    """Perform a single benchmarking simulation."""
    steps = 1000
    if options.steps:
        steps = options.steps
    
    if testName == 'adh_dodec_stream_commands':
        os.system(f'/usr/local/gromacs/bin/gmx mdrun -pin on -nsteps {steps} -resetstep 90000 -ntmpi 1 -ntomp 48 -noconfout -nb gpu -bonded cpu -pme gpu -v -gpu_id 0 -s adh_dodec/topol.tpr')
    elif testName == 'adh_dodec_mi100_commands':
        os.system(f'/usr/local/gromacs/bin/gmx mdrun -pin on -nsteps {steps} -resetstep 90000 -ntmpi 2 -ntomp 28 -noconfout -nb gpu -bonded cpu -pme gpu -npme 1 -v -gpu_id 0 -s adh_dodec/topol.tpr')
    elif testName == 'adh_dodec_mi200_commands':
        os.system(f'/usr/local/gromacs/bin/gmx mdrun -pin on -nsteps {steps} -resetstep 90000 -ntmpi 1 -ntomp 64 -noconfout -nb gpu -bonded gpu -pme gpu -v -gpu_id 0 -s adh_dodec/topol.tpr')
    elif testName == 'stmv_stream_commands':
        os.system(f'/usr/local/gromacs/bin/gmx mdrun -pin on -nsteps {steps} -resetstep 90000 -ntmpi 2 -ntomp 24 -noconfout -nb gpu -bonded cpu -pme gpu -npme 1 -v -gpu_id 0 -s stmv/topol.tpr')
    elif testName == 'stmv_dodec_mi100_commands':
        os.system(f'/usr/local/gromacs/bin/gmx mdrun -pin on -nsteps {steps} -resetstep 90000 -ntmpi 2 -ntomp 28 -noconfout -nb gpu -bonded cpu -pme gpu -npme 1 -v -gpu_id 0 -s stmv/topol.tpr')
    elif testName == 'stmv_dodec_mi200_commands':
        os.system(f'/usr/local/gromacs/bin/gmx mdrun -pin on -nsteps {steps} -resetstep 90000 -ntmpi 1 -ntomp 64 -noconfout -nb gpu -bonded gpu -pme gpu -v -gpu_id 0 -s stmv/topol.tpr')
    elif testName == 'celluloze_nve_stream_commands':
        os.system(f'/usr/local/gromacs/bin/gmx mdrun -pin on -nsteps {steps} -resetstep 90000 -ntmpi 2 -ntomp 28 -noconfout -nb gpu -bonded cpu -pme gpu -npme 1 -v -gpu_id 0 -s cellulose_nve/topol.tpr')
    elif testName == 'celluloze_nve_dodec_mi100_commands':
        os.system(f'/usr/local/gromacs/bin/gmx mdrun -pin on -nsteps {steps} -resetstep 90000 -ntmpi 2 -ntomp 28 -noconfout -nb gpu -bonded cpu -pme gpu -npme 1 -v -gpu_id 0 -s cellulose_nve/topol.tpr')
    elif testName == 'celluloze_nve_dodec_mi200_commands':
        os.system(f'/usr/local/gromacs/bin/gmx mdrun -pin on -nsteps {steps} -resetstep 90000 -ntmpi 1 -ntomp 64 -noconfout -nb gpu -bonded gpu -pme gpu -v -gpu_id 0 -s cellulose_nve/topol.tpr')
    else:
        print('Unknown test')
        return 0
    
    # if options.steps:
    #     steps = options.steps
    #     time = timeIntegration(context, steps, initialSteps)
    # else:
    #     steps = 20
    #     while True:
    #         time = timeIntegration(context, steps, initialSteps)
    #         if time >= 0.5*options.seconds:
    #             break
    #         if time < 0.5:
    #             steps = int(steps*1.0/time) # Integrate enough steps to get a reasonable estimate for how many we'll need.
    #         else:
    #             steps = int(steps*options.seconds/time)
    # print('Integrated %d steps in %g seconds' % (steps, time))
    # print('%g ns/day' % (dt*steps*86400/time).value_in_unit(unit.nanoseconds))
    return 0#(dt*steps*86400/time).value_in_unit(unit.nanoseconds)
def printResults(results):
    """Print results in a format that can be copied into any streadsheet program."""
    print()
    # 2 columns: test and performance
    for (test, r) in results:
        print(f'{test}\t{r}')
    print()
    # 1 column: performance only
    for (test, r) in results:
        print(r)
    print()
allTests = ['adh_dodec_stream_commands', 'adh_dodec_mi100_commands', 'adh_dodec_mi200_commands', 'stmv_stream_commands', 'stmv_dodec_mi100_commands', 'stmv_dodec_mi200_commands', 'celluloze_nve_stream_commands', 'celluloze_nve_dodec_mi100_commands', 'celluloze_nve_dodec_mi200_commands']
# Parse the command line options.
parser = ArgumentParser()
# platformNames = [mm.Platform.getPlatform(i).getName() for i in range(mm.Platform.getNumPlatforms())]
# parser.add_argument('--platform', dest='platform', choices=platformNames, help='name of the platform ##to benchmark')
parser.add_argument('--test', dest='tests', nargs='*', choices=allTests,
    help='the test to perform: gbsa, rf, pme, apoa1rf, apoa1pme, apoa1ljpme, amoebagk, amoebapme,  amber20-dhfr,  amber20-factorix, amber20-cellulose, amber20-stmv [default: all except amber-*]')
parser.add_argument('--ensemble', default='NVT', dest='ensemble', choices=('NPT', 'NVE', 'NVT'), help='the thermodynamic ensemble to simulate [default: NVT]')
parser.add_argument('--pme-cutoff', default=0.9, dest='cutoff', type=float, help='direct space cutoff for PME in nm [default: 0.9]')
parser.add_argument('--seconds', default=60, dest='seconds', type=float, help='target simulation length in seconds [default: 60]')
parser.add_argument('--steps', default=None, dest='steps', type=int, help='target simulation length in steps, used instead of --seconds if set')
parser.add_argument('--polarization', default='mutual', dest='polarization', choices=('direct', 'extrapolated', 'mutual'), help='the polarization method for AMOEBA: direct, extrapolated, or mutual [default: mutual]')
parser.add_argument('--mutual-epsilon', default=1e-5, dest='epsilon', type=float, help='mutual induced epsilon for AMOEBA [default: 1e-5]')
parser.add_argument('--heavy-hydrogens', action='store_true', default=False, dest='heavy', help='repartition mass to allow a larger time step')
parser.add_argument('--device', default=None, dest='device', help='device index for CUDA, HIP or OpenCL')
parser.add_argument('--profile', action='store_true', dest='profile', help='special mode for kernel profiling (using nvprof or rocprof): without a separate stream for PME')
args = parser.parse_args()
# if args.platform is None:
#     parser.error('No platform specified')
# print('Platform:', args.platform)
# if args.platform in ('CUDA', 'OpenCL', 'HIP'):
#     if args.device is not None:
#       print('Device:', args.device)
# Run the simulations.
tests = allTests
if args.tests:
    tests = args.tests
results = []
for test in tests:
    try:
        r = runOneTest(test, args)
        results.append((test, r))
    except KeyboardInterrupt:
        printResults(results)
        exit(0)
    except Exception as ex:
        print('Test failed: %s' % ex)
        results.append((test, 0))
if len(tests) > 1:
    printResults(results)