Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4457578B5E;
	Wed, 21 Feb 2024 14:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525236; cv=none; b=Ws4ZIRVRqDU6d5PJZCaoaVUQ6tT0oK+zZ6/n4Dxkw3w4/yRRwwzgfUpDgP4I4Rnbtmsv2thDaeG7Nyq6OIRjLlWSEue+HfLjygTBeImev9okssz2yt98AYTytanxd9MHfdISqy/zgnqCn5F4KAnAPuDli7cXnUDzqj1k8142VCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525236; c=relaxed/simple;
	bh=l2YH2k3mnVICt+lMbM9UsQEbDQ0JSXlt1IjohPPPgcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m15UOU5DdQSLNbKWVJD09rzKf5mR/GtpXAoew+ioWnSHHLsLvNT/p0K6ozWjSzXG5UUvl2MzCVhK85fMTpV6KBhpCWQyEvYEegDuiYRoCnG9E3c6QGSyJ3S3Q4njvS1sdSFQpKJwjcqC/jaIjEpfuErO78i6WgHND7IkzB1k50U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgoNr7+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgoNr7+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF4FC433C7;
	Wed, 21 Feb 2024 14:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525235;
	bh=l2YH2k3mnVICt+lMbM9UsQEbDQ0JSXlt1IjohPPPgcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgoNr7+K3Mm45FVj7Catjpwg7zLEO47UJ7RAbtFJYWBBPHTjHW9HKZV5kcbc/SPAh
	 lokgfQla0OkigdaSdEtFTQOWXN3GFUoNwkqMZKCQ83H8dU5jMjJR/avczSyuPGohsj
	 9ADUwdIsw917IQaTgPWYmgs4GR8uvPmMjJZ2sZEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/267] ARM: dts: imx7s: Fix lcdif compatible
Date: Wed, 21 Feb 2024 14:07:19 +0100
Message-ID: <20240221125943.023945423@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 33e9c210fd2f..a7ed880b12fc 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -769,7 +769,7 @@
 			};
 
 			lcdif: lcdif@30730000 {
-				compatible = "fsl,imx7d-lcdif", "fsl,imx28-lcdif";
+				compatible = "fsl,imx7d-lcdif", "fsl,imx6sx-lcdif";
 				reg = <0x30730000 0x10000>;
 				interrupts = <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX7D_LCDIF_PIXEL_ROOT_CLK>,
-- 
2.43.0



