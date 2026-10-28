Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212797;
	b=Z3YTZDx7WZCVhqL4xcjOeYmpkkqZ9X3+LK9niwqxq95ccAiK+1TMkht7/ddRZRnjxu8Y
	 Pm64MYjHYSU5qNs3IKxunGf+DMGIHn84OedkhTTDy4VZDtjbuc/2CFcToAtGPONUkVeyx
	 NaqldEn6NqDD+uO9GeJNlNRbM1FiIv+B9/UGn1d9eeZZD7CBB5hd9mQWnO/qJljs3IfXm
	 GN9Z+74BhPPF+1QZYIaHBuM0EfMd65KFDw+MSa9VXvaQkCRo9TAb4vnkENSrEUArQv2mF
	 8V7ZNjgQOhmD+fHKwLaRHpal9zsuDK9U1/Z2QwFvHNjuHvmta2OH0tckGJgnttwCw4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6r9Zb2Bg1Gq9tPMkxdeCp0WgTnZyPybzpLWKr0jQMbs=;
	b=eLGMbIePt6DowYQt66l8uUUCn8wAaey6x6dL2+XxOR+9b8ovSZMfrvcKaPvVeJr861P+
	 adxdCOJQZIBlAIq7DlaDIfDpS8C5aHymhhpGElqyYeU6ksGSf4rj2R6+cGkxqDFlgoHx4
	 I71+24LaMJV/1+oCT2tFgC5son5daE2A7qKrxc1Nep6mh+F0ZGWWT0g05MwJseOYvB4+s
	 rnc0ZeUm9LPgs0UEXCaYxvMn5QuZ86iJhfw5Gac67jGc8WB1RZ9BJloyIool12fTfK6bm
	 bvqiou7ZFolLMHzMRo1LCBMiu7mInrNAnxJKjl4JDbUQM3Nb0n/SO242KvxpeJdB2JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IVvQAVqM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F483606A320;
	Wed, 28 Oct 2026 18:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IVvQAVqM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6941F01825;
	Wed, 28 Oct 2026 18:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212797;
	bh=6r9Zb2Bg1Gq9tPMkxdeCp0WgTnZyPybzpLWKr0jQMbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IVvQAVqMWGkvXF1SLgPuqNAMdLNmQZ0SEda5XyhVZZdkspxL7uEECt2HXiKS8EImt
	 8MFTR7tsjyqTvO0Rf+IKxkignN05om6mUXmJLCt1wEdzjaYnKaUkM3MsfUMhEVtcuF
	 TFegJpzXyW+KHenMHqOllS5JROsTG3E7pZiQ5PpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minseo Kim <neck3922@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 0279/1887] USB: gadget: dummy-hcd: Fix wait for outstanding request completions
Date: Wed, 28 Oct 2026 17:39:35 +0100
Message-ID: <20261028170505.578681231@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Alan Stern <stern@rowland.harvard.edu>

commit b263ff9b0fc5c1f371d65c4eb196b31263d039ff upstream.

The dummy-hcd driver emulates synchronize_irq() by waiting until its
private callback_usage counter drops to 0 (with the private lock not
held).  This counter is incremented whenever a gadget driver callback
occurs (which requires the private lock to be dropped), but not when a
request completion handler is called.

This is an oversight.  Request completion is triggered by timer
interrupts (emulating device IRQs in a real UDC), and the interrupt
handlers are supposed to have completed when the synchronize_irq()
emulation routine returns -- they aren't supposed to be in the middle
of a completion callback.  If this happens it can lead to a gadget
driver's unbind routine running before all outstanding request
completions have finished, maybe even allowing the gadget driver's
module to be unloaded while a completion handler is still running.

Fix the oversight by incrementing the callback_usage value across
request completion callbacks.

Link: https://lore.kernel.org/linux-usb/7a87e293-633c-4100-aa8d-91560ba5e5c5@rowland.harvard.edu/
Fixes: 7dbd8f4cabd9 ("USB: dummy-hcd: Fix erroneous synchronization change")
Tested-by: Minseo Kim <neck3922@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/f23b9e1a-f110-441a-a1d8-95f442ec09d5@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -342,9 +342,11 @@ static void dummy_giveback(struct dummy
 {
 	bool fifo = req == &dum->fifo_req;
 
+	++dum->callback_usage;
 	spin_unlock(&dum->lock);
 	usb_gadget_giveback_request(_ep, &req->req);
 	spin_lock(&dum->lock);
+	--dum->callback_usage;
 	if (fifo)
 		dum->fifo_req_busy = 0;
 }
@@ -758,11 +760,13 @@ static int dummy_queue(struct usb_ep *_e
 		req->req.complete = fifo_complete;
 
 		list_add_tail(&req->queue, &ep->queue);
+		++dum->callback_usage;
 		spin_unlock(&dum->lock);
 		_req->actual = _req->length;
 		_req->status = 0;
 		usb_gadget_giveback_request(_ep, _req);
 		spin_lock(&dum->lock);
+		--dum->callback_usage;
 	}  else
 		list_add_tail(&req->queue, &ep->queue);
 	spin_unlock_irqrestore(&dum->lock, flags);


