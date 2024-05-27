Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5D1168C4;
	Mon, 27 May 2024 19:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837628; cv=none; b=RacYcHg8og3ZFi3PFPnXu3xgSiwZYoqGvdaO56O3nBs9uZp/D6+32+gb8rHtgRYHCdjr7r0OF65RwTd0dNk/RCRJ2DsM0x5YFxqcQkQ8vi0Sivh3mM2VXGp11ec0+7DK6fHlRNj2wZ1tWeSfa2JFyDKTSLsKHgij0LxqDMcc4NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837628; c=relaxed/simple;
	bh=LuovYODvAu4p3+nUWrOmDVaB61KZ4qR88bF1vgE7YU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmEsC1LffhJSL17p0Wp9+gpfjK1sIJeN1HM3xlsDkImUFZF7bCxq1PSEzKXyNmJVZplBy6P8DlkZAEwPRdMJm3FmnJxsVwNT6nUxW1nyKnEagcqKEO0YSVz4FQDL2UemDyn2P/kBLXvHwnRzUSzqjUg5eTbTt4kL/UpG3symqQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1Iy9AA2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1Iy9AA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A061DC2BBFC;
	Mon, 27 May 2024 19:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837628;
	bh=LuovYODvAu4p3+nUWrOmDVaB61KZ4qR88bF1vgE7YU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1Iy9AA2D+FmzbqVBWBby0cLPgc6qxRVgPqK1W3tfCBcASbaFK/E3JhlstlBPndgY
	 ZFLzycqqm1lnyhRBsqPN8zQs/aSyfUenjZ5MJgdakxU4LPV5IURhrm9YVTXZBxAJYW
	 i8oH/bAsonAzrWSvVS7HewbJBjY07DEaVr49GMCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 080/493] Input: xpad - add support for ASUS ROG RAIKIRI
Date: Mon, 27 May 2024 20:51:22 +0200
Message-ID: <20240527185632.756235420@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit be81415a32ef6d8a8a85529fcfac03d05b3e757d ]

Add the VID/PID for ASUS ROG RAIKIRI to xpad_device and the VID to xpad_table

Signed-off-by: Vicki Pfau <vi@endrift.com>
Link: https://lore.kernel.org/r/20240404035345.159643-1-vi@endrift.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 1fad51b51b0e1..c2de2f063cb8d 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -207,6 +207,7 @@ static const struct xpad_device {
 	{ 0x0738, 0xcb29, "Saitek Aviator Stick AV8R02", 0, XTYPE_XBOX360 },
 	{ 0x0738, 0xf738, "Super SFIV FightStick TE S", 0, XTYPE_XBOX360 },
 	{ 0x07ff, 0xffff, "Mad Catz GamePad", 0, XTYPE_XBOX360 },
+	{ 0x0b05, 0x1a38, "ASUS ROG RAIKIRI", 0, XTYPE_XBOXONE },
 	{ 0x0c12, 0x0005, "Intec wireless", 0, XTYPE_XBOX },
 	{ 0x0c12, 0x8801, "Nyko Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0c12, 0x8802, "Zeroplus Xbox Controller", 0, XTYPE_XBOX },
@@ -482,6 +483,7 @@ static const struct usb_device_id xpad_table[] = {
 	{ USB_DEVICE(0x0738, 0x4540) },		/* Mad Catz Beat Pad */
 	XPAD_XBOXONE_VENDOR(0x0738),		/* Mad Catz FightStick TE 2 */
 	XPAD_XBOX360_VENDOR(0x07ff),		/* Mad Catz Gamepad */
+	XPAD_XBOXONE_VENDOR(0x0b05),		/* ASUS controllers */
 	XPAD_XBOX360_VENDOR(0x0c12),		/* Zeroplus X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x0e6f),		/* 0x0e6f Xbox 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x0e6f),		/* 0x0e6f Xbox One controllers */
-- 
2.43.0



