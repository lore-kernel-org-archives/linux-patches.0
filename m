Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892804D5BA;
	Wed, 21 Feb 2024 13:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522485; cv=none; b=Q6PCf5aVp0JMVFmypWVN4ywGIGcZBXg4J1comVHVSYRDJCBSB3uf2ni8A6TzGztZekwQHS2zh/YRkeKXbdscEHVs3fya5WImQB7kA7WUIF7tzm4DfKPJnV/zKAUlOWzZWhoHMikI77cTl3gwYfRLmg/KIzNdbFlAP2uqLA01Des=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522485; c=relaxed/simple;
	bh=FoHFFSIlLMJz5FCSqqz9WWwPiAMYpoI8HGSw9k97TDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0CVrPab82gA65SAen9/O8mwLooj+Su4oWdFDeFRHftu4+3/p6qSXnY7XuHuMiLwcclmQbozU8avEGIggKpnyFNHPHPUXstFj7vY6xxsPFmmHKj5JJeB8Uv6lE7aSLDR3vfrNObC99sjKwaKGUeb86aIo1Z/tgHO0PWip3JH1B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qksXCaGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qksXCaGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC28DC433F1;
	Wed, 21 Feb 2024 13:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522485;
	bh=FoHFFSIlLMJz5FCSqqz9WWwPiAMYpoI8HGSw9k97TDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qksXCaGUwyHCeUGY2Dzn8vAAvDRdY+Lm+Lt9Hm7d7SUEAtxNQ5eou5JXxfImb9NFb
	 Ofi3hAcuHH5zB6FODedYOejyWVIQ9I+NQiPgK5yC/UZSpdMN1M4HhAOK+w6jnvLWl5
	 Ub2C+jWWIp+jATQRzMgwoY4GUkHHvFRpKPowmYrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 174/476] ARM: dts: imx7s: Fix lcdif compatible
Date: Wed, 21 Feb 2024 14:03:45 +0100
Message-ID: <20240221130014.343175265@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/imx7s.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 6cdaaacd9e36..35ee179e5ae3 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -802,7 +802,7 @@
 			};
 
 			lcdif: lcdif@30730000 {
-				compatible = "fsl,imx7d-lcdif", "fsl,imx28-lcdif";
+				compatible = "fsl,imx7d-lcdif", "fsl,imx6sx-lcdif";
 				reg = <0x30730000 0x10000>;
 				interrupts = <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX7D_LCDIF_PIXEL_ROOT_CLK>,
-- 
2.43.0



