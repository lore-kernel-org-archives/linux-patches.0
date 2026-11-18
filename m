Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019536;
	b=GdFWGlgstKrHEB3JO75yyondMSZ9XLfLqBkUMmXKyLroLancVVw7jFevNopxM3M8JeK+
	 Q2WLchoTGmRLuNn5Xm9l0xCaurnb4lka1ulYz5uTfjoAD6YNQ2aGnL0gYcDuPL/e3gjnk
	 XjqQUFPLRCbdttEGjQlpkJlJXfm4/qBbMTPF006kj1rPqqncav91uBhJLemRWsKWE/GD5
	 PLptLlSF5tLKa4ur0MOUtvTv67fn0V09WT8hh8OsmZ1ZgK11W/Lih9PQPIRmEjwX7G8P1
	 Y8mWg+j5zbAqP1GNuU5X3X9qLbpn0VFBfHeFUPC3VvSQ9Y/Y0uAtVk/p7YinC0gEEVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DCoQCjYPpFzIvP0t3dYYfSojZ1yjiBLUfHw6TQhKCss=;
	b=FBFNSLB+sQR1MYGnPFQbzIkGT2f2N3PcQ/LjDHpPNCqpHXw68V+Fp6B09UA06PpVxYQi
	 P7fy9WejKdLFa29zDZE96auGwTmTX8nOBNCimg/d5Nb8ZQ/dI+xFn5cDc/aj3EG5u6CdZ
	 qye6rKs6avQRr/fQehZN66epgRu2Ms8ta3ncjJt60pW5s+4BW3sRiobIbigxqOwigqmOX
	 iSqxgCN8XKZQ6hlOKu7XQ8t0CXRA9uiKkScTLadXX6CIWerCn84wI4gYQbagiC5G1n1Kw
	 OiYcGWtSoqWHeG6deFaakqNV9MFef1EDbTjEzjaT5XfEly+RRc6oNqVDJPUh+6cducQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sbKV1Fn8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79959606A330;
	Wed, 18 Nov 2026 16:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sbKV1Fn8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF15E1F000C6;
	Wed, 18 Nov 2026 16:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019536;
	bh=DCoQCjYPpFzIvP0t3dYYfSojZ1yjiBLUfHw6TQhKCss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sbKV1Fn8to3CDkHGnxydMVAfk4eqnOAzBMvd+uJHkXt064EdPgeBJy71UHtENHoeA
	 RsTHAwsnbRBWCh4RY56f25xbLygQxEt/Z7Sprra6nUeuU65CZ+cG6Lyrsiqk3ALEJo
	 +HUpP8EtQkPAcSPuchL62vURJ8jhziaVlm7vsTYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1632/2651] drm/panfrost: Move perfcnt GPU disable sequence into a helper
Date: Wed, 18 Nov 2026 15:47:52 +0100
Message-ID: <20261118150346.605597059@linuxfoundation.org>
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

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit a2858e0f33eaba1c4a1976ba0ddebb1d83e21545 ]

Just for the sake of avoiding repetition.

Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20261012-claude-fixes-v15-11-bc0a6c498553@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Stable-dep-of: 9944dd07f3cf ("drm/panfrost: Fix races between perfcnt and reset sequence")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c | 31 +++++++++------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
index 7020c0192e189..f71534e741b65 100644
--- a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
+++ b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
@@ -35,6 +35,16 @@ struct panfrost_perfcnt {
 	struct completion dump_comp;
 };
 
+static void panfrost_perfcnt_hw_disable(struct panfrost_device *pfdev)
+{
+	gpu_write(pfdev, GPU_PERFCNT_CFG,
+		  GPU_PERFCNT_CFG_MODE(GPU_PERFCNT_CFG_MODE_OFF));
+	gpu_write(pfdev, GPU_PRFCNT_JM_EN, 0x0);
+	gpu_write(pfdev, GPU_PRFCNT_SHADER_EN, 0x0);
+	gpu_write(pfdev, GPU_PRFCNT_MMU_L2_EN, 0x0);
+	gpu_write(pfdev, GPU_PRFCNT_TILER_EN, 0);
+}
+
 void panfrost_perfcnt_clean_cache_done(struct panfrost_device *pfdev)
 {
 	complete(&pfdev->perfcnt->dump_comp);
@@ -193,12 +203,7 @@ static int panfrost_perfcnt_disable_locked(struct panfrost_device *pfdev,
 	if (user != perfcnt->user)
 		return -EINVAL;
 
-	gpu_write(pfdev, GPU_PRFCNT_JM_EN, 0x0);
-	gpu_write(pfdev, GPU_PRFCNT_SHADER_EN, 0x0);
-	gpu_write(pfdev, GPU_PRFCNT_MMU_L2_EN, 0x0);
-	gpu_write(pfdev, GPU_PRFCNT_TILER_EN, 0);
-	gpu_write(pfdev, GPU_PERFCNT_CFG,
-		  GPU_PERFCNT_CFG_MODE(GPU_PERFCNT_CFG_MODE_OFF));
+	panfrost_perfcnt_hw_disable(pfdev);
 
 	perfcnt->user = NULL;
 	drm_gem_vunmap(&perfcnt->mapping->obj->base.base, &map);
@@ -327,12 +332,7 @@ int panfrost_perfcnt_init(struct panfrost_device *pfdev)
 	perfcnt->bosize = size;
 
 	/* Start with everything disabled. */
-	gpu_write(pfdev, GPU_PERFCNT_CFG,
-		  GPU_PERFCNT_CFG_MODE(GPU_PERFCNT_CFG_MODE_OFF));
-	gpu_write(pfdev, GPU_PRFCNT_JM_EN, 0);
-	gpu_write(pfdev, GPU_PRFCNT_SHADER_EN, 0);
-	gpu_write(pfdev, GPU_PRFCNT_MMU_L2_EN, 0);
-	gpu_write(pfdev, GPU_PRFCNT_TILER_EN, 0);
+	panfrost_perfcnt_hw_disable(pfdev);
 
 	init_completion(&perfcnt->dump_comp);
 	mutex_init(&perfcnt->lock);
@@ -344,10 +344,5 @@ int panfrost_perfcnt_init(struct panfrost_device *pfdev)
 void panfrost_perfcnt_fini(struct panfrost_device *pfdev)
 {
 	/* Disable everything before leaving. */
-	gpu_write(pfdev, GPU_PERFCNT_CFG,
-		  GPU_PERFCNT_CFG_MODE(GPU_PERFCNT_CFG_MODE_OFF));
-	gpu_write(pfdev, GPU_PRFCNT_JM_EN, 0);
-	gpu_write(pfdev, GPU_PRFCNT_SHADER_EN, 0);
-	gpu_write(pfdev, GPU_PRFCNT_MMU_L2_EN, 0);
-	gpu_write(pfdev, GPU_PRFCNT_TILER_EN, 0);
+	panfrost_perfcnt_hw_disable(pfdev);
 }
-- 
2.53.0



