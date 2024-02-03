Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC531118B;
	Sat,  3 Feb 2024 04:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933801; cv=none; b=chnABiSo/L9VUL1KMf6jfGIphodaGx4zgq81/oE5KP6G7Gmtp1/qiX9ZuicN/aSkQ70Vg8Ew0ge1WHz2cZqb61rtK+/ZwZo1Bx+ezDs1y8eJpluS+ijaOsXu5b79CtszTQfKjNjopWPPQY9hZtAc52LtFzlYhbko3MUin3Ku6g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933801; c=relaxed/simple;
	bh=WYOkevGUyIivK2l0MoZskS5iFATQJ3v4xoKDjqhiy9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1g4PQnUCVBGkIEpWH/bY3zbEpYfwAxpf7ECbKyxVzXDUKu6/2/1gnUDAIkjPq9vqlh86xA9QBRuK+DOuNCjbQkkJ9Zl8jOlE9MKOXRtx7aP61tLa1lGGjUyF88ZJNe8FsGyZJLQn/tHQA22dtT0xdoRJ2BgG4XJPHZ8CP6b59M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UdQa7OKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UdQa7OKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61E6C433C7;
	Sat,  3 Feb 2024 04:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933800;
	bh=WYOkevGUyIivK2l0MoZskS5iFATQJ3v4xoKDjqhiy9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UdQa7OKY4T9HlPHckwSkYK6UgWWf/TpIAHrQrNSf7dkaptdgMSIh5qa9u1z+yr18w
	 u6nC0zTx2irB1pf0uZTZrGoxgSLKn1sL8T1CEWOYt/vkS0BAPcZBSlx/GwJjXakRQ0
	 UgjUht9LSaNf961+tDr/TCIbSqADsKuK2VEjwz3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 088/353] ARM: dts: imx7s: Fix lcdif compatible
Date: Fri,  2 Feb 2024 20:03:26 -0800
Message-ID: <20240203035406.590590765@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 9f216d11a396..3bd33255266e 100644
--- a/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
@@ -815,7 +815,7 @@
 			};
 
 			lcdif: lcdif@30730000 {
-				compatible = "fsl,imx7d-lcdif", "fsl,imx28-lcdif";
+				compatible = "fsl,imx7d-lcdif", "fsl,imx6sx-lcdif";
 				reg = <0x30730000 0x10000>;
 				interrupts = <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX7D_LCDIF_PIXEL_ROOT_CLK>,
-- 
2.43.0



