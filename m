Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C7736728D;
	Sat, 12 Sep 2026 08:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201816; cv=none; b=Prhu2C9a32IzH/QaruWflyOf604dYAfuiEb86zit882Os8n9ATX511fFy2pmnrkmpwJe7EmbKDtj+WBi1wwvP77Ys/7IK3+PenZpKyaW7CmtZ9lfVRjA0NlW8xIS7XeoL9ddsZAGU4kUEb4SJHBxZBQVGbwfCcAaAm/Dv2bi0Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201816; c=relaxed/simple;
	bh=HQBHbSil74AFzrynKl7BLuXi9FycZ3ZdPFA9r6muRmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIMn5NodFgEwLdOESc34+VZ5eI7hQ+/zmAJ5JATDKCpMYkbRWHCwF8EySGWB/Mo+y8ogR7mRXQ9Beg4RP3BmrywwF/o0IzV8lXjXKc5zM5Th9UEU24XRrDw0JWQeWdeeH6KYZDkAj8iPVDQwIXZKfaf4cP6aPSyeUJTvux1h8Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXfCSW9c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXfCSW9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FB61F000FF;
	Sat, 12 Sep 2026 08:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201815;
	bh=2a2gOiKtNaxp8zHYLJ8XsX6y9RZ1xH2F/XkWSxOdNEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXfCSW9cfcjzLwipMpjdQuwBK3E5dtuzvNRrt56l7yqaQcHedk/LHXLn1U51hBrX8
	 mnnK8853KsKXibl14Gl+JbXsJ0W38OADrIBiM8uy8O1RzIXe55uhoavaB7JaQTwIgC
	 PekEJkL7FOJTozxGKN++1T/x9p8VtMtd4P4Sw69Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1074/1815] arm64: dts: qcom: qcm6490: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:04 +0200
Message-ID: <20260912065714.234424730@linuxfoundation.org>
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

[ Upstream commit f6a787a5e238599f3543c3dccf0abd6030dd48e3 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 9af6a9f32ad0 ("arm64: dts: qcom: Add base qcm6490 idp board dts")
Fixes: a319cf4a4b09 ("arm64: dts: qcom: qcm6490: Introduce the Particle Tachyon")
Fixes: eee9602ad649 ("arm64: dts: qcom: qcm6490: Add device-tree for Fairphone 5")
Fixes: 249666e34c24 ("arm64: dts: qcom: add QCM6490 SHIFTphone 8")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-12-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts    | 4 ++--
 arch/arm64/boot/dts/qcom/qcm6490-idp.dts              | 4 ++--
 arch/arm64/boot/dts/qcom/qcm6490-particle-tachyon.dts | 4 ++--
 arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts      | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts b/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts
index 04cb9230d29fd..92a7d80b7fee6 100644
--- a/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts
+++ b/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts
@@ -1502,8 +1502,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l6b>;
-	vdda-pll-supply = <&vreg_l1b>;
+	vdda-phy-supply = <&vreg_l1b>;
+	vdda-pll-supply = <&vreg_l6b>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/qcm6490-idp.dts b/arch/arm64/boot/dts/qcom/qcm6490-idp.dts
index bdc02260f902b..58cce89a0c1ce 100644
--- a/arch/arm64/boot/dts/qcom/qcm6490-idp.dts
+++ b/arch/arm64/boot/dts/qcom/qcm6490-idp.dts
@@ -1141,8 +1141,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l6b_1p2>;
-	vdda-pll-supply = <&vreg_l1b_0p912>;
+	vdda-phy-supply = <&vreg_l1b_0p912>;
+	vdda-pll-supply = <&vreg_l6b_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/qcm6490-particle-tachyon.dts b/arch/arm64/boot/dts/qcom/qcm6490-particle-tachyon.dts
index bf18c48520813..17804de03e177 100644
--- a/arch/arm64/boot/dts/qcom/qcm6490-particle-tachyon.dts
+++ b/arch/arm64/boot/dts/qcom/qcm6490-particle-tachyon.dts
@@ -839,8 +839,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l6b_1p2>;
-	vdda-pll-supply = <&vreg_l1b_0p912>;
+	vdda-phy-supply = <&vreg_l1b_0p912>;
+	vdda-pll-supply = <&vreg_l6b_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts b/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts
index 797f37596bf19..cdaacc09f56c1 100644
--- a/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts
+++ b/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts
@@ -976,8 +976,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l6b>;
-	vdda-pll-supply = <&vreg_l1b>;
+	vdda-phy-supply = <&vreg_l1b>;
+	vdda-pll-supply = <&vreg_l6b>;
 
 	status = "okay";
 };
-- 
2.53.0



