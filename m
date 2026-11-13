Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585832;
	b=2sG/52P+/XgHDw+O6b18Sf1WCGWHdEyqTdMuJYDfC8rLfP3W8dWJ6WAfPQDgjcPcmfJu
	 IfYOz0Vzl41emM7qvcg9Xf+OrCFD2MYj+oIHp8384KSMGeJWq13R2qidKQHWZu13dAMOi
	 11M7S4kw8cH4LL/FKlBl4LLBe+7vRBMrsM7fuvG0njv1eQ4S9kIFSKJ3UJzHtr33AqAab
	 eBbCz5sd3sxcD+Qz01obJ/BIYlq6Kk6bLxlxWuTacKn41ieTWyzXmX7PcX2yLg03Aof35
	 /5D/rXrPzg/mmUkC0ASXsd+2/ITvX5NKD/QN1EIX8xuF2psZfQyZv2E7UMoEEh5FryA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Cve4t1hIOiX4gk4UtMvwuIyPO5XpqYqozV/U9xdzJSg=;
	b=y0W+G9vzxRsUmd/h9wxrJte3QPy+uZ+iW2NZ2vAX6FVchpffIzlhrTM9O7wmhXlnhohF
	 3KwwR9MGzLFRwQUjypXfht6GlPsVcdXR5pCA162ht7uhHHLOp1fXzy/tPpmpqMfxjipOq
	 381TeMcPfytp4q4Hply6yiqfU6JKczRdU304ZyGUcSg3sq2MwrsW5QhgBjv/XPGazkzkp
	 OY6pFDGfVkt5mV+3GjvLIP0srokbYQpM3G1/eCiprlySBaKPnukZdwDoKqMTbMzEzcoZ0
	 EGOnwy8Qqj8O3jA0g1bzbefAeCQQYxJ5sqetgh3ZT7d66K0dReWuR0qpVbVxoO5r/jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWNoD93I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2DF606BAA6;
	Fri, 13 Nov 2026 16:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWNoD93I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB1F1F000C4;
	Fri, 13 Nov 2026 16:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585832;
	bh=Cve4t1hIOiX4gk4UtMvwuIyPO5XpqYqozV/U9xdzJSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWNoD93I9CHcT5OhbGL7QG+ppdVDXbkQrTnLI8XJaAI3Xi+g0umFdwtRr6CMZYqS+
	 6g7lXy7kF6yhpD9C1HUa1w8De3B10XoepWf61yDYMjmPeWKo5QHUUEoLXdg/KLTD62
	 U+fAdRLceUxIqB/5mpB8BM/C/dvaLgReI/ScUdxo=
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
Subject: [PATCH 7.3 410/507] drm/sched: Adjust run-queue when changing priority at runtime
Date: Fri, 13 Nov 2026 10:51:54 -0500
Message-ID: <20261113153810.629864695@linuxfoundation.org>
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

[ Upstream commit 75709a35da45bc67f94c9ceb91bf8871fdfe4d9e ]

Another consequence of the recent revert of

commit 77a6809f1dc3 ("drm/sched: Remove FIFO and RR and simplify to a single run queue")

is that after the revert we need to adjust entity->rq_priority when
runtime priority changes are requested.

Only amdgpu does that so the impact is minimal. Also considering dynamic
priority changes are largely broken there, due currently broken entity
scheduler list handling where the special case of a single scheduler can
never change it's run-queue. And coupled with the fact for the rest a two-
tier approach of drm_sched_entity_set_priority() and
drm_sched_entity_modify_sched() is used, where later directly maps to
different hardware queue priority by replacing the set of schedulers
completely.

Hence the regression is limited to rings which have multiple instances
other than compute and graphics, which would be SDMA only, for which I am
not sure any userspace actually does dynamic priority changes in the first
place.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: 2fa4d8e2c109 ("drm/sched: Add fair scheduling policy")
Cc: Christian König <christian.koenig@amd.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Philipp Stanner <phasta@kernel.org>
Cc: stable@vger.kernel.org # v7.2+
[phasta: fix checkpatch error]
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://patch.msgid.link/20261021094227.48034-3-tvrtko.ursulin@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index adaf7764ed33c..0206bbad2ce09 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -454,6 +454,8 @@ void drm_sched_entity_set_priority(struct drm_sched_entity *entity,
 {
 	spin_lock(&entity->lock);
 	entity->priority = priority;
+	if (drm_sched_policy != DRM_SCHED_POLICY_FAIR)
+		entity->rq_priority = priority;
 	spin_unlock(&entity->lock);
 }
 EXPORT_SYMBOL(drm_sched_entity_set_priority);
-- 
2.53.0



