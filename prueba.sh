n=1;
while :; do
 head -c $n </dev/urandom >/tmp/in.bin;
 ./tp0 -a encode -i /tmp/in.bin -o /tmp/out.b16;
 ./tp0 -a decode -i /tmp/out.b16 -o /tmp/out.bin;

	if diff /tmp/in.bin /tmp/out.bin; then :; else
		echo ERROR: $n;
		break;

	fi

echo ok: $n;

	n="`expr $n + 1`";

rm -f /tmp/in.bin /tmp/out.b16 /tmp/out.bin

done
