Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0F21DEFC8;
	Tue,  8 Oct 2024 13:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392796; cv=none; b=mUfILUg21sP5mJyLMeCgxIarY90W1qbr7NN6QtzZ45SjI1oQkBkARHZSW0Q5aDAgVzTwA0lnpivdIFpgO8uxhSqx2ayhU0hr8MIWbG5cViY+tGbkgoRT+sH11Tbt6k7YEzbXKXMmkzYOeKzLMXuzJ6GXar3vs69IbHf63XFMDg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392796; c=relaxed/simple;
	bh=tqSqlcPzDkQuKSYdfxXHHpimnn2kSBhAcYUoqB/veVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eb8vnyUC4FUTyFHezRAYuIim2gAfQZ4hJ/CnuYWBlwZxRAAmVeSYUByRT5hw5tiQjSvzn+5nVPP1nq4BC2QwHKDctZOXKUQbwDeIRiFFHZL1oUgr2BLd5NoTE0z+W+xPGWUlKbf7BY/pSkj3BJPLCN6h3EB7YfWIggWxwbH1CVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZIfkRsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZIfkRsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E15C4CECC;
	Tue,  8 Oct 2024 13:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392796;
	bh=tqSqlcPzDkQuKSYdfxXHHpimnn2kSBhAcYUoqB/veVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZIfkRsGjwbxZnt5ln8M9AlNqhhhufdWn83ptSynnnofDMSDQSUPydBa89vFm8L57
	 8rBkBkfmXqc1l9xkGMjO32tE4nO1CTo7axVYSVHYB5inUsfiCrZL8psPujRRMi78zz
	 uVJq8B7qfEIoBGLQ8zqW01f5YD0g5VYE3y8/EySk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Nirmoy Das <nirmoy.das@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Luben Tuikov <ltuikov89@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	David Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	dri-devel@lists.freedesktop.org,
	Nirmoy Das <nirmoy.das@intel.com>
Subject: [PATCH 6.11 523/558] drm/sched: Always increment correct scheduler score
Date: Tue,  8 Oct 2024 14:09:13 +0200
Message-ID: <20241008115722.810620190@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit 087913e0ba2b3b9d7ccbafb2acf5dab9e35ae1d5 upstream.

Entities run queue can change during drm_sched_entity_push_job() so make
sure to update the score consistently.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: d41a39dda140 ("drm/scheduler: improve job distribution with multiple queues")
Cc: Nirmoy Das <nirmoy.das@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Luben Tuikov <ltuikov89@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.9+
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240924101914.2713-4-tursulin@igalia.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -586,7 +586,6 @@ void drm_sched_entity_push_job(struct dr
 	ktime_t submit_ts;
 
 	trace_drm_sched_job(sched_job, entity);
-	atomic_inc(entity->rq->sched->score);
 	WRITE_ONCE(entity->last_user, current->group_leader);
 
 	/*
@@ -614,6 +613,7 @@ void drm_sched_entity_push_job(struct dr
 		rq = entity->rq;
 		sched = rq->sched;
 
+		atomic_inc(sched->score);
 		drm_sched_rq_add_entity(rq, entity);
 		spin_unlock(&entity->rq_lock);
 


