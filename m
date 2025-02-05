Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0A718C039;
	Wed,  5 Feb 2025 14:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766865; cv=none; b=toewg0jBtDY28Wp6Re/IrSE0kgYJ/ES8KB5nq37Q5ZAWjFy6vkswd8MO3uPQuwyIzjs2Ypn2WAurXhPVPavjUKKujd9vO+eEZdPeRT8DVXr6xjYue80O63QSbLEyCqmPJRqVQq1+xc3CYyKX/v4cKAAbG01oF+7XFKWSgMLZGpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766865; c=relaxed/simple;
	bh=LTp5wpiEEZ9jcFTE0RvM6yMrZBjgQPT3cOWoLsod6Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnTxzmQne4c3Kb8q6WaD2G9po8/FaIEa99GPa/Ts1o3lk9ntt598ta7P7o9tjSDltQRcWr49KnJiq/t3nZ7XCm33Fg6T/uMb5MhGczp/AQ7bhsXjjO7bvenaHibucU4QPTFiCPp9cCQ7YwznTqR77u3QKGFSwfS8K0A8zjyAAV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FveXMYBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FveXMYBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01F1C4CEDD;
	Wed,  5 Feb 2025 14:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766865;
	bh=LTp5wpiEEZ9jcFTE0RvM6yMrZBjgQPT3cOWoLsod6Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FveXMYBpDNTMZGo+j+xtkl4Up3Iw4Kk2CaC9+JNhNrJ/jT6l9uE74Rr4lZEVxk+Vd
	 tUS4eHe6tzFVaT1Q2Y99KFvzahOu5b8Citsq5E/w3nwVlJwTPPeglEdEvY2eHzicwf
	 TXjyyPKAPmHXzmOT+jpSGyiTSvkqrLrVS0I+Bxi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 373/590] arm64: dts: qcom: sdm845-db845c-navigation-mezzanine: remove disabled ov7251 camera
Date: Wed,  5 Feb 2025 14:42:08 +0100
Message-ID: <20250205134509.541324116@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



