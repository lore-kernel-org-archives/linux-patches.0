Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4FA1F7540;
	Tue,  3 Dec 2024 15:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238163; cv=none; b=NuxY9odxw7zYy1+PvnAds+wtT0IOnHJZklg7LqGOCPOpVOclvqNSu9WgSRYkwv4w+AsSPenB4vlUQMlzHnaPMfgBdgWuvlKA/L//4xV10iPTGA0Z3zfgeVd8vF274FHNdqGOJThvyt7K4dN/Gq0s6NeDDcvbR5j3rEGwRV4N/xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238163; c=relaxed/simple;
	bh=Ohgl7pXoWpsbAZU6o1uXKgmp4lhDD3FeZFDfVK0cUco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOzY3iSaUvELQmLtrXgKjs1mqm0mpLcED4GCGTjQcjnq3m2GXElepQLGhOpWbQaCbhKyUNeS3AdQYN6b9p0zD65jtWuWcsqCXce/y45M6sAoK4AMk0iZEfJkD/X2mg/3Gr4OMJ67vEn0Coj/QvUQzu/CUi6AfY0ymnHNSxf23Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eAaCFSsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eAaCFSsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1962FC4CEDA;
	Tue,  3 Dec 2024 15:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238163;
	bh=Ohgl7pXoWpsbAZU6o1uXKgmp4lhDD3FeZFDfVK0cUco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eAaCFSsIQfkbaS7lJGrkH/B2xSWLsHeHGWowrGEAZo0STzt4YumKo8cqOpFpYJQRJ
	 yjR1I0t/SNPcFk/8J/Cq0CHNQk+tLy80i+RBL75bFjVss5y6uEZPTTzeC2IgkY2DZ4
	 e8KOCacomcxSDgB5rPDu4dxmruQBmTslCXNmWA04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anurag Dutta <a-dutta@ti.com>,
	Aniket Limaye <a-limaye@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 184/817] arm64: dts: ti: k3-j7200: Fix clock ids for MCSPI instances
Date: Tue,  3 Dec 2024 15:35:56 +0100
Message-ID: <20241203144002.913427047@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anurag Dutta <a-dutta@ti.com>

[ Upstream commit 3a47e381670f130870caef6e1155ac531b17b032 ]

The clock IDs for multiple MCSPI instances across wakeup as
well as main domain in J7200 are incorrect when compared with
documentation [1]. This results in kernel crashes when the said
instances are enabled. Fix the clock ids to their appropriate
values.

[1]https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/j7200/clocks.html

Fixes: 8f6c475f4ca7 ("arm64: dts: ti: k3-j7200: Add MCSPI nodes")

Signed-off-by: Anurag Dutta <a-dutta@ti.com>
Reviewed-by: Aniket Limaye <a-limaye@ti.com>
Link: https://lore.kernel.org/r/20241023104532.3438851-2-a-dutta@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi       | 16 ++++++++--------
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi |  6 +++---
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
index 41adfa64418d0..1d11da926a871 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
@@ -1163,7 +1163,7 @@ main_spi0: spi@2100000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 266 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 266 1>;
+		clocks = <&k3_clks 266 4>;
 		status = "disabled";
 	};
 
@@ -1174,7 +1174,7 @@ main_spi1: spi@2110000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 267 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 267 1>;
+		clocks = <&k3_clks 267 4>;
 		status = "disabled";
 	};
 
@@ -1185,7 +1185,7 @@ main_spi2: spi@2120000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 268 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 268 1>;
+		clocks = <&k3_clks 268 4>;
 		status = "disabled";
 	};
 
@@ -1196,7 +1196,7 @@ main_spi3: spi@2130000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 269 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 269 1>;
+		clocks = <&k3_clks 269 4>;
 		status = "disabled";
 	};
 
@@ -1207,7 +1207,7 @@ main_spi4: spi@2140000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 270 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 270 1>;
+		clocks = <&k3_clks 270 2>;
 		status = "disabled";
 	};
 
@@ -1218,7 +1218,7 @@ main_spi5: spi@2150000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 271 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 271 1>;
+		clocks = <&k3_clks 271 4>;
 		status = "disabled";
 	};
 
@@ -1229,7 +1229,7 @@ main_spi6: spi@2160000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 272 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 272 1>;
+		clocks = <&k3_clks 272 4>;
 		status = "disabled";
 	};
 
@@ -1240,7 +1240,7 @@ main_spi7: spi@2170000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 273 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 273 1>;
+		clocks = <&k3_clks 273 4>;
 		status = "disabled";
 	};
 
diff --git a/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
index 5097d192c2b20..b18b2f2deb969 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
@@ -494,7 +494,7 @@ mcu_spi0: spi@40300000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 274 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 274 0>;
+		clocks = <&k3_clks 274 4>;
 		status = "disabled";
 	};
 
@@ -505,7 +505,7 @@ mcu_spi1: spi@40310000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 275 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 275 0>;
+		clocks = <&k3_clks 275 4>;
 		status = "disabled";
 	};
 
@@ -516,7 +516,7 @@ mcu_spi2: spi@40320000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 276 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 276 0>;
+		clocks = <&k3_clks 276 2>;
 		status = "disabled";
 	};
 
-- 
2.43.0



