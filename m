Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876642E339B;
	Tue, 15 Jul 2025 13:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586176; cv=none; b=A+4Lb6NXCJF04PiBAXRBE+sVveefEWUTfxEXATL0BZVmNPz8sLchldn/3aPrOJsta5CJdpvt2mw2csVVYBEZL14aUGv7+0lPqr+DzZ1WJf7HUcRIv989yc9OZaUxtg5FgeeHEWYXx/uLMQrjFJRiO2euRgqgNbiMFJE44Qj0EWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586176; c=relaxed/simple;
	bh=fpVtx7qnYW0qcePDCWiXsB9DEcEe4/ya4wbjBBinrbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AViPuCbwr/N+M6gclHLvqNSubBcCdT6pz6jlQbHE6Xf6kWjPyTjuBLA1yRBnVfnBWZon5Uffjq3zKgP1QeHco8IMNdZm8zDlNCi/NNC1PdyiloUoWNI4yrFOi3wppzga1IFGOW8b5DzZH1UYLUBhz1+jfh7ekxH9xPTPIx3dIDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpDfQuHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpDfQuHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F8BC4CEE3;
	Tue, 15 Jul 2025 13:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586176;
	bh=fpVtx7qnYW0qcePDCWiXsB9DEcEe4/ya4wbjBBinrbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpDfQuHvYcEIHTVGNoq/tG/M2ubY5Iv+pt2ILTYtzSYnsva7trvV3mD3E8sFbfAkC
	 5wI41VKsoIF1biq8bhl4pMltizdaQ837d69tCZJJZKtr/7dY0AfPwc5ZejSosSMVmK
	 CER4ssDxNoKUVbGdW+bSyLXQOo4G/6kDtTBxYzP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilton Perim Neto <niltonperimneto@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 45/77] Input: xpad - support Acer NGR 200 Controller
Date: Tue, 15 Jul 2025 15:13:44 +0200
Message-ID: <20250715130753.521575109@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilton Perim Neto <niltonperimneto@gmail.com>

[ Upstream commit 22c69d786ef8fb789c61ca75492a272774221324 ]

Add the NGR 200 Xbox 360 to the list of recognized controllers.

Signed-off-by: Nilton Perim Neto <niltonperimneto@gmail.com>
Link: https://lore.kernel.org/r/20250608060517.14967-1-niltonperimneto@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 98397c2c6bfac..a5207d6a5ebea 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -149,6 +149,7 @@ static const struct xpad_device {
 	{ 0x05fd, 0x107a, "InterAct 'PowerPad Pro' X-Box pad (Germany)", 0, XTYPE_XBOX },
 	{ 0x05fe, 0x3030, "Chic Controller", 0, XTYPE_XBOX },
 	{ 0x05fe, 0x3031, "Chic Controller", 0, XTYPE_XBOX },
+	{ 0x0502, 0x1305, "Acer NGR200", 0, XTYPE_XBOX },
 	{ 0x062a, 0x0020, "Logic3 Xbox GamePad", 0, XTYPE_XBOX },
 	{ 0x062a, 0x0033, "Competition Pro Steering Wheel", 0, XTYPE_XBOX },
 	{ 0x06a3, 0x0200, "Saitek Racing Wheel", 0, XTYPE_XBOX },
@@ -443,6 +444,7 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x045e),		/* Microsoft X-Box One controllers */
 	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */
+	XPAD_XBOX360_VENDOR(0x0502),		/* Acer Inc. X-Box 360 style controllers */
 	XPAD_XBOX360_VENDOR(0x056e),		/* Elecom JC-U3613M */
 	XPAD_XBOX360_VENDOR(0x06a3),		/* Saitek P3600 */
 	XPAD_XBOX360_VENDOR(0x0738),		/* Mad Catz X-Box 360 controllers */
-- 
2.39.5



