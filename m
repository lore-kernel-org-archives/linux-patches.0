Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B791ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7404C433C7;
	Tue, 25 Jul 2023 11:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285086;
	bh=o29lUjrMCrDA3+3uQSIRUPsbO846uYb8Y5O1/VYAQdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvXdCD1k/hYFCCs89mfaKj9j0zbyS/m52X7+LYPaHaiQH+q/d5foYREajZZax+len
	 bikqhxdvfP3+DqBKO7jelMD6c/2bhAM48szXZc0VX8LELJ91Ea3QSsaORl00zAgWpe
	 1VAsKfAFfcUvsnswOOxk+w8Wjt2ELxujXrs/0JQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/313] arm64: dts: qcom: msm8916: correct camss unit address
Date: Tue, 25 Jul 2023 12:43:51 +0200
Message-ID: <20230725104524.324064708@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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

[ Upstream commit 48798d992ce276cf0d57bf75318daf8eabd02aa4 ]

Match unit-address to reg entry to fix dtbs W=1 warnings:

  Warning (simple_bus_reg): /soc@0/camss@1b00000: simple-bus unit address format error, expected "1b0ac00"

Fixes: 58f479f90a7c ("arm64: dts: qcom: msm8916: Add CAMSS support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 301c1c467c0b7..bf40500adef73 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -1451,7 +1451,7 @@ video-encoder {
 			};
 		};
 
-		camss: camss@1b00000 {
+		camss: camss@1b0ac00 {
 			compatible = "qcom,msm8916-camss";
 			reg = <0x1b0ac00 0x200>,
 				<0x1b00030 0x4>,
-- 
2.39.2



