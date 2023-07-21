Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0526200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C1DC433C8;
	Fri, 21 Jul 2023 18:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965938;
	bh=1ahZNUWwPDJTr4c8IgFSj/s6864VIqlQInKhBO1Zzxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wb3G7TLC5wrnlpK/pdwBV+eBBtp+5xg67oZSnXu6AE3+bd5eQc2JlNj4h1rjBRCn+
	 NnILODeq3a3qhrIRC8DTV0NSD+y6p7KXxbZmtRY47igwuU5NI7FFHmyr3nTwXEOlUo
	 y0m5eBWAWp3fUSCl3Tqtg1P4XfLTJQ8y6HtMcdJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/532] arm64: dts: qcom: msm8996: correct camss unit address
Date: Fri, 21 Jul 2023 18:00:33 +0200
Message-ID: <20230721160621.460249402@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit e959ced1d0e5ef0b1f66a0c2d0e1ae80790e5ca5 ]

Match unit-address to reg entry to fix dtbs W=1 warnings:

  Warning (simple_bus_reg): /soc/camss@a00000: simple-bus unit address format error, expected "a34000"

Fixes: e0531312e78f ("arm64: dts: qcom: msm8996: Add CAMSS support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-9-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index cd66bb16c7392..893c241f72030 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -1771,7 +1771,7 @@ ufsphy_lane: phy@627400 {
 			};
 		};
 
-		camss: camss@a00000 {
+		camss: camss@a34000 {
 			compatible = "qcom,msm8996-camss";
 			reg = <0x00a34000 0x1000>,
 			      <0x00a00030 0x4>,
-- 
2.39.2



