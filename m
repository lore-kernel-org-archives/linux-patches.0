Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D502253F3;
	Mon,  2 Jun 2025 14:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874725; cv=none; b=D8jXxLKG3YXxhE5DVqicjYTSFioGu/N5ZPlNNOeKHwJqkaYmgymtUlyblIyxRKnD2YKA82BYTGHU7yxB+ExHPxZlWwD3y5W/ceprziPXjdm21UTNGZWf3XfRxmEs12Rut+wv7j3rUPz4kKl1M8O28vXD2kGxGwWFJmWlC65ubvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874725; c=relaxed/simple;
	bh=k3EZ36QuWXKUhH2+ZQT4FtZbVQZdKfXRPX15OMR+tdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmAXov5mFcM4vKxsi/mZKpSRVh+YUpdUv8kMhyMxBoJc1WjiwumxeEObwg5KCsdzFTHGe4fATSveVUB/wlxow8F0sShoBDY7YDCfXFmbwwJauD1rZ7LjG0yDSv9gsSLkml1eSUdvPa1bhz/QhwlP+RV8c+myK027MrQXZ+yNmbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bi3+p+zQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bi3+p+zQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48843C4CEEB;
	Mon,  2 Jun 2025 14:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874725;
	bh=k3EZ36QuWXKUhH2+ZQT4FtZbVQZdKfXRPX15OMR+tdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bi3+p+zQa6BlCaVvz53aURPkD2dnspa/vnaBG8XwiwvAh1McCUxKPQzIoRfQ1wYRU
	 CuNoEmExWijbX+VitPzYut63qoG7gvbo5L3Sv0OaxYJ6vH45TtwrLJnpG0QLv7ayNm
	 Un+lDuSzyChtrtpVu7t6LeU53Ky91aZ8NcspC6Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/204] ARM: tegra: Switch DSI-B clock parent to PLLD on Tegra114
Date: Mon,  2 Jun 2025 15:47:30 +0200
Message-ID: <20250602134300.253706836@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/tegra114.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index 0d7a6327e404a..fe1ebc3c5aa86 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -123,7 +123,7 @@ dsi@54400000 {
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



