Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341F129AB;
	Wed, 21 Feb 2024 13:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521420; cv=none; b=qgcxIFNGj72QQqYbnSIJQWFKEjwtrE/GBY2db2ckQ5a+qr7SvBZUy5cauhs8aNkPDSx49ICwu2MeA6u/746D5UQcK0P+BlW/C3X0NFXnJUzgPWaWtZ5JQDw/ls1F02x1hSfR0WnlwBhGLprDRxgXW0/4BpWwCIJ+0BMRqnwSALI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521420; c=relaxed/simple;
	bh=/c5tNTlDVPi1vnyB5hCHk4InKxk1oEnEqUO3UMKuhNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0w6W1kspVrMut1mWjwcJxGsJ2ul12Ca1ZbOBvuGMNChTlsS33kY9gngKZbJ0Sg8g3EKB4kmVpd2L3rehMRSIXpdcU/Yg4cu74kZCvRu648yWaukEk8qzxnRv72utVLzwb6700skl474DOGky/Jx9cxTYIhdQ8dE8T/Qbgdfz+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNAgtmoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNAgtmoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2C3C433F1;
	Wed, 21 Feb 2024 13:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521420;
	bh=/c5tNTlDVPi1vnyB5hCHk4InKxk1oEnEqUO3UMKuhNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNAgtmoZe1y6rXRIcFoy0hm8Sy/SGk11cx6/45Jj44zf0Ph4qWggF+0pBsi/zTEGw
	 R/AhRqYN2eLkK+KpKgfW0B6FeFNgQc25LtT8/uvS+/0PJRh8Mt3DBiPMDrBj4VeTCA
	 xaHgfmUZPyfg94EjEWlTLq4/fQl9/YQfuJjzj58w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/202] ARM: dts: imx7s: Fix lcdif compatible
Date: Wed, 21 Feb 2024 14:06:19 +0100
Message-ID: <20240221125934.327845138@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 36c00fe29f4f..ebe954f94e09 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -701,7 +701,7 @@
 			};
 
 			lcdif: lcdif@30730000 {
-				compatible = "fsl,imx7d-lcdif", "fsl,imx28-lcdif";
+				compatible = "fsl,imx7d-lcdif", "fsl,imx6sx-lcdif";
 				reg = <0x30730000 0x10000>;
 				interrupts = <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX7D_LCDIF_PIXEL_ROOT_CLK>,
-- 
2.43.0



