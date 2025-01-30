Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF035C13D;
	Thu, 30 Jan 2025 14:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245632; cv=none; b=ikFmXG2pCbdhumSwPXExHVhxSLxxNdBCv0LgepMpdUnNO0mVOQQc1vsBdqwiuj0E/w+MDxr+U1AGo2ohPdUvI4XyRx7mnQ62UG2Tmw4BZ7OW+qMUtDsyzcg5ffUHyJ/mgfdiwDp2hSG4NiPnDMiXSyK0x2Hc07wbIbEdrN02lN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245632; c=relaxed/simple;
	bh=NahfPWjPmr0Mux000+QY6CQeInetFv2bWnju7Fm1Td0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpaMVNuQbiY6wIhelA03/TG/ko4XFLMSAP73Hrm4EhzKkOk2Y2oD9WK7lS1ILvtEOBwlT9KWKubYTUlVs25O+Tq2K+8U9sllvHSrwl5gCHXpzCiriht1ipRDhE9RpRdoGyUdOulo1TN9iekQQM+v0/m2wRqx/QCRZ3eANo2FIjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhLvx/qS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhLvx/qS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B98C4CED2;
	Thu, 30 Jan 2025 14:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245632;
	bh=NahfPWjPmr0Mux000+QY6CQeInetFv2bWnju7Fm1Td0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhLvx/qSQ5Q7Z73UscRnTOq6VPRBvz7Ldt0OyBfKSetQfZm+SyZGEBj6xPheXEQAK
	 wK/c2GaIOCZpaBKF7V6lU3pwFWPZurDX97aohkS4nQN7aQmzMntAMpsUKm/4VP0l0J
	 2Zr0im9ADmbV2ydWWBdz1KSn49SAb+ax0Mk+dZ6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonardo Brondani Schenkel <leonardo@schenkel.net>,
	Pavel Rojtberg <rojtberg@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.13 23/25] Input: xpad - improve name of 8BitDo controller 2dc8:3106
Date: Thu, 30 Jan 2025 14:59:09 +0100
Message-ID: <20250130133457.864499081@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leonardo Brondani Schenkel <leonardo@schenkel.net>

commit 66372fa9936088bf29c4f47907efeff03c51a2c8 upstream.

8BitDo Pro 2 Wired Controller shares the same USB identifier
(2dc8:3106) as a different device, so amend name to reflect that and
reduce confusion as the user might think the controller was misdetected.

Because Pro 2 Wired will not work in XTYPE_XBOXONE mode (button presses
won't register), tagging it as XTYPE_XBOX360 remains appropriate.

Signed-off-by: Leonardo Brondani Schenkel <leonardo@schenkel.net>
Signed-off-by: Pavel Rojtberg <rojtberg@gmail.com>
Link: https://lore.kernel.org/r/20250107192830.414709-2-rojtberg@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -375,7 +375,7 @@ static const struct xpad_device {
 	{ 0x294b, 0x3303, "Snakebyte GAMEPAD BASE X", 0, XTYPE_XBOXONE },
 	{ 0x294b, 0x3404, "Snakebyte GAMEPAD RGB X", 0, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x2000, "8BitDo Pro 2 Wired Controller fox Xbox", 0, XTYPE_XBOXONE },
-	{ 0x2dc8, 0x3106, "8BitDo Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
+	{ 0x2dc8, 0x3106, "8BitDo Ultimate Wireless / Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x310a, "8BitDo Ultimate 2C Wireless Controller", 0, XTYPE_XBOX360 },
 	{ 0x2e24, 0x0652, "Hyperkin Duke X-Box One pad", 0, XTYPE_XBOXONE },
 	{ 0x31e3, 0x1100, "Wooting One", 0, XTYPE_XBOX360 },


