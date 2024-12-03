Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8EB33FE;
	Tue,  3 Dec 2024 15:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238169; cv=none; b=giw3aT+YOHYk4p8K8WCBoOdbVX1gSjMiDPgH05CkXa/An8CMsYBPUcJErlYdWgrmeOkgR8Vq3tIXFDTBqfabRSX0sfPX/OgL+GuZrw8vpEgqS8GuW0MEMpHF8kPn/r21PIgRYSAcP3gPDgsLye92SwSzjEiRINWpK3fgU7wWoBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238169; c=relaxed/simple;
	bh=aCilWIsuYEMHrfEP7yBO3DyrQacksmX5QDt1TanTY2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvQ76wk+J7tXHvVTeKsI2vB2eicTYzF6bz6rvnXjaijHgEp8hR5xM2TUrI936zhZB2Hz9sKxFXyocGnXcq0yam7fwiR5O+tg7xhMtDugm4qULp8bTtNLtX1wUyKLFwzwX+vuc08Vgm08h3sHrzCADrJvlO7giq9GZFGhgztB+Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5OU+RhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5OU+RhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D462EC4CED6;
	Tue,  3 Dec 2024 15:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238169;
	bh=aCilWIsuYEMHrfEP7yBO3DyrQacksmX5QDt1TanTY2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5OU+RhF5/SVYtRJADaG0xsI8PZXkwdiJqufIHUri25b9Q5R8jo3x1+VrOpydwRop
	 IFB7M476blBIErvq+dg3+vtxkzOjqI1PeNR0Jj5as7uK1yaASLfUNOLAa0EneUinK+
	 a7RWdgcV+/u+apyLwsW4vWJL2uoxQDwMEvzgrUoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anurag Dutta <a-dutta@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 186/817] arm64: dts: ti: k3-j721s2: Fix clock IDs for MCSPI instances
Date: Tue,  3 Dec 2024 15:35:58 +0100
Message-ID: <20241203144002.991568065@linuxfoundation.org>
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

[ Upstream commit 891874f015e98f67ab2fda76f2e859921e136621 ]

The clock IDs for multiple MCSPI instances across wakeup domain
in J721s2 are incorrect when compared with documentation [1]. Fix the
clock IDs to their appropriate values.

[1]https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/j721s2/clocks.html

Fixes: 04d7cb647b85 ("arm64: dts: ti: k3-j721s2: Add MCSPI nodes")

Signed-off-by: Anurag Dutta <a-dutta@ti.com>
Link: https://lore.kernel.org/r/20241023104532.3438851-4-a-dutta@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi       | 16 ++++++++--------
 arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi |  6 +++---
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi
index 9ed6949b40e9d..fae534b5c8a43 100644
--- a/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi
@@ -1708,7 +1708,7 @@ main_spi0: spi@2100000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 339 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 339 1>;
+		clocks = <&k3_clks 339 2>;
 		status = "disabled";
 	};
 
@@ -1719,7 +1719,7 @@ main_spi1: spi@2110000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 340 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 340 1>;
+		clocks = <&k3_clks 340 2>;
 		status = "disabled";
 	};
 
@@ -1730,7 +1730,7 @@ main_spi2: spi@2120000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 341 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 341 1>;
+		clocks = <&k3_clks 341 2>;
 		status = "disabled";
 	};
 
@@ -1741,7 +1741,7 @@ main_spi3: spi@2130000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 342 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 342 1>;
+		clocks = <&k3_clks 342 2>;
 		status = "disabled";
 	};
 
@@ -1752,7 +1752,7 @@ main_spi4: spi@2140000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 343 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 343 1>;
+		clocks = <&k3_clks 343 2>;
 		status = "disabled";
 	};
 
@@ -1763,7 +1763,7 @@ main_spi5: spi@2150000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 344 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 344 1>;
+		clocks = <&k3_clks 344 2>;
 		status = "disabled";
 	};
 
@@ -1774,7 +1774,7 @@ main_spi6: spi@2160000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 345 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 345 1>;
+		clocks = <&k3_clks 345 2>;
 		status = "disabled";
 	};
 
@@ -1785,7 +1785,7 @@ main_spi7: spi@2170000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 346 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 346 1>;
+		clocks = <&k3_clks 346 2>;
 		status = "disabled";
 	};
 
diff --git a/arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi
index 8feb42c89e476..ddf8fc57fd170 100644
--- a/arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi
@@ -425,7 +425,7 @@ mcu_spi0: spi@40300000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 347 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 347 0>;
+		clocks = <&k3_clks 347 2>;
 		status = "disabled";
 	};
 
@@ -436,7 +436,7 @@ mcu_spi1: spi@40310000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 348 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 348 0>;
+		clocks = <&k3_clks 348 2>;
 		status = "disabled";
 	};
 
@@ -447,7 +447,7 @@ mcu_spi2: spi@40320000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 349 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 349 0>;
+		clocks = <&k3_clks 349 2>;
 		status = "disabled";
 	};
 
-- 
2.43.0



