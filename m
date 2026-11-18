Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019539;
	b=eC7BfPS1dwXVxavfwxCZmXpLwzGpVskQRjHgHw4rMeG5nSwdxo9aBv0aEC71JVKY+juV
	 u1kZRg5C0jpsDh5SRuUDDim+03AKXTqeDQru+avPRJv5iWeMy9k9ZGGCdbKW9FYDeJM8w
	 eBn1g6v7mYgUcxl6d9boBAQOnqndDan49PSH+Dcxv0qBTFAcewSXtcFBlhrUCh0yJ9dC0
	 2xJRk4TpYWR08QmfM9KT8wXF42VIYx+FK9UAAynmcYDX4GGs7uDr6KFzBl4I2TsY2xaMg
	 qK0/1xpSI8QuRPLsQWHvh+LgAxzYBifBoUt2I8NjiA6+Z7zqPcNHnILSNI0JbCUIE2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=iIjb2NJwYkmLKTMiEK5FQUH8KDMgIHRMTsXwfGVWssg=;
	b=O5RC4jyXkseBI1st3U4ny1LOLq8cPHleZOY2BWmVbEjE9PeMxw6wc1+7O275twn0xKpo
	 21cmqp6y7f0qIzQl1RdAhrR8WKU9qSb8oiqTTY4o0jdE3hopMOvVNzRey9aKtqsWcuMqZ
	 c6aqc09LcRjMvLruOC5flw1QyKy1EMG5oat+lCpSwrdU8lg2P6Z9Vxgn9SJlD5u1Hg0ZP
	 mXzDNgrNZBwABiMES0umneT8ssI4UkkbZiovK401LIXehQNKEV0xV5FcIfJei+t1FYmFU
	 CYxzo+m0Ig7gOqdOb93u/QQapfutgzUK/aPHUJ6NOAsM5vjzj90ZLxOOuuRdg3pMEIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cg9K6lLw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F7B606A7C3;
	Wed, 18 Nov 2026 16:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cg9K6lLw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8184D1F000D2;
	Wed, 18 Nov 2026 16:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019539;
	bh=iIjb2NJwYkmLKTMiEK5FQUH8KDMgIHRMTsXwfGVWssg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cg9K6lLwmC7/bCKWW5rPSv733wyAA+FbhDC62QZfAhPQDaaiEjUI6/gV2XnKeHx/U
	 Ahuil5T4qANqdchsoUiSwCN6z8Pjsu6IgSd/ndlsF3c4ySw0XiPmDLA2sPKaVg7B7b
	 315rRRTU6SfLnedH9ROp+2rFT79szA70xweaSuMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1633/2651] drm/panfrost: Skip cache flush/invalidate when enabling perfcnt
Date: Wed, 18 Nov 2026 15:47:53 +0100
Message-ID: <20261118150346.636528419@linuxfoundation.org>
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

[ Upstream commit 711a34a56d64d235ff74dbe53ba488ecd54e5570 ]

The GPU cache flush/invalidate operation is unnecessary. In the usual case,
before a perfcnt dump is requested, there will be no stale lines in GPU
caches for the sample BO's physmem pages, since their memory had not
recently been addressed by the GPU.

However, in the off-chance that the sample BO reuses memory that the GPU
had recently addressed and for which it contains stale lines in its caches,
there already was a FLUSH_PT command being issued as part of the buffer GPU
mapping procedure, so by the time panfrost_gem_open() comes back at perfcnt
session enable, stale GPU cache lines should've already been evicted.

In either case, forcing a GPU cache clean when enabling a new session makes
no difference, and removing it simplifies handling of the error path.

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20261012-claude-fixes-v15-12-bc0a6c498553@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Stable-dep-of: 9944dd07f3cf ("drm/panfrost: Fix races between perfcnt and reset sequence")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
index f71534e741b65..ffc77121070e2 100644
--- a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
+++ b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
@@ -124,21 +124,10 @@ static int panfrost_perfcnt_enable_locked(struct panfrost_device *pfdev,
 	panfrost_gem_internal_set_label(&bo->base, "Perfcnt sample buffer");
 
 	/*
-	 * Invalidate the cache and clear the counters to start from a fresh
-	 * state.
+	 * Clear the counters to start from a fresh state.
 	 */
-	reinit_completion(&pfdev->perfcnt->dump_comp);
-	gpu_write(pfdev, GPU_INT_CLEAR,
-		  GPU_IRQ_CLEAN_CACHES_COMPLETED |
-		  GPU_IRQ_PERFCNT_SAMPLE_COMPLETED);
+	gpu_write(pfdev, GPU_INT_CLEAR, GPU_IRQ_PERFCNT_SAMPLE_COMPLETED);
 	gpu_write(pfdev, GPU_CMD, GPU_CMD_PERFCNT_CLEAR);
-	gpu_write(pfdev, GPU_CMD, GPU_CMD_CLEAN_INV_CACHES);
-	ret = wait_for_completion_timeout(&pfdev->perfcnt->dump_comp,
-					  msecs_to_jiffies(1000));
-	if (!ret) {
-		ret = -ETIMEDOUT;
-		goto err_vunmap;
-	}
 
 	ret = panfrost_mmu_as_get(pfdev, perfcnt->mapping->mmu);
 	if (ret < 0)
-- 
2.53.0



