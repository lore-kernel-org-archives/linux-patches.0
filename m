Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E918F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7EAC433C8;
	Sun, 16 Jul 2023 20:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538028;
	bh=xukQpDAT8F1awCCf6wjXZoLQ2P7/PckyQVhIC3BiM9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=so4AYIpLpzzDEXh0DfR/QODIVYfdsBNOewRitnU+z1znrTy4hfLZ00LdJC1VCnUyQ
	 ZOs90kZsU6q9ts8SEXvPZS0j8Nb3/iQ51e1+YVRRXv30mRRCM3F2O2WYLMZ8MQA1gy
	 8YFFeY50y68e+D7Ws9woZFdUQEafJcU5FSYDWz7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 305/800] arm64: dts: qcom: msm8953: correct WCNSS unit address
Date: Sun, 16 Jul 2023 21:42:38 +0200
Message-ID: <20230716194956.161468750@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

[ Upstream commit 751038676e3075a5cb816034f7d5ba6e95f4486d ]

Match unit-address to reg entry to fix dtbs W=1 warnings:

  Warning (simple_bus_reg): /soc@0/remoteproc@a21b000: simple-bus unit address format error, expected "a204000"

Fixes: b12428640ebe ("arm64: dts: MSM8953: Add wcnss nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-6-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8953.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8953.dtsi b/arch/arm64/boot/dts/qcom/msm8953.dtsi
index 4038e47a4610e..d1d6f80bb2e6b 100644
--- a/arch/arm64/boot/dts/qcom/msm8953.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8953.dtsi
@@ -1425,7 +1425,7 @@ i2c_8: i2c@7af8000 {
 			status = "disabled";
 		};
 
-		wcnss: remoteproc@a21b000 {
+		wcnss: remoteproc@a204000 {
 			compatible = "qcom,pronto-v3-pil", "qcom,pronto";
 			reg = <0x0a204000 0x2000>, <0x0a202000 0x1000>, <0x0a21b000 0x3000>;
 			reg-names = "ccu", "dxe", "pmu";
-- 
2.39.2



