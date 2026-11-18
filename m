Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033661;
	b=pVt2tL1u2G6WZbOsys0pck6xGomDIoQqdQOCrB5d4LCeSO2wJHJq53wQgu3t+mbYmBWu
	 kH2RvChAgTptxeMhJVWsgV+gs5BpERVONZE4TcAZOPzio0hRXKYY5jpfI6hXAV4suju9N
	 hSnsZXDQyiF8o5sndty1DlwvOqUgAtMETS783yqYnyjzqXMwENYbS5fE5pMUTwv/+7Xso
	 cJy0UCYFCnKnPu6TrUvJvIyUcv2fcWIyT7nyG6+/PPAtwKTrOpSawhjqHjvC0ejDV2Ns0
	 6+VVD8mh+P6bc+q6W98Sb5xSBGbvWNQDg0uq6rKrKolbB0N8hRrKRmdaVUXum/gJsqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DAImROxIjX+Mj7F1A1apDD1YgrlykiT51PGNWTtFDgI=;
	b=YcBQtpOgQosqA49Ocv+baVVc7PohXVm5nXY7MFq7oDOxMjLzCnuVQXoayVZb6DNUdr/H
	 qvOhdHl7sD6YIb56ccuNM2B2j02QN8l48p/V1Qccgq8+tUe5PIjXtXfrZrQ8JPO/SdLw6
	 WmR6zP5e/8DzeCkV2XqedwY937Nl1tRjd7ydTb1h2jjpZMxwi1pts57GEPuiXchvDHibk
	 2OZC7eBPr0IvAfQUzoArCFIUuEo7Ru+wxwTtoN8Imcd8xZSOEMXhdLXGBXzR+NqlK2KHB
	 Ydmqs2OibjEcCqEGf/scarurYIouO5WIfuQudrCIZJfZSFYEh4gs4JV3XwhQ4+pKoxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qBvjHvpN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AF0606A31C;
	Wed, 18 Nov 2026 20:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qBvjHvpN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896AD1F000C4;
	Wed, 18 Nov 2026 20:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033661;
	bh=DAImROxIjX+Mj7F1A1apDD1YgrlykiT51PGNWTtFDgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qBvjHvpN7IGSVwyYIinPtdfoyrdWj+9qxm112WnJDEHg026sDA1A45E2M+IEhtpN5
	 pnBHCWgjFHHV5L6waJSRKx4CBk2+S430jNk2Eed8iqRr/x0/TS+fpdDIn1Uz8+RqB/
	 H9VF97pVCdvtfwK9+u+CxWWZv5AXKSvzG8RCUf08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Prostitis <prostitisgabriel@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0094/3318] USB: gadget: inode: fix mm lifetime handling
Date: Wed, 18 Nov 2026 15:11:56 +0100
Message-ID: <20261118150316.987757352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3889b0ebdb90a..398ff96b0bbb5 100644
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
 	iocb->ki_complete(iocb, ret);
@@ -496,6 +502,7 @@ static void ep_aio_complete(struct usb_ep *ep, struct usb_request *req)
 	 * complete the aio request immediately.
 	 */
 	if (priv->to_free == NULL || unlikely(req->actual == 0)) {
+		mmdrop(priv->mm);
 		kfree(req->buf);
 		kfree(priv->to_free);
 		kfree(priv);
@@ -536,6 +543,7 @@ static ssize_t ep_aio(struct kiocb *iocb,
 	priv->epdata = epdata;
 	priv->actual = 0;
 	priv->mm = current->mm; /* mm teardown waits for iocbs in exit_aio() */
+	mmgrab(priv->mm);
 
 	/* each kiocb is coupled to one usb_request, but we can't
 	 * allocate or submit those if the host disconnected.
@@ -565,6 +573,7 @@ static ssize_t ep_aio(struct kiocb *iocb,
 
 fail:
 	spin_unlock_irq(&epdata->dev->lock);
+	mmdrop(priv->mm);
 	kfree(priv->to_free);
 	kfree(priv);
 	put_ep(epdata);
-- 
2.53.0



