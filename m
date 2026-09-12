Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB87A38AC87;
	Sat, 12 Sep 2026 08:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201803; cv=none; b=J5IJYBhh7pGepxkYgxBnUupGPkdmxbmG8u4D+Wp6hxtU7dpzD6D7dcn3v8WQG7fjWoqQlZxCqER8rWf71HhI4ivNtzDSoTtvW5p1gkVmshFN5TMwEEoAxZRbPgSb3eQYwNFSSycggh17Y4pniQMwjN5T6IWwhKOl87v2uHDe0JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201803; c=relaxed/simple;
	bh=iKYLKqBFyCANsT1Eykdls/8F+6kgZRkTFlmOhGwOfSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+LKk3wPHZ+pBGXT2AQW96+4a6xSVab01YmpKi+r2s4CLNSik6hEM/tc/62l8isDKls7oiak7pa343JUfI0CuObHzB3fC1MLXvXoDeZx9kthBY4m6elMlSMgip+wiiaw82jZCKXUhnTIlgjsPstu9X/+qlUkDpURt+hoeA9URa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNtxH5+f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNtxH5+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524461F000FF;
	Sat, 12 Sep 2026 08:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201801;
	bh=L167aoHCs1JTzdioe0MrguQ3xc8BBBAsUfvTcXmcN30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNtxH5+fhrKk1yGkQyTA2jq47prmhiLd1FaRtLXnShgDmpbfsK3t7t5/qBjBkXFhQ
	 z7AzM78KfnfIwHUTwSbgYyqLhgS6v/YHPGLoba+re/WY2e12jh/CauK7YSCaYG4KFC
	 Z3udarPmpuJ1hh2yUuyH08xDEopB3fo3JcyOiKKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1071/1815] arm64: dts: qcom: sm8450: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:01 +0200
Message-ID: <20260912065714.166133546@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 6469731fb66f40ab873bf4c9fd97d295b390e87f ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.91V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 067b2b3616cd ("arm64: dts: qcom: Add SM8450 HDK DTS")
Fixes: 27a0d0b846d9 ("arm64: dts: qcom: sm8450-qrd: Enable USB nodes")
Fixes: 1620676b85f1 ("arm64: dts: qcom: sm8450-nagara: Separate out Nagara platform dtsi")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-9-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450-hdk.dts                 | 4 ++--
 arch/arm64/boot/dts/qcom/sm8450-qrd.dts                 | 4 ++--
 arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara.dtsi | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450-hdk.dts b/arch/arm64/boot/dts/qcom/sm8450-hdk.dts
index b37998cd9a2c3..4ade28f40cae0 100644
--- a/arch/arm64/boot/dts/qcom/sm8450-hdk.dts
+++ b/arch/arm64/boot/dts/qcom/sm8450-hdk.dts
@@ -1214,8 +1214,8 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l6b_1p2>;
-	vdda-pll-supply = <&vreg_l1b_0p91>;
+	vdda-phy-supply = <&vreg_l1b_0p91>;
+	vdda-pll-supply = <&vreg_l6b_1p2>;
 };
 
 &usb_1_qmpphy_out {
diff --git a/arch/arm64/boot/dts/qcom/sm8450-qrd.dts b/arch/arm64/boot/dts/qcom/sm8450-qrd.dts
index 56db5f79f59d2..4993059483e9a 100644
--- a/arch/arm64/boot/dts/qcom/sm8450-qrd.dts
+++ b/arch/arm64/boot/dts/qcom/sm8450-qrd.dts
@@ -527,8 +527,8 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l6b_1p2>;
-	vdda-pll-supply = <&vreg_l1b_0p91>;
+	vdda-phy-supply = <&vreg_l1b_0p91>;
+	vdda-pll-supply = <&vreg_l6b_1p2>;
 };
 
 &usb_1_qmpphy_out {
diff --git a/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara.dtsi b/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara.dtsi
index 6bd315e109925..4fb5627d81264 100644
--- a/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara.dtsi
@@ -793,7 +793,7 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&pm8350_l6>;
-	vdda-pll-supply = <&pm8350_l1>;
+	vdda-phy-supply = <&pm8350_l1>;
+	vdda-pll-supply = <&pm8350_l6>;
 	status = "okay";
 };
-- 
2.53.0



