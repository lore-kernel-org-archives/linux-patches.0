Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C7A262A7
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 18:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="11Qix851"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-45260b91a29so605313137.2
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 11:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696531134; x=1697135934; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bW/UNmvenx38n72xyxTklCxWrHzjkVxYi7U2YpzzmQY=;
        b=11Qix851akKUUWwMs/pp/u55TdPC1n09QgywgA6080wxbqFX5qDImRrgwmAR9uHBAK
         O0QoHXygZ9REAdNv+ENzCYjE+QSQdD+4sTHjA4FScfFOWqsOlAZkE28jnx0SvYzXpDzc
         7aw3y70HRWBUmWH0F54WpkZSwNdUj0hw/cJX1v3fp4QH0mAaRL/hxiSC7U7LvxzqJ1eu
         X68Mim2ejWiSWIUrT2+XXHK5v506Hcb6W630ojEavpOfM+Z5KXCXwj2oLOvaM86oIqLg
         e65JW+xyE9sba7Z97ZT9HVp1TmPuXJ6KxqyngSYTjgd9AbheSVr7JSD1SdAhhDoQm6DY
         IA+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696531134; x=1697135934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bW/UNmvenx38n72xyxTklCxWrHzjkVxYi7U2YpzzmQY=;
        b=OwXmSLz7YzAcJQXC+nvOYexkFCwx/ymfQAOPijZmzlAL4RdnBnoqzFg0mIg6nT01ps
         Ar076pHaONReJBHTAXmJiAm/IuCauwf/cP9WTwV2/P+pWspFNhpjP37VwvqrPbIUpS1Y
         nORsqo9JcIOFcbLroay4wDumWxuhKWZu01ZAUziiZYL4ZX2XRohu9Y7/VhRKZfjVxLKu
         ulLk8/rSEPgEUm9FH25hNobBWw8uCBtq/ZypcEKn46XtGG+c9xLpZKGBBlwVJZzP80xR
         rWocDOZHPvZdKae/v/v16TIpurYQcUmyP6kPoTGgPwfL2KMRPAAtgVHFyjf8TFqA7kec
         bgHQ==
X-Gm-Message-State: AOJu0Ywp0V7PqMOLmfQW7yHOEVVjwjo0qHBndbdINVWfMlyBZ5BRG/QW
	NQxN/s1ZXCkS0x9XYVQEgIkgujsIFTwL9ZGCnLBUPA==
X-Google-Smtp-Source: AGHT+IGbtsrcT2R0dV38C5J3+TVlCDTcINV+rHWPusOlKA8A6u1+y5KQlTfRnDHABYpAO2ulZxXdaWCMpFibP/AByIc=
X-Received: by 2002:a67:b107:0:b0:452:6465:4a35 with SMTP id
 w7-20020a67b107000000b0045264654a35mr5658104vsl.11.1696531133911; Thu, 05 Oct
 2023 11:38:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231002-enable-wincompatible-function-pointer-types-strict-w-1-v1-1-808ab955d42d@kernel.org>
In-Reply-To: <20231002-enable-wincompatible-function-pointer-types-strict-w-1-v1-1-808ab955d42d@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 5 Oct 2023 11:38:41 -0700
Message-ID: <CAKwvOdnzi9g1sz6C_CBFfaqRu7HQ4ZfBphpyBrgV1C=bviR_Uw@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Enable -Wincompatible-function-pointer-types-strict
 in W=1
To: Nathan Chancellor <nathan@kernel.org>
Cc: masahiroy@kernel.org, keescook@chromium.org, samitolvanen@google.com, 
	nicolas@fjasle.eu, trix@redhat.com, linux-kbuild@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 2, 2023 at 3:20=E2=80=AFPM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> -Wincompatible-function-pointer-types-strict aims to catch clang kernel
> Control Flow Integrity (kCFI) violations at build time (rather than run
> time) by validating function pointer assignments against the expected
> prototype, similar to the existing -Wincompatible-function-pointer-types
> that is considered a hard error in the kernel. The -strict variant
> requires the types to match exactly, as opposed to just matching in
> terms of ABI compatibility. This is primarily visible with int/unsigned
> int in lieu of enum types or vice versa.
>
> The tree is not completely clean, so this warning cannot currently be
> enabled unconditionally. However, there are only warnings in one
> subsystem ('drivers/counter'), so it is really close. In order to
> benefit from CI infrastructure that tests with W=3D1, enable this warning
> at that level, so that new instances have a chance of being caught and
> fixed during development.
>
> This should eventually be a hard error in a similar manner as
> Wincompatible-function-pointer-types but some subsystems test
> with W=3D1 + CONFIG_WERROR=3Dn, so it would be rude to break their builds
> when they do not care about warnings outside of their subsystem.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Sounds like we're pretty close to just enabling this by default.
Getting it on in W=3D1 for a cycle will help prevent any backslide.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  scripts/Makefile.extrawarn | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
> index 2fe6f2828d37..9662f7fd6e39 100644
> --- a/scripts/Makefile.extrawarn
> +++ b/scripts/Makefile.extrawarn
> @@ -108,6 +108,7 @@ KBUILD_CFLAGS +=3D $(call cc-option, -Wformat-overflo=
w)
>  KBUILD_CFLAGS +=3D $(call cc-option, -Wformat-truncation)
>  KBUILD_CFLAGS +=3D $(call cc-option, -Wstringop-overflow)
>  KBUILD_CFLAGS +=3D $(call cc-option, -Wstringop-truncation)
> +KBUILD_CFLAGS +=3D $(call cc-option, -Wincompatible-function-pointer-typ=
es-strict)
>
>  KBUILD_CPPFLAGS +=3D -Wundef
>  KBUILD_CPPFLAGS +=3D -DKBUILD_EXTRA_WARN1
>
> ---
> base-commit: ce9ecca0238b140b88f43859b211c9fdfd8e5b70
> change-id: 20231002-enable-wincompatible-function-pointer-types-strict-w-=
1-4a56b99b8c6f
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>


--=20
Thanks,
~Nick Desaulniers
