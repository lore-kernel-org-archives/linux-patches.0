Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CE4DF71;
	Wed,  5 Feb 2025 14:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767435; cv=none; b=PS67uqYBnUnrU7YahCUdeW3w9QKBZBlxMhFGGZy8TOYD8AQxCMTgBAjiDSu3nZ05Hd+D86rNwDQsGYTwHuwqim4UyuAXfPNM2BpWPDhmLPFUxjH88WC55Au+WHXRWRiikWiOwMkX+JXjFsW9dvibwe9v4AHfWuGkL6ie6bUUNxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767435; c=relaxed/simple;
	bh=dDGiiXtH8xTih7cjQ7Nnq7xRInEhTSbQqOXZ26Cxavc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csiroWy/tQN733UNAT4bgwCRATxezerXi5OFV7NqZKnE4JLq2dHH1flxZjI+txTu72ezgJfhuHATKH3L572mkeiPp3FYjwLVo185r4QDou1l9EagQ0BYFPpWvv3XYDQYME6ShHmuczCNlmZoSSL4yYkXrOCBLyYQ70CjJJ3GznM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jm19E3h+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jm19E3h+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F8BC4CED1;
	Wed,  5 Feb 2025 14:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767435;
	bh=dDGiiXtH8xTih7cjQ7Nnq7xRInEhTSbQqOXZ26Cxavc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jm19E3h+Ou4Z5wEvQsWkt95f+wu8mvdVUGMMFWJ2QDmgBilKrtqHVD66CdDe48dqo
	 M9OZqA35hbxYSIx8pd8GKjTe/0S5hMOlR5k30sxjqQtnmu5N+KretrYXz6DxwzQkqc
	 k8Tyx6f0s6JpCe0NcQkOovEI5bl0Cx/90SE9OGWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 404/623] arm64: dts: qcom: sdm845-db845c-navigation-mezzanine: remove disabled ov7251 camera
Date: Wed,  5 Feb 2025 14:42:26 +0100
Message-ID: <20250205134511.677095602@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 0a87df806cafc..59970082da452 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dtso
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dtso
@@ -79,45 +79,3 @@
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



