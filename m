Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4349914B959;
	Wed,  5 Feb 2025 14:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765367; cv=none; b=cFKRtOeH/fwp5tqFXaIsMG7IImEPpPcjOAT+tnAHjjJj+m8q5UIeE+sUISONLA9VAOtTNJTbFzVIzgbvKKetz+nXXkb/1+avsYlclYc+lrj355gq20o7qfAx1SxIf7qbjtHaRH/L1yntp+4Xh5JZWLAECJOHnJQ75g8f2xOzvQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765367; c=relaxed/simple;
	bh=9naWWCTWx2kMCcU/yG8R2sEsFkJCEMp6JJs3IvUslBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvA/8HMheiA35Xdsg838dfGEIbDVEGiDAnTUAgbQr7G5W/Ua96phQbmG1e5KArlbkLGdAD7v1wrPa3GBEnMXNHvqGUNzEPxdrIFwNZh680WizDWtmj29U6Ftf4b0Al3jL5qIq+gYgXjLMjJRt0GLioEkglNF45KT8pbRd+xbAVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inFA3euW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inFA3euW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ACDC4CED1;
	Wed,  5 Feb 2025 14:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765366;
	bh=9naWWCTWx2kMCcU/yG8R2sEsFkJCEMp6JJs3IvUslBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inFA3euWs+rbYsVV6l+a2WYrA0xArWr3Thu+CIZjxpwvhUUrQWM00pYH9Kyd38Vs9
	 Jf3xRsP5jY2QwuVb0+mSqTlmjPz3CHnZV946TVcKaAv/Svn557CMGxPspcafMVlANH
	 N8HWtS0af+GG7n9owzCdcTix8znp/iw1OfbYkRq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 257/393] arm64: dts: qcom: sdm845-db845c-navigation-mezzanine: remove disabled ov7251 camera
Date: Wed,  5 Feb 2025 14:42:56 +0100
Message-ID: <20250205134430.143104562@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 80b47f14d5433068dd6738c9e6e17ff6648bae41 ]

The ov7251node has bindings check errors in the endpoint, and the
camera node was disabled since the beginning. Even when switching the
node to okay, the endpoint description to the csiphy is missing along
with the csiphy parameters.

Drop the ov7251 camera entirely until it's properly described.

This obviously fixes:
sdm845-db845c-navigation-mezzanine.dtso: camera@60: port:endpoint:data-lanes: [0, 1] is too long
	from schema $id: http://devicetree.org/schemas/media/i2c/ovti,ov7251.yaml#

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241230-topic-misc-dt-fixes-v4-2-1e6880e9dda3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../sdm845-db845c-navigation-mezzanine.dtso   | 42 -------------------
 1 file changed, 42 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dtso b/arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dtso
index b5f717d0ddd97..51f1a4883ab8f 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dtso
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dtso
@@ -68,45 +68,3 @@
 		};
 	};
 };
-
-&cci_i2c1 {
-	#address-cells = <1>;
-	#size-cells = <0>;
-
-	camera@60 {
-		compatible = "ovti,ov7251";
-
-		/* I2C address as per ov7251.txt linux documentation */
-		reg = <0x60>;
-
-		/* CAM3_RST_N */
-		enable-gpios = <&tlmm 21 GPIO_ACTIVE_HIGH>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&cam3_default>;
-
-		clocks = <&clock_camcc CAM_CC_MCLK3_CLK>;
-		clock-names = "xclk";
-		clock-frequency = <24000000>;
-
-		/*
-		 * The &vreg_s4a_1p8 trace always powered on.
-		 *
-		 * The 2.8V vdda-supply regulator is enabled when the
-		 * vreg_s4a_1p8 trace is pulled high.
-		 * It too is represented by a fixed regulator.
-		 *
-		 * No 1.2V vddd-supply regulator is used.
-		 */
-		vdddo-supply = <&vreg_lvs1a_1p8>;
-		vdda-supply = <&cam3_avdd_2v8>;
-
-		status = "disabled";
-
-		port {
-			ov7251_ep: endpoint {
-				data-lanes = <0 1>;
-/*				remote-endpoint = <&csiphy3_ep>; */
-			};
-		};
-	};
-};
-- 
2.39.5



