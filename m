Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459E11170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AA3C433C7;
	Mon, 11 Sep 2023 14:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441326;
	bh=hxIrzVaCeunsb7tUx4YAGG/OxyE678sR/KdOCPu8WMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdG3YbYXpPjzl9cRkqmOYaobjAs5lgVTUSdTZsiKdc6dhhPDnExZxujoEpncFaKT+
	 /3VPOtF+AGlDm9CWVcOj77SP7D+uf8LlRm+/G6+NqNhnNGZ5P4nDazbybpLxA3t2H4
	 Pi8i6nsk078AFKfePnF5773np3r9ZoXbCsf8NsVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 347/739] arm64: dts: qcom: msm8998: Add missing power domain to MMSS SMMU
Date: Mon, 11 Sep 2023 15:42:26 +0200
Message-ID: <20230911134700.809577819@linuxfoundation.org>
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

[ Upstream commit 7f828f3207142351750e9545527341425187de7b ]

The MMSS SMMU has its own power domain. Attach it so that we can drop
the "keep it always-on" hack.

Fixes: 05ce21b54423 ("arm64: dts: qcom: msm8998: Configure the multimedia subsystem iommu")
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230531-topic-8998_mmssclk-v3-2-ba1b1fd9ee75@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index 2c3e595091fbc..ed764d02819f7 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -2764,6 +2764,8 @@ mmss_smmu: iommu@cd00000 {
 				<GIC_SPI 261 IRQ_TYPE_LEVEL_HIGH>,
 				<GIC_SPI 262 IRQ_TYPE_LEVEL_HIGH>,
 				<GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+
+			power-domains = <&mmcc BIMC_SMMU_GDSC>;
 		};
 
 		remoteproc_adsp: remoteproc@17300000 {
-- 
2.40.1



