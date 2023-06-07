Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695653D64
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 11:00:32 +0000 (UTC)
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-78a5384a5daso399048241.0
        for <patches@lists.linux.dev>; Wed, 07 Jun 2023 04:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686135631; x=1688727631;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=utFv2n7Nj2e/FDpN7qyLak8UIusvCi1A8IvvGYMYwhU=;
        b=DrwRvvr8wkCc60q+4TeytNMzG5yzg5YRzsakXJGC5Mw51JiiVpXEblZqcTLneUGJvd
         Sl1NFLHdxszDECCn/BTwb2PY65GlWu1yjId2I5ebbKULn5NN/9Cywfn2KeU4LYcUzD+0
         aVBVXuToS3UQiftn4+QXSg3fTT84fIo8/VwwmdS5+Lg32ucMC7dWX9sGw7asFrNqJ+du
         hRQ0EqOTlYd/EM2OtCPk9uRb5YTjsFKSOxVMzz9S86hL9AVjoxpqKux72m5Kks0rLNHY
         cq6HGMLo/dx7PHz6Z3KK0P6idgtfCnvnfrQ5B2WadXP6Zo+1J7Ugkd1IMVrZcKxtB8W7
         c0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686135631; x=1688727631;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=utFv2n7Nj2e/FDpN7qyLak8UIusvCi1A8IvvGYMYwhU=;
        b=AUJf6sOxq1ZfH3zuTqVSZplG+tZU1ar1PD8fe17zgcVRkDIqdPPh3L7G0AaT0xwoiq
         D0KoiLLKDv6ZNidvDmuTNxEl9clYJUcVfbuBocXygI2Vu01H3AG1VSA2GYNUrOmtqgJc
         yCFs6fCKR33EFtPMQ8sTBkXpaS5MeNaHbIt/4ZRc/YsB6SBYgRXUgC6yZCACJswzVUt8
         rJjhpvH1L3DrqOK1pOcN1+/RhUc+U6sL0iuzXvzwIBm+W7QqjvenLGig6Tz/ugt9r3eW
         noEMszBmOSsYx2V1l8zUUXv8rvlH5+fQKCBhCfhR6DfeaqrG7XVGdIIIXHo27z6H9WzM
         nDsg==
X-Gm-Message-State: AC+VfDzI/IhFtoDhrzax7ZFQeL4GMPwcKrsPwv3GLqEF6TC41wTejSI5
	vW9o72ej1sthtscI5l+dFURT7L5HQc2B61AcQ8tRAA==
X-Google-Smtp-Source: ACHHUZ4HFfYgNv7o5eIp7Pa4GlU+Wn3luys2k3t/inbdIsV5+uKmMsly2J5/GaooqGXZqbfoG+Fnb0Er/HoYVgIr5bQ=
X-Received: by 2002:a67:f7c4:0:b0:436:22fe:1d9 with SMTP id
 a4-20020a67f7c4000000b0043622fe01d9mr874244vsp.10.1686135630486; Wed, 07 Jun
 2023 04:00:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230606-fix-as-option-after-clang_flags-move-v1-1-a7f7b23a35e3@kernel.org>
In-Reply-To: <20230606-fix-as-option-after-clang_flags-move-v1-1-a7f7b23a35e3@kernel.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 7 Jun 2023 16:30:19 +0530
Message-ID: <CA+G9fYs8HCjaBzTDdXsQoEt3KP5rS=M34awGs8em7Jmx=yQkkw@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Add KBUILD_CPPFLAGS to as-option invocation
To: Nathan Chancellor <nathan@kernel.org>
Cc: masahiroy@kernel.org, ndesaulniers@google.com, nicolas@fjasle.eu, 
	trix@redhat.com, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, 
	Linux Kernel Functional Testing <lkft@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Jun 2023 at 04:10, Nathan Chancellor <nathan@kernel.org> wrote:
>
> After commit feb843a469fb ("kbuild: add $(CLANG_FLAGS) to
> KBUILD_CPPFLAGS"), there is an error while building certain PowerPC
> assembly files with clang:
>
>   arch/powerpc/lib/copypage_power7.S: Assembler messages:
>   arch/powerpc/lib/copypage_power7.S:34: Error: junk at end of line: `0b01000'
>   arch/powerpc/lib/copypage_power7.S:35: Error: junk at end of line: `0b01010'
>   arch/powerpc/lib/copypage_power7.S:37: Error: junk at end of line: `0b01000'
>   arch/powerpc/lib/copypage_power7.S:38: Error: junk at end of line: `0b01010'
>   arch/powerpc/lib/copypage_power7.S:40: Error: junk at end of line: `0b01010'
>   clang: error: assembler command failed with exit code 1 (use -v to see invocation)
>
> as-option only uses KBUILD_AFLAGS, so after removing CLANG_FLAGS from
> KBUILD_AFLAGS, there is no more '--target=' or '--prefix=' flags. As a
> result of those missing flags, the host target
> will be tested during as-option calls and likely fail, meaning necessary
> flags may not get added when building assembly files, resulting in
> errors like seen above.
>
> Add KBUILD_CPPFLAGS to as-option invocations to clear up the errors.
> This should have been done in commit d5c8d6e0fa61 ("kbuild: Update
> assembler calls to use proper flags and language target"), which
> switched from using the assembler target to the assembler-with-cpp
> target, so flags that affect preprocessing are passed along in all
> relevant tests. as-option now mirrors cc-option.
>
> Fixes: feb843a469fb ("kbuild: add $(CLANG_FLAGS) to KBUILD_CPPFLAGS")
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Closes: https://lore.kernel.org/CA+G9fYs=koW9WardsTtora+nMgLR3raHz-LSLr58tgX4T5Mxag@mail.gmail.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>

This proposed fix patch applied on top of Linux next and
built with clang and build test pass.
https://storage.tuxsuite.com/public/linaro/naresh/builds/2QsEzqEij2M3F1JkQAQfhpIpsXG/

> ---
>  scripts/Makefile.compiler | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/Makefile.compiler b/scripts/Makefile.compiler
> index 437013f8def3..e31f18625fcf 100644
> --- a/scripts/Makefile.compiler
> +++ b/scripts/Makefile.compiler
> @@ -32,7 +32,7 @@ try-run = $(shell set -e;             \
>  # Usage: aflags-y += $(call as-option,-Wa$(comma)-isa=foo,)
>
>  as-option = $(call try-run,\
> -       $(CC) -Werror $(KBUILD_AFLAGS) $(1) -c -x assembler-with-cpp /dev/null -o "$$TMP",$(1),$(2))
> +       $(CC) -Werror $(KBUILD_CPPFLAGS) $(KBUILD_AFLAGS) $(1) -c -x assembler-with-cpp /dev/null -o "$$TMP",$(1),$(2))
>
>  # as-instr
>  # Usage: aflags-y += $(call as-instr,instr,option1,option2)
>
> ---
> base-commit: feb843a469fb0ab00d2d23cfb9bcc379791011bb
> change-id: 20230606-fix-as-option-after-clang_flags-move-be88e993cbaa
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>

Best regards
Naresh Kamboju
