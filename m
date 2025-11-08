Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACE3298CA7
	for <patches@lists.linux.dev>; Sat,  8 Nov 2025 02:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762570214; cv=none; b=nposy6jPrQJyJqstxlZJgDOx7NMRUiF1ThWvVin0I3WlWL2MapXu1wEHqkaPnBqqS2OL+xKKbjDvPPnC+qVe3Ug3zKRbeB2cI8Qxh0jjGu7IBaxe8AVU38E5bZGfSumhih3yv3cPeVOf+Y8JskhEUC0N816yCD/+oa9z0j8U8hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762570214; c=relaxed/simple;
	bh=OAMQkM8H202HpZ9SyALa6Zflvi3TrT+59q9nVOpCnkg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LSDmI+WRRoAVWjEmAFc41wmHR9TsM+7Gd8wqMOtBwqO0yF4QZOyC7fYDQfZzWuEwnvk+KtJcNLwsmeoTeNXhpBPREOdHj5jqlc+NM6VtMosASVLTzc2Cv8I/jsOfaLJOgq68E391WWVjEaSCCNPBYVcQLSCt/ygQlxd3HDLrJkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dKcjxee7; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dKcjxee7"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-295c64cb951so90355ad.0
        for <patches@lists.linux.dev>; Fri, 07 Nov 2025 18:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762570213; x=1763175013; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xz9KbiB3pKiQMMUPj1p32orHVehzjrikuGFe9xgdEQk=;
        b=dKcjxee7/Pd34Jhdoz7FQJ53B5F6NT60YMoQjBmULu833QC1TkCEoFpJfHwq73M1UD
         x27nGMi7vVkFxQxonrAprfV5c8gES4bbzfJLhvIPW9LbdHBfjt3xA+Cimzt+iTQRsNeQ
         KWDAHkwV48BGu1J4iOkO3OnRxgHYOdrLS8gKgUklhS0CG1+KBPUU3dt4mcBRuF+b0eDP
         5hM34WudV6HUFCLsQjPjYK15oW9OoLKKNVMcWb4uwYd+EiyMq7I56EqMNdtQQe+Mm1Pi
         1P69YgUnuzNMmXp28DBLpyaZj5p6TIwMHWTbT/kLX+SJ4Lc26Avrc2V7NX6JfhgCzS6G
         k1UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762570213; x=1763175013;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xz9KbiB3pKiQMMUPj1p32orHVehzjrikuGFe9xgdEQk=;
        b=Sk9SM7ZmiiQLKPkbQeunp9Gyuu3kAc8WDK++W7iBa/Y2TCRVndiKZr7PKwix0lKoV+
         UGn3X4AJVKQ6acAh7uhGxuBHmhXpR9r8KYTbEmmeaPBFe+4CdBplnwlHh0lFIM1I9h1h
         ewtcselZbUL4CQSSrzMZuSx8lChORvkNiDQN/PIxT3yE4xGqDa3FFaOkPkbZtfodKTxl
         emEVnnEGb8tN/NI6TkfvmvY7qv4He3SfEjdN4B27taj2V0w1+NRIzxymlfZ1HBciexvO
         1NIuocyzgqzQ6Y6THr/x80q+ru8qtEKhkH3HeoL6tiWyiR+kg9599e0avapJhT+TSsit
         Lz0w==
X-Forwarded-Encrypted: i=1; AJvYcCXEWg9pVpNYW/lUEizB3r4FEIm9mbd15dR29qHI/ytb8TFW7wWG/BLGylBIK9V1e8xTLjNKBOsg@lists.linux.dev
X-Gm-Message-State: AOJu0Yz26FWKEWofGAUQKFAxiSqF+i6aFWujq/OQRYJBfz6N/iDbnCuZ
	YzDm1kDROhysRaaObkQ4iqmb6TkKZrP4z469IA8B8I9cUKlt9/vFkSIVcNF7JEl/sISemY24PQB
	xrYWX2zdMj8Ou04AZAL2PsWXvR3PUXQgwJKp5dJ+J
X-Gm-Gg: ASbGncsnyH+RY5Yw5uNmPkIifr4kH+60GfZxyMznKaMaS8nWxf0X1vInzPvW4n7zwZ0
	HwPipuDylbWI5Z+IdAQluCrC/+CkIfF9oc0hMA43NCwpUU27viMk7p0APaytVhGJg8m80kfofXx
	jBI+ripB8t2J9bDFD3WAWhgVEbZoNVE7qvfJ+jaIvKl0bM3SUBc6OibL/2Sbnue7qTjBdfdHQfA
	tat/RXo2IvD02KqoSDPJD6e9WPi8+KpCV5kaw83TRmpxJ9bFmE/3/3K+Nh33JbjzsNc
X-Google-Smtp-Source: AGHT+IEDYpJKL+hIOzjq2gpmJ4iFLKF/Y9OWuaaO1G7yVaYPMHtubhDweRGu3Pd8BduK0hfGnF3VI4ZMdg1XmQs5Cik=
X-Received: by 2002:a17:902:d4cd:b0:291:6858:ee60 with SMTP id
 d9443c01a7336-297e51be5b3mr2383685ad.4.1762570212326; Fri, 07 Nov 2025
 18:50:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251108014246.689509-1-ojeda@kernel.org> <CANiq72nKC5r24VHAp9oUPR1HVPqT+=0ab9N0w6GqTF-kJOeiSw@mail.gmail.com>
In-Reply-To: <CANiq72nKC5r24VHAp9oUPR1HVPqT+=0ab9N0w6GqTF-kJOeiSw@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 7 Nov 2025 18:49:35 -0800
X-Gm-Features: AWmQ_bn2xE_C004xbiOPfj6vuNrWvyE4Ho8Vxi_L-U3qXSI0Ruu8KQu5_TFbvtY
Message-ID: <CABCJKucCJLWfHz6o=wWWx95keLC6na+uO3a0WVLTPEz02gENPw@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: skip gendwarfksyms in `bindings.o` for Rust
 >= 1.91.0
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, linux-modules@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Haiyue Wang <haiyuewa@163.com>, Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 7, 2025 at 6:31=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Sat, Nov 8, 2025 at 2:44=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
> >
> > note that `CLIPPY=3D1` does not reproduce it
>
> And obviously this means we have to special case this one too...
>
>     $(obj)/bindings.o: private skip_gendwarfksyms :=3D $(if $(call
> rustc-min-version,109100),$(if $(KBUILD_CLIPPY),,1))
>
> There may be other cases that disable the optimization or similar,
> plus we may have other small crates in the future that could also
> suffer from this, so it may be best to simply force to generate the
> DWARF with a dummy symbol from that crate for the time being as the
> fix:
>
>     #[expect(unused)]
>     static DUMMY_SYMBOL_FOR_DWARF_DEBUGINFO_GENERATION_FOR_GENDWARFKSYMS:
> () =3D ();

This looks reasonable to me, and indeed seems to fix the problem.

> And then later do something in the `cmd` command itself or teaching
> `genkallksyms` to auto-skip in cases like this.
>
> What do you think?

Like I mentioned in the other thread, we ideally wouldn't silently
skip symbol versioning because the exported symbols won't be usable in
this case.

Sami
