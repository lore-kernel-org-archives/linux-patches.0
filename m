Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030800;
	b=SJwSmiw/VJYdnM3VM4BjKw1UCZuhlvq31pC18uNi2KoODrTp7i9g0GLC5v0GBOvu8gT2
	 osG3vyaO6D0k8Rf+M414w4n17B8u81j3U1wuV38e6vzSh3BTEneHMNKaK1peiHoFhEV+f
	 5gay5OYnSi45AaAL56pWrnbigzHUj+6oXpE1ed1S3A/0suuxKkPwbLd/t0Zk/VanRyvVs
	 mzdDPtv6fYLLFDo7Wt5fnOI1ocTv3aFXFSG+lhlh0Yj89Ir425ifoTxxw/lllt5iDIkd4
	 CRHPkHC8U7xPLXojuF1pzh0OeMfz2yHQ/kcINMV9ys8YE92hSCpv7o0HKxNLi6NBxsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/HAIJ/Csd2OFYbx2SuKtJhTkuSeQ1dB7mYOmjxXbNWc=;
	b=p+nnPkRWeFdd0eTiXkB0KKS84G95/yHQDnoZ+SXU+vXfj+6zwPtT2rm4V3wwJG/qv8+9
	 pmUe0HMfSODTT2Ond9yS6Wv7BKZlTtYEqsZaIBNXCsqFsr3/gHLtwKuTr6bCQGBEKmg/o
	 my9dgbCBsh5wpwPuVurq72rB2G209vnfVLYsT8NPbgrSslWt0YZVX6HEpm3Z50vQqe/RF
	 a4Da19Shm8KIU4U9bSd5sabsyn4VRsfihYyE2rm4dDn9I8mgvJBsT/Fp/K7WQ3XSmET3h
	 v+AiAkDDbmyv+6/QwCcYOAeZbyw4g7JvFEhFqEXpLCBPxDz8ap34ZaFiDeBE8pZkZMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vdGfl5Xy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB929606A92E;
	Wed, 18 Nov 2026 19:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vdGfl5Xy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD1E1F000C4;
	Wed, 18 Nov 2026 19:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030800;
	bh=/HAIJ/Csd2OFYbx2SuKtJhTkuSeQ1dB7mYOmjxXbNWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vdGfl5Xy9LcHgxke5w57wN8xcb5k6W5sS8BH11SxCfZXGYRuYVUHA30ztK8SsYETC
	 SmOe0RcN3erwRo++0VpVR1w5rCD93mV8DeBkJJKgZ24huHtIJzIea/NkagW8zFIjCe
	 1iTOAR5pSJLdTM31O3gGraifY1A3brL9ypLGHbHU=
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
Subject: [PATCH 6.12 0792/1756] phy: rockchip: usbdp: Only enable USB3 when not in high-speed mode
Date: Wed, 18 Nov 2026 15:48:39 +0100
Message-ID: <20261118150041.234317067@linuxfoundation.org>
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

[ Upstream commit fbbf6c85b08008bf68ef49931175edeaa36ba82f ]

Ensure that USB3 mode is not accidently enabled during PHY re-init
for systems that are configured as high-speed only via DT.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/message/20260626212424.C215E1F000E9%40smtp.kernel.org
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-part2-v15-11-8d507cb1174f@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index a2af4443fc067..896000513e4b6 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -974,7 +974,7 @@ static int rk_udphy_power_on(struct rk_udphy *udphy, u8 mode)
 		if (ret)
 			return ret;
 
-		if (udphy->mode & UDPHY_MODE_USB)
+		if (!udphy->hs && udphy->mode & UDPHY_MODE_USB)
 			rk_udphy_u3_port_disable(udphy, false);
 		udphy->phy_needs_reinit = false;
 	} else if (udphy->phy_needs_reinit) {
-- 
2.53.0



