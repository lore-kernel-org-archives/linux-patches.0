Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585831;
	b=H3rxyJV3CgZFA+1YObZjtTacB34yToD4z+QUOoPz2bGkD2ugQt57y0Nd29DK5gw+o024
	 GSd27lomxv7QeTE48oPZMBg/k3AUpZCelkn9Hd49gXh0lEb1OF+tSDr0ykyGA66FRWs9P
	 hNO0UNyzxbwBVv6S/6jtfG+GJsCykCSdqTyiGFlQ2OE54BLqc5AQNVd1PRFXM8i8nf3op
	 6iCchMVKiJWRXSuQKZSDV6xMmihyHm0O2H6ImyVXMrxCLl+pLXptbLS7f25Ui59jkYePL
	 sLXu4hEGmkP+B3XUpIpnOp50ew4IKt65YVo1bDIjbdThLpzxu3HZjKpvMWnGd/tBHGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ciTj0J4XgFDcaDkWnLS99JrnDQyCI9Vxadr5oYa2KB0=;
	b=xn/YqlUxLmzfcccnjb54BrJpc4h2IVgeuqqzQfV5LrpXhHbuUFLjEOcGPbwbmnKO6eQf
	 lKsPjPzEBe/OcS23bS81oCRNLrmrcR5WoAMYVq17xD7WkCCeD8xaCH/1+t+1LL3Bl8PUn
	 KDjModInFcWkN2a+LTbvnEfKIHldRIwmc3PhQKIPfGNrhsdXNEkMSy4D6iiGXlyv/BGTq
	 cjWuZJC6kFpEw+GB7bvqmIO/bpCCPO/Ql2cCmocl4NOojqksmU8C0VxHegSMgs54c9D9I
	 duqEv8+gFeTl7aMnf8BYpTNzoOuN8NzwB1YdL2bjIdtxA4Wctnj0r8u0RBRBkIaOYYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KhXlyyER;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FA6606D2C5;
	Fri, 13 Nov 2026 16:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KhXlyyER
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310461F000C4;
	Fri, 13 Nov 2026 16:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585831;
	bh=ciTj0J4XgFDcaDkWnLS99JrnDQyCI9Vxadr5oYa2KB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KhXlyyERTTHJKaUenrsyuPfmUS0wkAWjaPagAArq0CUbwtoDJq1kC6daQhNHrqY10
	 03WdUnR3hmPHleqM2+F1JWsqnsclZKCGSmE3URZUoUSJsrNMZ/K7iNkFNZo4dVakqW
	 Hw00IZXsI+Tl3a5Ad+H75crPIMd80XuLHZMHj4tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 409/507] drm/sched: Fix out of bounds entity priority check
Date: Fri, 13 Nov 2026 10:51:53 -0500
Message-ID: <20261113153810.595626525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit cda6f72545f2372234c72f93fd1be61841295e19 ]

When the out of range priority at entity init time is clamped to the
number of run queues in the supplied scheduler the internal run-queue
priority needs to be adjusted as well.

There is no impact since none of the drivers hit the clamping path, but
we still need to address it by moving the entity->rq_priority assignment
to after the clamping is done.

Note that a lot of this will hopefully get removed once again when the
single run-queue simplification lands.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: 2fa4d8e2c109 ("drm/sched: Add fair scheduling policy")
Cc: Christian König <christian.koenig@amd.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Philipp Stanner <phasta@kernel.org>
Cc: stable@vger.kernel.org # v7.2+
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://patch.msgid.link/20261021094227.48034-2-tvrtko.ursulin@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c | 27 +++++++++++-------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index 673ca9cbf3628..adaf7764ed33c 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -130,10 +130,7 @@ int drm_sched_entity_init(struct drm_sched_entity *entity,
 
 	INIT_LIST_HEAD(&entity->list);
 	entity->guilty = guilty;
-	entity->priority = priority;
 	entity->last_user = current->group_leader;
-	entity->rq_priority = drm_sched_policy == DRM_SCHED_POLICY_FAIR ?
-			      DRM_SCHED_PRIORITY_KERNEL : priority;
 	entity->num_sched_list = num_sched_list;
 	entity->sched_list = num_sched_list > 1 ? sched_list : NULL;
 	RCU_INIT_POINTER(entity->last_scheduled, NULL);
@@ -145,26 +142,26 @@ int drm_sched_entity_init(struct drm_sched_entity *entity,
 		 * not to do this and to fix their DRM calling order.
 		 */
 		pr_warn("%s: called with uninitialized scheduler\n", __func__);
-	} else {
-		enum drm_sched_priority p = entity->priority;
-
+	} else if (priority >= sched_list[0]->num_user_rqs) {
 		/*
 		 * The "priority" of an entity cannot exceed the number of
 		 * run-queues of a scheduler. Protect against num_rqs being 0,
 		 * by converting to signed. Choose the lowest priority
 		 * available.
 		 */
-		if (p >= sched_list[0]->num_user_rqs) {
-			dev_err(sched_list[0]->dev, "entity with out-of-bounds priority:%u num_user_rqs:%u\n",
-				p, sched_list[0]->num_user_rqs);
-			p = max_t(s32,
-				  (s32)sched_list[0]->num_user_rqs - 1,
-				  (s32)DRM_SCHED_PRIORITY_KERNEL);
-			entity->priority = p;
-		}
-		entity->rq = sched_list[0]->sched_rq[entity->rq_priority];
+		dev_err(sched_list[0]->dev, "entity with out-of-bounds priority:%u num_user_rqs:%u\n",
+			priority, sched_list[0]->num_user_rqs);
+		priority = max_t(s32,
+				 (s32)sched_list[0]->num_user_rqs - 1,
+				 (s32)DRM_SCHED_PRIORITY_KERNEL);
 	}
 
+	entity->priority = priority;
+	entity->rq_priority = drm_sched_policy == DRM_SCHED_POLICY_FAIR ?
+			      DRM_SCHED_PRIORITY_KERNEL : priority;
+	if (sched_list[0]->sched_rq)
+		entity->rq = sched_list[0]->sched_rq[entity->rq_priority];
+
 	init_completion(&entity->entity_idle);
 
 	/* We start in an idle state. */
-- 
2.53.0



