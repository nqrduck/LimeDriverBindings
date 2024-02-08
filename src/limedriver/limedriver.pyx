# distutils: language = c++
# cython: language_level=3

from cpython.mem cimport PyMem_Malloc, PyMem_Free
from libc.stdlib cimport malloc, free
from libc.string cimport memcpy, strcpy


from libcpp.string cimport string

import pathlib

cdef extern from "limedriver.h":
    cdef struct LimeConfig_t:
        float srate
        float frq
        float frq_set
        float RX_LPF
        float TX_LPF
        int RX_gain
        int TX_gain
        int TX_IcorrDC
        int TX_QcorrDC
        int TX_IcorrGain
        int TX_QcorrGain
        int TX_IQcorrPhase
        int RX_IcorrGain
        int RX_QcorrGain
        int RX_IQcorrPhase
        int RX_gain_rback[4]
        int TX_gain_rback[3]

        int Npulses
        double *p_dur
        int *p_dur_smp
        int *p_offs
        double *p_amp
        double *p_frq
        double *p_frq_smp
        double *p_pha
        int *p_phacyc_N
        int *p_phacyc_lev
        
        double *am_frq
        double *am_pha
        double *am_depth
        int *am_mode
        double *am_frq_smp
        double *fm_frq
        double *fm_pha
        double *fm_width
        int *fm_mode
        double *fm_frq_smp

        int *p_c0_en
        int *p_c1_en
        int *p_c2_en
        int *p_c3_en

        int c0_tim[4]
        int c1_tim[4]
        int c2_tim[4]
        int c3_tim[4]

        int c0_synth[5]
        int c1_synth[5]
        int c2_synth[5]
        int c3_synth[5]

        int averages
        int repetitions
        int pcyc_bef_avg
        double reptime_secs
        double rectime_secs
        int reptime_smps
        int rectime_smps
        int buffersize
        
        int override_init
        int override_save

        string file_pattern
        string file_stamp
        string save_path

        string stamp_start
        string stamp_end

    cdef LimeConfig_t initializeLimeConfig(int Npulses)

    cdef int run_experiment_from_LimeCfg(LimeConfig_t config)
        

cdef class PyLimeConfig:
    cdef LimeConfig_t* _config

    def __cinit__(self, Npulses):
        self._config = <LimeConfig_t*>malloc(sizeof(LimeConfig_t))
        if self._config is NULL:
            raise MemoryError()

        # Set Npulses
        self._config.Npulses = Npulses

        # Allocate memory for string fields
        self._config.file_pattern = <char*>malloc(256)
        self._config.file_stamp = <char*>malloc(256)
        self._config.save_path = <char*>malloc(256)
        self._config.stamp_start = <char*>malloc(256)
        self._config.stamp_end = <char*>malloc(256)

        # Allocate memory for arrays with Npulses elements
        self._config.p_dur = <double*>malloc(Npulses * sizeof(double))
        self._config.p_dur_smp = <int*>malloc(Npulses * sizeof(int))
        self._config.p_offs = <int*>malloc(Npulses * sizeof(int))
        self._config.p_amp = <double*>malloc(Npulses * sizeof(double))
        self._config.p_frq = <double*>malloc(Npulses * sizeof(double))
        self._config.p_frq_smp = <double*>malloc(Npulses * sizeof(double))
        self._config.p_pha = <double*>malloc(Npulses * sizeof(double))
        self._config.p_phacyc_N = <int*>malloc(Npulses * sizeof(int))
        self._config.p_phacyc_lev = <int*>malloc(Npulses * sizeof(int))
        
        self._config.am_frq = <double*>malloc(Npulses * sizeof(double))
        self._config.am_pha = <double*>malloc(Npulses * sizeof(double))
        self._config.am_depth = <double*>malloc(Npulses * sizeof(double))
        self._config.am_mode = <int*>malloc(Npulses * sizeof(int))
        self._config.am_frq_smp = <double*>malloc(Npulses * sizeof(double))
        self._config.fm_frq = <double*>malloc(Npulses * sizeof(double))
        self._config.fm_pha = <double*>malloc(Npulses * sizeof(double))
        self._config.fm_width = <double*>malloc(Npulses * sizeof(double))
        self._config.fm_mode = <int*>malloc(Npulses * sizeof(int))
        self._config.fm_frq_smp = <double*>malloc(Npulses * sizeof(double))
        self._config.p_c0_en = <int*>malloc(Npulses * sizeof(int))
        self._config.p_c1_en = <int*>malloc(Npulses * sizeof(int))
        self._config.p_c2_en = <int*>malloc(Npulses * sizeof(int))
        self._config.p_c3_en = <int*>malloc(Npulses * sizeof(int))

        # Memory for arrays with 4 elements
        self._config.RX_gain_rback = <int*>malloc(4 * sizeof(int))
        self._config.TX_gain_rback = <int*>malloc(3 * sizeof(int))
        self._config.c0_tim = <int*>malloc(4 * sizeof(int))
        self._config.c1_tim = <int*>malloc(4 * sizeof(int))
        self._config.c2_tim = <int*>malloc(4 * sizeof(int))
        self._config.c3_tim = <int*>malloc(4 * sizeof(int))

        # Memory for arrays with 5 elements
        self._config.c0_synth = <int*>malloc(5 * sizeof(int))
        self._config.c1_synth = <int*>malloc(5 * sizeof(int))
        self._config.c2_synth = <int*>malloc(5 * sizeof(int))
        self._config.c3_synth = <int*>malloc(5 * sizeof(int))

    def __dealloc__(self):
        if self._config is not NULL:
            free(self._config.p_frq)
            free(self._config.p_dur)    
            free(self._config.p_dur_smp)
            free(self._config.p_offs)
            free(self._config.p_amp)
            free(self._config.p_frq_smp)
            free(self._config.p_pha)
            free(self._config.p_phacyc_N)
            free(self._config.p_phacyc_lev)
            free(self._config.am_frq)
            free(self._config.am_pha)
            free(self._config.am_depth)
            free(self._config.am_mode)
            free(self._config.am_frq_smp)
            free(self._config.fm_frq)
            free(self._config.fm_pha)
            free(self._config.fm_width)
            free(self._config.fm_mode)
            free(self._config.fm_frq_smp)
            free(self._config.p_c0_en)
            free(self._config.p_c1_en)
            free(self._config.p_c2_en)
            free(self._config.p_c3_en)

            free(self._config)


    @property
    def srate(self):
        return self._config.srate

    @srate.setter
    def srate(self, float value):
        self._config.srate = value

    @property
    def frq(self):
        return self._config.frq

    @frq.setter
    def frq(self, float value):
        self._config.frq = value

    @property
    def frq_set(self):
        return self._config.frq_set

    @frq_set.setter
    def frq_set(self, float value):
        self._config.frq_set = value

    @property
    def RX_LPF(self):
        return self._config.RX_LPF

    @RX_LPF.setter
    def RX_LPF(self, float value):
        self._config.RX_LPF = value

    @property
    def TX_LPF(self):
        return self._config.TX_LPF

    @TX_LPF.setter
    def TX_LPF(self, float value):
        self._config.TX_LPF = value

    @property
    def RX_gain(self):
        return self._config.RX_gain

    @RX_gain.setter
    def RX_gain(self, int value):
        self._config.RX_gain = value

    @property
    def TX_gain(self):
        return self._config.TX_gain

    @TX_gain.setter
    def TX_gain(self, int value):
        self._config.TX_gain = value

    @property
    def TX_IcorrDC(self):
        return self._config.TX_IcorrDC

    @TX_IcorrDC.setter
    def TX_IcorrDC(self, int value):
        self._config.TX_IcorrDC = value

    @property
    def TX_QcorrDC(self):
        return self._config.TX_QcorrDC

    @TX_QcorrDC.setter
    def TX_QcorrDC(self, int value):
        self._config.TX_QcorrDC = value

    @property
    def TX_IcorrGain(self):
        return self._config.TX_IcorrGain

    @TX_IcorrGain.setter
    def TX_IcorrGain(self, int value):
        self._config.TX_IcorrGain = value

    @property
    def TX_QcorrGain(self):
        return self._config.TX_QcorrGain

    @TX_QcorrGain.setter
    def TX_QcorrGain(self, int value):
        self._config.TX_QcorrGain = value

    @property
    def TX_IQcorrPhase(self):
        return self._config.TX_IQcorrPhase

    @TX_IQcorrPhase.setter
    def TX_IQcorrPhase(self, int value):
        self._config.TX_IQcorrPhase = value

    @property
    def RX_IcorrGain(self):
        return self._config.RX_IcorrGain
    
    @RX_IcorrGain.setter
    def RX_IcorrGain(self, int value):
        self._config.RX_IcorrGain = value

    @property
    def RX_QcorrGain(self):
        return self._config.RX_QcorrGain

    @RX_QcorrGain.setter
    def RX_QcorrGain(self, int value):
        self._config.RX_QcorrGain = value

    @property
    def RX_IQcorrPhase(self):
        return self._config.RX_IQcorrPhase

    @RX_IQcorrPhase.setter
    def RX_IQcorrPhase(self, int value):
        self._config.RX_IQcorrPhase = value

    @property
    def Npulses(self):
        return self._config.Npulses

    @Npulses.setter
    def Npulses(self, int value):
        self._config.Npulses = value

    @property
    def averages(self):
        return self._config.averages

    @averages.setter
    def averages(self, int value):
        self._config.averages = value

    @property
    def repetitions(self):
        return self._config.repetitions

    @repetitions.setter
    def repetitions(self, int value):
        self._config.repetitions = value

    @property
    def pcyc_bef_avg(self):
        return self._config.pcyc_bef_avg

    @pcyc_bef_avg.setter
    def pcyc_bef_avg(self, int value):
        self._config.pcyc_bef_avg = value

    @property
    def reptime_secs(self):
        return self._config.reptime_secs

    @reptime_secs.setter
    def reptime_secs(self, float value):
        self._config.reptime_secs = value

    @property
    def rectime_secs(self):
        return self._config.rectime_secs

    @rectime_secs.setter
    def rectime_secs(self, float value):
        self._config.rectime_secs = value

    @property
    def reptime_smps(self):
        return self._config.reptime_smps

    @reptime_smps.setter
    def reptime_smps(self, int value):
        self._config.reptime_smps = value

    @property
    def rectime_smps(self):
        return self._config.rectime_smps

    @rectime_smps.setter
    def rectime_smps(self, int value):
        self._config.rectime_smps = value

    @property
    def buffersize(self):
        return self._config.buffersize

    @buffersize.setter
    def buffersize(self, int value):
        self._config.buffersize = value

    @property
    def override_init(self):
        return self._config.override_init

    @override_init.setter
    def override_init(self, int value):
        self._config.override_init = value

    @property
    def override_save(self):
        return self._config.override_save

    @override_save.setter
    def override_save(self, int value):
        self._config.override_save = value

    # Pointers

    @property
    def p_dur(self):
        return [self._config.p_dur[i] for i in range(self._config.Npulses)]

    @p_dur.setter
    def p_dur(self, list value):
        for i in range(len(value)):
            self._config.p_dur[i] = value[i]

    @property
    def p_dur_smp(self):
        return [self._config.p_dur_smp[i] for i in range(self._config.Npulses)]

    @p_dur_smp.setter
    def p_dur_smp(self, list value):
        for i in range(len(value)):
            self._config.p_dur_smp[i] = value[i]

    @property
    def p_offs(self):
        return [self._config.p_offs[i] for i in range(self._config.Npulses)]

    @p_offs.setter
    def p_offs(self, list value):
        for i in range(len(value)):
            self._config.p_offs[i] = value[i]

    @property
    def p_amp(self):
        return [self._config.p_amp[i] for i in range(self._config.Npulses)]

    @p_amp.setter
    def p_amp(self, list value):
        for i in range(len(value)):
            self._config.p_amp[i] = value[i]

    @property
    def p_frq(self):
        return [self._config.p_frq[i] for i in range(self._config.Npulses)]

    @p_frq.setter
    def p_frq(self, list value):
        for i in range(len(value)):
            self._config.p_frq[i] = value[i]

    @property
    def p_frq_smp(self):
        return [self._config.p_frq_smp[i] for i in range(self._config.Npulses)]

    @p_frq_smp.setter
    def p_frq_smp(self, list value):
        for i in range(len(value)):
            self._config.p_frq_smp[i] = value[i]

    @property
    def p_pha(self):
        return [self._config.p_pha[i] for i in range(self._config.Npulses)]

    @p_pha.setter
    def p_pha(self, list value):
        for i in range(len(value)):
            self._config.p_pha[i] = value[i]

    @property
    def p_phacyc_N(self):
        return [self._config.p_phacyc_N[i] for i in range(self._config.Npulses)]

    @p_phacyc_N.setter
    def p_phacyc_N(self, list value):
        for i in range(len(value)):
            self._config.p_phacyc_N[i] = value[i]

    @property
    def p_phacyc_lev(self):
        return [self._config.p_phacyc_lev[i] for i in range(self._config.Npulses)]

    @p_phacyc_lev.setter
    def p_phacyc_lev(self, list value):
        for i in range(len(value)):
            self._config.p_phacyc_lev[i] = value[i]

    @property
    def am_frq(self):
        return [self._config.am_frq[i] for i in range(self._config.Npulses)]

    @am_frq.setter
    def am_frq(self, list value):
        for i in range(len(value)):
            self._config.am_frq[i] = value[i]

    @property
    def am_pha(self):
        return [self._config.am_pha[i] for i in range(self._config.Npulses)]

    @am_pha.setter
    def am_pha(self, list value):
        for i in range(len(value)):
            self._config.am_pha[i] = value[i]

    @property
    def am_depth(self):
        return [self._config.am_depth[i] for i in range(self._config.Npulses)]

    @am_depth.setter
    def am_depth(self, list value):
        for i in range(len(value)):
            self._config.am_depth[i] = value[i]

    @property
    def am_mode(self):
        return [self._config.am_mode[i] for i in range(self._config.Npulses)]

    @am_mode.setter
    def am_mode(self, list value):
        for i in range(len(value)):
            self._config.am_mode[i] = value[i]

    @property
    def am_frq_smp(self):
        return [self._config.am_frq_smp[i] for i in range(self._config.Npulses)]

    @am_frq_smp.setter
    def am_frq_smp(self, list value):
        for i in range(len(value)):
            self._config.am_frq_smp[i] = value[i]

    @property
    def fm_frq(self):
        return [self._config.fm_frq[i] for i in range(self._config.Npulses)]

    @fm_frq.setter
    def fm_frq(self, list value):
        for i in range(len(value)):
            self._config.fm_frq[i] = value[i]

    @property
    def fm_pha(self):
        return [self._config.fm_pha[i] for i in range(self._config.Npulses)]

    @fm_pha.setter
    def fm_pha(self, list value):
        for i in range(len(value)):
            self._config.fm_pha[i] = value[i]

    @property
    def fm_width(self):
        return [self._config.fm_width[i] for i in range(self._config.Npulses)]

    @fm_width.setter
    def fm_width(self, list value):
        for i in range(len(value)):
            self._config.fm_width[i] = value[i]

    @property
    def fm_mode(self):
        return [self._config.fm_mode[i] for i in range(self._config.Npulses)]

    @fm_mode.setter
    def fm_mode(self, list value):
        for i in range(len(value)):
            self._config.fm_mode[i] = value[i]

    @property
    def fm_frq_smp(self):
        return [self._config.fm_frq_smp[i] for i in range(self._config.Npulses)]

    @fm_frq_smp.setter
    def fm_frq_smp(self, list value):
        for i in range(len(value)):
            self._config.fm_frq_smp[i] = value[i]

    @property
    def p_c0_en(self):
        return [self._config.p_c0_en[i] for i in range(self._config.Npulses)]

    @p_c0_en.setter
    def p_c0_en(self, list value):
        for i in range(len(value)):
            self._config.p_c0_en[i] = value[i]

    @property
    def p_c1_en(self):
        return [self._config.p_c1_en[i] for i in range(self._config.Npulses)]

    @p_c1_en.setter
    def p_c1_en(self, list value):
        for i in range(len(value)):
            self._config.p_c1_en[i] = value[i]

    @property
    def p_c2_en(self):
        return [self._config.p_c2_en[i] for i in range(self._config.Npulses)]

    @p_c2_en.setter
    def p_c2_en(self, list value):
        for i in range(len(value)):
            self._config.p_c2_en[i] = value[i]

    @property
    def p_c3_en(self):
        return [self._config.p_c3_en[i] for i in range(self._config.Npulses)]

    @p_c3_en.setter
    def p_c3_en(self, list value):
        for i in range(len(value)):
            self._config.p_c3_en[i] = value[i]

    # Arrays

    @property
    def RX_gain_rback(self):
        # Return the contents of 'RX_gain_rback' array as a Python list
        return [self._config.RX_gain_rback[i] for i in range(4)]

    @RX_gain_rback.setter
    def RX_gain_rback(self, values):
        # Expected 'values' to be a list with 4 integer elements
        if not isinstance(values, list) or len(values) != 4:
            raise ValueError("RX_gain_rback must be a list with 4 integers.")
        for i in range(4):
            self._config.RX_gain_rback[i] = values[i]

    @property
    def TX_gain_rback(self):
        return [self._config.TX_gain_rback[i] for i in range(3)]

    @TX_gain_rback.setter
    def TX_gain_rback(self, values):
        if not isinstance(values, list) or len(values) != 3:
            raise ValueError("TX_gain_rback must be a list with 3 integers.")
        for i in range(3):
            self._config.TX_gain_rback[i] = values[i]

    @property
    def c0_tim(self):
        return [self._config.c0_tim[i] for i in range(4)]

    @c0_tim.setter
    def c0_tim(self, values):
        if not isinstance(values, list) or len(values) != 4:
            raise ValueError("c0_tim must be a list with 4 integers.")
        for i in range(4):
            self._config.c0_tim[i] = values[i]

    @property
    def c1_tim(self):
        return [self._config.c1_tim[i] for i in range(4)]

    @c1_tim.setter
    def c1_tim(self, values):
        if not isinstance(values, list) or len(values) != 4:
            raise ValueError("c1_tim must be a list with 4 integers.")
        for i in range(4):
            self._config.c1_tim[i] = values[i]

    @property
    def c2_tim(self):
        return [self._config.c2_tim[i] for i in range(4)]

    @c2_tim.setter
    def c2_tim(self, values):
        if not isinstance(values, list) or len(values) != 4:
            raise ValueError("c2_tim must be a list with 4 integers.")
        for i in range(4):
            self._config.c2_tim[i] = values[i]

    @property
    def c3_tim(self):
        return [self._config.c3_tim[i] for i in range(4)]

    @c3_tim.setter
    def c3_tim(self, values):
        if not isinstance(values, list) or len(values) != 4:
            raise ValueError("c3_tim must be a list with 4 integers.")
        for i in range(4):
            self._config.c3_tim[i] = values[i]

    @property
    def c0_synth(self):
        return [self._config.c0_synth[i] for i in range(5)]

    @c0_synth.setter
    def c0_synth(self, values):
        if not isinstance(values, list) or len(values) != 5:
            raise ValueError("c0_synth must be a list with 5 integers.")
        for i in range(5):
            self._config.c0_synth[i] = values[i]

    @property
    def c1_synth(self):
        return [self._config.c1_synth[i] for i in range(5)]

    @c1_synth.setter
    def c1_synth(self, values):
        if not isinstance(values, list) or len(values) != 5:
            raise ValueError("c1_synth must be a list with 5 integers.")
        for i in range(5):
            self._config.c1_synth[i] = values[i]

    @property
    def c2_synth(self):
        return [self._config.c2_synth[i] for i in range(5)]

    @c2_synth.setter
    def c2_synth(self, values):
        if not isinstance(values, list) or len(values) != 5:
            raise ValueError("c2_synth must be a list with 5 integers.")
        for i in range(5):
            self._config.c2_synth[i] = values[i]

    @property
    def c3_synth(self):
        return [self._config.c3_synth[i] for i in range(5)]

    @c3_synth.setter
    def c3_synth(self, values):
        if not isinstance(values, list) or len(values) != 5:
            raise ValueError("c3_synth must be a list with 5 integers.")
        for i in range(5):
            self._config.c3_synth[i] = values[i]
 
    # String properties
    @property
    def file_pattern(self):
        return self._config.file_pattern.decode()

    @file_pattern.setter
    def file_pattern(self, value):
        self._config.file_pattern = value.encode()

    @property
    def file_stamp(self):
        return self._config.file_stamp.decode('utf-8')

    @file_stamp.setter
    def file_stamp(self, value):
        self._config.file_stamp = value.encode('utf-8')

    @property
    def save_path(self):
        return self._config.save_path.decode('utf-8')

    @save_path.setter
    def save_path(self, str value):
        self._config.save_path = value.encode('utf-8')

    @property
    def stamp_start(self):
        return self._config.stamp_start.decode('utf-8')

    @stamp_start.setter
    def stamp_start(self, value):
        self._config.stamp_start = value.encode('utf-8')

    @property
    def stamp_end(self):
        return self._config.stamp_end.decode('utf-8')

    @stamp_end.setter
    def stamp_end(self, value):
        self._config.stamp_end = value.encode('utf-8')

    @classmethod
    def initialize(cls, int Npulses):
        cdef LimeConfig_t config = initializeLimeConfig(Npulses)

        cdef PyLimeConfig instance = cls.__new__(cls, Npulses)

        instance.srate = config.srate
        instance.frq = config.frq
        instance.frq_set = config.frq_set
        instance.RX_LPF = config.RX_LPF
        instance.TX_LPF = config.TX_LPF
        instance.RX_gain = config.RX_gain
        instance.TX_gain = config.TX_gain
        instance.TX_IcorrDC = config.TX_IcorrDC
        instance.TX_QcorrDC = config.TX_QcorrDC
        instance.TX_IcorrGain = config.TX_IcorrGain
        instance.TX_QcorrGain = config.TX_QcorrGain
        instance.TX_IQcorrPhase = config.TX_IQcorrPhase
        instance.RX_IcorrGain = config.RX_IcorrGain
        instance.RX_QcorrGain = config.RX_QcorrGain
        instance.RX_IQcorrPhase = config.RX_IQcorrPhase
        instance.RX_gain_rback = config.RX_gain_rback
        instance.TX_gain_rback = config.TX_gain_rback
        instance.Npulses = config.Npulses
        instance.averages = config.averages
        instance.repetitions = config.repetitions
        instance.pcyc_bef_avg = config.pcyc_bef_avg
        instance.reptime_secs = config.reptime_secs
        instance.rectime_secs = config.rectime_secs
        instance.reptime_smps = config.reptime_smps
        instance.rectime_smps = config.rectime_smps
        instance.buffersize = config.buffersize
        instance.override_init = config.override_init
        instance.override_save = config.override_save

        instance.file_pattern = config.file_pattern.decode('utf-8')
        instance.file_stamp = config.file_stamp.decode('utf-8')
        instance.save_path = config.save_path.decode('utf-8')
        instance.stamp_start = config.stamp_start.decode('utf-8')
        instance.stamp_end = config.stamp_end.decode('utf-8')


        instance.p_dur = [config.p_dur[i] for i in range(Npulses)]
        instance.p_dur_smp = [config.p_dur_smp[i] for i in range(Npulses)]
        instance.p_offs = [config.p_offs[i] for i in range(Npulses)]
        instance.p_amp = [config.p_amp[i] for i in range(Npulses)]
        instance.p_frq = [config.p_frq[i] for i in range(Npulses)]
        instance.p_frq_smp = [config.p_frq_smp[i] for i in range(Npulses)]
        instance.p_pha = [config.p_pha[i] for i in range(Npulses)]
        instance.p_phacyc_N = [config.p_phacyc_N[i] for i in range(Npulses)]
        instance.p_phacyc_lev = [config.p_phacyc_lev[i] for i in range(Npulses)]
        instance.am_frq = [config.am_frq[i] for i in range(Npulses)]
        instance.am_pha = [config.am_pha[i] for i in range(Npulses)]
        instance.am_depth = [config.am_depth[i] for i in range(Npulses)]
        instance.am_mode = [config.am_mode[i] for i in range(Npulses)]
        instance.am_frq_smp = [config.am_frq_smp[i] for i in range(Npulses)]
        instance.fm_frq = [config.fm_frq[i] for i in range(Npulses)]
        instance.fm_pha = [config.fm_pha[i] for i in range(Npulses)]
        instance.fm_width = [config.fm_width[i] for i in range(Npulses)]
        instance.fm_mode = [config.fm_mode[i] for i in range(Npulses)]
        instance.fm_frq_smp = [config.fm_frq_smp[i] for i in range(Npulses)]
        instance.p_c0_en = [config.p_c0_en[i] for i in range(Npulses)]
        instance.p_c1_en = [config.p_c1_en[i] for i in range(Npulses)]
        instance.p_c2_en = [config.p_c2_en[i] for i in range(Npulses)]
        instance.p_c3_en = [config.p_c3_en[i] for i in range(Npulses)]

        instance.c0_tim = [config.c0_tim[i] for i in range(4)]
        instance.c1_tim = [config.c1_tim[i] for i in range(4)]
        instance.c2_tim = [config.c2_tim[i] for i in range(4)]
        instance.c3_tim = [config.c3_tim[i] for i in range(4)]
        instance.c0_synth = [config.c0_synth[i] for i in range(5)]
        instance.c1_synth = [config.c1_synth[i] for i in range(5)]
        instance.c2_synth = [config.c2_synth[i] for i in range(5)]
        instance.c3_synth = [config.c3_synth[i] for i in range(5)]

        return instance

    def run(self):
        return run_experiment_from_LimeCfg(self._config[0])

    def get_path(self):
        path = self.save_path + self.file_stamp + '_' + self.file_pattern + '.h5'
        path = pathlib.Path(path).absolute()
        return path