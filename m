Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216663;
	b=1ALNR0RiozOVLiVNInrvtBRqXy0Ny3HojJqW452ov//Kc50Od/edi6yGEtRmqlyOUnBz
	 Y37r01xIzPqyqwSTKBVbQfnyOoIB4f4c91F7Ls1eEMGBS6k6WcpCXxuUH86LUKw0j8KAv
	 ML1Tx3O7KRfjN4aBCEIP+4RXssIkbwl1+Vz9aX38chmFwiWG9gBZzBUGp4yDH/HA8YAYt
	 BE7ZiQLeu8L2UjwMm/kkRWxXravn2joIA0uSHRVVmPMvf89L0YfJ6am5ncsVDd4PuH5Fy
	 hX4T0j2FcI8DqrP4dqzSdLf6WIfa9gtIAvFwFoIRG7wgwrI3JwUPS+9mhCmGmb/JRQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MuZfzx9CuURTz0fqPI/MTx1GbfJn4QnnbMWC90iTKO4=;
	b=zWu9FBZ3kOVDSjM74/9LVLqDpRK/p0/23bLr6Z1dOWplcaq1fPB7DUgjVoowGOW4Dj0v
	 e6OGveseNvrRgIFVbQjrLTdj899RQkD0UwSqbwfQ8lfaO7EQhuLLHrqqxu5erwEwaWXGs
	 j/I0xHk5p6QKFgP7Wmy7BfzH5ik0c/JuJFmBcaITzV7y2iPt12eemgSR/absD6GPvx+dF
	 EjCDKT+i230IHOw8Q4DX+QAHDmvYZnQzJo9+95dzniptZyYpJaMINaeShIhaYUVAo4h9v
	 24MeKEEMSZDQ+EUKzthWdeHbT02SUEyHm/6ZBmYtR8v76JIdaHW/VDO9kwAzjuyOM7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iDNz6jvU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E728B606A31A;
	Wed, 28 Oct 2026 19:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iDNz6jvU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EB71F01825;
	Wed, 28 Oct 2026 19:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216662;
	bh=MuZfzx9CuURTz0fqPI/MTx1GbfJn4QnnbMWC90iTKO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDNz6jvUyw4pHMw55wMnedCwjOsqbBeJhcPxLj6nvRwLWSbrHHEgj0O23aHHWn4Jq
	 0xdMoBz+uaBqb9bzThFLwozIvQIBiOVzxIuUf5Dws3h/RF/zFmwmQRQ/aDWy+UDrto
	 dmD7j6RE/Dw67Y9lRxBXPPEvjKbJOC4Bzs/YWcVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1634/1887] cgroup/cpuset: move common code to cpuset-internal.h
Date: Wed, 28 Oct 2026 18:02:10 +0100
Message-ID: <20261028170536.651166128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit 619a33efa0b0cd566f928d60d128033673e478cf ]

Move some declarations that will be used for cpuset v1 and v2,
including 'cpuset struct', 'cpuset_flagbits_t', cpuset_filetype_t,etc.
No logical change.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>

Adapted to this tree: the moved cpuset struct, file type enum and error
code enum follow the definitions already present here, and the include
removals in cpuset.c are skipped.

Stable-dep-of: 95220e1f18f6 ("cgroup/cpuset: Make nr_deadline_tasks an atomic_t")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset-internal.h | 216 ++++++++++++++++++++++++++++++++
 kernel/cgroup/cpuset.c          | 212 +------------------------------
 2 files changed, 217 insertions(+), 211 deletions(-)

diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 034de3cbf3add..f8e300ed0c34d 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -3,4 +3,220 @@
 #ifndef __CPUSET_INTERNAL_H
 #define __CPUSET_INTERNAL_H
 
+#include <linux/cpumask.h>
+#include <linux/spinlock.h>
+#include <linux/cpuset.h>
+#include <linux/cgroup.h>
+
+/* See "Frequency meter" comments, below. */
+
+struct fmeter {
+	int cnt;		/* unprocessed events count */
+	int val;		/* most recent output value */
+	time64_t time;		/* clock (secs) when val computed */
+	spinlock_t lock;	/* guards read or write of above */
+};
+
+/*
+ * Invalid partition error code
+ */
+enum prs_errcode {
+	PERR_NONE = 0,
+	PERR_INVCPUS,
+	PERR_INVPARENT,
+	PERR_NOTPART,
+	PERR_NOTEXCL,
+	PERR_NOCPUS,
+	PERR_HOTPLUG,
+	PERR_CPUSEMPTY,
+};
+
+/* bits in struct cpuset flags field */
+typedef enum {
+	CS_ONLINE,
+	CS_CPU_EXCLUSIVE,
+	CS_MEM_EXCLUSIVE,
+	CS_MEM_HARDWALL,
+	CS_MEMORY_MIGRATE,
+	CS_SCHED_LOAD_BALANCE,
+	CS_SPREAD_PAGE,
+	CS_SPREAD_SLAB,
+} cpuset_flagbits_t;
+
+/* The various types of files and directories in a cpuset file system */
+
+typedef enum {
+	FILE_MEMORY_MIGRATE,
+	FILE_CPULIST,
+	FILE_MEMLIST,
+	FILE_EFFECTIVE_CPULIST,
+	FILE_EFFECTIVE_MEMLIST,
+	FILE_SUBPARTS_CPULIST,
+	FILE_CPU_EXCLUSIVE,
+	FILE_MEM_EXCLUSIVE,
+	FILE_MEM_HARDWALL,
+	FILE_SCHED_LOAD_BALANCE,
+	FILE_PARTITION_ROOT,
+	FILE_SCHED_RELAX_DOMAIN_LEVEL,
+	FILE_MEMORY_PRESSURE_ENABLED,
+	FILE_MEMORY_PRESSURE,
+	FILE_SPREAD_PAGE,
+	FILE_SPREAD_SLAB,
+} cpuset_filetype_t;
+
+struct cpuset {
+	struct cgroup_subsys_state css;
+
+	unsigned long flags;		/* "unsigned long" so bitops work */
+
+	/*
+	 * On default hierarchy:
+	 *
+	 * The user-configured masks can only be changed by writing to
+	 * cpuset.cpus and cpuset.mems, and won't be limited by the
+	 * parent masks.
+	 *
+	 * The effective masks is the real masks that apply to the tasks
+	 * in the cpuset. They may be changed if the configured masks are
+	 * changed or hotplug happens.
+	 *
+	 * effective_mask == configured_mask & parent's effective_mask,
+	 * and if it ends up empty, it will inherit the parent's mask.
+	 *
+	 *
+	 * On legacy hierarchy:
+	 *
+	 * The user-configured masks are always the same with effective masks.
+	 */
+
+	/* user-configured CPUs and Memory Nodes allow to tasks */
+	cpumask_var_t cpus_allowed;
+	nodemask_t mems_allowed;
+
+	/* effective CPUs and Memory Nodes allow to tasks */
+	cpumask_var_t effective_cpus;
+	nodemask_t effective_mems;
+
+	/*
+	 * CPUs allocated to child sub-partitions (default hierarchy only)
+	 * - CPUs granted by the parent = effective_cpus U subparts_cpus
+	 * - effective_cpus and subparts_cpus are mutually exclusive.
+	 *
+	 * effective_cpus contains only onlined CPUs, but subparts_cpus
+	 * may have offlined ones.
+	 */
+	cpumask_var_t subparts_cpus;
+
+	/*
+	 * This is old Memory Nodes tasks took on.
+	 *
+	 * - top_cpuset.old_mems_allowed is initialized to mems_allowed.
+	 * - A new cpuset's old_mems_allowed is initialized when some
+	 *   task is moved into it.
+	 * - old_mems_allowed is used in cpuset_migrate_mm() when we change
+	 *   cpuset.mems_allowed and have tasks' nodemask updated, and
+	 *   then old_mems_allowed is updated to mems_allowed.
+	 */
+	nodemask_t old_mems_allowed;
+
+	struct fmeter fmeter;		/* memory_pressure filter */
+
+	/*
+	 * Tasks are being attached to this cpuset.  Used to prevent
+	 * zeroing cpus/mems_allowed between ->can_attach() and ->attach().
+	 */
+	int attach_in_progress;
+
+	/* partition number for rebuild_sched_domains() */
+	int pn;
+
+	/* for custom sched domain */
+	int relax_domain_level;
+
+	/* number of CPUs in subparts_cpus */
+	int nr_subparts_cpus;
+
+	/* partition root state */
+	int partition_root_state;
+
+	/*
+	 * Default hierarchy only:
+	 * use_parent_ecpus - set if using parent's effective_cpus
+	 * child_ecpus_count - # of children with use_parent_ecpus set
+	 */
+	int use_parent_ecpus;
+	int child_ecpus_count;
+
+	/*
+	 * number of SCHED_DEADLINE tasks attached to this cpuset, so that we
+	 * know when to rebuild associated root domain bandwidth information.
+	 */
+	int nr_deadline_tasks;
+	int nr_migrate_dl_tasks;
+	u64 sum_migrate_dl_bw;
+
+	/* Invalid partition error code, not lock protected */
+	enum prs_errcode prs_err;
+
+	/* Handle for cpuset.cpus.partition */
+	struct cgroup_file partition_file;
+};
+
+static inline struct cpuset *css_cs(struct cgroup_subsys_state *css)
+{
+	return css ? container_of(css, struct cpuset, css) : NULL;
+}
+
+/* Retrieve the cpuset for a task */
+static inline struct cpuset *task_cs(struct task_struct *task)
+{
+	return css_cs(task_css(task, cpuset_cgrp_id));
+}
+
+static inline struct cpuset *parent_cs(struct cpuset *cs)
+{
+	return css_cs(cs->css.parent);
+}
+
+/* convenient tests for these bits */
+static inline bool is_cpuset_online(struct cpuset *cs)
+{
+	return test_bit(CS_ONLINE, &cs->flags) && !css_is_dying(&cs->css);
+}
+
+static inline int is_cpu_exclusive(const struct cpuset *cs)
+{
+	return test_bit(CS_CPU_EXCLUSIVE, &cs->flags);
+}
+
+static inline int is_mem_exclusive(const struct cpuset *cs)
+{
+	return test_bit(CS_MEM_EXCLUSIVE, &cs->flags);
+}
+
+static inline int is_mem_hardwall(const struct cpuset *cs)
+{
+	return test_bit(CS_MEM_HARDWALL, &cs->flags);
+}
+
+static inline int is_sched_load_balance(const struct cpuset *cs)
+{
+	return test_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+}
+
+static inline int is_memory_migrate(const struct cpuset *cs)
+{
+	return test_bit(CS_MEMORY_MIGRATE, &cs->flags);
+}
+
+static inline int is_spread_page(const struct cpuset *cs)
+{
+	return test_bit(CS_SPREAD_PAGE, &cs->flags);
+}
+
+static inline int is_spread_slab(const struct cpuset *cs)
+{
+	return test_bit(CS_SPREAD_SLAB, &cs->flags);
+}
+
 #endif /* __CPUSET_INTERNAL_H */
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7123bb020a242..2700e6a1307b7 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -22,6 +22,7 @@
  *  distribution for more details.
  */
 #include "cgroup-internal.h"
+#include "cpuset-internal.h"
 
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
@@ -78,29 +79,6 @@ DEFINE_STATIC_KEY_FALSE(cpusets_enabled_key);
  */
 DEFINE_STATIC_KEY_FALSE(cpusets_insane_config_key);
 
-/* See "Frequency meter" comments, below. */
-
-struct fmeter {
-	int cnt;		/* unprocessed events count */
-	int val;		/* most recent output value */
-	time64_t time;		/* clock (secs) when val computed */
-	spinlock_t lock;	/* guards read or write of above */
-};
-
-/*
- * Invalid partition error code
- */
-enum prs_errcode {
-	PERR_NONE = 0,
-	PERR_INVCPUS,
-	PERR_INVPARENT,
-	PERR_NOTPART,
-	PERR_NOTEXCL,
-	PERR_NOCPUS,
-	PERR_HOTPLUG,
-	PERR_CPUSEMPTY,
-};
-
 static const char * const perr_strings[] = {
 	[PERR_INVCPUS]   = "Invalid cpu list in cpuset.cpus",
 	[PERR_INVPARENT] = "Parent is an invalid partition root",
@@ -111,104 +89,6 @@ static const char * const perr_strings[] = {
 	[PERR_CPUSEMPTY] = "cpuset.cpus is empty",
 };
 
-struct cpuset {
-	struct cgroup_subsys_state css;
-
-	unsigned long flags;		/* "unsigned long" so bitops work */
-
-	/*
-	 * On default hierarchy:
-	 *
-	 * The user-configured masks can only be changed by writing to
-	 * cpuset.cpus and cpuset.mems, and won't be limited by the
-	 * parent masks.
-	 *
-	 * The effective masks is the real masks that apply to the tasks
-	 * in the cpuset. They may be changed if the configured masks are
-	 * changed or hotplug happens.
-	 *
-	 * effective_mask == configured_mask & parent's effective_mask,
-	 * and if it ends up empty, it will inherit the parent's mask.
-	 *
-	 *
-	 * On legacy hierarchy:
-	 *
-	 * The user-configured masks are always the same with effective masks.
-	 */
-
-	/* user-configured CPUs and Memory Nodes allow to tasks */
-	cpumask_var_t cpus_allowed;
-	nodemask_t mems_allowed;
-
-	/* effective CPUs and Memory Nodes allow to tasks */
-	cpumask_var_t effective_cpus;
-	nodemask_t effective_mems;
-
-	/*
-	 * CPUs allocated to child sub-partitions (default hierarchy only)
-	 * - CPUs granted by the parent = effective_cpus U subparts_cpus
-	 * - effective_cpus and subparts_cpus are mutually exclusive.
-	 *
-	 * effective_cpus contains only onlined CPUs, but subparts_cpus
-	 * may have offlined ones.
-	 */
-	cpumask_var_t subparts_cpus;
-
-	/*
-	 * This is old Memory Nodes tasks took on.
-	 *
-	 * - top_cpuset.old_mems_allowed is initialized to mems_allowed.
-	 * - A new cpuset's old_mems_allowed is initialized when some
-	 *   task is moved into it.
-	 * - old_mems_allowed is used in cpuset_migrate_mm() when we change
-	 *   cpuset.mems_allowed and have tasks' nodemask updated, and
-	 *   then old_mems_allowed is updated to mems_allowed.
-	 */
-	nodemask_t old_mems_allowed;
-
-	struct fmeter fmeter;		/* memory_pressure filter */
-
-	/*
-	 * Tasks are being attached to this cpuset.  Used to prevent
-	 * zeroing cpus/mems_allowed between ->can_attach() and ->attach().
-	 */
-	int attach_in_progress;
-
-	/* partition number for rebuild_sched_domains() */
-	int pn;
-
-	/* for custom sched domain */
-	int relax_domain_level;
-
-	/* number of CPUs in subparts_cpus */
-	int nr_subparts_cpus;
-
-	/* partition root state */
-	int partition_root_state;
-
-	/*
-	 * Default hierarchy only:
-	 * use_parent_ecpus - set if using parent's effective_cpus
-	 * child_ecpus_count - # of children with use_parent_ecpus set
-	 */
-	int use_parent_ecpus;
-	int child_ecpus_count;
-
-	/*
-	 * number of SCHED_DEADLINE tasks attached to this cpuset, so that we
-	 * know when to rebuild associated root domain bandwidth information.
-	 */
-	int nr_deadline_tasks;
-	int nr_migrate_dl_tasks;
-	u64 sum_migrate_dl_bw;
-
-	/* Invalid partition error code, not lock protected */
-	enum prs_errcode prs_err;
-
-	/* Handle for cpuset.cpus.partition */
-	struct cgroup_file partition_file;
-};
-
 /*
  * Partition root states:
  *
@@ -238,22 +118,6 @@ struct tmpmasks {
 	cpumask_var_t new_cpus;		/* For update_cpumasks_hier() */
 };
 
-static inline struct cpuset *css_cs(struct cgroup_subsys_state *css)
-{
-	return css ? container_of(css, struct cpuset, css) : NULL;
-}
-
-/* Retrieve the cpuset for a task */
-static inline struct cpuset *task_cs(struct task_struct *task)
-{
-	return css_cs(task_css(task, cpuset_cgrp_id));
-}
-
-static inline struct cpuset *parent_cs(struct cpuset *cs)
-{
-	return css_cs(cs->css.parent);
-}
-
 void inc_dl_tasks_cs(struct task_struct *p)
 {
 	struct cpuset *cs = task_cs(p);
@@ -268,59 +132,6 @@ void dec_dl_tasks_cs(struct task_struct *p)
 	cs->nr_deadline_tasks--;
 }
 
-/* bits in struct cpuset flags field */
-typedef enum {
-	CS_ONLINE,
-	CS_CPU_EXCLUSIVE,
-	CS_MEM_EXCLUSIVE,
-	CS_MEM_HARDWALL,
-	CS_MEMORY_MIGRATE,
-	CS_SCHED_LOAD_BALANCE,
-	CS_SPREAD_PAGE,
-	CS_SPREAD_SLAB,
-} cpuset_flagbits_t;
-
-/* convenient tests for these bits */
-static inline bool is_cpuset_online(struct cpuset *cs)
-{
-	return test_bit(CS_ONLINE, &cs->flags) && !css_is_dying(&cs->css);
-}
-
-static inline int is_cpu_exclusive(const struct cpuset *cs)
-{
-	return test_bit(CS_CPU_EXCLUSIVE, &cs->flags);
-}
-
-static inline int is_mem_exclusive(const struct cpuset *cs)
-{
-	return test_bit(CS_MEM_EXCLUSIVE, &cs->flags);
-}
-
-static inline int is_mem_hardwall(const struct cpuset *cs)
-{
-	return test_bit(CS_MEM_HARDWALL, &cs->flags);
-}
-
-static inline int is_sched_load_balance(const struct cpuset *cs)
-{
-	return test_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
-}
-
-static inline int is_memory_migrate(const struct cpuset *cs)
-{
-	return test_bit(CS_MEMORY_MIGRATE, &cs->flags);
-}
-
-static inline int is_spread_page(const struct cpuset *cs)
-{
-	return test_bit(CS_SPREAD_PAGE, &cs->flags);
-}
-
-static inline int is_spread_slab(const struct cpuset *cs)
-{
-	return test_bit(CS_SPREAD_SLAB, &cs->flags);
-}
-
 static inline int is_partition_valid(const struct cpuset *cs)
 {
 	return cs->partition_root_state > 0;
@@ -2716,27 +2527,6 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	mutex_unlock(&cpuset_mutex);
 }
 
-/* The various types of files and directories in a cpuset file system */
-
-typedef enum {
-	FILE_MEMORY_MIGRATE,
-	FILE_CPULIST,
-	FILE_MEMLIST,
-	FILE_EFFECTIVE_CPULIST,
-	FILE_EFFECTIVE_MEMLIST,
-	FILE_SUBPARTS_CPULIST,
-	FILE_CPU_EXCLUSIVE,
-	FILE_MEM_EXCLUSIVE,
-	FILE_MEM_HARDWALL,
-	FILE_SCHED_LOAD_BALANCE,
-	FILE_PARTITION_ROOT,
-	FILE_SCHED_RELAX_DOMAIN_LEVEL,
-	FILE_MEMORY_PRESSURE_ENABLED,
-	FILE_MEMORY_PRESSURE,
-	FILE_SPREAD_PAGE,
-	FILE_SPREAD_SLAB,
-} cpuset_filetype_t;
-
 static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 			    u64 val)
 {
-- 
2.53.0



