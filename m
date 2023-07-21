Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF131F94B
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19D7C433C8;
	Fri, 21 Jul 2023 18:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965970;
	bh=TIoUDTCuSLsIFXgJbFALJzRmlfUQo0JvUeBVbYwVta8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9w7CpZHC8iPRIsFPHzawe01+h0WDO/0v0u4kvfPzewv5tHM3JvnK/+S3f53/sgHw
	 dUAPjw+Ov+78iPXsbmJlUYXRRf0Rebth8lPqbKhBN6vzyxNAU2HdzjpdLIEBqU3ZlM
	 4++9oPJAl7pNepsFmh3VYpt2Fi5wsBVyXXmwQemw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allen-KH Cheng <allen-kh.cheng@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/532] arm64: dts: mediatek: Add cpufreq nodes for MT8192
Date: Fri, 21 Jul 2023 18:01:23 +0200
Message-ID: <20230721160624.090747810@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Allen-KH Cheng <allen-kh.cheng@mediatek.com>

[ Upstream commit 9d498cce9298a71e3896e2d1aee24a1a4c531d81 ]

Add the cpufreq nodes for MT8192 SoC.

Signed-off-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
Tested-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230317061944.15434-1-allen-kh.cheng@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Stable-dep-of: a4366b5695c9 ("arm64: dts: mediatek: mt8192: Fix CPUs capacity-dmips-mhz")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192.dtsi b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
index 9ed1a72295747..19ba781729722 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
@@ -41,6 +41,7 @@ cpu0: cpu@0 {
 			clock-frequency = <1701000000>;
 			cpu-idle-states = <&cpu_sleep_l &cluster_sleep_l>;
 			next-level-cache = <&l2_0>;
+			performance-domains = <&performance 0>;
 			capacity-dmips-mhz = <530>;
 		};
 
@@ -52,6 +53,7 @@ cpu1: cpu@100 {
 			clock-frequency = <1701000000>;
 			cpu-idle-states = <&cpu_sleep_l &cluster_sleep_l>;
 			next-level-cache = <&l2_0>;
+			performance-domains = <&performance 0>;
 			capacity-dmips-mhz = <530>;
 		};
 
@@ -63,6 +65,7 @@ cpu2: cpu@200 {
 			clock-frequency = <1701000000>;
 			cpu-idle-states = <&cpu_sleep_l &cluster_sleep_l>;
 			next-level-cache = <&l2_0>;
+			performance-domains = <&performance 0>;
 			capacity-dmips-mhz = <530>;
 		};
 
@@ -74,6 +77,7 @@ cpu3: cpu@300 {
 			clock-frequency = <1701000000>;
 			cpu-idle-states = <&cpu_sleep_l &cluster_sleep_l>;
 			next-level-cache = <&l2_0>;
+			performance-domains = <&performance 0>;
 			capacity-dmips-mhz = <530>;
 		};
 
@@ -85,6 +89,7 @@ cpu4: cpu@400 {
 			clock-frequency = <2171000000>;
 			cpu-idle-states = <&cpu_sleep_b &cluster_sleep_b>;
 			next-level-cache = <&l2_1>;
+			performance-domains = <&performance 1>;
 			capacity-dmips-mhz = <1024>;
 		};
 
@@ -96,6 +101,7 @@ cpu5: cpu@500 {
 			clock-frequency = <2171000000>;
 			cpu-idle-states = <&cpu_sleep_b &cluster_sleep_b>;
 			next-level-cache = <&l2_1>;
+			performance-domains = <&performance 1>;
 			capacity-dmips-mhz = <1024>;
 		};
 
@@ -107,6 +113,7 @@ cpu6: cpu@600 {
 			clock-frequency = <2171000000>;
 			cpu-idle-states = <&cpu_sleep_b &cluster_sleep_b>;
 			next-level-cache = <&l2_1>;
+			performance-domains = <&performance 1>;
 			capacity-dmips-mhz = <1024>;
 		};
 
@@ -118,6 +125,7 @@ cpu7: cpu@700 {
 			clock-frequency = <2171000000>;
 			cpu-idle-states = <&cpu_sleep_b &cluster_sleep_b>;
 			next-level-cache = <&l2_1>;
+			performance-domains = <&performance 1>;
 			capacity-dmips-mhz = <1024>;
 		};
 
@@ -234,6 +242,12 @@ soc {
 		compatible = "simple-bus";
 		ranges;
 
+		performance: performance-controller@11bc10 {
+			compatible = "mediatek,cpufreq-hw";
+			reg = <0 0x0011bc10 0 0x120>, <0 0x0011bd30 0 0x120>;
+			#performance-domain-cells = <1>;
+		};
+
 		gic: interrupt-controller@c000000 {
 			compatible = "arm,gic-v3";
 			#interrupt-cells = <4>;
-- 
2.39.2



