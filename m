Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF73364059;
	Sat, 12 Sep 2026 08:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201821; cv=none; b=Djh5BNZ18oLcRQS8rQfktx1P7xZszSbJJ0VDB92wIvA3DfNhldpWMwABvWCybc/2737QR/A11ntJsFV/Tr/fNnzd46ZL/mdJyTWJlJw9581bdExVJOvVH1OKbtFXycYmfSZ/QJzU413mUw6J1XxXZMmj/OFiA336XGxKL80DB9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201821; c=relaxed/simple;
	bh=8bp/0fdjNVdreJ+2Jp70fpF0jJRGSJyiiCvwL2miEh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3glzgvnHZb0kgVr0/LOZEE4gH4CxwQr4eLnfbbcGIIFeGhnAR3AZDvDGuruAwdvTktWGnHeSE9I9UOQLKP0pNsWUGj8LsHO8FFHL1pWgrkLrozYcIb1/wdDtbrTcCsZckajDWypafrloNiNc3kIkifGkixnSj4jEycOxiDp6lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjtS9XjB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjtS9XjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209FC1F000FF;
	Sat, 12 Sep 2026 08:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201820;
	bh=Bgf6BfA2vPvr1nqWlItS5mxMtgMeX1yaCqcqeypZQwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjtS9XjBmbCtiD2wAE1LaVu8PEwQ1xe1/PZ+TFiAU+41xI0i+IvCxpeHd1J7D6XVq
	 CcpgexZQVaxGUIHJ2Pi+VVuQR+WQrzbrjZ7Ip/V5UNNLyENCEEa7ceY7QZkewnxHzD
	 djNzqwnE8FqMu+rqKqLFdF0cpIuPoXIMXSs2tTPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1075/1815] arm64: dts: qcom: qcs6490: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:05 +0200
Message-ID: <20260912065714.256858984@linuxfoundation.org>
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

[ Upstream commit 83185fc5f51e7fa2d02f02e2504ad7b002c2d1d8 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 04cf333afc75 ("arm64: dts: qcom: Add base qcs6490-rb3gen2 board dts")
Fixes: 1cde54c54b83 ("arm64: dts: qcom: qcs6490: Add Thundercomm AI Mini PC G1 IoT")
Fixes: f055a39f6874 ("arm64: dts: qcom: Add qcs6490-rubikpi3 board dts")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-13-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts                  | 4 ++--
 arch/arm64/boot/dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts | 4 ++--
 arch/arm64/boot/dts/qcom/qcs6490-thundercomm-rubikpi3.dts     | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
index 03fe7d58f6bfe..eeb422586896f 100644
--- a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
+++ b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
@@ -1419,8 +1419,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l6b_1p2>;
-	vdda-pll-supply = <&vreg_l1b_0p912>;
+	vdda-phy-supply = <&vreg_l1b_0p912>;
+	vdda-pll-supply = <&vreg_l6b_1p2>;
 
 	orientation-switch;
 
diff --git a/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts b/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts
index 2fc8987204e9c..1e773f9300f71 100644
--- a/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts
+++ b/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts
@@ -1059,8 +1059,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l6b_1p2>;
-	vdda-pll-supply = <&vreg_l1b_0p912>;
+	vdda-phy-supply = <&vreg_l1b_0p912>;
+	vdda-pll-supply = <&vreg_l6b_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-rubikpi3.dts b/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-rubikpi3.dts
index f47efca42d48d..7336118ae7e34 100644
--- a/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-rubikpi3.dts
+++ b/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-rubikpi3.dts
@@ -1103,8 +1103,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l6b_1p2>;
-	vdda-pll-supply = <&vreg_l1b_0p912>;
+	vdda-phy-supply = <&vreg_l1b_0p912>;
+	vdda-pll-supply = <&vreg_l6b_1p2>;
 
 	status = "okay";
 };
-- 
2.53.0



