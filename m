Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5493835201E;
	Wed, 20 May 2026 16:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295630; cv=none; b=d0o6aqAF85difvYoBh5WxSb1IR9bbhVyKad/9I1sLWwklb8PykdXrUqscQ9EBn0dFYgh3oMZlc2Ji7zBCCi3VNjtQzFLnf+LN/L8rwiHUk3DZs1qUcyrCGK9MeUFVff22YgPXJILhUN3+OwCR6tNl3tDYqBEhaBYjeZ7RUrT2DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295630; c=relaxed/simple;
	bh=Wp8GNfgcXHRoZlOSKK+ctiONjKrPg7Le9LukSeZZUQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plwjN0AFlAZSBMdmFym9WhfG+y/U3PdjQRnTuUnggAzku4Yp6KdGkP+T3zxrQEzCM6UuC9F0DU7q7F2ycnKMVasM3bcL3Hr2AHlqxh7Cjnx4ZYckwbWpce6kUi2LQdzNh8yhuf/9mMydlYZ1/gyFVM1Eat07FwCsSc+1dFEqfdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJA1Eoz4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJA1Eoz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2761F000E9;
	Wed, 20 May 2026 16:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295629;
	bh=vuBpIy6x3yffySYpumiuIcBm3jA1ieLSRasYk/3mNNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TJA1Eoz4F5v6bNqxIek/6SDw83NOaJrVBT4ChDXf0U4uJcwqNLqtmg05tiyzvOqEk
	 RyS96QbJj58aVeUU+L60jT4xf6yyM2rxKZaShL0pKS0CDS5XAhpCpt8EbcrS3/G7Zu
	 MnrgoAzIghNoQ/84cjsdgmF1GzS1+5gXkRM1D4k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	William Zhang <william.zhang@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0492/1146] ARM: dts: BCM5301X: Drop extra NAND controller compatible
Date: Wed, 20 May 2026 18:12:22 +0200
Message-ID: <20260520162159.326082700@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit f699e0aa7a1382f52fb6f3e8e26754e7aaad6db6 ]

Fix the dtbs_check warning introduced when the brcm,brcmnand fallback
compatible got removed for iProc machines.

Fixes: 4db35366d6dc ("dt-bindings: mtd: brcm,brcmnand: Drop "brcm,brcmnand" compatible for iProc")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Acked-by: William Zhang <william.zhang@broadcom.com>
Link: https://lore.kernel.org/r/20260204091530.624230-1-miquel.raynal@bootlin.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm-ns.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm-ns.dtsi b/arch/arm/boot/dts/broadcom/bcm-ns.dtsi
index d0d5f7e52a917..46b650abdb904 100644
--- a/arch/arm/boot/dts/broadcom/bcm-ns.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm-ns.dtsi
@@ -479,7 +479,7 @@ thermal: thermal@2c0 {
 	};
 
 	nand_controller: nand-controller@18028000 {
-		compatible = "brcm,nand-iproc", "brcm,brcmnand-v6.1", "brcm,brcmnand";
+		compatible = "brcm,nand-iproc", "brcm,brcmnand-v6.1";
 		reg = <0x18028000 0x600>, <0x1811a408 0x600>, <0x18028f00 0x20>;
 		reg-names = "nand", "iproc-idm", "iproc-ext";
 		interrupts = <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.53.0



