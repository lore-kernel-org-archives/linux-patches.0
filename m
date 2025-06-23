Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7611E22E6;
	Mon, 23 Jun 2025 21:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714804; cv=none; b=Q5ja3bRbAPegRVEJOEaXWSeZKl6h4tPIJOAaV3XBrLWxWVbfN2TvM7Q2GYGW4nalrx7/KNewGYdBEmDiAuKFr4gPZqcPVt5Ao3v4zRU97P7OvvMqRk9YF596VCTwcfZgHWJvtfriFTf4Ffxe2hv7GnJZNup4wKU2fi6N+P94CqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714804; c=relaxed/simple;
	bh=D56G/6sJ9WPNLl1wV1XxafQ5O/3ASuDtPGjqalTgrBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9aDq1wgH3TG/MJ8+8lRKs5eH82cEOXZnkOHEO9rdNAr4MlqreorEMX/caL2EFvx0Fsbp9uH8Sxa711vP8DwDCwyvwBgde5+OZwbiOQQfLEErpyBCrGfgtq+SdTrOUEjuUm2uPMYjwAwDCqmtsBTicjI0Gt6QIliO5M9+IiNH8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ytn+k+0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ytn+k+0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B67C4CEEA;
	Mon, 23 Jun 2025 21:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714804;
	bh=D56G/6sJ9WPNLl1wV1XxafQ5O/3ASuDtPGjqalTgrBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ytn+k+0dVo374eTQ4LQQAKYX4givUWIs5DH+0lh5uVrL+Xp5FBG4mN6xGT/gvZT7w
	 7y0qeXctwmHP/KcGBwVIOWKxOJL18rc9C1JDJsI7bfCWycxRvice4uFtTvsiSVd4pe
	 jBaUPWM08AFZmcWLcOAVANTkd80vyfIr4Go9rJ40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 217/508] arm64: dts: ti: k3-am65-main: Drop deprecated ti,otap-del-sel property
Date: Mon, 23 Jun 2025 15:04:22 +0200
Message-ID: <20250623130650.601866395@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

[ Upstream commit 2b9bb988742d1794e78d4297a99658f38477eedd ]

ti,otap-del-sel has been deprecated in favor of ti,otap-del-sel-legacy.

Drop the duplicate and misleading ti,otap-del-sel property.

Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20230607132043.3932726-3-nm@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Stable-dep-of: f55c9f087cc2 ("arm64: dts: ti: k3-am65-main: Add missing taps to sdhci0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index 83dd8993027ab..9854cf0e7f7b4 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -295,7 +295,6 @@ sdhci1: mmc@4fa0000 {
 		ti,otap-del-sel-ddr52 = <0x4>;
 		ti,otap-del-sel-hs200 = <0x7>;
 		ti,clkbuf-sel = <0x7>;
-		ti,otap-del-sel = <0x2>;
 		ti,trm-icp = <0x8>;
 		dma-coherent;
 	};
-- 
2.39.5



