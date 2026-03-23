Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FEE26A08F;
	Mon, 23 Mar 2026 14:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277270; cv=none; b=JNeel0AfCdaacja0+B0WH8qnmJVR+aEI0Ohf2opqQAjckeDTSMsnkQmnHnrNIgfzJ75gE5s08rwzC6lWxpfAfnFMiEcTathH4f8Oq1vCY5/SBD8YftUfw4rn0Gj+6oBjB74jU6eag5qfDDS+JUMF4b29Gaa9ZsdtXSN9rsenuMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277270; c=relaxed/simple;
	bh=DadZw4+B722EkGymkEsZ3eHgdLYtEEV5wXChFDZUgeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oV20F0gJU1PhdvdvIrmKX78zUiKOQChssRNolGis552+Ks40849ZFitsgbTfCQYrwlDWsy6bkGO3jzlIAwsO1gGFrKALbgbmjk86d5/o5iJeGc7z2sVvkXVQQZoBrV9Hd92aR6qrFQed6UsQr0l66eZI9sAtBObtEYm3fis5W3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v59LpJh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v59LpJh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72BEC2BCB5;
	Mon, 23 Mar 2026 14:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277270;
	bh=DadZw4+B722EkGymkEsZ3eHgdLYtEEV5wXChFDZUgeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v59LpJh4vIPTEyQjzs98UWS/+DgjgDSRlbmd1y2m0eApXbc6C4eO2Q3z4zqUHI7yO
	 MgwM6CDu0GXCLscSItzZ5Z+OAgBlvBRJNwNqav12px1UR4qCh/dQPJvqYDAnMQoBDo
	 Lwe0IL3BDyk4lJmrPMJAFYW5yd/xkrUplG0S6nTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 376/460] arm64: dts: renesas: r9a09g057: Add RTC node
Date: Mon, 23 Mar 2026 14:46:12 +0100
Message-ID: <20260323134535.806760815@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit cfc733da4e79018f88d8ac5f3a5306abbba8ef89 ]

Add RTC node to Renesas RZ/V2H ("R9A09G057") SoC DTSI.

Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251107210706.45044-4-ovidiu.panait.rb@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: a3f34651de42 ("arm64: dts: renesas: r9a09g057: Remove wdt{0,2,3} nodes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g057.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g057.dtsi b/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
index 1ad5a1b6917fe..4676ee7561395 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
@@ -241,6 +241,21 @@ wdt3: watchdog@13000400 {
 			status = "disabled";
 		};
 
+		rtc: rtc@11c00800 {
+			compatible = "renesas,r9a09g057-rtca3", "renesas,rz-rtca3";
+			reg = <0 0x11c00800 0 0x400>;
+			interrupts = <GIC_SPI 524 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 525 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 526 IRQ_TYPE_EDGE_RISING>;
+			interrupt-names = "alarm", "period", "carry";
+			clocks = <&cpg CPG_MOD 0x53>, <&rtxin_clk>;
+			clock-names = "bus", "counter";
+			power-domains = <&cpg>;
+			resets = <&cpg 0x79>, <&cpg 0x7a>;
+			reset-names = "rtc", "rtest";
+			status = "disabled";
+		};
+
 		scif: serial@11c01400 {
 			compatible = "renesas,scif-r9a09g057";
 			reg = <0 0x11c01400 0 0x400>;
-- 
2.51.0



