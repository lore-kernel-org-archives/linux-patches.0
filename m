Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6C51FC7;
	Wed, 25 Feb 2026 01:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983893; cv=none; b=pf5wIX2ZiJd+RnUySlOb8AR+/paap7wSf0FcCSRxKxO6ghwOs95+lvtC3/UkIzV6TwP7UU5S1AVqyyustlt29rzbqlEi5it5DnajlkVeQeNz0o6lbobxsGHGmLVja8epqA1S3AR8w5nHNDpkcIi6WWwxkAg4cGAQcW2PFQtKNHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983893; c=relaxed/simple;
	bh=nwkBQeUvsVA8BieULcdXEc7FfHlNM3cL1E7ZauX7h9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXnUBC8aS+RiSslofbs+QFkZx/jDd0JUYnfTz1VOZCJoEDEEEtyzsJV+9VxBSfSYIYnM0BUQ6iCSIbo1GdZsgsmdBxeJuAidoz72WoXttKABndoN3t6w3IWQ9BfOjwReFUfxmKSTj4s1rb4/k1pfsk0fNkX4H3SSKKuKM+URCBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XR/MkHB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XR/MkHB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BAFC116D0;
	Wed, 25 Feb 2026 01:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983893;
	bh=nwkBQeUvsVA8BieULcdXEc7FfHlNM3cL1E7ZauX7h9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XR/MkHB+Yywg2XcUR97+lO5RO9rCCArZQ4cHwMozSxPIUh2nj13l9YvDvWAi9Byfv
	 fKvCDrlL1ds7r5fPFgHdJOLrr+aM9OnEjNHmsYZ6WAMUtxPRrRATThGtqbHwilvGOL
	 0KLLHonTyqA705Z020BMUsjspnWPFX0WJgzuSkQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 165/641] arm64: dts: qcom: agatti: Add CX_MEM/DBGC GPU regions
Date: Tue, 24 Feb 2026 17:18:11 -0800
Message-ID: <20260225012353.059699751@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 0fdcc948929a6d673bd0f90631dd6e42090c3dbd ]

Describe the GPU register regions, with the former existing but not
being used much if at all on this silicon, and the latter containing
various debugging levers generally related to dumping the state of
the IP upon a crash.

Fixes: 4faeef52c8e6 ("arm64: dts: qcom: qcm2290: Add GPU nodes")
Reported-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Closes: https://lore.kernel.org/linux-arm-msm/8a64f70b-8034-45e7-86a3-0015cf357132@oss.qualcomm.com/T/#m404f1425c36b61467760f058b696b8910340a063
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251229-topic-6115_2290_gpu_dbgc-v1-2-4a24d196389c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcm2290.dtsi | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcm2290.dtsi b/arch/arm64/boot/dts/qcom/qcm2290.dtsi
index 3b0ba590ee825..e0e400fdd2497 100644
--- a/arch/arm64/boot/dts/qcom/qcm2290.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcm2290.dtsi
@@ -1503,8 +1503,12 @@ usb_dwc3_ss: endpoint {
 
 		gpu: gpu@5900000 {
 			compatible = "qcom,adreno-07000200", "qcom,adreno";
-			reg = <0x0 0x05900000 0x0 0x40000>;
-			reg-names = "kgsl_3d0_reg_memory";
+			reg = <0x0 0x05900000 0x0 0x40000>,
+			      <0x0 0x0599e000 0x0 0x1000>,
+			      <0x0 0x05961000 0x0 0x800>;
+			reg-names = "kgsl_3d0_reg_memory",
+				    "cx_mem",
+				    "cx_dbgc";
 
 			interrupts = <GIC_SPI 177 IRQ_TYPE_LEVEL_HIGH>;
 
-- 
2.51.0



