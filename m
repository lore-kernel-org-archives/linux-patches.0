Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E763021CA1C
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 22:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754604741; cv=none; b=EqtysZbElbuqfUf007qLCTO62MEy6R2PIVVgSbr1ijV4COkjbSrTkRkMSafVtnUH8vhJ+SVLJ8AYeBJb7+AE+iexj9AGYCGUPp971yz2dbRb0GuhvJkS/4bF1D3MGbUjweBXY1Ae0yY+rI/kHxhmUPk+f/pYdUotVzMWDinVX7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754604741; c=relaxed/simple;
	bh=qlVM8CkTZMg669S/Ns0vKD+hb/qHNknFkrDMmeEEhEY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dpSPWVv0byE9v9HDVT4Ufqyz7LBeSedJ9nsjLMWQGFJY7if5e5Vct6RngKrj8U3nMvUxy8JEWA1jIKrNtKJAa3VeQtFFJiryLYaSRSZbOa/Iu02NtmibMxTYK8/alZXLQsaXl4qf/d+QASVbSiJjJ7vCueeuIO+5LqmQsMh7jmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ksneTJKr; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ksneTJKr"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-4fc18de8e1bso508125137.0
        for <patches@lists.linux.dev>; Thu, 07 Aug 2025 15:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754604738; x=1755209538; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTjFQN82cwVeM4ZQvGBqCFZVTMn8cacbLuxP2Do1hio=;
        b=ksneTJKrRnVnQBYdyTENCEVUq1KKBe+y9P40mkGpBuEINcaFg8OEoCLv3yOJPw/tid
         xw9N1zgmO0Cr5ruUjNibkfWi15G+TwPkysoDg+FgZKRKZ7x5ienC2eG4dmT/suUMYMCS
         /s7w4zzKXYTBNWy6Qf/N3E7a1WwRHT4CU7h4ma0EqB7qI93TwnxAJ3S5BBwDGw8dMnd5
         8ndp8TB5F9l1wpqpgY9Zhr3jZsHiOsTQ2FzZORBledC/Q3kkSnKsXJdzWOCvpOZGv2WN
         Fjm12uuV1SlRNOF2fgkwjDd48Az9NnqiIgdx98ZQWi6TsrObxsSYFhknnv7RWn2TtueD
         jY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754604738; x=1755209538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hTjFQN82cwVeM4ZQvGBqCFZVTMn8cacbLuxP2Do1hio=;
        b=dg8LnX/6jLDRVVznLxXRNUN4ZwsZ1IcH6u83y0n5r1dnSI0Ctt8VK3YDuRt9r4IqcZ
         9L9DRQxMM29UMnoWMnXTPLLAsGfECg9u/2KSmt8lUF2FUOd2zh7m3gwvpD3osXEIdzCU
         T72PwzR5vDOQ1zkDi5kVOgy02lgNMCF6I8mTZWXFK6FT0w0ClGIJcITPjJdcrEnW5WhM
         qx1KYT4cS0AlJDfgZotjkl8bUTvPp3JCTEQpQvH9LEZxr1eECFwnwbd25+1tiAE2TE0Q
         Al23kkRvdLOfQLDShk3fsCOQ7iOhv8kFNuEqyetQd5LJKdN2k5r4AQfpVAKIheTTVMD/
         Rg4g==
X-Forwarded-Encrypted: i=1; AJvYcCXR6K4UHEYgvwzSL35Z5Jyj4L3ObQ0uI624mArrfU9PgJtjsEOLctNKuF2ARrpDdHM5nU5mVEem@lists.linux.dev
X-Gm-Message-State: AOJu0YycL8BJtPdsN5xZE0+VT8BfVF1VrK88D3DdLTJu3V13W2JE/jfN
	GQqG0zLm2scM8SBhYY71OpuaHrXgQucwN/GroEvvh6F4X7zdnfWws9qDBhzLFcvOFL8XgkQF0Ss
	Zt/S4LsBjhA9is6ZT+pa8z72kc66OC8h94cdD9jcr
X-Gm-Gg: ASbGncvm3c/seHd7zU4YvAQBRUyT5vCotyZ/KVpyMCRHyVWGHDn+ky0m67ICFqAHRxG
	AwiaTnBWF/BEZaYN+P6DZ0oWj1nTXMN0I9FF8L6n85LA+wOJRK1uykzjMFgoRnV99d/9wepyBc1
	LT8kUAZuikmj+Mad++vKzwyCPiiCpXrxHxblX5FePueKvNGQLnk03rRZiqmgiSjHUQMtgr/OKdn
	R7pBCW7lLX4QZk8h5fvwPlA8xwztWrF888=
X-Google-Smtp-Source: AGHT+IEYFGr//L1F66PSo/HzzBCZ90AvQWOXuRI6gktcJUFA02QiCFgkPiLDUKRHn6BALGhSzkBYiT/d+GRH+TAj6a8=
X-Received: by 2002:a67:e710:0:b0:4f9:d929:8558 with SMTP id
 ada2fe7eead31-5060d7b0262mr340444137.10.1754604737443; Thu, 07 Aug 2025
 15:12:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250807-fix-counted_by-clang-19-v1-1-902c86c1d515@kernel.org>
In-Reply-To: <20250807-fix-counted_by-clang-19-v1-1-902c86c1d515@kernel.org>
From: Justin Stitt <justinstitt@google.com>
Date: Thu, 7 Aug 2025 15:12:06 -0700
X-Gm-Features: Ac12FXyAGlTv67GNm7hvR62c2Q7kwHSr8jwLhWy08UJpC4Mp2yOrNOga1MEvl64
Message-ID: <CAFhGd8pkSP9JTVnBzn7-Cm6JMtj-qBAgLMBP1JhLtt4unkruZQ@mail.gmail.com>
Subject: Re: [PATCH] hardening: Require clang 20.1.0 for __counted_by
To: Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	Bill Wendling <morbo@google.com>, linux-hardening@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 7, 2025 at 2:36=E2=80=AFPM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> After an innocuous change in -next that modified a structure that
> contains __counted_by, clang-19 start crashing when building certain
> files in drivers/gpu/drm/xe. When assertions are enabled, the more
> descriptive failure is:

Since this is just now breaking builds, it is OK to bump up the
minimum compiler version just in time.

For future travelers, the "innocuous change" popped up in -next as
Commit 535c445eb94c ("drm/xe: Add dependency scheduler for GT TLB
invalidations to bind queues"). I am not sure why the additional
struct member caused this crash but it seems like Bill's clang patch
solved it -- so I won't look into it any further.

>
>   clang: clang/lib/AST/RecordLayoutBuilder.cpp:3335: const ASTRecordLayou=
t &clang::ASTContext::getASTRecordLayout(const RecordDecl *) const: Asserti=
on `D && "Cannot get layout of forward declarations!"' failed.
>
> According to a reverse bisect, a tangential change to the LLVM IR
> generation phase of clang during the LLVM 20 development cycle [1]
> resolves this problem. Bump the version of clang that enables
> CONFIG_CC_HAS_COUNTED_BY to 20.1.0 to ensure that this issue cannot be
> hit.
>
> Link: https://github.com/llvm/llvm-project/commit/160fb1121cdf703c3ef5e61=
fb26c5659eb581489 [1]

Reviewed-by: Justin Stitt <justinstitt@google.com>

> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Should this be marked for stable? If this makes 6.17 final, I think we
> are fine for mainline and newer but I wonder if a patch that adds
> __counted_by to a structure would ever be backported and expose this
> problem there.
> ---
>  init/Kconfig | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index af4c2f085455..a2675ee1ef8c 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -117,10 +117,11 @@ config CC_HAS_NO_PROFILE_FN_ATTR
>
>  config CC_HAS_COUNTED_BY
>         bool
> -       # clang needs to be at least 19.1.3 to avoid __bdos miscalculatio=
ns
> -       # https://github.com/llvm/llvm-project/pull/110497
> -       # https://github.com/llvm/llvm-project/pull/112636
> -       default y if CC_IS_CLANG && CLANG_VERSION >=3D 190103
> +       # clang needs to be at least 20.1.0 to avoid potential crashes
> +       # when building structures that contain __counted_by
> +       # https://github.com/ClangBuiltLinux/linux/issues/2114
> +       # https://github.com/llvm/llvm-project/commit/160fb1121cdf703c3ef=
5e61fb26c5659eb581489
> +       default y if CC_IS_CLANG && CLANG_VERSION >=3D 200100
>         # supported since gcc 15.1.0
>         # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D108896
>         default y if CC_IS_GCC && GCC_VERSION >=3D 150100
>
> ---
> base-commit: f627b51aaa041cba715b59026cf2d9cb1476c7ed
> change-id: 20250807-fix-counted_by-clang-19-470d53f93aa0
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
