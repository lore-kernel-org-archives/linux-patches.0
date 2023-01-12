Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F238746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F71C433EF;
	Thu, 12 Jan 2023 14:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532163;
	bh=x4jJklfXyiGG3hf/hgC+Km9UVMZm+1+hfK5jNklt75o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k15Y8I5PCbcwoBC9UWzyT5HN4XP3hODEVSVB9tDyL8/phcsNMk51gERhKusCnTHOR
	 vpcyv4ZIc8XQcKwvVJNy/IYChFk0vAyBsJZPshOwW675CXj01gO3Kf1qzQwn/wg4F5
	 eOgV4sA7U67zEbz/55OrSZRg6B2g95XJ2XOE8x3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vincent.donnefort@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/783] sched/fair: Cleanup task_util and capacity type
Date: Thu, 12 Jan 2023 14:45:59 +0100
Message-Id: <20230112135526.133767526@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vincent Donnefort <vincent.donnefort@arm.com>

[ Upstream commit ef8df9798d469b7c45c66664550e93469749f1e8 ]

task_util and capacity are comparable unsigned long values. There is no
need for an intermidiate implicit signed cast.

Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20211207095755.859972-1-vincent.donnefort@arm.com
Stable-dep-of: 48d5e9daa8b7 ("sched/uclamp: Fix relationship between uclamp and migration margin")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bca0efc03a51..2d3ea0679207 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4074,7 +4074,8 @@ static inline void util_est_update(struct cfs_rq *cfs_rq,
 	trace_sched_util_est_se_tp(&p->se);
 }
 
-static inline int task_fits_capacity(struct task_struct *p, long capacity)
+static inline int task_fits_capacity(struct task_struct *p,
+				     unsigned long capacity)
 {
 	return fits_capacity(uclamp_task_util(p), capacity);
 }
@@ -6247,7 +6248,7 @@ select_idle_capacity(struct task_struct *p, struct sched_domain *sd, int target)
 	return best_cpu;
 }
 
-static inline bool asym_fits_capacity(int task_util, int cpu)
+static inline bool asym_fits_capacity(unsigned long task_util, int cpu)
 {
 	if (static_branch_unlikely(&sched_asym_cpucapacity))
 		return fits_capacity(task_util, capacity_of(cpu));
-- 
2.35.1



