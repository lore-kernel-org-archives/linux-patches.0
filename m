Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CA91990CE;
	Thu,  6 Jun 2024 14:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683126; cv=none; b=rs7lelFzKHPfLa4HRyLzAKbpOtXYOwMK+NIbmcpC9/WMHflhMI+1woLiGUh9nOin3R12Ryis1aN5lWXqMPjSzPlVPTtKQDixWFrJI24dCEoLgM6iV4TSldXk61b+xnQTkveX2II+VkEtWTAPHgHoANyLYDCJ6oL3x1IaVNyY4h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683126; c=relaxed/simple;
	bh=8WAV/R6tvX5cYBdxSwbMjjXuNxjAqxn95SOFMJNNJiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHDPNfEUHS2P/oaHunHp2062SNjqi5p96H37c+MRieNtgjErXqk6P2AmKhpQW6Z1l97pb9eZ/MBSbMYKMIbJrPBD+inzVUZuq5Vy4sBoLYNY/HeNDOlAmxEHY8ICHMhrPPkscaS40pl86GpIWaIveMOeFSjJnYg/vyBIODQPn7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCfS232c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCfS232c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCA8C2BD10;
	Thu,  6 Jun 2024 14:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683126;
	bh=8WAV/R6tvX5cYBdxSwbMjjXuNxjAqxn95SOFMJNNJiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCfS232c4B3MZavXzzBrEaypldQxKMAkaA5hYRi4TdY7cqgWgWAAbkgQQjPC6YKmV
	 /NwED/aNlo/WHTiEb31ZSTcSaKNyVF8q/U67uMI1gfxCISnn9K6nABZJhVkVerZgdz
	 E1ah9Sdet+WwXWJBCOa8kYH8GM2ZKwfw+bbPDMO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/744] Input: xpad - add support for ASUS ROG RAIKIRI
Date: Thu,  6 Jun 2024 15:55:40 +0200
Message-ID: <20240606131734.594415858@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 9206253422016..cd97a7a9f812d 100644
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



