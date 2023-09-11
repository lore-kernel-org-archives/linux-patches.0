Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EB81170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A8EC433C7;
	Mon, 11 Sep 2023 14:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441061;
	bh=5HMFnxlW9c2IUTLoXyI9RHhZXboUr5SqL+EYDFvzODY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zI4vRcxa7+MPtHsXy9nrA99jWZRcfToUpiEKNBNi6/Kjp2bKPxUkKd6bpikp0Qpuk
	 zrwUi277Qpy2G4Ljnv+Kv95p0/f2O/QeeRuphkzLbFfJQinyLSiH9JDi0VDe2cj4kj
	 7ouGiEX+2Gx5GnygKsSn/koojNOBq7iOqGosrtFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 255/739] arm64: dts: qcom: pmi8950: Add missing OVP interrupt
Date: Mon, 11 Sep 2023 15:40:54 +0200
Message-ID: <20230911134658.275098246@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 4d77b639531fd85b84a7079c3369908dfaddf8b2 ]

Add the missing OVP interrupt. This fixes the schema warning:

wled@d800: interrupt-names: ['short'] is too short

Fixes: 0d97fdf380b4 ("arm64: dts: qcom: Add configuration for PMI8950 peripheral")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230626-topic-bindingsfixups-v1-5-254ae8642e69@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pmi8950.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/pmi8950.dtsi b/arch/arm64/boot/dts/qcom/pmi8950.dtsi
index 4891be3cd68a3..c16adca4e93a9 100644
--- a/arch/arm64/boot/dts/qcom/pmi8950.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmi8950.dtsi
@@ -87,8 +87,9 @@ pmic@3 {
 		pmi8950_wled: leds@d800 {
 			compatible = "qcom,pmi8950-wled";
 			reg = <0xd800>, <0xd900>;
-			interrupts = <0x3 0xd8 0x02 IRQ_TYPE_EDGE_RISING>;
-			interrupt-names = "short";
+			interrupts = <0x3 0xd8 0x1 IRQ_TYPE_EDGE_RISING>,
+				     <0x3 0xd8 0x2 IRQ_TYPE_EDGE_RISING>;
+			interrupt-names = "ovp", "short";
 			label = "backlight";
 
 			status = "disabled";
-- 
2.40.1



