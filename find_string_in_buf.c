long find_string_in_buf(
	const unsigned char *buf, 
	size_t buf_size,
	const char *s)
{
	long i, j;
	int slen = strlen(s);
	long imax = buf_size - slen + 1;
	long ret = -1;
	int match;

	for (i=0; i<imax; i++) {
		match = 1;
		for (j=0; j<slen; j++) {
			if (buf[i+j] != s[j]) {
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
