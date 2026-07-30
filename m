Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1778A430CC8;
	Thu, 30 Jul 2026 14:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421564; cv=none; b=Gu0tebV3rONM5OVIH4vJ8ZwzKFkRFuDWwTIgsoTfpY6ds70cvCEWTbG60F3W6/udrvoZK787UiBJk/eMBS3taUMUy/ReDsP/IjKTuhqGJ6Ouo9EndDLyztzEGmJx9WvUIFrHkpqffiCP0PLlfCjD35qX49r+FaoqLqtTa6ieQkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421564; c=relaxed/simple;
	bh=vjyYJJxVOIFWpsbRQ7PlSr7LVYAiyKeVsWcsgeRQu2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvCrOCKOnMXvDbBvdfKazfS2sZS+oohGcokZOvN3FSBOYAIqEvlF3xPNzD6x7+xrXsCqsneAKcbuQ0Y5gTfNL9RyQzzimHcHOs7veF+Puol2mJnAYp2XK5q7xjJJvvcehfVAKcudd8mleIhgKMpOSKSeFySMauSm7qzYyzr4xxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9miR4x8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9miR4x8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4881F000E9;
	Thu, 30 Jul 2026 14:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421563;
	bh=GoZwsWtEOPnZW0cY5SHFGXVxlKBvP6Vb2f7sEUtWH3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9miR4x8ZkIJxY/GiJnrgZ9COrbpT1oybNF/kw6RYEllICEtk/h7gQI0UzKAEMNZ8
	 2UYtovx8i7nFVV6/MOX5eyDyCR/pdZLuroOdOJDDPk5xbEN7fan+wGK0IISmTlLpQa
	 Nv0bjtdD6cEp5aSjVomAZ7TXc0btm6SVtdfG2FtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.1 146/744] USB: gadget: snps-udc: fix device name leak on probe failure
Date: Thu, 30 Jul 2026 16:06:59 +0200
Message-ID: <20260730141447.390105337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


