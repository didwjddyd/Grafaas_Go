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
    
    # dictionay 정보를 기반으로 하는 생성자
    def __init__(self, packetDict:dict):
        self.__type = packetDict['type']
        self.__src = packetDict['src']
        self.__sport = packetDict['sport']
        self.__dst = packetDict['dst']
        self.__dport = packetDict['dport']
        self.__flag = packetDict['flag']
        self.__hasRaw = packetDict['hasRaw']

    #methods
    def GetSrcIp(self):
        return f'{self.__src}:{self.__sport}'
    
    def GetDstIp(self):
        return f'{self.__dst}:{self.__dport}'

class ARPBlock:
    def __init__(self):
        self.__type = 'ARP'
        self.__op = None
        self.__hwsrc = None
        self.__hwdst = None
        self.__psrc = None
        self.__pdst = None