Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043181;
	b=HrwIo9HBFGjvkHqWoX4aBOlduxDUYYPBswr7sRzBrYAoECiYGy8UUOPgA4Z2GLzjkjPd
	 vLJP0VPzqLrSc1Mhhyxr3W9vnkxdGDCo615iU4U1iLOrHMtc8KvnTS9gKBJTt3E8A5qCe
	 Zfwg2LIY5LXz0STb9L7bFPMJGWKw9I+f73mCSgvFIZYI3xTGi6SbW4o5MAFXpkn3z16GP
	 LS9ys4Do24p0GqUKRUA3cZCfXz1jewxHjg3KHUXNFXrcxXDoNN3mT4gsn54d8EFNRz6bS
	 6N83r7y366MOb6c/P6XufOxh4iy2ymeK/XhVG6Fjfu/K0R2SGWcHoGNTYCPAtmfweOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Avy8vrz2ypO57BJo0dj8VqyMqDpxwzQoZM8XIoF1KZg=;
	b=BIXa1q2icWp+nvPteJCgGTcdRbZXsBP4z5+JuNo2v5Bb5p7FZ1OJYxaGw2BBjY8isCHv
	 msRbGJ0+216in2A2p19xZlT6TqbBuizBJDu7kBiYWMqL0hMsQUkfx3m1yzai4o//5kPIh
	 kLi9COGwCijlN/P5UdgXo8DAXBQjfnPnD87ic9M1Eb+dt6p6y22XM6R3gDtLhIRlXZEuT
	 OFjVPIGVR836eo/B5Z8jAuC93ZANi6RIYsU0Wz3lyQh2iVjEGAn5crnA2YST9KOtVGI0Q
	 pGXqC3SX+WUhTzUHo4y21n4wtzbdI0U56ip7gAKRnWqegPJE9fh7R9iamS//QrQMqwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l32VHDYe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0562F606A31C;
	Wed, 18 Nov 2026 23:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l32VHDYe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAAF1F000C5;
	Wed, 18 Nov 2026 23:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043180;
	bh=Avy8vrz2ypO57BJo0dj8VqyMqDpxwzQoZM8XIoF1KZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l32VHDYefOLrGnIH50pIGkEjngZqrFiQNlRFNCG1us8sXy0KXBm0UI6oLWOKPH79S
	 RqztpT9bsD5SYVareWBYXaTMQY1ZiaiFQqt2HFwjDT9z0+0SJXjz462vU+O89yC1Ff
	 REfCKVAdOBQLcbWdRL1gRPALM3mzMuO8faJIiPSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0120/2857] ipack: ipoctal: add rwsem to guard against TOCTOU in remove path
Date: Wed, 18 Nov 2026 15:19:14 +0100
Message-ID: <20261118150205.676046752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 7d3a708af7f4e2af9e114d731bd60d30c1ec884e ]

The "removed" flag check in each tty op has a TOCTOU race with
__ipoctal_remove(): the device could be removed between the flag
check and the subsequent access to hardware resources (channel
registers via iowrite8, or xmit_buf in write_tty).

Close this race by introducing a read-write semaphore (remove_sem).
The tty ops acquire the read lock via guard(rwsem_read) for the
full duration of the operation, while __ipoctal_remove() acquires
the write lock via scoped_guard(rwsem_write) when setting the
removed flag.  This ensures that once removed is true, no in-flight
tty op can still be accessing resources that are about to be freed
by the remove path.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://patch.msgid.link/fbce75010a0f0a3a3709a5e06fd0ffd19ca0a0ed.1782870760.git.xiaopei01@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ipack/devices/ipoctal.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 28cd550200154..215afae6e79e7 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/kref.h>
+#include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/serial.h>
@@ -54,6 +55,7 @@ struct ipoctal {
 	u8 __iomem			*int_space;
 	struct kref			kref;
 	struct module			*carrier_owner;
+	struct rw_semaphore		remove_sem;
 	bool				removed;
 };
 
@@ -81,7 +83,7 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 	channel = dev_get_drvdata(tty->dev);
 	ipoctal = chan_to_ipoctal(channel, tty->index);
 
-
+	guard(rwsem_read)(&ipoctal->remove_sem);
 	if (ipoctal->removed)
 		return -ENODEV;
 
@@ -475,7 +477,7 @@ static int ipoctal_write_tty(struct tty_struct *tty, const u8 *buf, int count)
 	struct ipoctal *ipoctal = chan_to_ipoctal(channel, tty->index);
 	size_t char_copied;
 
-
+	guard(rwsem_read)(&ipoctal->remove_sem);
 	if (ipoctal->removed || !channel->tty_port.xmit_buf)
 		return 0;
 
@@ -521,7 +523,7 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 	struct ipoctal *ipoctal = chan_to_ipoctal(channel, tty->index);
 	speed_t baud;
 
-
+	guard(rwsem_read)(&ipoctal->remove_sem);
 	if (ipoctal->removed)
 		return;
 
@@ -659,7 +661,7 @@ static void ipoctal_hangup(struct tty_struct *tty)
 		return;
 
 	ipoctal = chan_to_ipoctal(channel, tty->index);
-
+	guard(rwsem_read)(&ipoctal->remove_sem);
 	if (ipoctal->removed)
 		return;
 
@@ -685,7 +687,7 @@ static void ipoctal_shutdown(struct tty_struct *tty)
 		return;
 
 	ipoctal = chan_to_ipoctal(channel, tty->index);
-
+	guard(rwsem_read)(&ipoctal->remove_sem);
 	if (ipoctal->removed)
 		return;
 
@@ -735,6 +737,7 @@ static int ipoctal_probe(struct ipack_device *dev)
 		return -ENOMEM;
 
 	kref_init(&ipoctal->kref);
+	init_rwsem(&ipoctal->remove_sem);
 
 	ipoctal->dev = dev;
 	ipoctal->carrier_owner = dev->bus->owner;
@@ -754,7 +757,8 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 {
 	int i;
 
-	ipoctal->removed = true;
+	scoped_guard(rwsem_write, &ipoctal->remove_sem)
+		ipoctal->removed = true;
 
 	ipoctal->dev->bus->ops->free_irq(ipoctal->dev);
 
-- 
2.53.0



