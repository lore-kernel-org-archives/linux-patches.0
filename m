Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211661;
	b=StkP71kpFpZRMMvSArXkwoOkJonAUnUqAP8URVHhZYFJgbb1asBBDi+EDDizi7+nVwed
	 mpfFJkki8dzkGFAIgqAbxiJkxr2nUpYWN401vJR/UWQ5CS3eBYmn/ZCEjGxitih+cdfYo
	 tmjD15vEkcaqDIoO6ln0teJvGckSX5/itMjlq/CsL+UUYAnBDI8YPxSAUIcYuuhrFxS8H
	 7teV9MnDZnBGaZ6a8n/qw/LR93YlnQNSklJZganZ7fMJZmQzCwmPoX4SYQ/K6qi+FEMo4
	 s9e09KH2TvlN6HR3OabtCmORXDK+F1oj0zZt7l7P8hBYkz4n4J0URQTsvMuJunC3OUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LqoRdeQ/GrS8FWzLzzEZcUdEmFFGOTYzvmv2XN44J8c=;
	b=puJEbZ4It8BKK+10T+tgbGkGOig4Pv0RqAP0vWF0XeuJCEP8Tstx7A0efRzTkVJW7mHa
	 p2Q9M0osFdf0xGZLFkrQlDWgugcEDzpbiOV/RiU3kZQ+kxO/IvnG6Ytp9YHbujndvbPWk
	 qPYTTYKWFQfrZdGybwcjALZEZXDRhntAKv+XQBNEVzXTfN2pYAVMxrfpm9A47cQ4nDSiT
	 3Ewf3OjAG2fjIjs5aD1vSbR3G03G/dUuCstarMk1e7hzJPgoJgKj3/5QuCOX1Ars4N2Qy
	 SnIta1mxxqkkaEkaVLb5lUFveevx/XVvFZgmY5y4qkk8v3YBdeqUVoBv2z0eppeVCCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VK46EpZG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D40606A31D;
	Wed, 28 Oct 2026 18:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VK46EpZG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB681F01825;
	Wed, 28 Oct 2026 18:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211660;
	bh=LqoRdeQ/GrS8FWzLzzEZcUdEmFFGOTYzvmv2XN44J8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VK46EpZGT2xpJQ2EiDGCjQxHLUKURS6xX13pvtW0wBcPr4DSG5XNFx8mUWu4f2s/K
	 SksyiCpv2hq87ciq2vxQG6tkfaJEvrRfZbYDtGKQnW6J7FVjROzn+sy/ZR4jo+fVAU
	 iDtulflwOleS6RFAdwfQrI8ENqf6jq7ygFXLFZ/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jslaby@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 454/571] tty: finish kernel-doc of tty_struct members
Date: Wed, 28 Oct 2026 18:00:01 +0100
Message-ID: <20261028170018.799500258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit 18e6c0751cf9ae0631a2623e31af2bf504f72c30 ]

There are already pieces of kernel-doc documentation for struct
tty_struct in tty.h. Finish the documentation for the members which were
undocumented yet.

It also includes tuning the already existing pieces like flow and ctrl,
especially adding highlights to them.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20211126081611.11001-2-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 5dad87615c98 ("tty: add break_wait kernel-doc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tty.h | 79 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 15 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 9501a8640baa8..b1a626978efdc 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -122,33 +122,84 @@ struct tty_operations;
 /**
  * struct tty_struct - state associated with a tty while open
  *
- * @flow.lock: lock for flow members
- * @flow.stopped: tty stopped/started by tty_stop/tty_start
- * @flow.tco_stopped: tty stopped/started by TCOOFF/TCOON ioctls (it has
- *		      precedense over @flow.stopped)
+ * @magic: magic value set early in @alloc_tty_struct to %TTY_MAGIC, for
+ *	   debugging purposes
+ * @kref: reference counting by tty_kref_get() and tty_kref_put(), reaching zero
+ *	  frees the structure
+ * @dev: class device or %NULL (e.g. ptys, serdev)
+ * @driver: &struct tty_driver operating this tty
+ * @ops: &struct tty_operations of @driver for this tty (open, close, etc.)
+ * @index: index of this tty (e.g. to construct @name like tty12)
+ * @ldisc_sem: protects line discipline changes (@ldisc) -- lock tty not pty
+ * @ldisc: the current line discipline for this tty (n_tty by default)
+ * @atomic_write_lock: protects against concurrent writers, i.e. locks
+ *		       @write_cnt, @write_buf and similar
+ * @legacy_mutex: leftover from history (BKL -> BTM -> @legacy_mutex),
+ *		  protecting several operations on this tty
+ * @throttle_mutex: protects against concurrent tty_throttle_safe() and
+ *		    tty_unthrottle_safe() (but not tty_unthrottle())
+ * @termios_rwsem: protects @termios and @termios_locked
+ * @winsize_mutex: protects @winsize
+ * @termios: termios for the current tty, copied from/to @driver.termios
+ * @termios_locked: locked termios (by %TIOCGLCKTRMIOS and %TIOCSLCKTRMIOS
+ *		    ioctls)
+ * @name: name of the tty constructed by tty_line_name() (e.g. ttyS3)
+ * @flags: bitwise OR of %TTY_THROTTLED, %TTY_IO_ERROR, ...
+ * @count: count of open processes, reaching zero cancels all the work for
+ *	   this tty and drops a @kref too (but does not free this tty)
+ * @winsize: size of the terminal "window" (cf. @winsize_mutex)
+ * @flow: flow settings grouped together, see also @flow.unused
+ * @flow.lock: lock for @flow members
+ * @flow.stopped: tty stopped/started by stop_tty()/start_tty()
+ * @flow.tco_stopped: tty stopped/started by %TCOOFF/%TCOON ioctls (it has
+ *		      precedence over @flow.stopped)
  * @flow.unused: alignment for Alpha, so that no members other than @flow.* are
  *		 modified by the same 64b word store. The @flow's __aligned is
  *		 there for the very same reason.
- * @ctrl.lock: lock for ctrl members
+ * @ctrl: control settings grouped together, see also @ctrl.unused
+ * @ctrl.lock: lock for @ctrl members
  * @ctrl.pgrp: process group of this tty (setpgrp(2))
  * @ctrl.session: session of this tty (setsid(2)). Writes are protected by both
- *		  @ctrl.lock and legacy mutex, readers must use at least one of
+ *		  @ctrl.lock and @legacy_mutex, readers must use at least one of
  *		  them.
- * @ctrl.pktstatus: packet mode status (bitwise OR of TIOCPKT_* constants)
+ * @ctrl.pktstatus: packet mode status (bitwise OR of %TIOCPKT_ constants)
  * @ctrl.packet: packet mode enabled
+ * @ctrl.unused: alignment for Alpha, see @flow.unused for explanation
+ * @hw_stopped: not controlled by the tty layer, under @driver's control for CTS
+ *		handling
+ * @receive_room: bytes permitted to feed to @ldisc without any being lost
+ * @flow_change: controls behavior of throttling, see tty_throttle_safe() and
+ *		 tty_unthrottle_safe()
+ * @link: link to another pty (master -> slave and vice versa)
+ * @fasync: state for %O_ASYNC (for %SIGIO); managed by fasync_helper()
+ * @write_wait: concurrent writers are waiting in this queue until they are
+ *		allowed to write
+ * @read_wait: readers wait for data in this queue
+ * @hangup_work: normally a work to perform a hangup (do_tty_hangup()); while
+ *		 freeing the tty, (re)used to release_one_tty()
+ * @disc_data: pointer to @ldisc's private data (e.g. to &struct n_tty_data)
+ * @driver_data: pointer to @driver's private data (e.g. &struct uart_state)
+ * @files_lock:	protects @tty_files list
+ * @tty_files: list of (re)openers of this tty (i.e. linked &struct
+ *	       tty_file_private)
+ * @closing: when set during close, n_tty processes only START & STOP chars
+ * @write_buf: temporary buffer used during tty_write() to copy user data to
+ * @write_cnt: count of bytes written in tty_write() to @write_buf
+ * @SAK_work: if the tty has a pending do_SAK, it is queued here
+ * @port: persistent storage for this device (i.e. &struct tty_port)
  *
  * All of the state associated with a tty while the tty is open. Persistent
- * storage for tty devices is referenced here as @port in struct tty_port.
+ * storage for tty devices is referenced here as @port and is documented in
+ * &struct tty_port.
  */
 struct tty_struct {
 	int	magic;
 	struct kref kref;
-	struct device *dev;	/* class device or NULL (e.g. ptys, serdev) */
+	struct device *dev;
 	struct tty_driver *driver;
 	const struct tty_operations *ops;
 	int index;
 
-	/* Protects ldisc changes: Lock tty not pty */
 	struct ld_semaphore ldisc_sem;
 	struct tty_ldisc *ldisc;
 
@@ -157,12 +208,11 @@ struct tty_struct {
 	struct mutex throttle_mutex;
 	struct rw_semaphore termios_rwsem;
 	struct mutex winsize_mutex;
-	/* Termios values are protected by the termios rwsem */
 	struct ktermios termios, termios_locked;
 	char name[64];
 	unsigned long flags;
 	int count;
-	struct winsize winsize;		/* winsize_mutex */
+	struct winsize winsize;
 
 	struct {
 		spinlock_t lock;
@@ -181,7 +231,7 @@ struct tty_struct {
 	} __aligned(sizeof(unsigned long)) ctrl;
 
 	int hw_stopped;
-	unsigned int receive_room;	/* Bytes free for queue */
+	unsigned int receive_room;
 	int flow_change;
 
 	struct tty_struct *link;
@@ -192,7 +242,7 @@ struct tty_struct {
 	struct work_struct hangup_work;
 	void *disc_data;
 	void *driver_data;
-	spinlock_t files_lock;		/* protects tty_files list */
+	spinlock_t files_lock;
 	struct list_head tty_files;
 
 #define N_TTY_BUF_SIZE 4096
@@ -200,7 +250,6 @@ struct tty_struct {
 	int closing;
 	unsigned char *write_buf;
 	int write_cnt;
-	/* If the tty has a pending do_SAK, queue it here - akpm */
 	struct work_struct SAK_work;
 	struct tty_port *port;
 } __randomize_layout;
-- 
2.53.0



