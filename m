Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7663215F6C;
	Tue, 29 Apr 2025 17:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949445; cv=none; b=fziEJDzZzTwaxnbl8p92Xr2RHNuUSL/99ouBORj39lJUNcnWGXT2D0f6QZAgTpOD237gD41i4AtwTbNXZueGNp5cf/0kQhJKORrpdtbG+P0Qp14h2A5j3M4xdhsj1eLrEXwTkeOjijFxDbuP1n+A68f61HQFTvh8Nk3MNaRWpq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949445; c=relaxed/simple;
	bh=W/+O7G1JzfKMsDI6U+kLiSZ3MoHxFoQrBBsYl5/TVOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsM0U2WgPQiDs0RLpBrEjBWY1VnwCVhFlB7Gq1tngSNVD58Tww3d8axDg1KGpfRUzS1JbW9xb7BxpPMlSBb0mUPA9z9u2xjvWWkNUdIBnxo0RHt2C0UDjnlZDhBZrNIY/K1sUZ0PdkqK3MPGGIHPaltbWYs35uDfMoSeEA9Qvgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAsFPQJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAsFPQJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDB9C4CEE3;
	Tue, 29 Apr 2025 17:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949445;
	bh=W/+O7G1JzfKMsDI6U+kLiSZ3MoHxFoQrBBsYl5/TVOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAsFPQJ8+YFjucppj4wAsfLXVAiGvNW+DgAj6/wXabQiTqnUtAIfK0MHPbMFU0T3E
	 lqy3ptMfoiqbKrvzh+FnBW3MKigB4rOCMXJ/9WfTrqNPvNsDAx/uEU6QiO3CMeFo3D
	 Cp7MSNIOrpv/FHM9I2SCDUKZtrdZwZjo6tk4oweI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.15 322/373] USB: wdm: add annotation
Date: Tue, 29 Apr 2025 18:43:19 +0200
Message-ID: <20250429161136.370661404@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 73e9cc1ffd3650b12c4eb059dfdafd56e725ceda upstream.

This is not understandable without a comment on endianness

Fixes: afba937e540c9 ("USB: CDC WDM driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250401084749.175246-5-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -909,7 +909,7 @@ static int wdm_wwan_port_tx(struct wwan_
 	req->bRequestType = (USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE);
 	req->bRequest = USB_CDC_SEND_ENCAPSULATED_COMMAND;
 	req->wValue = 0;
-	req->wIndex = desc->inum;
+	req->wIndex = desc->inum; /* already converted */
 	req->wLength = cpu_to_le16(skb->len);
 
 	skb_shinfo(skb)->destructor_arg = desc;


