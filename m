Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2588A1420B3;
	Tue, 23 Jan 2024 00:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968159; cv=none; b=btLXxZcSy0S3Gs7cC+qZZXa6Gh3NOh1oUA0Qo/XqUAB17FtoISRBzbOZErQg1/yuwxyoLl7zrcPZiLJe3aYzpMtNWuwKJzsimaFYBp308libDHnyvn4985P4vYNMwCFWAfWce6w3HYmR4SiFwDY75TWzT+JWLIDZ6NnB+LgFDI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968159; c=relaxed/simple;
	bh=HQQaZ15hkhhcFJsyjA4x0PKNzT6NNFWy+u/Gw9FCleM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TU2WSQehPKwaH4JP0uZiFzrbh0zAKEMpi28FaWnbCB9FDgxrAboaNFn3F8G1LvgJMMkquwNAnvn5l9nkeR6as3V9YyiZH1uE/STFiwv98NAjzFgYYz8bBYwmVuxJ6U3Qij+OpLNqBZdLIMpB4v1QvLTsLfu0j6Qehl3I6yKe0h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OKTkNxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OKTkNxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F6FC433C7;
	Tue, 23 Jan 2024 00:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968159;
	bh=HQQaZ15hkhhcFJsyjA4x0PKNzT6NNFWy+u/Gw9FCleM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OKTkNxuDsOq4ME8ebndjK1PRH9cYTshIYShBXFO6hcQv9gBWbur1r+K+6RHHtwIU
	 RGLb7Wch51LJJWE6dyCivckx91Ro7TQ/q7ukCxV0Yw+bcmLzTy89mjCBwDQAXeAqc6
	 PPf2MLhuBFPSwTCZ5bXafJHWsS8Iu2UkvbayxDlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@z3ntu.xyz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/148] Input: xpad - add Razer Wolverine V2 support
Date: Mon, 22 Jan 2024 15:56:16 -0800
Message-ID: <20240122235713.244077602@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e330d28b59ec..dffdd25b6fc9 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -280,6 +280,7 @@ static const struct xpad_device {
 	{ 0x146b, 0x0604, "Bigben Interactive DAIJA Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1532, 0x0a00, "Razer Atrox Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x1532, 0x0a03, "Razer Wildcat", 0, XTYPE_XBOXONE },
+	{ 0x1532, 0x0a29, "Razer Wolverine V2", 0, XTYPE_XBOXONE },
 	{ 0x15e4, 0x3f00, "Power A Mini Pro Elite", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f0a, "Xbox Airflo wired controller", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f10, "Batarang Xbox 360 controller", 0, XTYPE_XBOX360 },
-- 
2.43.0



