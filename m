Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E605BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A73C433A7;
	Tue,  7 Mar 2023 18:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212185;
	bh=c5wZohWgbzXORd3AYvyRyeU4fK4CUQ7crBkelEtcp5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nT9Zy0yxNsYuaTr+ljG1QYKFyDWIsVJ3G3XjsU3/FPlf0Va99sYL1i++uBFn3Lbh2
	 gNtAIS0qg4fsrwqeCaf72dejbnOchravBRmUFHscDcanE5ih5z1hcLH36cxNHhB01c
	 6i8moevkO6QL1lB54HJmot2EOfOW4+zz9aupQcwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/885] arm64: dts: qcom: pmk8350: Specify PBS register for PON
Date: Tue,  7 Mar 2023 17:50:38 +0100
Message-Id: <20230307170006.401679990@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit f46ef374e0dcb8fd2f272a376cf0dcdab7e52fc2 ]

PMK8350 is the first PMIC to require both HLOS and PBS registers for
PON to function properly (at least in theory, sm8350 sees no change).
The support for it on the driver side has been added long ago,
but it has never been wired up. Do so.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221115132626.7465-1-konrad.dybcio@linaro.org
Stable-dep-of: c0ee8e0ba5cc ("arm64: dts: qcom: pmk8350: Use the correct PON compatible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pmk8350.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pmk8350.dtsi b/arch/arm64/boot/dts/qcom/pmk8350.dtsi
index a7ec9d11946df..ec002eecb19d9 100644
--- a/arch/arm64/boot/dts/qcom/pmk8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmk8350.dtsi
@@ -17,7 +17,8 @@ pmk8350: pmic@0 {
 
 		pmk8350_pon: pon@1300 {
 			compatible = "qcom,pm8998-pon";
-			reg = <0x1300>;
+			reg = <0x1300>, <0x800>;
+			reg-names = "hlos", "pbs";
 
 			pon_pwrkey: pwrkey {
 				compatible = "qcom,pmk8350-pwrkey";
-- 
2.39.2



