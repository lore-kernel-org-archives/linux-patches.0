Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F2C3A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjmP0uc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CE8C433C7;
	Wed, 15 Nov 2023 19:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077410;
	bh=DRLvMXwWHEsmy++5wgz1HtzjS1LJuhRIZ97LSAc7sY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjmP0uc5h8X1LZXQh+hcsI2tckY8XO6SpknuUPZVqljCRibIUhTYWkr+0Brh4GhBg
	 5sFS987aLVF9PJFM6ws4+4I3gg7QqOgNgmFxNJh0b2uF+H0GKgCJKS7t15npgzrjZ8
	 X1/QeZetkW1t9ar40lLz4Q68ikfbYcs2QkPqxbAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Acayan <mailingradian@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 285/603] arm64: dts: qcom: sdm670: Fix pdc mapping
Date: Wed, 15 Nov 2023 14:13:50 -0500
Message-ID: <20231115191633.099942287@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit ad75cda991f7b335d3b2417f82db07680f92648a ]

As pointed out by Richard, I missed a non-continuity in one of the ranges.
Fix it.

Reported-by: Richard Acayan <mailingradian@gmail.com>
Fixes: b51ee205dc4f ("arm64: dts: qcom: sdm670: Add PDC")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Acked-by: Richard Acayan <mailingradian@gmail.com>
Link: https://lore.kernel.org/r/20230818-topic-670_pdc_fix-v1-1-1ba025041de7@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm670.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm670.dtsi b/arch/arm64/boot/dts/qcom/sdm670.dtsi
index 84cd2e39266fe..ba2043d67370a 100644
--- a/arch/arm64/boot/dts/qcom/sdm670.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm670.dtsi
@@ -1328,7 +1328,8 @@ pdc: interrupt-controller@b220000 {
 			compatible = "qcom,sdm670-pdc", "qcom,pdc";
 			reg = <0 0x0b220000 0 0x30000>;
 			qcom,pdc-ranges = <0 480 40>, <41 521 7>, <49 529 4>,
-					  <54 534 24>, <79 559 30>, <115 630 7>;
+					  <54 534 24>, <79 559 15>, <94 609 15>,
+					  <115 630 7>;
 			#interrupt-cells = <2>;
 			interrupt-parent = <&intc>;
 			interrupt-controller;
-- 
2.42.0



