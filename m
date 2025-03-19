Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E0B1C4609;
	Wed, 19 Mar 2025 14:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394965; cv=none; b=OULudzWNHifhWCqnhpOFiXe1OoikGNRaS86fBOoTPuRdzBcMGFN7UC1RPBs48/eWKYZsVTbxe9akrNlDgJLK1Ek9VcdgOsjczI9njb77TQN0Xd7ZAeDS/OCMXVKdNoMsyST3ybLQPT15aqk2h/FU4ARC577PtZYN5G+SsG2G1Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394965; c=relaxed/simple;
	bh=NqHqoyUMG48TqibCSUQ9l8IdHSrdmYaWHrfEjpMe5Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOQ9QB8/63PW/J8TPpSaRMUGOYldzfy4or4X8aWKhh6CI0j02x4gQP9DjCCtQXh3hwNwr4xjAuKBHA6UoqRd/VPr8zzsYu7NnDNHdxm3qdfbrMtbAWNnozItYzSeFwpYp2D+mC72UabbZHfDUYq47rF9dlt3XCRySkaud3RaNoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPXyGyNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPXyGyNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86666C4CEE4;
	Wed, 19 Mar 2025 14:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394965;
	bh=NqHqoyUMG48TqibCSUQ9l8IdHSrdmYaWHrfEjpMe5Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPXyGyNY8tYPlofFJAtHQfNKIGyXcWZ2fMmRpm1NSOv1601ZyFo1+F8L6bPu5YGIO
	 gfYZB3an0KZsWaNVY7r2GCZKPVs9l0npnChwaB9yuIMZPh+mBVZP/Py/ahzPvVGdtx
	 J+cK+cRuXzM5qqdZ0JsGEiKlkUZuweRa2Xxyx9io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.13 157/241] Input: xpad - rename QH controller to Legion Go S
Date: Wed, 19 Mar 2025 07:30:27 -0700
Message-ID: <20250319143031.609340949@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

commit 659a7614dd72e2835ac0b220c2fa68fabd8d1df9 upstream.

The QH controller is actually the controller of the Legion Go S, with
the manufacturer string wch.cn and product name Legion Go S in its
USB descriptor. A cursory lookup of the VID reveals the same.

Therefore, rename the xpad entries to match.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://lore.kernel.org/r/20250222170010.188761-4-lkml@antheas.dev
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -312,7 +312,7 @@ static const struct xpad_device {
 	{ 0x1689, 0xfe00, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x17ef, 0x6182, "Lenovo Legion Controller for Windows", 0, XTYPE_XBOX360 },
 	{ 0x1949, 0x041a, "Amazon Game Controller", 0, XTYPE_XBOX360 },
-	{ 0x1a86, 0xe310, "QH Electronics Controller", 0, XTYPE_XBOX360 },
+	{ 0x1a86, 0xe310, "Legion Go S", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0002, "Harmonix Rock Band Guitar", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0003, "Harmonix Rock Band Drumkit", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0130, "Ion Drum Rocker", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
@@ -538,7 +538,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x1689),		/* Razer Onza */
 	XPAD_XBOX360_VENDOR(0x17ef),		/* Lenovo */
 	XPAD_XBOX360_VENDOR(0x1949),		/* Amazon controllers */
-	XPAD_XBOX360_VENDOR(0x1a86),		/* QH Electronics */
+	XPAD_XBOX360_VENDOR(0x1a86),		/* Nanjing Qinheng Microelectronics (WCH) */
 	XPAD_XBOX360_VENDOR(0x1bad),		/* Harmonix Rock Band guitar and drums */
 	XPAD_XBOX360_VENDOR(0x1ee9),		/* ZOTAC Technology Limited */
 	XPAD_XBOX360_VENDOR(0x20d6),		/* PowerA controllers */


