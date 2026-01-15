Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D6233993;
	Thu, 15 Jan 2026 17:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496935; cv=none; b=TVL5mrEHFOvAyTnhpu9Tcez5oMQ/NYzMkFSWiuwUz3xXBUG4PZuqlt6dQvHwKgfZFDbmjp+VKey3wpnGxXgRTdw5FJknajCjwQaNjAXaUm8krCnlIbd4M6Yd1LQzB6IcQL1ihXjpcf/RLekqypXMaeKHWA9ZZ8qvyiY7klyqiA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496935; c=relaxed/simple;
	bh=lNimzLaDxXOuwmgymGYlf6ghFdLJr8tBENTZA60owk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbWzs6yAapQ2a/NUxPpWA0MGNhZgUeZApjZhtSiFpqXq84yCroRDn49AwT7OJPoK+EQNpUlw9ACcPjNLF+hp2Q2FJKp7U3ovRvzBTF+CtPEBLnHTmcBhcTtVAQhuWSrIQvHRtUr+aWJ+IialEr1H42treKwH5VPj28KxISJqLN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNM8tj9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNM8tj9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F98C116D0;
	Thu, 15 Jan 2026 17:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496935;
	bh=lNimzLaDxXOuwmgymGYlf6ghFdLJr8tBENTZA60owk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNM8tj9cnmsGGf8wVr+EqjzbsbQjfpXNWvFcRaLKcYS4/T/Ak5iqz3ch/hfb/Da0G
	 dFN+Kc/M6aOPa/t+oPg+f9/bhBlRLzmY2Z5XonA9ADwg193OpcCmXmWait0h43qx8W
	 zHx+NrjfDI3sXv+Shr8mMOWa0fOi0n0qpeF1QUB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 40/88] arm64: dts: add off-on-delay-us for usdhc2 regulator
Date: Thu, 15 Jan 2026 17:48:23 +0100
Message-ID: <20260115164147.761592640@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a9ab87699f3d5..d22cec32b7cee 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -38,6 +38,7 @@ reg_usdhc2_vmmc: usdhc2-vmmc {
 		regulator-max-microvolt = <3000000>;
 		gpio = <&lsio_gpio4 7 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
+		off-on-delay-us = <4800>;
 	};
 };
 
-- 
2.51.0



