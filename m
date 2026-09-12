Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A8C37F730;
	Sat, 12 Sep 2026 08:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201868; cv=none; b=C4zzg016iDlDjtL8SigeH3qT+Ho8xVLp7KaFl/mlsV2kdM8GOSM3x9cR1cLRlTRLf2ZdDwk4A0x+pf9WW80SlSZpkQmPyDKvGnR6g7l1dpTy1ycvQLIQmvFav3nJsKsSKwwfTAR29TaKvf3/387uVP3btbmuFuE1CxmSmBrGEUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201868; c=relaxed/simple;
	bh=QUpZLFYCzlu/+6mbDKSZ32AzN6v/qbtuGBkrnZ6oHdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxV1aReXvFqFiGOeA6oeD2jUJT27jwzfp5QRkDTB+5bRqNCjPMm7vm91eiWh+rB5pUjG/CkQydrFg+L8FQ7V4MKt0Eh+NvytxkRjZmlEi1VmS0MiUdmc8KudaIuZy3tVcTVczjQrAXJybj11kTAwxoh1Hoau0S5Mdv+RYkqRmww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nV+hT/sb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nV+hT/sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3081F000FF;
	Sat, 12 Sep 2026 08:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201867;
	bh=F81eLY+Rt2ylNqe/+rOzW6BfSia6WxI+/MwUveI4OCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nV+hT/sbkQGmjZkhGWPbS1JkifdNXoDGAOGeNXPIzdresRqMMz1O2e1i+ZmnRAo9x
	 rEQDFn1aFq3AJ0cYeZMIgm/qY13vr1o5FHaFFc4WmbsNnidUvTSB3kmstNkUUssqeR
	 8gpBGOB4c7HSCm+0i3NsR/W7ImwoIixW2BZLailQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1084/1815] arm64: dts: qcom: sar2130p: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:14 +0200
Message-ID: <20260912065714.469007502@linuxfoundation.org>
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

[ Upstream commit 9d883d21fc12c873eee2f864f706c38a289bef59 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHY on this board, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 6339e41fa39b ("arm64: dts: qcom: sar2130p: add QAR2130P board file")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-22-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sar2130p-qar2130p.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sar2130p-qar2130p.dts b/arch/arm64/boot/dts/qcom/sar2130p-qar2130p.dts
index 74778a5b19ba6..80428c0b3b4e6 100644
--- a/arch/arm64/boot/dts/qcom/sar2130p-qar2130p.dts
+++ b/arch/arm64/boot/dts/qcom/sar2130p-qar2130p.dts
@@ -551,8 +551,8 @@ &usb_1_hsphy {
 };
 
 &usb_dp_qmpphy {
-	vdda-phy-supply = <&vreg_l3a_1p2>;
-	vdda-pll-supply = <&vreg_l1a_0p91>;
+	vdda-phy-supply = <&vreg_l1a_0p91>;
+	vdda-pll-supply = <&vreg_l3a_1p2>;
 
 	status = "okay";
 };
-- 
2.53.0



