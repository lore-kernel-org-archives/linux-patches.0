Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8311E1324
	for <patches@lists.linux.dev>; Wed,  4 Sep 2024 18:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725473018; cv=none; b=YFsGp3Yw1zAeTYdOYlhAFR7UbYNTIaIynwXiQpLT+SvCh3sK2fDz4UMwCq5cO6BU54hm0LFqKZt42Z+5qGCrb0j9125xhzlKy/9gWz8mVvoEKy21J2P4S2yhmIsoGrsBvi5tsGmp5N6mXRgyBwiE6tIneTtETg5rLnRIK5UtCT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725473018; c=relaxed/simple;
	bh=sGxD221mI90raKKqY69Jrvx+alI7qWayFZJCwsVmXTs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=szgfp2KZNu0rDptklmTkO/joCTm/FbL0YdN+oTEEeUfTndFBPRavUD9+uapLwP/h4E8/JvZBfhUZkQuA0+jSVfV7BRkmSiTm9kwN5bgCkz7kqjESZ66ING+SlTft8J2Z+YMSkC64im+SAK/U8ajzsNCQe47qDIP3rwcFgIub4k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3lognHrD; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3lognHrD"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6c34dd6c1b4so5508586d6.1
        for <patches@lists.linux.dev>; Wed, 04 Sep 2024 11:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725473015; x=1726077815; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sGxD221mI90raKKqY69Jrvx+alI7qWayFZJCwsVmXTs=;
        b=3lognHrD8Rlzu9QU4vMBF8pFi8jfeboeVCypWA0xIGjZEr+TjuVeu0ia3Fr/oFvFVZ
         6XB7vxbUw8j59jnJ7FnwY1lpmrCKSZa0hKkpa9PhFMowRo4aLdC546B/76eZkmwDSHCr
         2JnE6Ik5gMrxTGuRXYxPxVljegj8x1qBBVCyR+o1JxAnfSXNSRjqZwBB5S/+CupDYeSf
         nl9Zci2lf9zHaaxP0vl/B12oLzlsqo0AVnmKdHIHdL2uglSc0Tfx/hcitKy2jfwQjjK4
         RxyPwAwHoxOaSf6A2jLsGMZlTyTWpfTpvwp/aaQ6R6OQYbwEHBl6uAMT32X9BzHw3Kl2
         8YQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725473015; x=1726077815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sGxD221mI90raKKqY69Jrvx+alI7qWayFZJCwsVmXTs=;
        b=N2iOSv8whP3nmg0ys8RxoAOtZDHF7U454CMRoe9k18pfpdKlg6MS8NnKDaw12YloF4
         iBsjqFYaOGqKKGkEv0S0HOn2GEvdxFhoq61Geb/J87xEX/0yr8P/ZMiWGKpxO18XaIa5
         RpISeJAXtDTapXeDRuLJzrE6wVcOIIc65Jjf2dorDrZnwg/snPOOAhlWs9zOjYi7TWig
         3xH4OM6bbyiHe/X/yWryVJjfhdxf/S1xdumCohCbyHphEu8wPRyjdystspw7f0qP/3ts
         VgJgQdAxgn/4L/R0BXpcqfInQpgZpsWREfnVLyYp3vapJAonSXMO/saNtD+nQUfJagcz
         QwjA==
X-Forwarded-Encrypted: i=1; AJvYcCWuN9SY393SYCeiMVSE0S6SpCfPyocEVeeVbAkws0hP1XunxP8oO83qZDsUHPchchf7AZxXD8fq@lists.linux.dev
X-Gm-Message-State: AOJu0YwlZV1dMkznwc82t0WRiB7jOHwjc8/K2glHFKYJBKf7Ky0kDPIp
	D+au7Pa0Wp70ZfLfLmm/nASZTs8kNTf02VqbffE4sligbg0Y3UpAu/h9PCF5ruvXy9ey7A2qbb5
	EusIsx45N5SeGw4YCvOQPET5MDlJUNo425OkI
X-Google-Smtp-Source: AGHT+IHBmJTTHN2Wmj2krBKYeUJNhB5p9uqzsqxdO8mlK2mkQ3IDyZ4DJz70MF5sZsUtDnLHJNbztr+CG+65CRyvY3w=
X-Received: by 2002:a05:6214:320a:b0:6c3:6f34:eba6 with SMTP id
 6a1803df08f44-6c36f35002cmr72924326d6.42.1725473014610; Wed, 04 Sep 2024
 11:03:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904144229.18592-1-ojeda@kernel.org> <CAH5fLgizixTZ8nytkSzSLA67+f=zWZZKt8xTJ2BQg5K0ivAAmQ@mail.gmail.com>
In-Reply-To: <CAH5fLgizixTZ8nytkSzSLA67+f=zWZZKt8xTJ2BQg5K0ivAAmQ@mail.gmail.com>
From: Matt Gilbride <mattgilbride@google.com>
Date: Wed, 4 Sep 2024 14:02:58 -0400
Message-ID: <CABVGRke2nj83ohcBg_Q4RCKHuVVXP86jiL=moZ8x3fBEuKv0uQ@mail.gmail.com>
Subject: Re: [PATCH] rust: avoid `box_uninit_write` feature
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:43=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Like commit 0903b9e2a46c ("rust: alloc: eschew
> `Box<MaybeUninit<T>>::write`"), but for the new `rbtree` and `alloc` code=
.
>
> That is, `feature(new_uninit)` [1] got partially stabilized [2]
> for Rust 1.82.0 (expected to be released on 2024-10-17), but it
> did not include `Box<MaybeUninit<T>>::write`, which got split into
> `feature(box_uninit_write)` [3].
>
> To avoid relying on a new unstable feature, rewrite the `write` +
> `assume_init` pair manually.
>
> Link: https://github.com/rust-lang/rust/issues/63291 [1]
> Link: https://github.com/rust-lang/rust/pull/129401 [2]
> Link: https://github.com/rust-lang/rust/issues/129397 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Matt Gilbride <mattgilbride@google.com>
