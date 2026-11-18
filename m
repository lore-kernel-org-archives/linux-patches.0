Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025194;
	b=O8xFiHhTVHEFgiuoV/Dtlj/fxt9pfy8w7z0lj1mhnFIB0H+oFfZm4nsciQDeJduGX9Dh
	 MAiB6dn5UJTkvdax++IZ/Q9YeKJ0qEAIKjnMGcdO2K6D0dsEjo+EWcRoF2AX3CORnkuOg
	 ArGmiXIYsUom5jhY/XO8C58MolL+2CfR0J9jHaZ5TeNB9Q03ESLJViAjEDnGnJHNgf8zV
	 8j/vrZYonNTF3BZxWo5siPtLxhzgKxOWflGVk84lQ8BH5lgTiXRrgJDo3zJxqLX5Yj4yT
	 3/5nlDD/hv8evveUQ6Y09dwyJSLrT5I/PvUo7YaNYcjQgz5875IQho3vf1B0EDU/hGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2syqpCWG3Xj/k8grfHvgpaRui6Y0AsNSTKqI1oeboM4=;
	b=QLV0RM1XhmwHL3atzlNsbjmhQOZS0C8rmbkP9VG2GsSyFOKEJh4ea3IBxFFSHoxKRbDU
	 WcFolxp09sAQtugx0ETz4H2YeuAvH8CPG1O7GN0IKpYmhjr0XPJLEjxC7OG1ICBxJS6GV
	 lPfOsJRrGuU9vDDvehOVz0DmIiW3pY+DQnc6GLNyiZap5JBf17hu3797AHaqE/NtGkgJS
	 OS/AtJgbyQxSrWRGlP5PnNjk9vk8FtRrV2tnw85suE40ZVrzKGsUmfB8L9VQySRfYbFbL
	 /xYVo6zpuhSaB/ZbTkIJvw/98F97zF7kf9BWY35iyEXOcnYF7ut6SGLAdirfvpVPGNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U6a9WyEF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE774606A320;
	Wed, 18 Nov 2026 18:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U6a9WyEF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B801F000C4;
	Wed, 18 Nov 2026 18:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025194;
	bh=2syqpCWG3Xj/k8grfHvgpaRui6Y0AsNSTKqI1oeboM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6a9WyEFpxv1juZhkA/Y1JFsNXUD5QKIP0rOiPhdIr2+OqNbhML2xyh4tI1gVZUG/
	 sexjyVJW/Dr3Rrpet0Sg2CRnKBKxTKW5VyfRAc3ywwilrB29ZqJxf8lJwp21LlzeXp
	 VIAGoQrYkDOF/MWoBgovkODk6XZx6STsgD37x00w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 6.18 0993/2151] phy: rockchip: usbdp: Update mode_change after error handling
Date: Wed, 18 Nov 2026 15:45:28 +0100
Message-ID: <20261118150158.625125187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 3f2181226d7708349c69cd4a4b21372a8049576b ]

If rk_udphy_init() or rk_udphy_setup() fails, the reinit will not be
tried again. Fix this by only updating the variable after all potential
errors have been handled.

Note, that no errors have been seen on real hardware and failures would
most likely be fatal and require at least a full reboot as the function
already asserts the PHY reset lines. So this is more of a theoretical
issue.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-phy/20260612163835.8D5471F000E9@smtp.kernel.org/
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/linux-phy/20260612163835.8D5471F000E9@smtp.kernel.org/
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-v15-2-80e2c11d1ce8@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index fba35510d88ce..a5ffdf7a6e76b 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -1000,15 +1000,14 @@ static int rk_udphy_power_on(struct rk_udphy *udphy, u8 mode)
 	}
 
 	if (udphy->status == UDPHY_MODE_NONE) {
-		udphy->mode_change = false;
 		ret = rk_udphy_setup(udphy);
 		if (ret)
 			return ret;
 
 		if (udphy->mode & UDPHY_MODE_USB)
 			rk_udphy_u3_port_disable(udphy, false);
-	} else if (udphy->mode_change) {
 		udphy->mode_change = false;
+	} else if (udphy->mode_change) {
 		udphy->status = UDPHY_MODE_NONE;
 		if (udphy->mode == UDPHY_MODE_DP)
 			rk_udphy_u3_port_disable(udphy, true);
@@ -1017,6 +1016,7 @@ static int rk_udphy_power_on(struct rk_udphy *udphy, u8 mode)
 		ret = rk_udphy_setup(udphy);
 		if (ret)
 			return ret;
+		udphy->mode_change = false;
 	}
 
 	udphy->status |= mode;
-- 
2.53.0



