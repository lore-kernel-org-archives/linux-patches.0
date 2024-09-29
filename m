Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEAD17C9E
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 04:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727585788; cv=none; b=XmxhVq5ZTsjAgqb4GHW42JPEsvMojn6ls10ZlqALYg/lzz7Vi5tGyr0rjc9CjXQhVEfL0hVuALws/8MGr43gcxA1/1RdSRVm66PPxqAWd+sg4sI4IQkxeWRIDFYCUm6yHZkfwbqmod87VrkVQsQUQbxXrLHMhMYXYH61tJimlA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727585788; c=relaxed/simple;
	bh=YkNxXWjpqjYtCMtoRe3WVpFUJbFDdsQaD/T/kG7nl/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qXQfaRzPx9O4ODcr9Y8G0ezP3Gj3ykjlchWqNwV0GyrPk7eTMg4Fh4l8rQVSFUFj5Ni6xUHkrfkmmy2JTtGaiQpjIiECRvGYw850FH/MB1deWRKmi09uS8Kh6r16+iOq7G6S26z/e9ryVxUB8q2jGhQo+HeqU3XPbQPMXPzXJx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=gvgFGfx/; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="gvgFGfx/"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-6e2326896cbso22109787b3.3
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 21:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727585786; x=1728190586; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YOYsLISsVfhDxhjLXV7hyv9Fxzlka9wAvMifvGXxyVI=;
        b=gvgFGfx/BgakUgOpVDY5E0+9Nqrho7B1F31Mn6POgCjHLMnaShhcryueUGRMWJORbq
         fQZ78ahXaHtSxh/7dmy7E443SW+PJJgCkWG4Z2UT4q5bUuvcxBa27FJ1+390hHv8vtmZ
         cSNrXZWXuamQq2eWNDhwinYWIPSLOSCCtN/Q9NmrNi6YLGK1ZNMMwUJa49B0EoRxtooK
         0V2iXSZ4Qb4Gcs5DygrWPMYI/jNRHOOdabwAtQldQuJNVk0W6CwJZ72iqMT2SSQ824gR
         8HSmG1N/c3qArew2SV2+tAvM1HFrOWlmCrBD+6z/gCrm8+lJoi9r4l+rXZlDbNHqCHIh
         ZLFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727585786; x=1728190586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YOYsLISsVfhDxhjLXV7hyv9Fxzlka9wAvMifvGXxyVI=;
        b=Z0nsUCKj2IUepf1NixyvSkviCouxRPjpKPoycfJY4hBDMLvxFZXGeekuSuMGD07aeg
         VhUE929s4MJ69Ax21rFtoTb9XedVKSVi9j2a5tAqJy+XR1nPXGbI+bqG54NtRgG0142n
         MHNZRAjUuHlJmx6IyfHS6sbIs8geie2PA2T95Z4AMcLLGUsKRNEf7KSZ4MNPjXOmbDDm
         c7H9yZzQed0aLc0sNZnUMEvjKTC9WdN+OLsZsp738X3KyDej/CI6+jQkLUVRTkebI36f
         gENSo8y7HfGLSB2jRAhv8b5SKgFayYXvToFRjvwXvE89UunppdCkUEu4lHVuRmLLJdES
         hxTA==
X-Forwarded-Encrypted: i=1; AJvYcCWD9TSbyQg8KqjQhG98FfLNc7I8vEqbXy8kVJDYpndcJzpIiSGySVCfJqdH0oVrNqBQOZELDCR9@lists.linux.dev
X-Gm-Message-State: AOJu0YyrOway4pdIGNiQEsIllSe8hq7rvvSIlrcwMyZU/deCQ2ld8qR3
	ubtGGdfCv0KS0W21xu/2itdI8/lPuuVB9m6XShvBZnNz5G8KCKkIuN9217w/EeDZ8Y9Gor2/P5W
	4odPmSIPLKEm9AVg+mjDJ7/eHHvASmcCGhg/3Cg==
X-Google-Smtp-Source: AGHT+IES+mS3dwA7x3mj4/IZRVIw+FMcwmqXUyBn9jFMyuY82OeecDI+pqzm14EDy7gj7TkzRp0qLVGuvnyig5ATprI=
X-Received: by 2002:a05:690c:2b92:b0:6e2:1bba:ed4c with SMTP id
 00721157ae682-6e2475470bdmr36609157b3.17.1727585785734; Sat, 28 Sep 2024
 21:56:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-15-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-15-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 00:56:15 -0400
Message-ID: <CALNs47u+vEO5+v7dS3Zm2QbeOQfp9OdNv_y7G5c_AxqxjppFHg@mail.gmail.com>
Subject: Re: [PATCH 14/19] rust: provide proper code documentation titles
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
> Rust 1.82.0's Clippy is introducing [1][2] a new warn-by-default lint,
> `too_long_first_doc_paragraph` [3], which is intended to catch titles
> of code documentation items that are too long (likely because no title
> was provided and the item documentation starts with a paragraph).
>
> This lint does not currently trigger anywhere, but it does detect a coupl=
e
> cases we had in private cases if checking for private items gets enabled
> (which we will do in the next commit):

I think some words got flipped around, should this say something like
"...a couple private cases we had in case checking..."?

>     error: first doc comment paragraph is too long
>       --> rust/kernel/init/__internal.rs:18:1
>        |
>     18 | / /// This is the module-internal type implementing `PinInit` an=
d `Init`. It is unsafe to create this
>     19 | | /// type, since the closure needs to fulfill the same safety r=
equirement as the
>     20 | | /// `__pinned_init`/`__init` functions.
>        | |_
>        |
>        =3D help: for further information visit https://rust-lang.github.i=
o/rust-clippy/master/index.html#too_long_first_doc_paragraph
>        =3D note: `-D clippy::too-long-first-doc-paragraph` implied by `-D=
 warnings`
>        =3D help: to override `-D warnings` add `#[allow(clippy::too_long_=
first_doc_paragraph)]`
>
>     error: first doc comment paragraph is too long
>      --> rust/kernel/sync/arc/std_vendor.rs:3:1
>       |
>     3 | / //! The contents of this file come from the Rust standard libra=
ry, hosted in
>     4 | | //! the <https://github.com/rust-lang/rust> repository, license=
d under
>     5 | | //! "Apache-2.0 OR MIT" and adapted for kernel use. For copyrig=
ht details,
>     6 | | //! see <https://github.com/rust-lang/rust/blob/master/COPYRIGH=
T>.
>       | |_
>       |
>       =3D help: for further information visit https://rust-lang.github.io=
/rust-clippy/master/index.html#too_long_first_doc_paragraph
>
> Thus clean the two instances we hit and enable the lint.
>
> In addition, since we have a second `std_vendor.rs` file with a similar
> header, do the same there too (even if that one does not trigger the lint=
,
> because it is `doc(hidden)`).
>
> Link: https://github.com/rust-lang/rust/pull/129531 [1]
> Link: https://github.com/rust-lang/rust-clippy/pull/12993 [2]
> Link: https://rust-lang.github.io/rust-clippy/master/index.html#/too_long=
_first_doc_paragraph [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Trevor Gross <tmgross@umich.edu>
