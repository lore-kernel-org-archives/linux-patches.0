Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD2D14A4FA;
	Tue, 23 Jan 2024 00:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969248; cv=none; b=dKK28ar8dKNg6a0PRx0J2tWcNSQVBYUK+uH+x1kfzYlpSkLnsNafyM5DrjegjsUtwkuiuc9lDrq+mCJ/ELy8FpM2rGP49d+WrSpVLJTB+Pqj63jsvrXlty5TGkAdP98YF2OrHsFX5yTTPXew4pVZbqTjOJ7EycSms4t6AotA2Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969248; c=relaxed/simple;
	bh=qWvfL7yx3lG4yVQE7tG3aQuvBXp0XLfWMmC0gAAxhzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Px33RdPv02zCDD4cY8Y5Ulfn1v3xtln9XF+2yc1ti2gdgw7lYuYKBh1RfWsBgaIp8Bgflo//IXbeDn2tGgDeLbe5i9Ssw8t76US9b8S0tkkypnvMWLXgrluWmYLapmpiKO9h3XoDsi48tJ3j9vEgs/Ih9m4OCNMSwgKRwoFxIfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JWg073Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JWg073Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C43C43399;
	Tue, 23 Jan 2024 00:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969248;
	bh=qWvfL7yx3lG4yVQE7tG3aQuvBXp0XLfWMmC0gAAxhzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0JWg073ZLvVsgG0D9o5mPxbxOR/Fbpd1Hyq5CUkDggyCmopf4NP5PQym+UJQN7FoX
	 jxRIkpqdxqe6pjbaxAI4187usDJQzS2vRPVkZ9EplLdllY+Kbzwf4nqIk7iWiKRslZ
	 7Fx6qRSI3VWhYIW7rrWjFTcpotT4LvmjVK0E/eAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 124/641] arm64: dts: qcom: sc7280: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:50:28 -0800
Message-ID: <20240122235821.933607428@linuxfoundation.org>
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

[ Upstream commit 6897fac411db7b43243f67d4fd4d3f95abf7f656 ]

As described in the patch ("arm64: dts: qcom: sc7180: Make watchdog
bark interrupt edge triggered"), the Qualcomm watchdog timer's bark
interrupt should be configured as edge triggered. Make the change.

Fixes: 0e51f883daa9 ("arm64: dts: qcom: sc7280: Add APSS watchdog node")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20231106144335.v2.2.I11f77956d2492c88aca0ef5462123f225caf4fb4@changeid
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 66f1eb83cca7..6d01262199dc 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -5222,7 +5222,7 @@ watchdog: watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sc7280", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 			status = "reserved"; /* Owned by Gunyah hyp */
 		};
 
-- 
2.43.0



