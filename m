Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A588F9CE;
	Sat,  3 Feb 2024 04:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933538; cv=none; b=i6EDBF1pggrGc4m6sC63UgCdiVducFPmvzi6Ehc4x7kncmzD7JOooCEg6Vfog4TaLK21BtXXGs1rpLuEr04+NbsOxY7b6Gv6us5Y4yXol6PBrRDNcjs6jtPPvaNBFf1/CmanD1I3CUAdg9731M118Gyb7Y1lpM12s7pIasxKHEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933538; c=relaxed/simple;
	bh=uv3Gix0Z/YS7T6U++yeBJ0ZNyj3us/xFmf16dhmjtuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FE7f3DDUdK/Yx0RRLs63MoEtqMwE+rM10Xs4Rt5dVt1l8JSuinj6tPwkrFtyYk8PHjAcrvhh+NtlVy4akcQCYncO6C+D3zmVxAcOf4//bcRJdm3p6agTO44VuYlSltkE6vqZI+UCGSxC6GSKC6BdCvzvF1XnncBZjiHGZt5NRcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrrVxi5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrrVxi5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B84C433F1;
	Sat,  3 Feb 2024 04:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933537;
	bh=uv3Gix0Z/YS7T6U++yeBJ0ZNyj3us/xFmf16dhmjtuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrrVxi5KMTp5oAY0EUPw/SrNrO/5QPCoC3f+SPEkxSeS4eTP4uRyU5MfCKxEO69gF
	 q0Gzn2w9vOFimkiHtGxCFG5L4NsBXespSoLzRKL5J6RqfbR8jX9mQFeUrglFkf93up
	 GCtCrx3To/Ws1Q2cIeoUmnY8Y6Xl2xtdqMQ1x4PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/322] ARM: dts: imx7s: Fix lcdif compatible
Date: Fri,  2 Feb 2024 20:03:00 -0800
Message-ID: <20240203035401.849423924@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 5f55da4cc37051cda600ea870ce8cf29f1297715 ]

imx7d-lcdif is compatible to imx6sx-lcdif. MXSFB_V6 supports overlay
by using LCDC_AS_CTRL register. This registers used by overlay plane:
* LCDC_AS_CTRL
* LCDC_AS_BUF
* LCDC_AS_NEXT_BUF
are listed in i.MX7D RM as well.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx7s.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx7s.dtsi b/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
index 2e3513b7111e..b6d03794d8d9 100644
--- a/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
@@ -818,7 +818,7 @@
 			};
 
 			lcdif: lcdif@30730000 {
-				compatible = "fsl,imx7d-lcdif", "fsl,imx28-lcdif";
+				compatible = "fsl,imx7d-lcdif", "fsl,imx6sx-lcdif";
 				reg = <0x30730000 0x10000>;
 				interrupts = <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX7D_LCDIF_PIXEL_ROOT_CLK>,
-- 
2.43.0



