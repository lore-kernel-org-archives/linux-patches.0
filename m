Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025203;
	b=u/cmXYtsSUylhs1Kia0dO0TziAHKN2CrNcuGB6vP+6CceaPzmAXePdBNhh9p11t7p0z5
	 UuJZKvkQk867BcomQqiRBkRYZIxMS2/ryL8qoyods6aX5UGw0jEwSPMP4vQZGsNecfzHh
	 QhEkisiYGX6Aj4frEHeoWUfYuAyJalttMn6E2iZFVl+GcdVV0FvmzTAgtvxccb6Dmjeaf
	 XN1HWmC8iWO0eT+f/3iVLeI53VYfd9zBehhnx21UEyB/KNWbOwInm8n9qdQiy2bU2Ubup
	 hBo7JXVMFhG1Csh4gtclvlKIznhdGRyWpV88tyC1m5l05kQFIFL3y5FGQd82rQPhDoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZNP7umLh3/50lUncbMhrKCw8lrKtObYxApz6FQ6b2s4=;
	b=ruKjNfYjCV3clLWQYfYeR7g0+3OUA0IrDb25oM0Q9rgRRFDzCYvYGdblIUYk5x9FTD9a
	 1dNnKfrSYZ+3M7NgIPaQCO3xCS7lW82uyqTY8kfGacQzcJJTzuztseEzSe54eFj1QrPrA
	 nkU3bq5jvRnHMILY54sDmcxLuNxK5aXGUOiMLGquoo91vdc3W0miZ5/EKblP6zmeD6TMY
	 s3HBlQZii20ZMI0Ss0yo+3Lw5lEzcDLWzTs93vJEormK5U4FQBYCWieBkYS5g7JaL90ze
	 gFUwri6mFVj8aVc8Y/1WO3GEe1jNDaK0Tv7rMq/S17Q5BquiFKXjtB/12kfH/s5FxQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mosjkDxp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507B3606A320;
	Wed, 18 Nov 2026 18:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mosjkDxp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA75E1F000C4;
	Wed, 18 Nov 2026 18:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025203;
	bh=ZNP7umLh3/50lUncbMhrKCw8lrKtObYxApz6FQ6b2s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mosjkDxpfs9SDM6KDXsqY+fQMDJUr6h0kJglQ+y2n4KwMQ7FL/pM0pfHr/mtPZATI
	 BGwaCszP9yxh1fOTz7z7hOsh89ijvj9948OePzG2jQgaOayNNSXLvzByo2K541zyhd
	 yhscBjADoKeCzPYOii0yzX0ycO5p8q1NUWm8wQS0=
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
Subject: [PATCH 6.18 0996/2151] phy: rockchip: usbdp: Handle missing clock-names DT property gracefully
Date: Wed, 18 Nov 2026 15:45:31 +0100
Message-ID: <20261118150158.727772489@linuxfoundation.org>
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

[ Upstream commit 17cd5e026a6e806b811f915b8e02a8b9d14f6f41 ]

The rk_udphy_clk_init() function would currently try to do a strncmp for
a NULL pointer, if DT specifies 'clocks' property, but no 'clock-names'
property. Fix this by making sure the clock has an id string set.

Note that DT binding requires setting clock-names, so this is only a
problem when booting a non-compliant device tree.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/message/20260619154349.071321F000E9%40smtp.kernel.org
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-v15-5-80e2c11d1ce8@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index 2845a012eafcc..3fc8222fcaec2 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -432,6 +432,9 @@ static int rk_udphy_clk_init(struct rk_udphy *udphy, struct device *dev)
 
 	/* used for configure phy reference clock frequency */
 	for (i = 0; i < udphy->num_clks; i++) {
+		if (!udphy->clks[i].id)
+			continue;
+
 		if (!strncmp(udphy->clks[i].id, "refclk", 6)) {
 			udphy->refclk = udphy->clks[i].clk;
 			break;
-- 
2.53.0



