Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B2313E022;
	Tue, 14 May 2024 11:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685921; cv=none; b=r6L80xbLaAdeag+laFEBsKDwC2RtZdVeXWMo7yu9qhdxE5YNUP2uvIzkJYiUVYwFLKIJ1U4EIrKWAyMPQyqDQiWmorWpJ+LKhTbnJHTK0qE4zIFRK/5V6z5nFOm8GpWZxi9VShr0ClOtvg/CH0BWZEboNruzReuGNS74g1K/qiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685921; c=relaxed/simple;
	bh=SuEkyu6ImIh3EZeVfNXKTp+eNV+zGQkhMTOcots/pAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3Z5CzCrLJ2CK07/CXYsfsiMtwJ0Wz7Dem4GKCl5JpPH0FXVtyjsUOM+9zWq2lmAIIsinEZAllEPALivBYQ9YVuDwYArBwV/5qENlwVxyD1kEcq5RaTkkx7S/wkNFqZBAWwEZqosUybWrQems9MeiRTBH96PJPZc0kkAfmu8H2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdTuil8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdTuil8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E655C2BD10;
	Tue, 14 May 2024 11:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685920;
	bh=SuEkyu6ImIh3EZeVfNXKTp+eNV+zGQkhMTOcots/pAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdTuil8K3RKUqUfDKjr1fok3bvD23y988IkWC+cc3wkGb/7QczqbIBP2rbSDQphX0
	 /5udvO5xDB71XhS9irVZKjIBjPvi8dxoHD7njGATR1JJRN5mBtrqqi4pyNzHzmatBC
	 qsEgJ9R4kL9F1loQlIwgXwoY5zjCBsK9Lf4h7bEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Volodymyr Babchuk <volodymyr_babchuk@epam.com>,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 277/301] arm64: dts: qcom: sa8155p-adp: fix SDHC2 CD pin configuration
Date: Tue, 14 May 2024 12:19:08 +0200
Message-ID: <20240514101042.724749149@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>

commit 819fe8c96a5172dfd960e5945e8f00f8fed32953 upstream.

There are two issues with SDHC2 configuration for SA8155P-ADP,
which prevent use of SDHC2 and causes issues with ethernet:

- Card Detect pin for SHDC2 on SA8155P-ADP is connected to gpio4 of
  PMM8155AU_1, not to SoC itself. SoC's gpio4 is used for DWMAC
  TX. If sdhc driver probes after dwmac driver, it reconfigures
  gpio4 and this breaks Ethernet MAC.

- pinctrl configuration mentions gpio96 as CD pin. It seems it was
  copied from some SM8150 example, because as mentioned above,
  correct CD pin is gpio4 on PMM8155AU_1.

This patch fixes both mentioned issues by providing correct pin handle
and pinctrl configuration.

Fixes: 0deb2624e2d0 ("arm64: dts: qcom: sa8155p-adp: Add support for uSD card")
Cc: stable@vger.kernel.org
Signed-off-by: Volodymyr Babchuk <volodymyr_babchuk@epam.com>
Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20240412190310.1647893-1-volodymyr_babchuk@epam.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sa8155p-adp.dts |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
+++ b/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
@@ -367,6 +367,16 @@
 	};
 };
 
+&pmm8155au_1_gpios {
+	pmm8155au_1_sdc2_cd: sdc2-cd-default-state {
+		pins = "gpio4";
+		function = "normal";
+		input-enable;
+		bias-pull-up;
+		power-source = <0>;
+	};
+};
+
 &qupv3_id_1 {
 	status = "okay";
 };
@@ -384,10 +394,10 @@
 &sdhc_2 {
 	status = "okay";
 
-	cd-gpios = <&tlmm 4 GPIO_ACTIVE_LOW>;
+	cd-gpios = <&pmm8155au_1_gpios 4 GPIO_ACTIVE_LOW>;
 	pinctrl-names = "default", "sleep";
-	pinctrl-0 = <&sdc2_on>;
-	pinctrl-1 = <&sdc2_off>;
+	pinctrl-0 = <&sdc2_on &pmm8155au_1_sdc2_cd>;
+	pinctrl-1 = <&sdc2_off &pmm8155au_1_sdc2_cd>;
 	vqmmc-supply = <&vreg_l13c_2p96>; /* IO line power */
 	vmmc-supply = <&vreg_l17a_2p96>;  /* Card power line */
 	bus-width = <4>;
@@ -505,13 +515,6 @@
 			bias-pull-up;		/* pull up */
 			drive-strength = <16>;	/* 16 MA */
 		};
-
-		sd-cd-pins {
-			pins = "gpio96";
-			function = "gpio";
-			bias-pull-up;		/* pull up */
-			drive-strength = <2>;	/* 2 MA */
-		};
 	};
 
 	sdc2_off: sdc2-off-state {
@@ -532,13 +535,6 @@
 			bias-pull-up;		/* pull up */
 			drive-strength = <2>;	/* 2 MA */
 		};
-
-		sd-cd-pins {
-			pins = "gpio96";
-			function = "gpio";
-			bias-pull-up;		/* pull up */
-			drive-strength = <2>;	/* 2 MA */
-		};
 	};
 
 	usb2phy_ac_en1_default: usb2phy-ac-en1-default-state {


