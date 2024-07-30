Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700741BA885;
	Tue, 30 Jul 2024 15:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355117; cv=none; b=DYp4bEbKpur/e9ggAZCIsoENZL0R8MQhQH9DEzbtVKCx7w4dOkjBNr2VASSONKIJQtwhLcWFFJU0vZwy9lmcgkddD3ROBqmFasMsU6bvVwd/4S/WMMaGtmcAfjYJxmtKNoZqtOWlEb/2Uw4Tf3Mmey1UKSQl40xWsGk9NKivlFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355117; c=relaxed/simple;
	bh=rhBKG2lfOVi2aDgqSbNb65rGkolN7IH2btmmVka6RlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9hPThruxQ9GFXLVUG7H1GOIIoZD1ibGHyEscKPSuxjzzdeMMk1UZs/M2j4vE/OnvCzFD6jSDVoWDa8Wv9Z24YV4nMs6dPMnCMoX6YlldorRQl4LMJMA+sbE29zz6V8Fq48x5MTaUWotPfHxiHN/YhB2SyCIvpSa6Icm1Oaqq+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Hd8iSvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Hd8iSvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D276DC4AF0F;
	Tue, 30 Jul 2024 15:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355117;
	bh=rhBKG2lfOVi2aDgqSbNb65rGkolN7IH2btmmVka6RlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Hd8iSvR+x9owvaLPEf5/hrHegL6fIBH9mxY4DLKJIHaM6DhGqmwHNM9ce5Kf1Uti
	 s6auxV5peyKMt6SeLihYUYrZZ8Y6j4rI5kBOou2xI09YycuN5JVhFPuq2STcUfSLjo
	 cmaEoiGLcrDM35MvOFERJgAyzBagDC0R/oNNCChw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/568] arm64: dts: qcom: sc8180x: switch UFS QMP PHY to new style of bindings
Date: Tue, 30 Jul 2024 17:42:16 +0200
Message-ID: <20240730151640.977647845@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 916b5916f228a9f83a22ad91ad8c5bf788a456d7 ]

Change the UFS QMP PHY to use newer style of QMP PHY bindings (single
resource region, no per-PHY subnodes).

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230731111158.3998107-1-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 9a80ecce60bd ("arm64: dts: qcom: sc8180x: add power-domain to UFS PHY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index 9163c1419cc12..d310d4c4d0953 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -2093,7 +2093,7 @@ ufs_mem_hc: ufshc@1d84000 {
 				     "jedec,ufs-2.0";
 			reg = <0 0x01d84000 0 0x2500>;
 			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
-			phys = <&ufs_mem_phy_lanes>;
+			phys = <&ufs_mem_phy>;
 			phy-names = "ufsphy";
 			lanes-per-direction = <2>;
 			#reset-cells = <1>;
@@ -2132,10 +2132,8 @@ ufs_mem_hc: ufshc@1d84000 {
 
 		ufs_mem_phy: phy-wrapper@1d87000 {
 			compatible = "qcom,sc8180x-qmp-ufs-phy";
-			reg = <0 0x01d87000 0 0x1c0>;
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			reg = <0 0x01d87000 0 0x1000>;
+
 			clocks = <&rpmhcc RPMH_CXO_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 			clock-names = "ref",
@@ -2143,16 +2141,10 @@ ufs_mem_phy: phy-wrapper@1d87000 {
 
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
-			status = "disabled";
 
-			ufs_mem_phy_lanes: phy@1d87400 {
-				reg = <0 0x01d87400 0 0x108>,
-				      <0 0x01d87600 0 0x1e0>,
-				      <0 0x01d87c00 0 0x1dc>,
-				      <0 0x01d87800 0 0x108>,
-				      <0 0x01d87a00 0 0x1e0>;
-				#phy-cells = <0>;
-			};
+			#phy-cells = <0>;
+
+			status = "disabled";
 		};
 
 		ipa_virt: interconnect@1e00000 {
-- 
2.43.0



