Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBD2246326;
	Tue, 29 Apr 2025 17:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946164; cv=none; b=ZbARxkcHj8qz8uOVVTjdt7OfbrhJTV1UhGi3Q8Q8D10q59ImYw0WsTdyJY01U6FHyxbmkVAORnDvzogm+Jk1pAlUGl7RXyR3QgYLyUWWLVWsfsl1FSnPINMZpykiYNfNzukM25sUiW2iNySXs+cgqhALGQsMIXkk9mYUmbpUl60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946164; c=relaxed/simple;
	bh=/8iLxp1Xv9YOkE47A1Neyhil2JYc/q/rSbcLaAWBM+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyxXZeZVPLjNzUiDJDpu0TL6AWjp5xCbTa6ILsnh4s17e3OL3+sFunjJCnf+2FCSqIAaCF+hRwAiLkuoE12Awltn8c8oHLrss6qZsPaEUnzM9wY37Rhu8+n0f9gUkkndcd2FqxE37wvyaf2KCsH4003iJHG6lRJVMk93FwvJPQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OU6x2l4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OU6x2l4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B223FC4CEE3;
	Tue, 29 Apr 2025 17:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946164;
	bh=/8iLxp1Xv9YOkE47A1Neyhil2JYc/q/rSbcLaAWBM+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OU6x2l4jZCcZurcI5NStFbI6oT8lqK1Hc1/75BW47YoyfJ3ea71xkSbvLVLzzfQol
	 wy2lEebTX3VWOJC6p1dmVjooR1cg67gGCH2KpmnDqADJYbS/XrQcH+f5ykmWLV7R+4
	 BR97rxdHEm3CdPaviq+C/D0BdRS6hNCRBbkCHn80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.14 176/311] USB: wdm: add annotation
Date: Tue, 29 Apr 2025 18:40:13 +0200
Message-ID: <20250429161128.237526440@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


