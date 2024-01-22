Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06FC54279;
	Tue, 23 Jan 2024 01:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974032; cv=none; b=c4yUzWnvb/TziF+oeRe94SgGYXrcGwfWFw0F2PgBaRJjjUHts/Ms+CNyC/vRxUS4g2HtR4cbyYiY3KdNlbg5WBy7hCSHYoMS2iATraeJBxfQ8E9WUtlWc2Qfvjvd0GMM3C88oRpzjeBNVAlWyaS1OW+tDyju4WX1N+cZqV4zK5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974032; c=relaxed/simple;
	bh=ew5s+PbIKJbmNQJqCUFa983o2EYvAa3EI0ePB5Vs/ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEpoMyrQLhL3uU33TTG9ThBoNFZ2opq27rKkBWNm3GCqHo50cgXMNX4xeefrUebGE8bYzjU+fnXHUoSFPWndnECKRh6ptxZDV8Wo9u2lNIERahCLmdSwfBYtyzKK5nrS/yQ3dzZNloWkjbsKs2ot+z4m0+u8uQW7lYlPYXtxo0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJuuGLM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJuuGLM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A696C433C7;
	Tue, 23 Jan 2024 01:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974032;
	bh=ew5s+PbIKJbmNQJqCUFa983o2EYvAa3EI0ePB5Vs/ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJuuGLM1bwEB/ikdhWpEb2rgFQq2QRrlMamfVWOvoq574ZFH0/YBy5QvU97bF0op1
	 1BClmW0IIiF6at/ZXA3+PyY8EvnNknH0WoodF6HYkpvS6PHVRgGh2n2hcQyMUsktCb
	 KytGmwXDwEtmB3uXLC/Td/lLztSJ7Pi2w+qu0Zz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/374] arm64: dts: qcom: sm8150: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:56:29 -0800
Message-ID: <20240122235749.268551516@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 9204e9a4099212c850e1703c374ef4538080825b ]

As described in the patch ("arm64: dts: qcom: sc7180: Make watchdog
bark interrupt edge triggered"), the Qualcomm watchdog timer's bark
interrupt should be configured as edge triggered. Make the change.

Fixes: b094c8f8dd2a ("arm64: dts: qcom: sm8150: Add watchdog bark interrupt")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20231106144335.v2.4.I23d0aa6c8f1fec5c26ad9b3c610df6f4c5392850@changeid
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index e8cb20c4cbf2..c6b6064e6b12 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3359,7 +3359,7 @@ watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sm8150", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		timer@17c20000 {
-- 
2.43.0



