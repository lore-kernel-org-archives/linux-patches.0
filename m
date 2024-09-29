Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F501CD0C
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 04:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727584420; cv=none; b=NxU5rHYS5GLjhccDkon78KJc8Ilm+x0f3ZCzOLcx7dCdq8CF7JPzCFiDl/8yiRvdsR/AkZfUSKHZtS8bOZiJVFZrKsGXlNmXrZCvRAZj+zHFz7B76GPpE/svacoOIV4eSyYLbSh/V4lvo9fbwGLvu7m8i12Ej/Axv9f+n7FS9dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727584420; c=relaxed/simple;
	bh=ACdDOapy307eX83VoYT35p6yFmufcMowrIriJWNRkuU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PV5nDgsSX2q6U2dcIF1Zf9yqrWI1UDSv6EigUxLy3p21ggBunxBakErq6hmyAdKqocnovyaUu1YwM6+Va8G59tpZlvaJLSTSj9/Sl+H6OV2cV54BD0kNNNCRBgxmBkuVzFoCrOdMtNYB6gyrHFlSTTSZOHPUWvL/X9wDJTUsrns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=QJbo3d8I; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="QJbo3d8I"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6e255b5e0deso9901927b3.0
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 21:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727584416; x=1728189216; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=crMih/hO2yN7TpUZlSd9hsKUsXMFO0eCIYsluTrMHvg=;
        b=QJbo3d8IT8zY6yblP2lDVbK/CSoVS9l7bxoWoJwY54245YE4dSAgZXmhI9jZTfO9h5
         8aY6hdNujlS9oIm4Lv86KBeU/xz/qyyVx47rH0HiONjuiPemXbNgDECNCjqwHf5YSXoP
         fBLkLYgjQ03TtptfCk0fMTSVG+HNK6x6d1It+dn63jw2xItva5hJ4TAP7ourh4tN0HH4
         W6diTKXi4O0zh3I6dSVXML4+fUxk6ovGCknzpAxeb92PBSDRXm6Bx6mhRkj0ZWShr94f
         tdRN13/n5K/Ij4BuP73eDI6hoDB8qBPRcOICuB47G9eDS4Tg77RN43nvw3EwuX1E92sQ
         jHKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727584416; x=1728189216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=crMih/hO2yN7TpUZlSd9hsKUsXMFO0eCIYsluTrMHvg=;
        b=mQPv0Io8tse0uMI07w7gJdeSp6xfE79JUgS6pROlgyCusFAf4f2COA1V57HKnnAlCz
         XHkpJjv/AJCakrovYeMm1+iguAvvXvAXBesxbRKGcrNZBUXKpxPGq+kPNRxicdFabLfQ
         KyMeC2KshzE2PUqtJtbyle+LuzhG/SU79rEoe0nAIxrkYMuz2gz0Win1FpQpHHZnpnxU
         ltlIBJCzROo4AfED4Ux5rFmJvJljtIyShvz2r/G/M+qVWq6xa3iRECJbxCMDSgZNYKzd
         g+ojieNB9LqmUwsy+4aPCq6L1FHPzbwGYQBz+WexAtSc4hyx9WeRD+m1Zk3mKpsAujNe
         s/SQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzPlF9jIPk/rNHzbwzAOdLoTO+N002516tfxCI3PSmcGLExioolKlKKjwol1KJpHkmKNIpRJ8v@lists.linux.dev
X-Gm-Message-State: AOJu0YzWJz2RmrUfNPDUMjk/5MySizUFmISO8YG6W3GGhTdAVgmQDxEF
	/fLpoCd1l2xj3P34uTpY4bo1xLzQ8cOD4onMkL56/m601zuVNI9l4rMhgFC6kxJLJo7VThO+kLw
	pTCavpbdNNavY3fJx/A50s3wLGY5GbLUAR1WJnA==
X-Google-Smtp-Source: AGHT+IFTzOwIWznLgsvN4UDZ43A97KAtmUIMJ7FDriGjQqSZbDChpH70YRjNmpxoRB1v+fFdhx7P3G/OtX/gEQL2QBw=
X-Received: by 2002:a05:690c:c07:b0:6d6:afe9:d818 with SMTP id
 00721157ae682-6e22eda1e00mr78513967b3.6.1727584416245; Sat, 28 Sep 2024
 21:33:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-5-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-5-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 00:33:25 -0400
Message-ID: <CALNs47udN4_Gr2KHDapwWAmY=ixoJN+-9apAShVT7qFcKdK23Q@mail.gmail.com>
Subject: Re: [PATCH 04/19] rust: enable `clippy::undocumented_unsafe_blocks` lint
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Checking that we are not missing any `// SAFETY` comments in our `unsafe`
> blocks is something we have wanted to do for a long time, as well as
> cleaning up the remaining cases that were not documented [1].
>
> Back when Rust for Linux started, this was something that could have
> been done via a script, like Rust's `tidy`. Soon after, in Rust 1.58.0,
> Clippy implemented the `undocumented_unsafe_blocks` lint [2].
>
> Even though the lint has a few false positives, e.g. in some cases where
> attributes appear between the comment and the `unsafe` block [3], there
> are workarounds and the lint seems quite usable already.
>
> Thus enable the lint now.
>
> We still have a few cases to clean up, so just allow those for the moment
> by writing a `TODO` comment -- some of those may be good candidates for
> new contributors.
>
> Link: https://github.com/Rust-for-Linux/linux/issues/351 [1]
> Link: https://rust-lang.github.io/rust-clippy/master/#/undocumented_unsaf=
e_blocks [2]
> Link: https://github.com/rust-lang/rust-clippy/issues/13189 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

> @@ -277,6 +279,8 @@ pub(crate) fn from_err_ptr<T>(ptr: *mut T) -> Result<=
*mut T> {
>      if unsafe { bindings::IS_ERR(const_ptr) } {
>          // SAFETY: The FFI function does not deref the pointer.
>          let err =3D unsafe { bindings::PTR_ERR(const_ptr) };
> +
> +        #[allow(clippy::unnecessary_cast)]
>          // CAST: If `IS_ERR()` returns `true`,
>          // then `PTR_ERR()` is guaranteed to return a
>          // negative value greater-or-equal to `-bindings::MAX_ERRNO`,
> @@ -286,7 +290,6 @@ pub(crate) fn from_err_ptr<T>(ptr: *mut T) -> Result<=
*mut T> {
>          //
>          // SAFETY: `IS_ERR()` ensures `err` is a
>          // negative value greater-or-equal to `-bindings::MAX_ERRNO`.
> -        #[allow(clippy::unnecessary_cast)]
>          return Err(unsafe { Error::from_errno_unchecked(err as core::ffi=
::c_int) });
>      }

There are a couple places where the attributes move like this - did
this come from an older clippy version? clippy used to warn about this
but accepts it by default since [1]. (Still works of course, I just
think it looks nicer to have the attributes next to their statements).

Either way:

Reviewed-by: Trevor Gross <tmgross@umich.edu>

[1]: https://github.com/rust-lang/rust-clippy/pull/11170
