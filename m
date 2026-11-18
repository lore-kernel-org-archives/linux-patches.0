Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044437;
	b=WEKi6cSOsV0oq8E5Umo2syf7UFyty0u20JZ4Q/zxbtKc9xbzy0/rsEhmLRZ5n48FXSXz
	 m1HxsRvrhSNoUiImPi8/YLhrQ2gyZ3otKlV6li47Uvxip+fupdL+c/uVMdnrBfaipVVsn
	 3UhgUmGlJb/68YIPL+MPZG3mJD6G3x1iZOn7qfywGZVEcRj+qJXJlYKh1rPSieHGjPUwV
	 3ytRYlAnqwib0wRDXoPh2dzP7P3Qs5VzZnmCAF/QlJIX5wZ1XK0ErxkOYn5johEQBJ0cY
	 tCYbbB+WZPXzj3iPHLc235oV2Z8WvlifJ1XioeKxJMWKwUXTWtrdF9vROCPoqvNzkxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lx1UpTGNEnewmyRIzbJRfOUrkdKXSjkMTzw0uNqEiv0=;
	b=5DYWo47SLzIq4tNCDQ5sxH3Db8+gKqb7glMhnEilsgO1CVUUZAUsgJeLK7Bsx+UPwFRA
	 IYcP6XzkKcOO+8davWovi49fq+X+8vVWIEBxXYMyIPBOWaRkaXOzGV/h+0YOhm03EV8E6
	 c1ceZZjn2WOJDQkfOvObc/TYOVjF22u0TN1ZxTuvc7+akoQUkPv8ffrGlD6nAg9xc1ig5
	 lPuDwtYze/EdLy0ewiouZTE+GIkGNSo/eAkwjFISwflHERfud3GuuAPmVytGdqpdbc69c
	 +vPJjH41D96tyIqhC5bn4P4RVITRHVifRKL5V2zRqpZCaRumTUhDv94XBtyD0/dQ6ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IOmldQOr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B041606A31C;
	Wed, 18 Nov 2026 23:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IOmldQOr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7981F000C4;
	Wed, 18 Nov 2026 23:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044437;
	bh=Lx1UpTGNEnewmyRIzbJRfOUrkdKXSjkMTzw0uNqEiv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOmldQOr/zVOdTfXcdIppTI3l1pbG1ife7NbnprEYbyajMVa0MmLslsYQZG86Pr5Y
	 X/VpWid/7EJu1nWvXs0XxN9IT4VKiDhGX1dGcMmphKMBri0Mb8ikIS2MbSMLTlXFeY
	 HFpagGqLpuyITkT7DoDKCBWB8rBb1xcwTmYri35I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8496ab5e117502750445@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Nguyen Quang Le Kien <khiemtranzo532001@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 0565/2857] usb: gadget: fix refcount underflow in gadgetfs_bind() error path
Date: Wed, 18 Nov 2026 15:26:39 +0100
Message-ID: <20261118150221.832940120@linuxfoundation.org>
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
@@ -1682,6 +1682,8 @@ static int gadgetfs_bind(struct usb_gadg
 	dev->gadget = gadget;
 	gadget->ep0->driver_data = dev;
 
+	get_dev (dev);
+
 	/* preallocate control response and buffer */
 	dev->req = usb_ep_alloc_request (gadget->ep0, GFP_KERNEL);
 	if (!dev->req)
@@ -1696,7 +1698,6 @@ static int gadgetfs_bind(struct usb_gadg
 	spin_lock_irq(&dev->lock);
 	dev->state = STATE_DEV_UNCONNECTED;
 	spin_unlock_irq(&dev->lock);
-	get_dev (dev);
 	return 0;
 
 enomem:


