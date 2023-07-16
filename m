Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE3A8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974FFC433C7;
	Sun, 16 Jul 2023 20:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538305;
	bh=ShogA3wFM7YEKbrmd0qPdQo1chb4s7R1gnfKM6tCKpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWFx7QRk6t1WF/sNps3YpfuaByHavoaWPcq+QqlsuvY5hlFrmJg7W7ntWxqKDHADR
	 a05pRlzmP6rAyPaLxbYrzZx2Lk+9lYrSi+Usjw5E458p02qj+VOZyfmUW2kXDLfYel
	 K7nWksx0kT2V/nOMeEL61cGBYfqy9RXCS5tEUPFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 404/800] arm64: dts: mediatek: mt8192: Fix CPUs capacity-dmips-mhz
Date: Sun, 16 Jul 2023 21:44:17 +0200
Message-ID: <20230716194958.456144727@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit a4366b5695c984b8a3fc8b31de9e758c8f6d1aed ]

The capacity-dmips-mhz parameter was miscalculated: this SoC runs
the first (Cortex-A55) cluster at a maximum of 2000MHz and the
second (Cortex-A76) cluster at a maximum of 2200MHz.

In order to calculate the right capacity-dmips-mhz, the following
test was performed:
1. CPUFREQ governor was set to 'performance' on both clusters
2. Ran dhrystone with 500000000 iterations for 10 times on each cluster
3. Calculated the mean result for each cluster
4. Calculated DMIPS/MHz: dmips_mhz = dmips_per_second / cpu_mhz
5. Scaled results to 1024:
   result_c0 = dmips_mhz_c0 / dmips_mhz_c1 * 1024

The mean results for this SoC are:
Cluster 0 (LITTLE): 12016411 Dhry/s
Cluster 1 (BIG): 31702034 Dhry/s

The calculated scaled results are:
Cluster 0: 426.953226899238 (rounded to 427)
Cluster 1: 1024

Fixes: 48489980e27e ("arm64: dts: Add Mediatek SoC MT8192 and evaluation board dts and Makefile")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230602183515.3778780-1-nfraprado@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192.dtsi b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
index 6593cd0ef2972..75eeba539e6fe 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
@@ -71,7 +71,7 @@ cpu0: cpu@0 {
 			d-cache-sets = <128>;
 			next-level-cache = <&l2_0>;
 			performance-domains = <&performance 0>;
-			capacity-dmips-mhz = <530>;
+			capacity-dmips-mhz = <427>;
 		};
 
 		cpu1: cpu@100 {
@@ -89,7 +89,7 @@ cpu1: cpu@100 {
 			d-cache-sets = <128>;
 			next-level-cache = <&l2_0>;
 			performance-domains = <&performance 0>;
-			capacity-dmips-mhz = <530>;
+			capacity-dmips-mhz = <427>;
 		};
 
 		cpu2: cpu@200 {
@@ -107,7 +107,7 @@ cpu2: cpu@200 {
 			d-cache-sets = <128>;
 			next-level-cache = <&l2_0>;
 			performance-domains = <&performance 0>;
-			capacity-dmips-mhz = <530>;
+			capacity-dmips-mhz = <427>;
 		};
 
 		cpu3: cpu@300 {
@@ -125,7 +125,7 @@ cpu3: cpu@300 {
 			d-cache-sets = <128>;
 			next-level-cache = <&l2_0>;
 			performance-domains = <&performance 0>;
-			capacity-dmips-mhz = <530>;
+			capacity-dmips-mhz = <427>;
 		};
 
 		cpu4: cpu@400 {
-- 
2.39.2



