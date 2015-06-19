#ifndef _UTIL_H__
#define _UTIL_H__

// Error processing
void err_ret(const char *, ...);
void err_sys(const char *, ...);
void err_dump(const char *, ...);
void err_msg(const char *, ...);
void err_quit(const char *, ...);

#endif
