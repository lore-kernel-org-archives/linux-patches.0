Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040766;
	b=5i0KWr6TJf2EiW5cPQuNSFNQ+T9JYwPP+ih74ufWvp65X16K8IhCeLxjkz2VYro2zHba
	 mbwnYxVc4zfTlgnZjKMr9WYn0kf3eplFk4o1ROueBOTJpW2uRxT0ilt3x9LPGhlPLpLE2
	 0QDsK8GDjjX2vU/vVh86ky84lwrUFI/v9S97qu/0o6aX2zXm2RQ/aRw2ftuc0bY4ViQuz
	 Z5TcitljUJ/UWbgvfkUO7oHasSQngSq1TX4Cg9N1Kz7wQahMczn/w0Wp9vavUv2Iz58AT
	 glUHfeGESA3j1e5Wxj0oBrfcNFEwZSOTjQYLKlRl7RxRSQ44chfnmt2TiwBvAwNZGpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EhPx99wB8yeI3fXoXntQf/1S1qRompkn/BRyjk3kBj8=;
	b=JLTifW2y/3PE0ICr1QA+NKzHYQO9LhOr0uYZPv8TnjAzwVy+xm/ASSMyjCvrgY5oDdPy
	 SjE5tDZztaJdgkXRnl2nNugJUKaYMZSkGqki64BDekwHuX99vr+ZRIxoVyX5++3aQKfWH
	 bPg4BweS9WOz6TKh555kHDo7NS7ksyDnuRuQD5R0U4cQHtdQ26CceATP2d1BL7qcdalkO
	 1wi43jji+k+NjGlZqCD/zeV6ECgVnHeVR0EtxzaJwTy6j6zIuiqzhf3EXp3RdLg7CxK/g
	 dIMPdwpI/zFtlH4mX9UV2X7eVHdhkwY+VISaPBb0cVFgzv0D07UHChVZ30+d9zplv6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bfnyTlx5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B32A606A325;
	Wed, 18 Nov 2026 22:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bfnyTlx5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A3D1F000C4;
	Wed, 18 Nov 2026 22:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040766;
	bh=EhPx99wB8yeI3fXoXntQf/1S1qRompkn/BRyjk3kBj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bfnyTlx5tCQuFFj3cDKrfjHa14CGBkOTzp4HnT7mgs5lWkcqXCnLoxoWC4C4FqN6+
	 z5cvkS7NVJ2GCZLOT3T4TZ5ur67m5UOPtEF2b4QQEudfg64IIq7SXHTqJyaoQ8X70/
	 Y+SAvZV3nQ/G6AMTmHLeaT6XwMLvxEvY/gUc0rNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Anand Moon <linux.amoon@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2573/3318] arm64: dts: rockchip: Add cache information to the SoC dtsi for RK356x
Date: Wed, 18 Nov 2026 15:53:15 +0100
Message-ID: <20261118150438.412808791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

[ Upstream commit 8612169a05c5e979af033868b7a9b177e0f9fcdf ]

Add missing cache information to the Rockchip RK356x SoC dtsi, to allow
the userspace, which includes lscpu(1) that uses the virtual files provided
by the kernel under the /sys/devices/system/cpu directory, to display the
proper RK3566 and RK3568 cache information.

Adding the cache information to the RK356x SoC dtsi also makes the following
warning message in the kernel log go away:

  cacheinfo: Unable to detect cache hierarchy for CPU 0

The cache parameters for the RK356x dtsi were obtained and partially derived
by hand from the cache size and layout specifications found in the following
datasheets and technical reference manuals:

  - Rockchip RK3566 datasheet, version 1.1
  - Rockchip RK3568 datasheet, version 1.3
  - ARM Cortex-A55 revision r1p0 TRM, version 0100-00
  - ARM DynamIQ Shared Unit revision r4p0 TRM, version 0400-02

For future reference, here's a rather detailed summary of the documentation,
which applies to both Rockchip RK3566 and RK3568 SoCs:

  - All caches employ the 64-byte cache line length
  - Each Cortex-A55 core has 32 KB of L1 4-way, set-associative instruction
    cache and 32 KB of L1 4-way, set-associative data cache
  - There are no L2 caches, which are per-core and private in Cortex-A55,
    because it belongs to the ARM DynamIQ IP core lineup
  - The entire SoC has 512 KB of unified L3 16-way, set-associative cache,
    which is shared among all four Cortex-A55 CPU cores
  - Cortex-A55 cores can be configured without private per-core L2 caches,
    in which case the shared L3 cache appears to them as an L2 cache;  this
    is the case for the RK356x SoCs, so let's use "cache-level = <2>" to
    prevent the "huh, no L2 caches, but an L3 cache?" confusion among the
    users viewing the data presented to the userspace;  another option could
    be to have additional 0 KB L2 caches defined, which may be technically
    correct, but would probably be even more confusing

Helped-by: Anand Moon <linux.amoon@gmail.com>
Tested-By: Diederik de Haas <didi.debian@cknow.org>
Reviewed-by: Anand Moon <linux.amoon@gmail.com>
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/2dee6dad8460b0c5f3b5da53cf55f735840efef1.1709957777.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: 8043ed0f40fe ("arm64: dts: rockchip: Rename rk3566 and rk3568 HDMI audio cards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 41 ++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index 6377f2a0b4017..36c97ce9dcf9c 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -57,6 +57,13 @@ cpu0: cpu@0 {
 			#cooling-cells = <2>;
 			enable-method = "psci";
 			operating-points-v2 = <&cpu0_opp_table>;
+			i-cache-size = <0x8000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <128>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <128>;
+			next-level-cache = <&l3_cache>;
 		};
 
 		cpu1: cpu@100 {
@@ -66,6 +73,13 @@ cpu1: cpu@100 {
 			#cooling-cells = <2>;
 			enable-method = "psci";
 			operating-points-v2 = <&cpu0_opp_table>;
+			i-cache-size = <0x8000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <128>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <128>;
+			next-level-cache = <&l3_cache>;
 		};
 
 		cpu2: cpu@200 {
@@ -75,6 +89,13 @@ cpu2: cpu@200 {
 			#cooling-cells = <2>;
 			enable-method = "psci";
 			operating-points-v2 = <&cpu0_opp_table>;
+			i-cache-size = <0x8000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <128>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <128>;
+			next-level-cache = <&l3_cache>;
 		};
 
 		cpu3: cpu@300 {
@@ -84,9 +105,29 @@ cpu3: cpu@300 {
 			#cooling-cells = <2>;
 			enable-method = "psci";
 			operating-points-v2 = <&cpu0_opp_table>;
+			i-cache-size = <0x8000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <128>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <128>;
+			next-level-cache = <&l3_cache>;
 		};
 	};
 
+	/*
+	 * There are no private per-core L2 caches, but only the
+	 * L3 cache that appears to the CPU cores as L2 caches
+	 */
+	l3_cache: l3-cache {
+		compatible = "cache";
+		cache-level = <2>;
+		cache-unified;
+		cache-size = <0x80000>;
+		cache-line-size = <64>;
+		cache-sets = <512>;
+	};
+
 	cpu0_opp_table: opp-table-0 {
 		compatible = "operating-points-v2";
 		opp-shared;
-- 
2.53.0



