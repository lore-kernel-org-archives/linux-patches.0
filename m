Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A852AF1E
	for <patches@lists.linux.dev>; Wed, 21 May 2025 13:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747835134; cv=none; b=rgJBF6b/AVFrjjENqciWqZDOd84JYXS4AFh24KAc808jpLYEHev9EB6kKtljmAW0pUdBwepvR957eHjfQ3nE0zRAUoVvLn9sfO3fuselxNv5y3wpQtqjFVjNZccgBjn7en3O2VbyOPQvthQ2TzZ/ZZLYXLt19EJWPAZHJClSHVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747835134; c=relaxed/simple;
	bh=FxQfM36iuvDamyyfqC0jliSjTLRBVIUW69BqTmz6h/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fLJJRw90vxIKtBEKXUKRKFmw/hcdxoC8i+L/CjL+n8W0Wb2vDIICY2czHuGJyC0sJe33lhADggZhyFsCR7k5IybIKiD4U6BZxYiTFBBIYfKKU0hE3HjZGMqPbbAWNExLscSvkqXLQLNM4hb1wmsG6NGTAJ+A9iTzrOSV2iv5pss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CiB5JxAu; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CiB5JxAu"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-231f39b1b7aso3369305ad.2
        for <patches@lists.linux.dev>; Wed, 21 May 2025 06:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747835131; x=1748439931; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqeO+b0MwZruALSzGBi/axWBZuamPPMaMT8p8zPZkxQ=;
        b=CiB5JxAu5m5CmjHfKns42MNl3+C2tfnj+zDfLs9nLuK6OtNrttNiewdbfONL1dBTcs
         x1s9Ri5e1ATtcZ/5fUCwKbmS22UA5XSb5Tv9ss90Pam3fVmM/RZNuuqB4MBJf0uVh07r
         sJGPG5WqMibsBr6slzWfnXqZy1vFvy8SwS1FM6wmCuV4v/ebiZHSqee7qcqz6ZqFojdj
         RkQppox/Lpi2uo+9KYFPeWOpZHzovnq6BtTGh+X0phOMr3cO7CycsOsj+rTcCwG9tl2R
         uvTKODYaUJPAlhJTKOpd+5JdKcQq6NySUSNA3dBLD40qAgahgycHdTHfseHvglLU9Ws1
         W1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747835131; x=1748439931;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tqeO+b0MwZruALSzGBi/axWBZuamPPMaMT8p8zPZkxQ=;
        b=ms2Y7LviU+3g+HzVzkRSLZweij5DiLeIqVcuoQEY5dHU5ZLqrx9VAF8j1jh77JS/DY
         QeedMZq95EaDsOLFYlG5LUypd38dmXw40wC2AGZcSGvgjrFtZnGY3scJ8ve0QqUP6nBE
         ZFz5c2nBcTnaK9CfJZQRmoCEirb+ipqV+NUINvDS8kLGX6AySJMDCI2KMR4fqXw/veql
         7N8q2T8d+xSyE8CMqqV4LlbbB6K/brGS5jq/tYJa6ImreI54mlbimUA2uuwSX6/vcFqx
         j0cyDXQ+ieYrM2YgStMonoP0ts0PiivveMk86M82lmqYFnjXECLgbkPraiqsAG7+dGwc
         oxfA==
X-Forwarded-Encrypted: i=1; AJvYcCUSl2xOzjdv0uu0f4oqLdxYdJkiITR6qKfGwh1tUQy4u+5fsH3bUmiGPxHgng+2++/mL9M73mDr@lists.linux.dev
X-Gm-Message-State: AOJu0YyRP87Hb6pdUZF3NYWLBVhzAp2dboj/QLMgw4RoXFMWe90Ylm2n
	233rfLwI/sWr9YAiBjHZuJimfpFbBmBIRO94aDpu1AzU8jurIkiGktw+sns7sJr/kWo7zd+Xftn
	KcQVq0yqhQZdYV8PW2O+kaiuaDrMLXEg=
X-Gm-Gg: ASbGncv4Pd2pSQ4FRggY0JOQw3XH+2i4FEf71jZW7SVQCmNKhhQXlMDjJ+3Pl6/tqpO
	POl9nrsT//TCqOYqTtyq+dyJ03L8APZwLqDFQ+/XvsJQiRXFSgLLahfmQSnuCEBKa4V9aK1aaVN
	iEc/vqSHpf20vEaQhqLYdDov13AGjMYJb8
X-Google-Smtp-Source: AGHT+IEd6DsdwrSmmjCd7810ousDSSQK3PDaq3AuoW7wry1YdEav/d6efL+6DobgheFh5YsZPOOvlPQ1fuaqgwzW2gE=
X-Received: by 2002:a17:903:24e:b0:22e:62da:2e58 with SMTP id
 d9443c01a7336-231d4526b5fmr115017765ad.10.1747835131225; Wed, 21 May 2025
 06:45:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250325184309.97170-1-ojeda@kernel.org>
In-Reply-To: <20250325184309.97170-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 21 May 2025 15:45:18 +0200
X-Gm-Features: AX0GCFurjaXVVR2SMph-zlE4anDutDZ-hG_2Vo7FkceNywf_0ew3Zm4BUxeccDQ
Message-ID: <CANiq72nDtkpC6zKLT3dNH-u8uUXRqTGpS+GPotOrSV=pNR-39A@mail.gmail.com>
Subject: Re: [PATCH] rust: workaround `bindgen` issue with forward references
 to `enum` types
To: Andreas Hindborg <a.hindborg@kernel.org>, Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2025 at 7:43=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> `bindgen` currently generates the wrong type for an `enum` when there
> is a forward reference to it. For instance:
>
>     enum E;
>     enum E { A };
>
> generates:
>
>     pub const E_A: E =3D 0;
>     pub type E =3D i32;
>
> instead of the expected:
>
>     pub const E_A: E =3D 0;
>     pub type E =3D ffi::c_uint;
>
> The issue was reported to upstream `bindgen` [1].
>
> Now, both GCC and Clang support silently these forward references to
> `enum` types, unless `-Wpedantic` is passed, and it turns out that some
> headers in the kernel depend on them.
>
> Thus, depending on how the headers are included, which in turn may depend
> on the kernel configuration or the architecture, we may get a different
> type on the Rust side for a given C `enum`.
>
> That can be quite confusing, to say the least, especially since
> developers may only notice issues when building for other architectures
> like in [2]. In particular, they may end up forcing a cast and adding
> an `#[allow(clippy::unnecessary_cast)]` like it was done in commit
> 94e05a66ea3e ("rust: hrtimer: allow timer restart from timer handler"),
> which isn't great.
>
> Instead, let's have a section at the top of our `bindings_helper.h` that
> `#include`s the headers with the affected types -- hopefully there are
> not many cases and there is a single ordering that covers all cases.
>
> This allows us to remove the cast and the `#[allow]`, thus keeping the
> correct code in the source files. When the issue gets resolved in upstrea=
m
> `bindgen` (and we update our minimum `bindgen` version), we can easily
> remove this section at the top.
>
> Link: https://github.com/rust-lang/rust-bindgen/issues/3179 [1]
> Link: https://lore.kernel.org/rust-for-linux/87tt7md1s6.fsf@kernel.org/ [=
2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Andreas: are you OK with something along the lines of this change?

If you don't have anything against it, then I think it would be nice
to put it in, mainly so that the issue is documented, and so that we
don't forget about this possible workaround. Plus it removes an
`allow` and a cast, which is also nice.

The only downside, as far as I know, is that the workaround cannot be
always applied (see my sibling reply), but at least for this case, it
can be.

Thanks!

Cheers,
Miguel
