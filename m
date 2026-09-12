Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B96455162;
	Sat, 12 Sep 2026 12:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214887; cv=none; b=iMW8FE5YOtEU1rPNK/+5WKl4FGZaESBU7/dgRK1tdIeDy9Lhxv6BBsZqeGUwrLCh27cFt7/AVDQC8ztXNUelkqt1W41A7Ow7V/7/LfTDQI2/ncKpV0xY/pKKfyUsSZidkGILIAHg22G+8XHo2OBGz9GvTjcBxCQH6t2wJHRikmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214887; c=relaxed/simple;
	bh=IkLJ/6rnE9b8XC+kmlgfn1aP/yBTmcN8DPmOMlg7hes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRkNooINJ1RDXuMJ+64TY41jvFEPKWsLWl8BbAmuKhhSK7na1fwFBjzovksAyaTk6pYDu+O1ADI5RWFxt38FHM+iiEP0ANGZh9DZ8M6+SgWSwhnjans0hahYKHXcVOTIgbmyqyOn/z1EW7QIFVQRHn3PYn+YxmMAuQ/RSQhKRaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rITQ7dzK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rITQ7dzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11571F000FF;
	Sat, 12 Sep 2026 12:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214885;
	bh=Rseqx27RuFmYLN+nkOX7Gx7dTTBgzaaZMID8ys+I+Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rITQ7dzKeuRZg+7mjErkwHkZr2vEI0DSOYlBFX1FVGih/Mz6nr8gGMfehE2PwEx4x
	 BmejIlXIhPZyFzs6RvqjVGD9Xf4V/6pfP1eloVcr8XTzlsWrzv4fz3WBi0hopVe4il
	 ykGXwZdPLj7tPIW6jcjOpQOWGTMYn+rh03siDqDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0416/1376] arm64: dts: qcom: hamoa: Fix clocks for HSPHYs
Date: Sat, 12 Sep 2026 08:47:22 +0200
Message-ID: <20260912065616.813369054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 7e9de1b7c7a31..d456190ed76d4 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -2596,7 +2596,7 @@ usb_1_ss0_hsphy: phy@fd3000 {
 			reg = <0 0x00fd3000 0 0x154>;
 			#phy-cells = <0>;
 
-			clocks = <&tcsr TCSR_USB2_1_CLKREF_EN>;
+			clocks = <&rpmhcc RPMH_CXO_CLK>;
 			clock-names = "ref";
 
 			resets = <&gcc GCC_QUSB2PHY_PRIM_BCR>;
@@ -2736,7 +2736,7 @@ usb_1_ss2_hsphy: phy@fde000 {
 			reg = <0 0x00fde000 0 0x154>;
 			#phy-cells = <0>;
 
-			clocks = <&tcsr TCSR_USB2_1_CLKREF_EN>;
+			clocks = <&tcsr TCSR_USB2_2_CLKREF_EN>;
 			clock-names = "ref";
 
 			resets = <&gcc GCC_QUSB2PHY_TERT_BCR>;
-- 
2.53.0



