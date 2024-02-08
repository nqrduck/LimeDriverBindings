# distutils: language = c++
# cython: language_level=3

from cpython.mem cimport PyMem_Malloc, PyMem_Free
from libc.stdlib cimport malloc, free

from libcpp.string cimport string

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
        string file_pattern
        string file_stamp
        string save_path

        string stamp_start
        string stamp_end
        

cdef class PyLimeConfig:
    cdef LimeConfig_t* _config

    def __cinit__(self):
        self._config = <LimeConfig_t*>malloc(sizeof(LimeConfig_t))
        if self._config is NULL:
            raise MemoryError()

    def __dealloc__(self):
        if self._config is not NULL:
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

    
    
    # String properties
    @property
    def file_pattern(self):
        return self._config.file_pattern.decode('utf-8')

    @file_pattern.setter
    def file_pattern(self, value):
        self._config.file_pattern = value.encode('utf-8')

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
    def save_path(self, value):
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
