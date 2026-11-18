Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030646;
	b=HXgj9nL/AC5J72QNh4DubiVxND/519n0PtMGtSToefpDI3IxY9tr8sfbzEXcAfGDFXh/
	 rUoultgF4uJ3oOIxFm/Rs00GOrE6beDbuUn/lgvLQDwbheBO7AGYhylSSppfgfmJgQ4ZE
	 10sbsu2DXqPnsDc7QQzvuwz+20Xos+8STyzRiQ7/8rEwYWaW3wAV+jbJD749kdUVo2Zsj
	 dyKMOf+oXLAV9Ki1E9PNMyKsq1zMwQTzn3CCoSSOPzwRkhPsA8qIKEYarruS5rcHjnL1x
	 vHm7poImtox52oJ5VXjbyQlISkn3Er+IKQwWQHkU61HXMQuaEjQ865/JdlUG1schcIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bVvN2SIplUCJHD2W+td7IbsN5DCgQ1rw7NVY5Z/6EOU=;
	b=q+xNJ+W6rVqZZ5Ma0UQIlCAmAECKg8y+XO4vzvlqFHPP8xNEHpEU3uWSFefSamEmvHiw
	 +ZekhUnI8F1S1QojZsku4J5NpxaFSKnwgThJ2vt2qT3PZSc6KBtS0EiZReScvPsYP2PR8
	 /w5RohJFG6LpT2jueE6x588UHwUy25pP5jBgobFvX6uyVbFOJWZCDa9ML+0fDjh82Oh93
	 lo7Y8e/27sVJo7p4YdgBuGvE/HJNtF/PCUAZnqstJA54/ZYeSh779OE523SVEMW+onQ0O
	 ejhDl+L6lRV5sAE3qaUmHL1GmdL4nUuZ7FyDdt+AOnvbqOPem6SePvqJ/0nQqCu8z5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ewfpTW+a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B59606A31C;
	Wed, 18 Nov 2026 19:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ewfpTW+a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6239E1F000C5;
	Wed, 18 Nov 2026 19:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030645;
	bh=bVvN2SIplUCJHD2W+td7IbsN5DCgQ1rw7NVY5Z/6EOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewfpTW+aLuc/bfCtM0BE571SD6zsgAWrRDnRHISMbLbyGtBOVWOxbC0bPpm7yDGDY
	 XcLuBcGng1fSu3dDfSv6/j5m1vPEqE0MaA/7UpbYAPnBpcbh2rbmJJ70GoFPJEvhe8
	 vbJOlmXjiKhWAyo3xxML6Ea2WLaZ5YpZeI4Sisv4=
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
Subject: [PATCH 6.12 0777/1756] phy: rockchip: usbdp: Update mode_change after error handling
Date: Wed, 18 Nov 2026 15:48:24 +0100
Message-ID: <20261118150040.555676565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d2021f7941e3e..cc798a8344eb8 100644
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



