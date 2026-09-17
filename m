Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D717B433AD;
	Thu, 17 Sep 2026 17:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665376; cv=none; b=nRLme2C5U6DgOM7nStx+3P2S1h9wiqzz1TQSS3XRx4RqAuybJlsC1SukBEUdBxdW8LjEmPwo5MSDV85mcusYFHZfUvm17HEA4sXrUdSvwsIoCQpwrCQEZdbs8Ks86YZBTSVRH4GWJiT2cVwLhUtOO3uNjbsLc7e6BaLYkRAdyHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665376; c=relaxed/simple;
	bh=5ez1YarInoUZCpu9uhdJDhnVGl7TmbqDAA+3V6Pp7uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMQVAuRXtfMUfPLtU+iLP17mzFOj1BLsMfdTxJYYmpQFKhKG6m9V1WyuIAyqnEedsRyGZZXNEWbd1u7U/zjb+fQr/JZLsALCpBOJ8x27pywf5acB8nzJue8s/QfVjCPK9Wmm1dugtR0KbhjPAlQYUOaIRpT5Vjd3/QuswIiMNrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYsSEurC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYsSEurC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4C81F000FF;
	Thu, 17 Sep 2026 17:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665374;
	bh=iD03CTg0sCdiMKoEfWIDfYkgsqLj9lW6O6D/XS8hNTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sYsSEurCUgx+Lf8CH5Ficp0q/UMWtfLhMPWvTwnqn5WWki0b6QWCK3GfarnJS3YgG
	 ky8DySRZMwnmzKsUFQQgoxPNgwHT0NluGFgkyKFySTvV7KXJ/Y8uQlBNtqPTjLzrrC
	 tN7ObO5CQtyu1aTAi/S3l/H0Uo2cATLVPTIwQ6us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b503105c2410c3433459@syzkaller.appspotmail.com,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0683/1250] ppp: ppp_synctty: simplify tty disc_data access
Date: Thu, 17 Sep 2026 16:07:58 +0100
Message-ID: <20260917151610.398637029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit d8d4d1cf40d541a5d7cc3b15d57e42d0815c7d53 ]

Apply the same simplification as the preceding ppp_async change.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+b503105c2410c3433459@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=b503105c2410c3433459
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260828073245.126804-2-qingfang.deng@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_synctty.c | 83 +++--------------------------------
 1 file changed, 7 insertions(+), 76 deletions(-)

diff --git a/drivers/net/ppp/ppp_synctty.c b/drivers/net/ppp/ppp_synctty.c
index 9c4932198931f..1a1eb029a531b 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -38,11 +38,9 @@
 #include <linux/ppp-ioctl.h>
 #include <linux/ppp_channel.h>
 #include <linux/spinlock.h>
-#include <linux/completion.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
-#include <linux/refcount.h>
 #include <linux/unaligned.h>
 #include <linux/uaccess.h>
 
@@ -69,8 +67,6 @@ struct syncppp {
 
 	struct tasklet_struct tsk;
 
-	refcount_t	refcnt;
-	struct completion dead_cmp;
 	struct ppp_channel chan;	/* interface to generic ppp layer */
 };
 
@@ -118,37 +114,6 @@ ppp_print_buffer (const char *name, const __u8 *buf, int count)
  * Routines implementing the synchronous PPP line discipline.
  */
 
-/*
- * We have a potential race on dereferencing tty->disc_data,
- * because the tty layer provides no locking at all - thus one
- * cpu could be running ppp_synctty_receive while another
- * calls ppp_synctty_close, which zeroes tty->disc_data and
- * frees the memory that ppp_synctty_receive is using.  The best
- * way to fix this is to use a rwlock in the tty struct, but for now
- * we use a single global rwlock for all ttys in ppp line discipline.
- *
- * FIXME: Fixed in tty_io nowadays.
- */
-static DEFINE_RWLOCK(disc_data_lock);
-
-static struct syncppp *sp_get(struct tty_struct *tty)
-{
-	struct syncppp *ap;
-
-	read_lock(&disc_data_lock);
-	ap = tty->disc_data;
-	if (ap != NULL)
-		refcount_inc(&ap->refcnt);
-	read_unlock(&disc_data_lock);
-	return ap;
-}
-
-static void sp_put(struct syncppp *ap)
-{
-	if (refcount_dec_and_test(&ap->refcnt))
-		complete(&ap->dead_cmp);
-}
-
 /*
  * Called when a tty is put into sync-PPP line discipline.
  */
@@ -179,9 +144,6 @@ ppp_sync_open(struct tty_struct *tty)
 	skb_queue_head_init(&ap->rqueue);
 	tasklet_setup(&ap->tsk, ppp_sync_process);
 
-	refcount_set(&ap->refcnt, 1);
-	init_completion(&ap->dead_cmp);
-
 	ap->chan.private = ap;
 	ap->chan.ops = &sync_ops;
 	ap->chan.mtu = PPP_MRU;
@@ -203,34 +165,18 @@ ppp_sync_open(struct tty_struct *tty)
 }
 
 /*
- * Called when the tty is put into another line discipline
- * or it hangs up.  We have to wait for any cpu currently
- * executing in any of the other ppp_synctty_* routines to
- * finish before we can call ppp_unregister_channel and free
- * the syncppp struct.  This routine must be called from
- * process context, not interrupt or softirq context.
+ * Called when the tty is put into another line discipline or it hangs up.
+ * This call is serialized against other ldisc functions.
  */
 static void
 ppp_sync_close(struct tty_struct *tty)
 {
-	struct syncppp *ap;
+	struct syncppp *ap = tty->disc_data;
 
-	write_lock_irq(&disc_data_lock);
-	ap = tty->disc_data;
-	tty->disc_data = NULL;
-	write_unlock_irq(&disc_data_lock);
 	if (!ap)
 		return;
 
-	/*
-	 * We have now ensured that nobody can start using ap from now
-	 * on, but we have to wait for all existing users to finish.
-	 * Note that ppp_unregister_channel ensures that no calls to
-	 * our channel ops (i.e. ppp_sync_send/ioctl) are in progress
-	 * by the time it returns.
-	 */
-	if (!refcount_dec_and_test(&ap->refcnt))
-		wait_for_completion(&ap->dead_cmp);
+	tty->disc_data = NULL;
 	tasklet_kill(&ap->tsk);
 
 	ppp_unregister_channel(&ap->chan);
@@ -239,17 +185,6 @@ ppp_sync_close(struct tty_struct *tty)
 	kfree(ap);
 }
 
-/*
- * Called on tty hangup in process context.
- *
- * Wait for I/O to driver to complete and unregister PPP channel.
- * This is already done by the close routine, so just call that.
- */
-static void ppp_sync_hangup(struct tty_struct *tty)
-{
-	ppp_sync_close(tty);
-}
-
 /*
  * Read does nothing - no data is ever available this way.
  * Pppd reads and writes packets via /dev/ppp instead.
@@ -275,7 +210,7 @@ ppp_sync_write(struct tty_struct *tty, struct file *file, const u8 *buf,
 static int
 ppp_synctty_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 {
-	struct syncppp *ap = sp_get(tty);
+	struct syncppp *ap = tty->disc_data;
 	int __user *p = (int __user *)arg;
 	int err, val;
 
@@ -316,7 +251,6 @@ ppp_synctty_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 		break;
 	}
 
-	sp_put(ap);
 	return err;
 }
 
@@ -325,7 +259,7 @@ static void
 ppp_sync_receive(struct tty_struct *tty, const u8 *buf, const u8 *cflags,
 		 size_t count)
 {
-	struct syncppp *ap = sp_get(tty);
+	struct syncppp *ap = tty->disc_data;
 	unsigned long flags;
 
 	if (!ap)
@@ -335,21 +269,19 @@ ppp_sync_receive(struct tty_struct *tty, const u8 *buf, const u8 *cflags,
 	spin_unlock_irqrestore(&ap->recv_lock, flags);
 	if (!skb_queue_empty(&ap->rqueue))
 		tasklet_schedule(&ap->tsk);
-	sp_put(ap);
 	tty_unthrottle(tty);
 }
 
 static void
 ppp_sync_wakeup(struct tty_struct *tty)
 {
-	struct syncppp *ap = sp_get(tty);
+	struct syncppp *ap = tty->disc_data;
 
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 	if (!ap)
 		return;
 	set_bit(XMIT_WAKEUP, &ap->xmit_flags);
 	tasklet_schedule(&ap->tsk);
-	sp_put(ap);
 }
 
 
@@ -359,7 +291,6 @@ static struct tty_ldisc_ops ppp_sync_ldisc = {
 	.name	= "pppsync",
 	.open	= ppp_sync_open,
 	.close	= ppp_sync_close,
-	.hangup	= ppp_sync_hangup,
 	.read	= ppp_sync_read,
 	.write	= ppp_sync_write,
 	.ioctl	= ppp_synctty_ioctl,
-- 
2.53.0



