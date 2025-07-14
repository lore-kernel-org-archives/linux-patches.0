Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBF923BCFA
	for <patches@lists.linux.dev>; Mon, 14 Jul 2025 08:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752482931; cv=none; b=RyDt4YhZTvMevOT6xB5dmYY/q6qo9TiEsotXa5I8/yl7fGFm7w9aZDInpllyT39z+/Jqs4eVaqNLMVLa1rric9ecC8upkeeczyvmr8fOACs1l6SQzdAw1YUqsVy8G4wWbRNHM3quckRY3mri2gXEIGIbcPGeIQoEclU0S7StnYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752482931; c=relaxed/simple;
	bh=uEb/0VR0iaHwMvhSvE890850NYx60tZHhru27ZS4cjM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bGEdtP0i+hIGv9r6GhaU+HejNLjr4CJ13kTgqVVddjbvlYGi1t4ICHZoSFL1FCen8idMSFQHcwU4tQrxocwtt4T9A7u3ZV1WcSmJZTKxr8q5ab8mwpc/D5cZlvCEL/MOe7OZOEOZ9HccptOozUYnYb6kskpDh09hhDNobOfLYQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M6qUDSVR; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M6qUDSVR"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a54700a46eso2398962f8f.1
        for <patches@lists.linux.dev>; Mon, 14 Jul 2025 01:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752482928; x=1753087728; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V2eqVvWUGyRNHCflMNysYozlpMXxPdhkCEbZuAC8Zek=;
        b=M6qUDSVR6Xb+WWxEvru7otOrF9IecyxJC0YEPg34NR/uBRCkgSXjwjgFbYSA4olqWG
         waEi3JLDFsofljz5LR5C0BqsT0uPV6JFsPkWrlIMj6rSP8tX+gP2LK7d++VWTqQqaF52
         +lgvnADvZM9YpShEJ7XMqVRupLB5whAUfSmwXB7OMAHCqULcEejEvzdBjECj/V0OqFFs
         Kz9ET7YOMkyaGz5+MHmPdYCM/pPThxPbuKAdxdBLXeWekXUbf6x3AvsdfXum4UtQQxOe
         xf0V+5soBfqzMYkJeuxHX3WE+yfm7hCHU2/PF0cMN3BiZH5FSkB6ac4gwWib7KDGzddi
         543w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752482928; x=1753087728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V2eqVvWUGyRNHCflMNysYozlpMXxPdhkCEbZuAC8Zek=;
        b=GpwnwE68qf316/tDShwX3AQdlysC6rNRX+GlFl3dsgJZa8K2tKKrBwYV3wpn5wikMV
         7bk7Az2EO+KIZrhzuAYhQVHK2voi5ujpmXxeVGjixmyrqiZC4aUGB7OPs69/m0XNtT2l
         0EPY06MnNOCVrLYmcYaRoddK3ZnGB7/YBcqFMWbRVujRtPo9JPNdugnMbOY1jAgWoFU2
         OYhHnICiEP+tkCiElg2Q6WXpryWNJRoiVQw6Nc3X0HkRcjsUsggmeYsENNuT7Txns+iH
         UMHig47k6GaSskppG5GX1CrKbdwgGno7A7gnkv8BiGNWBI31OKSmpbkvb13SBPWiGXYt
         40xA==
X-Forwarded-Encrypted: i=1; AJvYcCXcTQtDrcXDr36eAfe2CMrXbFZv0nU0/pdYPNBzNPnG2a2Lwxv/h3I6oS3KJu8pOIGirVPpaH5O@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0dtSSadg18QflG394gBFxHLHzX2Gsd7tlju8M0P7obteQW187
	60XMwgezD4HCjC8infl2k9q41xBfcP7LRVVekzXIV7fZfSWDyrfr158P8w2Mxxy2Ieh07dLuMAb
	m2vqRTL7jIenyQuwp+D52QTGub4XRZWYL24hmZnK+
X-Gm-Gg: ASbGncurl1CNAO0Jw9+gt0xoQ6FNlBAB6IWhutiP74N73rbwLBHuE85QLQWX5dXl7Rb
	f0fD73znrqKl2AQq+KU2sbY7e1dmgk5JjyRH3YTfruKa1tSRRmzbiFKTx1D0U0STU4lyLx/3aG4
	0ZQSVyE3mtc/kOQVmr8w4KktrWdn/CQQA8JzZ47kedcAgWJtSFOgdIH6lUfS3LxGec27nZQtp7u
	CxNCb3IFSVELqu5TXZdf/l4KrVgfIo/Kx9DmA==
X-Google-Smtp-Source: AGHT+IFbanDs448XsjcCBuRD1OV+c4gYqU1GnCMBsm0XxQ4lxhrcMIJOjMNwYVAs8QqAaAg2E2jmgkH/HpU2k0t6Gys=
X-Received: by 2002:a05:6000:1ac5:b0:3a5:58a5:6a83 with SMTP id
 ffacd0b85a97d-3b5f187e264mr10159893f8f.13.1752482927867; Mon, 14 Jul 2025
 01:48:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250712160103.1244945-1-ojeda@kernel.org> <20250712160103.1244945-2-ojeda@kernel.org>
 <20250714084638.GL905792@noisy.programming.kicks-ass.net>
In-Reply-To: <20250714084638.GL905792@noisy.programming.kicks-ass.net>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 14 Jul 2025 10:48:33 +0200
X-Gm-Features: Ac12FXxMqzqa-86YzzJsOO2IogpXRlxWKeLa1kAAYOw4KPVk-KLgMAKuFCR7SWg
Message-ID: <CAH5fLgjtU1u=h8FY3im364AsC21GitnrjhBT=YJMmipH_ZWnQA@mail.gmail.com>
Subject: Re: [PATCH 1/2] objtool/rust: add one more `noreturn` Rust function
 for Rust 1.89.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2025 at 10:46=E2=80=AFAM Peter Zijlstra <peterz@infradead.o=
rg> wrote:
>
> On Sat, Jul 12, 2025 at 06:01:02PM +0200, Miguel Ojeda wrote:
> > Starting with Rust 1.89.0 (expected 2025-08-07), under
> > `CONFIG_RUST_DEBUG_ASSERTIONS=3Dy`, `objtool` may report:
> >
> >     rust/kernel.o: warning: objtool: _R..._6kernel4pageNtB5_4Page8read_=
raw()
> >     falls through to next function _R..._6kernel4pageNtB5_4Page9write_r=
aw()
> >
> > (and many others) due to calls to the `noreturn` symbol:
> >
> >     core::panicking::panic_nounwind_fmt
> >
> > Thus add the mangled one to the list so that `objtool` knows it is
> > actually `noreturn`.
> >
> > See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions"=
)
> > for more details.
> >
> > Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned=
 in older LTSs).
> > Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>
> > ---
> >  tools/objtool/check.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> > index f23bdda737aa..3257eefc41ed 100644
> > --- a/tools/objtool/check.c
> > +++ b/tools/objtool/check.c
> > @@ -224,6 +224,7 @@ static bool is_rust_noreturn(const struct symbol *f=
unc)
> >              str_ends_with(func->name, "_4core9panicking14panic_explici=
t")                            ||
> >              str_ends_with(func->name, "_4core9panicking14panic_nounwin=
d")                            ||
> >              str_ends_with(func->name, "_4core9panicking18panic_bounds_=
check")                        ||
> > +            str_ends_with(func->name, "_4core9panicking18panic_nounwin=
d_fmt")                        ||
> >              str_ends_with(func->name, "_4core9panicking19assert_failed=
_inner")                       ||
> >              str_ends_with(func->name, "_4core9panicking30panic_null_po=
inter_dereference")            ||
> >              str_ends_with(func->name, "_4core9panicking36panic_misalig=
ned_pointer_dereference")      ||
>
> Just having "_4core9panicking" substring is not sufficient?

That prefix just means it is defined in the panicking.rs file, which
also has a few functions that are not noreturn.

Alice
