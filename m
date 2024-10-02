Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD9216F84F;
	Wed,  2 Oct 2024 13:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875585; cv=none; b=V/GfKdNzma1BZ2oDhDPejeta75NDrSz95TNpGRL7ul92t5gDhBd/aTKnoEq3lLveyBzMUReaMiV8Dcd2LU6YtwtrWabnN2ubZ7OogyLCEI9rLC1zsyCrLRqdrnVP84YQ1xzP0ceOwhjhXUlcvbLdu6WAVOear2niZCA7DPnhjpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875585; c=relaxed/simple;
	bh=YJruoD+Ht5KT1EHrMTx9tjRtA+Vd8Qgpg2uiKVrHqK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGjnjIOks3VR1CAix/bbt4CG54VGVWFjs3BArRiEqCLgvZc1SZEkoh5UOmNBf6DmbPHYvQbuBJ+EAr2WT1ByDHgDTfL8vfHQa7Y49dPrGsRvrb9LnZ+INMY2M1LU5EgBICEY6SUEzJbmX5jUo8sB4JeySOWzukBausQ/fBEapdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgH0zn5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgH0zn5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D9BC4CEC5;
	Wed,  2 Oct 2024 13:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875585;
	bh=YJruoD+Ht5KT1EHrMTx9tjRtA+Vd8Qgpg2uiKVrHqK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgH0zn5LHmfzAH+vtGMjQSFAI1tCsgS1i0L2oqMZNbx4GMcMa2juCYAMtOpIvCPx8
	 ISaTobIKrp4KNbXj/+x21eEeINCpBB+IbNDEQ/0+eysag0auRLoQftdgmp6OTEg5JN
	 m5elNh0YdLyFFm5ytcBVxK2sBSvwjPL2FhtPQxmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 150/695] arm64: dts: qcom: x1e80100: Fix PHY for DP2
Date: Wed,  2 Oct 2024 14:52:28 +0200
Message-ID: <20241002125828.469294317@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit ba728bda663b0e812cb20450d18af5d0edd803a2 ]

The actual PHY used by MDSS DP2 is the USB SS2 QMP one. So switch to it
instead. This is needed to get external DP support on boards like CRD
where the 3rd Type-C USB port (right-hand side) is connected to DP2.

Fixes: 1940c25eaa63 ("arm64: dts: qcom: x1e80100: Add display nodes")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Link: https://lore.kernel.org/r/20240829-x1e80100-dts-dp2-use-qmpphy-ss2-v1-1-9ba3dca61ccc@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index cd732ef88cd8e..6174160b56c49 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -4402,14 +4402,14 @@
 
 				assigned-clocks = <&dispcc DISP_CC_MDSS_DPTX2_LINK_CLK_SRC>,
 						  <&dispcc DISP_CC_MDSS_DPTX2_PIXEL0_CLK_SRC>;
-				assigned-clock-parents = <&mdss_dp2_phy 0>,
-							 <&mdss_dp2_phy 1>;
+				assigned-clock-parents = <&usb_1_ss2_qmpphy QMP_USB43DP_DP_LINK_CLK>,
+							 <&usb_1_ss2_qmpphy QMP_USB43DP_DP_VCO_DIV_CLK>;
 
 				operating-points-v2 = <&mdss_dp2_opp_table>;
 
 				power-domains = <&rpmhpd RPMHPD_MMCX>;
 
-				phys = <&mdss_dp2_phy>;
+				phys = <&usb_1_ss2_qmpphy QMP_USB43DP_DP_PHY>;
 				phy-names = "dp";
 
 				#sound-dai-cells = <0>;
@@ -4597,8 +4597,8 @@
 				 <&usb_1_ss0_qmpphy QMP_USB43DP_DP_VCO_DIV_CLK>,
 				 <&usb_1_ss1_qmpphy QMP_USB43DP_DP_LINK_CLK>, /* dp1 */
 				 <&usb_1_ss1_qmpphy QMP_USB43DP_DP_VCO_DIV_CLK>,
-				 <&mdss_dp2_phy 0>, /* dp2 */
-				 <&mdss_dp2_phy 1>,
+				 <&usb_1_ss2_qmpphy QMP_USB43DP_DP_LINK_CLK>, /* dp2 */
+				 <&usb_1_ss2_qmpphy QMP_USB43DP_DP_VCO_DIV_CLK>,
 				 <&mdss_dp3_phy 0>, /* dp3 */
 				 <&mdss_dp3_phy 1>;
 			power-domains = <&rpmhpd RPMHPD_MMCX>;
-- 
2.43.0



