Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A0B1DC9A7;
	Wed, 19 Mar 2025 14:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395101; cv=none; b=SaeJ9GxLYHnsLLDWuC4zXTEJHLDHXq4xcoP8Vz6bNbNuS75BwLqTVS6pk5I+zRJgWw8TqXVzQM8Vbodqm2SWfy2tIXOjMjyd0iWW/ShlZbdmXVuaWmDLGXmwPv9sBCQoy0daFMkaG1171KT8ECny3FgGN4jI5Z48ZimEPvTwnXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395101; c=relaxed/simple;
	bh=/ghVvRf1W28rwusnORAF/H3AJCu5SuaT+26rR4jrz48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHzC5YWVUo2BWJBvqimx/fUUHEikQb2H5KGeXg25mSWZX16Nc98WKB0Y8ym7Ov3i1OkPhYD2C1dtAfITi4wWNtVktbhphOY94hRRTkQuFiJrs73xUk5odKujSx5II7YKhvtalf21Lv3AlVdiNlo70Ssk4GRHpzI9WePADjwouc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyOPouH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyOPouH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E84C4CEE4;
	Wed, 19 Mar 2025 14:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395101;
	bh=/ghVvRf1W28rwusnORAF/H3AJCu5SuaT+26rR4jrz48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyOPouH/qUNe9j09TBjvkzW0ntFYqvGr6A0krEgu40P2fuCBHcLdgpy4lJkFyDgQl
	 0TtFWDGQxEenZWITkT6T1hfVd70HsdpNcce+VP9gRDnmO8nHXxxKeHj1xU6XHqn2eZ
	 CNLe7fjSswYQSnqtRdNVygX3tPCLXZmGm1vXxq2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 152/231] Input: xpad - add support for TECNO Pocket Go
Date: Wed, 19 Mar 2025 07:30:45 -0700
Message-ID: <20250319143030.591778511@linuxfoundation.org>
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

commit 95a54a96f657fd069d2a9922b6c2d293a72a001f upstream.

TECNO Pocket Go is a kickstarter handheld by manufacturer TECNO Mobile.
It poses a unique feature: it does not have a display. Instead, the
handheld is essentially a pc in a controller. As customary, it has an
xpad endpoint, a keyboard endpoint, and a vendor endpoint for its
vendor software.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://lore.kernel.org/r/20250222170010.188761-3-lkml@antheas.dev
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -382,6 +382,7 @@ static const struct xpad_device {
 	{ 0x2563, 0x058d, "OneXPlayer Gamepad", 0, XTYPE_XBOX360 },
 	{ 0x294b, 0x3303, "Snakebyte GAMEPAD BASE X", 0, XTYPE_XBOXONE },
 	{ 0x294b, 0x3404, "Snakebyte GAMEPAD RGB X", 0, XTYPE_XBOXONE },
+	{ 0x2993, 0x2001, "TECNO Pocket Go", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x2000, "8BitDo Pro 2 Wired Controller fox Xbox", 0, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x3106, "8BitDo Ultimate Wireless / Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x3109, "8BitDo Ultimate Wireless Bluetooth", 0, XTYPE_XBOX360 },
@@ -548,6 +549,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x2563),		/* OneXPlayer Gamepad */
 	XPAD_XBOX360_VENDOR(0x260d),		/* Dareu H101 */
 	XPAD_XBOXONE_VENDOR(0x294b),		/* Snakebyte */
+	XPAD_XBOX360_VENDOR(0x2993),		/* TECNO Mobile */
 	XPAD_XBOX360_VENDOR(0x2c22),		/* Qanba Controllers */
 	XPAD_XBOX360_VENDOR(0x2dc8),		/* 8BitDo Controllers */
 	XPAD_XBOXONE_VENDOR(0x2dc8),		/* 8BitDo Controllers */


