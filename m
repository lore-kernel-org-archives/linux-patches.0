Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A0045F6F
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 17:25:24 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1c5dfadb492so8165ad.1
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 10:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695317123; x=1695921923; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nEO84+iq6kC3VEaU1+DAhOho9ryfXauqS0h4qPx+tVo=;
        b=NVn/hxg7rWSLDio82wLEf9fctqgZn0rusd9UbG2NuzgLI/frFTFBjldAuwLFYe4tjC
         RQ4zjTsnJ27LhoMnOj1c/Ty+8IMYftHKZx5sGLCVT6o/Znh5aLuAqH4iLaoZRM0R2xn5
         m4HByy7y+UQbGJKf/zbTVivSrFWVP/co34P3jPUmNQ5qJXoqk0uF7pXv2qzI8vvsZeFk
         Yh8PV5/LdOxNE8mfgSQhgQQSH/IlH0QfDT3IWbaJVBOSWVJVhb8bunQ8CHw6XVYzP+su
         GFO2sVJJz4DBOUAnRyPdYz0TnrsPMb8GS1Xxu8ghavfN2778xiBoRCAHfCKUdrrCsSe5
         Xzkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695317123; x=1695921923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nEO84+iq6kC3VEaU1+DAhOho9ryfXauqS0h4qPx+tVo=;
        b=UbtsajATgT3agmmW68cFIPfYbfUa4DwhJfqZHzujv/OqIbxsDP/ACjjtPvUKjQFPUl
         qu3thk6kdWBJCiJ8Ioqi0Udk30euX8YGT1YJQ1bD/PmkLKq0mctlzp8Ck6SqJPgHr8iQ
         V2n2IkBvtO26+H/yljTXd/crdkEJStEukGJUd+5e8hQCLEL0R1HXKEFTrcvrPLUtE4kB
         2ZQFke8D9FKM+Ao7e8roMSRgM8yN63CBcE4PdGDFkWoETkC+a9egGgm8PoWKytLDtBmT
         2faOaPuoGUSKx26PWUzb7YN+ays1IIp0NH8CXLtIk/BmyXmly9rUBnIMIHfJbJ6RCeVu
         oreg==
X-Gm-Message-State: AOJu0YxQk4NsOzO6K55mOmeg0QYHU96M8MXNdqkUa5dTScZMr/boB+/L
	yQBIX6k5VRnMos5kVwEgGL43ieYQGNlgxyByIH/r5g==
X-Google-Smtp-Source: AGHT+IH34jeCfkePOj7hpV+ODrentVe9NkKGE3tVIgDkrp39gCm/9T4EqQqhcSsElnfpQxsWsPmXdWmVy7RyHw94dUk=
X-Received: by 2002:a17:902:e744:b0:1b8:89fd:61ea with SMTP id
 p4-20020a170902e74400b001b889fd61eamr201854plf.1.1695317123272; Thu, 21 Sep
 2023 10:25:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZQrSXh+riB7NnZuE@dhcp22.suse.cz> <4eb47d6a-b127-4aad-af30-896c3b9505b4@linux.microsoft.com>
 <ZQr3+YfcBM2Er6F7@dhcp22.suse.cz> <CALvZod7E_Jm9y+40OKtLs5EFA0ptKGjoe2BU58SY29pUiPc93g@mail.gmail.com>
 <ZQskGGAwlsr1YxAp@dhcp22.suse.cz> <CALvZod6b3=+=xXEUeWOQW3t_URJpeeVX46WjBHv5BS+436KoFA@mail.gmail.com>
 <ZQtRKzUOfdaVKRCF@dhcp22.suse.cz> <CALvZod5DSMoEGY0CwGz=P-2=Opbr4SmMfwHhZRROBx7yCaBdDA@mail.gmail.com>
 <ZQv2MXOynlEPW/bX@dhcp22.suse.cz> <f01b5d93-0f43-41c8-b3d8-40ef9696dcf8@linux.microsoft.com>
 <ZQwnUpX7FlzIOWXP@dhcp22.suse.cz>
In-Reply-To: <ZQwnUpX7FlzIOWXP@dhcp22.suse.cz>
From: Shakeel Butt <shakeelb@google.com>
Date: Thu, 21 Sep 2023 10:25:11 -0700
Message-ID: <CALvZod7fs_K3807N1=-5bmXbA=vhAk+zcF+VHS=T5ycK1eeMfg@mail.gmail.com>
Subject: Re: [REGRESSION] Re: [PATCH 6.1 033/219] memcg: drop kmem.limit_in_bytes
To: Michal Hocko <mhocko@suse.com>
Cc: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Tejun Heo <tj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, mathieu.tortuyaux@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 21, 2023 at 4:21=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Thu 21-09-23 12:43:05, Jeremi Piotrowski wrote:
> > On 9/21/2023 9:52 AM, Michal Hocko wrote:
> > > On Wed 20-09-23 14:46:52, Shakeel Butt wrote:
> > >> On Wed, Sep 20, 2023 at 1:08=E2=80=AFPM Michal Hocko <mhocko@suse.co=
m> wrote:
> > >>>
> > >> [...]
> > >>>> have a strong opinion against it. Also just to be clear we are not
> > >>>> talking about full revert of 58056f77502f but just the returning o=
f
> > >>>> EOPNOTSUPP, right?
> > >>>
> > >>> If we allow the limit to be set without returning a failure then we
> > >>> still have options 2 and 3 on how to deal with that. One of them is=
 to
> > >>> enforce the limit.
> > >>>
> > >>
> > >> Option 3 is a partial revert of 58056f77502f where we keep the no
> > >> limit enforcement and remove the EOPNOTSUPP return on write. Let's g=
o
> > >> with option 3. In addition, let's add pr_warn_once on the read of
> > >> kmem.limit_in_bytes as well.
> > >
> > > How about this?
> > > ---
> >
> > I'm OK with this approach. You're missing this in the patch below:
> >
> > // static struct cftype mem_cgroup_legacy_files[] =3D {
> >
> > +       {
> > +               .name =3D "kmem.limit_in_bytes",
> > +               .private =3D MEMFILE_PRIVATE(_KMEM, RES_LIMIT),
> > +               .write =3D mem_cgroup_write,
> > +               .read_u64 =3D mem_cgroup_read_u64,
> > +       },
>
> Of course. I've lost the hunk while massaging the revert. Thanks for
> spotting. Updated version below. Btw. I've decided to not pr_{warn,info}
> on the read side because realistically I do not think this will help all
> that much. I am worried we will get stuck with this for ever because
> there always be somebody stuck on unpatched userspace.
> ---
> From bb6702b698efd31f3f90f4f1dd36ffe223397bec Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.com>
> Date: Thu, 21 Sep 2023 09:38:29 +0200
> Subject: [PATCH] mm, memcg: reconsider kmem.limit_in_bytes deprecation
>
> This reverts commits 86327e8eb94c ("memcg: drop kmem.limit_in_bytes")
> and partially reverts 58056f77502f ("memcg, kmem: further deprecate
> kmem.limit_in_bytes") which have incrementally removed support for the
> kernel memory accounting hard limit. Unfortunately it has turned out
> that there is still userspace depending on the existence of
> memory.kmem.limit_in_bytes [1]. The underlying functionality is not
> really required but the non-existent file just confuses the userspace
> which fails in the result. The patch to fix this on the userspace side
> has been submitted but it is hard to predict how it will propagate
> through the maze of 3rd party consumers of the software.
>
> Now, reverting alone 86327e8eb94c is not an option because there is
> another set of userspace which cannot cope with ENOTSUPP returned when
> writing to the file. Therefore we have to go and revisit 58056f77502f
> as well. There are two ways to go ahead. Either we give up on the
> deprecation and fully revert 58056f77502f as well or we can keep
> kmem.limit_in_bytes but make the write a noop and warn about the fact.
> This should work for both known breaking workloads which depend on the
> existence but do not depend on the hard limit enforcement.
>
> [1] http://lkml.kernel.org/r/20230920081101.GA12096@linuxonhyperv3.guj3yc=
tzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
> Fixes: 86327e8eb94c ("memcg: drop kmem.limit_in_bytes")
> Fixes: 58056f77502f ("memcg, kmem: further deprecate kmem.limit_in_bytes"=
)
> Signed-off-by: Michal Hocko <mhocko@suse.com>

With one request below:

Acked-by: Shakeel Butt <shakeelb@google.com>

> ---
>  Documentation/admin-guide/cgroup-v1/memory.rst |  7 +++++++
>  mm/memcontrol.c                                | 18 ++++++++++++++++++
>  2 files changed, 25 insertions(+)
>
> diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentati=
on/admin-guide/cgroup-v1/memory.rst
> index 5f502bf68fbc..ff456871bf4b 100644
> --- a/Documentation/admin-guide/cgroup-v1/memory.rst
> +++ b/Documentation/admin-guide/cgroup-v1/memory.rst
> @@ -92,6 +92,13 @@ Brief summary of control files.
>   memory.oom_control                 set/show oom controls.
>   memory.numa_stat                   show the number of memory usage per =
numa
>                                      node
> + memory.kmem.limit_in_bytes          Deprecated knob to set and read the=
 kernel
> +                                     memory hard limit. Kernel hard limi=
t is not
> +                                     supported since 5.16. Writing any v=
alue to
> +                                     do file will not have any effect sa=
me as if
> +                                     nokmem kernel parameter was specifi=
ed.
> +                                     Kernel memory is still charged and =
reported
> +                                     by memory.kmem.usage_in_bytes.
>   memory.kmem.usage_in_bytes          show current kernel memory allocati=
on
>   memory.kmem.failcnt                 show the number of kernel memory us=
age
>                                      hits limits
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a4d3282493b6..0b161705ef36 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3097,6 +3097,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cg=
roup *objcg,
>  static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
>                                    unsigned int nr_pages)
>  {
> +       struct page_counter *counter;
>         struct mem_cgroup *memcg;
>         int ret;
>
> @@ -3107,6 +3108,10 @@ static int obj_cgroup_charge_pages(struct obj_cgro=
up *objcg, gfp_t gfp,
>                 goto out;
>
>         memcg_account_kmem(memcg, nr_pages);
> +
> +       /* There is no way to set up kmem hard limit so this operation ca=
nnot fail */
> +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +               WARN_ON(!page_counter_try_charge(&memcg->kmem, nr_pages, =
&counter));

WARN_ON_ONCE() please.
