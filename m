Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9AA1CAA81;
	Wed, 19 Mar 2025 14:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395236; cv=none; b=Z4AIbgKW0mdBK05cj/qNOtXSI/41WzMXkcnO7kmNWg0dQMnQ8xOUl00aQmVsH2HuER+hWMYvC0lHgIZraYZXT0G+tYTONs1r2nJa2pRAA9+EtWeTuUY5tNId+7aZ63M+PDu6P2Hy4Ph6vBKPaR8+wp9IdGvmqfTjeTTmR6bIg0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395236; c=relaxed/simple;
	bh=F0UowwDkyxtpazBxWwIfZP2kf2JlCuOdy2qG5YP/4ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7PqXyq3hPtKhm+E1qJukBwkKula5zJoEeJIxNNxQ3Ad/mGUEHfzqlhEsGOI2r5nMe70OPhuqAx2JN8gO2jqPgxRPcaxCO4bxfaOtEj+QjMVsgVKcGFBVbsCko9Y/6jmw6CLIrJut2WUsaoif2xaJ+k15r/dqJTozpLz8AS64uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejzJm66E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejzJm66E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D188C4CEE4;
	Wed, 19 Mar 2025 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395236;
	bh=F0UowwDkyxtpazBxWwIfZP2kf2JlCuOdy2qG5YP/4ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejzJm66EQZk+4ohcJcqVW5LgEMMW+6RgwvswzxeOfs9BykQ3y6Jyt4HL/MejoYZwJ
	 EvEDKzFVarh7nzMs45UvqwAa0/J2qR44sSmSi5j+83C+4MTe0gKiPENDotG47DR8/N
	 /n6jPoTiftOnKmH05zd5ADlg0LB84lIfJ9iJ5WZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 109/166] Input: xpad - add support for TECNO Pocket Go
Date: Wed, 19 Mar 2025 07:31:20 -0700
Message-ID: <20250319143022.968564887@linuxfoundation.org>
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

commit 95a54a96f657fd069d2a9922b6c2d293a72a001f upstream.

TECNO Pocket Go is a kickstarter handheld by manufacturer TECNO Mobile.
It poses a unique feature: it does not have a display. Instead, the
handheld is essentially a pc in a controller. As customary, it has an
xpad endpoint, a keyboard endpoint, and a vendor endpoint for its
vendor software.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://lore.kernel.org/r/20250222170010.188761-3-lkml@antheas.dev
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -381,6 +381,7 @@ static const struct xpad_device {
 	{ 0x2563, 0x058d, "OneXPlayer Gamepad", 0, XTYPE_XBOX360 },
 	{ 0x294b, 0x3303, "Snakebyte GAMEPAD BASE X", 0, XTYPE_XBOXONE },
 	{ 0x294b, 0x3404, "Snakebyte GAMEPAD RGB X", 0, XTYPE_XBOXONE },
+	{ 0x2993, 0x2001, "TECNO Pocket Go", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x2000, "8BitDo Pro 2 Wired Controller fox Xbox", 0, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x3106, "8BitDo Ultimate Wireless / Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x3109, "8BitDo Ultimate Wireless Bluetooth", 0, XTYPE_XBOX360 },
@@ -546,6 +547,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x2563),		/* OneXPlayer Gamepad */
 	XPAD_XBOX360_VENDOR(0x260d),		/* Dareu H101 */
 	XPAD_XBOXONE_VENDOR(0x294b),		/* Snakebyte */
+	XPAD_XBOX360_VENDOR(0x2993),		/* TECNO Mobile */
 	XPAD_XBOX360_VENDOR(0x2c22),		/* Qanba Controllers */
 	XPAD_XBOX360_VENDOR(0x2dc8),		/* 8BitDo Controllers */
 	XPAD_XBOXONE_VENDOR(0x2dc8),		/* 8BitDo Controllers */


