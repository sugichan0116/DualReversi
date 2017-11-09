interface Rule {
  byte
  ISVALID     = (byte)1,
  ISNORMAL    = (byte)2,
  ISBLACK    = (byte)4,
  ISWHITE    = (byte)8,
  ISSIMPLE    = (byte)32,
  ISPOSITION  = (byte)64;
}