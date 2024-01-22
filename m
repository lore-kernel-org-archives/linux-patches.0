Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5C754BD6;
	Tue, 23 Jan 2024 01:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974034; cv=none; b=CRBrzeU/qc4moP+WCTzKwWhT/KcXYFOSR7hT3M9nrInIEeJgw3akINEqPK3+O7AR4UPaM25Q+tQ3egMalRXx5j7+OyiWp/epwZefNvXalC3+RNO4GN52xD5eehIHU8OrxRxkskbrLFr6Ma8xqrNvAS96Qf9itNimvAsc+rRw588=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974034; c=relaxed/simple;
	bh=wJSbdoeku2YCbb/84+FLgImcLG3+RdTILHBZpZW0rXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXWvWXDgc/yqHmAvZHdBkd0A2kr3YRyUykxaaZDWSdJju0h+QPbmHaYuSCKMffMg0aY8pyvL4ERZo+7F1QoRFKVKqiSU75gtGn0s0B1Ian/TyyG1ki6eeQT3Xg0Ub+ttMmEJmX32OHpTSdzDvKD5XW4Wu/FmXegEEJEGGC26c5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxfB33Fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxfB33Fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB87DC43390;
	Tue, 23 Jan 2024 01:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974034;
	bh=wJSbdoeku2YCbb/84+FLgImcLG3+RdTILHBZpZW0rXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZxfB33FlxH/qb+5edIQY1/0RA2pHy+Hc57lj71MlJ1oNEYNZOxgmPYAQttxNLqr4Z
	 QteVCVhAoJ6MQoKv0qZjs/mGZAvU5oy6IjH17CLW18J9YZyuWGBDKHkey47YMR3DSe
	 449eZ37NXYqv9qfAABGarNwxgxBZywpMcDUumYw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/374] arm64: dts: qcom: sm8250: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:56:30 -0800
Message-ID: <20240122235749.301933870@linuxfoundation.org>
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

[ Upstream commit 735d80e2e8e5d073ae8b1fff8b1589ea284aa5af ]

As described in the patch ("arm64: dts: qcom: sc7180: Make watchdog
bark interrupt edge triggered"), the Qualcomm watchdog timer's bark
interrupt should be configured as edge triggered. Make the change.

Fixes: 46a4359f9156 ("arm64: dts: qcom: sm8250: Add watchdog bark interrupt")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20231106144335.v2.5.I2910e7c10493d896841e9785c1817df9b9a58701@changeid
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 5d6551e1fcd8..8880e9cbc974 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -3947,7 +3947,7 @@ watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sm8250", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		timer@17c20000 {
-- 
2.43.0



