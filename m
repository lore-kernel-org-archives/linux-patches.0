Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C934B3AEF5F;
	Wed,  8 Apr 2026 18:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674009; cv=none; b=OpG9duoj3c3k8rhRxrfSwlPmfZRlZ4Sqg523VNQQ+bcLJt0yhNcZySAtbI2hPDrOz2nRsj+UVgRi/JMAbK14GcwBrcmS5PUhea3nePMZ4AfQTxJqwldZljxd+Tg0w6szBwvknzA9OQKJgTIX7HS4NUr7PtJrvqnrqBBQqj+pS48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674009; c=relaxed/simple;
	bh=MdTWa08r4tif1XB+5DQHvZgQkZ6/lIZId6y3NqC+oHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jogkucc6EDf+HaGuIRtGQHAgWT2dT/OoZBIs3bjqqKfTY2M++XaxtdMbyom81cr3lahju72EvfX9D6PPt471bWu8/3cHTVdIq/EpXds3ec0xu86BraGpZEuguKuysSi2vw0XAT2GlNz2quHquYtCwCJAPUwnXo2NhsmeG5o1ENc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQXRzePg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQXRzePg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6098AC2BC87;
	Wed,  8 Apr 2026 18:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674009;
	bh=MdTWa08r4tif1XB+5DQHvZgQkZ6/lIZId6y3NqC+oHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQXRzePgTB3Qmx9VIanUNzA5iX4KW3RvrSoDb6aeTTLOoL9Q66FQxTO5CkMtweUgU
	 wXV7RZzcKGm+C326zcFISD1b8dJAIUiWC6rmTO4sVc2BDpdVnXygE8sKMCvs7DVrYz
	 qECBefhvXekRXfHl5NL/CtyJkI4XcGW1YTQmMfqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengyu Qu <wiagn233@outlook.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 146/242] Input: xpad - add support for BETOP BTP-KP50B/C controllers wireless mode
Date: Wed,  8 Apr 2026 20:03:06 +0200
Message-ID: <20260408175932.558308428@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Shengyu Qu <wiagn233@outlook.com>

commit 0d9363a764d9d601a05591f9695cea8b429e9be3 upstream.

BETOP's BTP-KP50B and BTP-KP50C controller's wireless dongles are both
working as standard Xbox 360 controllers. Add USB device IDs for them to
xpad driver.

Signed-off-by: Shengyu Qu <wiagn233@outlook.com>
Link: https://patch.msgid.link/TY4PR01MB14432B4B298EA186E5F86C46B9855A@TY4PR01MB14432.jpnprd01.prod.outlook.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -354,6 +354,8 @@ static const struct xpad_device {
 	{ 0x1bad, 0xfd00, "Razer Onza TE", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0xfd01, "Razer Onza", 0, XTYPE_XBOX360 },
 	{ 0x1ee9, 0x1590, "ZOTAC Gaming Zone", 0, XTYPE_XBOX360 },
+	{ 0x20bc, 0x5134, "BETOP BTP-KP50B Xinput Dongle", 0, XTYPE_XBOX360 },
+	{ 0x20bc, 0x514a, "BETOP BTP-KP50C Xinput Dongle", 0, XTYPE_XBOX360 },
 	{ 0x20d6, 0x2001, "BDA Xbox Series X Wired Controller", 0, XTYPE_XBOXONE },
 	{ 0x20d6, 0x2009, "PowerA Enhanced Wired Controller for Xbox Series X|S", 0, XTYPE_XBOXONE },
 	{ 0x20d6, 0x2064, "PowerA Wired Controller for Xbox", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
@@ -548,6 +550,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x1a86),		/* Nanjing Qinheng Microelectronics (WCH) */
 	XPAD_XBOX360_VENDOR(0x1bad),		/* Harmonix Rock Band guitar and drums */
 	XPAD_XBOX360_VENDOR(0x1ee9),		/* ZOTAC Technology Limited */
+	XPAD_XBOX360_VENDOR(0x20bc),		/* BETOP wireless dongles */
 	XPAD_XBOX360_VENDOR(0x20d6),		/* PowerA controllers */
 	XPAD_XBOXONE_VENDOR(0x20d6),		/* PowerA controllers */
 	XPAD_XBOX360_VENDOR(0x2345),		/* Machenike Controllers */


