Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3E584FA7
	for <patches@lists.linux.dev>; Wed, 17 Apr 2024 08:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713342200; cv=none; b=SZKq+1XplUGwavJX+bYqPMUwwwEl+f4VLHOfiKtuC3KAV84PUtTk09cer0b0ACqhjgAS/DcqSoOa2xHRuqfshQPBv3XawtalwXgN8D/hrgockhUcP4IqAV7pUalVu5yIOBxGEgZBXIFKfV1JPd95geH3PWjM7ZUdS0wPQOP7FzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713342200; c=relaxed/simple;
	bh=C4tOCdvuBbe0nWsP1RYC0WfHw/yvoZ/fnppLyqdrzVg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NIfvlyUbyss5dti7iYFDrnOZSSrTpUTRapEFLIAWPAR2oqxhp9UW1SZWQRQZgpa1cnR7abC2eHyQdGPcwq7av0b1GQYfzBlI0B1TYa6YEDyuYHcDPAeHqyNZPgMu6X8jx/I4ecb/bcNZeVRp9sU347vbS4iCsTZi4/5BpUwKhXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cl0dXFi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cl0dXFi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96845C32786
	for <patches@lists.linux.dev>; Wed, 17 Apr 2024 08:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713342199;
	bh=C4tOCdvuBbe0nWsP1RYC0WfHw/yvoZ/fnppLyqdrzVg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Cl0dXFi7+cjctcO4EmDYic4Anp14X9g7oZQmOJzpgfUGrw+jlsNE4rsYPyaSGibd5
	 AgrdAoHAghKXhkZuTLTsdHvmIxd8bjB5LauD7bPkXD1DMbx39P9GtgNZ33VtZzKLpp
	 JfxgYOAT2KLRgnBpiDL4IsZ1RdcJpcEGZKQCWk0kilcCQaEqIZ0az8CrMEenlmvx0i
	 dqWgyK1XnPJD7BGHp5uiFJzNv6UZyhwNBo27xo6aAM/EEIw/ZkLrPyDo4AJVKUaliG
	 7eEYwPlT2cTGcnUA1IloRrDpURijulNu6E56nh2yOUvDC+UBMOh0sekIQ3V9XwuEqh
	 KaK9v7OdBfLIg==
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5acdbfa6e95so191405eaf.3
        for <patches@lists.linux.dev>; Wed, 17 Apr 2024 01:23:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUziHV510TwnhbRCK+9v2g78EzkjfSv5lbJlr2roWtwQBgVJjaKbznj54HzabfHMECjGS0/m8knK0NNvzns+mA3QpbFIITEMw==
X-Gm-Message-State: AOJu0YyaBlMD5Jfz+Q3bt/PS+cqm9+lacNJA7E2IdDNuT/ejvAPlu2/q
	2ATIn7M8kFYkX+K9QTUGFIs7X0x2Te8WWXqF4tgz3pgU09vC6W2hxLKltEQnkIx5JTVqbpYYQoh
	B+oTx9szdN/z+JJt9N/UFoMo38H0=
X-Google-Smtp-Source: AGHT+IEwWhyxwziJmItu3CudJNR/cbcOGfyy1lJsPIqbwVt2BL7zHv844Kmjt0yZaihq6jyNI/6OLt9Cemu6KrK30DQ=
X-Received: by 2002:a05:6820:4003:b0:5a7:db56:915c with SMTP id
 fh3-20020a056820400300b005a7db56915cmr17216803oob.1.1713342198919; Wed, 17
 Apr 2024 01:23:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240416211941.9369-1-tony.luck@intel.com> <20240416212250.9969-1-tony.luck@intel.com>
In-Reply-To: <20240416212250.9969-1-tony.luck@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 17 Apr 2024 10:23:06 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0hJbpCzGeshmP4NT0P6We=GTTgxVi0OTUoRF8DYpvKGCQ@mail.gmail.com>
Message-ID: <CAJZ5v0hJbpCzGeshmP4NT0P6We=GTTgxVi0OTUoRF8DYpvKGCQ@mail.gmail.com>
Subject: Re: [PATCH v3 69/74] x86/cpu/vfm: Update intel_soc_dts_thermal.c
To: Tony Luck <tony.luck@intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, 
	Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, linux-pm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2024 at 11:22=E2=80=AFPM Tony Luck <tony.luck@intel.com> wr=
ote:
>
> New CPU #defines encode vendor and family as well as model.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  include/linux/platform_data/x86/soc.h         | 12 ++++++------
>  drivers/thermal/intel/intel_soc_dts_thermal.c |  2 +-
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/platform_data/x86/soc.h b/include/linux/platfo=
rm_data/x86/soc.h
> index a5705189e2ac..f981907a5cb0 100644
> --- a/include/linux/platform_data/x86/soc.h
> +++ b/include/linux/platform_data/x86/soc.h
> @@ -20,7 +20,7 @@
>  static inline bool soc_intel_is_##soc(void)                    \
>  {                                                              \
>         static const struct x86_cpu_id soc##_cpu_ids[] =3D {      \
> -               X86_MATCH_INTEL_FAM6_MODEL(type, NULL),         \
> +               X86_MATCH_VFM(type, NULL),                      \
>                 {}                                              \
>         };                                                      \
>         const struct x86_cpu_id *id;                            \
> @@ -31,11 +31,11 @@ static inline bool soc_intel_is_##soc(void)          =
       \
>         return false;                                           \
>  }
>
> -SOC_INTEL_IS_CPU(byt, ATOM_SILVERMONT);
> -SOC_INTEL_IS_CPU(cht, ATOM_AIRMONT);
> -SOC_INTEL_IS_CPU(apl, ATOM_GOLDMONT);
> -SOC_INTEL_IS_CPU(glk, ATOM_GOLDMONT_PLUS);
> -SOC_INTEL_IS_CPU(cml, KABYLAKE_L);
> +SOC_INTEL_IS_CPU(byt, INTEL_ATOM_SILVERMONT);
> +SOC_INTEL_IS_CPU(cht, INTEL_ATOM_AIRMONT);
> +SOC_INTEL_IS_CPU(apl, INTEL_ATOM_GOLDMONT);
> +SOC_INTEL_IS_CPU(glk, INTEL_ATOM_GOLDMONT_PLUS);
> +SOC_INTEL_IS_CPU(cml, INTEL_KABYLAKE_L);
>
>  #undef SOC_INTEL_IS_CPU
>
> diff --git a/drivers/thermal/intel/intel_soc_dts_thermal.c b/drivers/ther=
mal/intel/intel_soc_dts_thermal.c
> index 9c825c6e1f38..718c6326eaf4 100644
> --- a/drivers/thermal/intel/intel_soc_dts_thermal.c
> +++ b/drivers/thermal/intel/intel_soc_dts_thermal.c
> @@ -36,7 +36,7 @@ static irqreturn_t soc_irq_thread_fn(int irq, void *dev=
_data)
>  }
>
>  static const struct x86_cpu_id soc_thermal_ids[] =3D {
> -       X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT, BYT_SOC_DTS_APIC_IRQ)=
,
> +       X86_MATCH_VFM(INTEL_ATOM_SILVERMONT, BYT_SOC_DTS_APIC_IRQ),
>         {}
>  };
>  MODULE_DEVICE_TABLE(x86cpu, soc_thermal_ids);
> --
> 2.44.0
>
