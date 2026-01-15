Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418922C028F;
	Thu, 15 Jan 2026 17:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496555; cv=none; b=VRLGkUPHsM6at+fC3TWd0oNtp9dyU7IGC9EevbirF5KoVEJXKwzOOlzJWIv1lfjth+SJXgFHOiI25Bn52gLAjAQFQ534azDZG0xCN4lAY/4jpHUfjNG7EbdkhA31GoUae4fO2V0aePzZf+KT/+dhxyGzLGxNOufNC2iza9S5bqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496555; c=relaxed/simple;
	bh=kR9v+BOmDx3t586/nyfZtf2z+D3A7DYkW9hkeZHbqwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYmug1nt9LRPmWu0xvLecU1GYk6J2ZTNKehR4wYMmivpiXDWREcOr4A+lnG5TPsQ9vWQClo2QVFlKxD7rZEIWo3hqnvAW3oahBw/lLQAUgk4Qi+zid8+56Tam2FOGL7i1mLXjXD42qp9DCpKsRPpQNlq3GS8SYI7ruRNXb6eHAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9EBhntG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9EBhntG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5096C16AAE;
	Thu, 15 Jan 2026 17:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496555;
	bh=kR9v+BOmDx3t586/nyfZtf2z+D3A7DYkW9hkeZHbqwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9EBhntGOlM5KVwyia4PvKnP0mrp5/1VgKoZch80DveyZ0OFsfWdH5JqpR3hNkStS
	 SWcq0nNfcrtz6hqyd6J9/AmMegkfaF44fAJruh0V+RfLPXOr4y53rfiqXiWQ3AZRFz
	 n2+wOTCr3dsOyHyIS4faFl5BlfNt5kSySOht4O8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/119] arm64: dts: add off-on-delay-us for usdhc2 regulator
Date: Thu, 15 Jan 2026 17:47:48 +0100
Message-ID: <20260115164153.872723255@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit ca643894a37a25713029b36cfe7d1bae515cac08 ]

For SD card, according to the spec requirement, for sd card power reset
operation, it need sd card supply voltage to be lower than 0.5v and keep
over 1ms, otherwise, next time power back the sd card supply voltage to
3.3v, sd card can't support SD3.0 mode again.

To match such requirement on imx8qm-mek board, add 4.8ms delay between
sd power off and power on.

Fixes: 307fd14d4b14 ("arm64: dts: imx: add imx8qm mek support")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
index 9d031f6334965..19c8d7ce1d409 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -132,6 +132,7 @@ reg_usdhc2_vmmc: usdhc2-vmmc {
 		regulator-max-microvolt = <3000000>;
 		gpio = <&lsio_gpio4 7 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
+		off-on-delay-us = <4800>;
 	};
 
 	reg_fec2_supply: regulator-fec2-nvcc {
-- 
2.51.0



