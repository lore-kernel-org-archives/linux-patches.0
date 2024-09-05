Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FB8198845;
	Thu,  5 Sep 2024 09:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529530; cv=none; b=bwW5TBxGgT6bdhluyblL6EdBeM27yL8t+d0ldvUKKaWc7Xw5mS6EXTmtcS4/mKIr+dmq8rVBAoyLo6d5tWvBnUCNfrvCK3nGL+g8kRLyU1A4MC3WKbt0GywKett3ESbcL76LRX9TVkZGfLPZntD0jp3+gM6H58ZNF7BTAB2DRrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529530; c=relaxed/simple;
	bh=xgN/UAPER5Knh+ixeNqS2eS3meUscQVG+E7YmI2py7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+lpOFUCmhDWnFWjOb1HJi4vR+R4sJxXDv0zNHvCTTDrMJSaqZ8QiggX7YX5rrcygJT5dMOQwhSPH/MHxyUGCTOHSaFaKdch83UDhL9oDo//UasCnCUbqQ9i+hBBx245akanRWD84pO5j4EvJlYPU6kBgDuCsdR7Dmo5wyKXsvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rg6L0pgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rg6L0pgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D60C4CEC3;
	Thu,  5 Sep 2024 09:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529530;
	bh=xgN/UAPER5Knh+ixeNqS2eS3meUscQVG+E7YmI2py7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rg6L0pgOcJDozvcmVO8uT5C0FnY2lbM4C8ttzvZ5wB/VO7dieht5jFuATVmlDNlOw
	 KCOCK3GZtlmtgBp8YRd1UaS8rd449JY41ojfPrR7aXKXROlnWlyKl7t5G6X82NwCn2
	 VzoxSUzuIWyOcvNk0J3znjCapBzQ4fZ9uVsfeDRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 031/184] arm64: dts: qcom: x1e80100-crd: fix missing PCIe4 gpios
Date: Thu,  5 Sep 2024 11:39:04 +0200
Message-ID: <20240905093733.461532785@linuxfoundation.org>
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

[ Upstream commit 42b33ad188466292eaac9825544b8be8deddb3cb ]

Add the missing PCIe4 perst, wake and clkreq GPIOs and pin config.

Fixes: d7e03cce0400 ("arm64: dts: qcom: x1e80100-crd: Enable more support")
Cc: stable@vger.kernel.org	# 6.9
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240722094249.26471-7-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts | 29 +++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
index 4096bb1ee4d3a..9f72e748c8041 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
@@ -658,6 +658,12 @@
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
 
@@ -833,6 +839,29 @@
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



