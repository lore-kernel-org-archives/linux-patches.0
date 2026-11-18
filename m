Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051878;
	b=UHEOxq4X6lSUCH8KkrksI0koWssu4iQH31dheBLRPYX9fJ6ntu8ccAYLUeaLLbvBKLLY
	 PXUuvQHJVRYtEesmcIKm4kJLyFZhgNuJ2QGXxmyfhUBZE6s1mMkdRT0CZVqpghGYXfVwf
	 mBgjfME7fvM+sR16YA7QNUudQQKtgiOO0kkhOe5c2VIbnaRQX3vjUAW4+pIEhKxveW5uO
	 4Eipq7kiBELUeG2ZUXqD/IpBqpbJ4zl2UycMcgyAneKlXNc+OJ/F8D3aPufxjotRpP3b6
	 k9vRN2RVLl1JYN4GoRVvj2s9lbJlGyPDLwp/HMRZ1Xto9ay2xdvOXZAe2DpERFGbCnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gHF/jh+bLJ1IEKhxrBULSiUa45pGgTmrf784VdjESr8=;
	b=tGyJqsrlG0RdL2K5K4MUjLvtlSOOQA7iUR8Wh+SkFE6XZ+dDThCIOIke4YI+kxp95+RW
	 nFMTI9PIez+4bjBnTOeR7+b6KeeUVqRYt/C+7vzBW/Cv8O7I6xZZ1gDnFM4FLm3ZcDKj6
	 7/3bpBpJ4EeQwO4jN+fgQPTyHV31x0U5ebHYGrNrD3a4+pM6F3RfG/isji0/xJkOi/sl+
	 wzsnERKud+56o2eueR8CKehMs6tM9Utz9viAQnXR+IAmhwV1hQf95OBj4X6Br8PZSZVnS
	 rXqrmr94b5y7UYa66f2R5nAll3d8fza+0e3GEg0YiY3hPH1vWi++iHF1hsQTIecIsmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RJGuw6vS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F61D606A333;
	Thu, 19 Nov 2026 01:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RJGuw6vS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA1D1F000C4;
	Thu, 19 Nov 2026 01:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051877;
	bh=gHF/jh+bLJ1IEKhxrBULSiUa45pGgTmrf784VdjESr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJGuw6vS37OGp1FXF+CBa9hD8EqRnCCwZ8WbETmVCZBDk014vm6bAlx9TME6EF94U
	 LfB9CVSsH1o4B8Fl/9U4YSAjyltOZMNppsNmDUuRudFIGFlZlOowdf4SqyCykv5dwa
	 TO/Au+z+lDUlXzMqAJknev16OJvjzvz4IhYQLtV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8496ab5e117502750445@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Nguyen Quang Le Kien <khiemtranzo532001@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 0315/2214] usb: gadget: fix refcount underflow in gadgetfs_bind() error path
Date: Wed, 18 Nov 2026 15:33:11 +0100
Message-ID: <20261118150022.742812033@linuxfoundation.org>
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
@@ -1690,6 +1690,8 @@ static int gadgetfs_bind(struct usb_gadg
 	dev->gadget = gadget;
 	gadget->ep0->driver_data = dev;
 
+	get_dev (dev);
+
 	/* preallocate control response and buffer */
 	dev->req = usb_ep_alloc_request (gadget->ep0, GFP_KERNEL);
 	if (!dev->req)
@@ -1704,7 +1706,6 @@ static int gadgetfs_bind(struct usb_gadg
 	spin_lock_irq(&dev->lock);
 	dev->state = STATE_DEV_UNCONNECTED;
 	spin_unlock_irq(&dev->lock);
-	get_dev (dev);
 	return 0;
 
 enomem:


