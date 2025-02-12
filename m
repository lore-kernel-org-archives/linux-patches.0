Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3DD253F0A
	for <patches@lists.linux.dev>; Wed, 12 Feb 2025 22:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739399388; cv=none; b=InutxocJ3rhqrCT5xigj0R0+V3rVqB/eNjAec/xx+Ry8M268+IHOjcpR9YMnIeni/4JGkn6vKDSHlNFRe/0qEzHJUwFMNhkRAiJiJPqT+rQ5Kqdxd7K1uYzJcOBaGK+1l635BToQyMnTPg3lBGKPi1hmyHTJTfkNhklYxYq0umg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739399388; c=relaxed/simple;
	bh=BFRXywWhuF494EJYNCYLCR8TnlqDFSbUwgsOkRXCO4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oP5YwC4724YKClr1A8paN00Tck25Bnq4TAgPsimhjIAodQnDY+JmMcyrxUs2AptySCTKCwCQBiUuom2MjbfJ1XD6vvlxCBH1TFL4T0/qRcHWLPNHp7QCptSEPemPRRmISIfrY96hteloBcIukqtRH3IGUq5lIiKn5nXTNipnbvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dXP4kF9Z; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dXP4kF9Z"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2f9f90103bbso60902a91.3
        for <patches@lists.linux.dev>; Wed, 12 Feb 2025 14:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739399386; x=1740004186; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZ/n9bqBDmoNTEbi3+gOvCn9UNpfuZOs7Z4fB5U9DNQ=;
        b=dXP4kF9Zy8xjFrgcNQcPv0vLGqiQlphHr8XIwoMhGfiG51M/ruPmskD99AVQ74K85T
         9v5KHNAwO/ym9Q6U0q1cU82z1dCtY6VjZJxdD+YypAi/bS3gl22WlHB+hmtXxAHnypvQ
         xIs7BaGw4QzmSUjqJpKw+tlFhMuyxYQYkO2NdmGWvwVfY/Dm3CQLGe6tMnwqkhdzgL8+
         oM2T1VAmXqttuvm8Rx32lFoKi8r0+Qm9MCdjnsEpp1yFSktzhUqpFyRnmrDK8FvLK+mq
         XAaxSo77T6Y6Bl1Gl6Oqj+EgDmnqoN0Pk2d92CUhoaPvE6inlrZBELg7we9+TD3agSAk
         5V4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739399386; x=1740004186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BZ/n9bqBDmoNTEbi3+gOvCn9UNpfuZOs7Z4fB5U9DNQ=;
        b=kzyUhXXK/967MkE2lf+Oc5imFh2zDzm0IXSGExU781ch1jjsRW2UgUJmM7MCCDVPyp
         UJpyzXUacYZS3WeeNbkBuWgF6UkxyCIpyrsjXjO5SfnX88FWAG/g+YkFZcKqa9Ll0aWR
         qUpGfjJLofinuxnUEVAwnZKRbpL/Joc+602Um6qHHpDfiMgGZYnOb0NsZZVcnPmdSe6f
         N3Efktt2L9cE56bwYnOZbNpTXJYpvffGMZbcDsWhEUuwx78wjx0b9ahrvkm8dMIVsVZP
         WSpjZtlpnYhBi6SPrsKU036Bz6mFEw12goQSP5z4qH+4KzqVoCHrC9eRQP5s/eWoRxIh
         GucQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2PctnAa0P//Rkn3UenmdAw7WhUDDfANNde2bns/XALn0y4TqgezoQNwo0AzQJkpTEN+4FinFI@lists.linux.dev
X-Gm-Message-State: AOJu0YwWdUb5XU9dIrAz4QmsmyLSevPQh2H9rLDMOOT8WTXOn1nR6kAY
	YIgiPFNhbaZ9a0W1F5ZGkG8omafvJcpMUV3eXd/k5+J0rVGuW9E8rGHn3S887Up14g6yY+y5Zkt
	f28c6Zi9qVccIUvTio3Oxn0nu594=
X-Gm-Gg: ASbGnctG7jzfp1upUmxyx4V1XHpPepDygDYCVpFwW/f3L+wheF0AcxHcJAj8DvzL3tE
	mhcRCTlm07epN5qHzyqnTngJGoqVuoJDf5HIdPDTyq4+ul6PBVoPWLfl5LrOPpCSZqY70EZpj
X-Google-Smtp-Source: AGHT+IHadNrgevyrSkaQZhOhsxlrzLkSyiZy1ey/P41VMurfsqDNouU1k4AFyaXrZKXXjkyODVF3l1r5ZtwFJzNg/Tw=
X-Received: by 2002:a17:90b:3b52:b0:2ee:acea:9ec4 with SMTP id
 98e67ed59e1d1-2fbf5c8b19amr2771748a91.3.1739399385115; Wed, 12 Feb 2025
 14:29:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250206232022.599998-1-ojeda@kernel.org>
In-Reply-To: <20250206232022.599998-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 12 Feb 2025 23:29:32 +0100
X-Gm-Features: AWEUYZnuk0VGL_AzcBee1c5Y4k5tHfvfuNR0sTon-_manIWBu0BxLrpeWaavqr4
Message-ID: <CANiq72kCKgcp6f-K1gtKdq_O6UkkC0A8WmZ-vGGGepvQHT3zLA@mail.gmail.com>
Subject: Re: [PATCH] rust: rbtree: fix overindented list item
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Yutaro Ohno <yutaro.ono.418@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 12:20=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Starting with Rust 1.86.0 (to be released 2025-04-03), Clippy will have
> a new lint, `doc_overindented_list_items` [1], which catches cases of
> overindented list items.
>
> The lint has been added by Yutaro Ohno, based on feedback from the kernel
> [2] on a patch that fixed a similar case -- commit 0c5928deada1 ("rust:
> block: fix formatting in GenDisk doc").
>
> Clippy reports a single case in the kernel, apart from the one already
> fixed in the commit above:
>
>     error: doc list item overindented
>         --> rust/kernel/rbtree.rs:1152:5
>          |
>     1152 | ///     null, it is a pointer to the root of the [`RBTree`].
>          |     ^^^^ help: try using `  ` (2 spaces)
>          |
>          =3D help: for further information visit https://rust-lang.github=
.io/rust-clippy/master/index.html#doc_overindented_list_items
>          =3D note: `-D clippy::doc-overindented-list-items` implied by `-=
D warnings`
>          =3D help: to override `-D warnings` add `#[allow(clippy::doc_ove=
rindented_list_items)]`
>
> Thus clean it up.
>
> Cc: Yutaro Ohno <yutaro.ono.418@gmail.com>
> Cc: <stable@vger.kernel.org> # Needed in 6.12.y and 6.13.y only (Rust is =
pinned in older LTSs).
> Fixes: a335e9591404 ("rust: rbtree: add `RBTree::entry`")
> Link: https://github.com/rust-lang/rust-clippy/pull/13711 [1]
> Link: https://github.com/rust-lang/rust-clippy/issues/13601 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks everyone!

    [ There are a few other cases, so updated message. - Miguel ]

Cheers,
Miguel
