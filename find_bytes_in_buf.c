long find_bytes_in_buf(	
	const unsigned char *buf, 
	size_t buf_size,
	const unsigned char bytes[])
{
	long i, j;
	int slen = sizeof(bytes);
	long imax = buf_size - slen + 1;
	long ret = -1;
	int match;
	
    for (i = 0; i < imax; i++)
    {
		match = 1;
		for (j = 0; j <slen; j++) {
			if (bytes[j] == 0x3F ) continue;
				//0x3F '?' is for any value
			if (buf[i+j] != bytes[j]) {
				match = 0;
				break;
			}
		}
		if (match) {
			ret = i + (long)buf;
			break;
		}	
  	}
	return ret;
}
