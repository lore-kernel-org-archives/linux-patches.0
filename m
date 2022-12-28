Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF7A1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18169C433D2;
	Wed, 28 Dec 2022 14:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239540;
	bh=W4+Z4aSKdlJHPQdoN85j3SNKJXWZS4ldke80WQwVz4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6BBU9nYYFomxcaMkUubNGUuO2JDe+Q1TFBMlunr1XEcsmFqXPndpXRmhboXc/Lah
	 JDwCP67WQ6YDMoQEEL4qj3pgp9DXVup6TKt3i2dwkhlBJbseZ5e5KO5KdB/JIWsCjW
	 aZlFF6FR7DfPmJ+/yqKWa5klTOI5wYTXfmOhW1U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@z3ntu.xyz>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0010/1146] ARM: dts: qcom: apq8064: fix coresight compatible
Date: Wed, 28 Dec 2022 15:25:49 +0100
Message-Id: <20221228144330.460625646@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit a42b1ee868361f1cb0492f1bdaefb43e0751e468 ]

There's a typo missing the arm, prefix of arm,coresight-etb10. Fix it to
make devicetree validation happier.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Fixes: 7a5c275fd821 ("ARM: dts: qcom: Add apq8064 CoreSight components")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221013190657.48499-3-luca@z3ntu.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 942aa2278355..a39b940d5853 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -1615,7 +1615,7 @@ wifi {
 		};
 
 		etb@1a01000 {
-			compatible = "coresight-etb10", "arm,primecell";
+			compatible = "arm,coresight-etb10", "arm,primecell";
 			reg = <0x1a01000 0x1000>;
 
 			clocks = <&rpmcc RPM_QDSS_CLK>;
-- 
2.35.1



