Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215256;
	b=VeZW2qA9Fpz3PKNcOGt02ZRMkKAesR3+P3+Z0CCFKuQHDtRyLeZ7Y9t6acJG29zk+JEF
	 dtB6fm8h+mV2eGwMiJiJox9vqonazpWjYjkG21/QfNkawia/qqVffkwQ4lV4vD7S7ynBb
	 Cik4OQz78uFv7cdRaYfHSOLHMKMFpvnbH/Q2QKwWnZW8hfkF8bf+CMsNAWSVTx7TZllPh
	 pdCkOxcmO2LpBN/R7bFq8TALHkhSTXy2U/wyVoIPu5qFQWo4bSWLvnYYM/NVDLsO6JkLb
	 6rdZZqj7cGT1KTbviMLuBqfBIbd3kQ4kELr/W4amC5RKEI1XC6ShqWRfBwUNe0nQ5fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cd0CQwdVXgGTP6SgPxdTrRcy3x9lC3v7PjZQ3reIiKU=;
	b=iDAzTohqFUiYDdWa/6L/cua1tcB85kuY+1SZ7+C4mIPPEGIB/hmC99cVYNZYg7YOMCpm
	 ag2PfDH0qW1o56W4sdIWWhg8uJbgOGF60coJvAXQwZFV1zx2kyVvis1QsLFbWZSb11RR7
	 U8CeGxsMnJ9cR2f+CodG4oP3xbve3NpMvY/LBsjo4SxPfyKP42N6vznGIvBXBWd1QwR+G
	 u9IihM+ehBHONIImueoJqk2ctOiq+oMfzVCFQK3zg2zKjjkj7vMVBa+i5nC2lalnngdGu
	 jnnYfYRgnXYeo4keGaYq9d1S+o53jbivaK1jriRAEoSqdbjys0ljqQFw0PeAtuBwkIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F1C6FAUh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE56E606A31C;
	Wed, 28 Oct 2026 19:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F1C6FAUh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2391F01825;
	Wed, 28 Oct 2026 19:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215255;
	bh=cd0CQwdVXgGTP6SgPxdTrRcy3x9lC3v7PjZQ3reIiKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F1C6FAUh+ioRP5QiB9zxGRh4D2BN6Xu+0f7KTzfUOs4XrHBi+asUdjOHw2kk/fRT+
	 cT4GUof+R1zUbsDAP+ovqohiMB0SQ3abYcMa0CcJrYlc5pxU4pa8yjCvpE73k61IH3
	 4k3P11F0uFyUMa0mPsgmlPBetOFrrtsUdMTj5uk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1148/1887] usb: gadget: function: Simplify diagnostic messaging in printer
Date: Wed, 28 Oct 2026 17:54:04 +0100
Message-ID: <20261028170525.529459301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

[ Upstream commit 57b7b733b1a7aeab25bc2670afff608214284863 ]

Don't issue messages which can be easily achieved with ftrace.
In case of printer_open() the return code is propagated to other layers
so the user will know about -EBUSY anyway.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Link: https://lore.kernel.org/r/20221123110746.59611-1-andrzej.p@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 30adce93d5c4 ("usb: gadget: f_printer: take kref only for successful open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_printer.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/f_printer.c b/drivers/usb/gadget/function/f_printer.c
index e4d35f5926941..b69e5244f6219 100644
--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -365,7 +365,7 @@ printer_open(struct inode *inode, struct file *fd)
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	kref_get(&dev->kref);
-	DBG(dev, "printer_open returned %x\n", ret);
+
 	return ret;
 }
 
@@ -383,7 +383,6 @@ printer_close(struct inode *inode, struct file *fd)
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	kref_put(&dev->kref, printer_dev_free);
-	DBG(dev, "printer_close\n");
 
 	return 0;
 }
@@ -881,8 +880,6 @@ static void printer_reset_interface(struct printer_dev *dev)
 	if (dev->interface < 0)
 		return;
 
-	DBG(dev, "%s\n", __func__);
-
 	if (dev->in_ep->desc)
 		usb_ep_disable(dev->in_ep);
 
@@ -920,8 +917,6 @@ static void printer_soft_reset(struct printer_dev *dev)
 {
 	struct usb_request	*req;
 
-	INFO(dev, "Received Printer Reset Request\n");
-
 	if (usb_ep_disable(dev->in_ep))
 		DBG(dev, "Failed to disable USB in_ep\n");
 	if (usb_ep_disable(dev->out_ep))
@@ -1218,8 +1213,6 @@ static void printer_func_disable(struct usb_function *f)
 {
 	struct printer_dev *dev = func_to_printer(f);
 
-	DBG(dev, "%s\n", __func__);
-
 	printer_reset_interface(dev);
 }
 
-- 
2.53.0



