Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213745;
	b=KTEMAa5H0+hSgfMX4cxwzxTqvQrMVZfBC5i7oYsHG3oi+TVT0MoZ5lwJvIbFPlWYtCkb
	 Yzh7YU77ZsNALYs+A83HgyV/UlznslrBrDXC+ssOl9OM+UDRzP+zXjMuqgQTrbnKV5UAP
	 Zf8sDvEacwoIgfUvDZFrMn8psVG1nABH7ZRCJwLA3195UVAvfEEipjr7ObX2JtjG3WJhe
	 ICEBMvKfieumnjtyV/Guum2aXf0A1fB2Hua1bn1tGV32XDX89GjWosMosDUjmn2RZPiPk
	 IOChIa5iqW+URpdhtUAJewD26/XXujTSPjUKuv1c48tXMzzg4wy44VfnGwIaNWr5nYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GXrbkmUGe4epBBaiJ8Sm8CUdOm2gnsixZmkyZBULiNQ=;
	b=sgYaymi+ryGjUaa2g+Gmvemfpo0Dtn3zD9jSUKMoaqbHbaKf3jtvnDOq7KieYW3r7RJm
	 lZ8xuip1UtjLtYBuESRjdasnQ9Mp5ApLGH/D0i3Kay933vgLIp3tvqUEL5/rJp6Y0ME5E
	 P+y1rm0PvlzaL5kldr4dPcdaF6zX4/h3Pa5tJ26dUINlSMPiNDew/SSajlF8OR0dKkEbe
	 Rejfxa5dI9Hb1Bm+voTY0Ad1UbaOV5CVDs6NpT/KlmTU9JSLIsQYky64BuLHVFLvP2iai
	 owC4jzES8gGAjdlMzOgqv64YgG9nh13hx16YRflJiZbyUYCdzz0oWi/Abr5T7OXlmgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrS8JbWj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D157606A31C;
	Wed, 28 Oct 2026 18:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrS8JbWj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8D41F01825;
	Wed, 28 Oct 2026 18:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213744;
	bh=GXrbkmUGe4epBBaiJ8Sm8CUdOm2gnsixZmkyZBULiNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UrS8JbWjGAocSjv9tsvzstVlxyLguvL6+T4lNGxa+o/U5JhClzJ1iOc9u9eiRH+ma
	 FUu7Nmm9hOZUb25TozmF+NByXWY6zvrgRD7su9zCT/sQLUv6Vtla+Vo0+DxzsXWFdf
	 vnpa3V7nqhdmiggSMaVKgWebZ3OEeNcoqZ+OUKeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0613/1887] drm/panfrost: Fix the error path in panfrost_mmu_map_fault_addr()
Date: Wed, 28 Oct 2026 17:45:09 +0100
Message-ID: <20261028170513.361907472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 1fc9af813b25e146d3607669247d0f970f5a87c3 ]

Subject: [PATCH 6.1 0613/1887] [PATCH] drm/panfrost: Fix the error path in
 panfrost_mmu_map_fault_addr()

If some the pages or sgt allocation failed, we shouldn't release the
pages ref we got earlier, otherwise we will end up with unbalanced
get/put_pages() calls. We should instead leave everything in place
and let the BO release function deal with extra cleanup when the object
is destroyed, or let the fault handler try again next time it's called.

Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
Cc: <stable@vger.kernel.org>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Co-developed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240105184624.508603-18-dmitry.osipenko@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index e961fa27702ce..5aa6d94e95c98 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -500,12 +500,19 @@ static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
 	mapping_set_unevictable(mapping);
 
 	for (i = page_offset; i < page_offset + NUM_FAULT_PAGES; i++) {
+		/* Can happen if the last fault only partially filled this
+		 * section of the pages array before failing. In that case
+		 * we skip already filled pages.
+		 */
+		if (pages[i])
+			continue;
+
 		pages[i] = shmem_read_mapping_page(mapping, i);
 		if (IS_ERR(pages[i])) {
 			mutex_unlock(&bo->base.pages_lock);
 			ret = PTR_ERR(pages[i]);
 			pages[i] = NULL;
-			goto err_pages;
+			goto err_bo;
 		}
 	}
 
@@ -515,7 +522,7 @@ static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
 	ret = sg_alloc_table_from_pages(sgt, pages + page_offset,
 					NUM_FAULT_PAGES, 0, SZ_2M, GFP_KERNEL);
 	if (ret)
-		goto err_pages;
+		goto err_bo;
 
 	ret = dma_map_sgtable(pfdev->dev, sgt, DMA_BIDIRECTIONAL, 0);
 	if (ret)
@@ -535,8 +542,6 @@ static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
 
 err_map:
 	sg_free_table(sgt);
-err_pages:
-	drm_gem_shmem_put_pages(&bo->base);
 err_bo:
 	panfrost_gem_mapping_put(bomapping);
 	return ret;
-- 
2.53.0



