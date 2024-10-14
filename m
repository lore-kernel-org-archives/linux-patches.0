Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7ED519E806
	for <patches@lists.linux.dev>; Mon, 14 Oct 2024 12:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728908102; cv=none; b=eI8uRLIr2SfVEBxbrdOHQT2JhlozFgryQT1yXg2HgAucNygXbMZwMBrexqQjK9uzmVd3lATa+ITLxCLUwQ1bE35hZS6PU/JfMvNsAr4mtRv6d+eyys2ytJwTPuiH5BaKDCkhofIM+U3fwoYSDOs9EsIP+uz2n+GH/p81DJl08TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728908102; c=relaxed/simple;
	bh=iQVLJCrO59l+U3C8nBsH7Y/xyKdeTfY2kCaFyYVzpXk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QS5fkH0n66JuiDeUkvEAPNtNcNVzyLhtwIWjXIfVRyyTHV4z8vK/lDncRkpYrD5uQmWYOlh9wNOVPJel0vDzhX1yy9rl6l7wmwiL/jhTSsCh49kb4I5fuN9d6tuOAV93bm4Of6GO13LPrvTJPUsXEhRZl+Ei7qOLwldHuqCRKgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lvA0LNcE; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lvA0LNcE"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-37d50fad249so2662713f8f.1
        for <patches@lists.linux.dev>; Mon, 14 Oct 2024 05:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728908099; x=1729512899; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e7KSNGy6l9LM1AhD6ncBYc2Uc1aK2VpPwzUYAgzX7Wg=;
        b=lvA0LNcEbbjA1wr1PbZKmzpjJQ+EGyUmcy9C+d+ue4healE61+XANWaNH4xaybDMOR
         g8ctUULRM5PfEMCcVhR2Kukdv2sYzvk0c1qXrqayi+XwOELJru3F+LXxwlhbJi4X9PL5
         p7uyqlkm8HvEYFzFA+9VgBw5WGsOE2QrLWfl1WmTviDaSXw0uDTlfjrrbsgYcUdYJIyC
         yb/vTjGDHkC9WDc30azqOgovNKO1jq0R0oeHNjSdPicgTM7yQBZV+tMlgcwYNpmp630V
         fdQQCwaD6X17r79z0A0uUO7kMz1+YtZv5FSbFyDIPI6JobvepIPv4xcZXEteYlir0KYZ
         YKtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728908099; x=1729512899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e7KSNGy6l9LM1AhD6ncBYc2Uc1aK2VpPwzUYAgzX7Wg=;
        b=sndCb3s4vYhtteuxzodJMXhE5JQLZq1kHNORFWZIbaKRqiMWBGF0FXDCAjWm5WvtXm
         gINBp56GPIA2bI4brmm8Tennzd9mZ1aIR0Owpd/HxzCfy78t+bQhaK6PuOf0hHwv0XZf
         MhkhYrp/foUMTPIQaVFkqkCWznKjmmUgG24glSPiVnlNefcf6Z1EvHqTj/kUd0/3JdnQ
         15T1HNNP6OoUFGqDJU2h8JQXaPriLe2o3n02nhIpaHQspm5BfOnQSoOkPSdbTW7PhQPv
         dEAadBiF/eyux3YQ2FmjNTKGkC8mf1KmyF0XsVO2opHAXd3MhvD4czaP/XE+x6dSVt/s
         uu0w==
X-Forwarded-Encrypted: i=1; AJvYcCUNMnkc5cY/bOzvRK/5LLAGhMOpO7OdCOd+CRPRUK6zA4Y5zoN3aL/0v43VGdH4OyvO/NtOGC6G@lists.linux.dev
X-Gm-Message-State: AOJu0Yzo2MoUbVJktTI0rT5soP3n8fWAX2suOql+ZlTte/lGBcflJtQn
	SHcJ8zOh2vJe9FBd7uUqbjwaRID6RWB3mHblKItY/tGtTAvU0SIbVNQ/HkvqXa2IityXWKMW8kT
	NXzKtAa+QApXv2eRvDSk2ynq/ZzExf754iP9F
X-Google-Smtp-Source: AGHT+IHQMN0yL72SF5rkncUiY67lreSaBexOvErTNNOjpfPJPaa/qxhsWysQojiA1+0udb8Z//rGPUkFfpXe0x5GCBc=
X-Received: by 2002:a05:6000:10c5:b0:37d:4fab:c194 with SMTP id
 ffacd0b85a97d-37d551ed80fmr6540039f8f.25.1728908098738; Mon, 14 Oct 2024
 05:14:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241012231300.397010-1-ojeda@kernel.org>
In-Reply-To: <20241012231300.397010-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 14 Oct 2024 14:14:46 +0200
Message-ID: <CAH5fLggkQ-z97O94Am=h8ObJZnC5M4PtWceu9MJfNw5pim=hTA@mail.gmail.com>
Subject: Re: [RFC PATCH] rust: kernel: clean explicit lifetimes that can be elided
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 13, 2024 at 1:13=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> In nightly Clippy (i.e. Rust 1.83.0), the `needless_lifetimes` lint has
> been extended [1] to suggest eliding `impl` lifetimes, e.g.
>
>     error: the following explicit lifetimes could be elided: 'a
>     --> rust/kernel/list.rs:647:6
>         |
>     647 | impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator=
 for Iter<'a, T, ID> {}
>         |      ^^                                                        =
          ^^
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#needless_lifetimes
>         =3D note: `-D clippy::needless-lifetimes` implied by `-D warnings=
`
>         =3D help: to override `-D warnings` add `#[allow(clippy::needless=
_lifetimes)]`
>     help: elide the lifetimes
>         |
>     647 - impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator=
 for Iter<'a, T, ID> {}
>     647 + impl<T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for=
 Iter<'_, T, ID> {}
>
> Thus clean them.
>
> Link: https://github.com/rust-lang/rust-clippy/pull/13286 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> Do we want this in general, or just in some cases? There is an issue abou=
t this
> where we may want to leave some feedback:
>
>     https://github.com/rust-lang/rust-clippy/issues/13514

If this lint lands for real, then this change LGTM:

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

However, I don't think the lint is useful. I would rather that we are
able to allow this lint.

Alice
