Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386C82AD38;
	Tue, 23 Jan 2024 01:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974668; cv=none; b=cGAtia4dkqFWOs99z/uuvKVdn5KnpIBWhNrzbKy8/rYxnyvGW6qJCc1mWIudzus6gUNV3zwTB9ZjCenhCmi46NA07+fEDgREIdPHlw5JVOyMnI+QtDF+3FTc1PMWnEJNO/9aiedDP8gHIk8g0FUVy3etsRCb8g0cc6Wf1ufrQO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974668; c=relaxed/simple;
	bh=okVFb234r66UrNod3dBeFsg1SOJ4k/w9tNI7KE2mpA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PthNAnaF/AAc7VyLHaUEmbFbUKzAwh4/7+oODLSh1Fn8iYQMXvxdIx/gw7yMVsxbmpTkEEObF2JXhcPclnljey4vWZ1vWhaWUnJQhX6Wl+D2vFQXu0A8DHkEDFjxr79a6DUNPfssjdSwdqr3bGAR0IGkqqjOnVqrs6NA7OMlPrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejkY2G4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejkY2G4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08E0C43390;
	Tue, 23 Jan 2024 01:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974668;
	bh=okVFb234r66UrNod3dBeFsg1SOJ4k/w9tNI7KE2mpA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejkY2G4NQ+oU0dRjPdw6kW6bSa6E09S46dPFMd1nBsSx+Rg3owuijE3VDvNQc60Th
	 sHM8BRbhpvVw2GR6EDfPl+bQuZ5flhzHJgYz4qPj2NXj5ip2twIk57q3aTdw6Y3VbK
	 xsq/nH8PwrMCo1Bp5QUK11YxCvuOt3ptnBRB60Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/583] arm64: dts: qcom: sm8250: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:52:46 -0800
Message-ID: <20240122235815.675187176@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a4e58ad731c3..1a98481d0c7f 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -5664,7 +5664,7 @@ watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sm8250", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		timer@17c20000 {
-- 
2.43.0



