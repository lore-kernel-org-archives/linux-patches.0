Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831491;
	b=w9T4R6U0G1QXN0hHRSsVxrRWYydqhwCeSrrfbRqdkqE1RgRP54Y20oqH1oq7uo2By81P
	 qNXk2nXSn8biWeA5lRmtGvSDWKmwbJ/g3/4VYKR0ipGvUokjjYcVeuayQjnkHbxyKdxGr
	 Wi3PdM6tFLfVD8AfOE77ErZ5O5pMLXyce5ZG4Ucw/ZmBkjlDD+CYsPOR1o/XCn146iCPO
	 lMKHG9egYTmLqVYA43se2I/dX6J/8dRdGqBiHKIkbMxy8OIuN8h6ySoDnhnlZMMuZoWNT
	 WynBgmlvkx29Za9HSINWGq30+pq+vW8kS0vW/jx4sBso1Ml7TqBl8FOMj1pj1lehpiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C49kosnddwzAZFB9FQE0WEamEw+ryuPSud4hw3Jpgs0=;
	b=vWH+Zl1z6PENJmSqngSQwuNex6rWSUC6974qLmuEV8oME3mE2ns5kLHpzS2IBh1UrZlY
	 Ll19/jc/IMncs11Rwy0Jp5t5ONmJfC3euR680npCsVpKhDtDJ2nAaWTod2mMS4yEjrZrC
	 W6u57L+3jHIGC26RihbpD1Vi1xrJY8DHARC4drFYSeWgZUGnE+eCHQ5wwrwlSyCd14VtL
	 4LjnZ/e3SC0FE9SwpilEii2RZrFh5jjKhXVXEnL7RoAHKAL+o4ypN3W4y1MAq0xK2NzYN
	 vT/3/pqxuyLEAQ9CFCYqzttaUCBlvcvhzfMT5K6Jwdysbbu4e1LHaAhCodZwUp7mGMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrO1f2Jt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695AA606B2D7;
	Wed,  4 Nov 2026 22:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrO1f2Jt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24E11F00919;
	Wed,  4 Nov 2026 22:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831491;
	bh=C49kosnddwzAZFB9FQE0WEamEw+ryuPSud4hw3Jpgs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wrO1f2JtNCN9yyxRiPCB5NgVBUKtdaFAwGnEOtNgQJZjkBsfm/1DO9xABp+40E2KI
	 excus9iPDnHxZAEqOT3U70R1CPKGp2XRWitCmwrX/WlMPs4p6o4CvsZp1zJ7KtvUB5
	 2T7NI3EXjv92+92Rctu+YELkVEvmcaYdue9TKiO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8496ab5e117502750445@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Nguyen Quang Le Kien <khiemtranzo532001@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.18 0736/1005] usb: gadget: fix refcount underflow in gadgetfs_bind() error path
Date: Wed,  4 Nov 2026 16:07:49 -0500
Message-ID: <20261104211104.103367330@linuxfoundation.org>
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
@@ -1697,6 +1697,8 @@ static int gadgetfs_bind(struct usb_gadg
 	dev->gadget = gadget;
 	gadget->ep0->driver_data = dev;
 
+	get_dev (dev);
+
 	/* preallocate control response and buffer */
 	dev->req = usb_ep_alloc_request (gadget->ep0, GFP_KERNEL);
 	if (!dev->req)
@@ -1711,7 +1713,6 @@ static int gadgetfs_bind(struct usb_gadg
 	spin_lock_irq(&dev->lock);
 	dev->state = STATE_DEV_UNCONNECTED;
 	spin_unlock_irq(&dev->lock);
-	get_dev (dev);
 	return 0;
 
 enomem:


