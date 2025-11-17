Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6BB30ACE3
	for <patches@lists.linux.dev>; Mon, 17 Nov 2025 09:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763372963; cv=none; b=srymWv1AGzJL6wXhegEW6XKXRCtIv6xwKjar0y+Uqc0ah7IR6o3aKusCOZ5wLxerlYxS7kSjPIeWpoinm1xdpuNKYo4mGcR2th7H5upBXg6UprS228sQdYQxQowYM3oJhJOXEljZa586Rl2DIZo79MeJYhY3I+tc4v7tpTrOSlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763372963; c=relaxed/simple;
	bh=CNE7KbqVQWvI2RgEONt3Y8S0ouzZQLAbHpNMtvz0fgY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d/OSIpfAMaTvn/GXKDq9z13LvCF3cbjccUva1qw07Ss9sGhqhVlQu+LJviFstKI3F84d0oNJxoWPIkuD7o7oZfR7w/I36CDhCRdwdyKCJa0q40wF259MlBOaoCQtg6edcLS5RiSJaHnB3Noo5UC8j+FklMlwJRPOM08dYJrOLEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F3JkCQHy; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F3JkCQHy"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4779cc419b2so15907935e9.3
        for <patches@lists.linux.dev>; Mon, 17 Nov 2025 01:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763372959; x=1763977759; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CNE7KbqVQWvI2RgEONt3Y8S0ouzZQLAbHpNMtvz0fgY=;
        b=F3JkCQHyIeKq8QkhwjDhtta1RcIcsvLNYy3H1tRLc0vQrrvkS9hVM9nARsP6nGCACs
         IEekbVfObVLez8MR42dDkdj+LHSbmXftIWvhiIp3nVb0kEt2Bt1wCwq9SBy4jDPxz6JX
         R8pBdDnUQh/6lfPzA4zZrXW0iy3R8XPHS3/120UdyQhN2yRrxC3RVi3/732CnRHtpnC+
         +N4Hsr107UbVIO6Vxp+cBHjBMUpCw70FAlm5FBXYNkqs1viteeWVzVMGCzgzCuAX2V3m
         6y+Wx7IHl5ixoAuNUtkUYfqsObmwRCj+qRJzI0YNW08UTO4RSEBGuNoH/nbK9gKvTpa8
         VM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763372959; x=1763977759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CNE7KbqVQWvI2RgEONt3Y8S0ouzZQLAbHpNMtvz0fgY=;
        b=ow07mT0oj+/9XD0oux1tTTDUmjBXIe9hyFfBcuFHHCZxjI6tBQelgpB7t/3AtemKhm
         qVCQoSVLn4qLeKynKlTaOmnAf5YDoCjQdaOmxu/ll6l3n0UMKJggI70TWMH8iJxqWU/O
         Ns1RIVcJ91KtE1l3+RFnXDyvHi2BhPavMqpj7mz6AEWO1HP8neea+i+oaBtUQzzSK1xV
         sg6bSDymIT+ZR6B+SAYSBNfBxsqf1TMkZ8DMzrmyYzPK5XsPlhHTwprWy+tlUH5A2Pfj
         o/x5+45iKVxGb6Qo+5NnGriO0MT5SgClWkA4BBWhEQftZrUra77sZdrQUodM+shLBPaI
         ovNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPzzhWDftfI7teD12I7NYQ7hxu4oBoV8SafJos7pA8UmjiCxJf+7SlyUB9adsX3+/iZk2tF+QB@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2fcurp0wGyn2vAjmb6JlnlkK/tKltjI7jkqxYl1sQaXEeV6VH
	OiZb8wnxjlmKgwkJ+3pvv+E9gHSmHOoXXG/QjIboOgMNwXE32r53ZxYY55Xi0ujd9AKkO7a7Pua
	nDQt1smnUoUbsV/L2HMiZHV/3E9pUFhDi18xJrg4O
X-Gm-Gg: ASbGncvThqWel8IMYXtJ4wnh/wHUhzii5VNZZ/dg/cfCBKP2sXeCXThGeqbEQFHiyp9
	ticnLeTsoXliMjqt9GOOZJ4yQaVYgjBtPQAJ8BuZhV8BRQHl1vEqgyVe4dvr7/i0Z2Hu9DmrHxd
	A4Ka7nDtMnFuh3sjS2K7fANAPWev/vmgBugjl9FImhCSNJ/HKfqLQ/914A87xMpsPUrh/HI74VY
	K2lBxifE/TBnimgPe+jZCf3KJUHxLS3n3RUXCr3K/2yZQZoE1dnXhVeEYrwQLxaqCNNseZV5NDl
	TPtY3KM2pRBOWA4DO+O0ESNnRR887h+FsQ0r
X-Google-Smtp-Source: AGHT+IH8YCYGV2S+juLRjDKyn40UwfPsqkcXdTOnoi2W85HbpkME845DVwjXxLdf4j6VbBFEphOGCaajGpmsgMuealQ=
X-Received: by 2002:a05:6000:220b:b0:42b:2fb5:73c9 with SMTP id
 ffacd0b85a97d-42b595bbaa9mr10050073f8f.58.1763372958607; Mon, 17 Nov 2025
 01:49:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117080714.876978-1-ojeda@kernel.org>
In-Reply-To: <20251117080714.876978-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 17 Nov 2025 10:49:06 +0100
X-Gm-Features: AWmQ_bkzFWgbscghZI6cgaoGm_Ak95pUyQ19oba0Tx8hSJRrA-n1VAVT0JCDMZE
Message-ID: <CAH5fLgjWFUwMaxPYGRR2YC8FCv9ex-YpM-VWrkVZ7Wgf8Qbtig@mail.gmail.com>
Subject: Re: [PATCH] rust: allow `clippy::disallowed_names` for doctests
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Benno Lossin <lossin@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, 
	rust-for-linux@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Rae Moar <raemoar63@gmail.com>, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 9:07=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Examples (i.e. doctests) may want to use names such as `foo`, thus the
> `clippy::disallowed_names` lint gets in the way.
>
> Thus allow it for all doctests.
>
> In addition, remove it from the existing `expect`s we have in a few
> doctests.
>
> This does not mean that we should stop trying to find good names for
> our examples, though.
>
> Suggested-by: Alice Ryhl <aliceryhl@google.com>
> Link: https://lore.kernel.org/rust-for-linux/aRHSLChi5HYXW4-9@google.com/
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
