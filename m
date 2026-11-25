Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618760;
	b=aujrUVdYOqGTZBep8nfK0eCNlcnkXrYEnPO9xrXuEvEJHU3Pc48bYXxyrNmGltII9Yu/
	 0afyzDxeo6r9AVxXen8SCB8R0XJdYENFtlUH+I6ZgHJvxIBsU9xnENCg1PUCZ12qUx2DU
	 bEUy20+WVhq0fVXwfuMpqE6B5ehgKNMgGhyapZsruIdGNna6rse3Ebgb0BE+Rn2pisyPM
	 PlLrZIGuvM0DV9vUXUwRM1zNdecMwZuaPhrhTUkVzWp43ZzLJp1qJn84ea71cXeL4p27K
	 5L0JCsz5qW0fUKvvUtsrUQ6byxpgj/vrE7DALHPSuKEYaqGZiK2mnS8A1udVOOmnTBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1PoM5tI3zBPKwvPxWIJDJRv6i378/VOanZoQn6tt8H8=;
	b=DsLhkj9nlhDSBFo9D50hADdi4bZmAnSMMs/jWZvCbt0+BYg58nh3h8ugW69Uz+u22oCA
	 7rH+95YsIUBtammESbnzlbtgsnUwU2KWI8RqL5ChDjrR3VtuMpfQbYMZgBEbSCPnlFgbE
	 gZwAMANSfCJlTzzM7p00yDmohzyKcDE2p2d53YPYl/LX3TDVjNvDAPDqEEHINd2RbxMlt
	 hA1Rhqn8ejLMNdQFsKSbx5F2ROiV8s6bUzyVn5X11OG8RXkFODmLcqpGffmO61GKhOdBo
	 RAjQWHf1AoZ3RQUHd81AnIReVAaOH5VU7/eYA+ig9Oge/nPorEIOWb9Srn6M7eCdBSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J6883/8Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CCD606A326;
	Wed, 25 Nov 2026 14:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J6883/8Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1566B1F000C6;
	Wed, 25 Nov 2026 14:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618760;
	bh=1PoM5tI3zBPKwvPxWIJDJRv6i378/VOanZoQn6tt8H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6883/8Z+tHjLJcN8ZANP5u3Sjw2Os1fbzJ9MXVj1ovdV7YnDag+z+6Nr0ddNiGcL
	 bPJWIw+OQAMSBTSx6ALUkKeLuhU6bu2orbU/UUK/y0mTzEO8JtrH/eHCHU6s7qXN+9
	 j+34RwF/T89dRTGDlrV2K+4kavEZr4ba5cUX/tUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satyanarayana K V P <satyanarayana.k.v.p@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0381/1005] drm/xe: Prevent VF memory IRQ from accessing a torn-down engine
Date: Wed, 25 Nov 2026 15:28:39 +0100
Message-ID: <20261125143830.663170625@linuxfoundation.org>
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

From: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>

[ Upstream commit db58638d5d0531beafafa498cffa516779876ee5 ]

The VF memory IRQ handler iterates over HW engines whose names are set.
Engine teardown clears hwe->gt but leaves hwe->name set, so the handler
can select an engine whose GT has already been invalidated. This can
cause a NULL pointer dereference in xe_hw_engine_handle_irq().

Invalidate the engine name during teardown so subsequent engine scans
skip it.

Signed-off-by: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Piotr Piórkowski <piotr.piorkowski@intel.com>
Fixes: 6eb2aad402cc ("drm/xe: Move hw_engine_fini to devm managed")
Reviewed-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20261013152417.3189567-6-satyanarayana.k.v.p@intel.com
(cherry picked from commit f88c6f2fa88bc5892b1e842972096613086c06b2)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hw_engine.c | 17 ++++++++++++++---
 drivers/gpu/drm/xe/xe_irq.c       |  3 +++
 drivers/gpu/drm/xe/xe_memirq.c    |  3 +++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_hw_engine.c b/drivers/gpu/drm/xe/xe_hw_engine.c
index 9680d2a5adec7..f7d5d1101c6e0 100644
--- a/drivers/gpu/drm/xe/xe_hw_engine.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine.c
@@ -275,11 +275,22 @@ static const struct engine_info engine_infos[] = {
 static void hw_engine_fini(void *arg)
 {
 	struct xe_hw_engine *hwe = arg;
+	struct xe_gt *gt = hwe->gt;
+
+	if (gt) {
+		struct xe_device *xe = gt_to_xe(gt);
+		unsigned long flags;
 
-	if (hwe->exl_port)
-		xe_execlist_port_destroy(hwe->exl_port);
+		if (hwe->exl_port)
+			xe_execlist_port_destroy(hwe->exl_port);
 
-	hwe->gt = NULL;
+		spin_lock_irqsave(&xe->irq.lock, flags);
+		hwe->name = NULL;
+		hwe->gt = NULL;
+		spin_unlock_irqrestore(&xe->irq.lock, flags);
+	} else {
+		hwe->name = NULL;
+	}
 }
 
 /**
diff --git a/drivers/gpu/drm/xe/xe_irq.c b/drivers/gpu/drm/xe/xe_irq.c
index 9e49e2241da41..b394c8edf89c9 100644
--- a/drivers/gpu/drm/xe/xe_irq.c
+++ b/drivers/gpu/drm/xe/xe_irq.c
@@ -908,6 +908,7 @@ static irqreturn_t xe_irq_msix_default_hwe_handler(int irq, void *arg)
 	struct xe_hw_engine *hwe;
 	enum xe_hw_engine_id id;
 	struct xe_tile *tile;
+	unsigned long flags;
 	struct xe_gt *gt;
 
 	if (!atomic_read(&xe->irq.enabled))
@@ -922,8 +923,10 @@ static irqreturn_t xe_irq_msix_default_hwe_handler(int irq, void *arg)
 			if (gt->tile != tile)
 				continue;
 
+			spin_lock_irqsave(&xe->irq.lock, flags);
 			for_each_hw_engine(hwe, gt, id)
 				xe_memirq_hwe_handler(memirq, hwe);
+			spin_unlock_irqrestore(&xe->irq.lock, flags);
 		}
 	}
 
diff --git a/drivers/gpu/drm/xe/xe_memirq.c b/drivers/gpu/drm/xe/xe_memirq.c
index 9dfe965cb46ec..1073132f2dede 100644
--- a/drivers/gpu/drm/xe/xe_memirq.c
+++ b/drivers/gpu/drm/xe/xe_memirq.c
@@ -555,6 +555,7 @@ void xe_memirq_handler(struct xe_memirq *memirq)
 	struct xe_hw_engine *hwe;
 	enum xe_hw_engine_id id;
 	struct iosys_map map;
+	unsigned long flags;
 	unsigned int gtid;
 	struct xe_gt *gt;
 
@@ -568,8 +569,10 @@ void xe_memirq_handler(struct xe_memirq *memirq)
 		if (gt->tile != tile)
 			continue;
 
+		spin_lock_irqsave(&xe->irq.lock, flags);
 		for_each_hw_engine(hwe, gt, id)
 			xe_memirq_hwe_handler(memirq, hwe);
+		spin_unlock_irqrestore(&xe->irq.lock, flags);
 	}
 
 	/* GuC and media GuC (if present) must be checked separately */
-- 
2.53.0



