Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5861CAA81;
	Wed, 19 Mar 2025 14:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395236; cv=none; b=Rl9+xCcA3Pfq9ydkipP9YNJ/b+VH74JU/lz5IWYpY3gVvwbVxietV3jP1LKw3ziYT8FdhTOI+jjetfIC7OvnP0EexIC1ARxG2uwFXsUMRIkfJolHlMyhzEBOBOfNwwV17MkPU6z0UKTjHq4PBF8xPXPqAUnbo6adXXd2Pgs3ZUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395236; c=relaxed/simple;
	bh=i5XIyJkEbbk9ZytChK/2b/fz+lim/rZDtdYf/nzI2K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHIn3SN/dDmWDdj0kd57djJ52PZR1dXsFFmhCuU3ibWclcg4Jjqet8dD/neG/s2Az8hGfmPpOww3xNQL66c2Klu3B7qGAxvK3fTMm9szS95ygMvHNxpR7FqSbUeYuChn01AKfeSJpaV4dc6bG0Ghgu8iu0XAe35DJPmU/sPPTug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRw+B+Hu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRw+B+Hu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0780C4CEE4;
	Wed, 19 Mar 2025 14:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395235;
	bh=i5XIyJkEbbk9ZytChK/2b/fz+lim/rZDtdYf/nzI2K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRw+B+HurPy/hsja4pz5HduRte18QNFXJ7CpQcsBNQlw3nq4ssofjtGWEMMgHto3s
	 rwjzZQF21X4KVmzQ9bXqotHHAm0JqY+7KQIrnQESEbxSNpcBl1ZMwlieyBx3t0CgTw
	 SizM9DoePJI9y91PdRJAMXOI7zB5XWovE6ObldR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 108/166] Input: xpad - add support for ZOTAC Gaming Zone
Date: Wed, 19 Mar 2025 07:31:19 -0700
Message-ID: <20250319143022.941984990@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

commit 709329c48214ad2acf12eed1b5c0eb798e40a64c upstream.

ZOTAC Gaming Zone is ZOTAC's 2024 handheld release. As it is common
with these handhelds, it uses a hybrid USB device with an xpad
endpoint, a keyboard endpoint, and a vendor-specific endpoint for
RGB control et al.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://lore.kernel.org/r/20250222170010.188761-2-lkml@antheas.dev
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -349,6 +349,7 @@ static const struct xpad_device {
 	{ 0x1bad, 0xfa01, "MadCatz GamePad", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0xfd00, "Razer Onza TE", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0xfd01, "Razer Onza", 0, XTYPE_XBOX360 },
+	{ 0x1ee9, 0x1590, "ZOTAC Gaming Zone", 0, XTYPE_XBOX360 },
 	{ 0x20d6, 0x2001, "BDA Xbox Series X Wired Controller", 0, XTYPE_XBOXONE },
 	{ 0x20d6, 0x2009, "PowerA Enhanced Wired Controller for Xbox Series X|S", 0, XTYPE_XBOXONE },
 	{ 0x20d6, 0x281f, "PowerA Wired Controller For Xbox 360", 0, XTYPE_XBOX360 },
@@ -537,6 +538,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x1949),		/* Amazon controllers */
 	XPAD_XBOX360_VENDOR(0x1a86),		/* QH Electronics */
 	XPAD_XBOX360_VENDOR(0x1bad),		/* Harmonix Rock Band guitar and drums */
+	XPAD_XBOX360_VENDOR(0x1ee9),		/* ZOTAC Technology Limited */
 	XPAD_XBOX360_VENDOR(0x20d6),		/* PowerA controllers */
 	XPAD_XBOXONE_VENDOR(0x20d6),		/* PowerA controllers */
 	XPAD_XBOX360_VENDOR(0x24c6),		/* PowerA controllers */


