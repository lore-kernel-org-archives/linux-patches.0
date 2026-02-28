Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAEA344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301730; cv=none; b=Ert1IIHngi+rpgYEM/+uHirKVFO6PuHVCYp4hJWeHeW5esxndJLKynNuohzzRk4dXfYM2bqwElg0ajicXieYT3KWacbw5GqjzLt8ehLEwmvyXGtLckL+QBcPTF3DIprtKLW6gOpJSjo5Z53fXH/Knirg+VgdDlYkEq5vfJXKLXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301730; c=relaxed/simple;
	bh=2ARIrTuXH0PJQuxJ+uktNxHGD/lLsUex2jtRplnpIw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoqUIbuqaiin5g0pne4PfFQNfV+nyLO/2hdnVGl1ovQTfozqBWlPgDqwr+2tbLYy49F0JxtrtOyIu1S21HzGu/Qi5+iDItM6cLaZePptbay9kMYAotpYCUr+XQqnbBeTJ7HaQCcABsKUBSgyn5VBbfujR2pZ4mJZ71qJTNmN8sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IKooxPMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IKooxPMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077CDC116D0;
	Sat, 28 Feb 2026 18:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301730;
	bh=2ARIrTuXH0PJQuxJ+uktNxHGD/lLsUex2jtRplnpIw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKooxPMRgQxk5+8w2TEnCzL7vlVITUEkSZH9Ji9ZBiW0uegepLaJBEQJhlmwgI8w5
	 66Cw5vxgnCDYlt8r/fVh0SFN3STPeDP7SFVfgdygy7C1f1YwVmQfCcbC3Llxaorugr
	 Hltdwoe3a72NYQM9iw3WOJq0S1MD+LOjneIk3qWi6jtomq/4DcDsYoMyyjrLLjq6k1
	 WRC8ROaYBwRSKo8XyKgIQ30I2KWcPZKvY2j+waYNGv7qojxVqlDf0bHaag2w2j5+up
	 MNWKEhAl6liVcrC4LnlpgoUxlfmN2UBsBjbrHerT4iO6sYz3hwoXcxxtCWSHPEcFNI
	 D8kKSTbD/okQw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 129/385] drm/panthor: Fix the full_tick check
Date: Sat, 28 Feb 2026 12:55:51 -0500
Message-ID: <20260228180011.1568201-129-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit a3c2d0b40b108bd45d44f6c1dfa33c39d577adcd ]

We have a full tick when the remaining time to the next tick is zero,
not the other way around. Declare a full_tick variable so we don't get
that test wrong in other places.

v2:
- Add R-b

v3:
- Collect R-b

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Link: https://patch.msgid.link/20251128094839.3856402-4-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 1d95decddc273..6cfd44a414802 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2338,6 +2338,7 @@ static void tick_work(struct work_struct *work)
 	u64 remaining_jiffies = 0, resched_delay;
 	u64 now = get_jiffies_64();
 	int prio, ret, cookie;
+	bool full_tick;
 
 	if (!drm_dev_enter(&ptdev->base, &cookie))
 		return;
@@ -2349,15 +2350,17 @@ static void tick_work(struct work_struct *work)
 	if (time_before64(now, sched->resched_target))
 		remaining_jiffies = sched->resched_target - now;
 
+	full_tick = remaining_jiffies == 0;
+
 	mutex_lock(&sched->lock);
 	if (panthor_device_reset_is_pending(sched->ptdev))
 		goto out_unlock;
 
-	tick_ctx_init(sched, &ctx, remaining_jiffies != 0);
+	tick_ctx_init(sched, &ctx, full_tick);
 	if (ctx.csg_upd_failed_mask)
 		goto out_cleanup_ctx;
 
-	if (remaining_jiffies) {
+	if (!full_tick) {
 		/* Scheduling forced in the middle of a tick. Only RT groups
 		 * can preempt non-RT ones. Currently running RT groups can't be
 		 * preempted.
-- 
2.51.0

