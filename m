Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B9A332EA7;
	Sat, 30 May 2026 17:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161626; cv=none; b=pNshs1OmLcD3zO75SGDaQWjOHF9q+ApJmUoIr9oclLjDeAUeO3j7qMSGTmeTYPbtNea8KkyhRsakdN0ZJISVIc6B0HI1QHZUzHrqJFHUPeih2id/whR4tSgz7RB2j4080eXVlJkQfL4cBD2ViVdSuB562l4rHAZqd71JONhtOnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161626; c=relaxed/simple;
	bh=8liNpPwTAnFH8sb/9TWpxQYiI9Oe+VrfgitR4mold2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTYVXvqnWj+mU7xL7uzWcSfbq3PKrS4Fsw3lvcTkRQCAqrresv54XK6pEI6hRs23SCkxc1GhmojA4XbPTZJ2l/6nVjwjbtBNW193VpasxhOB3Up+6hdLV76l22oXdRq54scLsXpzxlRfvb6L8eTWzq5PQFy1onJeTgmSDkOnUQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6TuZlj/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6TuZlj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457FD1F00893;
	Sat, 30 May 2026 17:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161624;
	bh=04f9Nkz1OK+nYBI6yeqpsP1d3v6bRRUR9Ma6pdVv5zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i6TuZlj/Ioq48F9F8rS/W+euRgfJyZwCBw+5cNpjklBPKAKhuHf6/3pfxT7Ujz9A5
	 b2IIlTb2hrTDUpXzpjGSrWGYJkMn3Kd9sw+/04brHteRa/a3E3Rrh/fD/Is3bMmTny
	 9FzoWxjC9soq9eut6JogmXqlUEG7iZGs7tvN2tvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 679/969] arm64: dts: imx8mm-tqma8mqml: Correct PAD settings for PMIC_nINT
Date: Sat, 30 May 2026 18:03:23 +0200
Message-ID: <20260530160319.248488873@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 42a9f5a16328ed78a88e0498556965b6c6ec515c ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

Fixes: dfcd1b6f7620e ("arm64: dts: freescale: add initial device tree for TQMa8MQML with i.MX8MM")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi
index f649dfacb4b69..4d79f388ebd26 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi
@@ -280,7 +280,7 @@ pinctrl_i2c1_gpio: i2c1gpiogrp {
 	};
 
 	pinctrl_pmic: pmicgrp {
-		fsl,pins = <MX8MM_IOMUXC_GPIO1_IO08_GPIO1_IO8		0x94>;
+		fsl,pins = <MX8MM_IOMUXC_GPIO1_IO08_GPIO1_IO8		0x1d4>;
 	};
 
 	pinctrl_reg_usdhc2_vmmc: regusdhc2vmmcgrp {
-- 
2.53.0



