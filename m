Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B23F4F1;
	Sat, 12 Sep 2026 16:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232226; cv=none; b=d/uR5KcEv7hW0LxHsk+/Zrw44+cu5MuB0jAffrUIsyY67y/6BcZSimFqLB4ZtY6SqCyHE+au9lfd1wLuc/rkL2SzlCisSNPzd53trVsClAiw8eqmENIUNwP3D9FsX9pAODCu2TWEBYcNdv8TwIbT8hM+v92s9bv+4pqHuQG0duQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232226; c=relaxed/simple;
	bh=zV+V804n6Ja3naxLiy5vwqjNfLWhQnhwMx4slkeuMr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urnHlxLoglgMmAG2nxZMumHNfjwb37llMsr/xlu71WstLDr2ABFquJ+06UazXlpqyIiQCBf3C2PNZLbfZkHUjgjRmdLhyNyN0kLt/vj/DJxsH1br9DF/bSSlQLnW0l2jDQpStuPtf3/gE0gh0U45lA0MCkCseFrKmm2ZMA3xl0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlxGXq7m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlxGXq7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0581F000FF;
	Sat, 12 Sep 2026 16:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232224;
	bh=M6MpCH3BADuZnFzBn0Aa9dbOkSE2IDUN3v1POr7UJKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nlxGXq7mb18/vYvAfxioSTbVHX0G2KgHnt1R9jcLb+VQzJMSRTYi7p28RGevRROMV
	 M3LKHDJL6fdjyPM01KKc6cdsbyb2ZNyB7SDwRyo+hQEz800pieTRu9k4/ZTutYjYsd
	 IJe9EZoO2ZHmtz5IYnCJYGviMuNkN9N1k/AdhCgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Guo <quic_cang@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1160/1191] arm64: dts: qcom: sm8550: Fix UFS PHY clocks
Date: Sat, 12 Sep 2026 09:04:48 +0200
Message-ID: <20260912065614.196654266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 746ae23ad02004fe283e2edb45b7a060bbc36d46 ]

QMP PHY used in SM8550 requires 3 clocks:

* ref - 19.2MHz reference clock from RPMh
* ref_aux - Auxiliary reference clock from GCC
* qref - QREF clock from TCSR

Fixes: 35cf1aaab169 ("arm64: dts: qcom: sm8550: Add UFS host controller and phy nodes")
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240131-ufs-phy-clock-v3-16-58a49d2f4605@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 09a3d2caf05ec..426b1750b7239 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1602,9 +1602,12 @@ crypto: crypto@1de0000 {
 		ufs_mem_phy: phy@1d80000 {
 			compatible = "qcom,sm8550-qmp-ufs-phy";
 			reg = <0x0 0x01d80000 0x0 0x2000>;
-			clocks = <&tcsr TCSR_UFS_CLKREF_EN>,
-				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
-			clock-names = "ref", "ref_aux";
+			clocks = <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
+				 <&tcsr TCSR_UFS_CLKREF_EN>;
+			clock-names = "ref",
+				      "ref_aux",
+				      "qref";
 
 			power-domains = <&gcc UFS_MEM_PHY_GDSC>;
 
-- 
2.53.0



