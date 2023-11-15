Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D38B37170
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMt6CA4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FA0C433C7;
	Wed, 15 Nov 2023 19:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076398;
	bh=JCwe6Pn6pVgmZ62/x5j/6h6b3prON/cF7PGzQDCYGTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMt6CA4X3Xw0NcqKDCyWsDajKQZaYU4tRLdgK+ZSTY91wiq4b8xHIynzzQaVTLGvL
	 7P9Vo9COjZe5OEmoADf7OQIzQvKYBmyANsek6ps6zwZMZLzUZGKS0W9ysA22DNEISA
	 8NGtW+fzkYI1yCFNkVxkRswfdTeBU906Zkc6AFLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 267/550] arm64: dts: qcom: sc7280: Add missing LMH interrupts
Date: Wed, 15 Nov 2023 14:14:11 -0500
Message-ID: <20231115191619.229265347@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

[ Upstream commit 3f93d119c9d6e1744d55cd48af764160a1a3aca3 ]

Hook up the interrupts that signal the Limits Management Hardware has
started some sort of throttling action.

Fixes: 7dbd121a2c58 ("arm64: dts: qcom: sc7280: Add cpufreq hw node")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230811-topic-7280_lmhirq-v1-1-c262b6a25c8f@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 2870fe8fd5263..20231d80c504b 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -5364,6 +5364,14 @@ cpufreq_hw: cpufreq@18591000 {
 			reg = <0 0x18591000 0 0x1000>,
 			      <0 0x18592000 0 0x1000>,
 			      <0 0x18593000 0 0x1000>;
+
+			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "dcvsh-irq-0",
+					  "dcvsh-irq-1",
+					  "dcvsh-irq-2";
+
 			clocks = <&rpmhcc RPMH_CXO_CLK>, <&gcc GCC_GPLL0>;
 			clock-names = "xo", "alternate";
 			#freq-domain-cells = <1>;
-- 
2.42.0



