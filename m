Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037463;
	b=FYTjkm4SSH1ea2U8jywuSZHn41Tpdmbw7fVtNoEe9VUGnY50ZdeA1fayrot5PHvZ0ZbA
	 ZT3Eleca0BAl2UnPM+FqjwO+Zrp2BXMY7HAhcVFZIZZqOKADkw5ZS+HQz1/WTlBe7hNgf
	 us+8x7A1kngfJIK0dQFfrxHDsgutjAw6ni55vRvsE418VzGxxPLFl9QD1BmFgR8U49NXn
	 dTmwlA6Zq+rJXcIEdYfiiyFgYbptMF6A4afUKR0MD4bQ+4D75OBe3tr+JysCcx5Cwpcah
	 t/aJeogzC1KSo///csl/YoWeRomjMhbKeo1S6Xl0/W+BGm6YHqMbrt2d5UGtNytkijw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xzaL7i9nL/ctIndmjpvmHHO+aJavcjSdsEtuQKceFWs=;
	b=3xBMt9fGvP9dzGWfyi6OUOeRQXzrYBpf3C/LdRrvBrKa2rc6tVNuy79qzIthiYKPUoHO
	 g4h32HKQwvIWFTpWReVequIXOunut5Ac/FenDPEJj86K+y/u3l/2EI5/gIWoOvCDySdXf
	 6BpcIze328cVaHfyGFSkxZqYO6z9apSv5C7zyBu302q7pyrHvbeCAOi91EFOaURgvYkbn
	 l/hK73e4Eatn5K4mIJuvMn6muQRgHDRUvgaIUOFN3LDVUXDw95GQPARjZffRxbMISaPeZ
	 xfMdsTyMIO7bA4A+/YUUtNLn3ileK2hfxmUr7jRsoPahRgcEFF79vbcx3orGUj71Hjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbSn6MQu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F1B606A320;
	Wed, 18 Nov 2026 21:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbSn6MQu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F461F000C4;
	Wed, 18 Nov 2026 21:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037463;
	bh=xzaL7i9nL/ctIndmjpvmHHO+aJavcjSdsEtuQKceFWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZbSn6MQu/o4GCn7fI/rJPB5RKmVG80NMqlFOTvxVMSad71t9vTvQJaYdsG5rWO+xW
	 Ym4P8EA1xE0+yXdfLgSxxS2CIph6elIAxM0FS2lYLizMDhFvEZx27IgWysRzhr3bMx
	 opUNNAKGx1EaJDiohQRoOo93qv2BfA0jv9lhrJvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Philipp Stanner <phasta@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1407/3318] drm/drm_crtc: ensure dma_fence_ops remain valid during device unbind
Date: Wed, 18 Nov 2026 15:33:49 +0100
Message-ID: <20261118150402.848033330@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit 3be436cbd3d265fe4fcfbb5b650edad7b2108443 ]

In [1], sashiko reported the following issue:

=== snip ===
Looking at how these fences are managed, drm_crtc_create_fence()
creates a dma_fence without taking a reference to the drm_device or
drm_crtc. Because the sync_file framework exposes this fence to
userspace, the fence can outlive the CRTC.

The dma_fence contract requires that data accessed by dma_fence_ops
(like get_driver_name) must remain valid for an RCU grace period after
the fence is signaled. However, drm_crtc_cleanup() and the subsequent
freeing of the device do not wait for an RCU grace period via
synchronize_rcu().

If userspace calls ioctl(SYNC_IOC_FILE_INFO) concurrently with a device
hot-unplug:

CPU1 (Userspace)
sync_file_get_name()
  ops = rcu_dereference(fence->ops);
  if (!dma_fence_test_signaled_flag())
    // Preempted or delayed here

CPU2 (Driver Teardown)
Signals the fence (setting fence->ops = NULL)
Destroys and frees the CRTC without waiting for an RCU grace period

CPU1 (Resumes)
  ops->get_driver_name(fence) -> drm_crtc_fence_get_driver_name()
  crtc = fence_to_crtc(fence); // Casts to the freed CRTC
  return crtc->dev->driver->name; // Use-after-free

...

Does the CRTC or DRM device need to be kept alive for the RCU grace
period, or should the fence hold a proper reference to prevent the
use-after-free when get_driver_name() and get_timeline_name() access
the freed CRTC structure?
=== snap ===

I believe this to be a correct observation and this patch implements
the suggestion of waiting for an RCU grace period before proceeding
with destruction of the drm_crtc, so that get_driver_name() and
get_timeline_name() can still work.

Link: https://sashiko.dev/#/patchset/20260618-linux-drm_crtc_fix2-v1-1-c03e77b36f34@linaro.org?part=1
Fixes: 6d6003c4b613 ("drm/fence: add fence timeline to drm_crtc")
Cc: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Reviewed-by: Philipp Stanner <phasta@kernel.org>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20260721-linux-drm_crtc_fix2-v3-1-afa8c71506e6@linaro.org
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_crtc.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 65f9f66933bba..6b210bfd6ac0d 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -489,14 +489,23 @@ EXPORT_SYMBOL(__drmm_crtc_alloc_with_planes);
  * drm_crtc_cleanup - Clean up the core crtc usage
  * @crtc: CRTC to cleanup
  *
- * This function cleans up @crtc and removes it from the DRM mode setting
- * core. Note that the function does *not* free the crtc structure itself,
- * this is the responsibility of the caller.
+ * This function cleans up @crtc and removes it from the DRM mode setting core,
+ * after first waiting an RCU grace period to ensure @crtc->dev can safely be
+ * dereferenced by our dma_fence_ops.
+ *
+ * Note that the function does *not* free the crtc structure itself, this is the
+ * responsibility of the caller.
  */
 void drm_crtc_cleanup(struct drm_crtc *crtc)
 {
 	struct drm_device *dev = crtc->dev;
 
+	/* Ensure our dma_fence_ops remain valid for an RCU grace period after
+	 * the fence is signaled. This is necessary because our dma_fence_ops
+	 * dereference crtc->dev.
+	 */
+	synchronize_rcu();
+
 	/* Note that the crtc_list is considered to be static; should we
 	 * remove the drm_crtc at runtime we would have to decrement all
 	 * the indices on the drm_crtc after us in the crtc_list.
-- 
2.53.0



