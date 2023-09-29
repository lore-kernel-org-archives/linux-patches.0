Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793894123C
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 14:21:22 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1c60128d3f6so195385ad.0
        for <patches@lists.linux.dev>; Fri, 29 Sep 2023 07:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695997282; x=1696602082; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tIjMyRkvD4vXS0iKt2DZ+VffYOy0NMhKbaOoqihxMXc=;
        b=wH9DDLSg3Cq5skHXNXkcN56fBwGaFCmE/s6xSZ71q5tlzLAYhfqUGYB+fQjMdgkwCd
         +dJ+GZGlVuwJT9SHsCO+P/0BLXvTOBhw9tL3KDtWmDq6G2PeiY/xURs7bMZEWrTKO0Zx
         6FlsnKn6Y5nf/9zK5OQeDCRlN4jid5tiYccC8irb6FEImoeVX86nlUmr9/haQR6vtUx8
         sv014mrmhdiddM8KajvQybp3laynq8sDCRvsgYvAEDh24xstKtLqFSvOBZTcd2ku+DUX
         9p7hk6Ka1MxZ62Ll++/4Zw8EQbosW4N88df6skEeyy1Ax8QeG4MFltJZ36oZtheKmUOf
         nyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695997282; x=1696602082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tIjMyRkvD4vXS0iKt2DZ+VffYOy0NMhKbaOoqihxMXc=;
        b=O9gzCcDoVQBd/JvN6G74Q3FFPLupjvJ0d2pK0hTzByk/x91bGQLChAlk18I9CgbVHc
         WTzq15nflPcvlakNKUZ+vdQ2oGOZa2cibQZvjRA6LjPiNFwOHZV3lp17obb2yi5eESgr
         LDR+p+o6eaqKiTGlKmTCwwPH24NkTtJRYymQBdDIh2PWTD27DkHW6N6c4WS6OEhALWUC
         GuSsiowQeaGoTFr+lFnicSgkr6wfrVThxky6+rV/Dkyd2ZkG9Gt6WR9qvV0kyP8lo5iI
         QcbeXW4Z0i6N9qAn8phgSDZFV5MuOf+vg19aj9vqWVQpA+UThKvkp466T6IjjIM2QcLC
         PwSA==
X-Gm-Message-State: AOJu0Yz9wi4holq69HyJbpeBdq3ANjAXPmNbXs7z3JpdBbBRQ5jfdsp1
	KyFktM6DHIRYXRUaUldYzd3RKo+6rB/uyf1duEzUiw==
X-Google-Smtp-Source: AGHT+IHsG1ktZ0SAurPZ0QFRvK0fU8aHMiW++bixgCyT5nwhEB/N1BLwp8n50oH0IVEBUeadXQvjE9aoL/FG8TN+++0=
X-Received: by 2002:a17:902:f54f:b0:1c7:1fbc:b9e8 with SMTP id
 h15-20020a170902f54f00b001c71fbcb9e8mr792263plf.10.1695997281453; Fri, 29 Sep
 2023 07:21:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230829234426.64421-1-tony.luck@intel.com> <20230928191350.205703-1-tony.luck@intel.com>
 <20230928191350.205703-6-tony.luck@intel.com>
In-Reply-To: <20230928191350.205703-6-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 29 Sep 2023 16:21:10 +0200
Message-ID: <CALPaoCgJ2qcwvKOG2aUrkd=dwwPdGGtaJS43Tgs=DwXxMmwUhg@mail.gmail.com>
Subject: Re: [PATCH v6 5/8] x86/resctrl: Add node-scope to the options for
 feature scope
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
> Currently supported resctrl features are all domain scoped the same as th=
e
> scope of the L2 or L3 caches.
>
> Add RESCTRL_NODE as a new option for features that are scoped at the
> same granularity as NUMA nodes. This is needed for Intel's Sub-NUMA
> Cluster (SNC) feature where monitoring features are node scoped.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>
> Changes since v5:
>
> Updates to commit message.
>
>  include/linux/resctrl.h            | 1 +
>  arch/x86/kernel/cpu/resctrl/core.c | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 1c925e3db2ea..18ed787f9798 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -165,6 +165,7 @@ struct resctrl_schema;
>  enum resctrl_scope {
>         RESCTRL_L2_CACHE =3D 2,
>         RESCTRL_L3_CACHE =3D 3,
> +       RESCTRL_NODE,
>  };
>
>  /**
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/res=
ctrl/core.c
> index 726f00c01079..e61bf919ac78 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -511,6 +511,8 @@ static int get_domain_id_from_scope(int cpu, enum res=
ctrl_scope scope)
>         case RESCTRL_L2_CACHE:
>         case RESCTRL_L3_CACHE:
>                 return get_cpu_cacheinfo_id(cpu, scope);
> +       case RESCTRL_NODE:
> +               return cpu_to_node(cpu);
>         default:
>                 break;
>         }
> --
> 2.41.0
>

Looks fine.

Reviewed-by: Peter Newman <peternewman@google.com>
