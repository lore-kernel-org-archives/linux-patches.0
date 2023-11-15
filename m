Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D26E3A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDESKOJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C73DC433CC;
	Wed, 15 Nov 2023 19:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077402;
	bh=NrIwbpt9PY6GJVSpp4BSLGX2+Qcy1e5DhYE8Ux2Yy54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDESKOJy3aHKjmVYiLlQsEVIgWMP5s9whqirJBLuCKLtqkwMaXSf/8OqyhZoFDEqj
	 g3yHRE/KW6V1yUI522VthDrq/393C5g5z2GHXOSB9tnDOdaDCFCGdw5ikDk8jjlFsP
	 aHzlK/XSfuA9CYkIez5ffX7HLvaL9Oq6ZlZhqFWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 281/603] arm64: dts: qcom: sm6125: Pad APPS IOMMU address to 8 characters
Date: Wed, 15 Nov 2023 14:13:46 -0500
Message-ID: <20231115191632.817508282@linuxfoundation.org>
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 310cdafc4a56827d1aeda7cc297939034adb8f99 ]

APPS IOMMU is the only node in sm6125.dtsi that doesn't have its
address padded to 8 hexadecimals; fix this by prepending a 0.

Fixes: 8ddb4bc3d3b5 ("arm64: dts: qcom: sm6125: Configure APPS SMMU")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Link: https://lore.kernel.org/r/20230723-sm6125-dpu-v4-2-a3f287dd6c07@somainline.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6125.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125.dtsi b/arch/arm64/boot/dts/qcom/sm6125.dtsi
index d7c1a40617c64..197f8fed19a29 100644
--- a/arch/arm64/boot/dts/qcom/sm6125.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6125.dtsi
@@ -1208,7 +1208,7 @@ spmi_bus: spmi@1c40000 {
 
 		apps_smmu: iommu@c600000 {
 			compatible = "qcom,sm6125-smmu-500", "qcom,smmu-500", "arm,mmu-500";
-			reg = <0xc600000 0x80000>;
+			reg = <0x0c600000 0x80000>;
 			interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.42.0



