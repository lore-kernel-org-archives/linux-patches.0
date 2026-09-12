Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6EE39A066;
	Sat, 12 Sep 2026 08:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201858; cv=none; b=E1uICJ4NK7di+bWx5o5VSo1immY0/zCpG16YMr6pMAQCHyLLsSMyi0LLg/05vZqkizhE+oi+JZvWEO9HylW8ymuUk4lK7X7EkZpTI3mMczrnuN9NufX38KB28eZ8d+JX43sqf+Z8UKVyaCKpKXLqpCLmuCd+wYZ1G0sUoqjXIFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201858; c=relaxed/simple;
	bh=Jqdd0zO9aEtjwbHGN/bqdAJTaPqL6M91f9knoeX455E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Th6RX4aAgPNfqD+HOTv1GtlCXfzpZHLi3/bYCap+HeYdAiTReBB3WGK3ExEKbch8dy6x0Se1SFxSG0Jq5JAdJwBFQjD2XevFtodxtaZ8b0K/uZnxT/uW2QeU2IVvwYinaJuYqJLJZJjlz8tRKNGcda5MzRQY+cNZ/S4C8OvsAFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fiOdJNaQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fiOdJNaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942341F000FF;
	Sat, 12 Sep 2026 08:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201857;
	bh=0/UHBgB/Ht8XQW1/D/eBaCgFfoIgE2RjZeGOLzi9OfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fiOdJNaQhJEkKIgU/KCiIjtjGiwklxdDTG+71wJWoKHiPa+ZO+/TAcfbpJ6nVHVsX
	 +01EpJxSZgKX/m6M0JWq860xptkizaIG8tLylQ1fS+y+v89QgR0+sQlysTZm6RqOAk
	 NPRwfCCf1ebCqKsl49Rbs1FSuKFYlbU1gjxHm/Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1082/1815] arm64: dts: qcom: sm8650: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:12 +0200
Message-ID: <20260912065714.422455289@linuxfoundation.org>
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

[ Upstream commit 464fba94ac2e35b336e19c34336a07946da7128f ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.88V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 6fbdb3c1fac7 ("arm64: dts: qcom: sm8650: add initial SM8650 MTP dts")
Fixes: a834911d50c1 ("arm64: dts: qcom: sm8650: add initial SM8650 QRD dts")
Fixes: 01061441029e ("arm64: dts: qcom: sm8650: add support for the SM8650-HDK board")
Fixes: df260487f33c ("arm64: dts: qcom: add basic devicetree for Ayaneo Pocket S2 gaming console")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-20-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650-ayaneo-pocket-s2.dts | 4 ++--
 arch/arm64/boot/dts/qcom/sm8650-hdk.dts              | 4 ++--
 arch/arm64/boot/dts/qcom/sm8650-mtp.dts              | 4 ++--
 arch/arm64/boot/dts/qcom/sm8650-qrd.dts              | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650-ayaneo-pocket-s2.dts b/arch/arm64/boot/dts/qcom/sm8650-ayaneo-pocket-s2.dts
index 0dc994f4e48d9..6ddf30ecabfef 100644
--- a/arch/arm64/boot/dts/qcom/sm8650-ayaneo-pocket-s2.dts
+++ b/arch/arm64/boot/dts/qcom/sm8650-ayaneo-pocket-s2.dts
@@ -1536,8 +1536,8 @@ &usb_1_hsphy {
 };
 
 &usb_dp_qmpphy {
-	vdda-phy-supply = <&vreg_l3i_1p2>;
-	vdda-pll-supply = <&vreg_l3g_0p91>;
+	vdda-phy-supply = <&vreg_l3g_0p91>;
+	vdda-pll-supply = <&vreg_l3i_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sm8650-hdk.dts b/arch/arm64/boot/dts/qcom/sm8650-hdk.dts
index eabc828c05b4c..865ee15be9e21 100644
--- a/arch/arm64/boot/dts/qcom/sm8650-hdk.dts
+++ b/arch/arm64/boot/dts/qcom/sm8650-hdk.dts
@@ -1338,8 +1338,8 @@ &usb_1_hsphy {
 };
 
 &usb_dp_qmpphy {
-	vdda-phy-supply = <&vreg_l3i_1p2>;
-	vdda-pll-supply = <&vreg_l3g_0p91>;
+	vdda-phy-supply = <&vreg_l3g_0p91>;
+	vdda-pll-supply = <&vreg_l3i_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sm8650-mtp.dts b/arch/arm64/boot/dts/qcom/sm8650-mtp.dts
index dd6e33d2dc5d7..26045430d34ad 100644
--- a/arch/arm64/boot/dts/qcom/sm8650-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8650-mtp.dts
@@ -886,8 +886,8 @@ &usb_1_hsphy {
 };
 
 &usb_dp_qmpphy {
-	vdda-phy-supply = <&vreg_l3i_1p2>;
-	vdda-pll-supply = <&vreg_l3g_0p91>;
+	vdda-phy-supply = <&vreg_l3g_0p91>;
+	vdda-pll-supply = <&vreg_l3i_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sm8650-qrd.dts b/arch/arm64/boot/dts/qcom/sm8650-qrd.dts
index a3982ae229290..c00e3ae208cd8 100644
--- a/arch/arm64/boot/dts/qcom/sm8650-qrd.dts
+++ b/arch/arm64/boot/dts/qcom/sm8650-qrd.dts
@@ -1357,8 +1357,8 @@ &usb_1_hsphy {
 };
 
 &usb_dp_qmpphy {
-	vdda-phy-supply = <&vreg_l3i_1p2>;
-	vdda-pll-supply = <&vreg_l3g_0p91>;
+	vdda-phy-supply = <&vreg_l3g_0p91>;
+	vdda-pll-supply = <&vreg_l3i_1p2>;
 
 	status = "okay";
 };
-- 
2.53.0



