Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365C9290098;
	Fri,  9 May 2025 13:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746795904; cv=none; b=TFfHV1tS4peYiBA561Ty9/xrFUe4Oe1nUhivOr8TSooH9Rd3kSw20nFCxdSOYDteKENxXBu10dLybctwu3KyCrELICpVivDqdg5VnMdP9Lz9PaeVJXh8vQ4cujPrQiDGwxY7j3E/vX/RDJCMX2Qeyzz4piXMNVF/S5NHO7Y4csA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746795904; c=relaxed/simple;
	bh=FmVwSJxNUg2aUI0N9m/RMCXNtxciLU9Haq/NbQscd8s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XIaj8kYnR6TAjLIdEY6blguwlcjdC2/U1cbOu21M4UPtqNxHww5w4JvV7hCx/g113XGoQdv3hxzBlP3sdc0/skwoi8vXokcvjAHzGfFqILaSZYh4Sw9AlS+F8hnqvIf51+bvHc7HrF2c60x4tDToHiYPwLn4B9oEpPhnIiFjAMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WzZsUhwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WzZsUhwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE37C4CEE4;
	Fri,  9 May 2025 13:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746795903;
	bh=FmVwSJxNUg2aUI0N9m/RMCXNtxciLU9Haq/NbQscd8s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WzZsUhwDUkrjGIDcUSnhug73MwRhHcONIANG/8A1jZNDpxGSr5UBdNtvi0Al+4gTf
	 H/rjs7J+qzC8Qw11nrnJkqXjF72hKrnHYJynjbzkL3q8gf34Vuec1OHOzXs2Ll0K61
	 iVLUZfQXO1L2UYRB+WsnZw19R40NYJP6eYiYT/A5P2kHov8RDpEhGoQlvIEL6B7rgR
	 4fJrybC1OWQxhXYZ51x1+ETF+RwalDX0ql4PE5QEfEeSiSJc56lNhathCj7wPhRwGZ
	 FyncXbyiCxMJZEUcCChDhpdYDabU/gwaimewjEwTqGnlHF5tmx8mj6h45mNKGUaNGG
	 uZgpYzo/4R87Q==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-54e98f73850so2326131e87.1;
        Fri, 09 May 2025 06:05:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVgY9MMWAuEwuINw9eOt62O8EJGp1kVyNBYW3+xqKlSZGgSP3fEeKFBmOktWRTIfO86uRiN@lists.linux.dev, AJvYcCVjIqqhN0SVAaEeHczmaDm/JcPHxlKkLRRxm0gXVnzZN/fA94Oah3D4D7/OKx/MlKuIyVApA33KIg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyDzdzv4UJVwtEK3NFM4aONi0ZwSOitcdbLDW8s4TUXg9Knobk2
	RXUoBVKCpEzlvR5mQFiDStycAb3cW0rwPT/DSjP5nRJR/3EMLCf2am1CZZkK7+Zw9eqoU1AsM/b
	8jnhZjJFO9lr6edR3BIkEpD6fsT0=
X-Google-Smtp-Source: AGHT+IG8VctgCGK/mzPxGLWukx9uOf8RJV1VJv+ZiOkNDCyDET76qqeLySD3EeJPhDp5aD2/pIilmlPw2uqsnuvbwQo=
X-Received: by 2002:a05:651c:322b:b0:30b:bba5:ac18 with SMTP id
 38308e7fff4ca-326c4539511mr14636641fa.3.1746795902336; Fri, 09 May 2025
 06:05:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250506-default-const-init-clang-v2-1-fcfb69703264@kernel.org>
In-Reply-To: <20250506-default-const-init-clang-v2-1-fcfb69703264@kernel.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Fri, 9 May 2025 22:04:23 +0900
X-Gmail-Original-Message-ID: <CAK7LNATmW6SfUkF4uZBLVCDUK9NRpWUrmenat1HsSkLHDNmVTQ@mail.gmail.com>
X-Gm-Features: ATxdqUEy4Bcxp7BXwVtXarJXeZNnBZvBKO-QzH7y8oKcmxrKMPmwnWyPf4Sl0dU
Message-ID: <CAK7LNATmW6SfUkF4uZBLVCDUK9NRpWUrmenat1HsSkLHDNmVTQ@mail.gmail.com>
Subject: Re: [PATCH v2] kbuild: Disable -Wdefault-const-init-unsafe
To: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas.schier@linux.dev>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org, 
	Linux Kernel Functional Testing <lkft@linaro.org>, Marcus Seyfarth <m.seyfarth@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 7, 2025 at 6:06=E2=80=AFAM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> A new on by default warning in clang [1] aims to flags instances where
> const variables without static or thread local storage or const members
> in aggregate types are not initialized because it can lead to an
> indeterminate value. This is quite noisy for the kernel due to
> instances originating from header files such as:
>
>   drivers/gpu/drm/i915/gt/intel_ring.h:62:2: error: default initializatio=
n of an object of type 'typeof (ring->size)' (aka 'const unsigned int') lea=
ves the object uninitialized [-Werror,-Wdefault-const-init-var-unsafe]
>      62 |         typecheck(typeof(ring->size), next);
>         |         ^
>   include/linux/typecheck.h:10:9: note: expanded from macro 'typecheck'
>      10 | ({      type __dummy; \
>         |              ^
>
>   include/net/ip.h:478:14: error: default initialization of an object of =
type 'typeof (rt->dst.expires)' (aka 'const unsigned long') leaves the obje=
ct uninitialized [-Werror,-Wdefault-const-init-var-unsafe]
>     478 |                 if (mtu && time_before(jiffies, rt->dst.expires=
))
>         |                            ^
>   include/linux/jiffies.h:138:26: note: expanded from macro 'time_before'
>     138 | #define time_before(a,b)        time_after(b,a)
>         |                                 ^
>   include/linux/jiffies.h:128:3: note: expanded from macro 'time_after'
>     128 |         (typecheck(unsigned long, a) && \
>         |          ^
>   include/linux/typecheck.h:11:12: note: expanded from macro 'typecheck'
>      11 |         typeof(x) __dummy2; \
>         |                   ^
>
>   include/linux/list.h:409:27: warning: default initialization of an obje=
ct of type 'union (unnamed union at include/linux/list.h:409:27)' with cons=
t member leaves the object uninitialized [-Wdefault-const-init-field-unsafe=
]
>     409 |         struct list_head *next =3D smp_load_acquire(&head->next=
);
>         |                                  ^
>   include/asm-generic/barrier.h:176:29: note: expanded from macro 'smp_lo=
ad_acquire'
>     176 | #define smp_load_acquire(p) __smp_load_acquire(p)
>         |                             ^
>   arch/arm64/include/asm/barrier.h:164:59: note: expanded from macro '__s=
mp_load_acquire'
>     164 |         union { __unqual_scalar_typeof(*p) __val; char __c[1]; =
} __u;   \
>         |                                                                =
  ^
>   include/linux/list.h:409:27: note: member '__val' declared 'const' here
>
>   crypto/scatterwalk.c:66:22: error: default initialization of an object =
of type 'struct scatter_walk' with const member leaves the object uninitial=
ized [-Werror,-Wdefault-const-init-field-unsafe]
>      66 |         struct scatter_walk walk;
>         |                             ^
>   include/crypto/algapi.h:112:15: note: member 'addr' declared 'const' he=
re
>     112 |                 void *const addr;
>         |                             ^
>
>   fs/hugetlbfs/inode.c:733:24: error: default initialization of an object=
 of type 'struct vm_area_struct' with const member leaves the object uninit=
ialized [-Werror,-Wdefault-const-init-field-unsafe]
>     733 |         struct vm_area_struct pseudo_vma;
>         |                               ^
>   include/linux/mm_types.h:803:20: note: member 'vm_flags' declared 'cons=
t' here
>     803 |                 const vm_flags_t vm_flags;
>         |                                  ^
>
> Silencing the instances from typecheck.h is difficult because '=3D {}' is
> not available in older but supported compilers and '=3D {0}' would cause
> warnings about a literal 0 being treated as NULL. While it might be
> possible to come up with a local hack to silence the warning for
> clang-21+, it may not be worth it since -Wuninitialized will still
> trigger if an uninitialized const variable is actually used.
>
> In all audited cases of the "field" variant of the warning, the members
> are either not used in the particular call path, modified through other
> means such as memset() / memcpy() because the containing object is not
> const, or are within a union with other non-const members.
>
> Since this warning does not appear to have a high signal to noise ratio,
> just disable it.
>
> Cc: stable@vger.kernel.org
> Link: https://github.com/llvm/llvm-project/commit/576161cb6069e2c7656a8ef=
530727a0f4aefff30 [1]
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Closes: https://lore.kernel.org/CA+G9fYuNjKcxFKS_MKPRuga32XbndkLGcY-PVuoS=
wzv6VWbY=3Dw@mail.gmail.com/
> Reported-by: Marcus Seyfarth <m.seyfarth@gmail.com>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2088
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Changes in v2:
> - Disable -Wdefault-const-init-var-unsafe as well, as '=3D {}' does not
>   work in typecheck() for all supported compilers and it may not be
>   worth a local hack.
> - Link to v1: https://lore.kernel.org/r/20250501-default-const-init-clang=
-v1-0-3d2c6c185dbb@kernel.org



Applied to linux-kbuild.
Thanks.

I fixed up the conflict with the -Wdefault-const-init-field-unsafe patch.

Please check if it is correct.


--=20
Best Regards
Masahiro Yamada
