Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B899827933A;
	Tue, 27 May 2025 17:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367066; cv=none; b=gUoS/3fYhhCl10GzQzfnaT0gIFEwFtclv7wl1GBJxDhdzJxWpsaOCT9pEPBg6Vf/nUKEdaN1HEz0WOrAeIQCakcNmNEysDTBvGEYc2PP8cKw7lzaOl/CIm0anSovrwp562wcCilNkHd8a4E2ySCxeGkG2pKCNYf4USCIo9skv0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367066; c=relaxed/simple;
	bh=seRx0GDP/yst4KbJxNsjNxzDhKH9aTNvFlDsDL0yDkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMzLaCJO0B3D4AyoAfW9g506J+TKc+3XJR+l76b2mT9TbkU+CW3XmKvtoQK0JhdOzbQJpx3ppklNSITCvBG80l+xlIo4CJReXTaOk/CIfPpRUCRMFD8QaKXkSY/VCMZdWEYcjeyqqWcgfes6TUe4gtAzkWPRFNsStIH7LKD9Hi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klsgOoBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klsgOoBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BE7C4CEE9;
	Tue, 27 May 2025 17:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367066;
	bh=seRx0GDP/yst4KbJxNsjNxzDhKH9aTNvFlDsDL0yDkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klsgOoBoQPaCqNsDA8JBkgRSmg38CEpAxlkfm/PC2nOw3rgSOqR96JytyZRHFSVle
	 5X+v6FrBNHsiy8/pB14RZUqtUjqXtNG3shdv8Z8u7Nj7PY00pqHhaSLgOZ+DkkE8vw
	 iMjUGEaAWwyYxEud9bgOAG2Y2fprmn+xWh1t+BVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 267/783] ARM: tegra: Switch DSI-B clock parent to PLLD on Tegra114
Date: Tue, 27 May 2025 18:21:04 +0200
Message-ID: <20250527162523.963890070@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



