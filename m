Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EE8408030;
	Wed, 20 May 2026 18:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302644; cv=none; b=kT/sOmsgQIHxqRd1Z819CfRDfW8Trq/+XdTfOntWG7jJjjGbiYlLOYlIvARsYSgTwm9OfRzlezeXON4jdnRJzgP2NI9y0TqYrWbRGklan7fgvzc/TiEwLoGwH0x9WIgNNMzPmNJtJr03eWJz8M3fz4I8ZVOY+C3brZn1E06iR/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302644; c=relaxed/simple;
	bh=XbM8T+SKJdbaaNntI+CRiVv5Mb3EaYexS6TBsA1h924=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4rtIhA3KdSkm/VtEwEb+F+KX1oZU+5lXoztaAAFEFfKt++w00dkMCozdg7xOfWB96hQfpDSWIIbT3Qr3UtZLp2itct3WVvznYMW73ORlcgIKpI6ZYq8xdFsJzRXxmGJeJRakKf3a1sb+Un0zRJVGeaAIdUr0WFTQP9+a8Mh/pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fo9aFShi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fo9aFShi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1661F000E9;
	Wed, 20 May 2026 18:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302643;
	bh=+JNmnnUHEYXFdaN7hNascC5fVT4wDmiSERkTlb9yDHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fo9aFShiAuW/yEYIzLaGeqbEloN9gGlGEhSJp+gf9fvvMTMzRercWHMoy3luqroy+
	 JisQpzbc8C9p9939xROtoCLKDu3GbuTAMQSIiJ1vX141SUXRBcJYt/21mhOhrMg/mA
	 7QmWLcecuuqFI6SzXLKtFgx78xFh6NXnGWFKFky0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 304/508] arm64: dts: imx8mp-icore-mx8mp: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:22:07 +0200
Message-ID: <20260520162105.228302417@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit ea8c90f5c7ceeb6657a8fe564aa7b190dce298a6 ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

Fixes: eefe06b295087 ("arm64: dts: imx8mp: Add Engicam i.Core MX8M Plus SoM")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-icore-mx8mp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-icore-mx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-icore-mx8mp.dtsi
index a6319824ea2eb..69558ffefa9a6 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-icore-mx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-icore-mx8mp.dtsi
@@ -132,7 +132,7 @@ MX8MP_IOMUXC_I2C1_SDA__I2C1_SDA		0x400001c3
 
 	pinctrl_pmic: pmicgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_NAND_CE0_B__GPIO3_IO01	  0x41
+			MX8MP_IOMUXC_NAND_CE0_B__GPIO3_IO01	0x1c0
 		>;
 	};
 
-- 
2.53.0



