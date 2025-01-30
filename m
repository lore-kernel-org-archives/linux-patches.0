Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4AA8BFF;
	Thu, 30 Jan 2025 14:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247461; cv=none; b=KePoZYdzT2LEwIpAkZQz+c6iPUYTtPWFI2ZIXDWN8jOtuNzhRJZKtWueFZF0BmPa+cTz2H7RyM37f2H3UUVr09dhxMvsfTDt47DGkXm4SGcMV5SVLmbYipdzfMWTTgmDMpPNXZHFZiFSyrGu9TKaAD5CI/9ZZkAdIwcy1EQmzCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247461; c=relaxed/simple;
	bh=RU4D9JvSrPeHNSV9eQg8U7137h5lmywHegmklcEMf2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYIR7XGlC5ccan1y7t8uxAVI5NSwDCaeUj0H76ct9SuUMh1jGXsCV1Wcsayaku2jZtekX9gk0Uk0qeAXhNDUiyvOPXRIK2i4Juz+m5ENPQ9SnM/D6XB9oDM35uL9PXw1ZTUrVvc4Iysz8PKkCFpkCbVBPfDxNQMy87gbT9kjWGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WG//ClCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WG//ClCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67810C4CED2;
	Thu, 30 Jan 2025 14:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247460;
	bh=RU4D9JvSrPeHNSV9eQg8U7137h5lmywHegmklcEMf2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WG//ClCqqmflriNszlyO1ktkf3zcrpuX/z4mcf/qfu07jUs9MG4M4n6IR7XzP+MA3
	 ywUU4U2W2Gz/okYjR00JMBWVIohF3UxKiyv2gQwJc0xIpCtbwBAx8o66VWdqL5UD/1
	 neXObSRTiFlaDlsqFLBznmgu2Gin2pAriyPG/Cuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilton Perim Neto <niltonperimneto@gmail.com>,
	Pavel Rojtberg <rojtberg@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 46/49] Input: xpad - add unofficial Xbox 360 wireless receiver clone
Date: Thu, 30 Jan 2025 15:02:22 +0100
Message-ID: <20250130140135.674528126@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilton Perim Neto <niltonperimneto@gmail.com>

commit e4940fe6322c851659c17852b671c6e7b1aa9f56 upstream.

Although it mimics the Microsoft's VendorID, it is in fact a clone.
Taking into account that the original Microsoft Receiver is not being
manufactured anymore, this drive can solve dpad issues encontered by
those who still use the original 360 Wireless controller
but are using a receiver clone.

Signed-off-by: Nilton Perim Neto <niltonperimneto@gmail.com>
Signed-off-by: Pavel Rojtberg <rojtberg@gmail.com>
Link: https://lore.kernel.org/r/20250107192830.414709-12-rojtberg@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -145,6 +145,7 @@ static const struct xpad_device {
 	{ 0x045e, 0x028e, "Microsoft X-Box 360 pad", 0, XTYPE_XBOX360 },
 	{ 0x045e, 0x028f, "Microsoft X-Box 360 pad v2", 0, XTYPE_XBOX360 },
 	{ 0x045e, 0x0291, "Xbox 360 Wireless Receiver (XBOX)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360W },
+	{ 0x045e, 0x02a9, "Xbox 360 Wireless Receiver (Unofficial)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360W },
 	{ 0x045e, 0x02d1, "Microsoft X-Box One pad", 0, XTYPE_XBOXONE },
 	{ 0x045e, 0x02dd, "Microsoft X-Box One pad (Firmware 2015)", 0, XTYPE_XBOXONE },
 	{ 0x045e, 0x02e3, "Microsoft X-Box One Elite pad", MAP_PADDLES, XTYPE_XBOXONE },


