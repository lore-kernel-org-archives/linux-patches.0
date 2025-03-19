Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C621DC9A7;
	Wed, 19 Mar 2025 14:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395101; cv=none; b=ZwSfDpW7DHDDxqON1hzrr3ZVjJ8iukUzva8wZMg7P2eYHXP4B/TYOaCPMjeHXwVj3j4jM5E7GL+tvz3pANM2ZERZJ9aBOAC9uD5wEXrpIgN08MDsZnbY0dqNsSvehW0bo8SgocWChZFzy1Ys3QOwA1k4WQ5fCrW4zM2efGJs4s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395101; c=relaxed/simple;
	bh=fMp7MJX63AiJOQLESaoFX1/9du1rRQYWk7ma5slxVEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhfkvFRs1PpWnDIAGKfwkbNAjVkb9gUaN6L8KKN48eoSNRp9lf+0SHBBmpzyj1WhJE06AFGvlgOOmI0pgYzH+w/QDD2fsC8BKbONK6N9HYfB3Rn4Pj+Ot++PEQ+G6Uvl3RZPVKsSoHEXgm8Qt0OPCoFCJOC6Vvqzobi+IPfO2Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuympGKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuympGKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67F5C4CEE4;
	Wed, 19 Mar 2025 14:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395101;
	bh=fMp7MJX63AiJOQLESaoFX1/9du1rRQYWk7ma5slxVEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuympGKrr702zhC+jwvmxh4xlnxXDtKc9tz8Fzn7Vl7YC1hzBXSx2+cQhpaKnvRS8
	 8v49+ONAprPHrdxXt5sPdGlQx3oDG7Zgwu1Vy9khM4jfTcLXUkFOGKMJYkyQ1Jh4DQ
	 BN3tMZ7UcpCLKOZZdo9tXG7SS3KCbVNdoJU4nc0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 153/231] Input: xpad - rename QH controller to Legion Go S
Date: Wed, 19 Mar 2025 07:30:46 -0700
Message-ID: <20250319143030.615558226@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


