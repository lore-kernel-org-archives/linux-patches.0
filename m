Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E5A367F36;
	Sat, 12 Sep 2026 07:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197649; cv=none; b=JV5Y/HKKG4ulSK8Bt0dbSArzvpGpxlyeoRzTqOiiSOnrymaYmZ5XS1/sZJhHzkpdlo2x4L4Vv0n5jRRblbTUKE+IJcdHkXQBJBi3VC2l/NlWeH9F8e0lDoh19yTKyzvam+teV3z57WU5kzqeX/BulkbcgpKVtiiOtkl2kP50Acg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197649; c=relaxed/simple;
	bh=tEN3Qb3OpCVDNwUdAuum3r/jpAXqE79VRYDg1rbYXpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BV+K4sokirx9b+KVrzRP5btKLDBlchuMZ3q3PnQ9luitVNHK4g0y+3ro6WuIpbn1fiIE3x5o8DdVVsgkOnshkik04aCdrHzvydScc3jY6cedHq4SCGeWDC0jV3bVx9SSSCBhECMf8zmA+hyGvZHIbbZkDLr1DkbR9L6BjMJskl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ggts5HTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ggts5HTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05351F000FF;
	Sat, 12 Sep 2026 07:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197648;
	bh=5cN8lfnZLGr8cRknj0olSYZMpSkDAlJSMajB31N0018=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ggts5HTcmfLFo1uIjezsmrbvAH59VLs8NTHg2G0dJeQWZp4rKyliiU+F4VFrsnYRZ
	 7lkOFfEHNbCE58z615Ffd04CxDdHZfSk6Hwk/BnLDEA3A4pEhau138+VTr1BnLg4V0
	 g5QWjK49JfEA32smITp32jaN/Oez+BQmzhRmMkbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0217/1815] arm64: dts: qcom: hamoa: Fix clocks for HSPHYs
Date: Sat, 12 Sep 2026 08:32:47 +0200
Message-ID: <20260912065654.089372113@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 115894bc201b0cd1799d239875a1b40924f0ef7b ]

The tertiary controller's HSPHY has its own toggle in TCSR, while the
primary one is wired directly to the XO clock. Fix that.

Fixes: 4af46b7bd66f ("arm64: dts: qcom: x1e80100: Add USB nodes")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260518-topic-hamoa_hsphy_clk-v1-1-d85203756505@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/hamoa.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
index 4ba751a65142b..fd86f4761eab9 100644
--- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
+++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
@@ -2868,7 +2868,7 @@ usb_1_ss0_hsphy: phy@fd3000 {
 			reg = <0 0x00fd3000 0 0x154>;
 			#phy-cells = <0>;
 
-			clocks = <&tcsr TCSR_USB2_1_CLKREF_EN>;
+			clocks = <&rpmhcc RPMH_CXO_CLK>;
 			clock-names = "ref";
 
 			resets = <&gcc GCC_QUSB2PHY_PRIM_BCR>;
@@ -3010,7 +3010,7 @@ usb_1_ss2_hsphy: phy@fde000 {
 			reg = <0 0x00fde000 0 0x154>;
 			#phy-cells = <0>;
 
-			clocks = <&tcsr TCSR_USB2_1_CLKREF_EN>;
+			clocks = <&tcsr TCSR_USB2_2_CLKREF_EN>;
 			clock-names = "ref";
 
 			resets = <&gcc GCC_QUSB2PHY_TERT_BCR>;
-- 
2.53.0



