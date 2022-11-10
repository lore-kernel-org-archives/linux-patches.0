Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63221EA07
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 23:17:20 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id e129so2988842pgc.9
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 15:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a2bzNs4rtiIEWS4hP4fFa/WTzjX0pYcg+YnAfRUDQN0=;
        b=Xw3EpdN3gudzO9w1MQTSqivuHehUg3UFHs7GTJzfjHQuRrFtKgfDnTN5uTaXzTfxoG
         BrsSgabn0RC+9Rjyq1OQJG62qxSd3fOuTEH/MjtLZlI+P++RCJc3yIbi7ZAeaRwzvP6w
         8wyzh4TSPAHmK0q+rmuAB9O7THoPsu1HsTDZcpZVfgIY2SmxqZhk/cc014/nc9M3R5Up
         OuMXLbeH5ZKBofdUsvBIo2tAsxKL3MJ1mqTKCIbDtMQzTtgpP5qUHNR0nDFqI9QbFVKo
         p06DC7abQGdBPjxAZ/lHIVVcFsfnEt5ETNjR56PEHFa2ydVqf2IHnQm6HwHbI53yHuAb
         QgNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a2bzNs4rtiIEWS4hP4fFa/WTzjX0pYcg+YnAfRUDQN0=;
        b=HMczrTkEdy3pQfWeLPP4/hIuvkRABk2cnLTTcIltwvMsfeU+/bu/GOhC1sT+oWBLFQ
         +dk/ex6JBxJqS56xMlFhsuLRSBoNGGTgicv00u1HLJBsEYHkdNE6Y+c/Wd3RG616tjF4
         T19J1k2i4H73VhVuKFTsZQrWhMDsgx1USh+5N74TMlmtLgzYgLbdhD7Y8tZ2Qfn8QDMM
         e9abG1Dmz4Zci3tpC8fsV0Lb+/3oLMxhn5E7yC8d0AfxuzL0Mpa+YUAnf8YU1Af4UAPB
         maCEcwW78IVdIe3JSYjc53yyR7G+qxqdaZLTzoR15wwLKUyN61XBboEB/ztL7KKhsOro
         rO0A==
X-Gm-Message-State: ACrzQf1LjOd/bCgf8TfgH8QLRoFyEJ24vvq1FMhl6OkgVCK+5FxfyD7f
	jGrASLOMEiMdwBa4DsDJQ+ixOg==
X-Google-Smtp-Source: AMsMyM7fh4Kur0PAb6g0H7G7SKOATz8yhuh3ZZgW15M4GbiGWv0ZqC7iVD85WQJ+IQZgK22mOcu/hg==
X-Received: by 2002:a63:d513:0:b0:46f:6afe:d94b with SMTP id c19-20020a63d513000000b0046f6afed94bmr3775600pgg.72.1668122240093;
        Thu, 10 Nov 2022 15:17:20 -0800 (PST)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id e29-20020a056a0000dd00b005668b26ade0sm190138pfj.136.2022.11.10.15.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 15:17:19 -0800 (PST)
Date: Thu, 10 Nov 2022 15:17:19 -0800 (PST)
X-Google-Original-Date: Thu, 10 Nov 2022 15:14:30 PST (-0800)
Subject:     Re: [PATCH] RISC-V: vdso: Do not add missing symbols to version section in linker script
In-Reply-To: <20221108171324.3377226-1-nathan@kernel.org>
CC: Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
  Conor Dooley <conor@kernel.org>, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
  llvm@lists.linux.dev, patches@lists.linux.dev, nathan@kernel.org
From: Palmer Dabbelt <palmer@dabbelt.com>
To: nathan@kernel.org
Message-ID: <mhng-430179a1-e929-4bf8-8f7f-d176215f80a7@palmer-ri-x1c9a>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Tue, 08 Nov 2022 09:13:23 PST (-0800), nathan@kernel.org wrote:
> Recently, ld.lld moved from '--undefined-version' to
> '--no-undefined-version' as the default, which breaks the compat vDSO
> build:
>
>   ld.lld: error: version script assignment of 'LINUX_4.15' to symbol '__vdso_gettimeofday' failed: symbol not defined
>   ld.lld: error: version script assignment of 'LINUX_4.15' to symbol '__vdso_clock_gettime' failed: symbol not defined
>   ld.lld: error: version script assignment of 'LINUX_4.15' to symbol '__vdso_clock_getres' failed: symbol not defined
>
> These symbols are not present in the compat vDSO or the regular vDSO for
> 32-bit but they are unconditionally included in the version section of
> the linker script, which is prohibited with '--no-undefined-version'.
>
> Fix this issue by only including the symbols that are actually exported
> in the version section of the linker script.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1756
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/riscv/kernel/vdso/Makefile   | 3 +++
>  arch/riscv/kernel/vdso/vdso.lds.S | 2 ++
>  2 files changed, 5 insertions(+)
>
> diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
> index f2e065671e4d..82416ebf4cca 100644
> --- a/arch/riscv/kernel/vdso/Makefile
> +++ b/arch/riscv/kernel/vdso/Makefile
> @@ -28,6 +28,9 @@ obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
>
>  obj-y += vdso.o
>  CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
> +ifneq ($(filter vgettimeofday, $(vdso-syms)),)
> +CPPFLAGS_vdso.lds += -DHAS_VGETTIMEOFDAY
> +endif
>
>  # Disable -pg to prevent insert call site
>  CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os
> diff --git a/arch/riscv/kernel/vdso/vdso.lds.S b/arch/riscv/kernel/vdso/vdso.lds.S
> index 01d94aae5bf5..150b1a572e61 100644
> --- a/arch/riscv/kernel/vdso/vdso.lds.S
> +++ b/arch/riscv/kernel/vdso/vdso.lds.S
> @@ -68,9 +68,11 @@ VERSION
>  	LINUX_4.15 {
>  	global:
>  		__vdso_rt_sigreturn;
> +#ifdef HAS_VGETTIMEOFDAY
>  		__vdso_gettimeofday;
>  		__vdso_clock_gettime;
>  		__vdso_clock_getres;
> +#endif
>  		__vdso_getcpu;
>  		__vdso_flush_icache;
>  	local: *;
>
> base-commit: f0c4d9fc9cc9462659728d168387191387e903cc

Thanks, this is on fixes.  Something is confusing b4, so I've merged it 
using the old flow -- hopefully that still works ;)
