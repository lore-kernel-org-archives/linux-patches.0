Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F0E14AD2B;
	Tue, 23 Jan 2024 00:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969263; cv=none; b=SyKfZW/KbpU1T+kX8XGxcR00PU5P5sYQRpdRadaNme1nnSl1fzB21T6UZe+4x6dEcgCZBd4Fv/2xTL4FrFQWbRqI51S6peOBg37uw1WCj9R6qLjFz1+2S+/m5PpqlFuH7Ue7ujZTm/+8dMWs1hxwA73ryyymsIhr7CNHg9qaFhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969263; c=relaxed/simple;
	bh=zDeMVOWDR6CS5pU5RabdRj813Vp2cU3EBvnyRXxGTKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHFRlJcy4hAAQM4qLfdks2hUJ0zmztUVunHYfij4mZAON6R+3Y2w8WmddathAoYje5c3eQvAovbR3B6mr0i3SDNBbg21nN8okmeZ/ES8QhEvki7QoIohqomGAcBEHsc36YHAsrUiJbxascBbfITBCR6u7ON37oDvAemw5MlpCik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=un0aaYXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="un0aaYXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973CBC433F1;
	Tue, 23 Jan 2024 00:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969263;
	bh=zDeMVOWDR6CS5pU5RabdRj813Vp2cU3EBvnyRXxGTKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=un0aaYXMvFVc7CC43xfZgiUiZkWRrXZlVV7BzNdrrWUTbZZNBG3lBGEtfiE/KFDtr
	 yyE7+NPUoC6UsKOocnjwe2XJoioWAAZ5sKa0HZMvW6kytnOioGJcKpFMVD2AM/zIgu
	 GkM25WnLTdC7LMqsjjs8e+clpHVvvs0ngOZ1+8aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 130/641] arm64: dts: qcom: sm6350: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:50:34 -0800
Message-ID: <20240122235822.116142798@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 5b84bb2b8d86595544fc8272364b0f1a34b68a4f ]

As described in the patch ("arm64: dts: qcom: sc7180: Make watchdog
bark interrupt edge triggered"), the Qualcomm watchdog timer's bark
interrupt should be configured as edge triggered. Make the change.

Fixes: 5f82b9cda61e ("arm64: dts: qcom: Add SM6350 device tree")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20231106144335.v2.8.Ic1d4402e99c70354d501ccd98105e908a902f671@changeid
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index 8fd6f4d03490..6464e144c228 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -2524,7 +2524,7 @@ watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sm6350", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		timer@17c20000 {
-- 
2.43.0



