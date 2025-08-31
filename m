Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8617B21ABC9
	for <patches@lists.linux.dev>; Sun, 31 Aug 2025 21:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756676694; cv=none; b=Bd4R2KqzVmkFlFmeL+eZFP6SeA2RbNCTabnP9VX1EeLuOREhlvDXGobrD6mPSGBcBu6ZlK8/TFi7bXX/3+y9zmnmixVOHYDO569PDAFmFuoyk+BCG5gJYidW7df5rnt2cj1vZqWA+ksQ7nue35V8rqsxpnHCzHSvpWfRViOupoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756676694; c=relaxed/simple;
	bh=ATlX29eggwecSHBFWVx+XL5nfZNPfYyOe/RUNhsSQVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Es/Bx7OcK0I/vEAjYxAtFJVPKABDaZnuUyYauiB8JNH1hLtAFHaIf2itBjhuHit1hqNy4wSpQBeXWqR2XtgpeoEBOVe5fre/HTESF6b9ULdtXtgBVc37Lb4B2iX7Cd3NuJ45VwClCGdj6MQTzkDRHUiBRcVxTWwdUVOl2OiafxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=adwVF2z0; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="adwVF2z0"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24896af0650so8357795ad.3
        for <patches@lists.linux.dev>; Sun, 31 Aug 2025 14:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756676693; x=1757281493; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ATlX29eggwecSHBFWVx+XL5nfZNPfYyOe/RUNhsSQVE=;
        b=adwVF2z0KYCBkF+0XDR0zkSTR1ksnSh6Vh0H6MtZoZhET4pMO9qCIc1FC+Aa51tUHV
         SZiBNZMbnRSonQBXonfhyDKlosbKhe3WvM76hENeSbBW7KSKtcnVorIfWfSsZfFRcIIG
         jcwwqCboJtNzxZ/Q030BEKC3AFG+sfkaKV5LHgn0xHDQcFalpoFOH9WmWKV2porfsWxV
         ceSOZ+Psr9JX4q1De+8FhHEN9YuTqwhVwzX2PHVK1s8ZIakzQcXxhitL1icdIe/I/ZNU
         HTPqRx2faYbDn/kwITsHwu08EY74LFvysCwzKgGqYLkTvvvHImLDpeG0udfY3//nFQhA
         z3+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756676693; x=1757281493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ATlX29eggwecSHBFWVx+XL5nfZNPfYyOe/RUNhsSQVE=;
        b=Jz0RZGTgPY49RSLWnj+smX8CVevMvfblS0Zya2zLxv/aoC4XZyAWKtW047nBvwFdxU
         7TM1CsgnHyVleh2Xl7es442fafKRyoCU9S+Hl6CcLkvNf6uYeQgLoxycc6Air3k7NWfv
         V4NrOIclFfrATg2IasE9iQvx6NJPBQEjfvP1h6DLPFy3VkUNsm9LN/FWA8iCAVa42CFu
         dEz5p4lguDzz3nnk10ul+6DuZ5UJKIEUlwCg0/rEs5p2cLoJVN8cJ7hkp94PD+0iPUmw
         wakY9Xd2K9pTodBNUUobKt9ZPrN6LHgKxlO1zXwGnLosIo0tVNfWC3VYzUlT9dio3S/u
         7maA==
X-Forwarded-Encrypted: i=1; AJvYcCVcd4uD0kkJmegIbnpU0s543ZRCXv6pYNjntesqlYBqZHFyqhUXTBs0S/8K0dZB/MpCeDl3VPGG@lists.linux.dev
X-Gm-Message-State: AOJu0YxKzvhRPRM5lF+Uux2TxGZd6XUsWmG7HFnBV0JIGcfoV2xtaKkm
	KBeDwy5NU2k96fAEVXvkLIwN+C69JR5alsZk+S5r+BkDCa7D0H3smBXoBImLkDYs3uIwExOaeOG
	tO/2opSgR3fzbB08jG3pMryDnhpwWljo=
X-Gm-Gg: ASbGncvJIgLpECQ/gzn9KB/KzpR90P+rJZjx68sQZAipdorLLUaQgGcLBg1tgBI7FSY
	iLvUD7dxf2dBZx6NkzymOAVOKML+fdWfqFIhVEz7x8yil0WvpdlpCEj7g+fA6wbiUuhitsV2tAC
	IbXVcsUzt7KV0HeFOOJAf2FUnhDGefD7lpeCk7aqIPyUkfjFajf92H6HJbyqoph/vs9eTAnDYZ4
	mxbjTanLPZRm1iXSo+havMw6X/xg3ZlCuJ2MN4kWEdOXvcd2NZxJTejdOK4iXnhJn4WSI7W65q3
	V672KZtwvLKfihz4ffDMO1m1qQ==
X-Google-Smtp-Source: AGHT+IHn8X2bk0G5dh7IMtbUmjvB3ATMrDad+r+JYlgB/nrfuB8xgJXEqdwDFEde9aacqWBGOAXr0FBhUY9DnbpUeos=
X-Received: by 2002:a17:90b:4c4a:b0:327:e781:3d37 with SMTP id
 98e67ed59e1d1-327f5be1809mr6603432a91.6.1756676692690; Sun, 31 Aug 2025
 14:44:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250829195525.721664-1-ojeda@kernel.org>
In-Reply-To: <20250829195525.721664-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 31 Aug 2025 23:44:40 +0200
X-Gm-Features: Ac12FXyChBItJccN3j0dFvHJBmKuYD7SYQmA2dMr5jm5bR3YjQ5JkmRcM0hMeJw
Message-ID: <CANiq72=yJzJTP54WSmp2d0_Ox32KzE9WCDX1-e37GC3b2Mu5Dg@mail.gmail.com>
Subject: Re: [PATCH] rust: support Rust >= 1.91.0 target spec
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Waffle Maybe <waffle.lapkin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2025 at 9:55=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Starting with Rust 1.91.0 (expected 2025-10-30), the target spec format
> has changed the type of the `target-pointer-width` key from string
> to integer [1].
>
> Thus conditionally use one or the other depending on the version.
>
> Cc: Waffle Maybe <waffle.lapkin@gmail.com>
> Link: https://github.com/rust-lang/rust/pull/144443 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> Conditional to the PR getting merged.

The PR landed, so applied to `rust-fixes`.

I may be able to take tags tomorrow, so those are welcome of course
(thanks in advance!), although it is already getting tested in the
Rust CI, so it should be pretty safe.

Cheers,
Miguel
