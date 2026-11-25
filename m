Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619004;
	b=xZ0VHBdqNe1PnJwh8cufywAnOmrf76ORtJPdMwzacRsJAwyVoHdW2QeLlRaB8CxC1vPl
	 EieMXHhlG23Z0faQ9SmCpA+6kB2ryPppTR0iEbJZDs+ZqcqpJnzJInuPmAeR6SeKE19fo
	 VYbnnXUJlit0tVF4hKVrVE7R3F0Gg613/muPDgdAYBB/AJrMbM5CMrf4sxgFhtgWtrYE8
	 w3UQ0ovn+Aw7nvovpsrwMNoXuMCmAvMfo8PRsp4CeeNyIzNpOmEuK9yzCiRPWycKn/uEm
	 2LwiMQfL9O/tuxD8N/RDRXMjJpCFf4EThpVI85myvPMdyj644w7ObBKr+V7ihN6gGHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=icdt3bJfH5PlXAfZ3LQh2xFciHi+zSGGkt56RPjVJBQ=;
	b=YGwJbKqrY60uTTSF+0wqH6DHsR5DntoJtIjyhWWRAYp8jev12X18Vg4rpJP4+PENWyBX
	 JyltxfQ3B8IbkmrkDOYU+mCFper0FWDINuffRLfHyXbJHZl4hHnaaZlD7obF/l+6L37Cv
	 54tw8U/NV+HaCCmuZLypNB37A8T1ntvmImgXnrHhfVMTIFLA/LonozxSFyPrmKUNNz06Q
	 eMVVI4riCWbHqqmCQqPOb0SiDaVyqeRPiSkTfwcDIHwMO1w39AES044Y3g+KXiS0tacAT
	 qrgzcVvuJjMhVPfq20X6Gjk9/WkmPxAbV/7SlqhWXlJn0h4l1HvcLJBECptgIwzID3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="j/BN+gti";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884B8606A31E;
	Wed, 25 Nov 2026 15:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j/BN+gti
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD23E1F01566;
	Wed, 25 Nov 2026 15:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619004;
	bh=icdt3bJfH5PlXAfZ3LQh2xFciHi+zSGGkt56RPjVJBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/BN+gtithgpwwuSse5YhQyPBrwfMyZ8NkXQt0X5WIvW3qESnsyxFuEQLsfVVRZxA
	 C3ixAA1m5o55+NRJz1ZfJEJE3CsP8JYFzzHlc+eoW5IlV1Y1QUGjTYMq6qg1hn4Xsb
	 6McBJ6BdRGjaeVDqWJ0OQKB/YBA92jVUgWreVLpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0413/1005] drm/panfrost: Enable cycle counting when perfcnt is enabled
Date: Wed, 25 Nov 2026 15:29:11 +0100
Message-ID: <20261125143831.427889444@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 99a2e2b1690f48b074bf14a3b7d5d52f45d26ecc ]

If we don't do that, we end up with invalid timestamps in the block
headers.

We also need to skip the warning on the cycle counter reference being
other than 0 during device reset, because of perfcnt's lingering ref.

Ideally this would be dealt with by splitting the reset sequence into
pre and post stages, so that a hypothetical panfrost_perfcnt_pre_reset()
would release the cycle counter reference. In the absence thereof, we
just make do.

Fixes: 7786fd108777 ("drm/panfrost: Expose performance counters through unstable ioctls")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20261104-panfrost-reset-races-fixes-v3-1-09868a88c351@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_gpu.c     | 7 +++----
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c | 3 +++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gpu.c b/drivers/gpu/drm/panfrost/panfrost_gpu.c
index 8a15ccce08e9b..5ef6897fc05ed 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -94,11 +94,10 @@ int panfrost_gpu_soft_reset(struct panfrost_device *pfdev)
 		  GPU_IRQ_CLEAN_CACHES_COMPLETED);
 
 	/*
-	 * All in-flight jobs should have released their cycle
-	 * counter references upon reset, but let us make sure
+	 * Even though all in-flight jobs should have released their cycle counter
+	 * references upon reset, perfcnt's might still hang about.
 	 */
-	if (drm_WARN_ON(&pfdev->base, atomic_read(&pfdev->cycle_counter.use_count) != 0))
-		atomic_set(&pfdev->cycle_counter.use_count, 0);
+	atomic_set(&pfdev->cycle_counter.use_count, 0);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
index 03a6dcd8da2f5..46b5141932ee8 100644
--- a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
+++ b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
@@ -17,6 +17,7 @@
 #include "panfrost_device.h"
 #include "panfrost_features.h"
 #include "panfrost_gem.h"
+#include "panfrost_gpu.h"
 #include "panfrost_issues.h"
 #include "panfrost_job.h"
 #include "panfrost_mmu.h"
@@ -52,6 +53,7 @@ static void panfrost_perfcnt_hw_disable(struct panfrost_device *pfdev)
 	gpu_write(pfdev, GPU_PRFCNT_TILER_EN, 0);
 
 	if (perfcnt->owns_as_ref) {
+		panfrost_cycle_counter_put(pfdev);
 		panfrost_mmu_as_put(pfdev, perfcnt->mapping->mmu);
 		perfcnt->owns_as_ref = false;
 	}
@@ -81,6 +83,7 @@ static int panfrost_perfcnt_hw_enable(struct panfrost_device *pfdev)
 		return ret;
 
 	perfcnt->owns_as_ref = true;
+	panfrost_cycle_counter_get(pfdev);
 
 	as = ret;
 	cfg = GPU_PERFCNT_CFG_AS(as) |
-- 
2.53.0



