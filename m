Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043061;
	b=YgAyaou1dqlUZ8oJNBMcX0ioYEwPN6RgnWsd5VciNYjm44+NDLU8ip+bhhf2DkMPozu8
	 Y4C3LHh7hnnO+kQGsKUnPZZFhiqRgR2btiJcmJ+OTt+ONXVrp+yHzrsmqs0czVW8Ufx6G
	 nxLvGOFAvh7To8aNHBHv8G0dgQzxZWo0Bl+5aA/gS1vP8atsF6O2Fal/iVO7vMXF9SaPv
	 hSAywFMdZDGy0fkt9ct/Zp4wQ3Kazu7VrCaRfKM+k77s9PB/PeH+iYX7lGtLaTecPPIQ/
	 vC4aYgxFCCMuTEZkDY8sLVNp1uWwu2Zs3kClCE6tQ7dJgzbERxGRVhg9or6Et5u2KUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UPHtm/oN56H/1Y316xopMSPj7HsaeM7xFEq4+CG+kFI=;
	b=nC4I0/83cRyI0yIKHjgY9+Bm+9O/bNrcGL3exTOHLzIG/YrsQIweKXCu92Nx6yTKoGiv
	 fEkoZ/By6cpl0hdulrcU7cnt7nUHYlRZ3uvAniTx+yJUgMhxt0t+SfItS0CIUsSkxUpOn
	 OiLrtRXYL3RUUp+6NWA/T1vLoMStInziUE8W2seonUx4u/X0bqAF3nDuuF3D8ZQhM2x7W
	 m9R0/jcaqY33zO6l0O8Hj0rKzu+DvpaImkNe0Y2WhhF/51jUg9yfXYrQVNMQTYvnshY63
	 njvfZU6WF4gKpuYtSlvfs8O4qrjJwTbDfiIQHsOQx8DqTtbNAgUkOU7AsAG9DrbbclQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LzaS9VDX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDB3606A31C;
	Wed, 18 Nov 2026 23:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LzaS9VDX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D871F000C4;
	Wed, 18 Nov 2026 23:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043061;
	bh=UPHtm/oN56H/1Y316xopMSPj7HsaeM7xFEq4+CG+kFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LzaS9VDXPqoiVKwiwxT+BhOschZUCHd4x2mZJfA67ulhlNhTODmBi5SId1pZmy1p9
	 i5Z14NmItUge3Ds3Ry74soVF5ZHcOGtVB+9o0ekHwe1Lpy2KBp0g5Dqf/+rCqcL/gx
	 t03R+uEkuzvqwo2RDbh5wMCmdvslaPuHpAZ5C07c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Prostitis <prostitisgabriel@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0077/2857] USB: gadget: inode: fix mm lifetime handling
Date: Wed, 18 Nov 2026 15:18:31 +0100
Message-ID: <20261118150204.079955150@linuxfoundation.org>
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
index 9ef922c537b4b..afae2a4573024 100644
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



