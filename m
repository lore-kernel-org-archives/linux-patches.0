Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C871170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F059C433C8;
	Mon, 11 Sep 2023 14:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441063;
	bh=aHWhKORo1I4ZkUlzYt6nwUI7cw0BtQ7sJocn0UE/Wtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cji+Fi1W4sRkzEoP6xiUz3SYqOECAv2CkGliDXB45nq1qOvPhedk3yivYEEuAm7h6
	 En3GQBSmD4aFQMpsfrwPwRWepBmVg4oDbfxOmMO5hsYWiqbw0ax9qL/p/fEfr21D/x
	 9vVt+2N5omjijF34GrkSPYLLbhf4PQ168kWevbvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 256/739] arm64: dts: qcom: pmi8994: Add missing OVP interrupt
Date: Mon, 11 Sep 2023 15:40:55 +0200
Message-ID: <20230911134658.301769920@linuxfoundation.org>
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

[ Upstream commit 8db94432690371b1736e9a2566a9b3d8a73d5a97 ]

Add the missing OVP interrupt. This fixes the schema warning:

wled@d800: interrupt-names: ['short'] is too short

Fixes: 37aa540cbd30 ("arm64: dts: qcom: pmi8994: Add WLED node")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230626-topic-bindingsfixups-v1-6-254ae8642e69@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pmi8994.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/pmi8994.dtsi b/arch/arm64/boot/dts/qcom/pmi8994.dtsi
index 0192968f4d9b3..36d6a1fb553ac 100644
--- a/arch/arm64/boot/dts/qcom/pmi8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmi8994.dtsi
@@ -54,8 +54,9 @@ pmi8994_spmi_regulators: regulators {
 		pmi8994_wled: wled@d800 {
 			compatible = "qcom,pmi8994-wled";
 			reg = <0xd800>, <0xd900>;
-			interrupts = <3 0xd8 0x02 IRQ_TYPE_EDGE_RISING>;
-			interrupt-names = "short";
+			interrupts = <0x3 0xd8 0x1 IRQ_TYPE_EDGE_RISING>,
+				     <0x3 0xd8 0x2 IRQ_TYPE_EDGE_RISING>;
+			interrupt-names = "ovp", "short";
 			qcom,cabc;
 			qcom,external-pfet;
 			status = "disabled";
-- 
2.40.1



