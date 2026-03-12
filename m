Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B85B846A;
	Thu, 12 Mar 2026 01:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773280760; cv=none; b=CMt46ae0yskYT6Bi0KLvy15N9x00tG9HRoETvR13yezZcJlU2RkuRAMZHCy9P34leEuIty8PF1GB0vLoISXrO5v2/n/VSwd/YuDmOknHhU3bk6aLJdB8gSjbWE47yF/GI90L8fT8+SRHbNvms2cI2vusg3CNm53PLltwzqWTEQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773280760; c=relaxed/simple;
	bh=VcBofxc+tWaYknAX4DgNGAe1Nprxi6EXo4Fvxrsf0tY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dueE61T/2xOBgwv8Ny1xPimeagD5+UGG0OZpiMtsNOde6IO7N1mFYDbwHXe6O3aNioo4soBo+E8HOuAxhipwD8spNsYH388UEAfLyTCIRNE0mnabK50BlMx0+u3Ybgfxy7fY5bzXg2hBNUm7Kzwzh75gNnM4IgoNJh5kSzEnjeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-0e-69b21a6748f9
Date: Thu, 12 Mar 2026 10:44:01 +0900
From: Byungchul Park <byungchul@sk.com>
To: Yunseong Kim <ysk@kzalloc.com>
Cc: Nathan Chancellor <nathan@kernel.org>, kernel_team@skhynix.com,
	torvalds@linux-foundation.org, gregkh@linuxfoundation.org,
	kernel-team@lge.com, linux-mm@kvack.org, minchan@kernel.org,
	harry.yoo@oracle.com, gwan-gyeong.mun@intel.com,
	max.byungchul.park@gmail.com, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	boqun.feng@gmail.com, Waiman Long <longman@redhat.com>,
	yunseong.kim@ericsson.com, yeoreum.yun@arm.com,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>, intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v18 20/42] dept: apply timeout consideration to dma fence
 wait
Message-ID: <20260312014401.GA24696@system.software.com>
References: <20251205071855.72743-1-byungchul@sk.com>
 <20251205071855.72743-21-byungchul@sk.com>
 <02e5b102-d8e2-4fbf-8818-55863e425c96@kzalloc.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02e5b102-d8e2-4fbf-8818-55863e425c96@kzalloc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHe89tx9Xg9WT05kJiFYZRaVg8QlgGxYEgiiKpCFt5yFNeYqul
	UVA4Eg1DI7VWLs2YS9eqqaFdmA3y1s1L6sDMazY1k/JSlllOifry8uP9//k9z4eHp4Us1p+X
	409IunhtrIZTMsqhefmrjvg75OAyI4aa1lsU2ErPU/B2bJiD5IJ7HDQMTlLQYelj4HuJh4Ls
	4gIOat+3sND06AYH722/Wei94uTgRVUNA/lfyhgYv6SG+sx0FixjwwporMyjwNE0wsKFVAsL
	KXc+cNCVYldAU3Pu9FPTiKA6vZICp6lFAdc/OxVgLSinYbDczUL3pSEFlH7KZMH4bh3kjobA
	aHERB3d/taBNS0Wb2YbEH2PNnPh0PI8RK0ztCjHPcVIssQaJBU/6KdFRlMqJjq+XFWL+Tw8t
	pg29pcSaqz8Z0Vy7U3Tm2hRix8VqSvSUXEM7/PYpN0RLsbJB0q0JP6iMyc4xouMDBxK/VKw4
	hzq3pCEfnuBQ0twwRf1lT1cy8jKDlxPrt8+slzkcSNzuCdrLflhDiu93MGlIydO4wofYb1s4
	bzAf7yZvRt4xXlZhIAN9w7S3JOAcREp7brCzgS+pvdY7U6JxEHFP9U9P5qdZTQqneO+3D95I
	jKlDM5UFeCmpfFhNeT0El/KkyNjNzm66iDyzupkMhE3/aU3/aU3/tHmILkKCHG+I08qxoatj
	kuLlxNWHE+IcaPpYLGcn95ejr/W7XAjzSDNPFbztgSywWoM+Kc6FCE9r/FRCm10WVNHapNOS
	LiFKdzJW0ruQmmc0C1Vrx09FC/iI9oR0TJKOS7q/KcX7+J9DetdNV5tQeCYwtKHEtn1x1PIl
	kRnru3x9W6kAz+4O81hP1q25QRfPhxsiNtS/apfNdUcDw1x3ekaTRiP2vr77vGqi0BkxuedK
	XRmqswzOqRaWvZQ3d+aoXdbHA479H9WRaWGHXr56arWz5q3RKYI9zGNI7VsJAcPaKFdMOjap
	NIw+RhsSROv02j8sQDXmKAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG+Z/bjqPBaU06uCJYmkMqExRe6P6hOhVFgWQEkcNOedIt2+bQ
	Iiom2hZZi+iynFiLNXVpzQuusolFbmg3N21SZlfzki3LW2UXV0R9efnx/J7n20vj0nEihhY0
	el6rUWUrKDEh3rjYuGBXjFtYZG9WgO/JJQxctUcwCI6GKTDaqyl4PDiJQY+jl4CJmj4MzlTa
	KfA/7yThjs1PQuBGCQXPXT9JeHPaS0HrPR8BF4frCBgrlsMjy3ESHKNhEbQ3lWHgDnwmodDk
	IKGo/C0FL4uqRBDosE0dXzuCluNNGHitnSK48MErAqe9AYfBhhAJr4qHRFD73kJCwbMUsI0k
	wUhlBQVXv3eiFbGcq9SFuK+jHRTXOFZGcB5rt4grc+dyNc4Ezn6rH+PcFSaKc386JeIufuvD
	OfNQEON8574RXKl/M+e1uURcz7EWjOurOY82RW8TL9nJZwsGXpu4LF2ceeZsAcoZ2J437FEe
	Ri9WmVEUzTLJbN9LI4owwcSxzvEPZIQpJp4Nhb7gEZYxCrbyWg9hRmIaZzxRbNVlBxURM5hU
	9uHnZ0SEJQywA71hPFKSMmcRW/u6hPwjprP+829+l3AmgQ396MfMiJ5iOXvlBx2Jo5jlbIFp
	6HclmpnLNtW3YCeRxPrf2vrf2vpvXYbwCiQTNAa1SshOWajLyszXCHkLM/aq3WjqHRwHJy0N
	aCSwphkxNFJMkyxaf12QkiqDLl/djFgaV8gk0qdVglSyU5W/n9fu3aHNzeZ1zUhOE4qZknVp
	fLqU2a3S81k8n8Nr/1qMjoo5jJzUvu7++RnyuzJ9Kb9SYx/I8DycXTiwtTUcypoz0WjY7MvV
	HcpdurahblZbr1Lp8t82r3wbmNDDHg9RveW+xFAvOxC7ZPyBh0pMtd3sUqo29hqn5a0b61qR
	7D1RbFEPBu5pEueWb3BmuY6mxDe9axNiP84LmiYdqbNNcauDaQpCl6lKSsC1OtUvyj6eeAoD
	AAA=
X-CFilter-Loop: Reflected

On Thu, Mar 12, 2026 at 01:38:19AM +0900, Yunseong Kim wrote:
> Hi all,
> 
> I have been investigating repeated Clang build failures of the form:
> 
>   "cannot jump from this indirect goto statement to one of its possible targets"
>   "note: jump enters a statement expression"
> 
> triggered by the interaction between drm_exec's indirect goto
> (goto *__drm_exec_retry_ptr) and diagnostic macros such as _THIS_IP_,
> LOCKDEP, and DEPT.
> 
> Link: https://lore.kernel.org/all/?q=b%3A%22error%3A+cannot+jump+from+this+indirect+goto+statement+to+one+of+its+possible+targets%22
> 
> Notably, failures on DEPT are currently observed on arm64 builds.
> On arm64, _THIS_IP_ uses the common implementation based on a GNU C
> statement expression with an address-taken label, relying on compiler
> optimization rather than an architecture-specific definition. This makes
> arm64 particularly sensitive to Clang's treatment of address-taken labels
> and indirect goto targets.
> 
> This is also not limited to a single driver. I have observed the same
> failure pattern in multiple DRM drivers when DEPT instrumentation is in
> the call path (e.g. dma_fence_wait() -> sdt_might_sleep_start_timeout()
> -> _THIS_IP_), including msm and others.
> 
> $ clang --version
> clang version 23.0.0git (https://github.com/llvm/llvm-project.git
> 1ff1e5f10a5c765b4cf1344c4964604dcd09fef3)
> 
> drivers/gpu/drm/msm/msm_gem_vma.c:919:3: error: cannot jump from this
> indirect goto statement to one of its possible targets
>   919 |                 drm_exec_retry_on_contention(&exec);
>       |                 ^
> ./include/drm/drm_exec.h:123:4: note: expanded from macro
> 'drm_exec_retry_on_contention'
>   123 |                         goto *__drm_exec_retry_ptr;             \
>       |                         ^
> drivers/gpu/drm/msm/msm_gem_vma.c:909:3: note: possible target of
> indirect goto statement
>   909 |                 dma_fence_wait(vm->last_fence, false);
>       |                 ^
> ./include/linux/dma-fence.h:677:2: note: expanded from macro 'dma_fence_wait'
>   677 |         sdt_might_sleep_start_timeout(NULL,
> MAX_SCHEDULE_TIMEOUT);      \
>       |         ^
> ./include/linux/dept_sdt.h:46:31: note: expanded from macro
> 'sdt_might_sleep_start_timeout'
>    46 |                 unsigned long __this_ip__ = _THIS_IP_;
>          \
>       |                                             ^
> ./include/linux/instruction_pointer.h:10:41: note: expanded from macro
> '_THIS_IP_'
>    10 | #define _THIS_IP_  ({ __label__ __here; __here: (unsigned
> long)&&__here; })
>       |                                         ^
> drivers/gpu/drm/msm/msm_gem_vma.c:909:3: note: jump enters a statement
> expression
> ./include/linux/dma-fence.h:677:2: note: expanded from macro 'dma_fence_wait'
>   677 |         sdt_might_sleep_start_timeout(NULL,
> MAX_SCHEDULE_TIMEOUT);      \
>       |         ^
> ./include/linux/dept_sdt.h:46:31: note: expanded from macro
> 'sdt_might_sleep_start_timeout'
>    46 |                 unsigned long __this_ip__ = _THIS_IP_;
>          \
>       |                                             ^
> ./include/linux/instruction_pointer.h:10:20: note: expanded from macro
> '_THIS_IP_'
>    10 | #define _THIS_IP_  ({ __label__ __here; __here: (unsigned
> long)&&__here; })
>       |                    ^
> drivers/gpu/drm/msm/msm_gem_vma.c:909:3: note: jump enters a statement
> expression
> ./include/linux/dma-fence.h:673:38: note: expanded from macro 'dma_fence_wait'
>   673 | #define dma_fence_wait(f, intr)
>          \
>       |
>          ^
> drivers/gpu/drm/msm/msm_gem_vma.c:933:5: error: cannot jump from this
> indirect goto statement to one of its possible targets
>   933 |                                 drm_exec_retry_on_contention(&exec);
>       |                                 ^
> ./include/drm/drm_exec.h:123:4: note: expanded from macro
> 'drm_exec_retry_on_contention'
>   123 |                         goto *__drm_exec_retry_ptr;             \
>       |                         ^
> drivers/gpu/drm/msm/msm_gem_vma.c:909:3: note: possible target of
> indirect goto statement
>   909 |                 dma_fence_wait(vm->last_fence, false);
>       |                 ^
> ./include/linux/dma-fence.h:677:2: note: expanded from macro 'dma_fence_wait'
>   677 |         sdt_might_sleep_start_timeout(NULL,
> MAX_SCHEDULE_TIMEOUT);      \
>       |         ^
> ./include/linux/dept_sdt.h:46:31: note: expanded from macro
> 'sdt_might_sleep_start_timeout'
>    46 |                 unsigned long __this_ip__ = _THIS_IP_;
>          \
>       |                                             ^
> ./include/linux/instruction_pointer.h:10:41: note: expanded from macro
> '_THIS_IP_'
>    10 | #define _THIS_IP_  ({ __label__ __here; __here: (unsigned
> long)&&__here; })
>       |                                         ^
> drivers/gpu/drm/msm/msm_gem_vma.c:909:3: note: jump enters a statement
> expression
> ./include/linux/dma-fence.h:677:2: note: expanded from macro 'dma_fence_wait'
>   677 |         sdt_might_sleep_start_timeout(NULL,
> MAX_SCHEDULE_TIMEOUT);      \
>       |         ^
> ./include/linux/dept_sdt.h:46:31: note: expanded from macro
> 'sdt_might_sleep_start_timeout'
>    46 |                 unsigned long __this_ip__ = _THIS_IP_;
>          \
>       |                                             ^
> ./include/linux/instruction_pointer.h:10:20: note: expanded from macro
> '_THIS_IP_'
>    10 | #define _THIS_IP_  ({ __label__ __here; __here: (unsigned
> long)&&__here; })
>       |                    ^
> drivers/gpu/drm/msm/msm_gem_vma.c:909:3: note: jump enters a statement
> expression
> ./include/linux/dma-fence.h:673:38: note: expanded from macro 'dma_fence_wait'
>   673 | #define dma_fence_wait(f, intr)
>          \
>       |
>          ^
> 
> I was able to find the pattern of the kernel source code that uses this pattern:
> 
>   $ git grep -n 'goto \*' | grep ';' | grep -v "\*/" | \
>     grep -Ev "(\*[[:space:]]+goto|_goto.*\*\);)"
>   drivers/gpu/drm/xe/xe_validation.h:149:                       goto *__drm_exec_retry_ptr;                     \
>   drivers/misc/lkdtm/cfi.c:129:                 goto *labels[1];
>   drivers/misc/lkdtm/cfi.c:131:                 goto *labels[2];
>   drivers/misc/lkdtm/cfi.c:133:                 goto *labels[3];
>   drivers/misc/lkdtm/cfi.c:135:                 goto *labels[4];
>   include/drm/drm_exec.h:123:                   goto *__drm_exec_retry_ptr;             \
>   kernel/bpf/core.c:1776:       goto *jumptable[insn->code];
>   scripts/gcc-plugins/gcc-common.h:368: return as_a<ggoto *>(stmt);
>   scripts/gcc-plugins/gcc-common.h:373: return as_a<const ggoto *>(stmt);
>   tools/testing/selftests/bpf/progs/bpf_gotox.c:219:    goto *jt[ctx->x & 0xff];
>   tools/testing/selftests/bpf/progs/bpf_gotox.c:261:            goto *jt1[a];
>   tools/testing/selftests/bpf/progs/bpf_gotox.c:263:            goto *jt2[b];
>   tools/testing/selftests/bpf/progs/bpf_gotox.c:284:            goto *jt[a];
>   tools/testing/selftests/bpf/progs/bpf_gotox.c:287:            goto *jt[a + b];
> 
> I understand that Clang's behavior here is intentional and conservative:
> any address-taken label in the same function is treated as a potential
> indirect goto target, and jumping into a statement expression is diagnosed
> to avoid semantic issues. This aligns with:
> 
>   - [Clang] Diagnose jumps into statement expressions (D154696)
>     https://reviews.llvm.org/D154696
> 
> At the same time, the kernel is not using _THIS_IP_ for control flow.
> The label address is used purely for diagnostics (lockdep/DEPT attribution).
> However, as discussed in:
> 
>   - LLVM Issue #138272: Add builtin/intrinsic to get current instruction pointer
>     https://github.com/llvm/llvm-project/issues/138272
> 
> using blockaddress (&&label) purely to obtain an instruction pointer is
> problematic in LLVM's model, since blockaddress has defined behavior only
> when used with indirectbr or for null comparisons.
> 
> Similar issues have also been observed in other contexts where indirect
> goto interacts with address-taken labels, e.g.:
> 
>   - LLVM Issue #28019: Wrong 'cannot jump from this indirect goto statement'
>     https://github.com/llvm/llvm-project/issues/28019
> 
> Given this, I think there is three possible directions:

Hi,

Thanks for the clarification of the issue.

Indeed, the issue is inevitable as long as 'THIS_IP' macro is used along
with 'indirect goto' statement nearby.

> 1) Continue per-callsite structural workarounds
>    Keep separating indirect goto usage from any code that expands _THIS_IP_
>    (e.g. moving PROVE_LOCKING / DEPT paths into helper functions). This avoids
>    the diagnostic but requires ongoing refactoring and does not scale well as
>    similar patterns reappear across drivers.

Yes.  This workaround would work anyway.  However, hopefully, we can
resolve it in a better way if any.

> 2) Introduce a compiler-supported alternative to _THIS_IP_
>    As discussed in LLVM Issue #138272, a dedicated builtin or intrinsic to
>    obtain a best-effort instruction pointer for diagnostics would allow the
>    kernel to avoid address-taken labels entirely and eliminate this class of
>    conflicts.

Or introduce a new attribute to indicate that 'the symbol(label) is not
used by indirect goto from out of the scope' or something?

> 3) DRM/drm_exec-scoped refactoring as a pragmatic middle ground
>    Since drm_exec is the common convergence point where indirect goto and
>    DEPT/LOCKDEP instrumentation can meet in the same function across multiple
>    DRM drivers, we could refactor the drm_exec usage patterns (or provide a
>    recommended wrapper pattern) to structurally separate the retry/indirect-goto
>    region from instrumentation that expands _THIS_IP_. This would avoid
>    kernel-wide churn while addressing the recurring failures in DRM drivers.
> 
> I am not proposing to weaken Clang's diagnostics. Rather, I would like
> feedback on whether option (3) is considered an acceptable short- to
> medium-term approach, and whether option (2) is the preferred long-term
> direction from the compiler side.

I'd also like to hear feedbacks for what you mentioned.

Thanks!

	Byungchul

> Any guidance from the LOCKDEP and kernel LLVM maintainers on the preferred
> path forward would be greatly appreciated.
> 
> On 12/5/25 4:18 PM, Byungchul Park wrote:
> > Now that CONFIG_DEPT_AGGRESSIVE_TIMEOUT_WAIT was introduced, apply the
> > consideration to dma fence wait.
> >
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > ---
> >  drivers/dma-buf/dma-fence.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
> > index b313bb59dc9c..f2cc7068af65 100644
> > --- a/drivers/dma-buf/dma-fence.c
> > +++ b/drivers/dma-buf/dma-fence.c
> > @@ -799,7 +799,7 @@ dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
> >       cb.task = current;
> >       list_add(&cb.base.node, &fence->cb_list);
> >
> > -     sdt_might_sleep_start(NULL);
> > +     sdt_might_sleep_start_timeout(NULL, timeout);
> >       while (!test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags) && ret > 0) {
> >               if (intr)
> >                       __set_current_state(TASK_INTERRUPTIBLE);
> > @@ -903,7 +903,7 @@ dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
> >               }
> >       }
> >
> > -     sdt_might_sleep_start(NULL);
> > +     sdt_might_sleep_start_timeout(NULL, timeout);
> >       while (ret > 0) {
> >               if (intr)
> >                       set_current_state(TASK_INTERRUPTIBLE);
> 
> 
> Best regards,
> Yuseong
