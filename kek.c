#include <stdint.h>

int main() {
	struct {uint32_t a[2]} b;
	b.a[0] = 5;
	kek(&b, 1, 2);
	printf("%d %d\n", b.a[0], b.a[1]);
}
