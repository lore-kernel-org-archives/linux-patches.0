Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0A722323;
	Thu, 18 Jan 2024 10:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575421; cv=none; b=jzOW0pIJhPzU/8DAb6mXOms8N7bHB3kpoQi4wln+2CSAijKDJUnrR2dtmfYCZPJ/oTXVz0qPpTg1TshCcYShBXdgg4M3ygQ2FBq6RY+kyCaCW/Lj0jGs1te44tdPhbOqdW/qwWtqc6d7maAI3wy0/IySyjCfBLd+FwdCE5v0Ml0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575421; c=relaxed/simple;
	bh=1yv4BDUz1d3qAEY3KptcJ0/3m7yNiJD1cmCp2QNNn7w=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=qBXUzGEPc+jyX5DoWnwZe3Rd8o0h5ZCIXkL7X7v6TJtQNrh0mQKRrDsV7+uIIOgDTtP6qSbSCljNoLEGc41iTFJYf93zOcffSzrr3dnfwZcjf2Oqnb1lQW5Tlson1DAqqGW0HWnETzVzSmwWi9J/m9gTZr8ukUqRrMQhcVvQCns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hs8vqohH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hs8vqohH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE5DC433C7;
	Thu, 18 Jan 2024 10:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575421;
	bh=1yv4BDUz1d3qAEY3KptcJ0/3m7yNiJD1cmCp2QNNn7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hs8vqohHYskhOibJ4J9S/TCCNlO01x0vKxOrEEVbztR9PwdvgmhnUCnls00hxMbZM
	 zfG2pR7NFyto2Izc561+Wdw7b8E/zuCunkIr3Z8Eoi+pyHbxprboaiZ8B1+nJcraPx
	 DDyOgH85DMCbkW4L2QZnwDw6YHKLeniMgtAkFA8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@z3ntu.xyz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/150] Input: xpad - add Razer Wolverine V2 support
Date: Thu, 18 Jan 2024 11:48:39 +0100
Message-ID: <20240118104324.441696320@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit c3d1610345b79cbe29ef6ca04a4780eff0d360c7 ]

Add the VID and PID of Razer Wolverine V2 to xpad_device.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Link: https://lore.kernel.org/r/20231125-razer-wolverine-v2-v1-1-979fe9f9288e@z3ntu.xyz
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index f5c21565bb3c..e2c1848182de 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -286,6 +286,7 @@ static const struct xpad_device {
 	{ 0x146b, 0x0604, "Bigben Interactive DAIJA Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1532, 0x0a00, "Razer Atrox Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x1532, 0x0a03, "Razer Wildcat", 0, XTYPE_XBOXONE },
+	{ 0x1532, 0x0a29, "Razer Wolverine V2", 0, XTYPE_XBOXONE },
 	{ 0x15e4, 0x3f00, "Power A Mini Pro Elite", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f0a, "Xbox Airflo wired controller", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f10, "Batarang Xbox 360 controller", 0, XTYPE_XBOX360 },
-- 
2.43.0



