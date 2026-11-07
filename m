Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060680;
	b=EWTq/NilEcJaO96hq+xKJsivwDFnedVsKuq+aLJqnvztj88S8Fo0odDukdZbGlYNWNrv
	 umf2wO5ss2owXQk6uZWBrp2lcLL21ghRoAkKS5nnSkOBJhnCL50XI1EhFcBqYwzRQktWJ
	 OHy/UxdlWOGE/uch62aOVOcuhrUIrn+o+SuCtyXQJ0E4PubfDWAfNYnbFq/FB7mV+aE2q
	 VjzQg3wAFErz2OHfChjGkdDNJedJiNTbBRRB0W/1GLqhKjEpago3awSyFbmpe5DXvWrFV
	 q0tYD+nzyOCa6U/T3Vopm/TPmPCb5YW2Eq8v2oq94Y4vyDwG5lylKsMgmw2PfzQzUUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o8VUIv3tGROliY/eMU/hkcPIgm1hcVu+Sae/fEGO6GE=;
	b=t5biXxFppZaKtYkWhzJ1W2KxxuPSzFDnAGlJt00aKC2P89v1+yQ5Exa1tq8HbCkAW1fU
	 gfQlRcZQKOGCEdFD9j2jsVNZGvsdvmgZ5RR5DrabMdJ9Njr8GiJf/6G15vVP9lMeok1a+
	 o/ODRgq7oY7gDhAdANxmOftvMDXdmh9DSNplc8a++6TD3WSXjfV6/NE9YWLnOM5spWlPi
	 vASCUujfSnmuWjE5qYhRVYF8rmJKlnetmSROggdMgqhmIHDqKI9QBr4e7XNNAHa2uAK0O
	 C0VBWXRW5yG//FnmVPl4ZIfgwAqbkco5fDdRTt8m/YFPu5lhi6KshxxtxPZTJ+wti2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YUsLESVu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E75606A32D;
	Sat,  7 Nov 2026 14:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YUsLESVu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E28F1F008A1;
	Sat,  7 Nov 2026 14:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060680;
	bh=o8VUIv3tGROliY/eMU/hkcPIgm1hcVu+Sae/fEGO6GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUsLESVuClGyRE0z6UEoaHRcKrUpqe3qXGdanN+GT9v1hRucsJPlVDhy/f8u3+oNT
	 iNZ6Cl1DXfzwIVGZc9EvSNbF+LIxmiZiNW7w3cF7sKM3j5ANEgPi7PCCz1KFiCGXfz
	 0DX4d7SybAco48nih9QWwTJOXfGqs7sNIHErNQ4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Prostitis <prostitisgabriel@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0113/1536] USB: gadget: inode: fix mm lifetime handling
Date: Sat,  7 Nov 2026 08:35:29 -0500
Message-ID: <20261107135000.848399056@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 81766838e4b2f..d98c28f7dd528 100644
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



