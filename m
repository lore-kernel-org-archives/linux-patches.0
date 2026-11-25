Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620396;
	b=2Ix8/9TnMlApf4tHMNxpRRLlzivm/KX/W8IpX61D+Tbe18A9nZ11H4iiqlrEGrWk8JQR
	 s0bbdlpumG4Zdno0B9E97qgDfuoomREHdj53M0am7kNC7u/lXSBMgRi21PIDlBwrnp/th
	 n/YwtWdZ4fodfRv3dBi6sSTIwbDyyj/3pDqCb59gNK++gjRBLqrmxbHPigf1zZWP1oBMp
	 g1tdWigPIfk+8O9fQkLK9+2ZtwAqnaHy+0jNiNIbKZljenJFqBGbr+7ozEAnccg4NL81E
	 VUn6WKShnEbNEVmMjCsb4OA0WTVXeVEyy5L0ktXFNgr+BqeFITz9Lt44CYrkQBg6rVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rcQEMjpYk1btmslTxRpdzeDt4kvnChF7P91yh8VEMt4=;
	b=o5d87l9wN5pTOkldCgFFPK9vCfB9GLpvUyoKJ7x6DCSuYVicPAbA+A0KGgB77ZDFBN7V
	 Lkcdlc1I7WSld6I+i7HuUeSLx0p8UoingfUMv3Mi25kmwQ+puZHy/QeN5JfXwDXroZe+Y
	 z2/aIs3iQ4zblwXi+QYOPx/DB4VjSsQweAEOTQxOKznDFZgpIz2vjeMhGLfGjhf6BDLYw
	 OoNuHCEa1GF62qhjek2xQyDya2vtcgkIR0WpBzo3xsb1UscPRYASDgl8zKC8l/kFbQ0Fl
	 MDyssellPQTuuH05gq+k1pFYLA8J4rH9UyA0j1DKmU1Vl3gSpDoVsD8ZdRDu0Mzx8mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EgOWiUSN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7E4606A31E;
	Wed, 25 Nov 2026 15:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EgOWiUSN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109331F000C4;
	Wed, 25 Nov 2026 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620395;
	bh=rcQEMjpYk1btmslTxRpdzeDt4kvnChF7P91yh8VEMt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EgOWiUSNwFU3+Ixh9LfdBakTNcjUPwvS1khEIX3VxdiEne2NTDnkZIMxqNpxKQ2VP
	 HtGxNJTu9EppX2wrz8WJsd0N7Z7z04gwkVvqHBbCckvqpf3QGZY1Th5jYKknmBA+j6
	 UD8LUj+IQQq1vfLjDwpxSfQE6+oOwD3z4ntWBGKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Nicolas Pitre <npitre@baylibre.com>,
	Kees Cook <kees+treewide@kernel.org>,
	Joshua Rogers <linux@joshua.hu>,
	Chris Mason <mason@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ronan Pigott <ronan@rjp.ie>,
	Liav Mordouch <liavmordouch@gmail.com>
Subject: [PATCH 7.3 0886/1005] vt: serialise the producers of the flip buffer
Date: Wed, 25 Nov 2026 15:37:04 +0100
Message-ID: <20261125143842.454497454@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit 5d1d814408c1c8e797031eac8ddd40de1a9e8e93 upstream.

Typing on a virtual console while the console replies to an escape
sequence can make the kernel write past the end of a buffer. A user who
can write to the foreground console can cause this on purpose if they
can also inject key events, through /dev/uinput or by writing to the
/dev/input/event* node of a keyboard.

Input for a tty goes through the flip buffer of its port. A driver
inserts the data with tty_insert_flip_*() and then calls
tty_flip_buffer_push() to pass it on to the line discipline. The insert
functions take no lock: they check that the current struct tty_buffer
has room, copy the data to offset ->used, and then advance ->used. So a
flip buffer supports only one producer at a time, and a driver that has
several must serialise them.

Four functions feed the flip buffer of a virtual console:

- put_queue(), puts_queue() and fn_send_intr() insert typed characters
  and breaks for the keyboard handler. They run under kbd_event_lock.
- respond_string() inserts the reply when a program writes an escape
  sequence that requests one, such as a cursor position report. It runs
  under the console lock.

The keyboard handler gets its events from the input layer and feeds the
foreground console. Key events that a program writes to /dev/uinput or
to an event node reach it in the same way as typed keys.

The keyboard handler and respond_string() share no lock, so they can
interleave:

    keyboard handler                respond_string()
    ================                ================
    room check passes
                                    room check passes
    memcpy() to offset used
    used += len
                                    memcpy() to offset used
                                    used += len
                                      /* used > size of the buffer */

The room check subtracts ->used from the size, and both are unsigned.
Once ->used exceeds the size, the result wraps, so the check always
passes, and each later insert lands further past the buffer.

Reproduced as root, with keys from a uinput keyboard and cursor position
reports on the same console: KFENCE reported an out-of-bounds write
1,024 bytes past the buffer in under 10 s.

Fix this by taking port->lock, with interrupts disabled, around the
insert and the push in these four functions. kbd_keycode() already takes
port->lock under kbd_event_lock, so this lock ordering is not new.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Nicolas Pitre <npitre@baylibre.com>
Cc: Kees Cook <kees+treewide@kernel.org>
Cc: Joshua Rogers <linux@joshua.hu>
Cc: Chris Mason <mason@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Mingyu Wang <25181214217@stu.xidian.edu.cn>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ronan Pigott <ronan@rjp.ie>
Cc: Liav Mordouch <liavmordouch@gmail.com>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20261027-tty-llm-v1-1-99b0202ae546@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/keyboard.c |    6 ++++++
 drivers/tty/vt/vt.c       |    2 ++
 2 files changed, 8 insertions(+)

--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -322,15 +322,20 @@ int kbd_rate(struct kbd_repeat *rpt)
 
 /*
  * Helper Functions.
+ *
+ * A flip buffer allows one producer at a time, and respond_string() in vt.c
+ * feeds the same one under the console lock. So take the lock of the port.
  */
 static void put_queue(struct vc_data *vc, int ch)
 {
+	guard(spinlock_irqsave)(&vc->port.lock);
 	tty_insert_flip_char(&vc->port, ch, 0);
 	tty_flip_buffer_push(&vc->port);
 }
 
 static void puts_queue(struct vc_data *vc, const char *cp)
 {
+	guard(spinlock_irqsave)(&vc->port.lock);
 	tty_insert_flip_string(&vc->port, cp, strlen(cp));
 	tty_flip_buffer_push(&vc->port);
 }
@@ -587,6 +592,7 @@ static void fn_inc_console(struct vc_dat
 
 static void fn_send_intr(struct vc_data *vc)
 {
+	guard(spinlock_irqsave)(&vc->port.lock);
 	tty_insert_flip_char(&vc->port, 0, TTY_BREAK);
 	tty_flip_buffer_push(&vc->port);
 }
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1857,6 +1857,8 @@ static void csi_m(struct vc_data *vc)
 
 static void respond_string(const char *p, size_t len, struct tty_port *port)
 {
+	/* The keyboard handler feeds the same flip buffer. */
+	guard(spinlock_irqsave)(&port->lock);
 	tty_insert_flip_string(port, p, len);
 	tty_flip_buffer_push(port);
 }


