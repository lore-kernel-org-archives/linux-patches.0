Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFEE30DD36;
	Sat, 25 Oct 2025 16:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409437; cv=none; b=DQOQPeWy0aj1zBkE6qZ8PN5lMAiwr+NfWfanjJCVKtLRwuQk8E7PWyzFw48d+q/w9MIuxRxpNNtIek5QQ6Kh3b7UY4q6op0mfsP5aEpmTBv0RPUWUEK6b6jEULBchAlDhTDkNaC9s+a+GcLHr9xbYZ8NEuUEMYT+QWXuVpF381E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409437; c=relaxed/simple;
	bh=MpKdhaeCkETQtgiFgR94/spgW6KnrrW1mFB3ds5sGIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kjhsK5lzQ/5sKnsP4dclFtVHyLNM/btIaWbP9KHasp3ioXT9OwAKkliW2RhCJ0EVzATZcSdVk13tca+0O8ZURPxXnU55kSC//+Q9JPBpUG7EidUWxO4qpgOsYJqtuOVlJo43Yt/1SJ2Va04Yqnk27UU8B06nBP4g69d2dOx03RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eps9lJkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eps9lJkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F901C4CEF5;
	Sat, 25 Oct 2025 16:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409437;
	bh=MpKdhaeCkETQtgiFgR94/spgW6KnrrW1mFB3ds5sGIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eps9lJkQ9Pi3v6FbUksqoJHFi3qp+0fgfkb87mlC4vJq+GBFACRpdnbDXgNGZ3/Lp
	 DMwWALvkkAe3s6edVPvvgoj9O9N2bQhwstyGcw4X6D3yiJCSOwYFe1foXMgWOK4A+G
	 x043Dayrb9O1KSj0HAy1mQQgi51ndqWRM1C1P3EosBV2JJj+DQ0WffqKl9YGPXmhOQ
	 mlA77qaaKdHVfYP4L47BJ7ci/9EhAU0OOscZkZreCsxzbQ1UUACZEgIKCdT+NSbEow
	 +8aBoAuEC3LzdjtSq4eMCLeZoQeEQJduQo2fArybGxISm0RYXQW3j5ZWdszDqJUuaM
	 bTSb2q0C6Jwug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] tty: serial: ip22zilog: Use platform device for probing
Date: Sat, 25 Oct 2025 11:59:16 -0400
Message-ID: <20251025160905.3857885-325-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

[ Upstream commit 3fc36ae6abd263a5cbf93b2f5539eccc1fc753f7 ]

After commit 84a9582fd203 ("serial: core: Start managing serial controllers
to enable runtime PM") serial drivers need to provide a device in
struct uart_port.dev otherwise an oops happens. To fix this issue
for ip22zilog driver switch driver to a platform driver and setup
the serial device in sgi-ip22 code.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Link: https://lore.kernel.org/r/20250725134018.136113-1-tsbogend@alpha.franken.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation

- Bug fixed: After 84a9582fd203 (“serial: core: Start managing serial
  controllers to enable runtime PM”), serial core expects every
  uart_port to have a valid parent device in uart_port.dev. The current
  ip22zilog driver does not set port.dev at all, which can lead to a
  NULL dereference in serial core paths that unconditionally use
  port->dev (for example pm_runtime checks and serial-base
  registration). This is a real crash scenario that affects users on SGI
  IP22 when the driver is present.

- Root cause in current tree:
  - No device parent: ip22zilog never assigns port.dev anywhere in the
    driver (drivers/tty/serial/ip22zilog.c), so port->dev remains NULL
    throughout probe/open/console paths.
  - Serial core’s runtime-PM-enabled flow uses port->dev directly; see
    the runtime PM checks and port device plumbing added by 84a9582fd203
    in drivers/tty/serial/serial_core.c:160 and
    drivers/tty/serial/serial_port.c, which assume port->dev is valid.
  - Existing implementation hard-codes resources and requests the IRQ
    globally, independent of a struct device; see request_irq(...) in
    drivers/tty/serial/ip22zilog.c:1158 and the chained interrupt
    handler entry at drivers/tty/serial/ip22zilog.c:424.

- What the patch changes to fix it:
  - Introduces a platform device for the Zilog UART on IP22, supplying
    both MMIO and IRQ resources:
    - Adds SGI_ZILOG_BASE and a resource table for the UART and its IRQ
      in arch/mips/sgi-ip22/ip22-platform.c, and registers it during
      init (device_initcall). This provides the physical device for
      uart_port.dev to reference.
  - Converts ip22zilog to a platform driver so it can bind to that
    device and set port.dev properly:
    - Adds an ip22zilog platform_driver with .probe/.remove; in probe
      it:
      - Gets the IRQ via platform_get_irq and the memory region via
        devm_platform_get_and_ioremap_resource.
      - Sets up two uart_port instances (channel B then A), crucially
        assigning port.dev = &pdev->dev for both channels.
      - Calls uart_add_one_port() for both ports after registering the
        IRQ handler.
    - The interrupt handler is updated to refer to the two static ports
      instead of a “dev_id chain”, but preserves the same handling
      sequence for combined R3 pending bits (A then B) as before. This
      keeps the interrupt servicing semantics identical to the old code
      that read R3 once and handled both channels.
  - Internal cleanups that reduce risk:
    - Replaces dynamic table allocation and ad hoc “chip chain” with a
      small static array of two ports (NUM_CHANNELS=2) matching the
      hardware.
    - Uses devm_* mapping for MMIO resource management to avoid manual
      iounmap errors.

- Why this is a stable-appropriate backport:
  - Fixes a crash: It directly addresses a NULL-pointer dereference
    class introduced when 84a9582fd203 landed by ensuring uart_port.dev
    is valid. This is a user-visible failure (oops) rather than a
    theoretical corner case.
  - Localized change: Affects only SGI IP22 MIPS platform code and the
    ip22zilog driver. No impact on other serial drivers or
    architectures.
  - No feature creep: The driver is merely adapted to the serial core’s
    new expectations; no new functionality is introduced beyond binding
    to a proper platform device and resource plumbing.
  - Architectural compatibility: The driver already hard-coded these
    resources via sgioc->uart and SGI_SERIAL_IRQ. The patch just
    formalizes them as platform resources via arch/mips/sgi-
    ip22/ip22-platform.c and switches to platform_probe to wire up
    port.dev.
  - Minimal behavioral change: The interrupt handling remains the same
    in effect. Previously, ip22zilog_interrupt() used a “chain” and one
    R3 read to service both channels; the new code keeps a single R3
    read (from channel A) and services both channels using the same bit
    tests. Compare the old entry point at
    drivers/tty/serial/ip22zilog.c:424 with the new interrupt flow using
    ip22zilog_port_table[CHANNEL_A] then [CHANNEL_B].
  - Precedent and core dependencies present: The repository contains
    84a9582fd203 and the serial_base/serial_ctrl/serial_port
    infrastructure. This change aligns ip22zilog with the runtime-PM-
    capable serial core.

- Notable details and side effects:
  - IRQ lifetime: The old driver requested the IRQ
    (drivers/tty/serial/ip22zilog.c:1158) but never freed it on exit;
    the new code similarly requests the IRQ in probe. While the new code
    uses request_irq (not devm_request_irq) and remove() does not
    free_irq, this mirrors existing behavior and remains non-regressive
    for built-in/non-hotplug scenarios common on IP22.
  - Console considerations: The console code is retained. Providing a
    proper device parent early via device_initcall() platform
    registration helps ensure the ports have a valid device for serial
    core and console setup on runtime-PM-enabled kernels.
  - Resource mapping: The platform device provides a 16-byte MMIO region
    starting at SGI_ZILOG_BASE that covers ctrl/data for both channels.
    The driver maps channelB and channelA regions by offsetting within
    that resource, matching the previous assumed layout in struct
    zilog_layout.

- Conclusion and backport scope:
  - Backport this fix to all stable trees that include 84a9582fd203 (or
    equivalent serial core runtime-PM changes). Without it, ip22zilog
    crashes due to a NULL port->dev.
  - It is a contained, necessary adaptation to the serial core’s device
    model with low regression risk restricted to the SGI IP22 platform.

Key references in current tree for context
- Old IRQ registration (no parent device):
  drivers/tty/serial/ip22zilog.c:1158
- Old interrupt entry using a chained dev_id:
  drivers/tty/serial/ip22zilog.c:424
- Presence of serial core runtime-PM infrastructure requiring port.dev:
  - serial core changes: 84a9582fd2030 (git show confirms)
  - serial_core runtime PM usage of port->dev:
    drivers/tty/serial/serial_core.c:160
- Platform device init precedents for IP22: arch/mips/sgi-
  ip22/ip22-platform.c:223 (existing device_initcall nearby; the patch
  adds a new one for the UART)

 arch/mips/sgi-ip22/ip22-platform.c |  32 +++
 drivers/tty/serial/ip22zilog.c     | 352 ++++++++++++-----------------
 2 files changed, 175 insertions(+), 209 deletions(-)

diff --git a/arch/mips/sgi-ip22/ip22-platform.c b/arch/mips/sgi-ip22/ip22-platform.c
index 0b2002e02a477..3a53690b4b333 100644
--- a/arch/mips/sgi-ip22/ip22-platform.c
+++ b/arch/mips/sgi-ip22/ip22-platform.c
@@ -221,3 +221,35 @@ static int __init sgi_ds1286_devinit(void)
 }
 
 device_initcall(sgi_ds1286_devinit);
+
+#define SGI_ZILOG_BASE	(HPC3_CHIP0_BASE + \
+			 offsetof(struct hpc3_regs, pbus_extregs[6]) + \
+			 offsetof(struct sgioc_regs, uart))
+
+static struct resource sgi_zilog_resources[] = {
+	{
+		.start	= SGI_ZILOG_BASE,
+		.end	= SGI_ZILOG_BASE + 15,
+		.flags	= IORESOURCE_MEM
+	},
+	{
+		.start	= SGI_SERIAL_IRQ,
+		.end	= SGI_SERIAL_IRQ,
+		.flags	= IORESOURCE_IRQ
+	}
+};
+
+static struct platform_device zilog_device = {
+	.name		= "ip22zilog",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(sgi_zilog_resources),
+	.resource	= sgi_zilog_resources,
+};
+
+
+static int __init sgi_zilog_devinit(void)
+{
+	return platform_device_register(&zilog_device);
+}
+
+device_initcall(sgi_zilog_devinit);
diff --git a/drivers/tty/serial/ip22zilog.c b/drivers/tty/serial/ip22zilog.c
index c2cae50f06f33..6e19c6713849a 100644
--- a/drivers/tty/serial/ip22zilog.c
+++ b/drivers/tty/serial/ip22zilog.c
@@ -30,6 +30,7 @@
 #include <linux/console.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
+#include <linux/platform_device.h>
 
 #include <linux/io.h>
 #include <asm/irq.h>
@@ -50,8 +51,9 @@
 #define ZSDELAY_LONG()		udelay(20)
 #define ZS_WSYNC(channel)	do { } while (0)
 
-#define NUM_IP22ZILOG		1
-#define NUM_CHANNELS		(NUM_IP22ZILOG * 2)
+#define NUM_CHANNELS		2
+#define CHANNEL_B		0
+#define CHANNEL_A		1
 
 #define ZS_CLOCK		3672000	/* Zilog input clock rate. */
 #define ZS_CLOCK_DIVISOR	16      /* Divisor this driver uses. */
@@ -62,9 +64,6 @@
 struct uart_ip22zilog_port {
 	struct uart_port		port;
 
-	/* IRQ servicing chain.  */
-	struct uart_ip22zilog_port	*next;
-
 	/* Current values of Zilog write registers.  */
 	unsigned char			curregs[NUM_ZSREGS];
 
@@ -72,7 +71,6 @@ struct uart_ip22zilog_port {
 #define IP22ZILOG_FLAG_IS_CONS		0x00000004
 #define IP22ZILOG_FLAG_IS_KGDB		0x00000008
 #define IP22ZILOG_FLAG_MODEM_STATUS	0x00000010
-#define IP22ZILOG_FLAG_IS_CHANNEL_A	0x00000020
 #define IP22ZILOG_FLAG_REGS_HELD	0x00000040
 #define IP22ZILOG_FLAG_TX_STOPPED	0x00000080
 #define IP22ZILOG_FLAG_TX_ACTIVE	0x00000100
@@ -84,6 +82,8 @@ struct uart_ip22zilog_port {
 	unsigned char			prev_status;
 };
 
+static struct uart_ip22zilog_port ip22zilog_port_table[NUM_CHANNELS];
+
 #define ZILOG_CHANNEL_FROM_PORT(PORT)	((struct zilog_channel *)((PORT)->membase))
 #define UART_ZILOG(PORT)		((struct uart_ip22zilog_port *)(PORT))
 #define IP22ZILOG_GET_CURR_REG(PORT, REGNUM)		\
@@ -93,7 +93,6 @@ struct uart_ip22zilog_port {
 #define ZS_IS_CONS(UP)	((UP)->flags & IP22ZILOG_FLAG_IS_CONS)
 #define ZS_IS_KGDB(UP)	((UP)->flags & IP22ZILOG_FLAG_IS_KGDB)
 #define ZS_WANTS_MODEM_STATUS(UP)	((UP)->flags & IP22ZILOG_FLAG_MODEM_STATUS)
-#define ZS_IS_CHANNEL_A(UP)	((UP)->flags & IP22ZILOG_FLAG_IS_CHANNEL_A)
 #define ZS_REGS_HELD(UP)	((UP)->flags & IP22ZILOG_FLAG_REGS_HELD)
 #define ZS_TX_STOPPED(UP)	((UP)->flags & IP22ZILOG_FLAG_TX_STOPPED)
 #define ZS_TX_ACTIVE(UP)	((UP)->flags & IP22ZILOG_FLAG_TX_ACTIVE)
@@ -423,60 +422,57 @@ static void ip22zilog_transmit_chars(struct uart_ip22zilog_port *up,
 
 static irqreturn_t ip22zilog_interrupt(int irq, void *dev_id)
 {
-	struct uart_ip22zilog_port *up = dev_id;
-
-	while (up) {
-		struct zilog_channel *channel
-			= ZILOG_CHANNEL_FROM_PORT(&up->port);
-		unsigned char r3;
-		bool push = false;
-
-		uart_port_lock(&up->port);
-		r3 = read_zsreg(channel, R3);
+	struct uart_ip22zilog_port *up;
+	struct zilog_channel *channel;
+	unsigned char r3;
+	bool push = false;
 
-		/* Channel A */
-		if (r3 & (CHAEXT | CHATxIP | CHARxIP)) {
-			writeb(RES_H_IUS, &channel->control);
-			ZSDELAY();
-			ZS_WSYNC(channel);
+	up = &ip22zilog_port_table[CHANNEL_A];
+	channel = ZILOG_CHANNEL_FROM_PORT(&up->port);
 
-			if (r3 & CHARxIP)
-				push = ip22zilog_receive_chars(up, channel);
-			if (r3 & CHAEXT)
-				ip22zilog_status_handle(up, channel);
-			if (r3 & CHATxIP)
-				ip22zilog_transmit_chars(up, channel);
-		}
-		uart_port_unlock(&up->port);
+	uart_port_lock(&up->port);
+	r3 = read_zsreg(channel, R3);
 
-		if (push)
-			tty_flip_buffer_push(&up->port.state->port);
+	/* Channel A */
+	if (r3 & (CHAEXT | CHATxIP | CHARxIP)) {
+		writeb(RES_H_IUS, &channel->control);
+		ZSDELAY();
+		ZS_WSYNC(channel);
 
-		/* Channel B */
-		up = up->next;
-		channel = ZILOG_CHANNEL_FROM_PORT(&up->port);
-		push = false;
+		if (r3 & CHARxIP)
+			push = ip22zilog_receive_chars(up, channel);
+		if (r3 & CHAEXT)
+			ip22zilog_status_handle(up, channel);
+		if (r3 & CHATxIP)
+			ip22zilog_transmit_chars(up, channel);
+	}
+	uart_port_unlock(&up->port);
 
-		uart_port_lock(&up->port);
-		if (r3 & (CHBEXT | CHBTxIP | CHBRxIP)) {
-			writeb(RES_H_IUS, &channel->control);
-			ZSDELAY();
-			ZS_WSYNC(channel);
+	if (push)
+		tty_flip_buffer_push(&up->port.state->port);
 
-			if (r3 & CHBRxIP)
-				push = ip22zilog_receive_chars(up, channel);
-			if (r3 & CHBEXT)
-				ip22zilog_status_handle(up, channel);
-			if (r3 & CHBTxIP)
-				ip22zilog_transmit_chars(up, channel);
-		}
-		uart_port_unlock(&up->port);
+	/* Channel B */
+	up = &ip22zilog_port_table[CHANNEL_B];
+	channel = ZILOG_CHANNEL_FROM_PORT(&up->port);
+	push = false;
 
-		if (push)
-			tty_flip_buffer_push(&up->port.state->port);
+	uart_port_lock(&up->port);
+	if (r3 & (CHBEXT | CHBTxIP | CHBRxIP)) {
+		writeb(RES_H_IUS, &channel->control);
+		ZSDELAY();
+		ZS_WSYNC(channel);
 
-		up = up->next;
+		if (r3 & CHBRxIP)
+			push = ip22zilog_receive_chars(up, channel);
+		if (r3 & CHBEXT)
+			ip22zilog_status_handle(up, channel);
+		if (r3 & CHBTxIP)
+			ip22zilog_transmit_chars(up, channel);
 	}
+	uart_port_unlock(&up->port);
+
+	if (push)
+		tty_flip_buffer_push(&up->port.state->port);
 
 	return IRQ_HANDLED;
 }
@@ -692,16 +688,16 @@ static void __ip22zilog_reset(struct uart_ip22zilog_port *up)
 		udelay(100);
 	}
 
-	if (!ZS_IS_CHANNEL_A(up)) {
-		up++;
-		channel = ZILOG_CHANNEL_FROM_PORT(&up->port);
-	}
+	up = &ip22zilog_port_table[CHANNEL_A];
+	channel = ZILOG_CHANNEL_FROM_PORT(&up->port);
+
 	write_zsreg(channel, R9, FHWRES);
 	ZSDELAY_LONG();
 	(void) read_zsreg(channel, R0);
 
 	up->flags |= IP22ZILOG_FLAG_RESET_DONE;
-	up->next->flags |= IP22ZILOG_FLAG_RESET_DONE;
+	up = &ip22zilog_port_table[CHANNEL_B];
+	up->flags |= IP22ZILOG_FLAG_RESET_DONE;
 }
 
 static void __ip22zilog_startup(struct uart_ip22zilog_port *up)
@@ -942,47 +938,6 @@ static const struct uart_ops ip22zilog_pops = {
 	.verify_port	=	ip22zilog_verify_port,
 };
 
-static struct uart_ip22zilog_port *ip22zilog_port_table;
-static struct zilog_layout **ip22zilog_chip_regs;
-
-static struct uart_ip22zilog_port *ip22zilog_irq_chain;
-static int zilog_irq = -1;
-
-static void * __init alloc_one_table(unsigned long size)
-{
-	return kzalloc(size, GFP_KERNEL);
-}
-
-static void __init ip22zilog_alloc_tables(void)
-{
-	ip22zilog_port_table = (struct uart_ip22zilog_port *)
-		alloc_one_table(NUM_CHANNELS * sizeof(struct uart_ip22zilog_port));
-	ip22zilog_chip_regs = (struct zilog_layout **)
-		alloc_one_table(NUM_IP22ZILOG * sizeof(struct zilog_layout *));
-
-	if (ip22zilog_port_table == NULL || ip22zilog_chip_regs == NULL) {
-		panic("IP22-Zilog: Cannot allocate IP22-Zilog tables.");
-	}
-}
-
-/* Get the address of the registers for IP22-Zilog instance CHIP.  */
-static struct zilog_layout * __init get_zs(int chip)
-{
-	unsigned long base;
-
-	if (chip < 0 || chip >= NUM_IP22ZILOG) {
-		panic("IP22-Zilog: Illegal chip number %d in get_zs.", chip);
-	}
-
-	/* Not probe-able, hard code it. */
-	base = (unsigned long) &sgioc->uart;
-
-	zilog_irq = SGI_SERIAL_IRQ;
-	request_mem_region(base, 8, "IP22-Zilog");
-
-	return (struct zilog_layout *) base;
-}
-
 #define ZS_PUT_CHAR_MAX_DELAY	2000	/* 10 ms */
 
 #ifdef CONFIG_SERIAL_IP22_ZILOG_CONSOLE
@@ -1070,144 +1025,123 @@ static struct uart_driver ip22zilog_reg = {
 #endif
 };
 
-static void __init ip22zilog_prepare(void)
+static void __init ip22zilog_prepare(struct uart_ip22zilog_port *up)
 {
 	unsigned char sysrq_on = IS_ENABLED(CONFIG_SERIAL_IP22_ZILOG_CONSOLE);
+	int brg;
+
+	spin_lock_init(&up->port.lock);
+
+	up->port.iotype = UPIO_MEM;
+	up->port.uartclk = ZS_CLOCK;
+	up->port.fifosize = 1;
+	up->port.has_sysrq = sysrq_on;
+	up->port.ops = &ip22zilog_pops;
+	up->port.type = PORT_IP22ZILOG;
+
+	/* Normal serial TTY. */
+	up->parity_mask = 0xff;
+	up->curregs[R1] = EXT_INT_ENAB | INT_ALL_Rx | TxINT_ENAB;
+	up->curregs[R4] = PAR_EVEN | X16CLK | SB1;
+	up->curregs[R3] = RxENAB | Rx8;
+	up->curregs[R5] = TxENAB | Tx8;
+	up->curregs[R9] = NV | MIE;
+	up->curregs[R10] = NRZ;
+	up->curregs[R11] = TCBR | RCBR;
+	brg = BPS_TO_BRG(9600, ZS_CLOCK / ZS_CLOCK_DIVISOR);
+	up->curregs[R12] = (brg & 0xff);
+	up->curregs[R13] = (brg >> 8) & 0xff;
+	up->curregs[R14] = BRENAB;
+}
+
+static int ip22zilog_probe(struct platform_device *pdev)
+{
 	struct uart_ip22zilog_port *up;
-	struct zilog_layout *rp;
-	int channel, chip;
+	char __iomem *membase;
+	struct resource *res;
+	int irq;
+	int i;
 
-	/*
-	 * Temporary fix.
-	 */
-	for (channel = 0; channel < NUM_CHANNELS; channel++)
-		spin_lock_init(&ip22zilog_port_table[channel].port.lock);
-
-	ip22zilog_irq_chain = &ip22zilog_port_table[NUM_CHANNELS - 1];
-        up = &ip22zilog_port_table[0];
-	for (channel = NUM_CHANNELS - 1 ; channel > 0; channel--)
-		up[channel].next = &up[channel - 1];
-	up[channel].next = NULL;
-
-	for (chip = 0; chip < NUM_IP22ZILOG; chip++) {
-		if (!ip22zilog_chip_regs[chip]) {
-			ip22zilog_chip_regs[chip] = rp = get_zs(chip);
-
-			up[(chip * 2) + 0].port.membase = (char *) &rp->channelB;
-			up[(chip * 2) + 1].port.membase = (char *) &rp->channelA;
-
-			/* In theory mapbase is the physical address ...  */
-			up[(chip * 2) + 0].port.mapbase =
-				(unsigned long) ioremap((unsigned long) &rp->channelB, 8);
-			up[(chip * 2) + 1].port.mapbase =
-				(unsigned long) ioremap((unsigned long) &rp->channelA, 8);
-		}
+	up = &ip22zilog_port_table[CHANNEL_B];
+	if (up->port.dev)
+		return -ENOSPC;
 
-		/* Channel A */
-		up[(chip * 2) + 0].port.iotype = UPIO_MEM;
-		up[(chip * 2) + 0].port.irq = zilog_irq;
-		up[(chip * 2) + 0].port.uartclk = ZS_CLOCK;
-		up[(chip * 2) + 0].port.fifosize = 1;
-		up[(chip * 2) + 0].port.has_sysrq = sysrq_on;
-		up[(chip * 2) + 0].port.ops = &ip22zilog_pops;
-		up[(chip * 2) + 0].port.type = PORT_IP22ZILOG;
-		up[(chip * 2) + 0].port.flags = 0;
-		up[(chip * 2) + 0].port.line = (chip * 2) + 0;
-		up[(chip * 2) + 0].flags = 0;
-
-		/* Channel B */
-		up[(chip * 2) + 1].port.iotype = UPIO_MEM;
-		up[(chip * 2) + 1].port.irq = zilog_irq;
-		up[(chip * 2) + 1].port.uartclk = ZS_CLOCK;
-		up[(chip * 2) + 1].port.fifosize = 1;
-		up[(chip * 2) + 1].port.has_sysrq = sysrq_on;
-		up[(chip * 2) + 1].port.ops = &ip22zilog_pops;
-		up[(chip * 2) + 1].port.type = PORT_IP22ZILOG;
-		up[(chip * 2) + 1].port.line = (chip * 2) + 1;
-		up[(chip * 2) + 1].flags |= IP22ZILOG_FLAG_IS_CHANNEL_A;
-	}
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
 
-	for (channel = 0; channel < NUM_CHANNELS; channel++) {
-		struct uart_ip22zilog_port *up = &ip22zilog_port_table[channel];
-		int brg;
+	membase = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
+	if (IS_ERR(membase))
+		return PTR_ERR(membase);
 
-		/* Normal serial TTY. */
-		up->parity_mask = 0xff;
-		up->curregs[R1] = EXT_INT_ENAB | INT_ALL_Rx | TxINT_ENAB;
-		up->curregs[R4] = PAR_EVEN | X16CLK | SB1;
-		up->curregs[R3] = RxENAB | Rx8;
-		up->curregs[R5] = TxENAB | Tx8;
-		up->curregs[R9] = NV | MIE;
-		up->curregs[R10] = NRZ;
-		up->curregs[R11] = TCBR | RCBR;
-		brg = BPS_TO_BRG(9600, ZS_CLOCK / ZS_CLOCK_DIVISOR);
-		up->curregs[R12] = (brg & 0xff);
-		up->curregs[R13] = (brg >> 8) & 0xff;
-		up->curregs[R14] = BRENAB;
-	}
-}
+	ip22zilog_prepare(up);
 
-static int __init ip22zilog_ports_init(void)
-{
-	int ret;
+	up->port.mapbase = res->start + offsetof(struct zilog_layout, channelB);
+	up->port.membase = membase + offsetof(struct zilog_layout, channelB);
+	up->port.line = 0;
+	up->port.dev = &pdev->dev;
+	up->port.irq = irq;
 
-	printk(KERN_INFO "Serial: IP22 Zilog driver (%d chips).\n", NUM_IP22ZILOG);
+	up = &ip22zilog_port_table[CHANNEL_A];
+	ip22zilog_prepare(up);
 
-	ip22zilog_prepare();
+	up->port.mapbase = res->start + offsetof(struct zilog_layout, channelA);
+	up->port.membase = membase + offsetof(struct zilog_layout, channelA);
+	up->port.line = 1;
+	up->port.dev = &pdev->dev;
+	up->port.irq = irq;
 
-	if (request_irq(zilog_irq, ip22zilog_interrupt, 0,
-			"IP22-Zilog", ip22zilog_irq_chain)) {
+	if (request_irq(irq, ip22zilog_interrupt, 0,
+			"IP22-Zilog", NULL)) {
 		panic("IP22-Zilog: Unable to register zs interrupt handler.\n");
 	}
 
-	ret = uart_register_driver(&ip22zilog_reg);
-	if (ret == 0) {
-		int i;
-
-		for (i = 0; i < NUM_CHANNELS; i++) {
-			struct uart_ip22zilog_port *up = &ip22zilog_port_table[i];
-
-			uart_add_one_port(&ip22zilog_reg, &up->port);
-		}
-	}
-
-	return ret;
-}
-
-static int __init ip22zilog_init(void)
-{
-	/* IP22 Zilog setup is hard coded, no probing to do.  */
-	ip22zilog_alloc_tables();
-	ip22zilog_ports_init();
+	for (i = 0; i < NUM_CHANNELS; i++)
+		uart_add_one_port(&ip22zilog_reg,
+				  &ip22zilog_port_table[i].port);
 
 	return 0;
 }
 
-static void __exit ip22zilog_exit(void)
+static void ip22zilog_remove(struct platform_device *pdev)
 {
 	int i;
-	struct uart_ip22zilog_port *up;
 
 	for (i = 0; i < NUM_CHANNELS; i++) {
-		up = &ip22zilog_port_table[i];
-
-		uart_remove_one_port(&ip22zilog_reg, &up->port);
+		uart_remove_one_port(&ip22zilog_reg,
+				     &ip22zilog_port_table[i].port);
+		ip22zilog_port_table[i].port.dev = NULL;
 	}
+}
 
-	/* Free IO mem */
-	up = &ip22zilog_port_table[0];
-	for (i = 0; i < NUM_IP22ZILOG; i++) {
-		if (up[(i * 2) + 0].port.mapbase) {
-		   iounmap((void*)up[(i * 2) + 0].port.mapbase);
-		   up[(i * 2) + 0].port.mapbase = 0;
-		}
-		if (up[(i * 2) + 1].port.mapbase) {
-			iounmap((void*)up[(i * 2) + 1].port.mapbase);
-			up[(i * 2) + 1].port.mapbase = 0;
-		}
+static struct platform_driver ip22zilog_driver = {
+	.probe	= ip22zilog_probe,
+	.remove	= ip22zilog_remove,
+	.driver	= {
+		.name = "ip22zilog"
 	}
+};
+
+static int __init ip22zilog_init(void)
+{
+	int ret;
+
+	ret = uart_register_driver(&ip22zilog_reg);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&ip22zilog_driver);
+	if (ret)
+		uart_unregister_driver(&ip22zilog_reg);
 
+	return ret;
+
+}
+
+static void __exit ip22zilog_exit(void)
+{
 	uart_unregister_driver(&ip22zilog_reg);
+	platform_driver_unregister(&ip22zilog_driver);
 }
 
 module_init(ip22zilog_init);
-- 
2.51.0

