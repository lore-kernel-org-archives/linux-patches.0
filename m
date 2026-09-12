Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAEA37F730;
	Sat, 12 Sep 2026 08:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201863; cv=none; b=crp8acLEEvs00v0NK/aRYg5prx/L1xPox0TVJf5pL/LgWP4F0WGTy/S55pbC7fq4yJF9PLJFhktTUmRFA/l1ONZiLdSsPvDfTPPwFLAS9RbaO1A2ZkN/kEgDNrnJNuOexsojxOqoXpw/uSqBs4g4WCUNCXuNYhgwdTWxzxZEkE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201863; c=relaxed/simple;
	bh=j/3O0Qo7VCWLmIcVh8Gqj2GX9rEJXLfM0Z9he8HrATo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaXQbzqSIiIAz/9Bf2AqQFM9k1pT81DQf6SXtxVqLhNNJsL1KExj5gH1gAkzd5qrBfiq3xbwd6WbyrUW36yTML7ZEWerDVoslqaax5PCGJj6304M53Nary4Ioo5XlyElf1QhNbooUoUgWJI58jx82wUJkuibdza0EIQrOlIOxBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVlKCaKH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVlKCaKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815931F000FF;
	Sat, 12 Sep 2026 08:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201862;
	bh=vzvK1wF83i97+gKJhkMqRoQe+xILpuZjteI9czfq1tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVlKCaKHDV1hgAlvVv+c0nU13h3GWzWtdVHWOedx+xJVuwjr8FjphAhAN+ndllCRB
	 y8JkWrd2VrA8Q2zb3SQGqmiYKYXMublxg2U+m7hQCTXpMHhc8rS4+RFVyx6yp6x8pE
	 LR/wUS02ORgbK6euxrmuMjTklUvwq/nSFT56r+tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1083/1815] arm64: dts: qcom: sm8750: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:13 +0200
Message-ID: <20260912065714.445192977@linuxfoundation.org>
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

[ Upstream commit 50c9658bc622888f9664a052fd98ef6026883ea5 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.88V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 2340f29e2b06 ("arm64: dts: qcom: sm8750: Add USB support for SM8750 MTP platform")
Fixes: 530f824a4e18 ("arm64: dts: qcom: sm8750: Add USB support for SM8750 QRD platform")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-21-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8750-mtp.dts | 4 ++--
 arch/arm64/boot/dts/qcom/sm8750-qrd.dts | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8750-mtp.dts b/arch/arm64/boot/dts/qcom/sm8750-mtp.dts
index 3837f6785320d..9b5fbc004df4e 100644
--- a/arch/arm64/boot/dts/qcom/sm8750-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8750-mtp.dts
@@ -1404,8 +1404,8 @@ &usb {
 };
 
 &usb_dp_qmpphy {
-	vdda-phy-supply = <&vreg_l3g_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p88>;
+	vdda-phy-supply = <&vreg_l2d_0p88>;
+	vdda-pll-supply = <&vreg_l3g_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sm8750-qrd.dts b/arch/arm64/boot/dts/qcom/sm8750-qrd.dts
index 801c46d556022..b56317cfa9fc7 100644
--- a/arch/arm64/boot/dts/qcom/sm8750-qrd.dts
+++ b/arch/arm64/boot/dts/qcom/sm8750-qrd.dts
@@ -1132,8 +1132,8 @@ &usb {
 };
 
 &usb_dp_qmpphy {
-	vdda-phy-supply = <&vreg_l3g_1p2>;
-	vdda-pll-supply = <&vreg_l2d_0p88>;
+	vdda-phy-supply = <&vreg_l2d_0p88>;
+	vdda-pll-supply = <&vreg_l3g_1p2>;
 
 	status = "okay";
 };
-- 
2.53.0



