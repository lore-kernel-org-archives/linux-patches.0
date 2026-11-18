Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058203;
	b=CXl6YOjFw067fYHdX3tXHcVBaO0RqScrfucHBoo1BirF+Lr7nq2b74gOcTwS9RCMVyNj
	 5ejyhZG4DSkFfXQAg4ql1l+9mUmLR0zAqAZYxDIBeCORjizCenP7gMPGxAKwWlNujyeyU
	 ZL3efurkW7XydhE7/37BSwHq0pKVVOg2Oyq8O3hGuXEx12T/jPNVWTcCI4QMsYg5bOYYg
	 NHzJ2V2rdEj8/X//9Ef4ladY+odzGxkKBJvPT80Zaclh+h+Hg+1S3Y0Tm8YVPtfOjpXTd
	 P9GpGQNIIuSfZKgBkkanDRumqIxW4SrHQO8IrTPxRnmbu6Zj4tKhOR5mskYzY/lXveg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RKAWep3Z9hWTag3c3lx9ahex3aulWOpVsvJk5rLbFf0=;
	b=hOHbxKqfxZ+y/AR9P+yB3pp1un56Odwau/3YmssMIWZTUiAPhK678klMZ9CgERPOrsmP
	 USkGcLoLfXQOQxITLneJ8Lc3Zt7kJ/QyoBt0IEx/8KaKkzE0Nwgdt22cnT8XETnv7vjgI
	 5jxrIVGlc9YMqJRqLZNE/rhcUuGke4AnR14NImCNBITPCH4pl75Zih5DHYiC+PKD+rTBK
	 LIh/+q4QQZFMcJvkPaHjFjVuVOuwI+6MgfbwtmSISI9KdUFbumXCQ7cqlA25xWsucSi88
	 eis0tGoih/nSX2LmN7rixgh9IlL7qahAAtMeo89gD93yFj957wgsNBk5A+hEDgTgZeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v1SAYz+K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0311A606A31C;
	Thu, 19 Nov 2026 03:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v1SAYz+K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2A31F000C4;
	Thu, 19 Nov 2026 03:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058202;
	bh=RKAWep3Z9hWTag3c3lx9ahex3aulWOpVsvJk5rLbFf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v1SAYz+KUhSlWs7y5grzYHSsnrRJjgLTSNXo5u06dvyCAgDzGEqvUyqW24dt82q72
	 GE38byMxazu2BWzk8n8EVx9rg3GPhZQngQyGlOgwE4GxdtVHMReEBNMySJM+DTN1jz
	 RJ2ojYkjSNXDLDKn2f17AiVXcTHEkYGEm8a0Q+vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0350/1848] media: redrat3: Ensure all urbs are suspended
Date: Wed, 18 Nov 2026 15:39:48 +0100
Message-ID: <20261118145927.381380396@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 1582f545273f2aa4eb4ee6f3a89b433f5c85c68f ]

Ensure that the learn urb is stopped before suspend.

Fixes: c49fcdde38cb ("[media] redrat3: enable carrier reports using wideband receiver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 1f42bc12cdc58..81dd6b9a938b7 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -1168,6 +1168,7 @@ static int redrat3_dev_suspend(struct usb_interface *intf, pm_message_t message)
 	usb_kill_urb(rr3->narrow_urb);
 	usb_kill_urb(rr3->wide_urb);
 	usb_kill_urb(rr3->flash_urb);
+	usb_kill_urb(rr3->learn_urb);
 	return 0;
 }
 
-- 
2.53.0



