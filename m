Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D49235360
	for <patches@lists.linux.dev>; Wed,  2 Apr 2025 10:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743591353; cv=none; b=l+Jb6HUOBO5C7Y4JWxkkc6I2aYMpwfF+QriX7BWwZ9QHxXTDFyHO4LNhLo5ub9AeDd8EiTkxnEeXXwgkteirO1LH1njXDxmLM6YMiiH75/I6hV1ZvdAVX1bozKOhEKSpvTkT3u84126G2Cci7UN4QbcOG0URaIWdSAv3ZGd6ToA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743591353; c=relaxed/simple;
	bh=2unff7AX7/CiMx6nxGFXK762WquO5nYtTjoo3PeLRBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hCZe2Sbp+7asfsYslBYI8N0OZfvLN5t4zNbOVBjXVR7ZwFqIEq17NpFRwv9fAw6BvRo+Dze58MsukVrBRjQt7kyKd4bpyc0vKjeAI59nlPbBLcoCOdxGbHDhL4eJL1eiUbXf3/OiaCXPZRKJ++yOHsfhPLprAWT1CrMf/IyyZMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IgWumCiB; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IgWumCiB"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-301001bc6a8so1584317a91.1
        for <patches@lists.linux.dev>; Wed, 02 Apr 2025 03:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743591351; x=1744196151; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2unff7AX7/CiMx6nxGFXK762WquO5nYtTjoo3PeLRBc=;
        b=IgWumCiB21ZZxBAvZNkyMPFBops7M1kQi6h98rkk7KExY0Uxv+8X66vi3ht5Ubwl4S
         /O7RHv6/CUZERvC8vzCFYK7h6FyI5L+piHSMjM5kiisZUUfnVN7pcSta9ZID2OoXV/ck
         apP/hMXQ4/ga3CxqKice09SDlcabAoUYe2YGyvZDTaR+t1rBxrVAZrR3X5b458zOae+K
         7KwXrUNRTua4/eNLAvt65MOZ6AMBr3TPs1IYgnKnZBywagTsr0YVImsrXuJ2I8fm+hnX
         PioftECFtgKEOlxJ4veDBUiCHdcvqlQ3IF17bdy62xCAeDCQVNvxJw256InhuE7cJ7g1
         HCqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743591351; x=1744196151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2unff7AX7/CiMx6nxGFXK762WquO5nYtTjoo3PeLRBc=;
        b=XKVFlcNXeZtVUAsNI0y6WOkAFpAGKhA7MFRVD8ktjRCnCJN9p3Qqkb2yXqlbfCYDMc
         Ud4AbKSWS+Iw/YgL6u7PeTet9CGkpwzsP99HLmgF0sNY7xLZ/5AkWrfnXBqVcoH9/fyT
         sYQ2R4H0Ys7ha6WPPvTnSFSLMa6F9m+9iv9mGwod0B0vZb/GB0al3QD8KT9fKW9zKWfG
         U/85WuDyoa1i5ZI7FrifH3W7ZUE5hN09WmZyVIVggU9SUkFlYhl/KNZkZVE0M5vlfMvm
         bMcEHHO987Ptx4zhJCLwlmCEI3FNV4BTNBWjnN401eT8ac0pHYSGFyBH/qmg9KHGrBj7
         Ikkw==
X-Forwarded-Encrypted: i=1; AJvYcCUuPUCKx6MW5byPMOLYlzIUol3z0U6IQGx1t0Gn39MM+XiPTE6XkZk2HrNADEbNzN0YhTMxVGjg@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0rblp+Hs2dUqedgaPZQowv/TN4vpu0iUDEbFpSTIIc4ySkaG4
	vL+iuCHZKZQXWPRQ2vGKoh7P1A2rtTH3A0RUC9nndj/FOTW+9LJ0yKufMen7tiRYIe/7ciw5s7U
	HvuxPuCza3gD9I+dI8+eDdc9AmdI=
X-Gm-Gg: ASbGnctpXwRtlmTbxVjCPAyVrJ5E8xbRIaX+nBgykC5Jv00oIDFz/69C5hAEEWVIxXf
	3rcPh6DCcASl8tnvoIz5P4xI/uO6RIv32HCEA47bLqnBFdWnSJeQb6kW83aMradV++M/PTv2hUN
	l3vB7e/nP7VK7gM+6MNb5NyV50aw==
X-Google-Smtp-Source: AGHT+IEwypRozS9Ypyq+iyNi09n48TXL23+OZQhgw2E6xUF5HInNRbFsqSw9JYkC6uJkSMnlkIhGlvYz6HLFTDTXJRY=
X-Received: by 2002:a17:90b:4d06:b0:2fe:b972:a2c3 with SMTP id
 98e67ed59e1d1-30562d0e8f2mr3139137a91.0.1743591351337; Wed, 02 Apr 2025
 03:55:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250401221205.52381-1-ojeda@kernel.org> <Z-0A1a3nvqFiEVtE@pollux>
In-Reply-To: <Z-0A1a3nvqFiEVtE@pollux>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 2 Apr 2025 12:55:39 +0200
X-Gm-Features: AQ5f1JpRmankZqFUTpg6TFluVCP-dnEX0-s47bPx1R_EGfUv0T_zApVdT3BHjDk
Message-ID: <CANiq72mmJTYQ+9goEaq6desJCNHNeYKrQN_DJEe67ZVM_7Wggg@mail.gmail.com>
Subject: Re: [PATCH] rust: clean Rust 1.86.0 new `clippy::needless_continue` cases
To: Danilo Krummrich <dakr@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 2, 2025 at 11:18=E2=80=AFAM Danilo Krummrich <dakr@kernel.org> =
wrote:
>
> Not related to the patch itself: Don't we need to disable new lints anywa=
ys?
> Otherwise we'd get warning when compiling older kernel with newer compile=
rs /
> linters, no?

So far we are cleaning them up as they arrive (and backporting) and
deciding if we want to keep them or not etc. My plan is to eventually
have an explicit set of the ones we really, really want to keep clean,
since at some point it will be too much to clean (if the rate of
changes on Clippy is steady), and leave the rest to something like
`W=3D`.

In any case, `CLIPPY=3D1` is opt-in and the future can always give us
issues: even when we set an explicit list, sometimes lints have added
new cases (like in this patch), so we will need cleanups from time to
time either way.

Relatedly, we discussed at FOSDEM having Clippy be potentially
unconditionally used, but that would require changes on their side
first.

Cheers,
Miguel
