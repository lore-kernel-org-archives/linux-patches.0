Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67501F1932
	for <patches@lists.linux.dev>; Sun, 19 Oct 2025 19:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760902973; cv=none; b=B8v6Mj2BkF67BOz0h7DIv6wp75BsZpKbGpV3H8E8Gk0SHyl5J5ZqoRXaIeNGLUHifvmwemnoP2D5GFwOvOVpOcOnyChMppJ4eTSbRqb2bs7MXCzrbjPwly3qSW6vmw9eUhPcSp1Ezl/Q3lP0eXzLRhvqRDSoBhEHjl8bJQC59go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760902973; c=relaxed/simple;
	bh=JNX8fAvoW1lb8BmNOFmuJuXah+Wz1jHvbOkzj/xKGqE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YvMs5dRjQ0USv1PgV+14uG4j/W+q1YcSQZj6NxRX0XNK5DzlMBfvNWbvV+Fgjzpg99v/S9pG11ic7w/9QkNz+Mhu0Rw1hTvGIjOTpiItPld+VreV4WoubZ7X2pvl6hZ7v0avHjAbT875ytCK40hpl7llg+UxKXhmHHc8XtR6ZsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R9VFp4wb; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R9VFp4wb"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-269640c2d4bso6457755ad.2
        for <patches@lists.linux.dev>; Sun, 19 Oct 2025 12:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760902971; x=1761507771; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KqNBOqOH483MS8SL737JXQnsKORCT0z1++jLxbruyag=;
        b=R9VFp4wbl++lFFtpXHXm+xpELITV02HV589M8shZFPeKQIANmrZqOrdAforjeOLXSJ
         5T/dBSwWIs7QDrgWTtWBqGhxts1Kj+M8ljeU0wzrFPWEHQtMmgMigY1cugAwHijcYF33
         iCoYqxnAOp1VsIxR+1xSM7ZoA2xK6l+Q9piVth2qeh8sob9D5BUHz5wn3dUFlWeA0psV
         YytLaeCJf9cHeleT3jyq0nJ0znyhZirb37S6dVnIsZXKXRFYInfTaeyvE139c/9EJKWO
         uOvYXKaBe2ehdWleCxooZ9Ryt0nbDBxp9kKPBnTvILXAPfCdVtjVPJ4I2x1d4NDN/cq2
         jFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760902971; x=1761507771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KqNBOqOH483MS8SL737JXQnsKORCT0z1++jLxbruyag=;
        b=iC3WZ5jxRRvTjKuN7w2U4V9I0t3o/IyfFfKywsoyi7PpU07YsWMlkUcnTp1pyCl5XJ
         ho0cIwOFcRD9oW93EYc73aF6nJf/qQOw3pV9IGmp1RBiC3kwA05f6JOAMwJz9p05rDE2
         zAMD5OLgsmP70iWKOVsosc5ZLjasSnANgo6XbwIEkmmdFJTvkBBl8WkskQFtQESVWKkF
         eTOtjTGlHruzHpbv4paadH8JGgjEgSVRGD611ok1sPNV/nGlUOmFhAHW7JannQky5D+l
         pEgErteEke5ueQtYEL7+9UmFpWDbA6gFr0G9XyNVUFe638nF/3H+9Ef0a51xdW1UjzOb
         RMcg==
X-Forwarded-Encrypted: i=1; AJvYcCUuoKny595BEmWuMhyurAPzrB5RGCKYwSuDFaG/bCrv4+exUNOCY0wk5m1fleMRigdFIilfH6xr@lists.linux.dev
X-Gm-Message-State: AOJu0Yxy4GHIrIFjMkBVBEa9ojyK+4ufuJFD+D3wRoIi+ovZ3GU7/9c0
	nnWWHz19MrS7+wpyppNE1RdnkbL3VVIGxVUhtUFOBLalGOOfvLzcaFKDexAGaxl3wNq7FFq3Y8q
	xwRBZtMAO10NpTdAVM9iL2yYZzDUraXk=
X-Gm-Gg: ASbGncv64W5dl8flRHE4ZTeUit00ny5imaVzZBLnBoA+B5UR/+fLhKuG3MNpdQufYCo
	T3i8ga6I+cpdQrOz0lATG5ZZjPsbbCz+u+PBVqyR1s4WAfobM3XlIjJcKdOn7LgB4wkCWPJMm+f
	yTdqalQYzo86thBToj+sULyKv4YNdK0kI/4u1gF+fhFfm7jizHv1oCPzFWp8fRfeftnV55ohfEv
	qylikBMSv5ZBVLNR+iqHAS7v01mrOexMNi6up/tftUHRcpOtQv62nFpHKTU2DueMJpp+wAY/fTu
	fCKqkQyHwS3yKHkM5Rj97jrNcQGtM/gkmVlTWvrQBVsNYwouZztQOhUoUAG1RN3/+cKq1P48NrE
	2PJCrymtwgZ44mA==
X-Google-Smtp-Source: AGHT+IEE791LDmD0uUicQaiHB1HajSqjSkV/deOR3kpO21CqJ5IhdKFr58FA/7AR/uuGkG6Uz6DIWA3taxKjoxNzmS0=
X-Received: by 2002:a17:903:3d0f:b0:274:944f:9d84 with SMTP id
 d9443c01a7336-290ccaccc47mr69902025ad.11.1760902970962; Sun, 19 Oct 2025
 12:42:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251012213230.1139674-1-ojeda@kernel.org>
In-Reply-To: <20251012213230.1139674-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 19 Oct 2025 21:42:38 +0200
X-Gm-Features: AS18NWB2z7Xk1h_mxd3wp5IozHJr98VqS3xSe5xmRLBQ1GuRbRwLAOkc00U5WGs
Message-ID: <CANiq72=a2WMxQ0kKXp0_J8tnrJWb7pibWxZ2novB4SMV7gxcRQ@mail.gmail.com>
Subject: Re: [PATCH] rust_binder: clean Clippy `mem-replace-with-default` warning
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Christian Brauner <christian@brauner.io>, 
	Carlos Llamas <cmllamas@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 12, 2025 at 11:32=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Starting with Rust 1.87.0, Clippy reports:
>
>       CLIPPY     drivers/android/binder/rust_binder_main.o
>     error: replacing a value of type `T` with `T::default()` is better ex=
pressed using `core::mem::take`
>        --> drivers/android/binder/node.rs:690:32
>         |
>     690 |             _unused_capacity =3D mem::replace(&mut inner.freeze=
_list, KVVec::new());
>         |                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^^^^^^^^^^ help: consider using: `core::mem::take(&mut inner.freeze=
_list)`
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#mem_replace_with_default
>         =3D note: `-D clippy::mem-replace-with-default` implied by `-D wa=
rnings`
>         =3D help: to override `-D warnings` add `#[allow(clippy::mem_repl=
ace_with_default)]`
>
> Thus clean it up as suggested.
>
> Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

For completeness: this is a duplicate (from myself!) of

    https://lore.kernel.org/all/20250924130510.752115-1-ojeda@kernel.org/

which Greg already applied as commit 7e69a24b6b35 ("rust_binder: clean
`clippy::mem_replace_with_default` warning"), in -next for a few days.

It would be nice to get it to Linus soon, so that Clippy builds are clean.

Thanks!

Cheers,
Miguel
