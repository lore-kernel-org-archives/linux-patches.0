Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086631F0E27
	for <patches@lists.linux.dev>; Wed,  2 Apr 2025 20:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743625781; cv=none; b=ccxcj02W7lSwy78xVEGijF/b3oRpe8L+JMSRvu08jedT6ybV8teyfF6+zeU5vJZ2kVyJxIeg48iwhQ/YoNsXlKqVEY1NgrwrJXpkxfr0FWQxrPaTTVqP7mYwzyB688RA7o7uzdolNoKkC/Dql8iigbcyga7x58pOOczCrw4sfrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743625781; c=relaxed/simple;
	bh=G2MDdEdO8z0KC+Zdy7504GbR+idMVp6LcuRq7ECu370=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pKwJUg8FauB519DVB7sPIkxONHLBtFhaAvITgxqzrjrrdZPIBEVMjPUjAmP88oJlDOQFDUif3jitHKfZY4y4PulJT2Wno5ps+Z4+e89SMFP/zRRzyjlDr9R04s8NmbJBpOMS7jifei/k3XC/kS26EPQh1UreEZ6BDU6tMHbacf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BGjn/U7o; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BGjn/U7o"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2ff5544af03so36943a91.1
        for <patches@lists.linux.dev>; Wed, 02 Apr 2025 13:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743625779; x=1744230579; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G2MDdEdO8z0KC+Zdy7504GbR+idMVp6LcuRq7ECu370=;
        b=BGjn/U7oQfdbduyNJ/lJOlUuxwuaR09xXobFHSdzLRWAPrVBJEKC7keddksDEbZYHj
         wpjxHKI2uiq6+mYiExYv4fBq0Jfcafqc50uO7XZYvJaEC5eZ9zt606Pr6m05szUIfJjp
         FufbW5jMRzbUyT+8zwQ9sgt3ThatDaIxqhhfGeBYKvDxK3n9WksY0dwOKfSePBlsIMf1
         g1CaWNxj5yryDu4tbYxR1onFmenZWOJ84SXDTgD9Oj+HxBqrOOTpouiCba9ZCXbbFX+I
         roYPUl1X45jeDwglPv86PUoZPdUuRg8YJGfPrlRWPs838SuiA92hnzRkjDx8WEzTX66Q
         y9iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743625779; x=1744230579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G2MDdEdO8z0KC+Zdy7504GbR+idMVp6LcuRq7ECu370=;
        b=kRJf297qRPUtz29wLVQsndT7EZYRwQ+g5ebVYWoHIbnCg7ZFuMBt2wuSy9/PF8ian1
         JINyCisFRndI61+7XhGLHRKF5F2gc2qaTo5y62XNV7e2lTHqkQaZIRM4JSEc4jrZkz58
         h3x012bg1oLDJO+/mSOaV3TINW9w4t68T49UIjJKq9nC2FTCfG5+XowTR++nTSeOfspV
         TNSHmq2hUnURcVQEKsCSA2hIhbovLJmfiRg1vhBCZxB+wlhHDJkTDFn7yCO1MCmNJaYq
         byWEQ5819ngKXxFa4O4KcEw/l/g9lgZlUJ62j6ZoTDIzeUhfurct4+6iqum321Uk3Vaj
         As5Q==
X-Forwarded-Encrypted: i=1; AJvYcCURLuDepgYEAh3KRNtBMMvdeulCCkkwDC36Ng+1OalLuvsXSl8czy7NReTAxkfxtM9yO3KGjYym@lists.linux.dev
X-Gm-Message-State: AOJu0YzIkpZ1gZMJtAYCa7VvalrLiKN8ri6VOw/1fUJ/g7iju+tIk+yX
	l11Fh++8I5soSMZMbrKAAP597NrxSM3QiAwf5al7DJoPyaAC0XZQG9JPu4yVTzvVYqIWRTQQnt1
	1+3DC4LOMHehfvxH4PhvPdLM3AIU=
X-Gm-Gg: ASbGncsCekLSzT2ey5O24SOrL2UAJHDubjzuIBL1y4/W76NISFjCMdxb9psgVz/QO/U
	JYFAuNHw8wT/kPtORHTVVNy54mZbmI21yqLjanccAOmcBofQ43vnZklmiTGtZ+I0mjpHEw0NHhg
	CI+O5X6yCAjvT4V7meOBVlUEQ=
X-Google-Smtp-Source: AGHT+IFCmvkmz5a2ce/qEErTy+ix3lRxJsnJ8qatRbe6xQkTV1eTtqypTjSAmk71nyPy+VkbGf6oJPtgS+lqMyJ4Z/w=
X-Received: by 2002:a17:90a:e7cc:b0:2fe:8fa0:e7a1 with SMTP id
 98e67ed59e1d1-30562ddfce2mr4049565a91.2.1743625779225; Wed, 02 Apr 2025
 13:29:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250401221205.52381-1-ojeda@kernel.org> <D8VPGBN60E61.1Z48FQW6TL3A@proton.me>
 <CANiq72mdvnHvWbVNQbiXSRxd1xrF+A=v0RdJO74xeY3HyhRmcg@mail.gmail.com>
 <CAJ-ks9nAAcoJoFF+qNPbhsM32kOh9u+LGYUwFN_n9qqudB6YhA@mail.gmail.com>
 <CANiq72k36Tvwbzkg6nRdxB8VNRHLf8QzLeCXZq7sEPewccsWNw@mail.gmail.com> <CAJ-ks9nfEg=sdn_-q+xOc+k9mU0pdMuumwRb76LXzE3RcOtg6w@mail.gmail.com>
In-Reply-To: <CAJ-ks9nfEg=sdn_-q+xOc+k9mU0pdMuumwRb76LXzE3RcOtg6w@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 2 Apr 2025 22:29:26 +0200
X-Gm-Features: AQ5f1Jr5D2JPo_bfn1lEtiLKIRtSrkGZ03A37KRZeYcdWqFq9fOb3M7KrVF5WBA
Message-ID: <CANiq72mERwbmXYq-pi=WUAZ_VYGcBVS7tzH4P5zSUVCMcL4-CQ@mail.gmail.com>
Subject: Re: [PATCH] rust: clean Rust 1.86.0 new `clippy::needless_continue` cases
To: Tamir Duberstein <tamird@gmail.com>
Cc: Benno Lossin <benno.lossin@proton.me>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 2, 2025 at 6:41=E2=80=AFPM Tamir Duberstein <tamird@gmail.com> =
wrote:
>
> The counterfactual is hard to prove - you don't know what true
> positives the lint would catch. In my opinion disabling lints is
> risking throwing the baby out with the bathwater.

It is true that it is not easy to know what we will exactly lose right
now (apart from what it claims in the docs and its examples), but one
can easily test enabling it in a couple cycles and we would have some
data from kernel code.

To be clear, disabling now does not mean forever -- we can reevaluate
with that data and possible improvements to the lint that happened
meanwhile (sometimes they get improved or split due to feedback).

By the way, the lint is in "pedantic" in Clippy and disabled by
default -- so we are "only" disabling w.r.t. what we do nowadays.

In any case, my main concern is cost: we already require a lot from
Rust kernel developers, typically more than in C, and while one goal
of the project is trying to see how far we can go on being strict
about things like lints, I worry we may overdo it at times.

Cheers,
Miguel
