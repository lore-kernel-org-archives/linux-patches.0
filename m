Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030837;
	b=pVytHfP7En6g7dSl3bhGi2qrBS+HzX27QjUT/hReUKTYTDVKx2oPaXnANRXAZffxnGU1
	 OKNVeich5Uvz+IyeqViyHGOQlz/pfjy+UddJw6y8JDc38/z7M3GducZY2ZZAG7HnRWXVj
	 vdtjTt7G2b0+/yQavtEIiRm1crYxekAlQiDMzyx3z1N6Fs+K0aZ/lOoaQimelzR+BQe9j
	 fjIRze76gynAWdDYfaSvm+Q6qxpabvwhYXj/zf1PgG7l8Aa+cRzJs9gKDsihoVW90oQ5G
	 vE19/Ihlgc7kBMC+pcv7ju1WLmlXthCHbePSmV7KTS5FD6ARBpYG0oWq7QYCEQTRQww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KW73rSIgqubDJ7Lfbjrq+9dSbOly5tQd4BO6kMrUgT8=;
	b=0zfG7ViFILxBeI4fXsa/m4GRItnQ0rPDaTloccLPHbXQGmUZPtZtY30jiBEWMhVSWqX4
	 OwL5s5UQC5UyGTuxoEVyEPmld9X51prJg2/BM3vOeJxkMbz1N0bsXcELdCTqJSAkspyWP
	 zcZgzWysc2Nd4ikZxH1TG0HXZGpHMAIbIoxHvd9dkb10TSkVRr2DSxa5zdk28VpGrMZ8Z
	 adZICwG2tAcT+MC8GKKi9TmBPbthYkK/RiBMlg8FDghy2tFY0koIHQO7xdmzHjTZI8Per
	 ytnzropBC32kV53za8mO681+51chKUfL+++fYiYD0HqdXgoIFTg8/Onc0AWhM1SDeLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C7rzkdtl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0737F606C73C;
	Wed, 18 Nov 2026 19:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C7rzkdtl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1BA1F000C5;
	Wed, 18 Nov 2026 19:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030836;
	bh=KW73rSIgqubDJ7Lfbjrq+9dSbOly5tQd4BO6kMrUgT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7rzkdtlk54SPrm22qskzcLJB8YScKaBp8DlYVs2HIb0dcLmXV4Fbnks33XIsgyPM
	 klWDEEf84dwHMzdlEwOdkZONL5WKa1ceBosiQvVcDKfPiHdSSpjYpI+AWV9kYeD4TU
	 fb1y525oKboibn/kxn6VVLPrVFb1lkNCp7RRiSYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0847/1756] arm64: dts: rockchip: Update CPU OPP voltages in RK356x SoC dtsi
Date: Wed, 18 Nov 2026 15:49:34 +0100
Message-ID: <20261118150043.125997282@linuxfoundation.org>
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

From: Dragan Simic <dsimic@manjaro.org>

[ Upstream commit 0e183fcc92b0eaa13b33b39846d86c3d65b8330a ]

Update the lower/upper voltage limits and the exact voltages for the Rockchip
RK356x CPU OPPs, using the most conservative values (i.e. the highest per-OPP
voltages) found in the vendor kernel source. [1]

Using the most conservative per-OPP voltages ensures reliable CPU operation
regardless of the actual CPU binning, with the downside of possibly using
a bit more power for the CPU cores than absolutely needed.

Additionally, fill in the missing "clock-latency-ns" CPU OPP properties, using
the values found in the vendor kernel source. [1]

[1] https://raw.githubusercontent.com/rockchip-linux/kernel/f8b9431ee38ed561650be7092ab93f564598daa9/arch/arm64/boot/dts/rockchip/rk3568.dtsi

Related-to: eb665b1c06bc ("arm64: dts: rockchip: Update GPU OPP voltages in RK356x SoC dtsi")
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/f816cd24b62742dd05a1b7c6fe162bb581c9b3bf.1730516702.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: 8043ed0f40fe ("arm64: dts: rockchip: Rename rk3566 and rk3568 HDMI audio cards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568.dtsi |  1 +
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 18 ++++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
index 0d16f74949b6a..1a66230f3d89e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
@@ -274,6 +274,7 @@ &cpu0_opp_table {
 	opp-1992000000 {
 		opp-hz = /bits/ 64 <1992000000>;
 		opp-microvolt = <1150000 1150000 1150000>;
+		clock-latency-ns = <40000>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index 32ccc57555545..d62c81849f4bd 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -134,39 +134,45 @@ cpu0_opp_table: opp-table-0 {
 
 		opp-408000000 {
 			opp-hz = /bits/ 64 <408000000>;
-			opp-microvolt = <900000 900000 1150000>;
+			opp-microvolt = <850000 850000 1150000>;
 			clock-latency-ns = <40000>;
 		};
 
 		opp-600000000 {
 			opp-hz = /bits/ 64 <600000000>;
-			opp-microvolt = <900000 900000 1150000>;
+			opp-microvolt = <850000 850000 1150000>;
+			clock-latency-ns = <40000>;
 		};
 
 		opp-816000000 {
 			opp-hz = /bits/ 64 <816000000>;
-			opp-microvolt = <900000 900000 1150000>;
+			opp-microvolt = <850000 850000 1150000>;
+			clock-latency-ns = <40000>;
 			opp-suspend;
 		};
 
 		opp-1104000000 {
 			opp-hz = /bits/ 64 <1104000000>;
 			opp-microvolt = <900000 900000 1150000>;
+			clock-latency-ns = <40000>;
 		};
 
 		opp-1416000000 {
 			opp-hz = /bits/ 64 <1416000000>;
-			opp-microvolt = <900000 900000 1150000>;
+			opp-microvolt = <1025000 1025000 1150000>;
+			clock-latency-ns = <40000>;
 		};
 
 		opp-1608000000 {
 			opp-hz = /bits/ 64 <1608000000>;
-			opp-microvolt = <975000 975000 1150000>;
+			opp-microvolt = <1100000 1100000 1150000>;
+			clock-latency-ns = <40000>;
 		};
 
 		opp-1800000000 {
 			opp-hz = /bits/ 64 <1800000000>;
-			opp-microvolt = <1050000 1050000 1150000>;
+			opp-microvolt = <1150000 1150000 1150000>;
+			clock-latency-ns = <40000>;
 		};
 	};
 
-- 
2.53.0



