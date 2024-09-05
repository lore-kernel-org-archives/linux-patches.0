Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A42919413E
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 08:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725523801; cv=none; b=KqPHha8x/d2T+FTvBjGuTxYpgAZLFQTtFU1xOpGnIMU5UBPQqzhiawxFR4k4XrY1LZ8t1pfXQ7SeX6ASUJc047gZA7lCHl7eN2sJHZta0nirKk6ICd2IYbqFspmPSP1xZDyKaIFnB47W/Rr6rOSkoDJojWRpsCm0xHB7QN068nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725523801; c=relaxed/simple;
	bh=tySEusZ4FVsvRHMC8dzgnyRnOLSB1ruPGBu0iAoTrG8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=odqcFQsRUaxtdx1Em0foDutTvP10nZVsMz7Xz7ZflTciVaPjrBYpuXVKwgHOtX3mw9gnQH+hO8hRajqIyNv1dXzMylE/XUMR6152Mn8Eyj7ZmHCfZNAEcH++RSwqG1NtqfwR152FRVGKuKljXTSGIGPzii0uX+k6mHxR7LFcHXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GChs54V1; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GChs54V1"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3787ddbd5a2so241280f8f.0
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 01:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725523798; x=1726128598; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6n/3Nx3QiIN/O2j0qCpOzIrPKFXDE9gLIjro9H442WQ=;
        b=GChs54V14+tSW57N0SR8o5p2xJtR0oRfD8qDd9KUScOkxVQFvFfu/UZ6UHr0bT9vlZ
         iBS+TVYxl18EfGdMZozjPLlMBebYeaK8PEgMkGFt7OTVfkHEV4a5HuB5fJBhDweq99oo
         0nSQoqmRYBGV7g+iPuRg4S2blLHc7z9DFVTI/xBKrnFx88F213nqiGkUqaXo+PAoIg2X
         vi22b0ra9vJiYkUZUltmj8kiAYlJqxzVnAxqJM9h3hrIsXpLDRR5+lGIegYl0BbT0hWZ
         /uqPTwg0u3iO6Cyxu3FQw8IKGFSb89rHd8dvpQ5tOO1pGvBR1aj1ghC/QIhNkx0dujdG
         /5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725523798; x=1726128598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6n/3Nx3QiIN/O2j0qCpOzIrPKFXDE9gLIjro9H442WQ=;
        b=c/WvzC863jy9plbL/FmXRzchpkHtIrYuxPLqd0OOEQpLz0hxOofkjpjLGRJS/h7LIL
         trtHcmkP+VSyxU7+fYl6VTLmr7XdZYk5q+e/KnwSmbqZFl6m8NRBCYFTLKgGS8sZt7L+
         yo3BMjY1MiVmycNdZPUm3QCY3bNQI/aeEMK+3Kui+W4bm57RTjFEeHObAkgoy4jkmp3B
         88d5L+ELXB38HEvo2s+OR7b2YMBaJ9S4TfAj4xzX0oV7Do93sTWd9eKyT9x5ZPUsuR1K
         SgaWpppzeDq+hsCD+4QtK/KAZ1dEkyTz+MVsF6olqvAQzcrUlRw5oVZUxEmlglWrf2+B
         4icw==
X-Forwarded-Encrypted: i=1; AJvYcCXwYN4B6M+35B7l8ymcHw3gGchxfdHQ0SiXNrtobvaCzsR0y4HGaRrjr3ctGO53keUZNyilFAN8@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/xwsIvYM24PJXc9RsBrgG8u089aR5AQT+eoKBbaadas2G5W4u
	qTk8gm8Rpg/aRI1baiw8n6ilRQoN3qxT54s1ae5XFXnW3ImS0aP2qr/p/32j9eufheM+A4L/pl8
	/Z3BODqGCkUB9OJXQRF2lVLrXpClK4Npem1Lj
X-Google-Smtp-Source: AGHT+IFD+VhaVe30caoIouMe2WUcx/xOWXVjE0LRfp5/b0qYljHoevwRDg/MOcmEHwV7hYCpWSrPr1zFvGm/2eAJAlE=
X-Received: by 2002:a05:6000:2c8:b0:374:ccb0:66c7 with SMTP id
 ffacd0b85a97d-374ecc8f350mr8137862f8f.16.1725523797494; Thu, 05 Sep 2024
 01:09:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-9-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-9-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 10:09:45 +0200
Message-ID: <CAH5fLgheU9ZSZzRF3RzG3AvW_h1E+UVb-PG9d3VnDUDjfLSoLQ@mail.gmail.com>
Subject: Re: [PATCH 08/19] rust: enable `rustdoc::unescaped_backticks` lint
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 10:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> In Rust 1.71.0, `rustdoc` added the `unescaped_backticks` lint, which
> detects what are typically typos in Markdown formatting regarding inline
> code [1], e.g. from the Rust standard library:
>
>     /// ... to `deref`/`deref_mut`` must ...
>
>     /// ... use [`from_mut`]`. Specifically, ...
>
> It does not seem to have almost any false positives, from the experience
> of enabling it in the Rust standard library [2], which will be checked
> starting with Rust 1.82.0. The maintainers also confirmed it is ready
> to be used.
>
> Thus enable it.
>
> Link: https://doc.rust-lang.org/rustdoc/lints.html#unescaped_backticks [1=
]
> Link: https://github.com/rust-lang/rust/pull/128307 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
