Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5F1188006;
	Tue, 30 Jul 2024 16:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355350; cv=none; b=b/7B1nUm6X4OmUSZ6YCCZh4Hx2pCPJdnCctGfQxAX/ZGdGu6DcTZ27ZWzAPRz5vEG6D7nIfVfiGse+U0ReTVqo4ELo9ATzWyrWBG+wVHbyDR3t4tN9IUISSnnATNsEb+U71deLfxFOTEysYjl5dCUAIlazGfvt06A50WI90MhmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355350; c=relaxed/simple;
	bh=5zKTWmcVlTla0EQRS51iX3kUj+tzKqvkI8byEy/wxZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kTIAUqBEncq5nqiiOpb8CVS8xRm6M4d3IYNwnSH35URNz72S5Mgwad6y7u0ttSOT5/lRDemmB3GXNI1fExCe2aVjkGIGxdcCU35TTzy6e2sky3olkveVJwl4FkeR38fclxcrUetL3tKGORh5z78H0y+bV1ZwelYXZJbyx+DhcYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4ECZZzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4ECZZzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEECC4AF0C;
	Tue, 30 Jul 2024 16:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355350;
	bh=5zKTWmcVlTla0EQRS51iX3kUj+tzKqvkI8byEy/wxZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4ECZZzCGtkJ1miAbGVm8wVED1THyKkmzvhdbssaXEjop3jH82ax8nlv4tyqbG+KJ
	 GiBNPDns0GDIT0lkoPNJbKU/rzMnBXqtCPCjTgjA8b1i6tVDzQNHOmfhlvGa4cEFgi
	 Hsy69PwrvBOCXMk8RlNfNnbcOFvYdETmFuQ+LBGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pavel=20L=C3=B6bl?= <pavel@loebl.cz>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/568] ARM: dts: sunxi: remove duplicated entries in makefile
Date: Tue, 30 Jul 2024 17:42:37 +0200
Message-ID: <20240730151641.795642776@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Löbl <pavel@loebl.cz>

[ Upstream commit bba474656dd85b13e4c5d5bdb73ca08d9136df21 ]

During introduction of DTS vendor subdirectories in 724ba6751532, sun8i
section of the makefile got duplicated. Clean that up.

Fixes: 724ba6751532 ("ARM: dts: Move .dts files to vendor sub-directories")
Signed-off-by: Pavel Löbl <pavel@loebl.cz>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/20240320061027.4078852-1-pavel@loebl.cz
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/allwinner/Makefile | 62 ----------------------------
 1 file changed, 62 deletions(-)

diff --git a/arch/arm/boot/dts/allwinner/Makefile b/arch/arm/boot/dts/allwinner/Makefile
index eebb5a0c873ad..296be33ec9346 100644
--- a/arch/arm/boot/dts/allwinner/Makefile
+++ b/arch/arm/boot/dts/allwinner/Makefile
@@ -259,68 +259,6 @@ dtb-$(CONFIG_MACH_SUN8I) += \
 	sun8i-v3s-licheepi-zero.dtb \
 	sun8i-v3s-licheepi-zero-dock.dtb \
 	sun8i-v40-bananapi-m2-berry.dtb
-dtb-$(CONFIG_MACH_SUN8I) += \
-	sun8i-a23-evb.dtb \
-	sun8i-a23-gt90h-v4.dtb \
-	sun8i-a23-inet86dz.dtb \
-	sun8i-a23-ippo-q8h-v5.dtb \
-	sun8i-a23-ippo-q8h-v1.2.dtb \
-	sun8i-a23-polaroid-mid2407pxe03.dtb \
-	sun8i-a23-polaroid-mid2809pxe04.dtb \
-	sun8i-a23-q8-tablet.dtb \
-	sun8i-a33-et-q8-v1.6.dtb \
-	sun8i-a33-ga10h-v1.1.dtb \
-	sun8i-a33-inet-d978-rev2.dtb \
-	sun8i-a33-ippo-q8h-v1.2.dtb \
-	sun8i-a33-olinuxino.dtb \
-	sun8i-a33-q8-tablet.dtb \
-	sun8i-a33-sinlinx-sina33.dtb \
-	sun8i-a83t-allwinner-h8homlet-v2.dtb \
-	sun8i-a83t-bananapi-m3.dtb \
-	sun8i-a83t-cubietruck-plus.dtb \
-	sun8i-a83t-tbs-a711.dtb \
-	sun8i-h2-plus-bananapi-m2-zero.dtb \
-	sun8i-h2-plus-libretech-all-h3-cc.dtb \
-	sun8i-h2-plus-orangepi-r1.dtb \
-	sun8i-h2-plus-orangepi-zero.dtb \
-	sun8i-h3-bananapi-m2-plus.dtb \
-	sun8i-h3-bananapi-m2-plus-v1.2.dtb \
-	sun8i-h3-beelink-x2.dtb \
-	sun8i-h3-libretech-all-h3-cc.dtb \
-	sun8i-h3-mapleboard-mp130.dtb \
-	sun8i-h3-nanopi-duo2.dtb \
-	sun8i-h3-nanopi-m1.dtb\
-	\
-	sun8i-h3-nanopi-m1-plus.dtb \
-	sun8i-h3-nanopi-neo.dtb \
-	sun8i-h3-nanopi-neo-air.dtb \
-	sun8i-h3-nanopi-r1.dtb \
-	sun8i-h3-orangepi-2.dtb \
-	sun8i-h3-orangepi-lite.dtb \
-	sun8i-h3-orangepi-one.dtb \
-	sun8i-h3-orangepi-pc.dtb \
-	sun8i-h3-orangepi-pc-plus.dtb \
-	sun8i-h3-orangepi-plus.dtb \
-	sun8i-h3-orangepi-plus2e.dtb \
-	sun8i-h3-orangepi-zero-plus2.dtb \
-	sun8i-h3-rervision-dvk.dtb \
-	sun8i-h3-zeropi.dtb \
-	sun8i-h3-emlid-neutis-n5h3-devboard.dtb \
-	sun8i-r16-bananapi-m2m.dtb \
-	sun8i-r16-nintendo-nes-classic.dtb \
-	sun8i-r16-nintendo-super-nes-classic.dtb \
-	sun8i-r16-parrot.dtb \
-	sun8i-r40-bananapi-m2-ultra.dtb \
-	sun8i-r40-oka40i-c.dtb \
-	sun8i-s3-elimo-initium.dtb \
-	sun8i-s3-lichee-zero-plus.dtb \
-	sun8i-s3-pinecube.dtb \
-	sun8i-t113s-mangopi-mq-r-t113.dtb \
-	sun8i-t3-cqa3t-bv3.dtb \
-	sun8i-v3-sl631-imx179.dtb \
-	sun8i-v3s-licheepi-zero.dtb \
-	sun8i-v3s-licheepi-zero-dock.dtb \
-	sun8i-v40-bananapi-m2-berry.dtb
 dtb-$(CONFIG_MACH_SUN9I) += \
 	sun9i-a80-optimus.dtb \
 	sun9i-a80-cubieboard4.dtb
-- 
2.43.0



