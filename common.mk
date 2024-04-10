.PHONY: all
all: $(ALL)

%.com: %.o
	ld --oformat binary -e start -Ttext 0x100 $< -o $@

%.o: %.s
	as $< -o $@

.PHONY: clean
clean::
	rm -f *~ \#*
	rm -f *.o $(ALL)
