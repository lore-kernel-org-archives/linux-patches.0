Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA19194C62;
	Mon, 21 Oct 2024 10:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506564; cv=none; b=S8TbHArLe4I8X0UwXUBQ9R/uKsu7qRtSQZZsuMMTLEzHaBAwVQihiPo86KH44vmK/fVSWRiMuPH7H2prkVuwvYIJ1z78Ak65T2nmodlOiO5oZhieLUz+eX7efuUCnOWdPutemlTKF5HAIsXKCtzN+Mr4GakHItetC/RJBtFGyzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506564; c=relaxed/simple;
	bh=IySBkdi/2Sg+KejbCJIoVblsaqh+8cs88vyXZDwbkrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxbBEUJb7WsQd93t5uCkynTBZkZp9uoAcOi/sbQmLGxsPtMdlHP0NfgSe2s0lJYYkpKPFUOrpbX4V0nlJ6DwrgYilYvbHT01450BcsEgYE4+Qta2BwOrz8FwQ/sUYPmAs1WiHALfcirN4b7r/N+uqyQ+oQr0aR/0+a6L+1jfZl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyopNueP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyopNueP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0D7C4CEC3;
	Mon, 21 Oct 2024 10:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506563;
	bh=IySBkdi/2Sg+KejbCJIoVblsaqh+8cs88vyXZDwbkrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyopNuePHFyk84bW01cVCidr6EKnxUti0P2gPPSZBWhJQgEiakunsT4veAHvn1g60
	 Q4gYi/j33P5N/8frOiuD3KBV+KLoOUXhx4+tC2+vvA28Hb/VNDpOY9yPKPrT2V4ws5
	 MiqsUXEtIovX52di9k+vereCQzl+J+Z7bnscEEXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Kerkmann <s.kerkmann@pengutronix.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.11 047/135] Input: xpad - add support for 8BitDo Ultimate 2C Wireless Controller
Date: Mon, 21 Oct 2024 12:23:23 +0200
Message-ID: <20241021102301.173425594@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Kerkmann <s.kerkmann@pengutronix.de>

commit ea330429a04b383bd319c66261a5eca4798801e4 upstream.

This XBOX360 compatible gamepad uses the new product id 0x310a under the
8BitDo's vendor id 0x2dc8. The change was tested using the gamepad in a
wired and wireless dongle configuration.

Signed-off-by: Stefan Kerkmann <s.kerkmann@pengutronix.de>
Link: https://lore.kernel.org/r/20241015-8bitdo_2c_ultimate_wireless-v1-1-9c9f9db2e995@pengutronix.de
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

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


