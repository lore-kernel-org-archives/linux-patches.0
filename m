Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8DB3B8BB1;
	Thu, 15 Jan 2026 16:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496106; cv=none; b=JXwyG0J96A1B8iU/EKBPMGyiGfBG4tDTcdLlzDDEAsa2lxmnQlDE6qQgrKBsBnZoI2EK5Ono6p6khtfLryyVs6B0KFhakQARFIT5+2p8QDdcPxnRd3FAS+iVuZVaxcTVyOYadgUBF0sfTpgYU2p4dwOmEKVtYLg90i7Wq2olS/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496106; c=relaxed/simple;
	bh=OzP31hw7LJk71aOsoKSsnO7O5fwECcTEJyNjt7TTRDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8Ug0nZNFpJkHPJakqb3GzxXMDuZpaAX3XSOMVtoCTP08iYAIg/q1O2DetC280bBl2Og9gqJPKsXHYEjHRREUVjhqWOvsLqLorG5x90hxGBIPSLWgZcFfzs/TL3I4p9UCVRqXNTcKClyepVt05bmZl1LV19Q4j3xVkz8subJwYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hLE7u5C3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hLE7u5C3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D664C116D0;
	Thu, 15 Jan 2026 16:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496105;
	bh=OzP31hw7LJk71aOsoKSsnO7O5fwECcTEJyNjt7TTRDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hLE7u5C3n7fJcTR707ZJFOA7TZkn+aOQQYXl8truw2Bub8GshKX/Itr3nnzynmqDH
	 maRfcYcOKU2i45EovgVzPfyPdYt/v0X26esqrUipYJgwmUpZ/ekzH581e3lPDO3WVs
	 4Bsiv6V69yWuR9t537EjGsbJiLJXk5q3tACJ2oMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 080/181] arm64: dts: add off-on-delay-us for usdhc2 regulator
Date: Thu, 15 Jan 2026 17:46:57 +0100
Message-ID: <20260115164205.216120968@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d4b13cfd87a92..df99fe88cf4ac 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -256,6 +256,7 @@ reg_usdhc2_vmmc: usdhc2-vmmc {
 		regulator-max-microvolt = <3000000>;
 		gpio = <&lsio_gpio4 7 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
+		off-on-delay-us = <4800>;
 	};
 
 	reg_audio: regulator-audio {
-- 
2.51.0



