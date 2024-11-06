Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345DD1EF928;
	Wed,  6 Nov 2024 12:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897382; cv=none; b=AbtD32i1Xtd/1BPNesA8MUH/lf3EqR11pqdznN+E2SzMYn2biXIhMP071pQOJ51n4ODUdAo0Y+MkP/qsLnNUGghgB1Z1oL4EFoHQe+adHfVWW5JlsHr1XyG+4CHa9w0naN3ZovQfTmS14+cL773nYxwlEklng3E7/8CSdajrgek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897382; c=relaxed/simple;
	bh=oQPiGRFExUfLTVGEiXyfE5Hg9e112sxj582g4wpUVKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qpwu8iL3nbIH/s5S9AIIM0DSKazrhZNS8Mkpqz1uxPhAI08zHWdgGt/+fTY6BjPKi4GcvSAnsnbEREtNjqYk5YIeMpJ0uhnYHiOuCZ/NnR27rZ0hhkBxlgYJcunnvj5fYlxdWmuLNM9ODMD4558yoN1QjxGH3jrXfisjlNdFVF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9quAnOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9quAnOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC631C4CECD;
	Wed,  6 Nov 2024 12:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897382;
	bh=oQPiGRFExUfLTVGEiXyfE5Hg9e112sxj582g4wpUVKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9quAnOCIMwnvHzQQfcshAEGC46/KcL2tc/Blsch5ZwfhiMpOI1ELeoDW1tA8aXFE
	 xY4xaPYwMEGvPRET0HRLKACm+sMY78h44E7R6IMl25c3xjFhLZwluCBO177DOR8Tlo
	 qSIGlfkS+pGZiB3e+UPSJyoRNSphlr+ooY+9Or1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Kerkmann <s.kerkmann@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/151] Input: xpad - add support for 8BitDo Ultimate 2C Wireless Controller
Date: Wed,  6 Nov 2024 13:03:13 +0100
Message-ID: <20241106120308.989334911@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Kerkmann <s.kerkmann@pengutronix.de>

[ Upstream commit ea330429a04b383bd319c66261a5eca4798801e4 ]

This XBOX360 compatible gamepad uses the new product id 0x310a under the
8BitDo's vendor id 0x2dc8. The change was tested using the gamepad in a
wired and wireless dongle configuration.

Signed-off-by: Stefan Kerkmann <s.kerkmann@pengutronix.de>
Link: https://lore.kernel.org/r/20241015-8bitdo_2c_ultimate_wireless-v1-1-9c9f9db2e995@pengutronix.de
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index ebe243b79d819..0cfcad8348a6d 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -373,6 +373,7 @@ static const struct xpad_device {
 	{ 0x294b, 0x3404, "Snakebyte GAMEPAD RGB X", 0, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x2000, "8BitDo Pro 2 Wired Controller fox Xbox", 0, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x3106, "8BitDo Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
+	{ 0x2dc8, 0x310a, "8BitDo Ultimate 2C Wireless Controller", 0, XTYPE_XBOX360 },
 	{ 0x2e24, 0x0652, "Hyperkin Duke X-Box One pad", 0, XTYPE_XBOXONE },
 	{ 0x31e3, 0x1100, "Wooting One", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1200, "Wooting Two", 0, XTYPE_XBOX360 },
-- 
2.43.0



