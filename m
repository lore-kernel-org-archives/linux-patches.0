Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025779;
	b=cbej7V65xc8HJLZTXNeCjUzoZN0HKPXniCzp1cvFPgzH5nsi41wQSO/uWJa2W+/wgwj9
	 5a8WV2L6OSLREEyQkHTdW9853TtVM+L2IJoFqaSntTdoSaPlHm7iTLhVykSBcTGabmbNN
	 E3w2PxPe59OBbzLFMnXHDBP3Rhi1pG0peS/2B+7fYhILtM1p5UE6mhKvjyG5tKdf1ocAk
	 S+WdiL/yLjq/wWgmFJo9m6HWKPlF0kkOtjYXHU5Bg/WGE0swMpqWWLy4HAR3B5OGGaedk
	 uO7OcC5LOWdD3hZfbya4o9VhrLYwAsqfJVgzj7SY3OmZ4sLOQEm3q4HIy2tpY3Bc8rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ewwO43AfANBHu6GJd4h4Tu9IGt53HvFp+0Zl0AtE9ds=;
	b=CGi5rypSgzfBL9ml3yqB73hNCtSEQfJfTkTn1Eyy3mkwmvLySFwflebctbruDDZp/KhF
	 FbiOm5btFbuI0mwc4Bm/qv0SS4pzbFUtz8slklZmY7GhL9JRdzMe8PVyZpTaJKFCYeRyH
	 R21XBYZHjTiLrUNVFLpFTcXDTs8CZc3wAeNF00V36Zll60EZNPs051MN/OaYReUbHbtZ9
	 5VtWlNkO3G+z/+15x36WTbK2HlRztK3IQkIaaU/POrk1prQEzkvLr5m5qkX3LSbAMV6v+
	 INKdZtTToK/oU/zMcCa5u8p7Pa4WjSr4PUVkJEGJ3vccXmK23dyA8zhgmlZ0YzzU5nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rRzuxqY9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FC6606A320;
	Wed, 18 Nov 2026 18:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rRzuxqY9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70751F000C4;
	Wed, 18 Nov 2026 18:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025779;
	bh=ewwO43AfANBHu6GJd4h4Tu9IGt53HvFp+0Zl0AtE9ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rRzuxqY9MXTqMfhDkZgOPNom5h2rXwjS1Qca/mf2Xw6FaZqQjfl7R1MJF9RxD5neS
	 B4jtgLbtW2nqCMqLhlJwClSZxhwr335v1K1sR4z0y1g0EnCu3Wzs7uC/J0p5gjGzCw
	 IpDlu2ayT0nT9wsHVe/edmzH7S3xPGEzdLrDNnq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1158/2151] drm/vc4: Drop the undocumented brcm,vc4-v3d compatible
Date: Wed, 18 Nov 2026 15:48:13 +0100
Message-ID: <20261118150204.355097302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 298e6cf3be54d..2e730ab4c3e61 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -280,7 +280,6 @@ static const struct of_device_id vc4_dma_range_matches[] = {
 	{ .compatible = "brcm,bcm2835-hvs" },
 	{ .compatible = "brcm,bcm2835-v3d" },
 	{ .compatible = "brcm,cygnus-v3d" },
-	{ .compatible = "brcm,vc4-v3d" },
 	{}
 };
 
diff --git a/drivers/gpu/drm/vc4/vc4_v3d.c b/drivers/gpu/drm/vc4/vc4_v3d.c
index 03589596b7fd9..ef28908668fae 100644
--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -533,7 +533,6 @@ static void vc4_v3d_dev_remove(struct platform_device *pdev)
 const struct of_device_id vc4_v3d_dt_match[] = {
 	{ .compatible = "brcm,bcm2835-v3d" },
 	{ .compatible = "brcm,cygnus-v3d" },
-	{ .compatible = "brcm,vc4-v3d" },
 	{}
 };
 
-- 
2.53.0



