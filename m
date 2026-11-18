Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057799;
	b=a0v1yWydEPA9+5G4FB4UY4+oWeoSmLr4uSFhiI9v8mUNHVb1zXHoslA4Y7fZ79plyNEq
	 q1dI1xyREqY7tTau3/lEpyhg7xR8kTV3u3zloebaOoshBYHDDTucMCJauwXnmHsy85f/s
	 BlQVcvGPzRG5sOwq4MVRW6JCQ1OiZ0dHZeMnk6m3+bCTG2R2+2emQICv0zW3jdzJp6PED
	 jQTHDx7jFi0nw0OXXEgHwdd+hufuArQ2B5+Xu2ZZZ40yjJhWg5kzAcrDXkRn40CWD17Ol
	 Pcz4tDT9HuDTEO8bedjHRW2S+jZF1VyWDeb9ZOxghhuzNLgM07iXAi4i0nIbj4NLPyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MFyS3nA+5dNaSaTAjRt3VjJ6yQ+RVA35rc2EcGDwBDM=;
	b=fDV0JMzIjSevd0Re8loAqRyr71kRPa/umruKNsXenmfjhTZtSrq+TSxotUZ2Zsox+mcA
	 n1wgwuGKji7pX+SiVcFuPGkM5wpQts+Syx6Sdn7/O0BKiMmx8kVVqJpcjZW+iGqk00KZy
	 MjnFHuGxYdfG39JG4UCc/XKP7eZC2+qmc/Zo1q6/BYbTkdhiOpP7/J4ydBpisLRM/zvIc
	 Ofa4XdycCvZ+asAl7koTlwy5A7TvfCQ1SD9+AjYAaQoeP0qhAEvmnrgNS7/Cx/4cgYPcJ
	 zgVmyN2crf4aqR+ZBsQBQCW9LrpWbwoxRCOiqQ6RLJ7Z6eDS9LoRg177sHUHu5XALDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vkZGa7fa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB45606A325;
	Thu, 19 Nov 2026 03:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vkZGa7fa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6271F000C4;
	Thu, 19 Nov 2026 03:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057799;
	bh=MFyS3nA+5dNaSaTAjRt3VjJ6yQ+RVA35rc2EcGDwBDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vkZGa7faAIkJDMXR9Ts4PNC8QFRAx6TG8Xn996v37Sdzj1nBQoA7dCYu1MvebG3eA
	 Gs5qZL86Zf2urF7bYfth3VD2ogeCSMNqbhOFOvzYQ7+xBMCNt01ieeBDdTuze7Irpd
	 NuyBSdeCT5O0Sff3GC66dnL/pinaxbdgqNO1Fgeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8496ab5e117502750445@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Nguyen Quang Le Kien <khiemtranzo532001@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 0257/1848] usb: gadget: fix refcount underflow in gadgetfs_bind() error path
Date: Wed, 18 Nov 2026 15:38:15 +0100
Message-ID: <20261118145922.993201413@linuxfoundation.org>
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
@@ -1689,6 +1689,8 @@ static int gadgetfs_bind(struct usb_gadg
 	dev->gadget = gadget;
 	gadget->ep0->driver_data = dev;
 
+	get_dev (dev);
+
 	/* preallocate control response and buffer */
 	dev->req = usb_ep_alloc_request (gadget->ep0, GFP_KERNEL);
 	if (!dev->req)
@@ -1703,7 +1705,6 @@ static int gadgetfs_bind(struct usb_gadg
 	spin_lock_irq(&dev->lock);
 	dev->state = STATE_DEV_UNCONNECTED;
 	spin_unlock_irq(&dev->lock);
-	get_dev (dev);
 	return 0;
 
 enomem:


