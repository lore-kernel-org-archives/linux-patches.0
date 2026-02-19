Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF5427EC7C;
	Thu, 19 Feb 2026 02:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466687; cv=none; b=KAVPvUXOSWtO1GcUfBgWWB4O/8+9kxuJEo6fInEdGV3hykrgj9O3MR9mz7XgD3DeJHuZPS5HHac1mbwPKrqpQyYx+4cCzVBi3YfgPntBwn/HOY57E8zUIoVUJp/cBqFMLhh3zIwp+FpwDTwT1tnJroKKD9Ng4qu+Eu9Y/Tk/Z+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466687; c=relaxed/simple;
	bh=3reYJvSH7ahSG/B6SvWXMM/NjZMpd+EdHuwNA20VIFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dafxJiE5OyeZjYwExHpY78iU+zhE8QTsyEfMFKbaBJs0Qc/soQaW/0Yh6kmCTR06gk9mIT6Vv/Z/DkxN6r05kRjHlXxw+LhYI6Aiz//xY82yDhzfV4SQBg8ADhVXTVtUHLXamIKjNSNdmNrGOlIEJBb72Vr7kdod9Bzvba8vIh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sFQ7e7v9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sFQ7e7v9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B583FC19422;
	Thu, 19 Feb 2026 02:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466686;
	bh=3reYJvSH7ahSG/B6SvWXMM/NjZMpd+EdHuwNA20VIFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFQ7e7v90bKn4xhOGBnPm0OvJcpTh+xIz989Mtjuh4hQZqdE0JLikRIzWiHw2uj8g
	 ls4P4OLOQwp31Rp4vVDpbs/i08122CuKGDotDN2AHhj0ZcD90Z6XU5f0/jW4LLjQFL
	 Bxe1F7GQQkBImLD91Y6Klu6p/dA6V47OSqkh5YQnEV1YWbnis6PY6P6zQEhrSxHjVH
	 9MZrBeMPZw2JRdJtRGyRJj3QHdL63LtqgB+ofkDfZy1uxjYwdtKAciRiF9qAUoZWQg
	 94fO19d2lSvYNsQNBGal+WwGVe5PCum50HSUnkb5/w+SGakFEU6vXTBLfxWoHFqDdW
	 YtzNlBs2foKRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Biju Das <biju.das.jz@bp.renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	jirislaby@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] serial: rsci: Add set_rtrg() callback
Date: Wed, 18 Feb 2026 21:03:54 -0500
Message-ID: <20260219020422.1539798-18-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit b346e5d7dbf6696176417923c49838a1beb1d785 ]

The rtrg variable is populated in sci_init_single() for RZ/T2H. Add
set_rtrg() callback for setting the rtrg value.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://patch.msgid.link/20251129164325.209213-4-biju.das.jz@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

`fifosize = 16`, so `fifosize > 1` is true, meaning the
`rx_fifo_trigger` sysfs attribute is also created. Both sysfs paths are
reachable and will cause NULL pointer dereferences without the
`set_rtrg` callback.

### Summary of Analysis

**What the commit does:** Adds a `set_rtrg()` callback to the RSCI
serial driver that programs the receive FIFO trigger level into the
hardware.

**What bug it fixes:** Without this callback, the `set_rtrg` function
pointer in `rsci_port_ops` is NULL. The shared SCI framework code in
`sh-sci.c` calls `s->ops->set_rtrg()` **without NULL checks** from
multiple paths:

1. **sysfs `rx_fifo_trigger` write** (line 1347): Created for RSCI
   because `fifosize=16 > 1`. Writing to it calls NULL `set_rtrg` →
   **kernel crash/panic**
2. **sysfs `rx_fifo_timeout` write** (line 1392): Explicitly created for
   `SCI_PORT_RSCI` at line 3921-3922. Writing a non-zero value calls
   NULL `set_rtrg` → **kernel crash/panic**
3. **Timer callback `rx_fifo_timer_fn`** (line 1322): Once a user writes
   to `rx_fifo_timeout`, the timer is set up and will fire, calling NULL
   `set_rtrg` → **kernel crash/panic**
4. **Interrupt handler path** (lines 1980-1982): If `rx_trigger > 1`
   (it's 15 for RSCI) and `rx_fifo_timeout > 0`, the interrupt handler
   calls NULL `rtrg_enabled` first → **kernel crash/panic**

The `rx_trigger` for RSCI is initialized to 15 (line 3333), and both
sysfs attributes are created, making these paths reachable from
userspace.

**Risk assessment:** LOW risk. The change adds a simple function that
reads a register, clamps a value, and writes it back. It only affects
the RSCI port type. The callback is registered in the existing ops
structure. No behavioral changes for any other port type.

**Scope:** Small - one new function (~15 lines) and one ops structure
entry.

**Stable criteria check:**
- Fixes a real bug: YES - NULL pointer dereference (kernel crash)
  reachable from sysfs
- Obviously correct: YES - straightforward register read/modify/write
- Small and contained: YES - ~15 lines of new code, 1 file
- No new features: The function itself enables correct operation of
  existing sysfs interfaces; the commit message frames it as "adding a
  callback" but it's actually fixing a NULL pointer dereference
- Tested: YES - has "Tested-by:" tag

**Note:** The commit is also missing a `rtrg_enabled` callback, which is
also called without NULL check at line 1981. This commit only adds
`set_rtrg`, not `rtrg_enabled`. However, `set_rtrg` alone fixes the most
immediate crash paths (sysfs writes and timer). The `rtrg_enabled` path
at line 1981 would still be a problem but only if both `rx_trigger > 1`
AND `rx_fifo_timeout > 0`, which requires explicit user action to set
the timeout.

### Verification

- **Verified** that `SCI_PORT_RSCI` sets `rx_trigger = 15` at sh-
  sci.c:3332-3333
- **Verified** that `rx_fifo_timeout` sysfs attribute is created for
  `SCI_PORT_RSCI` at sh-sci.c:3921-3922
- **Verified** that `rx_fifo_trigger` sysfs attribute is created when
  `fifosize > 1` at sh-sci.c:3916-3919 (RSCI fifosize=16 per rsci.c:420)
- **Verified** that `set_rtrg` is called without NULL checks at sh-sci.c
  lines 1322, 1347, 1349, 1392, 1517, 1955, 1982, 2661, 2666, 2668
- **Verified** that `rtrg_enabled` is called without NULL check at sh-
  sci.c:1981
- **Verified** that the RSCI `rsci_set_termios` at rsci.c:154-169 does
  NOT call the shared `sci_set_termios` (lines 2673+) so the set_termios
  path at lines 2659-2668 is not directly triggered for RSCI
- **Verified** that `rsci_port_ops` before this commit has no `set_rtrg`
  callback (it was not listed in the pre-patch ops structure)
- **Could NOT verify** whether a separate commit adds `rtrg_enabled` for
  RSCI (this commit only adds `set_rtrg`)

**YES**

 drivers/tty/serial/rsci.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/tty/serial/rsci.c b/drivers/tty/serial/rsci.c
index b3c48dc1e07db..0533a4bb1d03c 100644
--- a/drivers/tty/serial/rsci.c
+++ b/drivers/tty/serial/rsci.c
@@ -151,6 +151,22 @@ static void rsci_start_rx(struct uart_port *port)
 	rsci_serial_out(port, CCR0, ctrl);
 }
 
+static int rsci_scif_set_rtrg(struct uart_port *port, int rx_trig)
+{
+	u32 fcr = rsci_serial_in(port, FCR);
+
+	if (rx_trig >= port->fifosize)
+		rx_trig = port->fifosize - 1;
+	else if (rx_trig < 1)
+		rx_trig = 0;
+
+	fcr &= ~FCR_RTRG4_0;
+	fcr |= field_prep(FCR_RTRG4_0, rx_trig);
+	rsci_serial_out(port, FCR, fcr);
+
+	return rx_trig;
+}
+
 static void rsci_set_termios(struct uart_port *port, struct ktermios *termios,
 			     const struct ktermios *old)
 {
@@ -454,6 +470,7 @@ static const struct sci_port_ops rsci_port_ops = {
 	.poll_put_char		= rsci_poll_put_char,
 	.prepare_console_write	= rsci_prepare_console_write,
 	.suspend_regs_size	= rsci_suspend_regs_size,
+	.set_rtrg		= rsci_scif_set_rtrg,
 	.shutdown_complete	= rsci_shutdown_complete,
 };
 
-- 
2.51.0

