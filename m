Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBFA248BAA;
	Wed, 15 Jan 2025 11:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938914; cv=none; b=mKHFA5hV32Kmwm3c0SWF3R4Gqu3lf2NAZ31i+8LP9+gxw8UL1OoMIla7pAHw+gs1pF55QO9R5nSTl447O3GLuxbrUsgs4bcGy/UWwnHSidz8T5rFt6aUhJBYRku2I0AAD8CsI4vdUZ99m6p8BJOZZbD0E2s+bX/BQ+L43PzVISI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938914; c=relaxed/simple;
	bh=MI4QaMmNI4FSnP384B5e+IGHO/5RiAiXM6TGmjgDFV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B17ZwMsygX0J4RODTHwFILxhGuF6ttEYS9CkOYBJ2N6C+zCCFhm0zvCxaL1Yq5rkCS1s60C+JjCXo8//JM0gvUYbWVP+bhkh/EigN8BxlDlDLTD6BNLq6/PW1F94cBy8LiZ4AXeaCvmG2098WC7Vi0mZG0F/g6He01eW2aCnlEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNAlQlni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNAlQlni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5243C4CEE4;
	Wed, 15 Jan 2025 11:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938914;
	bh=MI4QaMmNI4FSnP384B5e+IGHO/5RiAiXM6TGmjgDFV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNAlQlnieg81gYxBlByNLdKifJGLzw67eq5YbrXC+MDJzniBhAJZEIuDcmM9Ru9p6
	 /UJFM9cscnyeNIxHm3Fpe2YtDstAYHTuoyqBaPqqdv0YAcnSk+fZoWq2VEtWwKHq2/
	 R/lhUmt4joHmMIo6ZtuueaJGmzFYWWDi/Baupia8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Taube <Mr.Bossman075@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/129] ARM: dts: imxrt1050: Fix clocks for mmc
Date: Wed, 15 Jan 2025 11:38:10 +0100
Message-ID: <20250115103558.933445336@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jesse Taube <Mr.Bossman075@gmail.com>

[ Upstream commit 5f122030061db3e5d2bddd9cf5c583deaa6c54ff ]

One of the usdhc1 controller's clocks should be IMXRT1050_CLK_AHB_PODF not
IMXRT1050_CLK_OSC.

Fixes: 1c4f01be3490 ("ARM: dts: imx: Add i.MXRT1050-EVK support")
Signed-off-by: Jesse Taube <Mr.Bossman075@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imxrt1050.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imxrt1050.dtsi b/arch/arm/boot/dts/nxp/imx/imxrt1050.dtsi
index dd714d235d5f..b0bad0d1ba36 100644
--- a/arch/arm/boot/dts/nxp/imx/imxrt1050.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imxrt1050.dtsi
@@ -87,7 +87,7 @@
 			reg = <0x402c0000 0x4000>;
 			interrupts = <110>;
 			clocks = <&clks IMXRT1050_CLK_IPG_PDOF>,
-				<&clks IMXRT1050_CLK_OSC>,
+				<&clks IMXRT1050_CLK_AHB_PODF>,
 				<&clks IMXRT1050_CLK_USDHC1>;
 			clock-names = "ipg", "ahb", "per";
 			bus-width = <4>;
-- 
2.39.5



