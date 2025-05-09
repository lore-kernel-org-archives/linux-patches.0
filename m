Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F842356B8
	for <patches@lists.linux.dev>; Fri,  9 May 2025 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746802995; cv=none; b=UdUk2ONITzgwklXPjftsCF7v+zlPS//RwcbWN5B/BB1qyk0Xf3MTI7NFntbPjMUssNB9NqtbH8GzlDSbwcExkUSfEAnzPLflgxovdbtieySipdedVwlwsV35WXmX8fVK+3kp5w2w4C/x00eRvDAOSZM3DuHW1IxWTARlI4Es1Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746802995; c=relaxed/simple;
	bh=0mDvJHOsLO1p6V52TYuh3EyHmhi97FfM+Fuo+xMfI3E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IqiNTS84963d978eEtiy7eOZrNbeFxAfW4Qa3zNZRW2XEQV6mcSoj2G+hrE0T7uRIjqbFemuPxgJfqofiRHP6THnP7NAV0NMH/dzzF4Ht7C+9m/maLW7mb8HKJ8kTQR131gyN5ddsEqBiQk72VgqTQeLnIVXCU9KhJSuKYij88M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bdG85MDm; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bdG85MDm"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5fbc736f0c7so3335876a12.2
        for <patches@lists.linux.dev>; Fri, 09 May 2025 08:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746802991; x=1747407791; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IbnPqI8CFw0GDCCHnX6To+j4QdmNlcwYap3UmnBP8KY=;
        b=bdG85MDmyVURrXRx2yuMVub5OLtNo69yA/gmupx2cmLRDUanliHfjBDEOgFlJ9c1L3
         mJmVuL8y6DuwzhSracz7EKuEhaDkXBw9bAYgn8Pr1dqdXIzoKe/cRwiICxWbHoKPi3/Q
         8Mf0rpHuitd7bQUax4i85s+cOXx0Hc1EnWllDS/7pljGzq2IEZKyV/wSXTRoKMGk/JND
         oKnaIVpqLiQ7sQ9qOgupk0uhwX9CFZWDR1Lbh/xGktXCNQfUdNTZzsXlRGa+jAewWE9q
         SPxi6A6+40Hy0eIAifGif5bY6/ihyPnJX1t9nTpWuvU7Ov/ebSVEfwJilZURTxQTE7jy
         y/kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746802991; x=1747407791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IbnPqI8CFw0GDCCHnX6To+j4QdmNlcwYap3UmnBP8KY=;
        b=CKIj5V9ft8cTfSgNKluo/iX3UYNSe0MOwi9kyt0tTfXFz8diWZG1WvKs21pNiUTAnw
         FiX21OBmPA+Bh81ECZhON/OkJRJMIOMDXpSpj6s0FyivBKZ7GKIVhMr8ydE0De0HA1np
         pmOp+oWlVQI4dlRXdGVCLmsB9vLKcuJ/1qXbKbIIpM5TsVkgg0eejOz3H8n7Frz/yzUZ
         6oPrOKGFu2ys6/eSDnJHU+1M/JcyybpvEtQrTOkEa9tKiesRbRG69ohue7XbztU8ooKv
         5XphKFE40LnxMWTvzNnl6ukGt3Iaog0uqulul1lBI76vVfu3mgybrMC4kJ5l8SQEiVMH
         4uEQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5/ZrvbYskEZxsJWR5dMtWADnjz8eNpkHs5mMVlfq9viyhKc8rDIBye8tWV/LugZe2+GZ3QTx8@lists.linux.dev
X-Gm-Message-State: AOJu0YzHSFtl3HpUO0oLGFe9Cu5cKF2lrU/gsVv/3nMSw2dAhRIaFLn3
	YPxTJjkrax1CFaxb+oIuuP7T2tfSmfVaWJVXTvi0UNxOS7xOXsX/JQqipxjkI2gLPDlWShksR0F
	dQ/9jnjwLrHuhmYy8R9yM8WGVbd5aDULbYCis
X-Gm-Gg: ASbGncsQRmLIO/FCJfHEDXCyLYa9bK5Pv9OdnmoYZOscl2W+x5ZF8PVM76aRhBmrNvF
	ms7/H2FsYVREEutlA7RZGTXcWoRPxkPUhFw7ADiXj/foj+ZlDZdl1KkADVrET3tWctok54lbl48
	4m3Fv4Dju3EcscSjABPVYVNqdLaiACg8lKsN+AywNhLkgiJPgoLxO9R+XCMTof+OA=
X-Google-Smtp-Source: AGHT+IFd1MHsMQpmuNk6iHvKTWNZ1gTFUjcbQ0INRAFrSpZXETJlixmoKR/aP5Al6K3yuG+x6iWw0qogHgIPaPpiWMs=
X-Received: by 2002:a17:906:ee87:b0:ad1:8e6a:5945 with SMTP id
 a640c23a62f3a-ad21911576cmr378855666b.36.1746802990966; Fri, 09 May 2025
 08:03:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250429003359.375508-1-tony.luck@intel.com> <20250429003359.375508-3-tony.luck@intel.com>
In-Reply-To: <20250429003359.375508-3-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 9 May 2025 17:02:59 +0200
X-Gm-Features: AX0GCFtb6OssAt87ngQgjTiXZm6Po2WzxhneFV47NMzIXD31vIbrbeCnLQTffYI
Message-ID: <CALPaoChWkjXz2Qe=1nezzJctX1jDapcdijFfgHe_ZBRWRjH5aw@mail.gmail.com>
Subject: Re: [PATCH v4 02/31] x86,fs/resctrl: Prepare for more monitor events
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

On Tue, Apr 29, 2025 at 2:34=E2=80=AFAM Tony Luck <tony.luck@intel.com> wro=
te:
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
> Change the rdt_ctrl_domain and rdt_hw_mon_domain structures to hold
> arrays of pointers to per event data instead of explicit fields for
> total and local bandwidth.
>
> Simplify the code by coding for many events using loops on
> which are enabled.
>
> Move resctrl_is_mbm_event() to <linux/resctrl.h> so it
> can be used more widely. Also provide a for_each_mbm_event()
> helper macro.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                | 15 +++++---
>  include/linux/resctrl_types.h          |  3 ++
>  arch/x86/kernel/cpu/resctrl/internal.h |  6 ++--
>  arch/x86/kernel/cpu/resctrl/core.c     | 38 ++++++++++----------
>  arch/x86/kernel/cpu/resctrl/monitor.c  | 33 ++++++++++--------
>  fs/resctrl/monitor.c                   | 13 ++++---
>  fs/resctrl/rdtgroup.c                  | 48 ++++++++++++--------------
>  7 files changed, 84 insertions(+), 72 deletions(-)
>
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 3c5d111aae65..cef9b0ed984c 100644
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
> +       struct mbm_state                *mbm_states[QOS_NUM_MBM_EVENTS];
>         struct delayed_work             mbm_over;
>         struct delayed_work             cqm_limbo;
>         int                             mbm_work_cpu;
> @@ -376,6 +374,15 @@ void resctrl_enable_mon_event(enum resctrl_event_id =
evtid);
>  bool resctrl_is_mon_event_enabled(enum resctrl_event_id evt);
>  bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);
>
> +static inline bool resctrl_is_mbm_event(int e)
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
> index a25fb9c4070d..5ef14a24008c 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -47,4 +47,7 @@ enum resctrl_event_id {
>         QOS_NUM_EVENTS,
>  };
>
> +#define QOS_NUM_MBM_EVENTS     (QOS_L3_MBM_LOCAL_EVENT_ID - QOS_L3_MBM_T=
OTAL_EVENT_ID + 1)
> +#define MBM_EVENT_IDX(evt)     ((evt) - QOS_L3_MBM_TOTAL_EVENT_ID)
> +
>  #endif /* __LINUX_RESCTRL_TYPES_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu=
/resctrl/internal.h
> index 5e3c41b36437..02b535c828f3 100644
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
> +       struct arch_mbm_state           *arch_mbm_states[QOS_NUM_MBM_EVEN=
TS];
>  };
>
>  static inline struct rdt_hw_ctrl_domain *resctrl_to_arch_ctrl_dom(struct=
 rdt_ctrl_domain *r)
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/res=
ctrl/core.c
> index 819bc7a09327..e5c91d21e8f7 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -364,8 +364,8 @@ static void ctrl_domain_free(struct rdt_hw_ctrl_domai=
n *hw_dom)
>
>  static void mon_domain_free(struct rdt_hw_mon_domain *hw_dom)
>  {
> -       kfree(hw_dom->arch_mbm_total);
> -       kfree(hw_dom->arch_mbm_local);
> +       for (int i =3D 0; i < QOS_NUM_MBM_EVENTS; i++)
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
> +       enum resctrl_event_id evt;
> +       int idx;
> +
> +       for_each_mbm_event(evt) {
> +               if (!resctrl_is_mon_event_enabled(evt))
> +                       continue;
> +               idx =3D MBM_EVENT_IDX(evt);
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
> index fda579251dba..bf7fde07846b 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -160,18 +160,21 @@ static struct arch_mbm_state *get_arch_mbm_state(st=
ruct rdt_hw_mon_domain *hw_do
>                                                  u32 rmid,
>                                                  enum resctrl_event_id ev=
entid)
>  {
> +       struct arch_mbm_state *state;
> +
>         switch (eventid) {
> -       case QOS_L3_OCCUP_EVENT_ID:
> -               return NULL;
> -       case QOS_L3_MBM_TOTAL_EVENT_ID:
> -               return &hw_dom->arch_mbm_total[rmid];
> -       case QOS_L3_MBM_LOCAL_EVENT_ID:
> -               return &hw_dom->arch_mbm_local[rmid];
>         default:
>                 /* Never expect to get here */
>                 WARN_ON_ONCE(1);
> +               fallthrough;
> +       case QOS_L3_OCCUP_EVENT_ID:
>                 return NULL;
> +       case QOS_L3_MBM_TOTAL_EVENT_ID:
> +       case QOS_L3_MBM_LOCAL_EVENT_ID:
> +               state =3D hw_dom->arch_mbm_states[MBM_EVENT_IDX(eventid)]=
;
>         }
> +
> +       return state ? &state[rmid] : NULL;
>  }
>
>  void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_doma=
in *d,
> @@ -200,14 +203,16 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r=
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
> +               idx =3D MBM_EVENT_IDX(evt);
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
> index 7de4e219dba3..ef33970166af 100644
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
> +       states =3D d->mbm_states[MBM_EVENT_IDX(evtid)];
> +
> +       return states ? &states[idx] : NULL;
>  }
>
>  static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 4a092c305255..c06752dfcb7c 100644
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
> @@ -4019,8 +4013,10 @@ static void rdtgroup_setup_default(void)
>  static void domain_destroy_mon_state(struct rdt_mon_domain *d)
>  {
>         bitmap_free(d->rmid_busy_llc);
> -       kfree(d->mbm_total);
> -       kfree(d->mbm_local);
> +       for (int i =3D 0; i < QOS_NUM_MBM_EVENTS; i++) {
> +               kfree(d->mbm_states[i]);
> +               d->mbm_states[i] =3D NULL;
> +       }
>  }
>
>  void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl=
_domain *d)
> @@ -4080,32 +4076,34 @@ void resctrl_offline_mon_domain(struct rdt_resour=
ce *r, struct rdt_mon_domain *d
>  static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon=
_domain *d)
>  {
>         u32 idx_limit =3D resctrl_arch_system_num_rmid_idx();
> -       size_t tsize;
> +       size_t tsize =3D sizeof(struct mbm_state);
> +       enum resctrl_event_id evt;
> +       int idx;
>
>         if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID)) {
>                 d->rmid_busy_llc =3D bitmap_zalloc(idx_limit, GFP_KERNEL)=
;
>                 if (!d->rmid_busy_llc)
>                         return -ENOMEM;
>         }
> -       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID)) {
> -               tsize =3D sizeof(*d->mbm_total);
> -               d->mbm_total =3D kcalloc(idx_limit, tsize, GFP_KERNEL);
> -               if (!d->mbm_total) {
> -                       bitmap_free(d->rmid_busy_llc);
> -                       return -ENOMEM;
> -               }
> -       }
> -       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID)) {
> -               tsize =3D sizeof(*d->mbm_local);
> -               d->mbm_local =3D kcalloc(idx_limit, tsize, GFP_KERNEL);
> -               if (!d->mbm_local) {
> -                       bitmap_free(d->rmid_busy_llc);
> -                       kfree(d->mbm_total);
> -                       return -ENOMEM;
> -               }
> +
> +       for_each_mbm_event(evt) {
> +               if (!resctrl_is_mon_event_enabled(evt))
> +                       continue;
> +               idx =3D MBM_EVENT_IDX(evt);
> +               d->mbm_states[idx] =3D kcalloc(idx_limit, tsize, GFP_KERN=
EL);
> +               if (!d->mbm_states[idx])
> +                       goto cleanup;
>         }
>
>         return 0;
> +cleanup:
> +       bitmap_free(d->rmid_busy_llc);
> +       while (--idx >=3D 0) {
> +               kfree(d->mbm_states[idx]);
> +               d->mbm_states[idx] =3D NULL;
> +       }
> +
> +       return -ENOMEM;
>  }
>
>  int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_d=
omain *d)
> --
> 2.48.1
>

I tried out this change to field an urgent internal request to
experimentally get MBM and occupancy events broken down by code/data
on an MPAM implementation. Because the approach to CDP used in the
MPAM driver allocates two IDs per group, code/data in all of the
events is naturally monitored separately, but the MPAM
resctrl_arch_rmid_read() implementation adds them back together[1]
before returning.

This may not ultimately be how code/data portions of monitoring events
are reported in the long run, since it seems troubling that we would
have to add two new derived events for every additional "real" event
which could be added later on.

diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index 6b2191672eb87..9c421ad836ee1 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -94,9 +94,15 @@ enum resctrl_event_id {
        QOS_L3_OCCUP_EVENT_ID           =3D 0x01,
        QOS_L3_MBM_TOTAL_EVENT_ID       =3D 0x02,
        QOS_L3_MBM_LOCAL_EVENT_ID       =3D 0x03,
+       QOS_L3_MBM_CODE_TOTAL_EVENT_ID,
+       QOS_L3_MBM_DATA_TOTAL_EVENT_ID,
+       QOS_L3_MBM_CODE_LOCAL_EVENT_ID,
+       QOS_L3_MBM_DATA_LOCAL_EVENT_ID,
+       QOS_L3_CODE_OCCUP_EVENT_ID,
+       QOS_L3_DATA_OCCUP_EVENT_ID,
 };

But I'm at least happy to report that I didn't need to make any
substantial changes to this patch to make this experiment work. The
main difference was needing to adjust the range of MBM event IDs.

Thanks!
-Peter


[1] https://web.git.kernel.org/pub/scm/linux/kernel/git/morse/linux.git/tre=
e/drivers/platform/arm64/mpam/mpam_resctrl.c?h=3Dmpam/snapshot/v6.14-rc1#n4=
02
