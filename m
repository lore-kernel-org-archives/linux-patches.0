Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A54C1D558;
	Thu, 11 Apr 2024 10:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831325; cv=none; b=K2JX3x7mP69uiNWryBwFVjvRT8It0KxhVUYR/0BzHAuYKI2YPOAmVkQ/i564pmrMTdSp/Lr6tmY7IIZMBqOlBqF/o0K5F3GiAiDd4wMDLtp4GGt0JxlvsWgi1hB1T0No3immN0MUVbTqmim+XKyd1Kp05HH+y9iTMpJcj6RQm08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831325; c=relaxed/simple;
	bh=yYeS7sFsVkuad5w3Ots0wO0zLL6WY0KOeTvA6NjdMN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGsZ3kXa6uh+X4B6QnGEvYHm/psX8GHKOTbqEdl50a2cGh18RZzHDENjhph8nun8pkojSeHWTDTIvye88GEbrDn8ctm3E3jdb73ep8fcI59WioQJgAkEHbHpSEGwINQEgnXexVD907cXcEspf8zwK+lb+FqpQbMinkauNmu+aSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/yyKExy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/yyKExy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87F8C433F1;
	Thu, 11 Apr 2024 10:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831325;
	bh=yYeS7sFsVkuad5w3Ots0wO0zLL6WY0KOeTvA6NjdMN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/yyKExyMygd4ixXIUZ0BlZ2xOxBb36frjaXkdA0PoLvssKGRoq371PO/CjENOyOe
	 2ejWFHiQLQZkjAk3it3qKuluz35PHXdEXz8cJoUxqh3pqbH3WYNOWU3tLjlFmFakk8
	 seFpFmfmSoF9wf+1LOHFK5skX/Tw8iJdcP/QhbPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Scialabba <matt.git@fastmail.fm>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/114] Input: xpad - add support for Snakebyte GAMEPADs
Date: Thu, 11 Apr 2024 11:56:51 +0200
Message-ID: <20240411095419.425265071@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

From: Matt Scialabba <matt.git@fastmail.fm>

[ Upstream commit 81c32343d04f8ca974681d5fb5d939d2e1f58851 ]

Add Snakebyte GAMEPAD BASE X and Snakebyte GAMEPAD RGB X to the list
of supported devices.

Signed-off-by: Matt Scialabba <matt.git@fastmail.fm>
Link: https://lore.kernel.org/r/efbfb428-06b0-48f9-8701-db291c2a9d65@app.fastmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index c11af4441cf25..9206253422016 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -366,6 +366,8 @@ static const struct xpad_device {
 	{ 0x24c6, 0x5d04, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0xfafe, "Rock Candy Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x2563, 0x058d, "OneXPlayer Gamepad", 0, XTYPE_XBOX360 },
+	{ 0x294b, 0x3303, "Snakebyte GAMEPAD BASE X", 0, XTYPE_XBOXONE },
+	{ 0x294b, 0x3404, "Snakebyte GAMEPAD RGB X", 0, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x2000, "8BitDo Pro 2 Wired Controller fox Xbox", 0, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x3106, "8BitDo Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1100, "Wooting One", 0, XTYPE_XBOX360 },
@@ -507,6 +509,7 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOXONE_VENDOR(0x24c6),		/* PowerA controllers */
 	XPAD_XBOX360_VENDOR(0x2563),		/* OneXPlayer Gamepad */
 	XPAD_XBOX360_VENDOR(0x260d),		/* Dareu H101 */
+       XPAD_XBOXONE_VENDOR(0x294b),            /* Snakebyte */
 	XPAD_XBOX360_VENDOR(0x2c22),		/* Qanba Controllers */
 	XPAD_XBOX360_VENDOR(0x2dc8),            /* 8BitDo Pro 2 Wired Controller */
 	XPAD_XBOXONE_VENDOR(0x2dc8),		/* 8BitDo Pro 2 Wired Controller for Xbox */
-- 
2.43.0



