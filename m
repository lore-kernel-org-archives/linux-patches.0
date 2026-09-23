Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63D2418368;
	Wed, 23 Sep 2026 14:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173398; cv=none; b=OU+1w3xMhLlKR8jMxvE6KVlauULFW9wYy5Ze33YSAJlkLoMTKtqrWaEKNL4kp1b7oBYRvE+9YQrTqiBrrcVdNQ2WIkHp5atVyji2aoiGeJ8f2XEDPtdi9TGH21KX3y9UTvnIxZ86WirsOTgMoAIDPNrr/8E0XjjyeB0/5y4y2FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173398; c=relaxed/simple;
	bh=XWhwDMUTVYZioqRDzPe8LCPTxMFqHllxR6dI1GmmZ80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/nyoUWBqyketou+MfEk0Yx1kfn/1Q0lL1KF0/VW/SCoyOCBp6nzkMiaUMKGQFOnxpcYBjPiObXuFiuTg5SoOpG+7Whxf3id0AOyOiwh3Ab8b8kObXM9w4OEUW7BHN4GvJ2z7u7wijqlfcn737SRcGFc2EEpy/CJZRYv1njXFa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kl+T/Zzq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kl+T/Zzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFD21F000FF;
	Wed, 23 Sep 2026 14:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173396;
	bh=f6DLjb+0GqxjgsNAEA9f6A7OwUfBxZ9lv/waTHrSJMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kl+T/Zzqhd+ViVK0tgf171AHNdtrdEQz4popQ9KFM57Q3iGKN2/5z0p30dYmGknYC
	 J9d45vNB0BjhoK4EmtyUHrmqU+CeRDy7nyRi9HRpmVxoQ/I8Hu2ThDRyB4qraXokR+
	 UTcLXzDLl4EtHdAF0H4pYpMMM+F/F4ZeH1MrLpII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberts Kursitis <roberts.kursitis@azeron.eu>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 234/438] Input: xpad - add support for Azeron devices
Date: Wed, 23 Sep 2026 16:04:15 +0200
Message-ID: <20260923140650.834351351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roberts Kursitis <roberts.kursitis@azeron.eu>

commit cba76c0f47af1a389d718c5bb69e75cbd67bba98 upstream.

Azeron controllers (Cyro, Cyborg, Classic/Compact, Cyro Lefty,
Cyborg II and Keyzen) present a standard Xbox 360 controller
interface, so they work with the existing xpad driver once their
USB IDs are added.

The 0x16d0 vendor ID is a shared block, but this is safe because
xpad only binds interfaces that match the Xbox 360 signature.

Tested with an Azeron Keyzen.

Signed-off-by: Roberts Kursitis <roberts.kursitis@azeron.eu>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260906143040.162418-1-roberts.kursitis@azeron.eu
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -293,6 +293,12 @@ static const struct xpad_device {
 	{ 0x1689, 0xfd00, "Razer Onza Tournament Edition", 0, XTYPE_XBOX360 },
 	{ 0x1689, 0xfd01, "Razer Onza Classic Edition", 0, XTYPE_XBOX360 },
 	{ 0x1689, 0xfe00, "Razer Sabertooth", 0, XTYPE_XBOX360 },
+	{ 0x16d0, 0x1103, "Azeron Cyro", 0, XTYPE_XBOX360 },
+	{ 0x16d0, 0x113c, "Azeron Cyborg", 0, XTYPE_XBOX360 },
+	{ 0x16d0, 0x1192, "Azeron Classic/Compact", 0, XTYPE_XBOX360 },
+	{ 0x16d0, 0x1212, "Azeron Cyro Lefty", 0, XTYPE_XBOX360 },
+	{ 0x16d0, 0x12f7, "Azeron Cyborg II", 0, XTYPE_XBOX360 },
+	{ 0x16d0, 0x13ea, "Azeron Keyzen", 0, XTYPE_XBOX360 },
 	{ 0x17ef, 0x6182, "Lenovo Legion Controller for Windows", 0, XTYPE_XBOX360 },
 	{ 0x1949, 0x041a, "Amazon Game Controller", 0, XTYPE_XBOX360 },
 	{ 0x1a86, 0xe310, "Legion Go S", 0, XTYPE_XBOX360 },
@@ -535,6 +541,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x15e4),		/* Numark Xbox 360 controllers */
 	XPAD_XBOX360_VENDOR(0x162e),		/* Joytech Xbox 360 controllers */
 	XPAD_XBOX360_VENDOR(0x1689),		/* Razer Onza */
+	XPAD_XBOX360_VENDOR(0x16d0),		/* Azeron controllers */
 	XPAD_XBOX360_VENDOR(0x17ef),		/* Lenovo */
 	XPAD_XBOX360_VENDOR(0x1949),		/* Amazon controllers */
 	XPAD_XBOX360_VENDOR(0x1a86),		/* Nanjing Qinheng Microelectronics (WCH) */


