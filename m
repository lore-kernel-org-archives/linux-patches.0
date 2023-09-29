Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB73A4418
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 12:09:54 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1c6193d6bb4so167105ad.0
        for <patches@lists.linux.dev>; Fri, 29 Sep 2023 05:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695989394; x=1696594194; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4tGzWMVpNkHmeXd9+StiHUNQluJqc763pD7utN+gAfM=;
        b=tIvpMEzXvvAz3xKm7QTtQ8HzMjAKQvbFPM4oK+tdMg+vIOp2f3vbEtQ/GGiLYLeBp4
         lrlqdayboE5xsI6x0PI+UB/XYDpLisfKaVtLoEsyaXGZ1fdMZTnyH0wJ64Pov6fb3NlT
         N4/zxid6bJokZdEhLS73/SnaFzTr7pCdW71HgfAuuMxS7ZdbMmlCusB+mdCH9M/impZq
         MN1MSyc10EgSzsbD0tF4zJkCwm+pBXBHyg5EzBY992fLyeJxRm0hNXL1eb8WNeNB3Vgh
         P/ozSJmrZJ+Sy94QXmkL7i0osEociYPMFeUNCzfA6rxhN14UL+riLXNkCj21vDGzNTLj
         2Ung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695989394; x=1696594194;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4tGzWMVpNkHmeXd9+StiHUNQluJqc763pD7utN+gAfM=;
        b=fGCMIISF1cF1Xj0ferUp+Lra7Ti3HGHzclB1VATZHJ8y6L6QoYPXzJJL6+3l+qsGGX
         q4Z9dSm+Dpf1WmC8dITvhfRDPzflv3Le/6eWDmoQzCwd89U5Iw7cyV83k36OM1w7hMFF
         1x0crM/JX2JCxqT60zmSzMle/IGOw97lhrlL9xYB2EcS3KvWsZ0LKQ95ThqJQSaszrb/
         8uqwH7NbDwNrfMNvUndcUHFWuXfvMOF6T0AGMtFpxc6qG4RWR14sl7v64QcrSCFqL6c1
         hzf1/EBdhXb0H1SoUqiQQwOVs5+uCvw50SOvktH9CvFiXzqbfhlXgSJrFmMxRGfgqBtl
         JMKQ==
X-Gm-Message-State: AOJu0YwEgXyFTPfMs7nRkJUkEeZrcblSkPjSD3r+runMdkuCjTcxANLf
	Wm2AK72E1BcCm/EP8G10UTCqVMfKawTk2oEaezsa4Q==
X-Google-Smtp-Source: AGHT+IGAyzbcOgd6nPp6UOIxRKbhqiu2HpCgiw/uVXKwWYpgnvy9crMH7Z9DQ1+e2bfTSz/u+4JbsS+CF3ZpoGwSaFs=
X-Received: by 2002:a17:903:2447:b0:1bc:66f2:4bb with SMTP id
 l7-20020a170903244700b001bc66f204bbmr957738pls.8.1695989393847; Fri, 29 Sep
 2023 05:09:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230829234426.64421-1-tony.luck@intel.com> <20230928191350.205703-1-tony.luck@intel.com>
 <20230928191350.205703-2-tony.luck@intel.com>
In-Reply-To: <20230928191350.205703-2-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 29 Sep 2023 14:09:42 +0200
Message-ID: <CALPaoChB5ryT96ZZBQb6+3=xO+A0uR-ToN0TWqUjLJ7bgi==Rg@mail.gmail.com>
Subject: Re: [PATCH v6 1/8] x86/resctrl: Prepare for new domain scope
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
> Resctrl resources operate on subsets of CPUs in the system with the
> defining attribute of each subset being an instance of a particular
> level of cache. E.g. all CPUs sharing an L3 cache would be part of the
> same domain.
>
> In preparation for features that are scoped at the NUMA node level
> change the code from explicit references to "cache_level" to a more
> generic scope. At this point the only options for this scope are groups
> of CPUs that share an L2 cache or L3 cache.
>
> Provide a more detailed warning message if a domain id cannot be found
> when adding a CPU. Just check and silent return if the domain id can't
> be found when removing a CPU.
>
> No functional change.

I see a number of diagnostic checks added below. Are you sure there's
no functional change?


> diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/=
cpu/resctrl/pseudo_lock.c
> index 8f559eeae08e..8c5f932bc00b 100644
> --- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
> +++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
> @@ -292,10 +292,14 @@ static void pseudo_lock_region_clear(struct pseudo_=
lock_region *plr)
>   */
>  static int pseudo_lock_region_init(struct pseudo_lock_region *plr)
>  {
> +       int scope =3D plr->s->res->scope;
>         struct cpu_cacheinfo *ci;
>         int ret;
>         int i;
>
> +       if (WARN_ON_ONCE(scope !=3D RESCTRL_L2_CACHE && scope !=3D RESCTR=
L_L3_CACHE))
> +               return -ENODEV;

Functional change?


> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu=
/resctrl/rdtgroup.c
> index 725344048f85..1cf2b36f5bf8 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -1345,10 +1345,13 @@ unsigned int rdtgroup_cbm_to_size(struct rdt_reso=
urce *r,
>         unsigned int size =3D 0;
>         int num_b, i;
>
> +       if (WARN_ON_ONCE(r->scope !=3D RESCTRL_L2_CACHE && r->scope !=3D =
RESCTRL_L3_CACHE))
> +               return -EINVAL;

This function returns unsigned int. That's a huge region!

-Peter
