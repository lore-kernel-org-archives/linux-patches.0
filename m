Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBD01448EF;
	Thu, 11 Apr 2024 10:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830308; cv=none; b=TeMQ293Fx89gn9pl2F+yFEVX6STcxo/Qo8aN9xEQfvHM5VvkGWUnneo04AENPKBviBN3vjfVlV9Yad4qYxgOSVi8juQ5YRiQQttznekztX4pjGtVxK975s/izkxf3UNyfnlLEoEdEREQY7sTFINtXVVFRAHkXN/neyJg1lqlY5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830308; c=relaxed/simple;
	bh=yqOk9XNUq4PwBDiEbV6oplVvQgeHA+J489RlDkCo7mI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0Ff6eNXX+xh7MhHXL/wiGSJrvfwpyTlxXaCopvy+WtBsn9wXrMXEhAucb+fYQ/tS85eeqGL+BHXEbQI2RObY2s/ztRNwvyXFiVsvvSb1zvPPuq4O0OGb+GZGgToUI+Zsz5MMFz708C1MdOkh3N1+XaeVt14f2Px81WxXjV6dTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAcfd257; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAcfd257"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86063C433F1;
	Thu, 11 Apr 2024 10:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830307;
	bh=yqOk9XNUq4PwBDiEbV6oplVvQgeHA+J489RlDkCo7mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pAcfd257uMcYwHBDVCZNVwisem8+pKOTkScJWELw16XeT+6sHAWsOsk2NaDGn1C8G
	 36jrnlDo9f0cBWtYepqss5T7r9WN8/nCoxHk30tylwwS8TKwT3/zFoPgog9mfiOfXk
	 B/8rbZBadgqeexef/C9Z48j0Xded1fVKVRDSBm8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Scialabba <matt.git@fastmail.fm>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 106/143] Input: xpad - add support for Snakebyte GAMEPADs
Date: Thu, 11 Apr 2024 11:56:14 +0200
Message-ID: <20240411095424.097781449@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 14c828adebf78..1fad51b51b0e1 100644
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



