Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6278820F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C15C433C8;
	Fri, 21 Jul 2023 18:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965825;
	bh=RqtIcHMCHtireM1r00OpYskwS3dV0wahy2+P+Me+N5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0juVY5GeMruzZcibybK/sWXl86LsOt/MNrGHNp7+q1Yuj8IBhPWzFFoDJlwMcZy1b
	 lrsHd5VCFCVIS78pXX4PkAm6St+CDhnFgqPmi/Z6nmfryuE03JlS7c95YdSJPUclfH
	 Na3YO703+DdmtLBuOukxiBDhrD/UyHCYaJCZS6Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/532] arm64: dts: qcom: msm8916: correct camss unit address
Date: Fri, 21 Jul 2023 18:00:31 +0200
Message-ID: <20230721160621.355344071@linuxfoundation.org>
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
index b967dbfba3b84..aa79e08075ea7 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -1064,7 +1064,7 @@ dsi_phy0: dsi-phy@1a98300 {
 			};
 		};
 
-		camss: camss@1b00000 {
+		camss: camss@1b0ac00 {
 			compatible = "qcom,msm8916-camss";
 			reg = <0x01b0ac00 0x200>,
 				<0x01b00030 0x4>,
-- 
2.39.2



