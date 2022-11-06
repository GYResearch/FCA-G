class Pair:
    def __init__(self, l, r):
        self.l = l
        self.r = r
    def getL(self):
        return self.l
    def getR(self):
        return self.r
    def setL(self, l):
        self.l = l
    def setR(self, r):
        self.r = r
    def setLR(self, l, r):
        self.l = l
        self.r = r
    def __eq__(self, other):
        return self.l == other.l and self.r == other.r

    def __hash__(self):
        return hash(self.l)

    def reversal(self):
        temp = self.l
        self.l = self.r
        self.r = temp
        return self




