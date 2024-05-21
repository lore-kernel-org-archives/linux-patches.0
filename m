Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6FF482DA
	for <patches@lists.linux.dev>; Tue, 21 May 2024 08:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716278730; cv=none; b=nG349wm7me7hlF8lrWt9nMLwPqg6pEv25drEBmSF5xvxog3Ijxpk4+rbnS6gtsH/AiqfSFdPJ2QIoG1ylblkiYjhA+tzJuQftniJuMT4Sj3EbY87eSP9FzMw0xlxfx6GaOg2xn8ekPAUHUmKj3xlvs0o8/nsNgmGzKekbuqvVlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716278730; c=relaxed/simple;
	bh=5LQIN76LGk6Do2fSAu4Q5mVj5ZWkrdbmP+HHXF42gLc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GUh/G6cMxw4q0LvSNv4g7Guls5TCCckUNFpigeHoL6SapEnX4QGmuI+a+iSfzCXfxis+zI7OCmcglO2s9cLUVmlnQrrVOCFYpVPmzCNl9vwPRq4BDoORKcmzpOyRNxp3LQGmUR1dnOwroiUD0sXa+8CrT1MPZ89wRz6806gnVVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ar6MLNiM; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ar6MLNiM"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1edf506b216so96249485ad.2
        for <patches@lists.linux.dev>; Tue, 21 May 2024 01:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716278728; x=1716883528; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5LQIN76LGk6Do2fSAu4Q5mVj5ZWkrdbmP+HHXF42gLc=;
        b=Ar6MLNiMioJJRP6epJiytTZUNKjuBAtcP+cyloms7gODOSNTjo7tdm6Dv/q4VYf2wt
         g9DKCON44lBA0I5Oen1FRnR6kvmfEjAjB84Gpybaw9/dDKNUd+DQkTxEc/ZddMbjIAe8
         N5JHi6jKwuQK4d+Qc6BJg5msJLweLfljk/DZ8V4h4JPo9YZsotBZjFyoSJXM4x9oxFa3
         ln0fLguvbYr1iNWBVxB4sgPtxa5r280NXLb9xhgqbPyYuxS/0JX5cTPfVM4HBX5DqTug
         nVKBDdowrf4DfmPbUBgJezE7Qa8+dUsQ9mv39SyYuQGGjpOUZtKy0UZ5ajGYFjxEtus6
         WHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716278728; x=1716883528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5LQIN76LGk6Do2fSAu4Q5mVj5ZWkrdbmP+HHXF42gLc=;
        b=XINN242JHnlatvWP1EUQoVSV5bASKtan+DPJwrFyWUBWB9pjq0dgXYsudfpgGWe9ol
         LsxMmszuKQrioPk3VYd/uvv+YCfax8CRVwYWSKt3j5sbAh09eDsHj042TdhwMNV6duJx
         +Lyg3APxeqAtSNwCPewIK8D5AYd8J0xscjDLLrD2ik1CTEg7wce8Kps87fUSb3THcU8F
         oRsprrvxrDcNnSbeOz500s0se50QRygJvukVOD3whmAYvJKMojztX99kqxKjK3HO3poe
         Rwi5BgqAYzGOlm2RceCVQMehghgNFzferGoIqjkG5zBp61gfePxjZxWGrjRzKzkv3I/f
         sTjA==
X-Forwarded-Encrypted: i=1; AJvYcCUB54dKON8eqJH+grEmKDxINW+tOrcLq30VDoQ4WF/HO5vfyv0MMl4PqMKQG9xzLNkQr9FXPB0pVE9AOB8OZQQ5oY/cxnbQ+w==
X-Gm-Message-State: AOJu0YxeZQKUz0bXeLk6qqOwSshK9cd9SWcaBfBMZkrC0oIPCzpn0zeW
	NdGCIObZz+INwnsrRZFheGhzcyRrKugSS8xbc2BDhjOXLsc0uIan9ku6V3fr3NHusASaTwhjfTb
	HHrVs3kmkOxAT+3i6lttQbncUa4I=
X-Google-Smtp-Source: AGHT+IGbNuVDfS2/nNPcPvcGmN5RBzUfnDNopwneysKedo3ubG5AEFhMAOmNVByi64q15tTgCTzcyTQeLmmpXz4BNV4=
X-Received: by 2002:a17:90a:ca8b:b0:2bd:6f2e:8c1a with SMTP id
 98e67ed59e1d1-2bd6f2e91b7mr5738211a91.2.1716278728508; Tue, 21 May 2024
 01:05:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240519211235.589325-1-ojeda@kernel.org> <20240519211235.589325-2-ojeda@kernel.org>
 <CAK7LNATPx2wTEM=KDmGtcH8vVTB4suOhh-CUQKP54F8wtPWDiw@mail.gmail.com>
In-Reply-To: <CAK7LNATPx2wTEM=KDmGtcH8vVTB4suOhh-CUQKP54F8wtPWDiw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 21 May 2024 10:05:16 +0200
Message-ID: <CANiq72mcdtNie=t=HHhZnjQa7gQiDZin+TYP_7Rgi4kL83H2BA@mail.gmail.com>
Subject: Re: [PATCH 2/3] kbuild: rust: apply `CONFIG_WERROR` to all Rust targets
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 21, 2024 at 6:15=E2=80=AFAM Masahiro Yamada <masahiroy@kernel.o=
rg> wrote:
>
> Rust started to do something different from C.
>
> KBUILD_HOSTCFLAGS is not affected by any CONFIG option.
>
> The reason is because HOSTCC is needed for building Kconfig.
> If the flags for HOSTCC is changed by a CONFIG option,
> it would be a chicken-egg problem.
> Also, some host programs might be compiled even
> without .config at all. (e.g. scripts/unifdef)
>
> I know Rust will not become a part of the core infrastructure
> of the build system, but IMHO, host programs should not be
> affected by any CONFIG option.
>
> I do not like this patch.

Thanks Masahiro -- yeah, I can see how it makes sense for C host
programs, and consistency with those may be best, even if it is not
used for core infrastructure in the case of Rust.

Do you think it would be OK if we do it only for everything else, i.e.
no host programs? That covers most of the Rust things so far and would
have helped with the warning I linked above (which is why I would like
to change this -- one can pass the flag manually, of course, but
having more targets affected by `CONFIG_WERROR` means more developers
will have it enabled and thus notice earlier).

(I am also thinking whether it could make sense to eventually
explicitly mark the C host programs that would be exempt from
`CONFIG_WERROR` so that we could apply it to everything else -- I
guess it could be easy to get wrong and/or forget when new ones are
added.)

Cheers,
Miguel
