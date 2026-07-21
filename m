Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EDD3CF1E0;
	Tue, 21 Jul 2026 17:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655627; cv=none; b=evpv1aBAbXG2vDSUu2fhp3LOb6/DspwpLEXvtemQZBSqxMX7K7O6dIUDo3vT0d/9A5SSe88y33MxvLYZ3sgdK7ju8FTQzTmp9C6nN8Fee1NDjzKPpElhL8VDkoLAW1VUzxus+mXKxH9Xn7XFFAr4q2Rb7bp9ckYuVq1PTzKnmIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655627; c=relaxed/simple;
	bh=0cHAX7vpDkr1TEiNsC851Uq5xlavqyCfgeBN1i30D5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGRpZZEBERmrZlc/nhbb6v0trMimR+PYtRd+XitARO8dhr8stjcgaZuXT5mJziff/8yVZZfAHHr7Y/I+SBAjNAN0hweD6YMK1IxVUJM9DrLtevREg5mtWooTwpOKg2AcuZp+OkY0F03ddvnNyotUzxCJCZ5Zz9hkudEmldhGJEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dv7c5D6t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dv7c5D6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5581F000E9;
	Tue, 21 Jul 2026 17:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655626;
	bh=x7hjma29bfRlHs7izIEvK7TPe4C6lFMYM0lgtVDNCpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dv7c5D6tUMz2RfBQXJelOt+dHyECK58qclF9yczO6huPUehT+jZzCXmwabcBLaEK3
	 7MfhVJvq7DFug1JwuWRTG5AZWMQsBCJl4/LkIEa7nJET1jhRtdDeMVfdZsB/GREk7/
	 H5lbNB0m2XsIi8EvQEOV/43vf/ubxZYYuFMvpP38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0079/1611] arm64: dts: qcom: sc8180x: Fix phy simple_bus_reg warning
Date: Tue, 21 Jul 2026 17:03:15 +0200
Message-ID: <20260721152516.618678573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit f319a5fc998e29699d325af0e461721b3768eeec ]

Correct the unit address of phy node in Qualcomm SC8180x SoC DTSI to fix
W=1 DTC warning:

  sc8180x.dtsi:2650.31-2695.5: Warning (simple_bus_reg): /soc@0/phy@88ee000: simple-bus unit address format error, expected "88ed000"

Fixes: 35e3a9c1afce ("arm64: dts: qcom: sc8180x: switch USB+DP QMP PHYs to new bindings")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260405-dts-qcom-w-1-fixes-v2-4-1f2c7b74a93f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index 85c2afcb417def..e20a096aac7f9b 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -2632,7 +2632,7 @@ usb_mp_qmpphy1: phy@88ec000 {
 			status = "disabled";
 		};
 
-		usb_sec_qmpphy: phy@88ee000 {
+		usb_sec_qmpphy: phy@88ed000 {
 			compatible = "qcom,sc8180x-qmp-usb3-dp-phy";
 			reg = <0 0x088ed000 0 0x3000>;
 
-- 
2.53.0



