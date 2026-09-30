Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C218E4F85BE;
	Wed, 30 Sep 2026 15:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783494; cv=none; b=s7SskgYvhyT0t2aPbqNVzxV7AmG2DFpSmU3XYH1yB5b0fRFpq6HUt/NUyyvZljnW1hJ09zwdnUUB+af752LiJILAj0oZgo9WVoaVSxwWb8JA2v/BgXx2Cn9F0HLdbEctwTlXNXYxle72LOf/QLakyJukKXjw6q2SydjPSLR8tzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783494; c=relaxed/simple;
	bh=6+HZWu4Q7vDTLJrMHyS8IwQ1dtqGJ0jZPoWX+iExQvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADFH1jzTzMde1jNyGIToYLqOYffFVkNAUEEluQ4Hu7HS0aodsaiSx50JI86Wx/F2TDNuh1YgIUx30r9npKB3G4zpxpg2+OAkWaaHiEEU2fTTVzq6LDy+61Dg385lwi716DrGR+1nrHkXpxBRLw4cWMh1ezAE4VjNxM2/uWsXp5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFisoJEh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFisoJEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A71D1F00898;
	Wed, 30 Sep 2026 15:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783489;
	bh=vosFINd/0pJKhYbObjqUFEWHaoyA4nzBBhm3PKvwRxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFisoJEh3PAAlvvlbXlKYCaXGFNpr/eBcLxaKJKbILtAcV38++I5cqLEp6gnZ+oA8
	 UbiJewV0fi2YkuGKxoVD2Ey8wEQrDHiKgR0LP4Lbo5AZqB1a53T//oPGCfMbngJxQH
	 0PXBQkb/4+qOOQl74sAKs1NdZs+Om0jtsSgBnEyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Nyberg <SlickStretch3.0@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 418/595] Input: xpad - fix PDP Marvel Xbox 360 controller
Date: Wed, 30 Sep 2026 17:25:11 +0200
Message-ID: <20260930152356.669367466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Nyberg <slickstretch3.0@gmail.com>

commit 7bc369cb3d3f3656eb77285628ee264264d28ad4 upstream.

The PDP Marvel Xbox 360 controller with USB ID 0e6f:0147 is
incorrectly classified as an Xbox One controller.

With the current XTYPE_XBOXONE classification, the controller is
detected but produces no input, while its four player LEDs continue
blinking indefinitely.

Classify USB ID 0e6f:0147 as an Xbox 360 controller instead.

Tested on a PDP Marvel Xbox 360 controller with USB ID 0e6f:0147.
All inputs register correctly and the player LED indicates the
current player.

Fixes: c225370e01b8 ("Input: xpad - sync supported devices with 360Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Jeremy Nyberg <SlickStretch3.0@gmail.com>
Link: https://patch.msgid.link/20260910071627.236014-1-SlickStretch3.0@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -209,7 +209,7 @@ static const struct xpad_device {
 	{ 0x0e6f, 0x0139, "Afterglow Prismatic Wired Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x013a, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0146, "Rock Candy Wired Controller for Xbox One", 0, XTYPE_XBOXONE },
-	{ 0x0e6f, 0x0147, "PDP Marvel Xbox One Controller", 0, XTYPE_XBOXONE },
+	{ 0x0e6f, 0x0147, "PDP Marvel Xbox 360 Controller", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x015c, "PDP Xbox One Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0161, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0162, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },


