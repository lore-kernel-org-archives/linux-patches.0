Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C95332692B;
	Wed,  8 Apr 2026 19:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674820; cv=none; b=NvftJlZmU2WUYe5w0JXZdB5bvRPxnVRvbT8S0kmvwaf9tMYJJ2CnVIFG+/2fn8eK9VYzqMJcS5kTEk6jHyv+ELn6UT1/4jNkXzJFiG48dgMVdTSvvpiQRI6qZL2u3/yhLmeyfqDbk3QURUQ8CoTVqT/YUXI9eAY0p48abhlAC4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674820; c=relaxed/simple;
	bh=wpO0Toxa+FobcNptLefx23CeL9sPulQsr6AiybseePM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAQCA3fUlqA3W/LgHUCFfGkhfOjAgQV8atE7BAxS4DH4WyEk2lpFHdpM4sbFyXR1rvEFZNGB9tzJz1ZPckXO0BKFTfEeUyS+SrgdsvGwkRvLhUVzAtJuHnL/A5ogiNkqC9NVtAFxiliTJyU+wBNZQJdUmFYX9U/1H0CLrvWr2VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXit0ERJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXit0ERJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95515C2BC9E;
	Wed,  8 Apr 2026 19:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674819;
	bh=wpO0Toxa+FobcNptLefx23CeL9sPulQsr6AiybseePM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXit0ERJT36S30gijXIRZE9//NNo3QNNhVh8lDa0QWuXgChVwYkntM1lhIUWxj942
	 YHpchIhpsjymLXnHj9n6VMwP1IJYcQ4ZX9C6oSSsMxHfCjFvZlMkgw2YIjBM9zP4GA
	 6bypN7aPYXYWIhLgtMW5VtoTdsXlpN8aFwezjD0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengyu Qu <wiagn233@outlook.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.19 213/311] Input: xpad - add support for BETOP BTP-KP50B/C controllers wireless mode
Date: Wed,  8 Apr 2026 20:03:33 +0200
Message-ID: <20260408175947.356454336@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -360,6 +360,8 @@ static const struct xpad_device {
 	{ 0x1bad, 0xfd00, "Razer Onza TE", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0xfd01, "Razer Onza", 0, XTYPE_XBOX360 },
 	{ 0x1ee9, 0x1590, "ZOTAC Gaming Zone", 0, XTYPE_XBOX360 },
+	{ 0x20bc, 0x5134, "BETOP BTP-KP50B Xinput Dongle", 0, XTYPE_XBOX360 },
+	{ 0x20bc, 0x514a, "BETOP BTP-KP50C Xinput Dongle", 0, XTYPE_XBOX360 },
 	{ 0x20d6, 0x2001, "BDA Xbox Series X Wired Controller", 0, XTYPE_XBOXONE },
 	{ 0x20d6, 0x2009, "PowerA Enhanced Wired Controller for Xbox Series X|S", 0, XTYPE_XBOXONE },
 	{ 0x20d6, 0x2064, "PowerA Wired Controller for Xbox", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
@@ -562,6 +564,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x1a86),		/* Nanjing Qinheng Microelectronics (WCH) */
 	XPAD_XBOX360_VENDOR(0x1bad),		/* Harmonix Rock Band guitar and drums */
 	XPAD_XBOX360_VENDOR(0x1ee9),		/* ZOTAC Technology Limited */
+	XPAD_XBOX360_VENDOR(0x20bc),		/* BETOP wireless dongles */
 	XPAD_XBOX360_VENDOR(0x20d6),		/* PowerA controllers */
 	XPAD_XBOXONE_VENDOR(0x20d6),		/* PowerA controllers */
 	XPAD_XBOX360_VENDOR(0x2345),		/* Machenike Controllers */


