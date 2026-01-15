Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9613BF314;
	Thu, 15 Jan 2026 17:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497080; cv=none; b=T+nnBbRHjAScZ0pWAGKU7C41S5L+h5BpCaKcwaZup0vIQlFr5hvNj1dhoIYf5QXpdFGlR86zce7YVDLRJ1Pz4GAWFucVwn6YYW/vnSVgVSOq6Ix88lRcoTkEmHCJmwwjXUMJA8m8brHBrviv9yxNNRFIb5n/+GkZ51E2a+JsBao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497080; c=relaxed/simple;
	bh=d9HAJGoj9iaWOMawjRsUJOa63a9Q/ISnE31juS06do0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTclxJjff0AUzfNqaIY9GV4LxOrVLSBDBmS3lGXPGPyAUKOVmBu4UEFzNtW9q12nNOpGHZVaOhbU1GzqdvXwpNDaO7k9tho0CT+BVlc82SzD51lhuLShQSpB0faKVGRxwAdznEvqD/UY/uCGc83CbMhQURFIqivR7u2kTJ+tCOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7wbnGj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7wbnGj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A428C19422;
	Thu, 15 Jan 2026 17:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497080;
	bh=d9HAJGoj9iaWOMawjRsUJOa63a9Q/ISnE31juS06do0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7wbnGj4vR7ewGDrkxkcBEPu+HWUUuPZuIu24qMV9GNHzjOH6tQeAk2PPd1xQYNt4
	 jsq69Q/YCc7CxNFaJSMI0tbYYWByaqmaZR+YYMeKHJZLWnENTROrzPK/dbffrRQA6f
	 Y0QMUc8ghfa9sNKKZ2KbKiLijZEqHyIdcnPO2aT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 30/72] arm64: dts: add off-on-delay-us for usdhc2 regulator
Date: Thu, 15 Jan 2026 17:48:40 +0100
Message-ID: <20260115164144.588065369@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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
index 470e4e4aa8c78..059f8c0ab93d9 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -34,6 +34,7 @@ reg_usdhc2_vmmc: usdhc2-vmmc {
 		regulator-max-microvolt = <3000000>;
 		gpio = <&lsio_gpio4 7 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
+		off-on-delay-us = <4800>;
 	};
 };
 
-- 
2.51.0



