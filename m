Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A9E11737
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 13:10:30 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1c6052422acso135835ad.1
        for <patches@lists.linux.dev>; Fri, 29 Sep 2023 06:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695993029; x=1696597829; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GqsUDvMrMOqqFL7m1YQGMK07qbU6YXfwUB/IfzIJHSc=;
        b=Cdn7pvTH9xwQ0X9HLv8NqlVCtBsdWjphi010QILk3eha7Y5vRGukqqzrXh6dIEsqRv
         Zc3tYh9/3GQPcTuQKfTBuyQ/yS/P9dMwiQtG3xNxsC7nj4KNG2yu7tYxnsZO2VyANzuP
         ppM90qn/SsSwQc6uOScnravd6yW0nYrk8EbbBSLrc3lB15p7JpVjtSzMdkMVy/ubcIr4
         TmKvvg7j7wes5QsQXv5jyNBgs0Sp0nHRNPfVne8ycLAxwVq6uOVuPlFzqY1/fDa6mpFI
         M+AbxxtQVxv4vKGYvER8KeHAqllUTxa3b/gRZvK3WVrO0kGBvFeZVXYvIm0unf4EbUV8
         Aiew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695993029; x=1696597829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GqsUDvMrMOqqFL7m1YQGMK07qbU6YXfwUB/IfzIJHSc=;
        b=wmwJ+Uw6f9ZLMPLbvA5FXPxi3PytgRzDuO159j10tiuKvn+qk0OGjthLJNJIRpOEYo
         yXLjBJndpZ6o96gpZiuXrRcZ1iCgW3Iw93T/amsXUw8c/0vnViVgdBpFt96OJtvMMzYa
         KgbHyAJfolPyAmI73twlXf+1wnF4oYra6NWnC3o6KlLKRGRxEYs21pnSq5LRE6VqFWSr
         G/PGZOKCD9Y0SrMDQE4qfeNZg2QmW70el0wcboi8/frEt+NzstAWk+hgUEk1Z/9C6EUV
         uHwXBFQpLiwqfvXta4+UOZabbzV3gPd8NtVzVXEPVZDLie6zEp8B4YCjLXHbJO8WQ3j/
         pehA==
X-Gm-Message-State: AOJu0YyN0+AzCLE9jX4yhvl+hWNJNFvFNSbDTwOc7j4eHxMoBzGq/Eif
	2DwaRknwZ2k7xNPfoSms5GEIc0U3L8RYsxegr17d3w==
X-Google-Smtp-Source: AGHT+IGa8YbOF0A0sMykEjT9fwajbe4gFnID97FG5oUvq2FBzNkVBTg2g/J63Q35Ro7fybey1Btr2vmzoE31FXbTm+k=
X-Received: by 2002:a17:903:32d0:b0:1bc:29c3:5895 with SMTP id
 i16-20020a17090332d000b001bc29c35895mr978436plr.0.1695993029313; Fri, 29 Sep
 2023 06:10:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230829234426.64421-1-tony.luck@intel.com> <20230928191350.205703-1-tony.luck@intel.com>
 <20230928191350.205703-4-tony.luck@intel.com>
In-Reply-To: <20230928191350.205703-4-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 29 Sep 2023 15:10:18 +0200
Message-ID: <CALPaoCgb35dGiC87e_cqTOXKKZ-nQcokWou+u=mC7m2gR36G8w@mail.gmail.com>
Subject: Re: [PATCH v6 3/8] x86/resctrl: Prepare for different scope for
 control/monitor operations
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

On Thu, Sep 28, 2023 at 9:14=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
>
> @@ -352,7 +355,7 @@ struct rdt_domain *get_domain_from_cpu(int cpu, struc=
t rdt_resource *r)
>  {
>         struct rdt_domain *d;
>
> -       list_for_each_entry(d, &r->domains, hdr.list) {
> +       list_for_each_entry(d, &r->ctrl_domains, hdr.list) {

If someone were to call get_domain_from_cpu() looking for a
mon_domain, I don't think they'd be happy with the result.

This problem seems adequately addressed by the next patch where a type
mismatch on the return value would result.

In any case, perhaps the name could be updated to set expectations better.


> @@ -549,44 +552,101 @@ static void domain_add_cpu(int cpu, struct rdt_res=
ource *r)
>
>         rdt_domain_reconfigure_cdp(r);
>
> -       if (r->alloc_capable && domain_setup_ctrlval(r, d)) {
> +       if (domain_setup_ctrlval(r, d)) {
>                 domain_free(hw_dom);
>                 return;
>         }
>
> -       if (r->mon_capable && arch_domain_mbm_alloc(r->num_rmid, hw_dom))=
 {
> +       list_add_tail(&d->hdr.list, add_pos);
> +
> +       err =3D resctrl_online_ctrl_domain(r, d);
> +       if (err) {
> +               list_del(&d->hdr.list);
>                 domain_free(hw_dom);
> +       }
> +}
> +
> +static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> +{
> +       int id =3D get_domain_id_from_scope(cpu, r->mon_scope);
> +       struct list_head *add_pos =3D NULL;
> +       struct rdt_hw_domain *hw_mondom;

It's still hw_dom in domain_add_cpu_ctrl(), so why hw_mondom here?


> @@ -3711,16 +3711,16 @@ static void domain_destroy_mon_state(struct rdt_d=
omain *d)
>         kfree(d->mbm_local);
>  }
>
> -void resctrl_offline_domain(struct rdt_resource *r, struct rdt_domain *d=
)
> +void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_doma=
in *d)
>  {
>         lockdep_assert_held(&rdtgroup_mutex);
>
>         if (supports_mba_mbps() && r->rid =3D=3D RDT_RESOURCE_MBA)
>                 mba_sc_domain_destroy(r, d);
> +}
>
> -       if (!r->mon_capable)
> -               return;
> -
> +void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domai=
n *d)
> +{
>         /*
>          * If resctrl is mounted, remove all the
>          * per domain monitor data directories.

We did a lockdep_assert_held(&rdtgroup_mutex) for both types before.
Should we continue to do so here?


> --
> 2.41.0
>

In the resctrl2 prototype I complained that resctrl_resource was
awkwardly disjoint in its support for control and monitoring
groups[1]. In this patch, you seem to have already done most of the
hard work in separating the control and monitoring functionality, so
taking the next step and using a different structure to represent
control and monitoring resources would further improve the code by
statically typing monitoring and control resources, which would be
less error-prone than run-time checks on the alloc_capable and
mon_capable fields, which seem easy to forget.

I don't think this is necessary to complete SNC support, but it would
give me confidence that there isn't a misplaced {alloc,mon}_capable
check resulting in the wrong domain list being traversed. I will
probably do this myself later if you don't.

Thanks!
-Peter

[1] https://lore.kernel.org/all/CALPaoCj_oa=3DnATvOO_uysYvu+PdTQtd0pvssvm9_=
M1+fP-Z8JA@mail.gmail.com/
