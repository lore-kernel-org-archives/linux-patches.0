Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD163F44CB;
	Wed, 20 May 2026 16:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296348; cv=none; b=JRCyeequtliHYgMFYX+X8zZ9Gm4zvhOY4qLRb9kyPdXFfUSOAcQypW81S4+P1dbaMdPssuPEWWq2MNbtUsxUrnChjroHETDWJHwA+vZh4Q/5UMhr4klnFkygNPHPd3+lmb6sy6eTSw24RwYjDsbpmG2tM90kZxQuGHcW9Xl4Vbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296348; c=relaxed/simple;
	bh=tdtP0ZWACuM22dfA/nMJMWal9ahKZmnFTP+V/JmgXRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6QzkxWOT3ev/U710Az9VQ8Xvvf1wwArziOAcQ1C6TGw751d3Wc5SzjtHmEvb59ADTqMu9F3eKnecIyHnHMMCb51f4ncDBjbLokDx0361AcjIxL0Sw6DTQaIT1iwmwhNCpXx7+nSJeuMnh5qN+LkrAlVhfxqOL8JIkDAOyVZaGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0VahoFb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0VahoFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2A11F000E9;
	Wed, 20 May 2026 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296347;
	bh=roQxsAwWfRky7iZq73WnoMN/R1ngubUSwtyefFhqVe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0VahoFbtLAUp6F282ZpnCrbhKbv3zxmJemFg9mo+jp+OsOef80JdRjvIbVkiA/eh
	 RQ28tSxvX+5JvjA8lmjEaoc8CNAUjJCYrh1DMjCd+XC/69G3MU/M4nuXPvPKzV4jMJ
	 8wivaJGo31EaNvLbENUuXY7PMHiAEOoD+TqZZLFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0764/1146] arm64: dts: imx8mn-tqma8mqnl: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:16:54 +0200
Message-ID: <20260520162205.501381357@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 0fb37990774113afd943eaa91323679388584b6d ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

Fixes: 3e56e354db6d3 ("arm64: dts: freescale: add initial device tree for TQMa8MQNL with i.MX8MN")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi
index 31a3ca137e636..48a687926aa1b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi
@@ -283,7 +283,7 @@ pinctrl_i2c1_gpio: i2c1gpiogrp {
 	};
 
 	pinctrl_pmic: pmicgrp {
-		fsl,pins = <MX8MN_IOMUXC_GPIO1_IO08_GPIO1_IO8	0x84>;
+		fsl,pins = <MX8MN_IOMUXC_GPIO1_IO08_GPIO1_IO8	0x1c4>;
 	};
 
 	pinctrl_reg_usdhc2_vmmc: regusdhc2vmmcgrp {
-- 
2.53.0



