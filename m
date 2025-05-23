Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E9F1A314F
	for <patches@lists.linux.dev>; Fri, 23 May 2025 09:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747990820; cv=none; b=ivwOoYjTt6ZlU1u4Gsry5QFl+7WPgvHQNf2j+QC49Y17akRbNYSddosSssaYe9PdOG1utbXeD0FLR2Z4O3nOi3RjfrYGHRFGZLWZwZqZN3753qEI3LL0hbQsP9ABdm3eiGzYBQYCBWYoSCDzvmp6P392HR3CUwzXm8j2xOwPqfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747990820; c=relaxed/simple;
	bh=fFrQ/JXoJLPBH7HEbAxWk44fvHSAe7VVAjZtBLCRav0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E8cs/p5zyeBQPcYAbEZi25eUf3ba/xLNIPX+6Ly2qhfaPFWI9vSuzll3Y9vqJ+sXGrh4TTw0YcnW2YNiE2PN9+apmUaw1mfHZLatcAVh/hrCuJUifOz4KMCpk2cmUkgPCxJTmtdcxHNpGHzjxChcc2oyNrPYcQT1Cz9NdD7yYcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OBRDmhrS; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OBRDmhrS"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ad1d1f57a01so1622614266b.2
        for <patches@lists.linux.dev>; Fri, 23 May 2025 02:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747990817; x=1748595617; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9uOzrdUJ2LFuVEOHCGYzPK9BiHxjeHo77kFnCgkTb6Y=;
        b=OBRDmhrS0yq1wVIhxX0R/ljRkaAQvI/eGtdXXB/RKOFX2rYffK6g9zjrBOn+uOPbsz
         KbyH07x1ibEo36XTGqh6CArtOOy/9cIk3KP1zji3k8RleJ/SsVn62YnSqSmr3udKyAX4
         V2CjG/kGNT7KfgKDsg5KjmyDihOD+kUVH062QL778QvKoHNqHPHglyLnYiDJlaNJW+xa
         iYvyjo7YcnuUH9UgpGAAKyEqUwAoj+Ec6JvBVFfVK4+iUNFs0K6GKgvZbXuE7R5tkjn5
         bkTFttPLKFWtO9drm/8k4RlwIB0BlK7rhj9bmrJQFA5225POkFqMy2apgqXsBHnfElOD
         XN7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747990817; x=1748595617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9uOzrdUJ2LFuVEOHCGYzPK9BiHxjeHo77kFnCgkTb6Y=;
        b=gNa0lgk5rwd3kWAxv31elt+6W2eFVugwZtfCl9ECFekVMHo9m8TrICTIemIwG2vls/
         /iFPr8O27McKV6qUwzQb4JQsVQCOQcLyyfrnAtlgFezh5N3dtw5LJ17EWVG+YxdbKRn5
         yPpyn6LbY2H8pKAaZDwY33tsPSSTYwe7sjFun1fgWJD4l4LFy49CXw0r4ojd3HF04B0C
         7XHkUk0YW+mYlgORifKGIPseCF2XvhrDwIelEsgRn/Nd4+t6TTHkjxV+qu4kdaCerOGK
         O1UcQ6DUzJDxGEJ5rOjJV/jhxE/40O0K/NmlOOgjhoekzWRqiLVhJea03d0f9Hswdb3o
         greg==
X-Forwarded-Encrypted: i=1; AJvYcCVIjChhSDtClLi/4U9if8IEt9UOBQmYDK0vjijd40odKrNN917ZN/Rmm/aqEsJwQHLgDS07J23X@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1+hLxxAdUPIjYHDzGfRZR7qT8mzaG+g3pjwjHDV/3Jk/bDsjT
	qM6jFKDreFCSK6WA3VA/BfdfVAK14LL9GrlnMcYS+5hCmuvslAaKgBgQ1SkaQmpunIB9x3RDPzB
	u/+BGVjGSZU6u+rZ418hweWViQe+2ZYdApOMHrdG+
X-Gm-Gg: ASbGnctxChil3zo81kZWLP3U38UC/v+RMN9dXy7Se9huAOtkt+IOSedXp5OPgHFqK9E
	lHGPjOeeQ6SedJvizvn4YqpkQ5aZ3RCq26DXZQsDJ3X1hwjqbmXTthrPENztPfu1zfr940whB3g
	QlmTrQr1Xj4Yj3PwZWKmQ1WqkpYv+E9IOBFhyIjbJOSX3lB9DLR9n3Q4clvHmjTYu8YvMlWmrl
X-Google-Smtp-Source: AGHT+IHrHoam2SyDQ+SDFuQ3kRR6NQqlgQ1d7rX02aF+XbK5tBB+f1Jkn6eLnmPaNV6nrsvcgQvKwhCoawOGVhsiExo=
X-Received: by 2002:a17:907:1b19:b0:aca:c38d:fef0 with SMTP id
 a640c23a62f3a-ad52d08120dmr2751786166b.0.1747990816441; Fri, 23 May 2025
 02:00:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250521225049.132551-1-tony.luck@intel.com> <20250521225049.132551-5-tony.luck@intel.com>
In-Reply-To: <20250521225049.132551-5-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 23 May 2025 11:00:04 +0200
X-Gm-Features: AX0GCFvmiUC1CESAcyIjRqdnb9Dai0VpCSt1phsq4U9f_hARl-qLtMQCj1OIYxc
Message-ID: <CALPaoCj8yfzJ=5CkxTPQXc0-WRWpu0xKRX8v4FAWFGQKtXtMUw@mail.gmail.com>
Subject: Re: [PATCH v5 04/29] x86,fs/resctrl: Prepare for more monitor events
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, James Morse <james.morse@arm.com>, 
	Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, 
	Dave Martin <Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>, 
	Chen Yu <yu.c.chen@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Thu, May 22, 2025 at 12:51=E2=80=AFAM Tony Luck <tony.luck@intel.com> wr=
ote:
>
> There's a rule in computer programming that objects appear zero,
> once, or many times. So code accordingly.
>
> There are two MBM events and resctrl is coded with a lot of
>
>         if (local)
>                 do one thing
>         if (total)
>                 do a different thing
>
> Change the rdt_mon_domain and rdt_hw_mon_domain structures to hold arrays
> of pointers to per event data instead of explicit fields for total and
> local bandwidth.
>
> Simplify by coding for many events using loops on which are enabled.
>
> Move resctrl_is_mbm_event() to <linux/resctrl.h> so it can be used more
> widely. Also provide a for_each_mbm_event() helper macro.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                | 15 +++++---
>  include/linux/resctrl_types.h          |  3 ++
>  arch/x86/kernel/cpu/resctrl/internal.h |  6 ++--
>  arch/x86/kernel/cpu/resctrl/core.c     | 38 ++++++++++----------
>  arch/x86/kernel/cpu/resctrl/monitor.c  | 36 +++++++++----------
>  fs/resctrl/monitor.c                   | 13 ++++---
>  fs/resctrl/rdtgroup.c                  | 48 ++++++++++++--------------
>  7 files changed, 82 insertions(+), 77 deletions(-)
>
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 843ad7c8e247..40f2d0d48d02 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -161,8 +161,7 @@ struct rdt_ctrl_domain {
>   * @hdr:               common header for different domain types
>   * @ci:                        cache info for this domain
>   * @rmid_busy_llc:     bitmap of which limbo RMIDs are above threshold
> - * @mbm_total:         saved state for MBM total bandwidth
> - * @mbm_local:         saved state for MBM local bandwidth
> + * @mbm_states:                saved state for each QOS MBM event
>   * @mbm_over:          worker to periodically read MBM h/w counters
>   * @cqm_limbo:         worker to periodically read CQM h/w counters
>   * @mbm_work_cpu:      worker CPU for MBM h/w counters
> @@ -172,8 +171,7 @@ struct rdt_mon_domain {
>         struct rdt_domain_hdr           hdr;
>         struct cacheinfo                *ci;
>         unsigned long                   *rmid_busy_llc;
> -       struct mbm_state                *mbm_total;
> -       struct mbm_state                *mbm_local;
> +       struct mbm_state                *mbm_states[QOS_NUM_L3_MBM_EVENTS=
];
>         struct delayed_work             mbm_over;
>         struct delayed_work             cqm_limbo;
>         int                             mbm_work_cpu;
> @@ -376,6 +374,15 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event=
_id evt);
>
>  bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);
>
> +static inline bool resctrl_is_mbm_event(enum resctrl_event_id e)
> +{
> +       return (e >=3D QOS_L3_MBM_TOTAL_EVENT_ID &&
> +               e <=3D QOS_L3_MBM_LOCAL_EVENT_ID);
> +}
> +
> +#define for_each_mbm_event(evt)        \
> +       for (evt =3D QOS_L3_MBM_TOTAL_EVENT_ID; evt <=3D QOS_L3_MBM_LOCAL=
_EVENT_ID; evt++)
> +
>  /**
>   * resctrl_arch_mon_event_config_write() - Write the config for an event=
.
>   * @config_info: struct resctrl_mon_config_info describing the resource,=
 domain
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.=
h
> index a25fb9c4070d..b468bfbab9ea 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -47,4 +47,7 @@ enum resctrl_event_id {
>         QOS_NUM_EVENTS,
>  };
>
> +#define QOS_NUM_L3_MBM_EVENTS  (QOS_L3_MBM_LOCAL_EVENT_ID - QOS_L3_MBM_T=
OTAL_EVENT_ID + 1)
> +#define MBM_STATE_IDX(evt)     ((evt) - QOS_L3_MBM_TOTAL_EVENT_ID)
> +
>  #endif /* __LINUX_RESCTRL_TYPES_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu=
/resctrl/internal.h
> index 5e3c41b36437..ea185b4d0d59 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -54,15 +54,13 @@ struct rdt_hw_ctrl_domain {
>   * struct rdt_hw_mon_domain - Arch private attributes of a set of CPUs t=
hat share
>   *                           a resource for a monitor function
>   * @d_resctrl: Properties exposed to the resctrl file system
> - * @arch_mbm_total:    arch private state for MBM total bandwidth
> - * @arch_mbm_local:    arch private state for MBM local bandwidth
> + * @arch_mbm_states:   arch private state for each MBM event
>   *
>   * Members of this structure are accessed via helpers that provide abstr=
action.
>   */
>  struct rdt_hw_mon_domain {
>         struct rdt_mon_domain           d_resctrl;
> -       struct arch_mbm_state           *arch_mbm_total;
> -       struct arch_mbm_state           *arch_mbm_local;
> +       struct arch_mbm_state           *arch_mbm_states[QOS_NUM_L3_MBM_E=
VENTS];
>  };
>
>  static inline struct rdt_hw_ctrl_domain *resctrl_to_arch_ctrl_dom(struct=
 rdt_ctrl_domain *r)
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/res=
ctrl/core.c
> index 819bc7a09327..4403a820db12 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -364,8 +364,8 @@ static void ctrl_domain_free(struct rdt_hw_ctrl_domai=
n *hw_dom)
>
>  static void mon_domain_free(struct rdt_hw_mon_domain *hw_dom)
>  {
> -       kfree(hw_dom->arch_mbm_total);
> -       kfree(hw_dom->arch_mbm_local);
> +       for (int i =3D 0; i < QOS_NUM_L3_MBM_EVENTS; i++)
> +               kfree(hw_dom->arch_mbm_states[i]);
>         kfree(hw_dom);
>  }
>
> @@ -399,25 +399,27 @@ static int domain_setup_ctrlval(struct rdt_resource=
 *r, struct rdt_ctrl_domain *
>   */
>  static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_mon_domain =
*hw_dom)
>  {
> -       size_t tsize;
> -
> -       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID)) {
> -               tsize =3D sizeof(*hw_dom->arch_mbm_total);
> -               hw_dom->arch_mbm_total =3D kcalloc(num_rmid, tsize, GFP_K=
ERNEL);
> -               if (!hw_dom->arch_mbm_total)
> -                       return -ENOMEM;
> -       }
> -       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID)) {
> -               tsize =3D sizeof(*hw_dom->arch_mbm_local);
> -               hw_dom->arch_mbm_local =3D kcalloc(num_rmid, tsize, GFP_K=
ERNEL);
> -               if (!hw_dom->arch_mbm_local) {
> -                       kfree(hw_dom->arch_mbm_total);
> -                       hw_dom->arch_mbm_total =3D NULL;
> -                       return -ENOMEM;
> -               }
> +       size_t tsize =3D sizeof(struct arch_mbm_state);

sizeof(*hw_dom->arch_mbm_states[0])?

The previous code didn't assume a type.

> +       enum resctrl_event_id evt;
> +       int idx;
> +
> +       for_each_mbm_event(evt) {
> +               if (!resctrl_is_mon_event_enabled(evt))
> +                       continue;
> +               idx =3D MBM_STATE_IDX(evt);
> +               hw_dom->arch_mbm_states[idx] =3D kcalloc(num_rmid, tsize,=
 GFP_KERNEL);
> +               if (!hw_dom->arch_mbm_states[idx])
> +                       goto cleanup;
>         }
>
>         return 0;
> +cleanup:
> +       while (--idx >=3D 0) {
> +               kfree(hw_dom->arch_mbm_states[idx]);
> +               hw_dom->arch_mbm_states[idx] =3D NULL;
> +       }
> +
> +       return -ENOMEM;
>  }
>
>  static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/=
resctrl/monitor.c
> index fda579251dba..85526e5540f2 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -160,18 +160,14 @@ static struct arch_mbm_state *get_arch_mbm_state(st=
ruct rdt_hw_mon_domain *hw_do
>                                                  u32 rmid,
>                                                  enum resctrl_event_id ev=
entid)
>  {
> -       switch (eventid) {
> -       case QOS_L3_OCCUP_EVENT_ID:
> -               return NULL;
> -       case QOS_L3_MBM_TOTAL_EVENT_ID:
> -               return &hw_dom->arch_mbm_total[rmid];
> -       case QOS_L3_MBM_LOCAL_EVENT_ID:
> -               return &hw_dom->arch_mbm_local[rmid];
> -       default:
> -               /* Never expect to get here */
> -               WARN_ON_ONCE(1);
> +       struct arch_mbm_state *state;
> +
> +       if (!resctrl_is_mbm_event(eventid))
>                 return NULL;
> -       }
> +
> +       state =3D hw_dom->arch_mbm_states[MBM_STATE_IDX(eventid)];
> +
> +       return state ? &state[rmid] : NULL;
>  }
>
>  void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_doma=
in *d,
> @@ -200,14 +196,16 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r=
, struct rdt_mon_domain *d,
>  void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_=
domain *d)
>  {
>         struct rdt_hw_mon_domain *hw_dom =3D resctrl_to_arch_mon_dom(d);
> -
> -       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
> -               memset(hw_dom->arch_mbm_total, 0,
> -                      sizeof(*hw_dom->arch_mbm_total) * r->num_rmid);
> -
> -       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
> -               memset(hw_dom->arch_mbm_local, 0,
> -                      sizeof(*hw_dom->arch_mbm_local) * r->num_rmid);
> +       enum resctrl_event_id evt;
> +       int idx;
> +
> +       for_each_mbm_event(evt) {
> +               idx =3D MBM_STATE_IDX(evt);
> +               if (!hw_dom->arch_mbm_states[idx])
> +                       continue;
> +               memset(hw_dom->arch_mbm_states[idx], 0,
> +                      sizeof(struct arch_mbm_state) * r->num_rmid);
> +       }
>  }
>
>  static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int wi=
dth)
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 325e23c1a403..4cd0789998bf 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -346,15 +346,14 @@ static struct mbm_state *get_mbm_state(struct rdt_m=
on_domain *d, u32 closid,
>                                        u32 rmid, enum resctrl_event_id ev=
tid)
>  {
>         u32 idx =3D resctrl_arch_rmid_idx_encode(closid, rmid);
> +       struct mbm_state *states;
>
> -       switch (evtid) {
> -       case QOS_L3_MBM_TOTAL_EVENT_ID:
> -               return &d->mbm_total[idx];
> -       case QOS_L3_MBM_LOCAL_EVENT_ID:
> -               return &d->mbm_local[idx];
> -       default:
> +       if (!resctrl_is_mbm_event(evtid))
>                 return NULL;
> -       }
> +
> +       states =3D d->mbm_states[MBM_STATE_IDX(evtid)];
> +
> +       return states ? &states[idx] : NULL;
>  }
>
>  static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 80e74940281a..8649b89d7bfd 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -127,12 +127,6 @@ static bool resctrl_is_mbm_enabled(void)
>                 resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID));
>  }
>
> -static bool resctrl_is_mbm_event(int e)
> -{
> -       return (e >=3D QOS_L3_MBM_TOTAL_EVENT_ID &&
> -               e <=3D QOS_L3_MBM_LOCAL_EVENT_ID);
> -}
> -
>  /*
>   * Trivial allocator for CLOSIDs. Use BITMAP APIs to manipulate a bitmap
>   * of free CLOSIDs.
> @@ -4020,8 +4014,10 @@ static void rdtgroup_setup_default(void)
>  static void domain_destroy_mon_state(struct rdt_mon_domain *d)
>  {
>         bitmap_free(d->rmid_busy_llc);
> -       kfree(d->mbm_total);
> -       kfree(d->mbm_local);
> +       for (int i =3D 0; i < QOS_NUM_L3_MBM_EVENTS; i++) {
> +               kfree(d->mbm_states[i]);
> +               d->mbm_states[i] =3D NULL;
> +       }
>  }
>
>  void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl=
_domain *d)
> @@ -4081,32 +4077,34 @@ void resctrl_offline_mon_domain(struct rdt_resour=
ce *r, struct rdt_mon_domain *d
>  static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon=
_domain *d)
>  {
>         u32 idx_limit =3D resctrl_arch_system_num_rmid_idx();
> -       size_t tsize;
> +       size_t tsize =3D sizeof(struct mbm_state);

Here too.

Thanks!
-Peter
