Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BC043AC8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itN2Xked"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC623C3279C;
	Wed, 15 Nov 2023 20:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081379;
	bh=864w5sKVnQgrrZbqQtxkAi2WIhULNdmgGqGAjorV0ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itN2XkedW5D5YaZhk7oNd0OpwRTDZAYetp/97quZ/I1uSvnglQvCVQpbLBdDqa3I2
	 R0CYnu0WIQeZpO6YUNJqN2EvCgc8dRln+Ww6QDzpnhB3b+qMR7kj76jykEyzc553rq
	 b4K9SuWoGdHob8HGkAVf0JRldGutl+gzKB78lUsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/244] ARM: dts: qcom: mdm9615: populate vsdcc fixed regulator
Date: Wed, 15 Nov 2023 15:35:10 -0500
Message-ID: <20231115203555.416406284@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 09f8ee81b6da5f76de8b83c8bfc4475b54e101e0 ]

Fixed regulator put under "regulators" node will not be populated,
unless simple-bus or something similar is used.  Drop the "regulators"
wrapper node to fix this.

Fixes: 2c5e596524e7 ("ARM: dts: Add MDM9615 dtsi")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230924183914.51414-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-mdm9615.dtsi | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-mdm9615.dtsi b/arch/arm/boot/dts/qcom-mdm9615.dtsi
index ad9b52d53ef9b..982f3c3921965 100644
--- a/arch/arm/boot/dts/qcom-mdm9615.dtsi
+++ b/arch/arm/boot/dts/qcom-mdm9615.dtsi
@@ -82,14 +82,12 @@ cxo_board {
 		};
 	};
 
-	regulators {
-		vsdcc_fixed: vsdcc-regulator {
-			compatible = "regulator-fixed";
-			regulator-name = "SDCC Power";
-			regulator-min-microvolt = <2700000>;
-			regulator-max-microvolt = <2700000>;
-			regulator-always-on;
-		};
+	vsdcc_fixed: vsdcc-regulator {
+		compatible = "regulator-fixed";
+		regulator-name = "SDCC Power";
+		regulator-min-microvolt = <2700000>;
+		regulator-max-microvolt = <2700000>;
+		regulator-always-on;
 	};
 
 	soc: soc {
-- 
2.42.0



