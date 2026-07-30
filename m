Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1589F440A06;
	Thu, 30 Jul 2026 15:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425590; cv=none; b=Kos6ATVPSlKG1Dfik3hIrnXKS9cke5l7dQUCWzGTamP/KZ2CRdVwC6w6VFnu/ZVDBYD3obF++Sxyb0mpeaWdNVcQ5atehW2rrGecF8wZOdlO3+uv7cFmyutIXbmoz0W09DpXOzWfsl5Np0gZgowLHAzQ+ZpkaQ+PWwhb9oHtZQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425590; c=relaxed/simple;
	bh=Lddof7WTXsOryOAhb3VPBJjWsPX/+CYFFmbRLCriYWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Krxc7PKGIkna223fxmsP5/V/jTFRXK/ZYZz4AFgkN8OIXY+weDTNIjyAgtAo+zRkZl8SEXCKwP4//n7kHXnP7spzRsjNkn0PazBrULIeXBkadxKxn05w3X4vuObmFoyQ8LzRCcKcFIwhB1+8ZPwRxvarsPowRAVVibySMDmQ6L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03P4klDF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03P4klDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705E21F00A3A;
	Thu, 30 Jul 2026 15:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425589;
	bh=ALUfsxp2Iqemx3XiVGWBDw2dsovC6G3Vt/WI+VZ0dKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=03P4klDFvQCtBbwTYXWNdexEKs0rtK5/gNPuzZVGNiKKeAPYP20+hhKWRV0iVZ8IQ
	 hPrt70tmWf0iHlaq6kv9hJI6aci2pfqs9dgJpklXG3KvoQW5XSeKeAwpFELAdUtUnY
	 LM0ldoDYVv/2kqCicKCadf4gOBlwt39E+vq2zAD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 121/602] USB: gadget: snps-udc: fix device name leak on probe failure
Date: Thu, 30 Jul 2026 16:08:33 +0200
Message-ID: <20260730141438.533415909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3133,7 +3133,6 @@ int udc_probe(struct udc *dev)
 	/* device struct setup */
 	dev->gadget.ops = &udc_ops;
 
-	dev_set_name(&dev->gadget.dev, "gadget");
 	dev->gadget.name = name;
 	dev->gadget.max_speed = USB_SPEED_HIGH;
 


