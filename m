Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018823;
	b=arLkAlPGR8DwCtdOUVSHNoTMPA8M2mVTx8OEpQZLrXjvEUChGDRHODyuBr0AMMSGV9vb
	 bVupByWOXaFfLcwsSSmrQYeurcNUdIatCvN3V/N5NF4doBsrld15lj3AKdxxdQYilJJf8
	 BNfskryBGiqv2i16JJK98Dj2o8f/UYjznZGiKTjYS5/e5HS9WmdedPGt2ZTader/tvsPw
	 csicXsvPuK2CeyqK1xnqS/qEidylPHfCAXBk9H7iYX0p8ZM5gWPJvBfGcvNc+QVugey6u
	 KOb8ZgrQp50I38RVfnnASSFmx6CR5+1YseQYrIz3Q7txmaomic+gfTJ6wapMEMxU6zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mHeViPU6fgapEPckIhcQbjcYTFNZq0xRom7OWyA2+o8=;
	b=q78X9tXwXQELNp1w3QMMysow13MYzTvxQp7uYa8P0Dz5ehvwY5xdEeyk2gX+9NOyHoua
	 mAkz33R9mbdcdDVxEdRTGEjcUGZ/pDHlXsJjm+KUr6U2dXcGYTK4GOcqWf4Yw/UBYaaXK
	 LN0P5lefaqhknLzCrowDK7Sxq7va8JgN812Gi1viiv5bT+i2bUtgeP3H5omLtkJ/NDRv0
	 6+7RW7OUggBYTX/vibCvLtCPBxYTZJMaTON4zP8QLzCiA5th/drNaOdd06IH3M6g+jPJ6
	 2Azm3c5wBiwtFCMI8bq4DPy6KcXYrPlL34frqWpon+rtZEtTgSAkQBgnpwHZH3gA3qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i1cfduHZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AAC60A2602;
	Wed, 18 Nov 2026 16:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i1cfduHZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85F51F000C4;
	Wed, 18 Nov 2026 16:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018823;
	bh=mHeViPU6fgapEPckIhcQbjcYTFNZq0xRom7OWyA2+o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i1cfduHZOAB4VZ/3PjcLxRDEctsKYjpkBZIHFOifONh1jbknB52Et3f4U6krXYRCK
	 mdp/iQaQEat1gWV7Z6yGAl6NDhg93cVVOUy1aLU1oqmQwWTm+unAdovpOKkvUQFTjr
	 ZZVjuXTiJ8r0PcdKfMc0Ha6R4/Dj0OcJmg6gEikE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1377/2651] drm/vc4: Drop the undocumented brcm,vc4-v3d compatible
Date: Wed, 18 Nov 2026 15:43:37 +0100
Message-ID: <20261118150337.602654984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit fb825a46e7982460bd620f5e6a71924c647f4280 ]

"brcm,vc4-v3d" is the compatible string V3D support originally shipped
with in commit d3f5168a0810 ("drm/vc4: Bind and initialize the V3D
engine."). Commit 90d7116061f8 ("drm/vc4: Recognize a more specific
compatible string for V3D.") added "brcm,bcm2835-v3d" in v4.6 and kept
the original one around, because the Raspberry Pi firmware was shipping
device trees that used it.

That string was never part of the binding: the documentation added in
commit 4653f22e9ab0 ("dt-bindings: Add binding docs for V3D.") describes
only "brcm,bcm2835-v3d", and no upstream device tree has ever used
"brcm,vc4-v3d": the first in-tree V3D node, from commit 49ac67e0c39c
("ARM: bcm2835: Add VC4 to the device tree."), already carried the
specific name. The firmware device trees the compatible was kept for
predate v4.6, released in 2016.

Drop it from both match tables.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-vc4-reset-control-v2-1-cb3a25b07822@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Stable-dep-of: b0a6b769cc17 ("drm/vc4: Set DRM DMA device directly from HVS and V3D")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.c | 1 -
 drivers/gpu/drm/vc4/vc4_v3d.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index 7b64e1ed02d4c..6930ca20e14b4 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -279,7 +279,6 @@ static const struct of_device_id vc4_dma_range_matches[] = {
 	{ .compatible = "brcm,bcm2835-hvs" },
 	{ .compatible = "brcm,bcm2835-v3d" },
 	{ .compatible = "brcm,cygnus-v3d" },
-	{ .compatible = "brcm,vc4-v3d" },
 	{}
 };
 
diff --git a/drivers/gpu/drm/vc4/vc4_v3d.c b/drivers/gpu/drm/vc4/vc4_v3d.c
index 6844e8f3948cf..d16eecf83fbaa 100644
--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -536,7 +536,6 @@ static void vc4_v3d_dev_remove(struct platform_device *pdev)
 const struct of_device_id vc4_v3d_dt_match[] = {
 	{ .compatible = "brcm,bcm2835-v3d" },
 	{ .compatible = "brcm,cygnus-v3d" },
-	{ .compatible = "brcm,vc4-v3d" },
 	{}
 };
 
-- 
2.53.0



