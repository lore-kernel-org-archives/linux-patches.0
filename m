Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80843266B65;
	Tue, 30 Sep 2025 15:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244869; cv=none; b=EQa4x4tqVvpn4+vSzQWi9IhrYmiz30glOcMGAN6HPb6aeTMyS7ore36E2/YFvEEe8WsrXBDvIMsmHqyx+oFVRrgu5NYslCzg0GYUC3O1qiBJ2LwseWql1eFGr5RFlyrkDCkbYTaVRjB0kQ/RK6g59wQk1oqxLZDXLH1mISMwE5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244869; c=relaxed/simple;
	bh=26pTV9+udUh+5IffRCCUFK4TvBLfWZB6V7t0z7Y/wNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XC7grSTZAeRDGWtSKHWBgE+QK5Xu4upEGrbrqOewP5VXsnJ3yO5cGArP0txAunjPYFVQ7Hts9dPcnshBw2u/t4SkJmX1lXISM7FVBErG7VyC/+ltcpiAJGYkG6h3aSTxHg4aLoJjNBsUos+Ny4VpojrRoutkA80VnLZzwBQs/iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hszIv1Y9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hszIv1Y9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB140C4CEF0;
	Tue, 30 Sep 2025 15:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244869;
	bh=26pTV9+udUh+5IffRCCUFK4TvBLfWZB6V7t0z7Y/wNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hszIv1Y9mG8yzu4gsbWHdpK0f7K0cXg/nflaKP15ST0NVSw8uWxkH/YFhALq34HB1
	 DntGHNTSXZtceYUyYYfmhilq+8SIZ9BaVMOQy4SIzLlRKJzyiwQpP/6EcaeFiJoIOZ
	 UqN+0hgt0f2+5y/WmXTbYE4xRF65UbEy3RpC+ui4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.16 139/143] sched_ext: idle: Make local functions static in ext_idle.c
Date: Tue, 30 Sep 2025 16:47:43 +0200
Message-ID: <20250930143836.777200570@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

commit 353656eb84fef8ffece3b1be4345cbacbbb5267f upstream.

Functions that are only used within ext_idle.c can be marked as static
to limit their scope.

No functional changes.

Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext_idle.c |   24 +++++++++++++++++-------
 kernel/sched/ext_idle.h |    7 -------
 2 files changed, 17 insertions(+), 14 deletions(-)

--- a/kernel/sched/ext_idle.c
+++ b/kernel/sched/ext_idle.c
@@ -75,7 +75,7 @@ static int scx_cpu_node_if_enabled(int c
 	return cpu_to_node(cpu);
 }
 
-bool scx_idle_test_and_clear_cpu(int cpu)
+static bool scx_idle_test_and_clear_cpu(int cpu)
 {
 	int node = scx_cpu_node_if_enabled(cpu);
 	struct cpumask *idle_cpus = idle_cpumask(node)->cpu;
@@ -198,7 +198,7 @@ pick_idle_cpu_from_online_nodes(const st
 /*
  * Find an idle CPU in the system, starting from @node.
  */
-s32 scx_pick_idle_cpu(const struct cpumask *cpus_allowed, int node, u64 flags)
+static s32 scx_pick_idle_cpu(const struct cpumask *cpus_allowed, int node, u64 flags)
 {
 	s32 cpu;
 
@@ -794,6 +794,16 @@ static void reset_idle_masks(struct sche
 		cpumask_and(idle_cpumask(node)->smt, cpu_online_mask, node_mask);
 	}
 }
+#else	/* !CONFIG_SMP */
+static bool scx_idle_test_and_clear_cpu(int cpu)
+{
+	return -EBUSY;
+}
+
+static s32 scx_pick_idle_cpu(const struct cpumask *cpus_allowed, int node, u64 flags)
+{
+	return -EBUSY;
+}
 #endif	/* CONFIG_SMP */
 
 void scx_idle_enable(struct sched_ext_ops *ops)
@@ -860,8 +870,8 @@ static bool check_builtin_idle_enabled(v
 	return false;
 }
 
-s32 select_cpu_from_kfunc(struct task_struct *p, s32 prev_cpu, u64 wake_flags,
-			  const struct cpumask *allowed, u64 flags)
+static s32 select_cpu_from_kfunc(struct task_struct *p, s32 prev_cpu, u64 wake_flags,
+				 const struct cpumask *allowed, u64 flags)
 {
 	struct rq *rq;
 	struct rq_flags rf;
@@ -1125,10 +1135,10 @@ __bpf_kfunc bool scx_bpf_test_and_clear_
 	if (!check_builtin_idle_enabled())
 		return false;
 
-	if (kf_cpu_valid(cpu, NULL))
-		return scx_idle_test_and_clear_cpu(cpu);
-	else
+	if (!kf_cpu_valid(cpu, NULL))
 		return false;
+
+	return scx_idle_test_and_clear_cpu(cpu);
 }
 
 /**
--- a/kernel/sched/ext_idle.h
+++ b/kernel/sched/ext_idle.h
@@ -15,16 +15,9 @@ struct sched_ext_ops;
 #ifdef CONFIG_SMP
 void scx_idle_update_selcpu_topology(struct sched_ext_ops *ops);
 void scx_idle_init_masks(void);
-bool scx_idle_test_and_clear_cpu(int cpu);
-s32 scx_pick_idle_cpu(const struct cpumask *cpus_allowed, int node, u64 flags);
 #else /* !CONFIG_SMP */
 static inline void scx_idle_update_selcpu_topology(struct sched_ext_ops *ops) {}
 static inline void scx_idle_init_masks(void) {}
-static inline bool scx_idle_test_and_clear_cpu(int cpu) { return false; }
-static inline s32 scx_pick_idle_cpu(const struct cpumask *cpus_allowed, int node, u64 flags)
-{
-	return -EBUSY;
-}
 #endif /* CONFIG_SMP */
 
 s32 scx_select_cpu_dfl(struct task_struct *p, s32 prev_cpu, u64 wake_flags,


