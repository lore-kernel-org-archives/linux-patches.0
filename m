Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4F513247D;
	Wed,  3 Jul 2024 11:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005194; cv=none; b=V+Ll+mi3kFyjWKrRsi0u7HN1ga/K7iORSEPirLT1ecPewRh2k2BikiT8SYfFay87Fy8K+OXZMSjp40EJ1XnNpFyYm6mw9UI6YAbts+PXS/FfoYCFw1mQhR/yTLtOUhvGazWyG+zTeZI2oP2ilj2peJggnUHD7G7Ep7NxB4I1W/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005194; c=relaxed/simple;
	bh=HDxen3Ndnr7Eh8dFvEkKhSzq7OCliTiT4AE8kfBYwuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ju4FED1q97/6KmjeVbdfyM+nKOIJgtfbMMCYTVF8P5UJ/vPZRqrqBX80vmv8wNvf7eqUHiyOlGCsZRDBkWSvbbHIFRBFLLXXRn+ivPcfRz6y5/5tW/CH7LBzC4dvG8XNMpN7seye8CZIpBsUNBTxAKKWK6hvH9nuIupzYi/gbEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lf2tImcD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lf2tImcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61C6C2BD10;
	Wed,  3 Jul 2024 11:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005194;
	bh=HDxen3Ndnr7Eh8dFvEkKhSzq7OCliTiT4AE8kfBYwuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lf2tImcDLWc4P1y75o3UxE4BSj6fOOt9lBE/7KSzVgbZ3qdhmRVyDGP/uhmricitG
	 1mz1RjVR6Cv5I5Y4LMlZsXwPzEiDr/EitryROQPdgkPrs21aL4Y+yo+fRMZ1tBDCO7
	 yanCT0ulIUBuC8ZjUlY2PVhn78ri4Eob8a7ggF24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 289/290] arm64: dts: rockchip: Add sound-dai-cells for RK3368
Date: Wed,  3 Jul 2024 12:41:10 +0200
Message-ID: <20240703102915.063340172@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit 8d7ec44aa5d1eb94a30319074762a1740440cdc8 ]

Add the missing #sound-dai-cells for RK3368's I2S and S/PDIF controllers.

Fixes: f7d89dfe1e31 ("arm64: dts: rockchip: add i2s nodes support for RK3368 SoCs")
Fixes: 0328d68ea76d ("arm64: dts: rockchip: add rk3368 spdif node")
Signed-off-by: Alex Bee <knaerzche@gmail.com>
Link: https://lore.kernel.org/r/20240623090116.670607-4-knaerzche@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3368.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3368.dtsi b/arch/arm64/boot/dts/rockchip/rk3368.dtsi
index 3746f23dc3df4..bc4df59df3f1e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3368.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3368.dtsi
@@ -687,6 +687,7 @@
 		dma-names = "tx";
 		pinctrl-names = "default";
 		pinctrl-0 = <&spdif_tx>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 	};
 
@@ -698,6 +699,7 @@
 		clocks = <&cru SCLK_I2S_2CH>, <&cru HCLK_I2S_2CH>;
 		dmas = <&dmac_bus 6>, <&dmac_bus 7>;
 		dma-names = "tx", "rx";
+		#sound-dai-cells = <0>;
 		status = "disabled";
 	};
 
@@ -711,6 +713,7 @@
 		dma-names = "tx", "rx";
 		pinctrl-names = "default";
 		pinctrl-0 = <&i2s_8ch_bus>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 	};
 
-- 
2.43.0



