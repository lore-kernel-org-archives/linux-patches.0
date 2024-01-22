Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434E14BAA4;
	Tue, 23 Jan 2024 00:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970724; cv=none; b=ITCWKhrS1V29B2xXHbqJyK6TTnHf05E2E6C2Kitt83ZSyjrl0NYRTdq9fnERD9/DYmnCNlkMIo3arJeOGuz+1Y87TvCC9rWOFBEmySoc2zC2DD5mW/T9KvoHN4bdTtk2og5M78i63zNG60+2i0BjAiMOTCa+RefKN1ZKmRrdGEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970724; c=relaxed/simple;
	bh=MoDMa0Zlrq58ZLq6tcvOnC8Lhc8E66GOW1nTWEGdo4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBjpFJJwI86obMO/chrcyKnmNGWJ+UeKcLylJM4fhhmxXTikqWusNVAKU6tE4RIzAnCxkDY2A2DB4HNL65/FJ/ZcauCk47O2j6cRevbNR4pcYNGiIH0o8gr7lgiNxrG8n8lgZeFSfwbtAqqZX88xZXRMfreqSr9DYo9o+QgwjHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yr5Mozjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yr5Mozjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038A7C433C7;
	Tue, 23 Jan 2024 00:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970724;
	bh=MoDMa0Zlrq58ZLq6tcvOnC8Lhc8E66GOW1nTWEGdo4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yr5MozjoGJZroB8Pb6VaYVaSMz07OicEI5VyTyhrfj9IHIZRujk2X6n1nKVgc6S/S
	 yUX4kHXHQkSRa5m40uuig7dV+YXjHbLisutbQX130qIgeTDg9LPR3P7bY233aPJP3v
	 ilCpPJS/diTuaTpYddPL55aNoAutNJzStiW/axXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/417] arm64: dts: qcom: sm8150: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:54:17 -0800
Message-ID: <20240122235754.780058152@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c586378fc6bc..c3c12b0cd416 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3940,7 +3940,7 @@ watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sm8150", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		timer@17c20000 {
-- 
2.43.0



