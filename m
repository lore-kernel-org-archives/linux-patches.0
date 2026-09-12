Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E00C368D5A;
	Sat, 12 Sep 2026 08:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201768; cv=none; b=dfsuhZa6v0gfjmJ9d965mcvdtNB1B1R9faaPZWiwgAVWCXnrzkvKBn/P7yNOmQbk7H0uc3GUnKNOZm9/EEU6XPJtJRJHCQUQD/XxoI7AhBtx6hmjMmlQAnE3dKaeHe/8q0f9sgeA0ilv5DRYmgK8qoVnMIsrZiyJA7o3j09dxkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201768; c=relaxed/simple;
	bh=1oPLxi3HvSyiyKty3XkKFEZVAzk5UCxW3C4TQlY/X1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raeqACkNIX7UdrOUXbO9uH43Bzx9ZKCkLJOuxwpByHMWtZglur4rrYQ49XjUQY23EWNUUgurhqR1n6LI6L8BMG/T67WtAS/UWaMMMi1gxqbIpozLxnKuyxO4PUzOtPnc/WQ4S6IyIGWd05e/W6luRLcLqWsrbaNJFBTV23D5nmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkMP0K/m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkMP0K/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EC31F000FF;
	Sat, 12 Sep 2026 08:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201767;
	bh=TyfdSdw/VB50j+hV57oPgjh8mOCAY/CRw2Lu6UpM8Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkMP0K/mKAh36riV+7o7OBinnXNX0sykXWWZUzgQ0/Un4rpMf8ihtv8PxPAxVMVG1
	 CMMUO0LcuKo6xLvLt+EMYoNrZxgyl70wzpnehd1QNJ0xTPdKeSykYokMvms2RXQ/iW
	 8I203equVGT1D7G0Zj9DnCcWb1GM5xvnra/WkKhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1065/1815] arm64: dts: qcom: sa8540p: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:46:55 +0200
Message-ID: <20260912065714.022104554@linuxfoundation.org>
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

[ Upstream commit 1960614611142e4b57f8a4e276f36ff8b6db2a1d ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 519183af39b2 ("arm64: dts: qcom: add SA8540P and ADP")
Fixes: 6be310347c9c ("arm64: dts: qcom: add SA8540P ride(Qdrive-3)")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-3-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8295p-adp.dts  | 16 ++++++++--------
 arch/arm64/boot/dts/qcom/sa8540p-ride.dts |  8 ++++----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8295p-adp.dts b/arch/arm64/boot/dts/qcom/sa8295p-adp.dts
index d28d691624279..7178ae087038c 100644
--- a/arch/arm64/boot/dts/qcom/sa8295p-adp.dts
+++ b/arch/arm64/boot/dts/qcom/sa8295p-adp.dts
@@ -604,8 +604,8 @@ &usb_0_hsphy {
 };
 
 &usb_0_qmpphy {
-	vdda-phy-supply = <&vreg_l3a>;
-	vdda-pll-supply = <&vreg_l5a>;
+	vdda-phy-supply = <&vreg_l5a>;
+	vdda-pll-supply = <&vreg_l3a>;
 
 	status = "okay";
 };
@@ -628,8 +628,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l4c>;
-	vdda-pll-supply = <&vreg_l1c>;
+	vdda-phy-supply = <&vreg_l1c>;
+	vdda-pll-supply = <&vreg_l4c>;
 
 	status = "okay";
 };
@@ -671,15 +671,15 @@ &usb_2_hsphy3 {
 };
 
 &usb_2_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3a>;
-	vdda-pll-supply = <&vreg_l5a>;
+	vdda-phy-supply = <&vreg_l5a>;
+	vdda-pll-supply = <&vreg_l3a>;
 
 	status = "okay";
 };
 
 &usb_2_qmpphy1 {
-	vdda-phy-supply = <&vreg_l3a>;
-	vdda-pll-supply = <&vreg_l5a>;
+	vdda-phy-supply = <&vreg_l5a>;
+	vdda-pll-supply = <&vreg_l3a>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts b/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
index 44177e9b64b52..df40c44c447e7 100644
--- a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
+++ b/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
@@ -478,8 +478,8 @@ &usb_0_hsphy {
 };
 
 &usb_0_qmpphy {
-	vdda-phy-supply = <&vreg_l3a>;
-	vdda-pll-supply = <&vreg_l5a>;
+	vdda-phy-supply = <&vreg_l5a>;
+	vdda-pll-supply = <&vreg_l3a>;
 
 	status = "okay";
 };
@@ -493,8 +493,8 @@ &usb_2_hsphy0 {
 };
 
 &usb_2_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3a>;
-	vdda-pll-supply = <&vreg_l5a>;
+	vdda-phy-supply = <&vreg_l5a>;
+	vdda-pll-supply = <&vreg_l3a>;
 
 	status = "okay";
 };
-- 
2.53.0



