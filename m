Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CB3129A63;
	Tue, 23 Jan 2024 00:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968747; cv=none; b=ch3kruvgSPXm6Fc6KtTfnRozfSIdYa1jRqSqG9e71VE2XO6nWi7xYHxSbJ71DoE11iGAIKYHe2XkHaGF0dI3ZyX+oJmdYU+2chiHuQ/TTH4Jawoy1xCROkhs6sCZUjnQfaNiC1V1ZCjIZQXIlcVKWIav8qzyROkEIbZXzDO/b3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968747; c=relaxed/simple;
	bh=vzEDZx95EHBgh1Q0CPzRzpDtOU/23hDm6I+ufPcINMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHf49dSkKWLglKIuPE3fwWNtHFGM9PJ5FSB+V8L62+IIoSG1m01/3OWISWQh2/r1D5AGVu/XXyjFJQRdyr9P/pG9mdz8+n0wdJy1gPFxM4nkmEXzBPeP2kW/+A6RkdbTN6/KHlVPjUgER8oCfxA7aQ3hMFH1Hmj50n68zFnxGOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zv+uiDI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zv+uiDI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051DBC433F1;
	Tue, 23 Jan 2024 00:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968747;
	bh=vzEDZx95EHBgh1Q0CPzRzpDtOU/23hDm6I+ufPcINMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zv+uiDI0Fnu9XwS/DKX48q/pk/eCySn8bHoh8cgo9DDoIZNkIkwp1DiRR3qyPSk7T
	 04bfGft0YuCFPAGp7/YgbBinwts9h6MHROJTr9UenGiXDuUsH5/xtiGVmoVLvxDnq/
	 KMEgd9CIfdYY5Hr9mwwozXpJeYQaX2IRfAJNmQrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@z3ntu.xyz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/194] Input: xpad - add Razer Wolverine V2 support
Date: Mon, 22 Jan 2024 15:55:58 -0800
Message-ID: <20240122235720.423161417@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit c3d1610345b79cbe29ef6ca04a4780eff0d360c7 ]

Add the VID and PID of Razer Wolverine V2 to xpad_device.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Link: https://lore.kernel.org/r/20231125-razer-wolverine-v2-v1-1-979fe9f9288e@z3ntu.xyz
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index beedad0fe09a..239471cf7e4c 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -266,6 +266,7 @@ static const struct xpad_device {
 	{ 0x146b, 0x0604, "Bigben Interactive DAIJA Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1532, 0x0a00, "Razer Atrox Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x1532, 0x0a03, "Razer Wildcat", 0, XTYPE_XBOXONE },
+	{ 0x1532, 0x0a29, "Razer Wolverine V2", 0, XTYPE_XBOXONE },
 	{ 0x15e4, 0x3f00, "Power A Mini Pro Elite", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f0a, "Xbox Airflo wired controller", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f10, "Batarang Xbox 360 controller", 0, XTYPE_XBOX360 },
-- 
2.43.0



