Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C084636C5A3
	for <patches@lists.linux.dev>; Tue, 18 Nov 2025 16:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763483213; cv=none; b=AbE6H4CK/+C63rldc5d8G+YRhfdMJzYY3R6IS5zLWpnKrxo/NXPtJeAOZggtlt4ZXYGIB1UK3abXM/cyRzsKldoooW+dhZIozj7+7zK6BFaibk1U3rlf+NlS7Cm7hM3W4V/bvSToULy5j5cF+17qn8cImwDPzeBjBYvFq4j2Zfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763483213; c=relaxed/simple;
	bh=FwtecA3cou5swpKk+7V9h8LfHIUHPkUFVZFloQEb+dQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pC2sU3pUNayNb0Ts24SKJKkMGHDMFqjf7ZZJYmO5hPCYP0oHtw2KUN1Udoteju7CUdXuO51JDQAbXsNRTAB/Y2CTVd9LybHLCZrRqh9jP+ZNL8IFyS2gdjpoDmD3/p8jN53GTq5gjXKF8gC8GtXJ8aiBA2ZgN5Io8NIXL3yJQMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ug6ld80G; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ug6ld80G"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-295c64cb951so242935ad.0
        for <patches@lists.linux.dev>; Tue, 18 Nov 2025 08:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763483211; x=1764088011; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FwtecA3cou5swpKk+7V9h8LfHIUHPkUFVZFloQEb+dQ=;
        b=Ug6ld80Gedkwb6YqPq2VRY3+0HoPs0ZVFH06MJqlAUgtTUyE/lv6gMF8rR+gXAx6ta
         tzhrnO0npfKO76BvyvKsSXdBXDCf4Zh13FIPylz3KQjISBYSiZCP5kORvnSnehzqG4r8
         pFQBDZj3mZxMatQJm7/Qh18+Ibrb064qxctU8KDSefp4AF1qTQi+7/EYPkMMgFnMxbut
         3eUCHYHG+Jg5DdWGd1q6aOWh64C1m+gWiLlOIhU8XpFXuaQWa6Qxn4FOOlpu350vZV27
         MhE6LJaruZ+fux/rnQCcmby/sp4UD0yw1wcZrAGDWOSNE6/uWv7f40DPPB2LdrDMBecA
         +v7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763483211; x=1764088011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FwtecA3cou5swpKk+7V9h8LfHIUHPkUFVZFloQEb+dQ=;
        b=tSVQajlZESQHews5AwoppSvBzL3DfeOhYZo6lvAzGWwfZyUV4WYt1HX5n9fBQsn19+
         5x1/2k8gUgyBm170lk6EE8ojlRWDR2XyQ2xR1mlTUBmnMIvqLOS+tu336tfOU7wWgnQG
         4qXc4hg2u8yjw8KGbFW/wRBFkAk7TVg7zVTwsXBdEawgFxoId1/P8zKYK9E8gSpltjSi
         0xl6ksjFmxXhU1Uprv3pjB1/+OmfE+ovY4Cn/SukDdPjHpq/b05HVco3yNrNu/XjrKrN
         HKxcYmHR6NjjUUHb9SPeDgxqRFTYDbf7XwUaVlc1PacO9GKL3yu+FnmeUw7RDPDpk8cK
         Urag==
X-Forwarded-Encrypted: i=1; AJvYcCU3fWYjeNv8v4yZ3vRScpB8rAsVQ4JUzARtAX39u+BYfelAmEkT7lTFWbNQDT3Ouy8ziy2k186+@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1Pehd0Nfk4hV9XBLHBzOAK2OvOlGiNaaPVVGzHhWgVEOIQwzN
	K2mmf32EvJ5RHTVIov60hjs8Zyt6BDH2yYnBqRnJDnNEPGtAWPf+8rpJr3LS9e52srx3/fqg8L/
	lIg+XtFn7tDhoMeAllNuX4gtGHi05/WznFvQTwBh+U+VyTwKQZnIQT7Ml
X-Gm-Gg: ASbGncvjqL/gd2s0dYaN18mSG4CGgsujOXDi9w1e6+MIUg5GeTYSxSihzCHhI5oM/3V
	duU9GZwf7gK9ZXD3cOIJDLEG+rfM9YJbbyrANSLV4u9qkafq8TWtao+l7lsN2IibAGI1L9vF7hP
	Fk68bpQ3vlzNEtDb5XmpQ0mPqKv8IfUbgdSbBLzeulH53AaM/aJ7a31Q59VDWOlHnacyt4NfDpQ
	+U70NkvvtoZCEe0iDpbuOISOBtwgI3Ql+P8ClGwkr8Ycv5Uk5BW3F4EsKqHGPd+NB8gDRI1ARF/
	UII=
X-Google-Smtp-Source: AGHT+IEttx3J/mC4gE4KpQ4cPRjj+rRjuHjvkWN8RJrR+j19dbMNf6uYkFpkl0xwq9jCxBWF224ugSC9ScsaeVYU4f0=
X-Received: by 2002:a05:7022:4387:b0:119:e56b:c1e1 with SMTP id
 a92af1059eb24-11c88f6e153mr87381c88.12.1763483210529; Tue, 18 Nov 2025
 08:26:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110131913.1789896-1-ojeda@kernel.org> <20251118145741.1042013-1-gprocida@google.com>
In-Reply-To: <20251118145741.1042013-1-gprocida@google.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 18 Nov 2025 08:26:13 -0800
X-Gm-Features: AWmQ_bkpM4OnhqoM9DwukpapoYV-fxdR_ddUQfMp-wv3ty5dsyWJZ2MH8TZJaP0
Message-ID: <CABCJKuc0ZwN23MX4mV=vVne1giR=iWKSvqFg1oKMqxUcnOWiCg@mail.gmail.com>
Subject: Re: [PATCH v2] gendwarfksyms: Skip files with no exports
To: Giuliano Procida <gprocida@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	linux-modules@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Haiyue Wang <haiyuewa@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Giuliano,

On Tue, Nov 18, 2025 at 6:58=E2=80=AFAM Giuliano Procida <gprocida@google.c=
om> wrote:
>
> Hi.
>
> > Thus do the last one: don't attempt to process files if we have no symb=
ol
> > versions to calculate.
>
> This results in the -T foo option being ignored in the case there were
> no symbols. I think it would be better, consistent with the
> documentation and expectations, for the file to be produced empty.

The kernel build doesn't produce empty symtypes files because symbol
versioning is skipped for (non-Rust) object files that have no
exports, and before rustc 1.91, we never ran gendwarfksyms for Rust
object files that didn't have exports.

> This means that just the for loop should be skipped, say by adding the
> condition there with &&.

No, I think the current behavior is correct, we shouldn't produce empty fil=
es.

> If you disagree, then please update the documentation to match the new
> behaviour.

I re-read the documentation and it doesn't really state how the -T
flag behaves if the tool is used to process a file with no exports.
While this doesn't impact kernel builds, a patch to clarify the
documentation is always welcome!

Sami
