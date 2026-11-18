Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025208;
	b=YFo2EjaPAsRVomA9f0uSi6czWolkq+09NQWrPPmRQ1ZlpFQratNytI/zEoiuSfhUiZnJ
	 giNupC1qX1shHMgLAxhalN5p23lmGRWEpUf0Sv+53rHv1UfsZdCOQlOX5QW6GbfZ2XoCC
	 XfkhvEvVRLnk6L+5Zxhy+aIUxvDuS6Y+B7RweyypXhs+vtQuMYIdtm/satzH9FshfgJWj
	 +J3RAe/RL6ku6bHB2AwzrKarJ6MxlISBeEWqDqhsszrtrDLm+XbXtFnLgktw08MBYk9GY
	 /G1uf2LoWaogPDeQiLsEwUFJnpIr6kbduU7kdwmfJ5cgJDFUiFdWLkFFDpEeavoIYag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3iBrXaMou2K6DJxPEZoUnTUR33gR61htqzQW8a9gBgI=;
	b=IQgLNDiwFu5R39q4gCcxvaJ3Av/o8qSGicCRKglCTUfwin0id5iQflAeIdf+GtpjYqbU
	 FsOLj/AOf0hfzMnFIa8PuQu1InVIo3wA2TeIummYTLhotDp3/WRsRR0S/XFlllusvTQM3
	 0JFObwevkU2nWdOFOmHupViMkOU7mnN4V3XygcVrZ6YYsxKCF7eUOmRUD2/hquicmuzLr
	 EVHkgBtpgOhdtJrO90j+X+93gv+33kAAwzSW2N9LwnOdjbPz3D8gHWoAf+a+fsSYluNcQ
	 1Hwof8IIilmjU4pl0cbN082FQAfd5Y26UuK7vb1vayueuH2umXCcdoqVaB+8fJg8P+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPG8uChN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8183606A325;
	Wed, 18 Nov 2026 18:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPG8uChN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FC11F000C4;
	Wed, 18 Nov 2026 18:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025208;
	bh=3iBrXaMou2K6DJxPEZoUnTUR33gR61htqzQW8a9gBgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPG8uChN1MUdCQ8RbQm5MAG2Jc493ih2dPACWTVZAmPm9RUJKgb6M9u7pTLmJ23Qi
	 sGrzxb315+9WRBuMo5aG4/5JvTqqaJT8kEYsNe+/8ZyXhl8c382acjd7H3dmOehsFD
	 LA1iZ8aCNfHhbj++3xVlFpjRNqZ8u4WCobutabS8=
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
Subject: [PATCH 6.18 0998/2151] phy: rockchip: usbdp: Limit DP lane count to muxed lanes
Date: Wed, 18 Nov 2026 15:45:33 +0100
Message-ID: <20261118150158.800678729@linuxfoundation.org>
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
index 6cb9f6b4dbf6d..ff66b88abdbd3 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -1102,6 +1102,9 @@ static int rk_udphy_dp_phy_verify_link_rate(struct rk_udphy *udphy,
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



