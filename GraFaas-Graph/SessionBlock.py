class Session:
    pass

# TCP 정보 기록 Class
class TCPPacket:
    # 기본 생성자
    def __init__(self):
        self.__type = None
        self.__src = None
        self.__sport = None
        self.__dst = None
        self.__dport = None
        self.__flag = None
        self.__hasRaw = None
        self.__rawNumber = -1
    
    # dictionay 정보를 기반으로 하는 생성자
    def __init__(self, packetDict:dict):
        self.__type = packetDict['type']
        self.__src = packetDict['src']
        self.__sport = packetDict['sport']
        self.__dst = packetDict['dst']
        self.__dport = packetDict['dport']
        self.__flag = packetDict['flag']
        self.__hasRaw = packetDict['hasRaw']
        self.__rawNumber = packetDict['rawNumber']

    #getter
    def src(self):
        return self.__src

    def sport(self):
        return self.__sport
    
    def dst(self):
        return self.__dst

    def dport(self):
        return self.__dport

# ARP 정보 기록 Class
class ARPBlock:
    # 기본 생성자
    def __init__(self):
        # self.__type = None
        # self.__hwsrc = None
        # self.__psrc = None
        self.__hwdst = None
        self.__pdst = None
    
    # dictionay 정보를 기반으로 하는 생성자
    def __init__(self, packetDict:dict):
        # self.__type = packetDict['type']
        # self.__hwsrc = packetDict['hwsrc']
        # self.__psrc = packetDict['psrc']
        self.__hwdst = packetDict['hwdst']
        self.__pdst = packetDict['pdst']

    #getter
    # @property
    # def psrc(self):
    #     return self.__psrc
    
    @property
    def pdst(self):
        return self.__pdst

    @property
    def hwdst(self):
        return self.__hwdst

    #setter
    @hwdst.setter
    def hwdst(self, dst:str):
        self.__hwdst = dst