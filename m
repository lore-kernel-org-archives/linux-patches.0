Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43B428382
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUOU13nL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61873C433C8;
	Wed, 15 Nov 2023 19:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076393;
	bh=w2GgMIdjgCMXPy3LiBzJOKrg1tLZO8s0Do25z5JK5vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUOU13nLPYaxHENSsTm3kpoFzAscjmm6E91WjnVmcink6Aindp2f34tGCEotK/Wz1
	 +J1um+So/8s1iqZ8L6FJsNCgdyJnpa0mOuwCjFLCtiLuQCJPVmzViklWyCTXhGkv/l
	 KIzop5rmywolVO5fIXPCY8NEl8EhwEdU7aNkx/mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Gaurav Kohli <quic_gkohli@quicinc.com>,
	Stephan Gerhold <stephan@gerhold.net>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 264/550] arm64: dts: qcom: msm8916: Fix iommu local address range
Date: Wed, 15 Nov 2023 14:14:08 -0500
Message-ID: <20231115191619.012081699@linuxfoundation.org>
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

From: Gaurav Kohli <quic_gkohli@quicinc.com>

[ Upstream commit 2de8ee9f58fa51f707c71f8fbcd8470ab0078102 ]

Fix the apps iommu local address space range as per data sheet.

Fixes: 6a6729f38436 ("arm64: dts: qcom: msm8916: Add IOMMU support")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Gaurav Kohli <quic_gkohli@quicinc.com>
Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230915143304.477-1-quic_gkohli@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 7582c7d748fe9..6b8705e965537 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -1805,7 +1805,7 @@ apps_iommu: iommu@1ef0000 {
 			#size-cells = <1>;
 			#iommu-cells = <1>;
 			compatible = "qcom,msm8916-iommu", "qcom,msm-iommu-v1";
-			ranges = <0 0x01e20000 0x40000>;
+			ranges = <0 0x01e20000 0x20000>;
 			reg = <0x01ef0000 0x3000>;
 			clocks = <&gcc GCC_SMMU_CFG_CLK>,
 				 <&gcc GCC_APSS_TCU_CLK>;
-- 
2.42.0



