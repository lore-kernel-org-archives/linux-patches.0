Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42DE230996;
	Tue, 12 Nov 2024 11:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731411789; cv=none; b=B4eLhJ6JkE1ZO6m+lC4w7/9zJmGtejub9QmQ+BwLLSiUj+ikt6NKWdQrdRcAVoJ/FnlfephaMmiFamzHiAfO7zVn8gExbE+VPgkEdU2bC7XjDzGMJ2USLGsNWYyfHyMmyiSRoCkR132gqk86AZD033DrGcD9l3wtVKnICUpY9S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731411789; c=relaxed/simple;
	bh=ywmrmwU61cquYWqHb3soWy5KtfML++9SbcjwKY7ZNaI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hzBMPidEcp5xrNAYUFZvCCZ6nuWkavyqpWDgXxlhOwoI/FZgFNxpEdHb9t2TdEkZYQIZGp7rG7tzDK+69p3+3yyMFVsjVkGRpj2Q0ESte5PqRaMQtba2pLih9O4u3j5IMxeyQG+xtV1HodvdQcEeWP34kg+E1PDLpx+Mwh4gGYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PDX0EjKm; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PDX0EjKm"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2e9b23d189cso66965a91.1;
        Tue, 12 Nov 2024 03:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731411787; x=1732016587; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j0z23DhUHW7wNW00l4MV+YrP9iRE6XDYN76aiQ5G0Vc=;
        b=PDX0EjKmlNcQErwO4bc/9TEjD5Ug6SCu2kXXeTp5F48B2GQPNSO4gR432fzcyOM8Tr
         YzdzBaLHGm48UkM2TSo/JlnuCv4gQAyJTBMrENF1Fv+YRONydp4ptv86nGFL4Yw4WY0y
         EM/rqlLUj3oo9g1x/ReJKaHEZZBojdjaBFOfTZu/Et4WFVyD2Owa6DHYDs/BDXPyZd/X
         YPoyiCGivFucV8Glr6d5cocuglualz/V6rCfFK8+s7NohxzvrvVkVTgWIOFZQ/Nvaq+P
         +VrDgZeC6CQeoF95+tWmqYZEjot24Fao2E+iHSOzVlqkBqKNpx0lEeLoOCwIQTNGRqPo
         x/jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731411787; x=1732016587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j0z23DhUHW7wNW00l4MV+YrP9iRE6XDYN76aiQ5G0Vc=;
        b=gngu8l2FqdnzG6tx/HhLtpm7dt41nIve/TI80uMfsm4O3R9PG5/Jb3QzmSbnfXpjGx
         p6TSWHNqIA9BbNJwsw+ERR8y3fMPHWBwhFqC1+/CWLajibUE8pMeKwnbJiKSZ7Fe5okT
         yD7F4+9WNx3xIN8xAVQx/DbpWqS56n/3TmlsnQZuM2awTkRWKvo6DOo66tT0nJRBo2CL
         HNiDKl9qKmNU6An7m7qdRH1BFvnPLJ9gua1R4Dk42wQBpluax/6zrfYxWkq11JykI4du
         LKjOyzVqIwYOl91t2V8MKq4KTxyaJ0+/LeQT3LzzrwcAnE7tXfEa2WUKo2YNUueHysil
         3ucQ==
X-Forwarded-Encrypted: i=1; AJvYcCW65tYRHrD5sOT6xbJATxTV4W/lNk2CbW534OrNdNP0a3cIu+w7eT6fnHi6IOEKtC05yZTU@lists.linux.dev, AJvYcCX4fZZ/J9/lseP0O2EAU/S6g29LmHP58YrvejmIuM9eDmIUoOOaucroc7IAklSDGcsv3zj/PqPPyg==@lists.linux.dev
X-Gm-Message-State: AOJu0YynwRKOEudAzoucNPSIELq1HrBJMj4DwZ2nBK6/I0UMI3LBqdzO
	u3eFHOXJJGQEljTVGRKT/3G7RP9/ulOKaBOgGSgYpaKzO67airsoXw++J60D1kdGCmsUBf/xolP
	1sg/xVG7oysxrWWhjuq3qNR1q7pg=
X-Google-Smtp-Source: AGHT+IGggizb3kL12ZjnHA+9BEc8hjb63HpYjen5xTTmWs+MKPFBZ8CYn9vyQuK8cPPVTowrwyuTF+2y5HhglUBEUAA=
X-Received: by 2002:a17:90b:3ec5:b0:2e2:ada8:2984 with SMTP id
 98e67ed59e1d1-2e9b174818dmr8920433a91.4.1731411787013; Tue, 12 Nov 2024
 03:43:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241111201607.653149-1-ojeda@kernel.org>
In-Reply-To: <20241111201607.653149-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 12 Nov 2024 12:42:55 +0100
Message-ID: <CANiq72mUu9V0tAFRYju5=B9-EZ9hbPVMabKJvHm67n7BgSVQXw@mail.gmail.com>
Subject: Re: [PATCH v2] rust: warn on bindgen < 0.69.5 and libclang >= 19.1
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Ben Beasley <code@musicinmybrain.net>, 
	NoisyCoil <noisycoil@tutanota.com>, Matthias Geiger <werdahias@riseup.net>, 
	Masahiro Yamada <masahiroy@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11, 2024 at 9:16=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> When testing a `clang` upgrade with Rust Binder, Alice encountered [1] a
> build failure caused by `bindgen` not translating some symbols related to
> tracepoints. This was caused by commit 2e770edd8ce1 ("[libclang] Compute
> the right spelling location") changing the behavior of a function exposed
> by `libclang`. `bindgen` fixed the regression in commit 600f63895f73
> ("Use clang_getFileLocation instead of clang_getSpellingLocation").
>
> However, the regression fix is only available in `bindgen` versions
> 0.69.5 or later (it was backported for 0.69.x). This means that when
> older bindgen versions are used with new versions of `libclang`, `bindgen=
`
> may do the wrong thing, which could lead to a build failure.
>
> Alice encountered the bug with some header files related to tracepoints,
> but it could also cause build failures in other circumstances. Thus,
> always emit a warning when using an old `bindgen` with a new `libclang`
> so that other people do not have to spend time chasing down the same
> bug.
>
> However, testing just the version is inconvenient, since distributions
> do patch their packages without changing the version, so I reduced the
> issue into the following piece of code that can trigger the issue:
>
>     #define F(x) int x##x
>     F(foo);
>
> In particular, an unpatched `bindgen` will ignore the macro expansion
> and thus not provide a declaration for the exported `int`.
>
> Thus add a build test to `rust_is_available.sh` using the code above
> (that is only triggered if the versions appear to be affected), following
> what we did for the 0.66.x issue.
>
> Moreover, I checked the status in the major distributions we have
> instructions for:
>
>   - Fedora 41 was affected but is now OK, since it now ships `bindgen`
>     0.69.5.
>
>     Thanks Ben for the quick reply on the updates that were ongoing.
>
>     Fedora 40 and earlier are OK (older `libclang`, and they also now
>     carry `bindgen` 0.69.5).
>
>   - Debian Sid was affected but is now OK, since they now ship a patched
>     `bindgen` binary (0.66.1-7+b3). The issue was reported to Debian by
>     email and then as a bug report [2].
>
>     Thanks NoisyCoil and Matthias for the quick replies. NoisyCoil handle=
d
>     the needed updates. Debian may upgrade to `bindgen` 0.70.x, too.
>
>     Debian Testing is OK (older `libclang` so far).
>
>   - Ubuntu non-LTS (oracular) is affected. The issue was reported to Ubun=
tu
>     by email and then as a bug report [3].
>
>     Ubuntu LTS is not affected (older `libclang` so far).
>
>   - Arch Linux, Gentoo Linux and openSUSE should be OK (newer `bindgen` i=
s
>     provided). Nix as well (older `libclang` so far).
>
> This issue was also added to our "live list" that tracks issues around
> distributions [4].
>
> Cc: Ben Beasley <code@musicinmybrain.net>
> Cc: NoisyCoil <noisycoil@tutanota.com>
> Cc: Matthias Geiger <werdahias@riseup.net>
> Link: https://lore.kernel.org/rust-for-linux/20241030-bindgen-libclang-wa=
rn-v1-1-3a7ba9fedcfe@google.com/ [1]
> Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1086510 [2]
> Link: https://bugs.launchpad.net/ubuntu/+source/rust-bindgen-cli/+bug/208=
6639 [3]
> Link: https://github.com/Rust-for-Linux/linux/issues/1127 [4]
> Co-developed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> We would like to put this into the merge window, or ideally very soon aft=
er as a
> "fix" (it is not really a fix, but it is very convenient for people wonde=
ring
> why their toolchain may not work, especially if tracepoints land in the m=
erge
> window as expected).
>
> v2 (based on Alice's v1):
>   - Fixed libclang version number (we use a different `get_canonical_vers=
ion`
>     that returns one more digit).
>   - Added build test -- now we can detect binaries like Debian's that are
>     patched but do not change the version number.
>   - Added tests.
>   - Explained the current status of the distributions in the commit messa=
ge.

Cc'ing Kbuild too, so that they are aware, just in case -- sorry, I
should have done that in the patch itself yesterday:

    https://lore.kernel.org/rust-for-linux/20241111201607.653149-1-ojeda@ke=
rnel.org/

Cheers,
Miguel
