Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016595;
	b=BA909ijrS2E0JPm2HzewmyyNBa1i1p3Drisz1jcdxVMuPhi8o+mew6wTCLyXAhHsq8qf
	 Pj1T9PgjUI1FptPJkgV7TyOb5/ypRWNP1JQjtaE8UsZDkIzLboETZ0k/L7VFDCqubHuNX
	 pi9SHjgjkmQSryzePHEhYxzSKx4BL6Fz2y2+TgzmKOkXKu824Vo7kqq55zQ7qDlwwCN/S
	 oi1MPPmgstBR0K2vmvDitfaHjPhswP2eDbn59j6XT4m/AyyQhbADtJpYBAeE5PGwcWFOo
	 Jg8aSWcX6gEuWhGe9Ge0tcW8YWMFSI1zM2lviY3a6JkAqJ67OWDtuW1hzAHb8LZVWxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=RN6UTtssbTMFmjbmIrAQUr4JM3704eSnID1VpTTAzeE=;
	b=kZFcIV+lbhq+qq1wAeCPXO8zeUaPIYIA0rAS1QaS6/aIrntR3nyP1hxmeyiglc+xQbtd
	 W3HfamB/ni/1FvBSt8oxIDi/yERLuDEDas/W1MfnmbzWsQmq8SZx2bOKndvD3Dmn6KDHV
	 ScZwRjywNL+j3clT5prxslHWgJrJDKtZ1kflvQzs8TIoRKAFWxJYCB/Bz9rKja8l4Myrf
	 YvBlC1L+WAYKvjVI52ru58zpGC91MYCWs7HWc/+6zuwrzjxO282nZDdJ7jFGyYrRSUZE1
	 TjuAh315nsr4p+OTQcJLE/GFadhIRm4gopH3SPCkxC8e0EUdYKvSnbHRZOlbwQd3Kfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vrZ/36B8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912C660A260C;
	Wed, 18 Nov 2026 15:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vrZ/36B8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9931D1F000C5;
	Wed, 18 Nov 2026 15:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016595;
	bh=RN6UTtssbTMFmjbmIrAQUr4JM3704eSnID1VpTTAzeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrZ/36B8wuTzSUOezwC1tKPTRPZ9QlJjK+/cnkEWm3WqFjf3ggmcOPqFmLrH28afE
	 1MQAJcKWvsTkGJ9SWLIvMuVopnaaj4GmYGEfednBVm3eZSAGKY8zMNgD/EUonnVXv4
	 fgrpm/ciMpDe7N72QGsJW0pt1qFIUl7KdOssaBJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arvind Yadav <arvind.yadav@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Varun Gupta <varun.gupta@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0584/2651] drm/pagemap: Prevent CPU stalls during unbounded pagemap teardown
Date: Wed, 18 Nov 2026 15:30:24 +0100
Message-ID: <20261118150308.751563127@linuxfoundation.org>
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

From: Varun Gupta <varun.gupta@intel.com>

[ Upstream commit b66b036c959f49decd2202db4026d3ae21e01388 ]

drm_pagemap_dev_unhold_work() processes an unbatched llist of pagemaps
on the system workqueue. This creates potential latency traps during
heavy teardown cycles due to two compounding factors:

1. The loop contains a per-item drm_dbg() trace. If dynamic debug is
enabled on a slow serial console, synchronous print latency scales
linearly with the batch size and can block worker execution.
2. The llist can accumulate large batches during intensive unmap
operations, monopolizing worker resources without yielding.

This causes below log warning:
"workqueue: drm_pagemap_dev_unhold_work [drm_gpusvm_helper] hogged CPU
for >10000us 19 times, consider switching to WQ_UNBOUND"

Fix this by implementing a latency mitigation strategy:
- Move the teardown work to system_unbound_wq to avoid tying up
  per-CPU bound worker pools.
- Add cond_resched() inside the teardown loop to yield the CPU during
  large batch teardowns, ensuring system responsiveness.
- Convert the drm_dbg() trace to drm_dbg_ratelimited() to mitigate
  serial console bottlenecks while preserving debuggability.

v2:
  - Changed workqueue from deprecated system_unbound_wq to system_dfl_wq.
    (Arvind Yadav)

Fixes: a26084328ac4 ("drm/pagemap, drm/xe: Manage drm_pagemap provider lifetimes")
Reviewed-by: Arvind Yadav <arvind.yadav@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Varun Gupta <varun.gupta@intel.com>
Link: https://patch.msgid.link/20260918081320.30389-2-varun.gupta@intel.com
Signed-off-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_pagemap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index a0546955d0b9f..c66c58f85c345 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -1079,7 +1079,7 @@ static void drm_pagemap_release(struct kref *ref)
 	dpagemap->dev_hold = NULL;
 	drm_pagemap_shrinker_add(dpagemap);
 	llist_add(&dev_hold->link, &drm_pagemap_unhold_list);
-	schedule_work(&drm_pagemap_work);
+	queue_work(system_dfl_wq, &drm_pagemap_work);
 	/*
 	 * Here, either the provider device is still alive, since if called from
 	 * page_free(), the caller is holding a reference on the dev_pagemap,
@@ -1102,10 +1102,11 @@ static void drm_pagemap_dev_unhold_work(struct work_struct *work)
 		struct drm_device *drm = dev_hold->drm;
 		struct module *module = drm->driver->fops->owner;
 
-		drm_dbg(drm, "Releasing reference on provider device and module.\n");
+		drm_dbg_ratelimited(drm, "Releasing reference on provider device and module.\n");
 		drm_dev_put(drm);
 		module_put(module);
 		kfree(dev_hold);
+		cond_resched();
 	}
 }
 
-- 
2.53.0



