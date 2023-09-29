Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1334B4123C
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 14:22:05 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1c60128d3f6so195595ad.0
        for <patches@lists.linux.dev>; Fri, 29 Sep 2023 07:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695997325; x=1696602125; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYEFurrEEC58Pi6MuErcWJ3A1NxFP/ysymFeMwH4+H0=;
        b=eP+Wn6DIskfx5/oEZfDpyevbuOocpeSaVD7U4KjEzzusf1eXZ0deEBj9ou18KK61rZ
         eVBafRcxmDV5dHXLYRcK8sdXx5uq6isDcCh3QTeSnH2iPKW52ULa7Q2Arp+rh7sC+50E
         6odWpELHkQLsbu6zT+ezHitko0MWCzwcishfGXwGC/yba4w8Dj+6yJMKf9X0tItd0n/i
         gtJ2DOeyB/zpNehQaBn3yeHydAcNx2HDJpHNFImpegpAzDUU1AIQH++Pogg7sFPSWgPa
         3uhBxVi7AM31q/+ufpfdEIW4uRLrcEpwL40XjiQEt0UmTqid6I7bRbjfvCjfV2RJbHA/
         eClg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695997325; x=1696602125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yYEFurrEEC58Pi6MuErcWJ3A1NxFP/ysymFeMwH4+H0=;
        b=MTAbrA45feu2F8eNyG7cfo58t3/D5+Ipg7l7wRaaK/2NWHQmjZ0mgkQP62bCt10KXN
         BvS7k62aZ1X9j40+v4iCl5sIaJhLSyRZ9G3sPBLHmJheXI8x6YihPJiRNAVv+lP5TCkN
         s5GJiBtFS+Ca57uQG4YLDA/rtre9Q136o+dxH4358ymkvio6P79geTC6ZwykKZVLlnku
         puCGKFONFCxdqtLuETfPS3p81BPCUtkP5pQSFvm69u3quR5hqoQQlrQt3hOzvKxlUXbh
         b+teewFY2GmN7X81LuRZBlEpR4lz/xXs0GwdMwrCaQZq7U4am0VzGkbZW0/G74iHwn3H
         iI4g==
X-Gm-Message-State: AOJu0YzPvoQh8ztt2O1Dga52Onuaqlf4slmwXJJ4fA3CioHmV7RSzCHA
	FOLT+ci6L4pZLGULK/he9DrPcMNzpi6FqzKLLP80cA==
X-Google-Smtp-Source: AGHT+IHONXaoBfwbXAGD+xhM6NPRFrExlJFSRqqfsw7iuwEyKFEv1rwMEELo7No+ciZsiAeOEkmQIOfvUjDaN2Qc5nA=
X-Received: by 2002:a17:902:ab18:b0:1c4:21fe:2823 with SMTP id
 ik24-20020a170902ab1800b001c421fe2823mr930677plb.13.1695997324947; Fri, 29
 Sep 2023 07:22:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230829234426.64421-1-tony.luck@intel.com> <20230928191350.205703-1-tony.luck@intel.com>
 <20230928191350.205703-7-tony.luck@intel.com>
In-Reply-To: <20230928191350.205703-7-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 29 Sep 2023 16:21:54 +0200
Message-ID: <CALPaoCh0dzx2T8-u5ZQXXM0XqaZgJbUAGnRVBmbzHmQiHjvWTA@mail.gmail.com>
Subject: Re: [PATCH v6 6/8] x86/resctrl: Introduce snc_nodes_per_l3_cache
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
> Intel Sub-NUMA Cluster (SNC) is a feature that subdivides the CPU cores
> and memory controllers on a socket into two or more groups. These are
> presented to the operating system as NUMA nodes.
>
> This may enable some workloads to have slightly lower latency to memory
> as the memory controller(s) in an SNC node are electrically closer to the
> CPU cores on that SNC node. This cost may be offset by lower bandwidth
> since the memory accesses for each core can only be interleaved between
> the memory controllers on the same SNC node.
>
> Resctrl monitoring on Intel system depends upon attaching RMIDs to tasks
> to track L3 cache occupancy and memory bandwidth. There is an MSR that
> controls how the RMIDs are shared between SNC nodes.
>
> The default mode divides them numerically. E.g. when there are two SNC
> nodes on a socket the lower number half of the RMIDs are given to the
> first node, the remainder to the second node. This would be difficult
> to use with the Linux resctrl interface as specific RMID values assigned
> to resctrl groups are not visible to users.
>
> The other mode divides the RMIDs and renumbers the ones on the second
> SNC node to start from zero.
>
> Even with this redumbering SNC mode requires several changes in resctrl
> behavior for correct operation.

redumbering? Harsh.


> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu=
/resctrl/rdtgroup.c
> index b0901fb95aa9..a5404c412f53 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -1357,7 +1357,7 @@ unsigned int rdtgroup_cbm_to_size(struct rdt_resour=
ce *r,
>                 }
>         }
>
> -       return size;
> +       return size / snc_nodes_per_l3_cache;

To confirm, the size represented by a bit goes down rather than the
CBM mask shrinking in each sub-NUMA domain?

I would maybe have expected the CBM mask to already be allocating at
the smallest granularity the hardware supports.

>  }
>
>  /**
> @@ -2590,7 +2590,7 @@ static int rdt_parse_param(struct fs_context *fc, s=
truct fs_parameter *param)
>                 ctx->enable_cdpl2 =3D true;
>                 return 0;
>         case Opt_mba_mbps:
> -               if (!supports_mba_mbps())
> +               if (!supports_mba_mbps() || snc_nodes_per_l3_cache > 1)

Factor into supports_mba_mbps()?

>                         return -EINVAL;
>                 ctx->enable_mba_mbps =3D true;
>                 return 0;
> --
> 2.41.0
>

Reviewed-by: Peter Newman <peternewman@google.com>
