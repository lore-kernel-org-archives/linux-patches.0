Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621812;
	b=4qZDnlehn+v2L9t7XUaLIhnDDW7PI1lv17HJEo0k8qnPEiON7v6s0EfPo3xBogCZIKIm
	 hfHf8cFCqKFsUD3u2CkVeHBJAh8MC6jijozfWogQpJmedAshXEGwIf6+7AusYsbBWHqNW
	 nVQ2e2/Ru5qNbjot5dPfuQzBJnW4n8l/I1GOTK+lktIj7BFaJS1gf7oDcijKmRoooSToN
	 2xAhkRRpaVXkTGmprTJu+8TFPl33SUNWm3PY5fNd+BzQPiy6VZxYO6+uU6uomW7mrcUaZ
	 cGddQTvudHVyw8OVJt5opGiVea2bO9oLM6Jb7+ei8z8fiWV7VZPg782jHm94+ifxJog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=W6AqxoJHKER0xTuZgE6R9HLgz/REnU51fjhgKuYHCe4=;
	b=FRQGXBI3Wj/DhATEtuDHXFTqfDdZygR14cFuK20bQT21mdEDplx0wF9TL9Xfbnhg24ui
	 9OHMoKHog9TFcNnPUcwZjFEw6/fRIH61H+pnetDtFZjlbB19v2gGbCeizcsGN6WUgawH7
	 RXUwWwhpT3/IFw0dRy5CcOfc96O3/b7wqUqz5tBXldluJZhxWPdU0ffXKgHPYNqqRbshI
	 u7yBHGZKQP79vhIIVrO7LMA3R412Ndh2/2zC2O7wjv8J9bndrfnEBLkb6txVCqmy0orr6
	 ttqMaC70KhBqpqF6Q9YU/o0J8GqmLE3gaIZwxL+BFhRfdvJTezDbZlJlHZJAKXyw/jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MmjKu1G9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7891E606A693;
	Wed, 25 Nov 2026 15:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MmjKu1G9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407B61F000C6;
	Wed, 25 Nov 2026 15:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621811;
	bh=W6AqxoJHKER0xTuZgE6R9HLgz/REnU51fjhgKuYHCe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MmjKu1G9XDWfArg4O5hCxyvVxwY74hkNSTb7qsUW5AuSHO8irlNt6C/GyxZOMc+OQ
	 VWM+/PEgyxw3hJYkkcDTAfRXnzlJQW9lRJ25AKrPCGmjzINVNmtFkQzXqRhY3dH8Ds
	 KkTSbP6w2+WrZsalAWcrER+9UcaA2GW8m/NLz+Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satyanarayana K V P <satyanarayana.k.v.p@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 342/990] drm/xe: Prevent VF memory IRQ from accessing a torn-down engine
Date: Wed, 25 Nov 2026 15:28:29 +0100
Message-ID: <20261125143830.103382627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 2cc8fe677decd..cf5e42dddacf1 100644
--- a/drivers/gpu/drm/xe/xe_hw_engine.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine.c
@@ -276,11 +276,22 @@ static const struct engine_info engine_infos[] = {
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
index 06976cc779180..f49dfa208346f 100644
--- a/drivers/gpu/drm/xe/xe_irq.c
+++ b/drivers/gpu/drm/xe/xe_irq.c
@@ -855,6 +855,7 @@ static irqreturn_t xe_irq_msix_default_hwe_handler(int irq, void *arg)
 	struct xe_hw_engine *hwe;
 	enum xe_hw_engine_id id;
 	struct xe_tile *tile;
+	unsigned long flags;
 	struct xe_gt *gt;
 
 	if (!atomic_read(&xe->irq.enabled))
@@ -869,8 +870,10 @@ static irqreturn_t xe_irq_msix_default_hwe_handler(int irq, void *arg)
 			if (gt->tile != tile)
 				continue;
 
+			spin_lock_irqsave(&xe->irq.lock, flags);
 			for_each_hw_engine(hwe, gt, id)
 				xe_memirq_hwe_handler(memirq, hwe);
+			spin_unlock_irqrestore(&xe->irq.lock, flags);
 		}
 	}
 
diff --git a/drivers/gpu/drm/xe/xe_memirq.c b/drivers/gpu/drm/xe/xe_memirq.c
index 49c45ec3e83ca..da8a7feb56ece 100644
--- a/drivers/gpu/drm/xe/xe_memirq.c
+++ b/drivers/gpu/drm/xe/xe_memirq.c
@@ -473,6 +473,7 @@ void xe_memirq_handler(struct xe_memirq *memirq)
 	struct xe_hw_engine *hwe;
 	enum xe_hw_engine_id id;
 	struct iosys_map map;
+	unsigned long flags;
 	unsigned int gtid;
 	struct xe_gt *gt;
 
@@ -487,8 +488,10 @@ void xe_memirq_handler(struct xe_memirq *memirq)
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



