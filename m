Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8F928032B;
	Tue, 27 May 2025 16:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364959; cv=none; b=nCun1+xVEs6oQoVSjmedX/keeSKSHsA3EGmFAbHLGwy2QZPM0hg+71XTbfB/LHBa90cbUt9NpcLJfJzXerN5wu8FaidJ55KPKZPqie/DAbRYuTEqYmFRpUbMJYvYXpX/ALDWTnbnhquekxsCpb7GEgSt3bMO4TiMUKmW3JugYkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364959; c=relaxed/simple;
	bh=qwFMYuzSuLy0vGHf2ZI+un3E3V0WmgllWklug6JAfMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aoodh23t1xDBVEXU/PFWzUhY6EdCpBTpP2/AnP3XFM2YO9QWwn2LTSChbFb5Cm94CXOv5+7ios/oDywlAp4WhTBzux7YLWiRYone4/2tztRr0BND9dVbIcVVvAwsLN4Lq548f6SW/eg/LuvIRJk554e+vFviozZvClA+hnek46c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WyeiCr2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WyeiCr2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F5BC4CEEB;
	Tue, 27 May 2025 16:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364959;
	bh=qwFMYuzSuLy0vGHf2ZI+un3E3V0WmgllWklug6JAfMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WyeiCr2JrtFYF3Ec0Gw8j6SkAaTE0iA+A0V1N/kQX5SB9mIkByxLNWaFylSEz8CGd
	 Uph/4kJ+ygqWKNt6WKpLBffs7Egpqc854NgzphxMn9XVLKD6yAnFLBGWdOTjuLpTCY
	 Zxo3HyGDoQ+wK0m1Aqn2kvGRCRSZ9jMZNplhe9BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/626] ARM: tegra: Switch DSI-B clock parent to PLLD on Tegra114
Date: Tue, 27 May 2025 18:21:55 +0200
Message-ID: <20250527162454.037128319@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 2b3db788f2f614b875b257cdb079adadedc060f3 ]

PLLD is usually used as parent clock for internal video devices, like
DSI for example, while PLLD2 is used as parent for HDMI.

Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Link: https://lore.kernel.org/r/20250226105615.61087-3-clamor95@gmail.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nvidia/tegra114.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nvidia/tegra114.dtsi b/arch/arm/boot/dts/nvidia/tegra114.dtsi
index 86f14e2fd29f3..6c057b5069514 100644
--- a/arch/arm/boot/dts/nvidia/tegra114.dtsi
+++ b/arch/arm/boot/dts/nvidia/tegra114.dtsi
@@ -139,7 +139,7 @@ dsib: dsi@54400000 {
 			reg = <0x54400000 0x00040000>;
 			clocks = <&tegra_car TEGRA114_CLK_DSIB>,
 				 <&tegra_car TEGRA114_CLK_DSIBLP>,
-				 <&tegra_car TEGRA114_CLK_PLL_D2_OUT0>;
+				 <&tegra_car TEGRA114_CLK_PLL_D_OUT0>;
 			clock-names = "dsi", "lp", "parent";
 			resets = <&tegra_car 82>;
 			reset-names = "dsi";
-- 
2.39.5



