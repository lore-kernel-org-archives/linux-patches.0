Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26212EEE73;
	Mon, 17 Aug 2026 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979013; cv=none; b=lC3qADBYA7C0/WFtaQB8ZEPaCJnGjxuDP+6dFR51Ef318MgyyL8Gh4Gj2ASaoS1IHUW5XIC8KpI6b5sj5yea3iI540aTCXoDiT5yoo4ivwVLFqAmgHhqd/iyior4YxZAD4Km17YbozLAkXNUWgj/gahb4PwajOWJKIJEldt6Ms0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979013; c=relaxed/simple;
	bh=9vsOktc66SbX2t3mXdAGRERsYXXPG7/hzl0ItH2PJSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILcaBG/PRCXfG3DZzh0+zh5udEmZWVh6tfrbhpTtIyqucORA4TDVdIWgS+Oh3qwsG9rU1wkuUJoQ5w0tI+Z9npxsYnd4ElTo/CnysTcqgLb+8y2Bnhtv/90wmtA3CIRybFBYq7x0vTVlnRzcrBIqq2T6NZQupvx7CjzdcF7Ysko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppvIAq/9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppvIAq/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E901F000E9;
	Mon, 17 Aug 2026 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979012;
	bh=+lvHPzcxs1HKeo/yuukb7cbCXlbaMHHhs5O2q0BW0YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppvIAq/912gWWaHrHGW3IaIKHEzwFZIHGDU0G50zeWsgrah/MnP0z/3/wucWza8kB
	 KrI2xQbbRfhKpSrdW5StZSlJbokzNAeeKahe7kG3Q/EXtPdaQHQjODITl0CI5kngJz
	 wF18+45mgT6crvQ1IIbuTzyKxteTxjpq3Hwv+HOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 079/609] USB: gadget: snps-udc: fix device name leak on probe failure
Date: Mon, 17 Aug 2026 15:26:15 +0200
Message-ID: <20260817132546.196515203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


