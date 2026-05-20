Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4434436405A;
	Wed, 20 May 2026 17:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298939; cv=none; b=lvFQoN6RoicYxyy9GtMMuj16+dOK3+gNEWm54RQMI+3+0Cl78ho+5KdP1DG6nafjXvH/3RnPqQ9heBz+tXw4JIpCQx7aTIQb0c/h9hsFwYtDeeqYsbrQWw9Xf5OXn9PeU3EXBR88XGJRDuwpILeBpVMstBuwbc+4gvqFU9JphJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298939; c=relaxed/simple;
	bh=e2GyM/yCuz8FwQOqPXdbKgEBc/gFn8x56xHGF5YD7Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpF8+oS4ZcMZ8IXNT+BtMGTGl2hifKbe7S6MemZWvnvIcbr98nmnU1nEIGHu69kM8lq0DR2YJNZxIT7St13hLBddvSBsE1oRbwVfD7XWgjl7YIoo+wo72BczaG1tq43M33lCYR+Pt8XmfQSLqwK/4eWrbnTg7NlSU6mPZ0/gRwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZ9brY2M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZ9brY2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD071F000E9;
	Wed, 20 May 2026 17:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298938;
	bh=h3/dBgAt18wCfTtmPUTseFakyBgBAnH9LCTx6IEh/4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZ9brY2MXlAfbZR3mqOzeqLhsAZknEM4HOXt6cNe5kr98IhVL824WBfctYqafTdo9
	 yw/124IpXlofZgdEmRNJb28iObIBgct91h05ySvKvfQrxs36c4XvUqMsCa4mnLdHm5
	 8fAhzBZdhuX/PNT5ZRVvBb2Ud32K8W3gRsVmh0R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 601/957] arm64: dts: imx8mp-edm-g: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:18:04 +0200
Message-ID: <20260520162147.567946320@linuxfoundation.org>
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

[ Upstream commit c46c5a54443440ce0f71de9f4df9dd860f5c2afd ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

Fixes: 95e882c021c8b ("arm64: dts: imx8mp: Add TechNexion EDM-G-IMX8M-PLUS SOM on WB-EDM-G carrier board")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-edm-g.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-edm-g.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-edm-g.dtsi
index 3f1e0837f349f..91b87a7248dd1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-edm-g.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-edm-g.dtsi
@@ -563,7 +563,7 @@ MX8MP_IOMUXC_GPIO1_IO01__GPIO1_IO01	0x41 /* PCIE RST */
 
 	pinctrl_pmic: pmicirqgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03	0x41
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03	0x1c0
 		>;
 	};
 
-- 
2.53.0



