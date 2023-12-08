Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68EF1A727
	for <patches@lists.linux.dev>; Fri,  8 Dec 2023 18:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yUruWAKw"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d0b40bb704so10505ad.0
        for <patches@lists.linux.dev>; Fri, 08 Dec 2023 10:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702059977; x=1702664777; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=75zio9oghTkUElUZUVPQLES5Kw5emjlawW+mI0eiLfs=;
        b=yUruWAKw7M2uxFW2ErkEU8SXej7jKWAtn7/xB05AKthVvy3RDZZHRWII0U9Kc+CUCK
         ttJ7LPjk+pXljcCY1isQULSZCnsW5VKkb6EfKlU1pIbVcCLf029A3nD5/tv2IUcoYguf
         HYJhagVp/4xmS351UpjXstcvshv33UGmWBwKSpJ8+WhdHwo1uRhMnRTNnwFXvPOdEsCT
         bqftSGGR+vGz/ZuTILFOpStljSZC4UkOrVwRxZy0vMLCvKA2HvRYEhrpEoJ8zWidOXUg
         fUhgoFkF9NGtJuqkFGFBCTU3N5aoiCUoXesMEdThqdQtIgep65x1knf5cpB5PBQUu4v5
         6ufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702059977; x=1702664777;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=75zio9oghTkUElUZUVPQLES5Kw5emjlawW+mI0eiLfs=;
        b=d2YpscJphS1dreSRmHPmCmR9PFKlDKt30yqmx/P5Q+mnnhEh0AzM0BsGkUdXlS+Mmc
         qJhepdkKZXysQHLLK/SChs2Uub0GEOmcyF6NvLs0GvrMmjFaeCGVwruoljaJ6iHMrcVc
         BDiGM6uzFsaiyAocy70I3+AWqmp+ggX4eesyagnVZavbc8KQ9e2ABin/XmkMCkE1ZAcJ
         jeorHJKHKpx5Oyd4oph+0vplA/U3MXW6jHWKuifOpANiI/GyRN1Oq1NYACz0MpMcYYoL
         Op/XgQ+BdkMXclBNEsjKV+gF8TgNJ4OUAWWC6f8R39an0PRpg9TbVmOo/AZv5iZj29qI
         Iiiw==
X-Gm-Message-State: AOJu0YyXcCXUTEJXG+I/lAfT/Fd1SZxSl+sZaXPfJtL1Ot1WWnnP/xe5
	Ni8gnZ7rD1Euqmq5sNQ+AUVRQv0pienjqR4z5T85gw==
X-Google-Smtp-Source: AGHT+IG1AfEt/Tw51pB1tsGJgVQsx5i9xByxbif3lqRSlA8jKdPIkrRKdier/oxRIv+d1qmJOHXgkvTs0WvAfHdNXkE=
X-Received: by 2002:a17:903:244f:b0:1cf:9f0e:9524 with SMTP id
 l15-20020a170903244f00b001cf9f0e9524mr175431pls.27.1702059976843; Fri, 08 Dec
 2023 10:26:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231201214737.104444-1-tony.luck@intel.com> <20231207195613.153980-1-tony.luck@intel.com>
 <20231207195613.153980-3-tony.luck@intel.com>
In-Reply-To: <20231207195613.153980-3-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 8 Dec 2023 10:26:06 -0800
Message-ID: <CALPaoCgR5qNsSegKLzg2g2eE8EgQB9vixAdDOryQOr8HQ+CPAw@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] x86/resctrl: Use total bandwidth for mba_MBps
 option when local isn't present
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org, 
	Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse <james.morse@arm.com>, 
	Jamie Iles <quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 7, 2023 at 11:56=E2=80=AFAM Tony Luck <tony.luck@intel.com> wro=
te:
>
> On Intel systems the memory bandwidth monitoring events are
> independently enumerated. It is possible for a system to support
> total memory bandwidth monitoring, but not support local bandwidth
> monitoring. On such a system a user could not enable mba_sc mode.
> Users will see this highly unhelpful error message from mount:
>
>  # mount -t resctrl -o mba_MBps resctrl /sys/fs/resctrl
>  mount: /sys/fs/resctrl: wrong fs type, bad option, bad superblock on
>  resctrl, missing codepage or helper program, or other error.
>  dmesg(1) may have more information after failed mount system call.
>
> dmesg(1) does not provide any additional information.
>
> Modify the existing "mba_MBps" mount option to switch to total bandwidth
> monitoring if local monitoring is not available.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu=
/resctrl/rdtgroup.c
> index 5f64a0b2597c..7410513db45a 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -2725,6 +2725,8 @@ static int rdt_parse_param(struct fs_context *fc, s=
truct fs_parameter *param)
>                         return -EINVAL;
>                 if (is_mbm_local_enabled())
>                         ctx->enable_mba_mbps_local =3D true;
> +               else if (is_mbm_total_enabled())
> +                       ctx->enable_mba_mbps_total =3D true;
>                 else
>                         return -EINVAL;
>                 return 0;
> --
> 2.41.0
>

Reviewed-by: Peter Newman <peternewman@google.com>
