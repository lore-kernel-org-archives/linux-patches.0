Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164A947A4A
	for <patches@lists.linux.dev>; Fri,  8 Dec 2023 18:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mNIxRP69"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-35d68239732so3045ab.1
        for <patches@lists.linux.dev>; Fri, 08 Dec 2023 10:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702059440; x=1702664240; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rT+IqEgBG0h+KBQVMoiPQaupxIMoYqveRu1390Nm3NU=;
        b=mNIxRP69ARskAJ2uSMkttcFpZw+6ejVH0lhT28EFExLhsihc7XfYDcXNzB0lEgt4E4
         Jkl1uzpleS7DhuYIKee1NmNNSBLxUa083ePuB747oA2H5VLus0qZxI3azJz0BeWreAzw
         rKF/3hZ15eBlQhZqiqiRC38m8MU3vrSanZL/rCt002FPOD5EX/dGMKJpAHQW9QjFBl3f
         Mc4fJRKn4MBHKdnIi20gvKy8YCN0pDX/QygHmYD1T122s44Qh2P6YsTMlMFABmGrdnH+
         YpBskreIMUNGB+fLTH1nz4BHp4j8t6N1tvc1SU09Lkb0csV2H9kfppCedBqq+8siR1KZ
         LwHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702059440; x=1702664240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rT+IqEgBG0h+KBQVMoiPQaupxIMoYqveRu1390Nm3NU=;
        b=m1uqeI5/s3EKy8aRwETjrKbUaT6f4Qfy2TDGIJrsIvPwfe1zvZ3f0p5PxkCW1pzPaj
         K1cWAf+SkuuUFyEgcyJzegPuwxvV4y0bT1fjxuyuxDQWLM/ejtqXP+QL2Yr2z8iKxNot
         nNVL6K9ZeDCFTjugRzWK5La2/gWfZ5W0VoOj5jMKIQQysJFhsJzrjzKzWMirnpuXadpQ
         uHJldasmQkz0TOxyrLPc4nwkU3r3VO7SPmrZG74w4KPZv5PDzeOVgki1khNHIJx4GZlH
         OKB15JNaQMKbO24Oc77D672bvzKvrDM6COVeon3vx5S5wODBummFgqWRb8DPz3mgLDDF
         pXMQ==
X-Gm-Message-State: AOJu0YwLtOG7iCrCGkxqHVAwMazrcC7QSIo3vgIejvdEyFmeJABrcEmY
	UENL4eM16TYcmRP0z3w4rBFO9WWxJvtf821zHXw9rg==
X-Google-Smtp-Source: AGHT+IH0/NXGMQE81etiuHRrZE0cVxQZNyZhSrRDTKfpiBdT14P7txnmutXo3GyPbc5TdiySCBh+bXEmFC/bDqFzxg4=
X-Received: by 2002:a92:da05:0:b0:35c:e4c2:5345 with SMTP id
 z5-20020a92da05000000b0035ce4c25345mr190166ilm.21.1702059439867; Fri, 08 Dec
 2023 10:17:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231201214737.104444-1-tony.luck@intel.com> <20231207195613.153980-1-tony.luck@intel.com>
 <20231207195613.153980-2-tony.luck@intel.com>
In-Reply-To: <20231207195613.153980-2-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 8 Dec 2023 10:17:08 -0800
Message-ID: <CALPaoCji1yzfkA=tms3LhYMvRB+wSJQM3qzPKrHNEa7a+KduTA@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] x86/resctrl: Add mount option "mba_MBps_event"
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org, 
	Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse <james.morse@arm.com>, 
	Jamie Iles <quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Thu, Dec 7, 2023 at 11:56=E2=80=AFAM Tony Luck <tony.luck@intel.com> wro=
te:
>
> The MBA Software Controller(mba_sc) is a feedback loop that uses
> measurements of local memory bandwidth to adjust MBA throttling levels
> to keep workloads in a resctrl group within a target bandwidth set in
> the schemata file.
>
> Users may want to use total memory bandwidth instead of local to handle
> workloads that have poor NUMA localization.
>
> Add a new mount option "mba_MBps_event=3D{event_name}" where event_name
> is one of "mbm_Local_bytes" or "mbm_total_bytes" that allows a user to

It's "mbm_local_bytes" in the matching logic later on.


> specify which monitoring event to use.
>
> Update the once-per-second polling code to use the chosen event (local
> or total memory bandwidth).
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                |  2 +
>  arch/x86/kernel/cpu/resctrl/internal.h |  3 +-
>  arch/x86/kernel/cpu/resctrl/monitor.c  | 21 +++++----
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c | 61 +++++++++++++++++++++-----
>  4 files changed, 63 insertions(+), 24 deletions(-)
>
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 66942d7fba7f..1feb3b2e64fa 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -129,6 +129,7 @@ enum membw_throttle_mode {
>   * @throttle_mode:     Bandwidth throttling mode when threads request
>   *                     different memory bandwidths
>   * @mba_sc:            True if MBA software controller(mba_sc) is enable=
d
> + * @mba_mbps_event:    Event (local or total) for mba_sc
>   * @mb_map:            Mapping of memory B/W percentage to memory B/W de=
lay
>   */
>  struct resctrl_membw {
> @@ -138,6 +139,7 @@ struct resctrl_membw {
>         bool                            arch_needs_linear;
>         enum membw_throttle_mode        throttle_mode;
>         bool                            mba_sc;
> +       enum resctrl_event_id           mba_mbps_event;
>         u32                             *mb_map;
>  };
>
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu=
/resctrl/internal.h
> index a4f1aa15f0a2..8b9b8f664324 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -58,7 +58,8 @@ struct rdt_fs_context {
>         struct kernfs_fs_context        kfc;
>         bool                            enable_cdpl2;
>         bool                            enable_cdpl3;
> -       bool                            enable_mba_mbps;
> +       bool                            enable_mba_mbps_local;
> +       bool                            enable_mba_mbps_total;
>         bool                            enable_debug;
>  };
>
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/=
resctrl/monitor.c
> index f136ac046851..d9e590f1cbc3 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -431,9 +431,10 @@ static int __mon_event_count(u32 rmid, struct rmid_r=
ead *rr)
>   */
>  static void mbm_bw_count(u32 rmid, struct rmid_read *rr)
>  {
> -       struct mbm_state *m =3D &rr->d->mbm_local[rmid];
>         u64 cur_bw, bytes, cur_bytes;
> +       struct mbm_state *m;
>
> +       m =3D get_mbm_state(rr->d, rmid, rr->evtid);

WARN_ON(m =3D=3D NULL) since we assume the caller has confirmed rr->evtid
is an MBM event?

>         cur_bytes =3D rr->val;
>         bytes =3D cur_bytes - m->prev_bw_bytes;
>         m->prev_bw_bytes =3D cur_bytes;
> @@ -521,19 +522,21 @@ static void update_mba_bw(struct rdtgroup *rgrp, st=
ruct rdt_domain *dom_mbm)
>         u32 closid, rmid, cur_msr_val, new_msr_val;
>         struct mbm_state *pmbm_data, *cmbm_data;
>         u32 cur_bw, delta_bw, user_bw;
> +       enum resctrl_event_id evt_id;
>         struct rdt_resource *r_mba;
>         struct rdt_domain *dom_mba;
>         struct list_head *head;
>         struct rdtgroup *entry;
>
> -       if (!is_mbm_local_enabled())
> +       if (!is_mbm_enabled())
>                 return;
>
>         r_mba =3D &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
> +       evt_id =3D r_mba->membw.mba_mbps_event;
>
>         closid =3D rgrp->closid;
>         rmid =3D rgrp->mon.rmid;
> -       pmbm_data =3D &dom_mbm->mbm_local[rmid];
> +       pmbm_data =3D get_mbm_state(dom_mbm, rmid, evt_id);

One defensive WARN_ON((!pmbm_data) for this function to ensure evt_id
is valid for this call and the ones in the loop below?

>
>         dom_mba =3D get_domain_from_cpu(smp_processor_id(), r_mba);
>         if (!dom_mba) {
> @@ -553,7 +556,7 @@ static void update_mba_bw(struct rdtgroup *rgrp, stru=
ct rdt_domain *dom_mbm)
>          */
>         head =3D &rgrp->mon.crdtgrp_list;
>         list_for_each_entry(entry, head, mon.crdtgrp_list) {
> -               cmbm_data =3D &dom_mbm->mbm_local[entry->mon.rmid];
> +               cmbm_data =3D get_mbm_state(dom_mbm, entry->mon.rmid, evt=
_id);
>                 cur_bw +=3D cmbm_data->prev_bw;
>                 delta_bw +=3D cmbm_data->delta_bw;
>         }
> @@ -616,18 +619,14 @@ static void mbm_update(struct rdt_resource *r, stru=
ct rdt_domain *d, int rmid)
>                 rr.evtid =3D QOS_L3_MBM_TOTAL_EVENT_ID;
>                 rr.val =3D 0;
>                 __mon_event_count(rmid, &rr);
> +               if (is_mba_sc(NULL) && rr.evtid =3D=3D r->membw.mba_mbps_=
event)
> +                       mbm_bw_count(rmid, &rr);
>         }
>         if (is_mbm_local_enabled()) {
>                 rr.evtid =3D QOS_L3_MBM_LOCAL_EVENT_ID;
>                 rr.val =3D 0;
>                 __mon_event_count(rmid, &rr);
> -
> -               /*
> -                * Call the MBA software controller only for the
> -                * control groups and when user has enabled
> -                * the software controller explicitly.
> -                */
> -               if (is_mba_sc(NULL))
> +               if (is_mba_sc(NULL) && rr.evtid =3D=3D r->membw.mba_mbps_=
event)
>                         mbm_bw_count(rmid, &rr);
>         }
>  }
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu=
/resctrl/rdtgroup.c
> index 69a1de92384a..5f64a0b2597c 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -2294,7 +2294,7 @@ static bool supports_mba_mbps(void)
>  {
>         struct rdt_resource *r =3D &rdt_resources_all[RDT_RESOURCE_MBA].r=
_resctrl;
>
> -       return (is_mbm_local_enabled() &&
> +       return (is_mbm_enabled() &&
>                 r->alloc_capable && is_mba_linear());
>  }
>
> @@ -2302,7 +2302,7 @@ static bool supports_mba_mbps(void)
>   * Enable or disable the MBA software controller
>   * which helps user specify bandwidth in MBps.
>   */
> -static int set_mba_sc(bool mba_sc)
> +static int set_mba_sc(bool mba_sc, enum resctrl_event_id mba_mbps_event)
>  {
>         struct rdt_resource *r =3D &rdt_resources_all[RDT_RESOURCE_MBA].r=
_resctrl;
>         u32 num_closid =3D resctrl_arch_get_num_closid(r);
> @@ -2313,6 +2313,7 @@ static int set_mba_sc(bool mba_sc)
>                 return -EINVAL;
>
>         r->membw.mba_sc =3D mba_sc;
> +       r->membw.mba_mbps_event =3D mba_mbps_event;
>
>         list_for_each_entry(d, &r->domains, list) {
>                 for (i =3D 0; i < num_closid; i++)
> @@ -2445,13 +2446,14 @@ static void rdt_disable_ctx(void)
>  {
>         resctrl_arch_set_cdp_enabled(RDT_RESOURCE_L3, false);
>         resctrl_arch_set_cdp_enabled(RDT_RESOURCE_L2, false);
> -       set_mba_sc(false);
> +       set_mba_sc(false, QOS_L3_MBM_LOCAL_EVENT_ID);
>
>         resctrl_debug =3D false;
>  }
>
>  static int rdt_enable_ctx(struct rdt_fs_context *ctx)
>  {
> +       enum resctrl_event_id mba_mbps_event;
>         int ret =3D 0;
>
>         if (ctx->enable_cdpl2) {
> @@ -2466,8 +2468,12 @@ static int rdt_enable_ctx(struct rdt_fs_context *c=
tx)
>                         goto out_cdpl2;
>         }
>
> -       if (ctx->enable_mba_mbps) {
> -               ret =3D set_mba_sc(true);
> +       if (ctx->enable_mba_mbps_local || ctx->enable_mba_mbps_total) {
> +               if (ctx->enable_mba_mbps_total)
> +                       mba_mbps_event =3D QOS_L3_MBM_TOTAL_EVENT_ID;
> +               else
> +                       mba_mbps_event =3D QOS_L3_MBM_LOCAL_EVENT_ID;

Total takes precedence over local when the user picks both.

> +               ret =3D set_mba_sc(true, mba_mbps_event);
>                 if (ret)
>                         goto out_cdpl3;
>         }
> @@ -2683,15 +2689,17 @@ enum rdt_param {
>         Opt_cdp,
>         Opt_cdpl2,
>         Opt_mba_mbps,
> +       Opt_mba_mbps_event,
>         Opt_debug,
>         nr__rdt_params
>  };
>
>  static const struct fs_parameter_spec rdt_fs_parameters[] =3D {
> -       fsparam_flag("cdp",             Opt_cdp),
> -       fsparam_flag("cdpl2",           Opt_cdpl2),
> -       fsparam_flag("mba_MBps",        Opt_mba_mbps),
> -       fsparam_flag("debug",           Opt_debug),
> +       fsparam_flag("cdp",                     Opt_cdp),
> +       fsparam_flag("cdpl2",                   Opt_cdpl2),
> +       fsparam_flag("mba_MBps",                Opt_mba_mbps),
> +       fsparam_string("mba_MBps_event",        Opt_mba_mbps_event),
> +       fsparam_flag("debug",                   Opt_debug),
>         {}
>  };
>
> @@ -2715,7 +2723,25 @@ static int rdt_parse_param(struct fs_context *fc, =
struct fs_parameter *param)
>         case Opt_mba_mbps:
>                 if (!supports_mba_mbps())
>                         return -EINVAL;
> -               ctx->enable_mba_mbps =3D true;
> +               if (is_mbm_local_enabled())
> +                       ctx->enable_mba_mbps_local =3D true;
> +               else
> +                       return -EINVAL;
> +               return 0;
> +       case Opt_mba_mbps_event:
> +               if (!supports_mba_mbps())
> +                       return -EINVAL;
> +               if (!strcmp("mbm_local_bytes", param->string)) {
> +                       if (!is_mbm_local_enabled())
> +                               return -EINVAL;
> +                       ctx->enable_mba_mbps_local =3D true;
> +               } else if (!strcmp("mbm_total_bytes", param->string)) {
> +                       if (!is_mbm_total_enabled())
> +                               return -EINVAL;
> +                       ctx->enable_mba_mbps_total =3D true;
> +               } else {
> +                       return -EINVAL;

It looks like if I pass
"mba_MBps_event=3Dmbm_total_bytes,mba_MBps_event=3Dmbm_local_bytes" I can
set both flags true.

> +               }
>                 return 0;
>         case Opt_debug:
>                 ctx->enable_debug =3D true;
> @@ -3780,16 +3806,27 @@ static int rdtgroup_rename(struct kernfs_node *kn=
,
>         return ret;
>  }
>
> +static char *mba_sc_event_opt_name(struct rdt_resource *r)
> +{
> +       if (r->membw.mba_mbps_event =3D=3D QOS_L3_MBM_LOCAL_EVENT_ID)
> +               return ",mba_MBps_event=3Dmbm_local_bytes";
> +       else if (r->membw.mba_mbps_event =3D=3D QOS_L3_MBM_TOTAL_EVENT_ID=
)
> +               return ",mba_MBps_event=3Dmbm_total_bytes";
> +       return "";
> +}
> +
>  static int rdtgroup_show_options(struct seq_file *seq, struct kernfs_roo=
t *kf)
>  {
> +       struct rdt_resource *r_mba =3D &rdt_resources_all[RDT_RESOURCE_MB=
A].r_resctrl;
> +
>         if (resctrl_arch_get_cdp_enabled(RDT_RESOURCE_L3))
>                 seq_puts(seq, ",cdp");
>
>         if (resctrl_arch_get_cdp_enabled(RDT_RESOURCE_L2))
>                 seq_puts(seq, ",cdpl2");
>
> -       if (is_mba_sc(&rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl))
> -               seq_puts(seq, ",mba_MBps");
> +       if (is_mba_sc(r_mba))
> +               seq_puts(seq, mba_sc_event_opt_name(r_mba));
>
>         if (resctrl_debug)
>                 seq_puts(seq, ",debug");
> --
> 2.41.0
>

Consider the setting-both-events quirk and a little bit of defensive
programming for get_mbm_data() returning NULL.

Assuming the case of "Local" is fixed in the commit message:

Reviewed-by: Peter Newman <peternewman@google.com>

Thanks!
