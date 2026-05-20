Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E7D28DC4;
	Wed, 20 May 2026 17:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298944; cv=none; b=bG5Q+YxFh9q2lPpmYucUiTvQ0kQmyROhLWGd3NzI6fRmYgld5Yo1Yd3WBJnbDLLW1ak5eFJc7Um5reSZpoqnTNFelgKV3XCP34fm8QE7yedxqqetfwZL031G1tHLb6RmgWV6PhbRrupM8upl4oqAdoAylvP6zkSpo6W+sBLTAYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298944; c=relaxed/simple;
	bh=aTRSL7337HFqREK1p3s0HnL/joKU0MNI0iW8amINwTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kL9vLRFD3oAxunSYVp5hlmnO69EIeZ+rXLeP0P9gDfy4lBYfEVUIzLnnJfcjmZmfPvSwREb7LS4B3MaF0kb0cSlTEFNSsLpSQ9oqjewbM9zgsbYRZf/FvJiiaHoopKDQHWI9f7bz0N682WKeOkE7WHP17vGSH0ex2cSfXnh6Uls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tje42umW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tje42umW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E807B1F000E9;
	Wed, 20 May 2026 17:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298943;
	bh=ZBAof2mAs5ogskCI1UF9YKpS7KVagzinEN5iLI1Ps8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tje42umWR9FOKoEuXuCZ1vT9y+1W21PaHJ7qOEDTJ5vYLXz9ItFiXiCHGMluOjoI+
	 QnfafFX+XLp+kJ0ShiGc1OmshwKV8LCe9TJeusRelF40K7f2enW59ocPjCAX+byjCa
	 pPZzHcwLGFKw5zBFzWpZi6dN6Cg0nc3i0BBD1ocQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 602/957] arm64: dts: imx8mp-aristainetos3a-som-v1: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:18:05 +0200
Message-ID: <20260520162147.589273521@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit e6d2d8e49ca34bb39126a69128794d08ffd7c83e ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

Fixes: eead8f3536d5c ("arm64: dts: imx8mp: add aristainetos3 board support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-aristainetos3a-som-v1.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-aristainetos3a-som-v1.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-aristainetos3a-som-v1.dtsi
index f654d866e58c0..e7666e54310be 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-aristainetos3a-som-v1.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-aristainetos3a-som-v1.dtsi
@@ -903,7 +903,7 @@ MX8MP_IOMUXC_SAI1_MCLK__GPIO4_IO20	0x41
 
 	pinctrl_pmic: aristainetos3-pmic-grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03	0x41
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03	0x1c0
 		>;
 	};
 
-- 
2.53.0



