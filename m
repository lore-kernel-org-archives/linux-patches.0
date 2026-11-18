Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035163;
	b=pNSNVhFN6Y9Ys9ftBvTPtSSBCx7gwLfHC8CAoSwOyWpQH4O4c8X0hLkbnG/bkWkr/1j0
	 C0shvuKAyy53rUUlZGgSiiod4zA1wXj/nnJYfgipeqmign9KUg0x66dBMJdswSvTEEb76
	 tt6HePJrOW4/K9JxRbe7qVUOxvDO72gpfqS+EQCQ63tUwfVRqsrpvR2MsZEzjN3hkiE2g
	 Tsg4EmJRoXmsNNrx+PNXTJhBOJike1xSoa6kTZVAcSCb2DrRn0Rqei+0X3PoXCxvsMlrU
	 dsyBt6rMXBCnA1SpxZYvv9keY10hEBGv2WsU6LfCTiA80ts3FIO2H6n3TiIFxxy1ZCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P/PLHcxmCfwWR3unczUYAaQb966vpfmqnmRj7q+UpvE=;
	b=rNUFKdgFSgjRomP/KVjzhrbMADMCmgrmMAx6TLHan/w2VDlGWSZCTF1lwxgKLIsZDbE9
	 5JagFzJUROrYvc5tDQDNoAOoAzFaduGkO3fnk/D02rUx96pWGYS0BwBOt+CvPsbSjfNoh
	 4N2ldXZOkrSvhdQZ1LvBrW04ETtYjfFMhVKDuqNvbHAoDIozD56iasKBFiZDqyJXlbQ/x
	 29mDFFAmKGnvy6sth5+7lKIVOLAPRHfmt/s0DOKEERBRo/iRH3acpUhrK+nF9pKiMhTu6
	 zYsyXHbVkNy0FUBxgUGr7c9dm/C0JMrz2KiI840/huKAAFEHZzhVjUhFAXh5L0k9HXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IoSkZmYF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B05C606A31C;
	Wed, 18 Nov 2026 20:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IoSkZmYF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579FC1F000C5;
	Wed, 18 Nov 2026 20:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035162;
	bh=P/PLHcxmCfwWR3unczUYAaQb966vpfmqnmRj7q+UpvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IoSkZmYF6MnZhK7UVqXSOGiSMcJHHATwSA2dL7UGb1/wgHAPT0Qpvn/jx4vvsobox
	 V+6+4Lsl6RhzUfBi89paLEkVmElOwlLsnxZ8CIj+1PsTWIShb0hv3BYtu8uu5xDtm7
	 qtNo5Op4N1gocRrZHIyRqwg6gSZ3mHBaKBvxJGEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8496ab5e117502750445@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Nguyen Quang Le Kien <khiemtranzo532001@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.6 0627/3318] usb: gadget: fix refcount underflow in gadgetfs_bind() error path
Date: Wed, 18 Nov 2026 15:20:49 +0100
Message-ID: <20261118150336.672788571@linuxfoundation.org>
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


