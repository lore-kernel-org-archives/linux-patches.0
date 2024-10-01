Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF13319F411
	for <patches@lists.linux.dev>; Tue,  1 Oct 2024 22:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727820755; cv=none; b=lo1yjtrCr9VsAwpDAtua4UNl8MLMnfOSaPtRZBuQpm8teySr0xMbEL2yK4sqDVmYwr6rL0Ecb3g3ZFOL+GqynZPO0Thvv2rrw4lCYKGosGljCAOBWnvhMqtQXaDMRkTQ3yP1HQGRCdiDzJfBRhxxpzMIb6dMuE81DIXSQu1ejl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727820755; c=relaxed/simple;
	bh=+Y4UDQ0SBLFXK+EKaoLuBpz9TvjY4PQlfPV4NBauuBw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dFYYDu5Fl15QB9eUHV7JhSHq63mnbZnbwjyCl4ZeikjwG/obacEanZbL1X5s88276ieHpdWChcmWm8jM/tBBqWiauDxW35T4/liFXFNFww9P7yCMo8SHOigIOJPklv9LHQAGKvEqdhFODWcC/BJ3gZI2ESP1pKNBmBq6g1R2ULg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bfjvg3DW; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bfjvg3DW"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-71790698b22so856639b3a.1
        for <patches@lists.linux.dev>; Tue, 01 Oct 2024 15:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727820753; x=1728425553; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Frfh6hBj6DUTGEMrubT/n9jUTuny2AERvO+Dq7ZfqEA=;
        b=bfjvg3DWjYuhghB3n6eXirwhsR6g6fhxiNp9iBVcZ17/H7rybJiFw57FFotxTSYEkn
         qSZfYcZp+kpJcRUYFl4RHTSMcLlK7kJeUNiIUnl9LKosVx4Eho+ujSbMT+Z6bdU/wnGZ
         V0XuMeIAlwA+yYyW3E0DBYl2f6LZ3J6Fv9EYaoAfeUB6FboLJG6DoC1THgFTyDkAvhfd
         wsWM8XZhUf/cGsMXxyU/7GT9iAE8HySAcw5eMF+yIM/p+zWy46knEetFNf43A2jmlzxm
         WG748/0hQYece8UQKBu+L+T1nJAb8s9OWVGd7UtCNQfjkS5Aes5calZRZoJgDSd17VEb
         +HvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727820753; x=1728425553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Frfh6hBj6DUTGEMrubT/n9jUTuny2AERvO+Dq7ZfqEA=;
        b=d0AJjuearwRNTLp9PfWe7OyAH5K6f+8b+S+VR8Qy8YOPEmdHeMI3zpU6XybBiLbvqE
         cR7lQo7UPduQ9DO8ISoAJZSqG93qNVWm7koCms+HtrQA3QhnuDFH5UHSU+hvXK6u+ASL
         DnS6+vFEfYzLtCHyyY/VPVRKSNUa2yzj2MVvD9xmflzCiLUCd66tLbVTJLrBrUYtiuJh
         bq6sHKtCTL8kH/fDCfgOqZlIOO6XfTOjbfWmz2TBLSC0OHpNkPtCnPY3zsav44ccgwo+
         p+V6L7tEXk0sFaqCVUGLrP+A16CGquijtog5e4HIAgHpbk70HCVTWefiUpisb8Ze9I0o
         0Tow==
X-Forwarded-Encrypted: i=1; AJvYcCVvNEKlEWKS8WbsUl4TD/7sL8+z6cjzXr8Ea3KHjA1Uy5VoKvPbZ12XMP/DqXxnVTN2AvYt/tow@lists.linux.dev
X-Gm-Message-State: AOJu0Yxs5qqC2epVWzLfp+aJzxyUW1kKlSijwfnTG+pEi+FSm0HSzUT0
	l60AXjsTMVsswszmOjmmkyGwcfiGLwwAg4AAyHzfUR1bqt7potbxZuzl0BgW1YrRlcu1MwC/RT5
	zdoqEG0p8IbZxYBp8OiECIsXilSY=
X-Google-Smtp-Source: AGHT+IHSa0R4OQIO3Y/6fLRRBq/Xo5ODccew70DFb/Dr7Z1Sg3pF8k4ffLa067F2mmhJkkeuuAW91uzXNwCGzvJB800=
X-Received: by 2002:a05:6a00:23c9:b0:718:e49f:246e with SMTP id
 d2e1a72fcca58-71dc5d5cce5mr771264b3a.6.1727820752956; Tue, 01 Oct 2024
 15:12:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240927164414.560906-1-ojeda@kernel.org>
In-Reply-To: <20240927164414.560906-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 2 Oct 2024 00:12:20 +0200
Message-ID: <CANiq72k7ttdioXrto8VRJL+q2F9EjuPxhOR9HgpwdM+ZySM_+g@mail.gmail.com>
Subject: Re: [PATCH] rust: kunit: use C-string literals to clean warning
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2024 at 6:44=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Starting with upstream Rust commit a5e3a3f9b6bd ("move
> `manual_c_str_literals` to complexity"), to be released in Rust 1.83.0
> [1], Clippy now warns on `manual_c_str_literals` by default, e.g.:
>
>     error: manually constructing a nul-terminated string
>       --> rust/kernel/kunit.rs:21:13
>        |
>     21 |             b"\x013%pA\0".as_ptr() as _,
>        |             ^^^^^^^^^^^^^ help: use a `c""` literal: `c"\x013%pA=
"`
>        |
>        =3D help: for further information visit https://rust-lang.github.i=
o/rust-clippy/master/index.html#manual_c_str_literals
>        =3D note: `-D clippy::manual-c-str-literals` implied by `-D warnin=
gs`
>        =3D help: to override `-D warnings` add `#[allow(clippy::manual_c_=
str_literals)]`
>
> Apply the suggestion to clean up the warnings.
>
> Link: https://github.com/rust-lang/rust-clippy/pull/13263 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks everyone!

Cheers,
Miguel
