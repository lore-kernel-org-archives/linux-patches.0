Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199986;
	b=WnkUa9Da7gcM4TUBNw/7aB2QZ3YvkxJcajPfOJ7Bw4B4PzIXBIZhuq+YUbjjsia+m0lq
	 ZU6qCPF2uvbsNmPC30ZloxdgZzHocH0SzwNRUX7JAXvHld9cNwVq1CCfqk8gq0hqLXBE/
	 7A8uaqUHWesdkGszuytBGEOUc2CtKH4sB67av6nklYw+PwokW6Mnw4Cl6Wqcv0DeuLSr+
	 pCJkZagSIUrfsHuDRIe+Ra+TVFef2yAg1FeRyzdGSYZ4m/dE7oTlO1OdJkdgTFF3p5i/q
	 0Pw3lWKEdTrWdxMqti96dLX6TJAufjrjlAKBu4lLLBGlGzYR8Cfc2Mv6+YpaPW3H+qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199986;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GCc6FMGDt7ajCqVzDVfnvWK7RnujE3EoWW2vegspg0s=;
	b=Vx/o6+mkOXOMoEArYfOfHaGfXMvA3ZVCseOrKEeB7P2TSCzwSZ68C9f3YZNl1UeSLs+2
	 bOQzI0P3/QgHkffRFH1p7YRoFgilRsm0WzNGrNVqVCgxjz3+KNCdG1+3Tv7wgH+E93szN
	 IT+aMXo1x3Kqjqa1McGZrXmWN3B2TRy5zibjz6uiiz2lmV8fhcmJOThu7XyYBOfCmuPt+
	 Kb91NS2ACMzOpMie6HMTfPF4GQhAQrPi0AJ4rfGw3AQ/pD9+M3HZ8QUV5H9xDxYpZs1BH
	 8s1XnRfK5xF87AlBrdNE618u58Y9VoVAWcPhzb5dW9oO6JcmvknMpFkjVYIaOcPZyKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CZA95BQP;
	arc=none smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C9E60A261E
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 18:39:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41C9E60A261E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CZA95BQP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795199981; x=1826735981;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1dL6aXlYz0yRzNYuphh0tfaAWKCvv/mw7lzaNRZIq/8=;
  b=CZA95BQP+beho+c6cGMHb6TubEHihtkV2HKLIMg52jYZlS9gP6NGGuE7
   0Z0xc0c6WfmFoMUPk4EjK0V+GS9eTooDg1KsExmNGA9HF+pydZ7rJcgfJ
   sIXmOQMnICx7ppYgagnPY34rDaxWZMZPxxUoFBYhj3WsNNshvF09nWGA8
   nnJo97NHRKfIhl1wjN7saPp2csSsNlv9bPAMlr6oWmbCNdyo426Qvul3X
   xJJa5GGPYJhw8rlL43BeQ+lJIh6O6wVhbwE8YHOzMNoNQ/p7EVlF3wVoF
   aMxLYv5b9IfYDs+JbeDP673Mh9BrjL1qOAOn5uYT4VBaZs2JSJ3s+c+rc
   Q==;
X-CSE-ConnectionGUID: 6LPZBqwTTkyQsORHPW2yMg==
X-CSE-MsgGUID: jf8Y8q0TRcaZa+3Mt22pUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="3931830"
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="3931830"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:40 -0800
X-CSE-ConnectionGUID: MLb54DnqRsC9YOdVnHv6PQ==
X-CSE-MsgGUID: PDpUp96QRhu8vbGjLDHQgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="12590715"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:39 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com,
	tony.luck@intel.com,
	ben.horgan@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	jedrzej.wasiukiewicz@intel.com
Cc: fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [RFC PATCH 1/3] fork,arm,x86,fs/resctrl: Fix stale resource group assignment vs copy_process()
Date: Fri, 20 Nov 2026 10:39:30 -0800
Message-ID: <b2e13da64ca3e41207b5d46fb060bccefaf9fecd.1795197419.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795197419.git.reinette.chatre@intel.com>
References: <cover.1795197419.git.reinette.chatre@intel.com>
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

During fork a task's CLOSID and RMID are copied into the new task by
dup_task_struct(), early in copy_process() without holding tasklist_lock
or any lock that resctrl takes. The new task becomes visible to a walk of
the task list later in copy_process(), after it is linked onto the task
list while the tasklist_lock is held for write.

Removing a resource group moves all of its tasks to another group by
walking the task list while holding the tasklist_lock for read, and then
frees the CLOSID and RMID of the removed group. A task that copies its
parent's CLOSID and RMID before the walk reaches the parent is missed by
the walk: it is not on the task list yet, and it cannot get there while
the walk holds the tasklist_lock. By the time it is added to the task list
the CLOSID and RMID it was initialized with have been freed.

    CPU0                                CPU1
    ====                                ====

  fork()
    copy_process()
      dup_task_struct()
        /*
         * New task inherits the
         * parent's CLOSID and RMID.
         */
                                    rdtgroup_rmdir_{ctrl,mon}()
                                      rdt_move_group_tasks()
                                        read_lock(&tasklist_lock)
                                        for_each_process_thread()
                                          /*
                                           * Parent is moved out of
                                           * the group. New task is
                                           * not on the task list
                                           * and is not moved.
                                           */
      write_lock_irq(&tasklist_lock)
        /* Waits for the walk. */
                                        read_unlock(&tasklist_lock)
      /* Lock acquired. */
      list_add_tail_rcu(&p->tasks, ...)
      write_unlock_irq(&tasklist_lock)
                                      free_rmid()
                                      closid_free() /* ctrl only */

    New task and every task it creates use the freed CLOSID and RMID.
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The new task and every task it goes on to create keep using a CLOSID
and RMID that resctrl believes are unused. Once those identifiers are
handed to a resource group created later, the strays appear in that
group's tasks file, their memory accesses are counted in its monitoring
data, and they are subject to its allocation policy, while the group
intended for them does not control or monitor them.

Introduce resctrl_copy_process() to copy the parent's CLOSID and RMID
into the new task from copy_process(), while the tasklist_lock is held
for write. The walk holds the same lock for read for its full duration,
so the new task is either already on the task list and assigned by the
walk, or the copy happens after the walk completed and observes the
parent's new resource group.

resctrl_copy_process() reads two values that some architectures store
separately. __rdtgroup_move_task() assigns them with two stores while
holding only rdtgroup_mutex, which resctrl_copy_process() cannot take,
so those reads can fall between the two stores and leave the new task
with the CLOSID of one resource group and the RMID of another. Assign
them from __rdtgroup_move_task() while holding tasklist_lock for read
as well, so that resctrl_copy_process() observes both as intended.

Add an architecture call to perform the copy because CLOSID and RMID are
stored per architecture and cannot be read and written as independent
values on all of them.

Fixes: f3cbeacaa06e ("x86/intel_rdt/cqm: Add rmdir support")
Reported-by: Jedrzej Wasiukiewicz <jedrzej.wasiukiewicz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Note to MPAM maintainers:

resctrl_copy_process() runs on every fork(), so
resctrl_arch_copy_closid_rmid() is a static inline on x86. Doing so is
perhaps not required as fork() is already expensive.

Even so, I attempted doing same for MPAM but ended up with solutions
that do not seem ideal:

- A static inline in arch/arm64/include/asm/mpam.h, next to the other
  accessors of thread_info::mpam_partid_pmg. Nothing on the path from
  include/linux/resctrl.h reaches that header, so the definition is not
  visible to resctrl_copy_process(). Making it visible means
  arch/arm64/include/asm/resctrl.h has to include asm/mpam.h, which
  does not seem to match MPAM's intended design?

- A static inline in include/linux/arm_mpam.h, beside the
  resctrl_arch_*() inlines already there. asm/mpam.h includes
  linux/arm_mpam.h, so the reverse include would be circular and
  mpam_get_regval() cannot be called. The copy would have to read and
  write thread_info::mpam_partid_pmg directly, which no code outside
  asm/mpam.h does today, and would need a CONFIG_ARM64_MPAM guard
  because the field is only present when it is set.

The out-of-line definition this ended up with matches
resctrl_arch_sched_in(). Please let me know (if this is a change you
agree with) what kind of shape it needs to take for MPAM. We could also
just make x86 and MPAM both be out-of-line - doing so may not be felt by
the heavy copy_process().
---
 arch/arm64/include/asm/mpam.h  |  6 ++++++
 arch/x86/include/asm/resctrl.h |  7 +++++++
 drivers/resctrl/mpam_resctrl.c |  6 ++++++
 fs/resctrl/rdtgroup.c          | 21 +++++++++++++++++++++
 include/linux/arm_mpam.h       |  1 +
 include/linux/resctrl.h        | 28 ++++++++++++++++++++++++++++
 kernel/fork.c                  |  3 +++
 7 files changed, 72 insertions(+)

diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
index 70d396e7b6da..0746e5d7cc2d 100644
--- a/arch/arm64/include/asm/mpam.h
+++ b/arch/arm64/include/asm/mpam.h
@@ -63,6 +63,12 @@ static inline void mpam_set_task_partid_pmg(struct task_struct *tsk,
 	WRITE_ONCE(task_thread_info(tsk)->mpam_partid_pmg, regval);
 }
 
+static inline void mpam_copy_task_partid_pmg(struct task_struct *dst,
+					     struct task_struct *src)
+{
+	WRITE_ONCE(task_thread_info(dst)->mpam_partid_pmg, mpam_get_regval(src));
+}
+
 static inline void mpam_thread_switch(struct task_struct *tsk)
 {
 	u64 oldregval;
diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 8f6edcdcfd87..199ca9af0089 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -153,6 +153,13 @@ static inline void resctrl_arch_set_closid_rmid(struct task_struct *tsk,
 	WRITE_ONCE(tsk->rmid, rmid);
 }
 
+static inline void resctrl_arch_copy_closid_rmid(struct task_struct *dst,
+						 struct task_struct *src)
+{
+	WRITE_ONCE(dst->closid, READ_ONCE(src->closid));
+	WRITE_ONCE(dst->rmid, READ_ONCE(src->rmid));
+}
+
 static inline bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid)
 {
 	return READ_ONCE(tsk->closid) == closid;
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 5468367776e2..7aea58fca85b 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -345,6 +345,12 @@ void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid)
 	}
 }
 
+void resctrl_arch_copy_closid_rmid(struct task_struct *dst,
+				   struct task_struct *src)
+{
+	mpam_copy_task_partid_pmg(dst, src);
+}
+
 bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid)
 {
 	u64 regval = mpam_get_regval(tsk);
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 57ab090072c2..ebf780fc5fe9 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -657,12 +657,28 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
 		return -EINVAL;
 	}
 
+	/*
+	 * Hold tasklist_lock for read so that resctrl_copy_process(), which
+	 * holds it for write, cannot read the CLOSID and the RMID of @tsk
+	 * while only one of the two has been updated.
+	 *
+	 * Hold tasklist_lock just for the @tsk update. A CPU running @tsk
+	 * keeps using the CLOSID and RMID that resctrl_arch_sched_in()
+	 * applied when @tsk was last scheduled in, so
+	 * update_task_closid_rmid() below has to interrupt that CPU for the
+	 * new resource group to take effect. Leave that until after
+	 * tasklist_lock has been dropped: a CPU waiting for tasklist_lock
+	 * for write waits with interrupts disabled, and @tsk's CPU is the
+	 * one that may be waiting, because @tsk may be forking.
+	 */
+	read_lock(&tasklist_lock);
 	if (rdtgrp->type == RDTMON_GROUP)
 		resctrl_arch_set_closid_rmid(tsk, rdtgrp->mon.parent->closid,
 					     rdtgrp->mon.rmid);
 	else
 		resctrl_arch_set_closid_rmid(tsk, rdtgrp->closid,
 					     rdtgrp->mon.rmid);
+	read_unlock(&tasklist_lock);
 
 	/*
 	 * Ensure the task's closid and rmid are written before determining if
@@ -2959,6 +2975,11 @@ static void schemata_list_destroy(void)
  * If @mask is not NULL the cpus on which moved tasks are running are set
  * in that mask so the update smp function call is restricted to affected
  * cpus.
+ *
+ * Tasks created while this walks the task list are handled by
+ * resctrl_copy_process(), which tasklist_lock serializes against this walk.
+ * A new task is either visible to the walk and moved with the others, or
+ * resctrl_copy_process() assigns it after the walk completes.
  */
 static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
 				 struct cpumask *mask)
diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
index 002f56e15362..b605e9771c32 100644
--- a/include/linux/arm_mpam.h
+++ b/include/linux/arm_mpam.h
@@ -56,6 +56,7 @@ bool resctrl_arch_mon_capable(void);
 void resctrl_arch_set_cpu_default_closid(int cpu, u32 closid);
 void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
 void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid, u32 rmid);
+void resctrl_arch_copy_closid_rmid(struct task_struct *dst, struct task_struct *src);
 void resctrl_arch_sched_in(struct task_struct *tsk);
 bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid);
 bool resctrl_arch_match_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 10dfdca7f4bf..32d8bf9ca9ba 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -7,6 +7,8 @@
 #include <linux/list.h>
 #include <linux/pid.h>
 #include <linux/resctrl_types.h>
+#include <linux/sched.h>
+#include <linux/sched/task.h>
 
 #ifdef CONFIG_ARCH_HAS_CPU_RESCTRL
 #include <asm/resctrl.h>
@@ -729,6 +731,32 @@ extern unsigned int resctrl_rmid_realloc_limit;
 int resctrl_init(void);
 void resctrl_exit(void);
 
+#ifdef CONFIG_RESCTRL_FS
+/**
+ * resctrl_copy_process() - Give a new task the resource group of its parent.
+ * @child:	The new task, which is not yet on the task list.
+ *
+ * Call from copy_process() while tasklist_lock is held for write. Serialized
+ * against rdt_move_group_tasks() and __rdtgroup_move_task() that hold
+ * tasklist_lock for read.
+ *
+ * dup_task_struct() copies the parent's CLOSID and RMID into @child before
+ * @child is linked onto the task list. If the parent is moved out of a
+ * resource group that is being removed, that group's CLOSID and RMID are
+ * freed once the walk completes, leaving @child with stale assignments.
+ *
+ * Bring @child up to date with the parent.
+ */
+static inline void resctrl_copy_process(struct task_struct *child)
+{
+	lockdep_assert_held_write(&tasklist_lock);
+
+	resctrl_arch_copy_closid_rmid(child, current);
+}
+#else
+static inline void resctrl_copy_process(struct task_struct *child) { }
+#endif
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 u64 resctrl_arch_get_prefetch_disable_bits(void);
 int resctrl_arch_pseudo_lock_fn(void *_plr);
diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a7..8344e0d27b78 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -105,6 +105,7 @@
 #include <linux/stackprotector.h>
 #include <linux/user_events.h>
 #include <linux/iommu.h>
+#include <linux/resctrl.h>
 #include <linux/rseq.h>
 #include <uapi/linux/pidfd.h>
 #include <linux/pidfs.h>
@@ -2491,6 +2492,8 @@ __latent_entropy struct task_struct *copy_process(
 
 	klp_copy_process(p);
 
+	resctrl_copy_process(p);
+
 	sched_core_fork(p);
 
 	spin_lock(&current->sighand->siglock);
-- 
2.56.0

