Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DFC2EB5CF;
	Tue, 17 Jun 2025 16:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177780; cv=none; b=DZl6Kf9C2iebAhEwyR3sjlStMtMJVUbK5v1CR3YCyowQ3eteGxXeq7mLs2XlUgBpZaMWGbF6r36xdFeHlJCGgSt8WwMyZSzmfjRBtvdfnupFdxsGCdp+woTOUlKm2Aw4pmijzHmIqny6ezsMg/jEl/PVY3h5p31U/38yzOO9Qt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177780; c=relaxed/simple;
	bh=P3Z+cejXi+BlI9dR0Kdom6YfuVijerW02F900iFhjao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3VPvXyCZ87bCA7pbGOaEcfG/iTA07aCzUAcnAmg/7T3DFaLlo9ejfh0qxv7oI0AFaeaCne2eM+8XbqBf0gS4+UXBLnR4gklI5H0oYkfrArhPpG7fKBdFU1HsNcy5JkgVQrmYGDCVqhaTxq8zsl77+maoBwIQk0r9oLFJ7V1j0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsPiXriS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsPiXriS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C90C4CEE3;
	Tue, 17 Jun 2025 16:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177780;
	bh=P3Z+cejXi+BlI9dR0Kdom6YfuVijerW02F900iFhjao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsPiXriSu9XvgkLIyd6nsNOvPOwrI0mAwOEPFFAtXRzY6bpqsWTy6GbuFkInHirZ1
	 s119PDF0aamqAIojNcLbuEmhLl/OLPYqiUwDFaQ+5b5Iw7NuARPkX9SRs2b9Z4wmKu
	 s7xh2uVsQMwH7VV3tZ40A4ly1J+Grs+RU70Kot8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 362/780] arm64: dts: rockchip: Add missing uart3 interrupt for RK3528
Date: Tue, 17 Jun 2025 17:21:10 +0200
Message-ID: <20250617152506.201541389@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit a37d21a9b45e47ed6bc1f94e738096c07db78a07 ]

The interrupt of uart3 node on rk3528 is missing, fix it.

Fixes: 7983e6c379a9 ("arm64: dts: rockchip: Add base DT for rk3528 SoC")
Reviewed-by: Yao Zi <ziyao@disroot.org>
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Link: https://lore.kernel.org/r/20250401100020.944658-2-amadeus@jmu.edu.cn
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3528.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3528.dtsi b/arch/arm64/boot/dts/rockchip/rk3528.dtsi
index 26c3559d6a6de..7f1ffd6003f58 100644
--- a/arch/arm64/boot/dts/rockchip/rk3528.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3528.dtsi
@@ -404,9 +404,10 @@
 
 		uart3: serial@ffa08000 {
 			compatible = "rockchip,rk3528-uart", "snps,dw-apb-uart";
+			reg = <0x0 0xffa08000 0x0 0x100>;
 			clocks = <&cru SCLK_UART3>, <&cru PCLK_UART3>;
 			clock-names = "baudclk", "apb_pclk";
-			reg = <0x0 0xffa08000 0x0 0x100>;
+			interrupts = <GIC_SPI 43 IRQ_TYPE_LEVEL_HIGH>;
 			reg-io-width = <4>;
 			reg-shift = <2>;
 			status = "disabled";
-- 
2.39.5



