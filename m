Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B687E364038;
	Sat, 12 Sep 2026 09:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206504; cv=none; b=CfqF9GoSJ6oY7TXgg71dqqTV3OWX/G8ZYVQXzqytVMfsG1B8OxJwN9Syag1CA6XlKeQIuqIVxp2IcHgRrst2FVe3lcq7f0TgOGBnsS/mRFHQb8geL8Lu6xaS/Zt9EKLQW2cvG5hslAM0+VAAHx1q6+QrJILEzTz5dwMUtE13xrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206504; c=relaxed/simple;
	bh=UlwsJQgIZuprl37UE+EfCw4xPvJqp+J1MCSNPAhNUNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8ZQQ891j3WPsEl4OlRcE+hnmVr0bU3Lr8aQohnbt/cz05SJFQJr8JZmhhv1y+zmKmSKdwMGagiRAL6KengwmT7baSm/DKL9DKhr0tOggIs3MrfRuYyWf8b3fI8rdG3OMD0JEj/uFEHfrA9kd/19CmBSR7F9naGy+69/5TkXgPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6HGIXw4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6HGIXw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB4E1F000FF;
	Sat, 12 Sep 2026 09:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206503;
	bh=eZyObHOgFMR637B4d86Arq8AOAdWUB57DNx9jpSE38E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m6HGIXw491PBJmvCd0kVCsj3bQDFVB0Jb7h/qFq+W4eEeyHvlSY4hAfUBkEvBqff8
	 sPd+9+I5exSK17wypISP/gj58l/3y3oPVh4v5PSruKvCT9UH9F1uzWLO/Wb4KH2vVK
	 rubVKFerPFw7pmMQpbzHTld/0Nzu/LEBQznpPzSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0220/1518] arm64: dts: qcom: hamoa: Fix clocks for HSPHYs
Date: Sat, 12 Sep 2026 08:39:49 +0200
Message-ID: <20260912065628.465531768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index adb18c10dbd9f..6a456b3694fc9 100644
--- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
+++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
@@ -2826,7 +2826,7 @@ usb_1_ss0_hsphy: phy@fd3000 {
 			reg = <0 0x00fd3000 0 0x154>;
 			#phy-cells = <0>;
 
-			clocks = <&tcsr TCSR_USB2_1_CLKREF_EN>;
+			clocks = <&rpmhcc RPMH_CXO_CLK>;
 			clock-names = "ref";
 
 			resets = <&gcc GCC_QUSB2PHY_PRIM_BCR>;
@@ -2968,7 +2968,7 @@ usb_1_ss2_hsphy: phy@fde000 {
 			reg = <0 0x00fde000 0 0x154>;
 			#phy-cells = <0>;
 
-			clocks = <&tcsr TCSR_USB2_1_CLKREF_EN>;
+			clocks = <&tcsr TCSR_USB2_2_CLKREF_EN>;
 			clock-names = "ref";
 
 			resets = <&gcc GCC_QUSB2PHY_TERT_BCR>;
-- 
2.53.0



