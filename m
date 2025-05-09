Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515B027A93D
	for <patches@lists.linux.dev>; Fri,  9 May 2025 09:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746782401; cv=none; b=SQT3JZx//fCxKnb7aXD+5UKoQK7Zia9rlvoI96HfKx0ZKBz+qU9+xeu5tcs5qg0Bk2Zg7eS2mtQN3KT29tp1R15zXmcyDZtn1W2ubXISXfAqjfd6801Q8QXNvOEAdDLlx29DigOn3BNuEN9wSTo5n/H1EYxmqoO68CahTivcxwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746782401; c=relaxed/simple;
	bh=EMOhec4HskiBdc/01dhCtn++PiZsLN3WyjQfpIewH54=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=H4AhTQm2dtU8hJUFzrpnc/+8hMQPY7mNDqn4ZplMUFpPjr1lXqheSu2/ihIRAG6IrLwz2UdDNJ6uuXp4oBWn9BYJQ8ay+1rdAOw1vwh1LBOZgCaN61Zphfj/uJbdj2bNBwEabI+l8a0mwTP4lJO3mucPzKzNH1RZ3Hy/2W4i1+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54970X2G030883;
	Fri, 9 May 2025 09:19:52 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 46d8c1753b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 09 May 2025 09:19:51 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Fri, 9 May 2025 02:19:50 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Fri, 9 May 2025 02:19:47 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <jianqi.ren.cn@windriver.com>, <penguin-kernel@i-love.sakura.ne.jp>,
        <akpm@linux-foundation.org>, <daniel.starke@siemens.com>,
        <torvalds@linux-foundation.org>
Subject: [PATCH 5.10.y] tty: add the option to have a tty reject a new ldisc
Date: Fri, 9 May 2025 17:19:47 +0800
Message-ID: <20250509091947.3242314-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=NIjV+16g c=1 sm=1 tr=0 ts=681dc8b7 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=py2lGXHgnwZgnTii:21 a=dt9VzEwgFbYA:10 a=edf1wS77AAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=a_U1oVfrAAAA:8
 a=hSkVLCK3AAAA:8 a=ag1SF4gXAAAA:8 a=t7CeM3EgAAAA:8 a=6NjF2_L7S0a423FRwFsA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=HkZW87K1Qel5hWWM3VKY:22 a=cQPPKAXgyycSBL8etih5:22 a=Yupwre4RP9_Eg_Bd0iYG:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: bDTybNtv7NfbLu8vhRSLRWhNGRy8gZQG
X-Proofpoint-ORIG-GUID: bDTybNtv7NfbLu8vhRSLRWhNGRy8gZQG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDA4OSBTYWx0ZWRfX0bteHXWOAlbL EdpnTQRqBSEZE4f9VJiCAPBKT68iRKEG+Ainvm8H1z5r+lzHeRGiFSW0kgqvE4Jvuzcm558u3TQ bJb6jmZg6R32nsfekmJtLckLezG5XLCyxLwQChSXsL719V1QhWNQK7C5v2CLsmy+djdCf2ssqbj
 33Z4wBibMSx570bixPVKjiVQMO+gQtvDizA31bJ9w6Dp3XpYXxXGRkvmVezDs32Lb8Dd9L0S6tq 7Ls1T+XOYUtYc82aP6f9IYWztTiQwcCMsdk8dNkmFW2X9vfhmjTtJTZb3pXLZulgHwkTCLuAAB1 7UPWcYtJEF5rbqTalUmN04wkIppFC69oL81KzhR5i0Skm3ThqgSnwaqdkcwJMeFpakMkwEwsY5Y
 HADkEQm8kyRasPawIUSSWFAelogoA9u+TGMyoR6t5GYu5mHsh4IShvAR1878z/Uhvd3wcTq3
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-09_03,2025-05-08_04,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0
 clxscore=1015 adultscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2505090089

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 6bd23e0c2bb6c65d4f5754d1456bc9a4427fc59b ]

... and use it to limit the virtual terminals to just N_TTY.  They are
kind of special, and in particular, the "con_write()" routine violates
the "writes cannot sleep" rule that some ldiscs rely on.

This avoids the

   BUG: sleeping function called from invalid context at kernel/printk/printk.c:2659

when N_GSM has been attached to a virtual console, and gsmld_write()
calls con_write() while holding a spinlock, and con_write() then tries
to get the console lock.

Tested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Starke <daniel.starke@siemens.com>
Reported-by: syzbot <syzbot+dbac96d8e73b61aa559c@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=dbac96d8e73b61aa559c
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20240423163339.59780-1-torvalds@linux-foundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Minor conflict resolved due to code context change. And also backport description
comments for struct tty_operations.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 drivers/tty/tty_ldisc.c    |   6 +
 drivers/tty/vt/vt.c        |  10 ++
 include/linux/tty_driver.h | 339 +++++++++++++++++++++++++++++++++++++
 3 files changed, 355 insertions(+)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 7262f45b513b..0dae579efdd9 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -579,6 +579,12 @@ int tty_set_ldisc(struct tty_struct *tty, int disc)
 		goto out;
 	}
 
+	if (tty->ops->ldisc_ok) {
+		retval = tty->ops->ldisc_ok(tty, disc);
+		if (retval)
+			goto out;
+	}
+
 	old_ldisc = tty->ldisc;
 
 	/* Shutdown the old discipline. */
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 5d9de3a53548..a772c614a878 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3448,6 +3448,15 @@ static void con_cleanup(struct tty_struct *tty)
 	tty_port_put(&vc->port);
 }
 
+/*
+ * We can't deal with anything but the N_TTY ldisc,
+ * because we can sleep in our write() routine.
+ */
+static int con_ldisc_ok(struct tty_struct *tty, int ldisc)
+{
+	return ldisc == N_TTY ? 0 : -EINVAL;
+}
+
 static int default_color           = 7; /* white */
 static int default_italic_color    = 2; // green (ASCII)
 static int default_underline_color = 3; // cyan (ASCII)
@@ -3576,6 +3585,7 @@ static const struct tty_operations con_ops = {
 	.resize = vt_resize,
 	.shutdown = con_shutdown,
 	.cleanup = con_cleanup,
+	.ldisc_ok = con_ldisc_ok,
 };
 
 static struct cdev vc0_cdev;
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 2f719b471d52..3412eb7280da 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -243,6 +243,344 @@ struct tty_driver;
 struct serial_icounter_struct;
 struct serial_struct;
 
+/**
+ * struct tty_operations -- interface between driver and tty
+ *
+ * @lookup: ``struct tty_struct *()(struct tty_driver *self, struct file *,
+ *				    int idx)``
+ *
+ *	Return the tty device corresponding to @idx, %NULL if there is not
+ *	one currently in use and an %ERR_PTR value on error. Called under
+ *	%tty_mutex (for now!)
+ *
+ *	Optional method. Default behaviour is to use the @self->ttys array.
+ *
+ * @install: ``int ()(struct tty_driver *self, struct tty_struct *tty)``
+ *
+ *	Install a new @tty into the @self's internal tables. Used in
+ *	conjunction with @lookup and @remove methods.
+ *
+ *	Optional method. Default behaviour is to use the @self->ttys array.
+ *
+ * @remove: ``void ()(struct tty_driver *self, struct tty_struct *tty)``
+ *
+ *	Remove a closed @tty from the @self's internal tables. Used in
+ *	conjunction with @lookup and @remove methods.
+ *
+ *	Optional method. Default behaviour is to use the @self->ttys array.
+ *
+ * @open: ``int ()(struct tty_struct *tty, struct file *)``
+ *
+ *	This routine is called when a particular @tty device is opened. This
+ *	routine is mandatory; if this routine is not filled in, the attempted
+ *	open will fail with %ENODEV.
+ *
+ *	Required method. Called with tty lock held. May sleep.
+ *
+ * @close: ``void ()(struct tty_struct *tty, struct file *)``
+ *
+ *	This routine is called when a particular @tty device is closed. At the
+ *	point of return from this call the driver must make no further ldisc
+ *	calls of any kind.
+ *
+ *	Remark: called even if the corresponding @open() failed.
+ *
+ *	Required method. Called with tty lock held. May sleep.
+ *
+ * @shutdown: ``void ()(struct tty_struct *tty)``
+ *
+ *	This routine is called under the tty lock when a particular @tty device
+ *	is closed for the last time. It executes before the @tty resources
+ *	are freed so may execute while another function holds a @tty kref.
+ *
+ * @cleanup: ``void ()(struct tty_struct *tty)``
+ *
+ *	This routine is called asynchronously when a particular @tty device
+ *	is closed for the last time freeing up the resources. This is
+ *	actually the second part of shutdown for routines that might sleep.
+ *
+ * @write: ``int ()(struct tty_struct *tty, const unsigned char *buf,
+ *		    int count)``
+ *
+ *	This routine is called by the kernel to write a series (@count) of
+ *	characters (@buf) to the @tty device. The characters may come from
+ *	user space or kernel space.  This routine will return the
+ *	number of characters actually accepted for writing.
+ *
+ *	May occur in parallel in special cases. Because this includes panic
+ *	paths drivers generally shouldn't try and do clever locking here.
+ *
+ *	Optional: Required for writable devices. May not sleep.
+ *
+ * @put_char: ``int ()(struct tty_struct *tty, unsigned char ch)``
+ *
+ *	This routine is called by the kernel to write a single character @ch to
+ *	the @tty device. If the kernel uses this routine, it must call the
+ *	@flush_chars() routine (if defined) when it is done stuffing characters
+ *	into the driver. If there is no room in the queue, the character is
+ *	ignored.
+ *
+ *	Optional: Kernel will use the @write method if not provided. Do not
+ *	call this function directly, call tty_put_char().
+ *
+ * @flush_chars: ``void ()(struct tty_struct *tty)``
+ *
+ *	This routine is called by the kernel after it has written a
+ *	series of characters to the tty device using @put_char().
+ *
+ *	Optional. Do not call this function directly, call
+ *	tty_driver_flush_chars().
+ *
+ * @write_room: ``int ()(struct tty_struct *tty)``
+ *
+ *	This routine returns the numbers of characters the @tty driver
+ *	will accept for queuing to be written.  This number is subject
+ *	to change as output buffers get emptied, or if the output flow
+ *	control is acted.
+ *
+ *	The ldisc is responsible for being intelligent about multi-threading of
+ *	write_room/write calls
+ *
+ *	Required if @write method is provided else not needed. Do not call this
+ *	function directly, call tty_write_room()
+ *
+ * @chars_in_buffer: ``int ()(struct tty_struct *tty)``
+ *
+ *	This routine returns the number of characters in the device private
+ *	output queue. Used in tty_wait_until_sent() and for poll()
+ *	implementation.
+ *
+ *	Optional: if not provided, it is assumed there is no queue on the
+ *	device. Do not call this function directly, call tty_chars_in_buffer().
+ *
+ * @ioctl: ``int ()(struct tty_struct *tty, unsigned int cmd,
+ *		    unsigned long arg)``
+ *
+ *	This routine allows the @tty driver to implement device-specific
+ *	ioctls. If the ioctl number passed in @cmd is not recognized by the
+ *	driver, it should return %ENOIOCTLCMD.
+ *
+ *	Optional.
+ *
+ * @compat_ioctl: ``long ()(struct tty_struct *tty, unsigned int cmd,
+ *			  unsigned long arg)``
+ *
+ *	Implement ioctl processing for 32 bit process on 64 bit system.
+ *
+ *	Optional.
+ *
+ * @set_termios: ``void ()(struct tty_struct *tty, struct ktermios *old)``
+ *
+ *	This routine allows the @tty driver to be notified when device's
+ *	termios settings have changed. New settings are in @tty->termios.
+ *	Previous settings are passed in the @old argument.
+ *
+ *	The API is defined such that the driver should return the actual modes
+ *	selected. This means that the driver is responsible for modifying any
+ *	bits in @tty->termios it cannot fulfill to indicate the actual modes
+ *	being used.
+ *
+ *	Optional. Called under the @tty->termios_rwsem. May sleep.
+ *
+ * @ldisc_ok: ``int ()(struct tty_struct *tty, int ldisc)``
+ *
+ *	This routine allows the @tty driver to decide if it can deal
+ *	with a particular @ldisc.
+ *
+ *	Optional. Called under the @tty->ldisc_sem and @tty->termios_rwsem.
+ *
+ * @set_ldisc: ``void ()(struct tty_struct *tty)``
+ *
+ *	This routine allows the @tty driver to be notified when the device's
+ *	line discipline is being changed. At the point this is done the
+ *	discipline is not yet usable.
+ *
+ *	Optional. Called under the @tty->ldisc_sem and @tty->termios_rwsem.
+ *
+ * @throttle: ``void ()(struct tty_struct *tty)``
+ *
+ *	This routine notifies the @tty driver that input buffers for the line
+ *	discipline are close to full, and it should somehow signal that no more
+ *	characters should be sent to the @tty.
+ *
+ *	Serialization including with @unthrottle() is the job of the ldisc
+ *	layer.
+ *
+ *	Optional: Always invoke via tty_throttle_safe(). Called under the
+ *	@tty->termios_rwsem.
+ *
+ * @unthrottle: ``void ()(struct tty_struct *tty)``
+ *
+ *	This routine notifies the @tty driver that it should signal that
+ *	characters can now be sent to the @tty without fear of overrunning the
+ *	input buffers of the line disciplines.
+ *
+ *	Optional. Always invoke via tty_unthrottle(). Called under the
+ *	@tty->termios_rwsem.
+ *
+ * @stop: ``void ()(struct tty_struct *tty)``
+ *
+ *	This routine notifies the @tty driver that it should stop outputting
+ *	characters to the tty device.
+ *
+ *	Called with @tty->flow.lock held. Serialized with @start() method.
+ *
+ *	Optional. Always invoke via stop_tty().
+ *
+ * @start: ``void ()(struct tty_struct *tty)``
+ *
+ *	This routine notifies the @tty driver that it resumed sending
+ *	characters to the @tty device.
+ *
+ *	Called with @tty->flow.lock held. Serialized with stop() method.
+ *
+ *	Optional. Always invoke via start_tty().
+ *
+ * @hangup: ``void ()(struct tty_struct *tty)``
+ *
+ *	This routine notifies the @tty driver that it should hang up the @tty
+ *	device.
+ *
+ *	Optional. Called with tty lock held.
+ *
+ * @break_ctl: ``int ()(struct tty_struct *tty, int state)``
+ *
+ *	This optional routine requests the @tty driver to turn on or off BREAK
+ *	status on the RS-232 port. If @state is -1, then the BREAK status
+ *	should be turned on; if @state is 0, then BREAK should be turned off.
+ *
+ *	If this routine is implemented, the high-level tty driver will handle
+ *	the following ioctls: %TCSBRK, %TCSBRKP, %TIOCSBRK, %TIOCCBRK.
+ *
+ *	If the driver sets %TTY_DRIVER_HARDWARE_BREAK in tty_alloc_driver(),
+ *	then the interface will also be called with actual times and the
+ *	hardware is expected to do the delay work itself. 0 and -1 are still
+ *	used for on/off.
+ *
+ *	Optional: Required for %TCSBRK/%BRKP/etc. handling. May sleep.
+ *
+ * @flush_buffer: ``void ()(struct tty_struct *tty)``
+ *
+ *	This routine discards device private output buffer. Invoked on close,
+ *	hangup, to implement %TCOFLUSH ioctl and similar.
+ *
+ *	Optional: if not provided, it is assumed there is no queue on the
+ *	device. Do not call this function directly, call
+ *	tty_driver_flush_buffer().
+ *
+ * @wait_until_sent: ``void ()(struct tty_struct *tty, int timeout)``
+ *
+ *	This routine waits until the device has written out all of the
+ *	characters in its transmitter FIFO. Or until @timeout (in jiffies) is
+ *	reached.
+ *
+ *	Optional: If not provided, the device is assumed to have no FIFO.
+ *	Usually correct to invoke via tty_wait_until_sent(). May sleep.
+ *
+ * @send_xchar: ``void ()(struct tty_struct *tty, char ch)``
+ *
+ *	This routine is used to send a high-priority XON/XOFF character (@ch)
+ *	to the @tty device.
+ *
+ *	Optional: If not provided, then the @write method is called under
+ *	the @tty->atomic_write_lock to keep it serialized with the ldisc.
+ *
+ * @tiocmget: ``int ()(struct tty_struct *tty)``
+ *
+ *	This routine is used to obtain the modem status bits from the @tty
+ *	driver.
+ *
+ *	Optional: If not provided, then %ENOTTY is returned from the %TIOCMGET
+ *	ioctl. Do not call this function directly, call tty_tiocmget().
+ *
+ * @tiocmset: ``int ()(struct tty_struct *tty,
+ *		       unsigned int set, unsigned int clear)``
+ *
+ *	This routine is used to set the modem status bits to the @tty driver.
+ *	First, @clear bits should be cleared, then @set bits set.
+ *
+ *	Optional: If not provided, then %ENOTTY is returned from the %TIOCMSET
+ *	ioctl. Do not call this function directly, call tty_tiocmset().
+ *
+ * @resize: ``int ()(struct tty_struct *tty, struct winsize *ws)``
+ *
+ *	Called when a termios request is issued which changes the requested
+ *	terminal geometry to @ws.
+ *
+ *	Optional: the default action is to update the termios structure
+ *	without error. This is usually the correct behaviour. Drivers should
+ *	not force errors here if they are not resizable objects (e.g. a serial
+ *	line). See tty_do_resize() if you need to wrap the standard method
+ *	in your own logic -- the usual case.
+ *
+ * @get_icount: ``int ()(struct tty_struct *tty,
+ *			 struct serial_icounter *icount)``
+ *
+ *	Called when the @tty device receives a %TIOCGICOUNT ioctl. Passed a
+ *	kernel structure @icount to complete.
+ *
+ *	Optional: called only if provided, otherwise %ENOTTY will be returned.
+ *
+ * @get_serial: ``int ()(struct tty_struct *tty, struct serial_struct *p)``
+ *
+ *	Called when the @tty device receives a %TIOCGSERIAL ioctl. Passed a
+ *	kernel structure @p (&struct serial_struct) to complete.
+ *
+ *	Optional: called only if provided, otherwise %ENOTTY will be returned.
+ *	Do not call this function directly, call tty_tiocgserial().
+ *
+ * @set_serial: ``int ()(struct tty_struct *tty, struct serial_struct *p)``
+ *
+ *	Called when the @tty device receives a %TIOCSSERIAL ioctl. Passed a
+ *	kernel structure @p (&struct serial_struct) to set the values from.
+ *
+ *	Optional: called only if provided, otherwise %ENOTTY will be returned.
+ *	Do not call this function directly, call tty_tiocsserial().
+ *
+ * @show_fdinfo: ``void ()(struct tty_struct *tty, struct seq_file *m)``
+ *
+ *	Called when the @tty device file descriptor receives a fdinfo request
+ *	from VFS (to show in /proc/<pid>/fdinfo/). @m should be filled with
+ *	information.
+ *
+ *	Optional: called only if provided, otherwise nothing is written to @m.
+ *	Do not call this function directly, call tty_show_fdinfo().
+ *
+ * @poll_init: ``int ()(struct tty_driver *driver, int line, char *options)``
+ *
+ *	kgdboc support (Documentation/dev-tools/kgdb.rst). This routine is
+ *	called to initialize the HW for later use by calling @poll_get_char or
+ *	@poll_put_char.
+ *
+ *	Optional: called only if provided, otherwise skipped as a non-polling
+ *	driver.
+ *
+ * @poll_get_char: ``int ()(struct tty_driver *driver, int line)``
+ *
+ *	kgdboc support (see @poll_init). @driver should read a character from a
+ *	tty identified by @line and return it.
+ *
+ *	Optional: called only if @poll_init provided.
+ *
+ * @poll_put_char: ``void ()(struct tty_driver *driver, int line, char ch)``
+ *
+ *	kgdboc support (see @poll_init). @driver should write character @ch to
+ *	a tty identified by @line.
+ *
+ *	Optional: called only if @poll_init provided.
+ *
+ * @proc_show: ``int ()(struct seq_file *m, void *driver)``
+ *
+ *	Driver @driver (cast to &struct tty_driver) can show additional info in
+ *	/proc/tty/driver/<driver_name>. It is enough to fill in the information
+ *	into @m.
+ *
+ *	Optional: called only if provided, otherwise no /proc entry created.
+ *
+ * This structure defines the interface between the low-level tty driver and
+ * the tty routines. These routines can be defined. Unless noted otherwise,
+ * they are optional, and can be filled in with a %NULL pointer.
+ */
 struct tty_operations {
 	struct tty_struct * (*lookup)(struct tty_driver *driver,
 			struct file *filp, int idx);
@@ -270,6 +608,7 @@ struct tty_operations {
 	void (*hangup)(struct tty_struct *tty);
 	int (*break_ctl)(struct tty_struct *tty, int state);
 	void (*flush_buffer)(struct tty_struct *tty);
+	int (*ldisc_ok)(struct tty_struct *tty, int ldisc);
 	void (*set_ldisc)(struct tty_struct *tty);
 	void (*wait_until_sent)(struct tty_struct *tty, int timeout);
 	void (*send_xchar)(struct tty_struct *tty, char ch);
-- 
2.34.1

