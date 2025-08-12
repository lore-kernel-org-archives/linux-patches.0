Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D4D284B3A;
	Tue, 12 Aug 2025 18:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023490; cv=none; b=aUrLlDJSHcAeGIVkBqRkx0QrWFpAptkrjYcvYDqZalm5Zh2CfuMc1aKmL1WrGpF9T0W1sAMtVUQus4x5nXBWn5nS+9qDst52JGS2ccjltFVjIEOc+jOFQ0p5ByOhr2yRlqGKbybJGfE797Tr9ziDXJg4PMbExGXNmPAO1peC+EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023490; c=relaxed/simple;
	bh=lKfHec4W9BMNcUb6Yy2XVNwnpvnPOYkjyMi+GAFmVYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pclDl/Ex5P9eOJnYC+fSwhU0qcIuwZjOnJOM3NuGEliiluSOz+fgkDUAArvAwWohVewzjEKmaR53S2359QXdjKRGMc3pXQy+UNd/k8WJb5W35EPKKLbPtAIkjq7hC+INbg7HP6CoU2V/f6hMyVmmSobUBc9HyOALTua5zchhu4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJyupcq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJyupcq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BB8C4CEF6;
	Tue, 12 Aug 2025 18:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023490;
	bh=lKfHec4W9BMNcUb6Yy2XVNwnpvnPOYkjyMi+GAFmVYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJyupcq3edIKpq351rnsTiYG6ewtQ+BN/+f5OZrn5fXizva+qoFa5FcdFfNlmDzTJ
	 ZQo9DbnJbBIiDT46d26K67ySGRnMhJDt6RjE3aipII8bx4x+8rOvunuSEfV1VrF1J5
	 FTlu4ch0NrggfYL28JbEFNHRndXJVDaGovAdf7d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 094/627] arm64: dts: ti: k3-am62p-verdin: fix PWM_3_DSI GPIO direction
Date: Tue, 12 Aug 2025 19:26:29 +0200
Message-ID: <20250812173422.885736442@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parth Pancholi <parth.pancholi@toradex.com>

[ Upstream commit b1a8daa7cf2650637f6cca6aaf014bee89672120 ]

PWM_3_DSI is used as the HDMI Hot-Plug Detect (HPD) GPIO for the Verdin
DSI-to-HDMI adapter. After the commit 33bab9d84e52 ("arm64: dts: ti:
k3-am62p: fix pinctrl settings"), the pin was incorrectly set as output
without RXACTIVE, breaking HPD detection and display functionality.
The issue was previously hidden and worked by chance before the mentioned
pinctrl fix.

Fix the pinmux configuration to correctly set PWM_3_DSI GPIO as an input.

Fixes: 87f95ea316ac ("arm64: dts: ti: Add Toradex Verdin AM62P")
Signed-off-by: Parth Pancholi <parth.pancholi@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20250703084534.1649594-1-parth105105@gmail.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi b/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi
index 85c001aef7e3..24b233de2bf4 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi
@@ -426,7 +426,7 @@ AM62PX_IOPAD(0x00f4, PIN_INPUT, 7) /* (Y20) VOUT0_DATA15.GPIO0_60 */ /* WIFI_SPI
 	/* Verdin PWM_3_DSI as GPIO */
 	pinctrl_pwm3_dsi_gpio: main-gpio1-16-default-pins {
 		pinctrl-single,pins = <
-			AM62PX_IOPAD(0x01b8, PIN_OUTPUT, 7) /* (E20) SPI0_CS1.GPIO1_16 */ /* SODIMM 19 */
+			AM62PX_IOPAD(0x01b8, PIN_INPUT, 7) /* (E20) SPI0_CS1.GPIO1_16 */ /* SODIMM 19 */
 		>;
 	};
 
-- 
2.39.5



