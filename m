Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBE12F5A2D;
	Sat, 25 Oct 2025 16:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408783; cv=none; b=Znz/0vHESiNKnhXId1p0JKLfd6xll4Idz3pAyt5OJ0gGPHIq6Axd1sTT1jEtvx+vep8bOCme+ywSt4LmOzHQ6OV/XS3LCmWdreVTNNSiNzDGKJ968p57A2gnItPKf586vzGgTm4cyeviYtN0ip5AwtTMWAuHGU2auMmvVB9zy6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408783; c=relaxed/simple;
	bh=iLJTnyyX2C4zRSWEbIvqNlqLS0GvRfxHjoXGQ+vcNSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MCmupDG7pFAruQiNDhTcdSL5sWvA9fdOTIXdMzDvWcvGcjpLrQWR8/Dvr6SQQAhAhELbZSmHEqM6yfb/lVoxnlDgCHsC5bNlmMZ5EFQaDi42oa+HaVUsHnhNn8d6bpsTu4F7QLxIcIGAOANwqI5iVQYMnXqXXDWHXEktXOGU7CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CIxnKjJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CIxnKjJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0487DC4CEFB;
	Sat, 25 Oct 2025 16:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408783;
	bh=iLJTnyyX2C4zRSWEbIvqNlqLS0GvRfxHjoXGQ+vcNSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIxnKjJRzfAzYqsI64tmos3Vo5QdStHfv7SnVlrGRnfdqAhLLq3Ch42ZEIwj76kh4
	 UbnTUhLTqqKQ5B7IQka7mMp+w+nSXDPNnkoSQGpfgfnaDt08+TKcGNdlJTR7Cn88/E
	 +Dtq9Bz4URo1I1E4rG5X9gIVX3DuNrKatDgQZkA6i7MliYbhYjemWPE+r7rbf8nJV1
	 5sDIu2tDCPz9XVujhZBzlmfLQKmWTgYywmxjplEe7WdLMe1G2ZY6kUjSo5rW1FEDt0
	 WJYyRNlymHcqvJSkcc6WMcv+2ky+3g9ajNsBUkYUcEEc3BxKFOksCuxLV5Rs+AOEgA
	 CBgZuY87xsQtg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Meng Li <li.meng@amd.com>,
	Jiang Liu <gerry@linux.alibaba.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Hawking.Zhang@amd.com,
	asad.kamal@amd.com,
	Likun.Gao@amd.com,
	cesun102@amd.com,
	alexandre.f.demers@gmail.com,
	tvrtko.ursulin@igalia.com,
	andrealmeid@igalia.com,
	christian.koenig@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amd/amdgpu: Release xcp drm memory after unplug
Date: Sat, 25 Oct 2025 11:54:58 -0400
Message-ID: <20251025160905.3857885-67-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Meng Li <li.meng@amd.com>

[ Upstream commit e6c2b0f23221ed43c4cc6f636e9ab7862954d562 ]

Add a new API amdgpu_xcp_drm_dev_free().
After unplug xcp device, need to release xcp drm memory etc.

Co-developed-by: Jiang Liu <gerry@linux.alibaba.com>
Signed-off-by: Jiang Liu <gerry@linux.alibaba.com>
Signed-off-by: Meng Li <li.meng@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Releases per-partition DRM/platform-device resources that remain
    allocated after device unplug, preventing leaks and rebind/reprobe
    issues. In current trees, `amdgpu_xcp_dev_unplug()` only calls
    `drm_dev_unplug()` and restores a few saved pointers, but does not
    free the devres-managed DRM device or its platform device, leaving
    resources alive until module exit. See
    `drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c:367` (loop at lines
    375–385) where xcp partition devices are unplugged without freeing
    them.
  - The new API `amdgpu_xcp_drm_dev_free()` provides a targeted free for
    a single xcp DRM device, enabling correct cleanup on unplug without
    waiting for global teardown.

- Scope of change
  - Adds a small, self-contained API and uses it in the unplug path:
    - `drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c:379` gains
      `amdgpu_xcp_drm_dev_free(p_ddev);` after `drm_dev_unplug()` and
      before returning, so the xcp DRM/platform-device resources are
      actually released.
    - New helper and synchronization in
      `drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.c`:
      - Introduces `static DEFINE_MUTEX(xcp_mutex);` and wraps
        alloc/free/release with `guard(mutex)(&xcp_mutex);` to serialize
        access to the global `xcp_dev[]`/`pdev_num` state (addresses
        races between concurrent alloc/free).
      - `amdgpu_xcp_drm_dev_alloc()` is updated to pick the first free
        slot in `xcp_dev[]` rather than relying solely on a
        monotonically increasing index, preventing exhaustion after
        partial frees and allowing reuse of holes (safe, bounded
        change).
      - Adds `amdgpu_xcp_drm_dev_free(struct drm_device *ddev)` which
        finds and frees the corresponding platform device/devres group
        for a single xcp device and decrements the global count;
        exported for use by `amdgpu_xcp.c`.
      - Refactors release into `free_xcp_dev()` and updates
        `amdgpu_xcp_drv_release()` to free all remaining devices by
        scanning `xcp_dev[]` while `pdev_num != 0`.
    - Header updated to declare the new free API:
      `drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.h`.

- Why it’s a good stable backport
  - User-visible bug: Fixes resource/memory leaks after
    unplug/halt/remove, which can lead to:
    - Stale platform devices (name collisions on reload/hotplug) and
      devres lingering until module exit.
    - Inability to reuse xcp device slots on re-probe, hitting limits
      prematurely (MAX_XCP_PLATFORM_DEVICE = 64).
  - Small and contained: Only touches AMDGPU XCP code paths:
    - `amdgpu_xcp.c` unplug path (drm/amd/amdgpu), and the XCP platform-
      device helper (drm/amd/amdxcp).
    - No UAPI/ABI changes and no cross-subsystem effects.
  - Low regression risk:
    - Alloc/free remain devres-managed and paired with platform device
      unregister, now simply exposed as a per-device free that the
      unplug path can call at the correct time.
    - Locking (`xcp_mutex`) protects `xcp_dev[]`/`pdev_num` against
      races; used only in alloc/free/release, so minimal behavioral
      impact.
    - The unplug flow still calls `drm_dev_unplug()` first, then
      restores the saved pointers before free, maintaining the existing
      detach ordering.
  - Architecture unchanged: No design or feature additions; strictly a
    cleanup and correctness fix.
  - Stable applicability:
    - Affects kernels that already have XCP support (e.g., v6.6+,
      v6.10+, v6.12+). In these, `amdgpu_xcp_dev_unplug()` exists and
      does not free xcp devices.
    - For older stable series without XCP, not applicable.
    - For older XCP revisions (e.g., v6.6), minor context adjustments
      may be needed (device naming and `pdev_num` type), but the core
      addition (new free API + unplug call + mutex-guarded slot
      management) remains straightforward.

- Code references
  - Unplug path without freeing devices:
    drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c:367
  - Existing alloc that creates platform/devres-managed DRM devices:
    drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c:240 and
    drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.c:49
  - Global XCP platform device state:
    drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.c:46–47

Conclusion: This is a targeted bugfix for resource leaks on unplug with
minimal risk and clear user impact in hotplug/reload scenarios. It
should be backported to stable kernels that include AMD XCP support.

 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c     |  1 +
 drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.c | 56 +++++++++++++++++----
 drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.h |  1 +
 3 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
index c417f86892207..699acc1b46b59 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
@@ -406,6 +406,7 @@ void amdgpu_xcp_dev_unplug(struct amdgpu_device *adev)
 		p_ddev->primary->dev = adev->xcp_mgr->xcp[i].pdev;
 		p_ddev->driver =  adev->xcp_mgr->xcp[i].driver;
 		p_ddev->vma_offset_manager = adev->xcp_mgr->xcp[i].vma_offset_manager;
+		amdgpu_xcp_drm_dev_free(p_ddev);
 	}
 }
 
diff --git a/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.c b/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.c
index 8bc36f04b1b71..44009aa8216ed 100644
--- a/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.c
+++ b/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.c
@@ -46,18 +46,29 @@ static const struct drm_driver amdgpu_xcp_driver = {
 
 static int8_t pdev_num;
 static struct xcp_device *xcp_dev[MAX_XCP_PLATFORM_DEVICE];
+static DEFINE_MUTEX(xcp_mutex);
 
 int amdgpu_xcp_drm_dev_alloc(struct drm_device **ddev)
 {
 	struct platform_device *pdev;
 	struct xcp_device *pxcp_dev;
 	char dev_name[20];
-	int ret;
+	int ret, i;
+
+	guard(mutex)(&xcp_mutex);
 
 	if (pdev_num >= MAX_XCP_PLATFORM_DEVICE)
 		return -ENODEV;
 
-	snprintf(dev_name, sizeof(dev_name), "amdgpu_xcp_%d", pdev_num);
+	for (i = 0; i < MAX_XCP_PLATFORM_DEVICE; i++) {
+		if (!xcp_dev[i])
+			break;
+	}
+
+	if (i >= MAX_XCP_PLATFORM_DEVICE)
+		return -ENODEV;
+
+	snprintf(dev_name, sizeof(dev_name), "amdgpu_xcp_%d", i);
 	pdev = platform_device_register_simple(dev_name, -1, NULL, 0);
 	if (IS_ERR(pdev))
 		return PTR_ERR(pdev);
@@ -73,8 +84,8 @@ int amdgpu_xcp_drm_dev_alloc(struct drm_device **ddev)
 		goto out_devres;
 	}
 
-	xcp_dev[pdev_num] = pxcp_dev;
-	xcp_dev[pdev_num]->pdev = pdev;
+	xcp_dev[i] = pxcp_dev;
+	xcp_dev[i]->pdev = pdev;
 	*ddev = &pxcp_dev->drm;
 	pdev_num++;
 
@@ -89,16 +100,43 @@ int amdgpu_xcp_drm_dev_alloc(struct drm_device **ddev)
 }
 EXPORT_SYMBOL(amdgpu_xcp_drm_dev_alloc);
 
-void amdgpu_xcp_drv_release(void)
+static void free_xcp_dev(int8_t index)
 {
-	for (--pdev_num; pdev_num >= 0; --pdev_num) {
-		struct platform_device *pdev = xcp_dev[pdev_num]->pdev;
+	if ((index < MAX_XCP_PLATFORM_DEVICE) && (xcp_dev[index])) {
+		struct platform_device *pdev = xcp_dev[index]->pdev;
 
 		devres_release_group(&pdev->dev, NULL);
 		platform_device_unregister(pdev);
-		xcp_dev[pdev_num] = NULL;
+
+		xcp_dev[index] = NULL;
+		pdev_num--;
+	}
+}
+
+void amdgpu_xcp_drm_dev_free(struct drm_device *ddev)
+{
+	int8_t i;
+
+	guard(mutex)(&xcp_mutex);
+
+	for (i = 0; i < MAX_XCP_PLATFORM_DEVICE; i++) {
+		if ((xcp_dev[i]) && (&xcp_dev[i]->drm == ddev)) {
+			free_xcp_dev(i);
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL(amdgpu_xcp_drm_dev_free);
+
+void amdgpu_xcp_drv_release(void)
+{
+	int8_t i;
+
+	guard(mutex)(&xcp_mutex);
+
+	for (i = 0; pdev_num && i < MAX_XCP_PLATFORM_DEVICE; i++) {
+		free_xcp_dev(i);
 	}
-	pdev_num = 0;
 }
 EXPORT_SYMBOL(amdgpu_xcp_drv_release);
 
diff --git a/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.h b/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.h
index c1c4b679bf95c..580a1602c8e36 100644
--- a/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.h
+++ b/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.h
@@ -25,5 +25,6 @@
 #define _AMDGPU_XCP_DRV_H_
 
 int amdgpu_xcp_drm_dev_alloc(struct drm_device **ddev);
+void amdgpu_xcp_drm_dev_free(struct drm_device *ddev);
 void amdgpu_xcp_drv_release(void);
 #endif /* _AMDGPU_XCP_DRV_H_ */
-- 
2.51.0

