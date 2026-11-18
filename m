Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051048;
	b=fsdYlA5tDJREzrQ70IMujg8AGDp5xrivZvLxq4zB22qKO3kj+2FAhK3giGhBX22o4HrQ
	 U0PQt3wZvO0cQbjsq0mL14IQNHhR92WqSMQ6+flpephWEa0TfAXQ0E4j8v1/oagiPTHXg
	 xWe7/PNAxxn2LLS0O1Grm8iqWt3+9Y/IZzz//6kIaX2pd9udyQwMp9FifmI5Od5BQZeDq
	 eBCnFgCSOWeyJVYTNCWX1VdqDIJkbN0AEzF5c29iIzhS+xH0/Mqf9oC25TjkmdeR2F0MU
	 e3TaueCsRNuSU3gKpKyJmCpZVtQE5DLXIrM7aNFUK0XS/i6KIzBAJiiyTF3FwX//2NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qY1fidVMAIpM//MFIPvpnGXusKQON8JJZoB9mrL7JxA=;
	b=I7nYTCIW+cStCLR7TXLRKt06pVZS7hNAbTF7Hc1k6pOHyJqNLyL0yBBoNoPaYwo3RIKg
	 23RuIiKBcw5J2kfVTeZZN9i9tpni83QSdlWLxw558aVn9BKRmDtg11H9ouud1VdN7QaO5
	 2Sh8YaeT/0Q2bo4+FVM8jk/B0zuukLRc4g6XLgJueRoDJSuSk/MtgGrs19Oh7OuKI9AxT
	 htzfhaVX+L0NuwrBV9hME2Ur7t9Khf9EwmH7KQ7baQMClVQV4w2HRw9ufBJ1w+/WAUTg4
	 fSZ7vDT8fKJxzLSDx5O/Ran9GAf6XTr4i5MOv1eUUePHZ+MaRwP52oXXfCxnRCbf72w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VWANuDyb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01128606A31C;
	Thu, 19 Nov 2026 01:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VWANuDyb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6691F000C4;
	Thu, 19 Nov 2026 01:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051047;
	bh=qY1fidVMAIpM//MFIPvpnGXusKQON8JJZoB9mrL7JxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VWANuDybmjH5tolbj65fWbAN1sJZCxfbhR/5qlkeTnUWa0K/QmQGAObo96z9Aonyz
	 WSbB8kHvEnRUDFXDk9gtq1m6fBYFUyFYwmkxJ4QHbUIumrVjc0tc+ZjkkV6NHSOVK/
	 S51GITS18dTwdOpvrYkTec1QQ0tb4fzrG8sLxU5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Prostitis <prostitisgabriel@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0069/2214] USB: gadget: inode: fix mm lifetime handling
Date: Wed, 18 Nov 2026 15:29:05 +0100
Message-ID: <20261118150012.753898200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index b17122fa7931d..10d01e6c06b89 100644
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
@@ -539,6 +546,7 @@ static ssize_t ep_aio(struct kiocb *iocb,
 	priv->epdata = epdata;
 	priv->actual = 0;
 	priv->mm = current->mm; /* mm teardown waits for iocbs in exit_aio() */
+	mmgrab(priv->mm);
 
 	/* each kiocb is coupled to one usb_request, but we can't
 	 * allocate or submit those if the host disconnected.
@@ -568,6 +576,7 @@ static ssize_t ep_aio(struct kiocb *iocb,
 
 fail:
 	spin_unlock_irq(&epdata->dev->lock);
+	mmdrop(priv->mm);
 	kfree(priv->to_free);
 	kfree(priv);
 	put_ep(epdata);
-- 
2.53.0



