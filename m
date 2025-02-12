Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED7311CA9
	for <patches@lists.linux.dev>; Wed, 12 Feb 2025 00:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739321861; cv=none; b=pkKtZ0UPtOFvhgq41N1pxXvGAfSgnRep4HTzDCr8BE34115nGJ7q9jH8RfP/PQc15nGDVqgEJVGyBqosgSUgKDA2zsmIiLHUbr8Ex4qTOa9zexsbnpq4yc/DDkWFniAb96Xfg0sSgu1nfLbZbgZt6yFGsXYlDlIW81nVJ+1foN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739321861; c=relaxed/simple;
	bh=ZE/ltet4LHK7MQuN1AESeTZTqaYdweE9eCvmTMUDYtU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eO4BR40jU931aehk64eTqowseYzjMc0W1dnpeVZSdq19oWHJ+5dFUfDDdiqvXRoXkYmrW7EIASoCTN3V3l+e8Hi6W1I9Cr7Ww12qaYObJWhu74z3TFEHFY4iu5UzgjVpjKo07hm0vnUztWYVzsD8Qdo7nKD6WrgJrT0hI5U5sAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nP0j2h6i; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nP0j2h6i"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5de636e6937so4602a12.0
        for <patches@lists.linux.dev>; Tue, 11 Feb 2025 16:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739321858; x=1739926658; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tyBGo4NEk4ou27pmwT3GiAGuDVYoMKwfHMTAe8m2fBI=;
        b=nP0j2h6ivdLH60pdMBoi4tc1uY4N8fQ89ceteHIWYmET3Dpt3cwlqqjBSIQoJhUhVe
         fqFh0+l2QLw3dtYSEyZ/zbTGqN4x8nmGKHbW5/rUCVS8rt/WFpG3l3I46ujHydMtJaiy
         SJRmJUdToskpOj0PCQy7SRVM1W63oCjJ7tvXhruVBoZBSZxBd9xjTS0jB/nMajzjs0bJ
         +XVnV1nbpXymzK42rYd0p9PyXvzFiMgpZfCGuZ/GISEtuuupBU9pPf1vAFpuGAmLj5tX
         8Cre5+7KHb0kd5nKe3e8JGmj71kgQf71BsENRj10kFcNLBAXnd2WUKEqGJEq41lrIRW5
         SEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739321858; x=1739926658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tyBGo4NEk4ou27pmwT3GiAGuDVYoMKwfHMTAe8m2fBI=;
        b=mjvWl7PO+WVfQmLJSd44qBxKNYMOgvTx2czhu5g9I9RqVkDgCCHkoVfgy+m83iDuz6
         0U77tfWD71e5YrBh9WfTcBtzzswrCHgtnJQVbdzOlY6OPkQ4+aUe/Xa6e0qk+JQVpEkx
         0zgW7qf60IjSoNd2zdyE9e1Op4k9CBM+kr1lgQSH21kMMaQKZx6D/RC6CEpvlGpV6ua0
         ntzOp7YbjXNX0k/mkK02XByXMRcGSVpf3YwFlo63SRhRx4ZSegWVPYX6adHEXLcuszHA
         IJoi1al0V5fhIDaOD3x3n5NjXEBttDPOxYl0lNw4AR2DOxr9gHLsSd4qRrD4Extr2Kn3
         CYLg==
X-Forwarded-Encrypted: i=1; AJvYcCUhh+42QWsU0oYq5wiqAgcVER8dsp5V6K2V/aE2gMEEhCCrWdsApF7Oel2tU9BrWw9jkW14Wcqy@lists.linux.dev
X-Gm-Message-State: AOJu0YwyD9iL19xgqVPhGL37tStw9ukipdw/voD+7qu+CX3RiIG3ZvOr
	TWlIfIrqF2cq33p+8/pynDqd7OQ+ZjnoJj5m566c8yVPiuZvvsm58w3TC+BPEuf8u/WN1ngnF9/
	6i97qeo7BEMyiaLdfsNmEF1m/HcUR8WJxkVKR
X-Gm-Gg: ASbGncvwOkm5xkzFS27h1/zylkY11v/jrhGrdOKxlUDNBPmms5rZYXd05okuoq2KR++
	UqVnZjoDh93IWxsUwsj+5C5bRuRYY2VnBJ3Zu549R3MUoZe+/n1kba6wpn+0trV++AFfbr3128d
	kPeA04P4pEZDkaxEcfkO8Xk2a1/es=
X-Google-Smtp-Source: AGHT+IGGry5l4RQEnuSdk6aioJ+bv1rbvIM1o5se3iV5Jtj1b2iEWNaQAzttrNeymsRtOervTIxy8hxdeVXm7d1+3Ag=
X-Received: by 2002:a05:6402:ca5:b0:5dc:ea60:45aa with SMTP id
 4fb4d7f45d1cf-5deb0dc7a96mr19983a12.1.1739321857927; Tue, 11 Feb 2025
 16:57:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250210163732.281786-1-ojeda@kernel.org> <CALNs47uBcyTmBdTBAPXiBcAkE0-4tih9j=VAv1rRcTcf_c2yTg@mail.gmail.com>
In-Reply-To: <CALNs47uBcyTmBdTBAPXiBcAkE0-4tih9j=VAv1rRcTcf_c2yTg@mail.gmail.com>
From: Matthew Maurer <mmaurer@google.com>
Date: Tue, 11 Feb 2025 16:57:25 -0800
X-Gm-Features: AWEUYZlRV6pF3AGbc0XvrMoRFXalIUrBnJyNWQn2iVM9raDE_v1HBIS8LQ3IxnI
Message-ID: <CAGSQo00rWwhcT0SjhUn_e3o+TyCP2stadHwANkmE7-AEeSHBAA@mail.gmail.com>
Subject: Re: [PATCH] arm64: rust: clean Rust 1.85.0 warning using softfloat target
To: Trevor Gross <tmgross@umich.edu>
Cc: Miguel Ojeda <ojeda@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	moderated for non-subscribers <linux-arm-kernel@lists.infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Ralf Jung <post@ralfj.de>, Jubilee Young <workingjubilee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I successfully booted this on the emulator (with some additional
patches to our system unrelated to this issue), so

Tested-by: Matthew Maurer <mmaurer@google.com>


On Tue, Feb 11, 2025 at 3:10=E2=80=AFAM Trevor Gross <tmgross@umich.edu> wr=
ote:
>
> On Mon, Feb 10, 2025 at 10:38=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> =
wrote:
> >
> > Starting with Rust 1.85.0 (to be released 2025-02-20), `rustc` warns
> > [1] about disabling neon in the aarch64 hardfloat target:
> >
> >     warning: target feature `neon` cannot be toggled with
> >              `-Ctarget-feature`: unsound on hard-float targets
> >              because it changes float ABI
> >       |
> >       =3D note: this was previously accepted by the compiler but
> >               is being phased out; it will become a hard error
> >               in a future release!
> >       =3D note: for more information, see issue #116344
> >               <https://github.com/rust-lang/rust/issues/116344>
> >
> > Thus, instead, use the softfloat target instead.
> >
> > While trying it out, I found that the kernel sanitizers were not enable=
d
> > for that built-in target [2]. Upstream Rust agreed to backport
> > the enablement for the current beta so that it is ready for
> > the 1.85.0 release [3] -- thanks!
> >
> > However, that still means that before Rust 1.85.0, we cannot switch
> > since sanitizers could be in use. Thus conditionally do so.
> >
> > Cc: <stable@vger.kernel.org> # Needed in 6.12.y and 6.13.y only (Rust i=
s pinned in older LTSs).
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Matthew Maurer <mmaurer@google.com>
> > Cc: Alice Ryhl <aliceryhl@google.com>
> > Cc: Ralf Jung <post@ralfj.de>
> > Cc: Jubilee Young <workingjubilee@gmail.com>
> > Link: https://github.com/rust-lang/rust/pull/133417 [1]
> > Link: https://rust-lang.zulipchat.com/#narrow/channel/131828-t-compiler=
/topic/arm64.20neon.20.60-Ctarget-feature.60.20warning/near/495358442 [2]
> > Link: https://github.com/rust-lang/rust/pull/135905 [3]
> > Link: https://github.com/rust-lang/rust/issues/116344
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
>
> This is consistent with what has been discussed for a while on the Rust s=
ide.
>
> Reviewed-by: Trevor Gross <tmgross@umich.edu>
