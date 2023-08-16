Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841AD1ADCA
	for <patches@lists.linux.dev>; Wed, 16 Aug 2023 22:14:42 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-40c72caec5cso118881cf.0
        for <patches@lists.linux.dev>; Wed, 16 Aug 2023 15:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692224081; x=1692828881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fEeQ0BrGSycrd2HYJ/F64FkxcfNt1wG/F0GbqsiDMHc=;
        b=70ju2hKyUmKrm92QJdAPekeP5swEqHhWV+pqo3RFs5MKieF7pQIRafojB9i/a/v4Nr
         32vxbvFyIAqIC4N+k9/Y5OJngJdWTdbN3JXV2zbvldBeSLjjm1v86NdJXNywh9FIGmM1
         gGKv7IGp1kpAebh03fNNSdRCXUePVG25m6zjS5N9gDlMN+ljp+ZGk1wbw5a73DxUMwSc
         xQvlXGOjBegGHoozG5sNO9ItpgNORYlG8c6khwpUFoE0ExkXNI3k8CNRRrmJUSTg1xOZ
         TEt0OtEcpA9RRnh5yPiBnp2h4fRcA0Q8rh4bfYwGz57T/IqEF2s2XAbm7PUkZXDXT5Ui
         /Ebg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692224081; x=1692828881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fEeQ0BrGSycrd2HYJ/F64FkxcfNt1wG/F0GbqsiDMHc=;
        b=XEZhGG3HT1U1Su1AtZCaHj98WQuJutBldcwjbr8KT96Mt+brS1Y35ElW2f2oNq1XEc
         /l7qPS2aApousqDl32FXtFG3hjjk9P4GM7mLTyDg0Y4laOEG6/L+8aE0VJV5XsLp5Fu8
         9BFLc3NsriBObkmFWwI3MfwiGk//ZgndyP7zyP0F8vbGhZiAX4/GH/W7PAUONKzSsuTX
         L1PkK8ZimiT5EtRAIGdetfGlXtRhLKbGSP+4yuUmYAOWAAoGj1EC2jqoT5QJaRY7cdH2
         qJJAyerKgM4M0lePFbfYHUmFCz5DQ3btTgAyf3v4z2hoOXyPPfkT6YoOVxbtoZX3cMMX
         kwAw==
X-Gm-Message-State: AOJu0YxFgjUUYKR7nbtUSV5BXeDE1VpNu8xZTAvjpHMqDtwIwyAWJzJF
	WrwPCZR3JoInFzBfNoly8R53BmTd66IgUzlNTZDk2Q==
X-Google-Smtp-Source: AGHT+IEjhZ4cZOnjuNqtHWoNW/DytduS8DsjFgsLhaLs5ni7Dg5U6HX1s7FEfydYlPDtscBplZAGdPp0Bu0fCNlbDAg=
X-Received: by 2002:a05:622a:1a18:b0:3f9:56c:1129 with SMTP id
 f24-20020a05622a1a1800b003f9056c1129mr44310qtb.5.1692224081176; Wed, 16 Aug
 2023 15:14:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230816-mips-vdso-cond-export-__vdso_gettimeofday-v1-1-fe725254c782@kernel.org>
In-Reply-To: <20230816-mips-vdso-cond-export-__vdso_gettimeofday-v1-1-fe725254c782@kernel.org>
From: Fangrui Song <maskray@google.com>
Date: Wed, 16 Aug 2023 15:14:30 -0700
Message-ID: <CAFP8O3LN9j-qHcEmHE0mM-8F9rpMDZMe2wE5ybABPVV_UXtx9Q@mail.gmail.com>
Subject: Re: [PATCH] MIPS: VDSO: Conditionally export __vdso_gettimeofday()
To: Nathan Chancellor <nathan@kernel.org>
Cc: tsbogend@alpha.franken.de, linux-mips@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 16, 2023 at 2:59=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> ld.lld 16.0.0 and newer defaults to '--no-undefined-version', which
> causes the following error when CONFIG_MIPS_CLOCK_VSYSCALL is not set:
>
>   ld.lld: error: version script assignment of 'LINUX_2.6' to symbol '__vd=
so_gettimeofday' failed: symbol not defined
>
> Only export __vdso_gettimeofday() when it will be present in the final
> object file, which clears up the error.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202308170532.zxFFv25c-lkp@i=
ntel.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/mips/vdso/vdso.lds.S | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/mips/vdso/vdso.lds.S b/arch/mips/vdso/vdso.lds.S
> index d90b65724d78..836465e3bcb8 100644
> --- a/arch/mips/vdso/vdso.lds.S
> +++ b/arch/mips/vdso/vdso.lds.S
> @@ -94,7 +94,9 @@ VERSION
>  #ifndef CONFIG_MIPS_DISABLE_VDSO
>         global:
>                 __vdso_clock_gettime;
> +#ifdef CONFIG_MIPS_CLOCK_VSYSCALL
>                 __vdso_gettimeofday;
> +#endif
>                 __vdso_clock_getres;
>  #if _MIPS_SIM !=3D _MIPS_SIM_ABI64
>                 __vdso_clock_gettime64;
>
> ---
> base-commit: 2ccdd1b13c591d306f0401d98dedc4bdcd02b421
> change-id: 20230816-mips-vdso-cond-export-__vdso_gettimeofday-30ab92c716d=
4
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
>

LGTM as a maintainer of lld/ELF who has fixed some user-space packages
(https://github.com/gentoo/gentoo/pull/29097#issuecomment-1383304538).

Reviewed-by: Fangrui Song <maskray@google.com>


--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
