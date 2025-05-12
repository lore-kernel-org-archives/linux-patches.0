Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB20297128;
	Mon, 12 May 2025 17:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071870; cv=none; b=LCUH7GB7hP+cDrAAdWO2RsKVDkueDf2rS1Hixec7gK92Humot2gqWZJ/Rjj4Rny8aoJKMpESZDUkDqTMM3rDukq+16t000AhsAfYUZ1ywIkJOjUisr2SipLDpwpLnQ5axR9YZV5VwWXsa0ahKYHUR8a46ZhGFXIxlBj5aUv5CAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071870; c=relaxed/simple;
	bh=8Mii450GWGcpkVEjuPOihEirAFvs+Dk9TW1SlVEGku4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4wd0n9cbzaENZdzSGch0CAKMOrdqBrXGGcQzFwm8qW1pd6BaU0PInZmtCpjQ1/WFydyNO4EY0E53efLQj7n71qShfL5CNutCXA08PUbsuf8QmysicAbpGid6Y4PiyjkFxCohTs47bX4XWONawJJEEekuRTVJeQwV4TFhRDXBEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7NppvIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7NppvIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A02C4CEE9;
	Mon, 12 May 2025 17:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071870;
	bh=8Mii450GWGcpkVEjuPOihEirAFvs+Dk9TW1SlVEGku4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7NppvIcI7iv18yr/sWOvWenmlKTT5F5zLw5Dk2EzCA8oMduxlEbk9ViByR3Sow9R
	 igC2nf5zT8mID4pBHU5SUjCc3wA4BAcfM8/arcR+0bJ62YwnYs+uLy6b+Ynl6ZiYRC
	 W1X81ZP/73DFilwB011eXJ2TsjfyJJChDifCY59o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lode Willems <me@lodewillems.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.14 058/197] Input: xpad - add support for 8BitDo Ultimate 2 Wireless Controller
Date: Mon, 12 May 2025 19:38:28 +0200
Message-ID: <20250512172046.747622145@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lode Willems <me@lodewillems.com>

commit 22cd66a5db56a07d9e621367cb4d16ff0f6baf56 upstream.

This patch adds support for the 8BitDo Ultimate 2 Wireless Controller.
Tested using the wireless dongle and plugged in.

Signed-off-by: Lode Willems <me@lodewillems.com>
Link: https://lore.kernel.org/r/20250422112457.6728-1-me@lodewillems.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -388,6 +388,7 @@ static const struct xpad_device {
 	{ 0x2dc8, 0x3106, "8BitDo Ultimate Wireless / Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x3109, "8BitDo Ultimate Wireless Bluetooth", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x310a, "8BitDo Ultimate 2C Wireless Controller", 0, XTYPE_XBOX360 },
+	{ 0x2dc8, 0x310b, "8BitDo Ultimate 2 Wireless Controller", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x6001, "8BitDo SN30 Pro", 0, XTYPE_XBOX360 },
 	{ 0x2e24, 0x0652, "Hyperkin Duke X-Box One pad", 0, XTYPE_XBOXONE },
 	{ 0x2e24, 0x1688, "Hyperkin X91 X-Box One pad", 0, XTYPE_XBOXONE },


