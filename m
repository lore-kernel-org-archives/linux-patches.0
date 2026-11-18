Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037649;
	b=z6s4uJdrVo2PsOQuBrJYmB15GFAKtQbTJimKij6XPyAWK50wrSWF46huEOivTEDaCBon
	 afaGFOzM4mHAsRvp+5Kpib1ShAYxyt+Jn/26YspDJyj5274ToBlxdvlwA4B1v+Z0+SUo+
	 1ueDkCvEyDrCeguafGFMmXQd18xEAnfpJAhG3VZ2JY5wisap1Vhn5NzlyjgvpHsdJR51s
	 ZJf/jtw3IHh2XH6ZtIwq8zkmMA+wuib/EKycl6wvpNvDG8ATNLIPBV9eZMW7wn52e/xmI
	 qZFTT6qNrs9nHBDm8LkhZe4x+22OkMpDp4JPquuii+PWHjrGds8cAtK0/n5MgzVSLEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5qnmsThdEF8ZPPato2tvc4OTlcsZJAyKKVp60n4S7Zs=;
	b=g20rWN+5jovc+c6H9L/q3JYj0hzyoHGqWzLSaswCrkmKlTZ43UjxZD0s0X3g8t4M+mx8
	 WPBgOz79fYL5fyxGnlfK28hwPoSqL4sHXSukIB4jxVkv6FobX7Ql6Zk5IjweJI/pOhyKh
	 dR1u2aFn4fRGb5v5VaaIZ9X3Qc/PLuwKty4E0AJQBGQ/zCx6IGCfP/5hVSv4LXR2KpIQ1
	 iaZ6VdBT6iUgDc0AQwfVIm2/LjM+NaBTrfUcDVO0xJs3SO2+i/kj2u7P52EcpYwlFrtQ5
	 2fKUjBULGjgBwYmNdFg7e+TWd/NO4bGRp5ZQJX8LOi08k7bt2/CHYqXWMLbW8DJ8iWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P77pMlV6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF80606A338;
	Wed, 18 Nov 2026 21:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P77pMlV6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884AA1F000C4;
	Wed, 18 Nov 2026 21:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037649;
	bh=5qnmsThdEF8ZPPato2tvc4OTlcsZJAyKKVp60n4S7Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P77pMlV67RV7Eousl5Gqmfnt56S0Ay7S/l5WRv4HEqhwLtqFgtwB+GDGa1GHSMu9w
	 CsRP16OC3eXkl93mSkAMmU3bBnMQUPO5ISEKtxrCiJew91is3L+IWDoWOSH1bD1pDx
	 qCZKH6bIDZSZQJs0gen/SxPoAU7rWqKg/K2V4X+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evanshenf <archwse@gmail.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1429/3318] drm/loongson: Handle buffer mapping failures when clearing a BO
Date: Wed, 18 Nov 2026 15:34:11 +0100
Message-ID: <20261118150403.609874319@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Evanshenf <archwse@gmail.com>

[ Upstream commit f00d7a241f846b053e89c0bb2285ef5988d4cafc ]

lsdc_bo_clear() ignores the return value from lsdc_bo_kmap() and writes
to lbo->kptr unconditionally. When the first mapping of a newly allocated
buffer fails, kptr is still NULL and the subsequent memset accesses it.

Return the mapping error without touching the buffer and propagate it
from lsdc_gem_object_create(). Install the GEM object functions before
clearing so that drm_gem_object_put() can release the buffer correctly
on failure. Do not add the failed object to the tracking list or return
an uncleared buffer to the caller.

Imported buffers still skip clearing, and successfully mapped buffers
are cleared and unmapped as before.

Tested on LS7A2000 with a one-shot range error in ttm_bo_kmap(). Its
-EINVAL return reached userspace, the object was destroyed once, and
no GEM handle was published. Normal create/map/zero/write/read/close
cycles passed, with the tracked BO count and VRAM usage unchanged.

AI assistance was used for the lifetime analysis, fix, fault-injection
tools, build and test execution.

Fixes: f39db26c5428 ("drm: Add kms driver for loongson display controller")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Evanshenf <archwse@gmail.com>
Reviewed-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Link: https://patch.msgid.link/20261003093415.902f89244043-2-archwse@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/loongson/lsdc_gem.c | 12 ++++++++----
 drivers/gpu/drm/loongson/lsdc_ttm.c | 10 ++++++++--
 drivers/gpu/drm/loongson/lsdc_ttm.h |  2 +-
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/loongson/lsdc_gem.c b/drivers/gpu/drm/loongson/lsdc_gem.c
index 04293df2f0de0..8335dbea6c828 100644
--- a/drivers/gpu/drm/loongson/lsdc_gem.c
+++ b/drivers/gpu/drm/loongson/lsdc_gem.c
@@ -164,14 +164,18 @@ struct drm_gem_object *lsdc_gem_object_create(struct drm_device *ddev,
 		return ERR_PTR(ret);
 	}
 
+	gobj = &lbo->tbo.base;
+	gobj->funcs = &lsdc_gem_object_funcs;
+
 	if (!sg) {
 		/* VRAM is filled with random data */
-		lsdc_bo_clear(lbo);
+		ret = lsdc_bo_clear(lbo);
+		if (ret) {
+			drm_gem_object_put(gobj);
+			return ERR_PTR(ret);
+		}
 	}
 
-	gobj = &lbo->tbo.base;
-	gobj->funcs = &lsdc_gem_object_funcs;
-
 	/* tracking the BOs we created */
 	mutex_lock(&ldev->gem.mutex);
 	list_add_tail(&lbo->list, &ldev->gem.objects);
diff --git a/drivers/gpu/drm/loongson/lsdc_ttm.c b/drivers/gpu/drm/loongson/lsdc_ttm.c
index f0562ff87bb22..ce377ea3d8842 100644
--- a/drivers/gpu/drm/loongson/lsdc_ttm.c
+++ b/drivers/gpu/drm/loongson/lsdc_ttm.c
@@ -393,9 +393,13 @@ void lsdc_bo_kunmap(struct lsdc_bo *lbo)
 	ttm_bo_kunmap(&lbo->kmap);
 }
 
-void lsdc_bo_clear(struct lsdc_bo *lbo)
+int lsdc_bo_clear(struct lsdc_bo *lbo)
 {
-	lsdc_bo_kmap(lbo);
+	int ret;
+
+	ret = lsdc_bo_kmap(lbo);
+	if (ret)
+		return ret;
 
 	if (lbo->is_iomem)
 		memset_io((void __iomem *)lbo->kptr, 0, lbo->size);
@@ -403,6 +407,8 @@ void lsdc_bo_clear(struct lsdc_bo *lbo)
 		memset(lbo->kptr, 0, lbo->size);
 
 	lsdc_bo_kunmap(lbo);
+
+	return 0;
 }
 
 int lsdc_bo_evict_vram(struct drm_device *ddev)
diff --git a/drivers/gpu/drm/loongson/lsdc_ttm.h b/drivers/gpu/drm/loongson/lsdc_ttm.h
index 843e1475064e2..df47d9bb0d035 100644
--- a/drivers/gpu/drm/loongson/lsdc_ttm.h
+++ b/drivers/gpu/drm/loongson/lsdc_ttm.h
@@ -89,7 +89,7 @@ size_t lsdc_bo_size(struct lsdc_bo *lbo);
 
 int lsdc_bo_kmap(struct lsdc_bo *lbo);
 void lsdc_bo_kunmap(struct lsdc_bo *lbo);
-void lsdc_bo_clear(struct lsdc_bo *lbo);
+int lsdc_bo_clear(struct lsdc_bo *lbo);
 
 int lsdc_bo_evict_vram(struct drm_device *ddev);
 
-- 
2.53.0



