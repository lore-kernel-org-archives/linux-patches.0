Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F107F1CB50B
	for <patches@lists.linux.dev>; Tue,  1 Oct 2024 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727802724; cv=none; b=JAH/HRas2DRcNzQ/qMruM7IUJd6l5MOTB1vekgrZFH5RdacYX9d7dmYNLifihQTXzhwOw0ZptItviiqwwd4Ix4NfVrCeWckcdQFNRlZ4/cvufypTCTweiO3Re9TkQziDxdVtj78RhHNF4vCxl1k3EsyQtElurxearsq7qLLides=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727802724; c=relaxed/simple;
	bh=sC39jjPhAHkzIyKoYVlvv9pTOoSBbDLMVZDLzFNZwoo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qrTclCmzEOFRlQdkzHaa828osUBfkZgnpUwU/Ctu7vD42G41thDcIYTzGre5swy57N+hbof2Kx3gXHyiYytx96/fhLYZvVlB0rD2uzR/eMu+HVClVFf77HRksw2BaTNzvsTav8T0Qf1JguAJNPJZ6gD/jCrswaTddNC4yrZ3xyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nP+wd60N; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nP+wd60N"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5398a2509edso600293e87.0
        for <patches@lists.linux.dev>; Tue, 01 Oct 2024 10:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727802721; x=1728407521; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sC39jjPhAHkzIyKoYVlvv9pTOoSBbDLMVZDLzFNZwoo=;
        b=nP+wd60N/x1Zj1TlA3NCCRP/+hvFfZrWuLU9oyUrfKhtW6CM52rBwbaHQSdWwrH9mg
         m+RpiA8L5Hj1Fwu0OCydcKK3l6CQDv5dV40oVu1y8HnMmffEDgWk7418wWyWaYoyxNKY
         0Pz50Q9VBfco6z3Eoi3rRepChZ8Culo8Nwh0Dx1+ALCZkM449IGZDvdV6+CGAVus3XS1
         BVRCqf5ELywEguToxNp+jA2D4G4OJiMSUA0SWC4HrSs6MPY9MQQW+8Yq/WC2lJUQtjS/
         bD3uhP5qLY1AG85wIKmenZsCFXt222pSEH5mVf1NVBVKs09/CUZLOu/J1Vd7BNJgKS3m
         UH/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727802721; x=1728407521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sC39jjPhAHkzIyKoYVlvv9pTOoSBbDLMVZDLzFNZwoo=;
        b=jhPzJdbhMevz5jourDwnkzyjgyn+ydu3sVByHxsCR7ydz8ykPPFPWD5tmY7QOlLQ5N
         nur3EYR36UdY9ez7cAPp45zszOkfOiYnOjgMNIAUJHnJQXCEsAB7/u9VFDd22M+de574
         T4bxNV2tAuFGprHrUjZr7AYKJ/BXpgPBV2vIBY2a5476f5CIcWkY/pjIssy51+X86Ek8
         z4daaIsRC4w+zJUXWGjPh2O9A/acet3YKLub/uj6Qq6ZloZ3goSn7ZPxIK0tUO9gzXlT
         0f4xAk+SSrx423F/S3MzqN9m8QThbkBGF1edguNIyXXrxPOR5fIiOskDtDleJs1sKCzD
         NcRw==
X-Forwarded-Encrypted: i=1; AJvYcCXStAYYhFFWmrR1ypOz3vPDskWci1yZZKROwrEGCUQf7lsSGnzVD5G5PBjvi2z15gyHS/H6w9Ly@lists.linux.dev
X-Gm-Message-State: AOJu0YyqEZMcSdOiHkmjcDBlIzMUQ7JLWzIR/xWa/oOtG4RxCYBpdJAM
	raFZN17qho3n4HhRPVJl7N3rQ2C/HjqcIpL3UEmg4ipYMzqabKsidPfJyENbW6gZ281OvvJHsn6
	69bXvpG0mPlVySBBNlNYCeYGXN0A=
X-Google-Smtp-Source: AGHT+IHKHRku2EkBhzAUSqu18scL+pCkpv1wbY1i5srIBY1ciu173sLzEq6cGISO9u9P0jB3frWmDXmFZMHcBbV3S2w=
X-Received: by 2002:a05:651c:501:b0:2fa:c4b0:a0eb with SMTP id
 38308e7fff4ca-2fae1020a1fmr1101491fa.5.1727802720878; Tue, 01 Oct 2024
 10:12:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-19-ojeda@kernel.org>
 <CALNs47vPzH7CSjRh=jW0xNTh9=oajUs4SAkTE2OHLd5M2e065A@mail.gmail.com>
In-Reply-To: <CALNs47vPzH7CSjRh=jW0xNTh9=oajUs4SAkTE2OHLd5M2e065A@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 1 Oct 2024 19:11:45 +0200
Message-ID: <CANiq72k21-kke0XFNf0iQ5gpECjAtEPg00tm-JwpNjff34n5+g@mail.gmail.com>
Subject: Re: [PATCH 18/19] Documentation: rust: discuss `#[expect(...)]` in
 the guidelines
To: Trevor Gross <tmgross@umich.edu>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 29, 2024 at 7:11=E2=80=AFAM Trevor Gross <tmgross@umich.edu> wr=
ote:
>
> Would it be good to mention that a reason can be specified with
> `reason =3D "..."`? I don't think we use this anywhere yet.

I mainly wanted to introduce things "slowly" :)

But I would be happy if we consistently use `reason`, I think it is a
good idea to document those, and perhaps we can get to the point where
we go for `clippy::allow_attributes_without_reason` too.

Relatedly, I also thought about `clippy::allow_attributes`, but due to
conditional compilation and the other reasons mentioned in the docs
added in the series, it is likely not something we can easily do.

Another tangent: I find the `reason` syntax a bit too "busy". I think
in some cases we may just want to write things as if they were "normal
comments" (and multiline and so on). Highlighting in particular ways
could help perhaps. It would have been nice to have something like `//
ALLOW` on top of the attribute, similar to `// SAFETY`, and have the
compiler understand that directly like Clippy nowadays does for `//
SAFETY`, but I guess there are downsides.

Cheers,
Miguel
