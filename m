Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9B24F218;
	Thu, 12 Dec 2024 15:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018577; cv=none; b=q5L/zKMJF5MYTGYibiFQ9Y6N0lv48goWzm7pvM+VZMcKPLXomVRHjlL+GknzffVAm9zcyP9glEoNrP3Qdkb21GUZkVqikOq/9vjAPoLxqqd+8MIbX5Ld3X469zsdoueDU+xh9k52ih7K+vGECg5HG3NTd3DSaWa0R8dBPu7vpIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018577; c=relaxed/simple;
	bh=7WAGjhHxE6RPL8rLrhdDmHjqiTul3nyViyIUWNrJ07c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fnix/cRmJ1k7SLw6BG7Q4gKm00/D69qm4TpsfvE1AVeq42bpov2n3qisXOLpdNRIz9wJ3ZHtVJ2inImN/0NfCMqIDHe21ujaxPsDNSvv4SIiyVxrc+d9NFn8hfHOo7MZ9iYcv641bkanJ0mPwjnyIuLlbXcyjK/NfGwq2qXxzXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/xp/9bB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/xp/9bB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78718C4CECE;
	Thu, 12 Dec 2024 15:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018577;
	bh=7WAGjhHxE6RPL8rLrhdDmHjqiTul3nyViyIUWNrJ07c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/xp/9bB138ZMblKNEPOMDIobJBx1SZRXaaedTvsu8JNJ51mia66VuHa5B/lOQ9GL
	 AD0TvSfZ6K569X3NP/kxiVCSS29w7nzr4OQ8H6mpRujRsImv2Rg02w9pWOQnwIdqGU
	 7CdpQ5mTr2IuPhMFUYis8wQ1Nc20p+JVdxExVknU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 323/356] sched/fair: Rename check_preempt_wakeup() to check_preempt_wakeup_fair()
Date: Thu, 12 Dec 2024 16:00:42 +0100
Message-ID: <20241212144257.317283395@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo Molnar <mingo@kernel.org>

[ Upstream commit 82845683ca6a15fe8c7912c6264bb0e84ec6f5fb ]

Other scheduling classes already postfix their similar methods
with the class name.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Stable-dep-of: 0664e2c311b9 ("sched/deadline: Fix warning in migrate_enable for boosted tasks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d1a67776ecb5d..685774895bcec 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8255,7 +8255,7 @@ static void set_next_buddy(struct sched_entity *se)
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
+static void check_preempt_wakeup_fair(struct rq *rq, struct task_struct *p, int wake_flags)
 {
 	struct task_struct *curr = rq->curr;
 	struct sched_entity *se = &curr->se, *pse = &p->se;
@@ -13102,7 +13102,7 @@ DEFINE_SCHED_CLASS(fair) = {
 	.yield_task		= yield_task_fair,
 	.yield_to_task		= yield_to_task_fair,
 
-	.check_preempt_curr	= check_preempt_wakeup,
+	.check_preempt_curr	= check_preempt_wakeup_fair,
 
 	.pick_next_task		= __pick_next_task_fair,
 	.put_prev_task		= put_prev_task_fair,
-- 
2.43.0



