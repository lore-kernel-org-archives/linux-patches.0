Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CA32BFC6A
	for <patches@lists.linux.dev>; Thu, 22 May 2025 20:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747944619; cv=none; b=KHQmDSTdFeO58mIXL6zNJoX/U2LEhutZ1sMBWpnsf3QPf42tsa2tky3MmYCAyp+qxBzc3ryEA0sddYGxw836ongu5lbJnBBjBzKgn8jPaJP/97dvBrUOQ6wbtceKXN19MzutB6dzZsQVBm+BEYuIJ6gYw5JHExS0s+3JVz7wpUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747944619; c=relaxed/simple;
	bh=u1d0amzEQMXWLc+O6o+EmY9H47Q/ZLgRR2P2wcViHWM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y8IXQei1d+oHg8yvjRGUHHMWov3RX4ktNj+KfVhUrxML69f6aELJH/7lXEO/IMrp7S791qKnaJisf8AXfIaWhIf0OkBG2T5przei3M0cwrV8VPHQ6n+imGDkeIUYz+v7dLSIU74y2RPuSZpvSTNnSblFhkr0T31bVPb2pLR7DbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q6odWQ9/; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q6odWQ9/"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a376da332aso3658991f8f.3
        for <patches@lists.linux.dev>; Thu, 22 May 2025 13:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747944616; x=1748549416; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zi6UK63Kniro/hiv/vg69lXNbuiW+Rc4uGAFOEdYP7c=;
        b=Q6odWQ9/lutI2sNxMJqMIJb5B1tT+E7v3B0T/j/o0t4tLrWsdSH/LtsXuRRZzdQj4G
         I+WGEWrJUvrWCUhtggtzGsvc9A39hT1BGliOqdqxvqfX1Yl6LF9zPZ1y3cKbnNnWnyMV
         tOMlY8TLSqVWaqfCh84uTX4OJS4P7b9NU/Qj6FQlxpFznZtxrPNN8p9VhZQcbsQ0pgL8
         YrITz5KwcYrExMTl45egA5v8Rp0SIiMrs9KjMAExL9lh0EhoxkfVClbK/P0c8wWE0MHu
         9EztDlvB+BxmIpsHyqAowo5LpknC96YL9ShQ036lLJkaCTTdbGMoP6IKcNQBwRGypIdF
         oM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747944616; x=1748549416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zi6UK63Kniro/hiv/vg69lXNbuiW+Rc4uGAFOEdYP7c=;
        b=nwzjXkJSoQWRnZXhCHrZsDRJyjZflrKvCh7ou863grlijNqnPVsI4YBr8dVSrz6n0I
         jiOkt2mCEE/a0s7PDMH9yg8/ZsXH1HSg5uS9rGI528Aenl6Ezg9eQ/R4jsds8wLSlYr4
         dpLEFtW7CNPAYAoc8viXgcySyt9nHNgcqLBNK7vmpFI4CgVH1yJRAyMlVUQ3ZvWRzVMf
         V24NplG3Mw5nLNqlpwbg5KdoZouCmXgNgfH/xxnjyTienTqDKFSl+foh3SMaabDS5b+q
         0M96/JBLGYKiJxX39+3hfyywcnos2mx7vqqIQyiN7xS7p7/9nUde98v5w6eDJaRSCpHV
         htjA==
X-Forwarded-Encrypted: i=1; AJvYcCVYC2GRxQ/jarFUaV4xyH/blX4Iz0gYlcYVbewS34dFvbLyM8MqyIdUzVqyC7nM7Ck7RN+6bkgk@lists.linux.dev
X-Gm-Message-State: AOJu0YzI8mTyWCwwEI3a0Oa+BCV+k+/nqsxpuogmu6XHldKEI1PCHHJQ
	/qScZioWFr4vIc4wtX487VfbtZwr8nCj2BotQEenss3Nqj5Z+1Fs6bR15Wfy7Bpi43JWEweUf+1
	UyF3vzujDxfWLfDKFzMVg9xeRVlEPfKWM6jpyfOuS
X-Gm-Gg: ASbGncto2EeZqfmlvTQ4Nc9hKiSj3U5Od3ykZzuifCrYvNM+TRfi8ZwYPr1AqyWeo77
	LUaQ/O/qCk3o4LDvD2t1ZEVmSyhJKAJnVrX3AHCQAySUf4Vgc9ZTJRdIrHD3A0BR/PhuPFKoEx6
	qH5bY3YgxBdfnCeb6wD717rMvKEMQeOxrhUhrgWZaM63YrPNZZZPTrzeQCVvYmRTaS6oujRYMv/
	g==
X-Google-Smtp-Source: AGHT+IHd6YqAoxYw8miBcoEkIf/xB+HqLUuOOhvJRjCeKRZF7C69+8RuD1SZ5w0zECEw6IKhFE00IUJDA7Pw53bTrRo=
X-Received: by 2002:a5d:64c7:0:b0:3a3:6584:3fa1 with SMTP id
 ffacd0b85a97d-3a365844ba6mr22936770f8f.44.1747944615640; Thu, 22 May 2025
 13:10:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250413005650.1745894-1-ojeda@kernel.org> <CAH5fLgiF0kZdOYaQi18_LTNx6Onq-5PBomA=bwS0m0z+C0wtvg@mail.gmail.com>
 <CANiq72ngfTJ5PTYaJOOQ2NedERrLYzA62hL8Fgw5C4QkuZ2R-Q@mail.gmail.com>
 <Z_0X8Z9M2H0mmcK8@google.com> <CANiq72=ttuQYrGNDqNZDmBN5G4TUpna+ex8eD85HvOP723frDw@mail.gmail.com>
In-Reply-To: <CANiq72=ttuQYrGNDqNZDmBN5G4TUpna+ex8eD85HvOP723frDw@mail.gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 22 May 2025 13:10:03 -0700
X-Gm-Features: AX0GCFsS36Reksqvi8aRibe6a18Oz-bTGUW4k34hhUquW5v3Uv-Z43TgekyqjRs
Message-ID: <CAH5fLggfFJ3TmoDbVa1SqOPywOHKDy85CR5pz5wZ8VpZj+Cr6w@mail.gmail.com>
Subject: Re: [PATCH] rust: add C FFI types to the prelude
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2025 at 1:05=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Mon, Apr 14, 2025 at 4:13=E2=80=AFPM Alice Ryhl <aliceryhl@google.com>=
 wrote:
> >
> > Hmm. Maybe, but I think having it at the end is okay. Could we catch
> > core::ffi with checkpath instead of clippy? Just search for core::ffi?
>
> Sure, we can add it as a good first issue (Clippy would still be ideal
> -- it allows to check all the current code).
>
> I came up with this, which puts the right way first:
>
>     Rust kernel code refers to C types, such as ``int``, using type
>     aliases such as ``c_int``, which are readily available from
>     the ``kernel`` prelude. Please do not use the aliases from
>     ``core::ffi`` -- they may not map to the correct types.
>
> If neither of you are against that, I will put that in a few days,
> including Danilo's tag.

LGTM
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
