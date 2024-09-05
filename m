Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AEF198832;
	Thu,  5 Sep 2024 09:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529437; cv=none; b=ED49Di7mdmlynTWeFg92ZCekt9TpTYN7FwuGAu2YXXtlp5XMKftdpCPBGuFqZ/CYQxbJnPou+8W11cUcd5cSyiJXLpLLCjOtz1xHITuzpHuu2z1pNadiAuNkIsB6nuYihMWh/CXsIsMKRN9t07CsomGHRUbsu2Ubb865zj1izjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529437; c=relaxed/simple;
	bh=APSU7dTciiAP7ByDVV5XCDpaVkdDIeufEMcHH2wdz6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gk/X/sAgzJl8i42ueylcYoJv4/+B/9n987Uoa6EGhH2wUqzhw2lfrvxBVu0UzlwmZlplVy+sJp6UgGgAic4Cf54yNyLrp4Eq7Ces7hwxpmKpHmCwVVdWFmOPJnRSlqIYR4vBjoE0SmB8wamaT6YVQhXUMKfp9nuru3WyR04YvjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxUWp58d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxUWp58d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C84C4CEC6;
	Thu,  5 Sep 2024 09:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529436;
	bh=APSU7dTciiAP7ByDVV5XCDpaVkdDIeufEMcHH2wdz6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxUWp58dFndZCMpsFTvZsB4ZU1bIR1TTyySO9/axR/lmtvtMuGqBW418LK17MAt9d
	 bdVU79uc6XXm5g0EOF5NbJIegVw7rq2pdFfEu5IJ1Hu2gdCmbAAOec9QqkcWEpTlV0
	 8UjBE66OCtJZJA7/P5HlVPvTyPmhe/PdlFAD9e2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 033/184] arm64: dts: qcom: x1e80100-qcp: fix missing PCIe4 gpios
Date: Thu,  5 Sep 2024 11:39:06 +0200
Message-ID: <20240905093733.540925119@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 2ac90e4d2b6d6823ca10642ef39595ff1181c3fa ]

Add the missing PCIe4 perst, wake and clkreq GPIOs and pin config.

Fixes: f9a9c11471da ("arm64: dts: qcom: x1e80100-qcp: Enable more support")
Cc: stable@vger.kernel.org	# 6.9
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240722095459.27437-5-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts | 29 +++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
index 2cf3ea4f6e2e6..f90177a662b7d 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -469,6 +469,12 @@
 };
 
 &pcie4 {
+	perst-gpios = <&tlmm 146 GPIO_ACTIVE_LOW>;
+	wake-gpios = <&tlmm 148 GPIO_ACTIVE_LOW>;
+
+	pinctrl-0 = <&pcie4_default>;
+	pinctrl-names = "default";
+
 	status = "okay";
 };
 
@@ -558,6 +564,29 @@
 		bias-disable;
 	};
 
+	pcie4_default: pcie4-default-state {
+		clkreq-n-pins {
+			pins = "gpio147";
+			function = "pcie4_clk";
+			drive-strength = <2>;
+			bias-pull-up;
+		};
+
+		perst-n-pins {
+			pins = "gpio146";
+			function = "gpio";
+			drive-strength = <2>;
+			bias-disable;
+		};
+
+		wake-n-pins {
+			pins = "gpio148";
+			function = "gpio";
+			drive-strength = <2>;
+			bias-pull-up;
+		};
+	};
+
 	pcie6a_default: pcie6a-default-state {
 		clkreq-n-pins {
 			pins = "gpio153";
-- 
2.43.0



