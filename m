Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1453C13C9C4;
	Mon, 17 Aug 2026 14:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976789; cv=none; b=nuoPJmPQ2LtP0mnZCtYXmp0ksTkJM3yMTHV8p7eVz+4WQQgDdKGfqp+8lDQyXgryUDX8IqGVVVwIjpqLp1QyHvER18M8Ulu6h/BdWB0H4VvryAONf8/kyH3Y1p9tuaf7WYbknz4Jt1SW9G10SH1akhjxwwwPo/HG2p5Du3NinIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976789; c=relaxed/simple;
	bh=u/sPnUsNVAKjlB3uiNj5jxnDOzzctBCacYeJpFvcB2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIKNTPpBSxdi9Yj7UEj4e1idE07HkhfEIuVv3FT1yXr8VXLDaR3jE4bgeB6/niBqwR1R4kwV6PtReSvN2990pbuWW+u+8eHtY8IhZkkGs/CebrCFdv/ko/0dvczwLof184GGOr9KOxHnaSuvKO5k0rwvmL+IHg0YBqmeuUJh0P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUdOnBdQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUdOnBdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9081F000E9;
	Mon, 17 Aug 2026 14:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976788;
	bh=wzr6hXJtxX75rnrB4gAg8kqHIfg9H9JE24JQjFyEGrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUdOnBdQzimGF1gEfEtj3uEN0RwDg1PO13v3XWVYW4h4rIrLa8iBs9wmP3KpPCeO8
	 SlNeEa0I4vr7oBuTKALEJ+wSM3jpFGaZFTgGCLWJHC6/8x1u1u3gF58KAPoVtR6+oy
	 j/cQ0rJ4Mhhaod9z8ucKfEFH5oCqYsJsTY87R32w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 065/456] USB: gadget: snps-udc: fix device name leak on probe failure
Date: Mon, 17 Aug 2026 15:27:35 +0200
Message-ID: <20260817132542.592200245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Johan Hovold <johan@kernel.org>

commit 29a142d3e8b35ebc9e0bcc78f4bc26c9b6a9ac0b upstream.

The gadget device name is set by UDC core when registering the gadget
and must not be set before to avoid leaking the name in intermediate
error paths (e.g. when detecting an older chip revision).

Fixes: 12ad0fcaf2fb ("usb: gadget: amd5536udc: let udc-core manage gadget->dev")
Cc: stable <stable@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260702141536.90887-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/snps_udc_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/gadget/udc/snps_udc_core.c
+++ b/drivers/usb/gadget/udc/snps_udc_core.c
@@ -3134,7 +3134,6 @@ int udc_probe(struct udc *dev)
 	/* device struct setup */
 	dev->gadget.ops = &udc_ops;
 
-	dev_set_name(&dev->gadget.dev, "gadget");
 	dev->gadget.name = name;
 	dev->gadget.max_speed = USB_SPEED_HIGH;
 


