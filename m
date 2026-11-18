Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057242;
	b=P6kd15RKIBMjv1VwwWd6GJMRv0GnyTYihX7mi0IyzWYpHeonYy+yRv3Ucs+sd53bmTJE
	 /tELCCqLnWKtQTp3Fnqu2L1brOyCOWqxcXf//v/APGvyWm1yN5UKQFDoUrhT6dancs4yH
	 SrKJi8RmSYwl/gYUwnPSBKWGBkdGVWn241dEbIq6u1CzZE7rIWHGzFANQdKJGUjHOKe5V
	 JU8Hmxr3rcWg3R7+ZXUfuJjG8/0cpdAJyJ4wM3GCHVZSmXHWvieTEU/6Jp6F5RIR2UpNN
	 b6UQzXh64JRR8Nzqq8LzdbzbJiAyt/9rpyys/LoCRsQJMl9ZQ2/IYuxRiyzR/qypmtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yFqOgV87Vh/dCW56eYw+avdg+6QmxFfvZe2DxNt8xkw=;
	b=AdNurqp6Rz6MWQvz3o7+mok7mF86VQo68820LkpMtz40+VzXE291UHmggrjwKyLmLRat
	 uhHuEy3xPmk3PAC2h4NiF5VNuTOvfajZlGdHAMk1prMpQ1PlB7IcIN7cr3MHYhgNHwC+d
	 XmgY9lReCdqOHSZrJcTEyBkbxq0AdxZTlho+EIEznlWUfYb8Ds+3tcb8SN1L5GZfRacPA
	 V1lRlfua7bdPTJmNl255m4h8JmSpdav5MaYK0k7CCJzbzNxB9NMnT4YFGExDyDMtxcdTG
	 KuKCcuI3+R4ywK3rSRrSEb9t/pQ7+B3BONuU9g8zRc/gtJ6unMzyvKuR3tESkwzmdXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MDpm3GUX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC48606A33F;
	Thu, 19 Nov 2026 03:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MDpm3GUX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003CA1F000C5;
	Thu, 19 Nov 2026 03:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057242;
	bh=yFqOgV87Vh/dCW56eYw+avdg+6QmxFfvZe2DxNt8xkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDpm3GUXdcLJTrhgdStTYEBOgRQQ9pkxXBVzhedikgvQjo++zhTy6H7Zoo4/uTmEH
	 //HLNUsD6wuswD3Ccb/N8H1PQyYZqewt1JnEbWs6auwo1SZhGfZv7kEWvuV08/w6AA
	 2too7JoDdyQN7X+wmECPBRkBqsFfsaHe2lJzMPEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Prostitis <prostitisgabriel@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0062/1848] USB: gadget: inode: fix mm lifetime handling
Date: Wed, 18 Nov 2026 15:35:00 +0100
Message-ID: <20261118145913.738352970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Prostitis <prostitisgabriel@gmail.com>

[ Upstream commit a1c33c80e11ecd5c3310a38c4be324095dd85ac5 ]

priv stores a pointer to the submitting task's mm_struct,
but does not currently hold a reference to it while async
requests are pending.

This can result in a use-after-free if the task exits before
completion handling finishes.

Take a reference with mmgrab() when queuing the read request
and release it with mmdrop() on request completion.

Reported-by: Gabriel Prostitis <prostitisgabriel@gmail.com>
Signed-off-by: Gabriel Prostitis <prostitisgabriel@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260601-mm-uaf-fix-v2-2-3c942a707bce@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/legacy/inode.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index dbc17fcbeb57b..03f415664eaf8 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -466,11 +466,17 @@ static void ep_user_copy_worker(struct work_struct *work)
 	struct kiocb *iocb = priv->iocb;
 	size_t ret;
 
-	kthread_use_mm(mm);
-	ret = copy_to_iter(priv->buf, priv->actual, &priv->to);
-	kthread_unuse_mm(mm);
-	if (!ret)
+	if (mmget_not_zero(mm)) {
+		kthread_use_mm(mm);
+		ret = copy_to_iter(priv->buf, priv->actual, &priv->to);
+		kthread_unuse_mm(mm);
+		mmput(mm);
+		if (!ret)
+			ret = -EFAULT;
+	} else {
 		ret = -EFAULT;
+	}
+	mmdrop(mm);
 
 	/* completing the iocb can drop the ctx and mm, don't touch mm after */
 	iocb->ki_complete(iocb, ret, ret);
@@ -496,6 +502,7 @@ static void ep_aio_complete(struct usb_ep *ep, struct usb_request *req)
 	 * complete the aio request immediately.
 	 */
 	if (priv->to_free == NULL || unlikely(req->actual == 0)) {
+		mmdrop(priv->mm);
 		kfree(req->buf);
 		kfree(priv->to_free);
 		kfree(priv);
@@ -538,6 +545,7 @@ static ssize_t ep_aio(struct kiocb *iocb,
 	priv->epdata = epdata;
 	priv->actual = 0;
 	priv->mm = current->mm; /* mm teardown waits for iocbs in exit_aio() */
+	mmgrab(priv->mm);
 
 	/* each kiocb is coupled to one usb_request, but we can't
 	 * allocate or submit those if the host disconnected.
@@ -567,6 +575,7 @@ static ssize_t ep_aio(struct kiocb *iocb,
 
 fail:
 	spin_unlock_irq(&epdata->dev->lock);
+	mmdrop(priv->mm);
 	kfree(priv->to_free);
 	kfree(priv);
 	put_ep(epdata);
-- 
2.53.0



