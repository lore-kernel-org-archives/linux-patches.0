Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618664;
	b=J35Bc/H+oixM2FOu5MYokM9cZe3rnXKiGlOK5aItGvy6+LOG+4j6qIztv4eloBGtcegD
	 OlxN+KszLmZg+ZJ2uXLNYGBDH8cqyq4qFujm/khRNfhX5XW2kfDyD32tW+9YknzrTF4dO
	 ADpxfpndwiAdCVS89wgfhMuGKi5LfVujHHJOBp+Ufycev688MFSsXmxW307xSx0WBa+/7
	 XS6lApT8wLWric/O+OXz+8PIW1AXD/OAOmYuwF0Y4LnjjcwV5wsRlETQin1/6DwOt/DBH
	 1uGSCuRk0FpZqzxcJNMcvzBQt+q883I4wDonQ0BPG2aKhKbbsCTez3bERKoJYJCnnEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OjzcOIL/5jGLwm+8uQR6QVw3dS19Z6Z9683rqB0EeiI=;
	b=NFbmHNQDszvpk5irFxwYZ4OMbJdiwRcdyE69o0LR8By8Yq4ErZWn3A9HM80ARThiF9ui
	 35KGmqVixdSJ1CP3vA21CY0Z9ZFsLRYjJGDD9CvDZbVfOuaSJIWvvdd8RGBS4oOqbjmLq
	 MYRyL1BkXQWQXayrNYYR1MKVi+KrsS2fnZ9nN9TYaM3I29lPfFOFNowsdNhpJ6eiMU4xW
	 FKlotpCmFdDU6i222mcY6dH/jlfCP1tMpRHaCVCW+IPoV86A43cReLNEi8I1Uot62HXqj
	 jtyBWQzoels4FOKDYkNvzGnIWj+gzDQ7nvbprFUljOjCRxhvr/J2IVslXrMnwzkG8Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Shoa2ELy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFA7606A31E;
	Wed, 25 Nov 2026 14:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Shoa2ELy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17931F000D2;
	Wed, 25 Nov 2026 14:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618664;
	bh=OjzcOIL/5jGLwm+8uQR6QVw3dS19Z6Z9683rqB0EeiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Shoa2ELyX9sKmWg+JVR+hhWFFBKcs/g7bGpfVUS+POz8xIoopgwkXJrPo+KEkfIcM
	 qYhvQkZDqckL6CE5LM2f5Be0UhLNFxuSGzlzB9P618UViBxX4vCfg4xwIQY+vt17g+
	 Wya8jUaP4ygd25i9gd2K9a8+unDyZvVu7wq3lL6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kayra Cizmeci <kayracizmeci@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0348/1005] sched/cache: Ignore non-fair current in alb_break_llc()
Date: Wed, 25 Nov 2026 15:28:06 +0100
Message-ID: <20261125143829.887014591@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kayra Cizmeci <kayracizmeci@gmail.com>

[ Upstream commit 006991aa89974378ee579416dba87adc22cd60fd ]

Commit d6b9afab44e23 ("sched/cache: Fix
checking active load balance by only considering the CFS task")
stopped using task_util() for non-fair cur.

__active_load_balance_cpu_stop() calls detach_one_task(), that only looks
to cfs_tasks list. So if the rq->curr is not fair, doing a decision
according to it is wrong, since we only migrate tasks that is fair.

Commit f0d243a96f26 ("sched/fair: Avoid creating misfits during
cache-aware balancing") passes cur to task_misfits_asym_cpu()
without checking if the cur is in fair class or not. Fix this.

Fixes: f0d243a96f26 ("sched/fair: Avoid creating misfits during cache-aware balancing")
Signed-off-by: Kayra Cizmeci <kayracizmeci@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Link: https://patch.msgid.link/20261020185402.57017-1-kayracizmeci@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 327d5f8f45966..d1ea0e53f1657 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11035,7 +11035,14 @@ alb_break_llc(struct lb_env *env)
 			return true;
 
 		cur = rcu_dereference_all(env->src_rq->curr);
-		if (cur && cur->sched_class == &fair_sched_class)
+		/*
+		 * Active balance only detaches CFS tasks, so a non-fair
+		 * curr is never migrated. Ignore it and avoid using its
+		 * state util in the misfit and LLC checks.
+		 */
+		if (cur && cur->sched_class != &fair_sched_class)
+			cur = NULL;
+		if (cur)
 			util = task_util(cur);
 
 		if (task_misfits_asym_cpu(env, cur) ||
-- 
2.53.0



