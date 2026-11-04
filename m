Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829450;
	b=hnhbiZ5zkV7eXht0NI3iZH8kJsCTkzn7JmgOacrLpgm3MzXArt71+kN/qJIUBzQjnA4D
	 Xxtv4CVNDtFUjGZPVqouZZI/jrJ7Rd3yZyKeroxL3L/5oNC3LyF/tUzy9/wn477hWSRGl
	 pm4dvylY+5JfzLYa/uDgQCIwx/+eH73NTMOHyJP54AFyuk1I278wtPpAZD7cFv1PMca2i
	 BKB2cVeltKXal3PWJF9Ea9untZ14ImIJQF3TboD3WHnbwRoGdiYFKF0pnCtyEt1abYs9f
	 rqzahOjalmQo9NmrVhXi/RC8PIbm1gbX5QQHSqY1YKfzdga3RNtEJpV0nEl/zUpC//w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9Fx2riOh1t5DK68EMD8cjU7tCfZ4xEi7soW1RS7UELE=;
	b=PuPf109bFHooy1WXwrOHfecHOCaC6zH5ybyxMnP+DsA2dzv0G2VYTcLjD2qDqUtinM2p
	 MErsrpwl9OqDUMB6MFCFm+9+lLLD3eFfYfju47OB4ugpBIZW83bmpj7QYD3/iY52mXvmZ
	 OudnDHaZ/KvBVb41lqZJvoL7PwDcciKd5l7xup4Nsc7ntdNFVVcdp8UiuAcp/5Hab/Cin
	 0bBkwpgPOyYqv1gNUx1llcPphzzbuVVmpaQi6W3YwCfntLLACDwZdzZb7+g4nKxgt8plj
	 SaBjNuWTjiFiX0buNTDC/4ZsKGnVIcMwZVCcpQwZwqiLIoEMcYNh+ir+qiK0Q6g/UBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fJu545H2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FF0606AE28;
	Wed,  4 Nov 2026 21:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fJu545H2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9308D1F000C1;
	Wed,  4 Nov 2026 21:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829449;
	bh=9Fx2riOh1t5DK68EMD8cjU7tCfZ4xEi7soW1RS7UELE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJu545H2vZDyBoy74+8gHsx/6FG051FThs8/b9hyo1rlqJKJ/H8AoXtJ9MPRG5Y/B
	 FS5+e9EcUKBkc7UG/06AXG0tg8gg9liWXbTg/5qazZLkn7XK/kkQWuu+pA4MnKyTn8
	 ynNVtSoNjxkiugqcr4ZahpTgFegiKZoNrEWdDQhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Prostitis <prostitisgabriel@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0132/1005] USB: gadget: inode: fix mm lifetime handling
Date: Wed,  4 Nov 2026 15:57:45 -0500
Message-ID: <20261104211047.390978043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7c72267c0c53b..a46b6a6b1f836 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -473,11 +473,17 @@ static void ep_user_copy_worker(struct work_struct *work)
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
@@ -503,6 +509,7 @@ static void ep_aio_complete(struct usb_ep *ep, struct usb_request *req)
 	 * complete the aio request immediately.
 	 */
 	if (priv->to_free == NULL || unlikely(req->actual == 0)) {
+		mmdrop(priv->mm);
 		kfree(req->buf);
 		kfree(priv->to_free);
 		kfree(priv);
@@ -543,6 +550,7 @@ static ssize_t ep_aio(struct kiocb *iocb,
 	priv->epdata = epdata;
 	priv->actual = 0;
 	priv->mm = current->mm; /* mm teardown waits for iocbs in exit_aio() */
+	mmgrab(priv->mm);
 
 	/* each kiocb is coupled to one usb_request, but we can't
 	 * allocate or submit those if the host disconnected.
@@ -572,6 +580,7 @@ static ssize_t ep_aio(struct kiocb *iocb,
 
 fail:
 	spin_unlock_irq(&epdata->dev->lock);
+	mmdrop(priv->mm);
 	kfree(priv->to_free);
 	kfree(priv);
 	put_ep(epdata);
-- 
2.53.0



