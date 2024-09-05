Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42239199930;
	Thu,  5 Sep 2024 09:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529524; cv=none; b=lNlYvmseN+yhzDOiEhi3p4TmvHQknimjYPR+8CTuK0h2IR0mgAZjWazKiNT6mlYMZzqiYV5PD7JJ/kUxj0JbrUB1GtId3lXmbzSFTHoTwgeuUSA0tOJL9+fwmbmuvGZHyp9ResrKMx/sHDUEP6H4Gkyf36O0YAORZBYIZ8V0XG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529524; c=relaxed/simple;
	bh=24CIB06ZUw2dvqHHotsZZJkh4yxFaFCBxWGQ3r+uy20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZZFVPI7/ObJV7C35tJC6iQaMV8zCql9BXzvbGSUu8pcM9b9RJL1gSxd+fu5GaFrxQqnzo9n9sp2r0f/ma0OdsgBFaC9FgDCyOb0hAjRgAUyULwvHlV9AZRNXoPzTjOS/serrP3JvHJCsxDKwmEm6plRM+kGXQf2Ug0UK+wOsKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fB5Omm5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fB5Omm5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5789DC4CEC3;
	Thu,  5 Sep 2024 09:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529523;
	bh=24CIB06ZUw2dvqHHotsZZJkh4yxFaFCBxWGQ3r+uy20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fB5Omm5hPkAH8f6ScRVX7v5wwXxglb1JE1f7zqYubN3gwTZG4T+VaLnrISkDxfZIN
	 TgpyDBzOoy/zOR8OklHRXnIVrCFqrf3IH8jQGKaghd4m8xdq/0A8jgE0PFzn/dFfHP
	 UwLI/sskUM0m06vlMjWkMPSqMmoAjHHpC9rpDYFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 029/184] arm64: dts: qcom: x1e80100: Describe the PCIe 6a resources
Date: Thu,  5 Sep 2024 11:39:02 +0200
Message-ID: <20240905093733.384581808@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit eb57cbe730d10ec8c6505492a9f3252b160e0f1e ]

On both the CRD and QCP, on PCIe 6a sits the NVMe. Add the 3.3V
gpio-controlled regulator and the clkreq, perst and wake gpios as
resources for the PCIe 6a.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240530-x1e80100-dts-pcie6a-v1-3-ee17a9939ba5@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 42b33ad18846 ("arm64: dts: qcom: x1e80100-crd: fix missing PCIe4 gpios")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts | 52 +++++++++++++++++++++++
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts | 52 +++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
index 7d03316c279df..0d47c75e2ad8c 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
@@ -173,6 +173,20 @@
 		regulator-always-on;
 		regulator-boot-on;
 	};
+
+	vreg_nvme: regulator-nvme {
+		compatible = "regulator-fixed";
+
+		regulator-name = "VREG_NVME_3P3";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+
+		gpio = <&tlmm 18 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&nvme_reg_en>;
+	};
 };
 
 &apps_rsc {
@@ -655,6 +669,14 @@
 };
 
 &pcie6a {
+	perst-gpios = <&tlmm 152 GPIO_ACTIVE_LOW>;
+	wake-gpios = <&tlmm 154 GPIO_ACTIVE_LOW>;
+
+	vddpe-3v3-supply = <&vreg_nvme>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&pcie6a_default>;
+
 	status = "okay";
 };
 
@@ -804,6 +826,36 @@
 		bias-disable;
 	};
 
+	nvme_reg_en: nvme-reg-en-state {
+		pins = "gpio18";
+		function = "gpio";
+		drive-strength = <2>;
+		bias-disable;
+	};
+
+	pcie6a_default: pcie2a-default-state {
+		clkreq-n-pins {
+			pins = "gpio153";
+			function = "pcie6a_clk";
+			drive-strength = <2>;
+			bias-pull-up;
+		};
+
+		perst-n-pins {
+			pins = "gpio152";
+			function = "gpio";
+			drive-strength = <2>;
+			bias-pull-down;
+		};
+
+		wake-n-pins {
+		       pins = "gpio154";
+		       function = "gpio";
+		       drive-strength = <2>;
+		       bias-pull-up;
+	       };
+	};
+
 	tpad_default: tpad-default-state {
 		pins = "gpio3";
 		function = "gpio";
diff --git a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
index 2d7dedb7e30f2..d2c8c860895e6 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -59,6 +59,20 @@
 		regulator-always-on;
 		regulator-boot-on;
 	};
+
+	vreg_nvme: regulator-nvme {
+		compatible = "regulator-fixed";
+
+		regulator-name = "VREG_NVME_3P3";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+
+		gpio = <&tlmm 18 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&nvme_reg_en>;
+	};
 };
 
 &apps_rsc {
@@ -466,6 +480,14 @@
 };
 
 &pcie6a {
+	perst-gpios = <&tlmm 152 GPIO_ACTIVE_LOW>;
+	wake-gpios = <&tlmm 154 GPIO_ACTIVE_LOW>;
+
+	vddpe-3v3-supply = <&vreg_nvme>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&pcie6a_default>;
+
 	status = "okay";
 };
 
@@ -528,6 +550,36 @@
 		drive-strength = <16>;
 		bias-disable;
 	};
+
+	nvme_reg_en: nvme-reg-en-state {
+		pins = "gpio18";
+		function = "gpio";
+		drive-strength = <2>;
+		bias-disable;
+	};
+
+	pcie6a_default: pcie2a-default-state {
+		clkreq-n-pins {
+			pins = "gpio153";
+			function = "pcie6a_clk";
+			drive-strength = <2>;
+			bias-pull-up;
+		};
+
+		perst-n-pins {
+			pins = "gpio152";
+			function = "gpio";
+			drive-strength = <2>;
+			bias-pull-down;
+		};
+
+		wake-n-pins {
+		       pins = "gpio154";
+		       function = "gpio";
+		       drive-strength = <2>;
+		       bias-pull-up;
+	       };
+	};
 };
 
 &uart21 {
-- 
2.43.0



