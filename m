Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795443291;
	b=3Zm2t9W0+2yUMf0NjcsCWmPtU3fbqRkyIkOpH0BIJ1lCx7BM4utziuC/RdMHH4i8UtRA
	 N3EA8XcUXsAPXD6w+eaXLM7unBGBCkNmBnsJUzKp5T2XVPEEA0zZbL4r3dcXIuyb859fC
	 G//4Fs8sEYeOQVHyxuUt2NdGO0+DYq4mbKq6vZa4zOAOp+Bj3hhyf8+SRwJsppP6jCxij
	 bTrfIl4zIL/rJfQgBKwkzqxfXaz8bdXW5xFnjwZpViFs77p4lpGu5ZXL4TlHsZxKwpNLT
	 1dfLn3p4gop16nMj4rJpQ/YGOAvwdDxms53a2n0seFmTjKPmX4uxG8Lfugj9e7wlncQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443291;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=BzWlJypFH0JBdyX3v3gI3tSAws9JaPsiAy4GuzyD5ZA=;
	b=1/gJlVfc3FEe/9V3CYcFMU8uBpjbgphCBxToxnBXxxk3jq2QEQE1IaSqqHV38WqSnQbu
	 CA0AFFmqv1ef5SSrqaeEDFJJtWG4ggbr+1kwXnI5r/5TBWkJss4GmAJmijwUhHxke/hzh
	 t2PNPKLjJTwF42CxE00vbeRhLa+NltpqVrvyhejoe6Sx2y4lGzP0bZxe0dj1Kp2GXDWSn
	 e/RpC0+8QQ/+GLITDd2cb3SksyJX3GlMZyY0avWUT0Bsrhp8V5Y39dRnZWQH9wWXfMH78
	 WH5ilzuQ7g2ZJ39nmgaSR2oxlu7C+8rKYduEQHH1xsiEm/gZBp7p0vGvfcKldJcpweA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=TpQZw53a;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55327606A321
	for <patches@lists.linux.dev>; Mon, 23 Nov 2026 14:14:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55327606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=TpQZw53a
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6767D143D;
	Mon, 23 Nov 2026 06:14:46 -0800 (PST)
Received: from [10.211.55.3] (unknown [10.57.19.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 85C483F632;
	Mon, 23 Nov 2026 06:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795443289; bh=13+dL+2yU1ST0Gj3ZErbeUJoSIXiq2YVvfbO1TbDWFQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TpQZw53aO4s2CGwpt4CspTd4evdvoct8/Xd6AMv3lVDPfLwuP1n9VgLyar/Yv0L1g
	 i8auUfjTyeM5tev+x0ZUJ8vhTZIinVGgUt/LwpuaOjG66TyqxN0O1hfPIueITCccsB
	 yj4Mzrg8OqqUI0kueXe6Fz3NArQudEjfPYlEiKJQ=
Message-ID: <17fe3497-b887-4dc1-a8f8-3b647c1880a6@arm.com>
Date: Mon, 23 Nov 2026 14:14:40 +0000
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [RFC PATCH 1/3] fork,arm,x86,fs/resctrl: Fix stale resource group
 assignment vs copy_process()
To: Reinette Chatre <reinette.chatre@intel.com>, kees@kernel.org,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, bp@alien8.de, tglx@linutronix.de,
 dave.hansen@linux.intel.com, tony.luck@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, babu.moger@amd.com, fustini@kernel.org,
 jedrzej.wasiukiewicz@intel.com
Cc: fenghuay@nvidia.com, peternewman@google.com, yu.c.chen@intel.com,
 x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <cover.1795197419.git.reinette.chatre@intel.com>
 <b2e13da64ca3e41207b5d46fb060bccefaf9fecd.1795197419.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <b2e13da64ca3e41207b5d46fb060bccefaf9fecd.1795197419.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 20/11/2026 18:39, Reinette Chatre wrote:
> During fork a task's CLOSID and RMID are copied into the new task by
> dup_task_struct(), early in copy_process() without holding tasklist_lock
> or any lock that resctrl takes. The new task becomes visible to a walk of
> the task list later in copy_process(), after it is linked onto the task
> list while the tasklist_lock is held for write.
> 
> Removing a resource group moves all of its tasks to another group by
> walking the task list while holding the tasklist_lock for read, and then
> frees the CLOSID and RMID of the removed group. A task that copies its
> parent's CLOSID and RMID before the walk reaches the parent is missed by
> the walk: it is not on the task list yet, and it cannot get there while
> the walk holds the tasklist_lock. By the time it is added to the task list
> the CLOSID and RMID it was initialized with have been freed.
> 
>     CPU0                                CPU1
>     ====                                ====
> 
>   fork()
>     copy_process()
>       dup_task_struct()
>         /*
>          * New task inherits the
>          * parent's CLOSID and RMID.
>          */
>                                     rdtgroup_rmdir_{ctrl,mon}()
>                                       rdt_move_group_tasks()
>                                         read_lock(&tasklist_lock)
>                                         for_each_process_thread()
>                                           /*
>                                            * Parent is moved out of
>                                            * the group. New task is
>                                            * not on the task list
>                                            * and is not moved.
>                                            */
>       write_lock_irq(&tasklist_lock)
>         /* Waits for the walk. */
>                                         read_unlock(&tasklist_lock)
>       /* Lock acquired. */
>       list_add_tail_rcu(&p->tasks, ...)
>       write_unlock_irq(&tasklist_lock)
>                                       free_rmid()
>                                       closid_free() /* ctrl only */
> 
>     New task and every task it creates use the freed CLOSID and RMID.
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> The new task and every task it goes on to create keep using a CLOSID
> and RMID that resctrl believes are unused. Once those identifiers are
> handed to a resource group created later, the strays appear in that
> group's tasks file, their memory accesses are counted in its monitoring
> data, and they are subject to its allocation policy, while the group
> intended for them does not control or monitor them.
> 
> Introduce resctrl_copy_process() to copy the parent's CLOSID and RMID
> into the new task from copy_process(), while the tasklist_lock is held
> for write. The walk holds the same lock for read for its full duration,
> so the new task is either already on the task list and assigned by the
> walk, or the copy happens after the walk completed and observes the
> parent's new resource group.
> 
> resctrl_copy_process() reads two values that some architectures store
> separately. __rdtgroup_move_task() assigns them with two stores while
> holding only rdtgroup_mutex, which resctrl_copy_process() cannot take,
> so those reads can fall between the two stores and leave the new task
> with the CLOSID of one resource group and the RMID of another. Assign
> them from __rdtgroup_move_task() while holding tasklist_lock for read
> as well, so that resctrl_copy_process() observes both as intended.
> 
> Add an architecture call to perform the copy because CLOSID and RMID are
> stored per architecture and cannot be read and written as independent
> values on all of them.
> 
> Fixes: f3cbeacaa06e ("x86/intel_rdt/cqm: Add rmdir support")
> Reported-by: Jedrzej Wasiukiewicz <jedrzej.wasiukiewicz@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Note to MPAM maintainers:
> 
> resctrl_copy_process() runs on every fork(), so
> resctrl_arch_copy_closid_rmid() is a static inline on x86. Doing so is
> perhaps not required as fork() is already expensive.
> 
> Even so, I attempted doing same for MPAM but ended up with solutions
> that do not seem ideal:

Thanks for considering MPAM so carefully.

> 
> - A static inline in arch/arm64/include/asm/mpam.h, next to the other
>   accessors of thread_info::mpam_partid_pmg. Nothing on the path from
>   include/linux/resctrl.h reaches that header, so the definition is not
>   visible to resctrl_copy_process(). Making it visible means
>   arch/arm64/include/asm/resctrl.h has to include asm/mpam.h, which
>   does not seem to match MPAM's intended design?
> 
> - A static inline in include/linux/arm_mpam.h, beside the
>   resctrl_arch_*() inlines already there. asm/mpam.h includes
>   linux/arm_mpam.h, so the reverse include would be circular and

Hmm, the existing include of linux/arm_mpam.h appears to be unnecessary.
As such, that include can be removed and resctrl_arch_copy_closid_rmid()
could be a static inline in include/linux/arm_mpam.h.

Thanks,

Ben

>   mpam_get_regval() cannot be called. The copy would have to read and
>   write thread_info::mpam_partid_pmg directly, which no code outside
>   asm/mpam.h does today, and would need a CONFIG_ARM64_MPAM guard
>   because the field is only present when it is set.
> 
> The out-of-line definition this ended up with matches
> resctrl_arch_sched_in(). Please let me know (if this is a change you
> agree with) what kind of shape it needs to take for MPAM. We could also
> just make x86 and MPAM both be out-of-line - doing so may not be felt by
> the heavy copy_process().
> ---
>  arch/arm64/include/asm/mpam.h  |  6 ++++++
>  arch/x86/include/asm/resctrl.h |  7 +++++++
>  drivers/resctrl/mpam_resctrl.c |  6 ++++++
>  fs/resctrl/rdtgroup.c          | 21 +++++++++++++++++++++
>  include/linux/arm_mpam.h       |  1 +
>  include/linux/resctrl.h        | 28 ++++++++++++++++++++++++++++
>  kernel/fork.c                  |  3 +++
>  7 files changed, 72 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
> index 70d396e7b6da..0746e5d7cc2d 100644
> --- a/arch/arm64/include/asm/mpam.h
> +++ b/arch/arm64/include/asm/mpam.h
> @@ -63,6 +63,12 @@ static inline void mpam_set_task_partid_pmg(struct task_struct *tsk,
>  	WRITE_ONCE(task_thread_info(tsk)->mpam_partid_pmg, regval);
>  }
>  
> +static inline void mpam_copy_task_partid_pmg(struct task_struct *dst,
> +					     struct task_struct *src)
> +{
> +	WRITE_ONCE(task_thread_info(dst)->mpam_partid_pmg, mpam_get_regval(src));
> +}
> +
>  static inline void mpam_thread_switch(struct task_struct *tsk)
>  {
>  	u64 oldregval;
> diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
> index 8f6edcdcfd87..199ca9af0089 100644
> --- a/arch/x86/include/asm/resctrl.h
> +++ b/arch/x86/include/asm/resctrl.h
> @@ -153,6 +153,13 @@ static inline void resctrl_arch_set_closid_rmid(struct task_struct *tsk,
>  	WRITE_ONCE(tsk->rmid, rmid);
>  }
>  
> +static inline void resctrl_arch_copy_closid_rmid(struct task_struct *dst,
> +						 struct task_struct *src)
> +{
> +	WRITE_ONCE(dst->closid, READ_ONCE(src->closid));
> +	WRITE_ONCE(dst->rmid, READ_ONCE(src->rmid));
> +}
> +
>  static inline bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid)
>  {
>  	return READ_ONCE(tsk->closid) == closid;
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 5468367776e2..7aea58fca85b 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -345,6 +345,12 @@ void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid)
>  	}
>  }
>  
> +void resctrl_arch_copy_closid_rmid(struct task_struct *dst,
> +				   struct task_struct *src)
> +{
> +	mpam_copy_task_partid_pmg(dst, src);
> +}
> +
>  bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid)
>  {
>  	u64 regval = mpam_get_regval(tsk);
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 57ab090072c2..ebf780fc5fe9 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -657,12 +657,28 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
>  		return -EINVAL;
>  	}
>  
> +	/*
> +	 * Hold tasklist_lock for read so that resctrl_copy_process(), which
> +	 * holds it for write, cannot read the CLOSID and the RMID of @tsk
> +	 * while only one of the two has been updated.
> +	 *
> +	 * Hold tasklist_lock just for the @tsk update. A CPU running @tsk
> +	 * keeps using the CLOSID and RMID that resctrl_arch_sched_in()
> +	 * applied when @tsk was last scheduled in, so
> +	 * update_task_closid_rmid() below has to interrupt that CPU for the
> +	 * new resource group to take effect. Leave that until after
> +	 * tasklist_lock has been dropped: a CPU waiting for tasklist_lock
> +	 * for write waits with interrupts disabled, and @tsk's CPU is the
> +	 * one that may be waiting, because @tsk may be forking.
> +	 */
> +	read_lock(&tasklist_lock);
>  	if (rdtgrp->type == RDTMON_GROUP)
>  		resctrl_arch_set_closid_rmid(tsk, rdtgrp->mon.parent->closid,
>  					     rdtgrp->mon.rmid);
>  	else
>  		resctrl_arch_set_closid_rmid(tsk, rdtgrp->closid,
>  					     rdtgrp->mon.rmid);
> +	read_unlock(&tasklist_lock);
>  
>  	/*
>  	 * Ensure the task's closid and rmid are written before determining if
> @@ -2959,6 +2975,11 @@ static void schemata_list_destroy(void)
>   * If @mask is not NULL the cpus on which moved tasks are running are set
>   * in that mask so the update smp function call is restricted to affected
>   * cpus.
> + *
> + * Tasks created while this walks the task list are handled by
> + * resctrl_copy_process(), which tasklist_lock serializes against this walk.
> + * A new task is either visible to the walk and moved with the others, or
> + * resctrl_copy_process() assigns it after the walk completes.
>   */
>  static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
>  				 struct cpumask *mask)
> diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
> index 002f56e15362..b605e9771c32 100644
> --- a/include/linux/arm_mpam.h
> +++ b/include/linux/arm_mpam.h
> @@ -56,6 +56,7 @@ bool resctrl_arch_mon_capable(void);
>  void resctrl_arch_set_cpu_default_closid(int cpu, u32 closid);
>  void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
>  void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid, u32 rmid);
> +void resctrl_arch_copy_closid_rmid(struct task_struct *dst, struct task_struct *src);
>  void resctrl_arch_sched_in(struct task_struct *tsk);
>  bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid);
>  bool resctrl_arch_match_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 10dfdca7f4bf..32d8bf9ca9ba 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -7,6 +7,8 @@
>  #include <linux/list.h>
>  #include <linux/pid.h>
>  #include <linux/resctrl_types.h>
> +#include <linux/sched.h>
> +#include <linux/sched/task.h>
>  
>  #ifdef CONFIG_ARCH_HAS_CPU_RESCTRL
>  #include <asm/resctrl.h>
> @@ -729,6 +731,32 @@ extern unsigned int resctrl_rmid_realloc_limit;
>  int resctrl_init(void);
>  void resctrl_exit(void);
>  
> +#ifdef CONFIG_RESCTRL_FS
> +/**
> + * resctrl_copy_process() - Give a new task the resource group of its parent.
> + * @child:	The new task, which is not yet on the task list.
> + *
> + * Call from copy_process() while tasklist_lock is held for write. Serialized
> + * against rdt_move_group_tasks() and __rdtgroup_move_task() that hold
> + * tasklist_lock for read.
> + *
> + * dup_task_struct() copies the parent's CLOSID and RMID into @child before
> + * @child is linked onto the task list. If the parent is moved out of a
> + * resource group that is being removed, that group's CLOSID and RMID are
> + * freed once the walk completes, leaving @child with stale assignments.
> + *
> + * Bring @child up to date with the parent.
> + */
> +static inline void resctrl_copy_process(struct task_struct *child)
> +{
> +	lockdep_assert_held_write(&tasklist_lock);
> +
> +	resctrl_arch_copy_closid_rmid(child, current);
> +}
> +#else
> +static inline void resctrl_copy_process(struct task_struct *child) { }
> +#endif
> +
>  #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
>  u64 resctrl_arch_get_prefetch_disable_bits(void);
>  int resctrl_arch_pseudo_lock_fn(void *_plr);
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 5efceb8d58a7..8344e0d27b78 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -105,6 +105,7 @@
>  #include <linux/stackprotector.h>
>  #include <linux/user_events.h>
>  #include <linux/iommu.h>
> +#include <linux/resctrl.h>
>  #include <linux/rseq.h>
>  #include <uapi/linux/pidfd.h>
>  #include <linux/pidfs.h>
> @@ -2491,6 +2492,8 @@ __latent_entropy struct task_struct *copy_process(
>  
>  	klp_copy_process(p);
>  
> +	resctrl_copy_process(p);
> +
>  	sched_core_fork(p);
>  
>  	spin_lock(&current->sighand->siglock);

