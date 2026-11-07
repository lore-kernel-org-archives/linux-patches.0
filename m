Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061579;
	b=gUmFVoveB31X1EY3muv3BsVcPE7/tj2PnmUSYl613O4tH4MSELhbRDyQe2amX6ovPTm9
	 zmIPjVmyDDtJNOA1KLbTT05CzetY3Nq55wQFbJ2iZLF0o3idmLNK4kU+u5GC6c7TmvYAO
	 xcvQy1Q0PwLdShUT++q2udnBkbgEmOPe8U83LlkpxbgJYJmB33dKZa8MEAGunpDZ2W/e5
	 jCqqUZhfEubcz/FJGpyK6y+OpqoSLf+i7KDHg0++peKSRAhmLyTkHBrsKYtl6JDTHZqYd
	 2GQ1Tftx8vkrPIMoA2SxKIZKIqh0qucXvbEYoCLtTTSn6O2vkJXxO6bfljeuhzLnw4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VFXI+dQ4u5coA3mWQkrZfRUj5RyQF22GpcZf/BjPPdY=;
	b=RUptM9HiliMH4QcxxD17q/8iXf9fv4nR4aj/gVvz9GMj6DQNszAhmfGfkxlreMEku/Hv
	 0UG22lQ+v7EBr87fmSIQqLbqAwfh8dMGXNOmlsquL3NVto0jqdvkIgBJeHrLRJqQJXuVt
	 WXHArYYR/PVQf5BmfXeKNH5QOCIX0Dif1744N+Xe2aPcbXqvY7DlU+nrWGZl4XKJ0VCBW
	 AAnNA0sV0EMJoBhegmfW5TmzbbLOiB5oBpD/L7pUzE82pdtMc4EMxVAWSRJpD/EVrZHkk
	 oAeADbtWYZe+cHoRX1NbLqHnDNYTrCXvHwnmba69gO5TSzSYK0ARwvCmFrufqLj2xug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K82Dfhrf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEC4606A326;
	Sat,  7 Nov 2026 14:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K82Dfhrf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAE91F0089F;
	Sat,  7 Nov 2026 14:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061578;
	bh=VFXI+dQ4u5coA3mWQkrZfRUj5RyQF22GpcZf/BjPPdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K82Dfhrfd29gabBxdq3AN51NfdAkJvjdwbdkA8vMoQETs+I/bWXBhpV+pYbEEtLZy
	 x/iIvUFNm+aEJaV/tkfUlki/bse68dTQarV1Ax7L2uDCwLmZIPuwxsaWaoGUDe5hKW
	 xUvBZH/DJzopwhUoiMYuhMN4IfUfixOnqCfCsSHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8496ab5e117502750445@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Nguyen Quang Le Kien <khiemtranzo532001@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.12 0655/1536] usb: gadget: fix refcount underflow in gadgetfs_bind() error path
Date: Sat,  7 Nov 2026 08:44:31 -0500
Message-ID: <20261107135015.925415071@linuxfoundation.org>
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

From: Nguyen Quang Le Kien <khiemtranzo532001@gmail.com>

commit cb3b441f2698455a48e9a023d5f7f4e3fcb94c73 upstream.

gadgetfs_bind() calls get_dev() only on the success path, but
gadgetfs_unbind() called from the enomem error label unconditionally
calls put_dev().  When bind fails (e.g. ENOMEM), put_dev() fires
without a matching get_dev(), leaving the refcount unbalanced.

A subsequent close of the ep0 file descriptor calls dev_release() ->
put_dev() which hits zero and frees the object; then gadgetfs_kill_sb()
calls put_dev(the_device) again on the already-freed pointer, triggering
a refcount underflow and use-after-free.

Fix by calling get_dev() at the start of gadgetfs_bind(), before any
error path that invokes gadgetfs_unbind(), so the reference is always
balanced regardless of whether bind succeeds or fails.

Reported-by: syzbot+8496ab5e117502750445@syzkaller.appspotmail.com
Cc: stable <stable@kernel.org>
Closes: https://syzkaller.appspot.com/bug?extid=8496ab5e117502750445
Signed-off-by: Nguyen Quang Le Kien <khiemtranzo532001@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260811060810.295666-1-khiemtranzo532001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1702,6 +1702,8 @@ static int gadgetfs_bind(struct usb_gadg
 	dev->gadget = gadget;
 	gadget->ep0->driver_data = dev;
 
+	get_dev (dev);
+
 	/* preallocate control response and buffer */
 	dev->req = usb_ep_alloc_request (gadget->ep0, GFP_KERNEL);
 	if (!dev->req)
@@ -1716,7 +1718,6 @@ static int gadgetfs_bind(struct usb_gadg
 	spin_lock_irq(&dev->lock);
 	dev->state = STATE_DEV_UNCONNECTED;
 	spin_unlock_irq(&dev->lock);
-	get_dev (dev);
 	return 0;
 
 enomem:


