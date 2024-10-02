Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31431D0BBE;
	Wed,  2 Oct 2024 14:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879863; cv=none; b=qWjp9WntWZwHDSNMl9hietSHNw1qjR3Pk/EwCX6U1b6R+yevCaAd2hojUxQclUQP9GgvpGXk9zmTM8F8kEcAR0XzjeBxvm7uTSmurf01BM1ol/yOgpYNnplo/AiGvPtlEu2Ff/u07TMFC86wDJR6ZRGICv53TSZbHBtBfmMwIX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879863; c=relaxed/simple;
	bh=vPtuSU87oeGIoMXFUdb35jRJFTrTMXzlZaXx5+B6fDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxFKR9RX4VVjeR2WT0TcCu2IhrOiCrSmH1nOw+CTjFBgYCsoZgFo/HIewhsU8sgST3qOlrUE24ZxEsHCSf+tJKTwMXO5WWFScXhrsUAL47uw8HEAM/rE5LxN/NXwIPDs/Ft7Iz3r3XilSHyAGYBEnEGoZDg3AYbg5Cab6VNSuyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZsiX5ZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZsiX5ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5642EC4CEC2;
	Wed,  2 Oct 2024 14:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879863;
	bh=vPtuSU87oeGIoMXFUdb35jRJFTrTMXzlZaXx5+B6fDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZsiX5ZKwJmBKi/r9CUyMsDHBqWbCtxrqK3XE89hpavkRt/nXabeci29uZgKUNosR
	 ri3qxPKtUIFzMsPgZj0BV6T9QlzlPpvf+X7VjNXSrrEQQiN1xiduVXu46CjfsErAoP
	 /9mDo1XDsDLpTDkByrRrSlsEoIKsE+UG0F44ZFng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mel Gorman <mgorman@techsingularity.net>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 233/538] sched/numa: Rename vma_numab_state::access_pids[] => ::pids_active[], ::next_pid_reset => ::pids_active_reset
Date: Wed,  2 Oct 2024 14:57:52 +0200
Message-ID: <20241002125801.449503652@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Mel Gorman <mgorman@techsingularity.net>

[ Upstream commit f3a6c97940fbd25d6c84c2d5642338fc99a9b35b ]

The access_pids[] field name is somewhat ambiguous as no PIDs are accessed.
Similarly, it's not clear that next_pid_reset is related to access_pids[].
Rename the fields to more accurately reflect their purpose.

[ mingo: Rename in the comments too. ]

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20231010083143.19593-3-mgorman@techsingularity.net
Stable-dep-of: f22cde4371f3 ("sched/numa: Fix the vma scan starving issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm.h       |  4 ++--
 include/linux/mm_types.h |  6 +++---
 kernel/sched/fair.c      | 12 ++++++------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 830b925c2d005..b6a4d6471b4a7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1732,8 +1732,8 @@ static inline void vma_set_access_pid_bit(struct vm_area_struct *vma)
 	unsigned int pid_bit;
 
 	pid_bit = hash_32(current->pid, ilog2(BITS_PER_LONG));
-	if (vma->numab_state && !test_bit(pid_bit, &vma->numab_state->access_pids[1])) {
-		__set_bit(pid_bit, &vma->numab_state->access_pids[1]);
+	if (vma->numab_state && !test_bit(pid_bit, &vma->numab_state->pids_active[1])) {
+		__set_bit(pid_bit, &vma->numab_state->pids_active[1]);
 	}
 }
 #else /* !CONFIG_NUMA_BALANCING */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b53a13d15bbae..80d9d1b7685c6 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -559,10 +559,10 @@ struct vma_numab_state {
 	unsigned long next_scan;
 
 	/*
-	 * Time in jiffies when access_pids[] is reset to
+	 * Time in jiffies when pids_active[] is reset to
 	 * detect phase change behaviour:
 	 */
-	unsigned long next_pid_reset;
+	unsigned long pids_active_reset;
 
 	/*
 	 * Approximate tracking of PIDs that trapped a NUMA hinting
@@ -574,7 +574,7 @@ struct vma_numab_state {
 	 * Window moves after next_pid_reset has expired approximately
 	 * every VMA_PID_RESET_PERIOD jiffies:
 	 */
-	unsigned long access_pids[2];
+	unsigned long pids_active[2];
 };
 
 /*
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5fc0d9cc9d9d7..d07fb0a0da808 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3200,7 +3200,7 @@ static bool vma_is_accessed(struct vm_area_struct *vma)
 	if (READ_ONCE(current->mm->numa_scan_seq) < 2)
 		return true;
 
-	pids = vma->numab_state->access_pids[0] | vma->numab_state->access_pids[1];
+	pids = vma->numab_state->pids_active[0] | vma->numab_state->pids_active[1];
 	return test_bit(hash_32(current->pid, ilog2(BITS_PER_LONG)), &pids);
 }
 
@@ -3316,7 +3316,7 @@ static void task_numa_work(struct callback_head *work)
 				msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
 
 			/* Reset happens after 4 times scan delay of scan start */
-			vma->numab_state->next_pid_reset =  vma->numab_state->next_scan +
+			vma->numab_state->pids_active_reset =  vma->numab_state->next_scan +
 				msecs_to_jiffies(VMA_PID_RESET_PERIOD);
 		}
 
@@ -3337,11 +3337,11 @@ static void task_numa_work(struct callback_head *work)
 		 * vma for recent access to avoid clearing PID info before access..
 		 */
 		if (mm->numa_scan_seq &&
-				time_after(jiffies, vma->numab_state->next_pid_reset)) {
-			vma->numab_state->next_pid_reset = vma->numab_state->next_pid_reset +
+				time_after(jiffies, vma->numab_state->pids_active_reset)) {
+			vma->numab_state->pids_active_reset = vma->numab_state->pids_active_reset +
 				msecs_to_jiffies(VMA_PID_RESET_PERIOD);
-			vma->numab_state->access_pids[0] = READ_ONCE(vma->numab_state->access_pids[1]);
-			vma->numab_state->access_pids[1] = 0;
+			vma->numab_state->pids_active[0] = READ_ONCE(vma->numab_state->pids_active[1]);
+			vma->numab_state->pids_active[1] = 0;
 		}
 
 		do {
-- 
2.43.0



