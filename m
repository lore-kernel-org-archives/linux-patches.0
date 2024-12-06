Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8185810957
	for <patches@lists.linux.dev>; Fri,  6 Dec 2024 01:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733449759; cv=none; b=H5NVT0e5txA34auFrSStNG+dbY6cAShQGfQcwUBjbkFbwqbSTfzME8kxAUDmbaEhk44SmXLD4VUURxPrVozRRwpEx3ln6O8lIeqyaWKYUTx2+9qgj+PjmXS+ijuDCcHeleVgay9Do0pORWtKNc9jFzRIkDkM17kWloIF31rgf18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733449759; c=relaxed/simple;
	bh=LMmlWKNmVBwdw/whPUOfRU56EnAaGuw/30vVRzfcLnA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ae3i1iYyXk0Y7FI2pwCB1NfPnKrBvvFVHErLtYsrTwR4pIxjP48MAuwv5D5KGHgiqcI9Wo0shc39LVIWjmdgjjjEF1iJLqqzcLlmRYQkfTcGTsWGuxpfIkQfciop4sq/k6PZe/9GoXB88nGSsSaFr/P+Ii58EMJ7mhNX9gEUH6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=REYDwSHQ; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="REYDwSHQ"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d0d71d7f00so2446144a12.3
        for <patches@lists.linux.dev>; Thu, 05 Dec 2024 17:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733449756; x=1734054556; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/v1bu1qzcHSaRbclvMhL2gHRSj6sckPpuptjguLzmU=;
        b=REYDwSHQqlY+zbGU6sO7mzzIg4fy8p39se7fHDCMGn1pDdU4F341d2TvLKLQ+m+RjM
         s4EadLeJpivsgxsL6d8f680f4t3WQt0d9h0xpHqdVhX6CMV+Gy6oUx1LuhtO44dzQ7EO
         4wektLd7ILufO+fq/RmQx6+ZTObnQIQbWTwH15dZy/p9lfQH8My+UguSXuN13OFbO7Jb
         2ZNbSA6nzZwd5mODqtLpwPzdgAmX+JwkzJ/SEJIl5sL9EapCyt8X9pCZyVnAp7chpirU
         VC3KC188VRnauWIPNgDJokaZ0wqE7mw1Syz+LqEJhMHHqleGk+uI+XZCLJZEF+zo1B04
         0Uwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733449756; x=1734054556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g/v1bu1qzcHSaRbclvMhL2gHRSj6sckPpuptjguLzmU=;
        b=TASqu6tkehv5mKMac6n86QMA3XMNnWU6A+MW3HviYldsYFL73qBKwxWkggpu07pwqY
         BwMN1kWX+CwE3gNxPdh/2gOCWmS2H4dsqFs9gOf4EEo3zgXtWu5z4CvG50gKJnQ2x0mV
         70Yrgs7qPXGzpbauYRc4yZfai36u8Vr0Dn+NR19oMyMuuylyobqRkpKemw/x28INtrlM
         Z5LEbvQjYmEBDJ7q0OIxwd2EQZqLlMsKrLbngv7O513mpXhKw0du32JdU/0OTpbc625W
         Pkm4Xne2mB7Wj34mGtz/TaGinRptZ8kyNhEJE8RI/fhD9D26QuDbQaPcE9Bg32P/rAOe
         RYKg==
X-Forwarded-Encrypted: i=1; AJvYcCVDnXDKSVtxdRShvUAsaEUwpYox3dVBOyvMgPez2QbDnpwDr0nw82l5xG67aMhNNyYepcnX/Hrd@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7yKAMzoM7fa8mCMerDyvjY3zkhfyPEh3Jd7Zh+iRQOUbPI+cn
	uVmYggMohAzf4DLk+nE3vJiyTLEPBDaHph10TJyETvos5Ck1KZeO4IK3gvRgiXET+Nlybtx7kpF
	NHBGnrSitm6kXAlm9vAVkAijpGB6iXFJnWdnM
X-Gm-Gg: ASbGnctWVepBPbRJLrEf8YURNrrw5rE4lyt5BlX0QNvOZ/MvLvwUdr8IE3u5FzqJ8HZ
	1DDTvmYPvpZNOH45K6FFucurxJpmy9yA4lk2+S35nzIkm82YiPqpuWrv+fbNatfxO
X-Google-Smtp-Source: AGHT+IHWoFKow2oW9dCX31mwU7asjyqdFAGshEQB6zNAgVBklECaZ8FGAbU3zPEKbfahKyrrE3z9TE1WY+b0pveDS+8=
X-Received: by 2002:a05:6402:320d:b0:5d1:2677:b047 with SMTP id
 4fb4d7f45d1cf-5d3be720dd8mr1350471a12.28.1733449755904; Thu, 05 Dec 2024
 17:49:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112184455.855133-1-ojeda@kernel.org> <CAABy=s1u75ywAECbkCmGfyt+Yp5khnF0UVcezA-_BEDWUVrHkw@mail.gmail.com>
 <CAK7LNAQJUdubjkvV0T0XRU8=336rV88b7+t6BP4xR9v_g38eKQ@mail.gmail.com>
In-Reply-To: <CAK7LNAQJUdubjkvV0T0XRU8=336rV88b7+t6BP4xR9v_g38eKQ@mail.gmail.com>
From: "Hong, Yifan" <elsk@google.com>
Date: Thu, 5 Dec 2024 17:48:38 -0800
Message-ID: <CAABy=s3ONLwVugBSc=DhC8MdGa9YaAM6ZL5yrWRciLDLLtKmrw@mail.gmail.com>
Subject: Re: [PATCH v3] kbuild: rust: add PROCMACROLDFLAGS
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, 
	linux-kbuild@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 5:28=E2=80=AFPM Masahiro Yamada <masahiroy@kernel.or=
g> wrote:
>
> On Fri, Dec 6, 2024 at 8:40=E2=80=AFAM Hong, Yifan <elsk@google.com> wrot=
e:
> >
> > On Tue, Nov 12, 2024 at 10:45=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org=
> wrote:
> > >
> > > From: HONG Yifan <elsk@google.com>
> > >
> > > These are flags to be passed when linking proc macros for the Rust
> > > toolchain. If unset, it defaults to $(KBUILD_HOSTLDFLAGS).
> > >
> > > This is needed because the list of flags to link hostprogs is not
> > > necessarily the same as the list of flags used to link libmacros.so.
> > > When we build proc macros, we need the latter, not the former (e.g. w=
hen
> > > using a Rust compiler binary linked to a different C library than hos=
t
> > > programs).
> > >
> > > To distinguish between the two, introduce this new variable to stand
> > > out from KBUILD_HOSTLDFLAGS used to link other host progs.
> > >
> > > Signed-off-by: HONG Yifan <elsk@google.com>
> > > Link: https://lore.kernel.org/r/20241017210430.2401398-2-elsk@google.=
com
> > > [ v3:
> > >
> > >   - `export`ed the variable. Otherwise it would not be visible in
> > >     `rust/Makefile`.
> > >
> > >   - Removed "additional" from the documentation and commit message,
> > >     since this actually replaces the other flags, unlike other cases.
> > >
> > >   - Added example of use case to documentation and commit message.
> > >     Thanks Alice for the details on what Google needs!
> > >
> > >   - Instead of `HOSTLDFLAGS`, used `KBUILD_HOSTLDFLAGS` as the fallba=
ck
> > >     to preserve the previous behavior as much as possible, as discuss=
ed
> > >     with Alice/Yifan. Thus moved the variable down too (currently we
> > >     do not modify `KBUILD_HOSTLDFLAGS` elsewhere) and avoided
> > >     mentioning `HOSTLDFLAGS` directly in the documentation.
> > >
> > >   - Fixed documentation header formatting.
> > >
> > >   - Reworded slightly.
> > >
> > >          - Miguel ]
> > > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > > ---
> > > Masahiro: if Kbuild wants to pick this up, that is great. Otherwise, =
I am happy
> > > picking this up early next cycle, if you give an `Acked-by` since thi=
s is
> > > changing the interface for Kbuild users given we are introducing a ne=
w
> > > environment variable. Thanks!
> > >
> > > Note that the `or` means if the string is empty, we will use the defa=
ult rather
> > > than nothing. I didn't change that from Yifan's version, but maybe we=
 want to do
> > > otherwise. Users can still provide e.g. an empty space to avoid any f=
lag.
> >
> > I am not sure if I understand the implications here.
> > https://www.gnu.org/software/make/manual/html_node/Conditional-Function=
s.html
> > says:
> >
> > The or function provides a =E2=80=9Cshort-circuiting=E2=80=9D OR operat=
ion. Each
> > argument is expanded, in order. If an argument expands to a non-empty
> > string the processing stops and the result of the expansion is that
> > string. If, after all arguments are expanded, all of them are false
> > (empty), then the result of the expansion is the empty string.
> >
> > I am assuming that this means:
> > - If PROCMACROLDFLAGS is not empty, KBUILD_PROCMACROLDFLAGS evaluates
> > to PROCMACROLDFLAGS
> > - Otherwise if KBUILD_HOSTLDFLAGS is not empty,
> > KBUILD_PROCMACROLDFLAGS evaluates to KBUILD_HOSTLDFLAGS
> > - Otherwise KBUILD_PROCMACROLDFLAGS is set to empty.
>
> I think your understanding is correct.
>
> $(or A,B) works like $(if A,A,B)
>
> Commit 5c8166419acf shorten the code.
>
>
>
> > What do you mean by "use the default"?
>
>
> "use the default" means,
> "use $(KBUILD_HOSTLDFLAGS)"

Thank you for confirming. I think this is my original intention. If
PROCMACROLDFLAGS (a new API) is not set, the code should have the same
behavior as before this patch, i.e. cmd_rustc_procmacro uses
-Clink-args KBUILD_HOSTLDFLAGS. This minimizes surprises for existing
users.


>
>
> --
> Best Regards
> Masahiro Yamada
