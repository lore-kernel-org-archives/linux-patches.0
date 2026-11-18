Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018351;
	b=ofRzBngw1C8VC+3bwzYcmiWkBfukigeB+40xuf4+1tiax9D1+hnQbzqoZFIJ9Lj7AfyW
	 eb66lOaFq6PvU314uWzQtbtHJtCkE5WsMnz+4l8Q/FfaliGl+XB9r+CSnfQIN3TXJiXdT
	 tYw4xGTcsJ370ebyLp3jnElELTbGbRCDJkuL3wZOZ727Mnad17xOUwG7Wc9honmWTWkXJ
	 nDw1JYDpTr9Z16zyzQ3PkMz9zC7xpROxXS7eAWWhQBFEfFa/v/fxX3KuC6v156+eIa37s
	 NhQa8yeETbHUigofk80/9z2h0l4YCZPXJaOY1TGA/i1U2YXYKrnTEdRIlcYOjqsctWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XR+KdZimLkKilw6DzTCmgBJfYV/BbHN/rSL6Kr5Y1EE=;
	b=0/GLEAJxUIwOnnvdBjHSLDbK7VO0a+SMGiCFCwqnGRjGhteg0hjNeMkAD1HkViCF/Rrt
	 ToNhC+T5qT9u0jsGjGRcxA9sHLPI4Qs3MDRp91nBJUKcBttInwURRXwRhL1t94rVk25Av
	 6NodJjAKltslaly/SJkKtSSxoCh4/3Jzj9MnRJjbSY+263/LmNPllhikOPUCF0wvY/QyV
	 3v7XqsaWQcZyf5dzs5bCk65hSX51Y1oTn+3mCvrVMFL3cCBqr7jq1Q2Y6GVtl37LUBF+1
	 sSx/3nE9Q7f9H5Sf6a7RU+2ADs9y3olyFMuKk1bH7UR/JwM1FDccXwp/xKSYvdTCRaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L0GTeLsD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAC3606A31C;
	Wed, 18 Nov 2026 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L0GTeLsD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93AC1F000C4;
	Wed, 18 Nov 2026 16:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018351;
	bh=XR+KdZimLkKilw6DzTCmgBJfYV/BbHN/rSL6Kr5Y1EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0GTeLsD8MPNyk6XhiUJkBB3oE8RaIteudQ1XEQXnA2Eu73xi1L0qkM0RplmcFRjG
	 fVRIpCzVC6BFYvryLg6JSkqqDfXgZrAe+YOLQ4sAsYWK7fklWPS33PfvS5Rxw+EDkb
	 mJvnLCIGZ0XRBOMVyU9FqAdizciI9LGDxg4I6QzA=
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
Subject: [PATCH 7.3 1208/2651] phy: rockchip: usbdp: Limit DP lane count to muxed lanes
Date: Wed, 18 Nov 2026 15:40:48 +0100
Message-ID: <20261118150331.480248770@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 443997ca8d797375ff35e8f3ad3828799e88f71b ]

In theory the DP controller could request 4 lanes when the PHY is
restricted to 2 lanes as the other half is used by USB3.

With the current user (DW-DP) this cannot happen, but as the check is
cheap and users might change in the future protect things accordingly.
Not doing so would corrupt USB3 usage by the following code configuring
the voltages.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-phy/20260612165546.98E1F1F000E9@smtp.kernel.org/
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/linux-phy/20260612165546.98E1F1F000E9@smtp.kernel.org/
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-v15-12-80e2c11d1ce8@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index ce2b74a288017..d3ebd9ed56dde 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -1101,6 +1101,9 @@ static int rk_udphy_dp_phy_verify_link_rate(struct rk_udphy *udphy,
 static int rk_udphy_dp_phy_verify_lanes(struct rk_udphy *udphy,
 					struct phy_configure_opts_dp *dp)
 {
+	if (dp->lanes > udphy->dp_lanes)
+		return -EINVAL;
+
 	switch (dp->lanes) {
 	case 1:
 	case 2:
-- 
2.53.0



