Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019525;
	b=T1b9GKLwrMnMUDEdwnWdw9qsyY26h3eFW9fH/MOhCNugkFRZJQ/KlVpxRhPMdPEUEeiI
	 zoVqWXNPYCDQBQLEwjBOhCz4yXsXKYekNHsG/j7qPAKZt0UQNvv/HTzO7RG8V/t9EJJcp
	 FLyDhs2OYvcz0LqBaNFBX4f9BZ0u7IG/UcXMXpWg+MrvdqjTjehBKizVSDasCFTpqBWdn
	 8Ma9mu6HK8nQF4m7izfWGVDNCdif1R21Xq1Ml8w6Hf0k+hKsfkLumNXOcgfcAsIUhJxWp
	 3tjUnhi70WaOXAdDzzG8w94wrEPUDFrBA1du2VMrdcTZtxLLoHLftnn1EtFBUIEnPZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Zenhv4OMd4bcodAaUEBI8z42jU8ay18KXatnIeV+TyE=;
	b=borThcVc/OyF5xINKZNjPmwr4InGKGf6ZhrpOvbHAFi1ncgMjDau6q2YPYogh7/h/4Zl
	 HUvkHEUWrUeVA15tm3oCAaL5Pa2vISLi5/ozfVmSbswWKhSdXg6Y8b2FlGvh9vedXdj7/
	 0/7FhgZGiW84cgh5Zrer0vtP48isJveuB0A99jxJrUhMQuu0nNJlU5mmWY/4OKyxDPkey
	 ftbaAx6/xCL8vnFFqbO5nBtC06KK4VdnvHmDFuAruDXXEA8ER9pl9DzssfPgrXAdMdJHb
	 IxTLjR8hnhohQueZuRmXzJlKmZqlImilVt/dJ08pZMa/hZIM3BuQgLg+CC9E/EcOeJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jl2W3E7l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5163606A32A;
	Wed, 18 Nov 2026 16:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jl2W3E7l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D4C1F000C5;
	Wed, 18 Nov 2026 16:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019525;
	bh=Zenhv4OMd4bcodAaUEBI8z42jU8ay18KXatnIeV+TyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jl2W3E7lybs3+O3obNnj7rWm3ok4kDt8+PgosHqqpc0y6I1OwHZ3oRGxEe5FAohIK
	 gZ4dNVCXumA68B3gF4diWQLTsy2hF8agXJxnbIuEH/hczbTpRMpEQ9V2xsOUeoJ9Iu
	 9Q7kiKIg0t0/QCzM1E4wFHxQ75zJUaRAuLfN4khM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1628/2651] drm/panfrost: Move shrinker initialization and unplug one level down
Date: Wed, 18 Nov 2026 15:47:48 +0100
Message-ID: <20261118150346.467967192@linuxfoundation.org>
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

[ Upstream commit 80c4ff19d938a170bf487a11a1d7291c493ba22a ]

Since the moment we call drm_dev_register() the device should be in a
position to accept jobs, so it's best if the shrinker is already
initialized by then.

On top of that, make shrinker functions take an panfrost_device pointer
like other functions in the same sequence and rename them accordingly.

Essentially mimic the init/fini behaviour in Panthor.

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20261012-claude-fixes-v15-1-bc0a6c498553@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Stable-dep-of: e9672bf9382f ("drm/panfrost: Fix PM refcnt and autosuspend issues at device probe/remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_device.c    |  8 +++++-
 drivers/gpu/drm/panfrost/panfrost_drv.c       |  6 -----
 drivers/gpu/drm/panfrost/panfrost_gem.c       | 26 +++++++++++--------
 drivers/gpu/drm/panfrost/panfrost_gem.h       |  7 ++---
 .../gpu/drm/panfrost/panfrost_gem_shrinker.c  |  8 ++----
 5 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_device.c b/drivers/gpu/drm/panfrost/panfrost_device.c
index d0a23c51be39d..a5db571678da5 100644
--- a/drivers/gpu/drm/panfrost/panfrost_device.c
+++ b/drivers/gpu/drm/panfrost/panfrost_device.c
@@ -281,9 +281,14 @@ int panfrost_device_init(struct panfrost_device *pfdev)
 	if (err)
 		goto out_job;
 
-	panfrost_gem_init(pfdev);
+	err = panfrost_gem_init(pfdev);
+	if (err)
+		goto out_perfcnt;
 
 	return 0;
+
+out_perfcnt:
+	panfrost_perfcnt_fini(pfdev);
 out_job:
 	panfrost_jm_fini(pfdev);
 out_mmu:
@@ -305,6 +310,7 @@ int panfrost_device_init(struct panfrost_device *pfdev)
 
 void panfrost_device_fini(struct panfrost_device *pfdev)
 {
+	panfrost_gem_fini(pfdev);
 	panfrost_perfcnt_fini(pfdev);
 	panfrost_jm_fini(pfdev);
 	panfrost_mmu_fini(pfdev);
diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 70c05210ea846..130ec763343bb 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -1003,14 +1003,9 @@ static int panfrost_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto err_out1;
 
-	err = panfrost_gem_shrinker_init(&pfdev->base);
-	if (err)
-		goto err_out2;
 
 	return 0;
 
-err_out2:
-	drm_dev_unregister(&pfdev->base);
 err_out1:
 	pm_runtime_disable(pfdev->base.dev);
 	panfrost_device_fini(pfdev);
@@ -1024,7 +1019,6 @@ static void panfrost_remove(struct platform_device *pdev)
 	struct panfrost_device *pfdev = platform_get_drvdata(pdev);
 
 	drm_dev_unregister(&pfdev->base);
-	panfrost_gem_shrinker_cleanup(&pfdev->base);
 
 	pm_runtime_get_sync(pfdev->base.dev);
 	pm_runtime_disable(pfdev->base.dev);
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 3a7fce4288987..f39c0f50ed4ff 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -15,20 +15,24 @@
 #include "panfrost_gem.h"
 #include "panfrost_mmu.h"
 
-void panfrost_gem_init(struct panfrost_device *pfdev)
+int panfrost_gem_init(struct panfrost_device *pfdev)
 {
-	int err;
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && panfrost_transparent_hugepage) {
+		int err = drm_gem_huge_mnt_create(&pfdev->base, "within_size");
+
+		if (drm_gem_get_huge_mnt(&pfdev->base))
+			drm_info(&pfdev->base, "Using Transparent Hugepage\n");
+		else if (err)
+			drm_warn(&pfdev->base, "Can't use Transparent Hugepage (%d)\n",
+				 err);
+	}
 
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    !panfrost_transparent_hugepage)
-		return;
+	return panfrost_gem_shrinker_init(pfdev);
+}
 
-	err = drm_gem_huge_mnt_create(&pfdev->base, "within_size");
-	if (drm_gem_get_huge_mnt(&pfdev->base))
-		drm_info(&pfdev->base, "Using Transparent Hugepage\n");
-	else if (err)
-		drm_warn(&pfdev->base, "Can't use Transparent Hugepage (%d)\n",
-			 err);
+void panfrost_gem_fini(struct panfrost_device *pfdev)
+{
+	panfrost_gem_shrinker_fini(pfdev);
 }
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h b/drivers/gpu/drm/panfrost/panfrost_gem.h
index 79d4377019e9e..5c823cdbd9806 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.h
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
@@ -129,7 +129,8 @@ drm_mm_node_to_panfrost_mapping(struct drm_mm_node *node)
 	return container_of(node, struct panfrost_gem_mapping, mmnode);
 }
 
-void panfrost_gem_init(struct panfrost_device *pfdev);
+int panfrost_gem_init(struct panfrost_device *pfdev);
+void panfrost_gem_fini(struct panfrost_device *pfdev);
 
 struct drm_gem_object *panfrost_gem_create_object(struct drm_device *dev, size_t size);
 
@@ -154,8 +155,8 @@ panfrost_gem_mapping_get(struct panfrost_gem_object *bo,
 void panfrost_gem_mapping_put(struct panfrost_gem_mapping *mapping);
 void panfrost_gem_teardown_mappings_locked(struct panfrost_gem_object *bo);
 
-int panfrost_gem_shrinker_init(struct drm_device *dev);
-void panfrost_gem_shrinker_cleanup(struct drm_device *dev);
+int panfrost_gem_shrinker_init(struct panfrost_device *pfdev);
+void panfrost_gem_shrinker_fini(struct panfrost_device *pfdev);
 
 void panfrost_gem_set_label(struct drm_gem_object *obj, const char *label);
 int panfrost_gem_sync(struct drm_gem_object *obj, u32 type,
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
index 2fe967a90bcb0..fefae87535d6f 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
@@ -95,10 +95,8 @@ panfrost_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
  *
  * This function registers and sets up the panfrost shrinker.
  */
-int panfrost_gem_shrinker_init(struct drm_device *dev)
+int panfrost_gem_shrinker_init(struct panfrost_device *pfdev)
 {
-	struct panfrost_device *pfdev = to_panfrost_device(dev);
-
 	pfdev->shrinker = shrinker_alloc(0, "drm-panfrost");
 	if (!pfdev->shrinker)
 		return -ENOMEM;
@@ -118,10 +116,8 @@ int panfrost_gem_shrinker_init(struct drm_device *dev)
  *
  * This function unregisters the panfrost shrinker.
  */
-void panfrost_gem_shrinker_cleanup(struct drm_device *dev)
+void panfrost_gem_shrinker_fini(struct panfrost_device *pfdev)
 {
-	struct panfrost_device *pfdev = to_panfrost_device(dev);
-
 	if (pfdev->shrinker)
 		shrinker_free(pfdev->shrinker);
 }
-- 
2.53.0



