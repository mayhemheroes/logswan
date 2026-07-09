/* Baked ASan defaults for the fuzz build (linked in by mayhem/build.sh).
 * detect_leaks=0: logswan intentionally leaves end-of-process allocations to the OS;
 * LeakSanitizer would abort every run at exit and mask real memory-safety defects.
 * Weak + overridable; Mayhem's runtime ASAN_OPTIONS are not replaced. */
__attribute__((weak)) const char *__asan_default_options(void) {
	return "detect_leaks=0";
}
