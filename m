Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8881F941
	for <patches@lists.linux.dev>; Tue, 27 May 2025 15:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748359361; cv=none; b=FIBuWMDx5O4WIpxzGZ8h3ykPRIncsSrbFaQ6cqfmLH1mKQehedf8s8dg70zLGDRaPMVSYr1IWaskmjkx02lGHaVoatf8zf6vZxEf7DFeDjXwQC2gkdt1jN7PXF0krV9TwJ/bmtjG/fJ0cJ2FJ3zNcZnKKuXgPycnTetgzqR1mks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748359361; c=relaxed/simple;
	bh=xFVApp8xTfR/YzA8SQhWfU8t8lZcJsWBKVg3yZcwNbM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e6R9o3Ae/5jBTiBmxSoog3sWc4V+39RZ7Hxu3Nuil6nWIX1Sq+LWt5YEkbpzAH1Jej0QhWYobxlm7nTBS6QdKCL0emtEtHMWCpM3MbgfmlAelg2FF03yrQq42s0SwN5NANIf8103POKyrxWdFaKb6KWAggZtRKdJbw+FdBzYNNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KbOPWakA; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KbOPWakA"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-234ae2bf851so672505ad.1
        for <patches@lists.linux.dev>; Tue, 27 May 2025 08:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748359359; x=1748964159; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xFVApp8xTfR/YzA8SQhWfU8t8lZcJsWBKVg3yZcwNbM=;
        b=KbOPWakAPPrn19OeTe2UedQTYEUJXC3W7P07/IFZLjr4000iFLE3T8h3Whz1b+G1MZ
         oLMOgGjv3sv0KVUkiW4uR28lFPT55iI7bLOjtem+re1fFSD+4jEKxZ2xbcwDdURWkmE8
         WNCdmVfHWTeBtOGwF9jIdBhkAkXY/bz70spuvefhxvQiQ9vRwd2dfXEw1gZulgz4qPSc
         /0yE3J/dCXp5Ww2yMY42ZJ8Nk8UMiUwZXLYmkCcbNGe1fXtIguHbUlHDhFLNFXzOk9JH
         CjTvk6m2GkwksparBE5ODO23fSkQuAnYzxOmYMJBznNro8QUfKg8hm8nJjHdr29o2EDJ
         Ywlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748359359; x=1748964159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xFVApp8xTfR/YzA8SQhWfU8t8lZcJsWBKVg3yZcwNbM=;
        b=wdRDaAEC1O/ZKJh2Dk6GoYTiOek/ZqNg2g2huh7MuMSlwgKkFLjZr0Zwn9q04oO9xv
         cODvm7IPsFxTR3lslz1Sj9guuTf4S2uCgX1Q3KG2gj9rd/JfzRVEyqpevthOVQhJFJsx
         2xqWvLvLM59Gu703pWAqVZ3bzehgmLrz/jh2hHP6KsNQ5waSmt8bBQ2I9Itg7EHUvIbK
         ZAOEZZComYE9SdF+qe+pVtMHS9l+vh5/gR15lzqFXzQmy2tlLTnNYknvhPP5XTYTSGzc
         Yq821y7sTnmAmpVHmqRXKRASmmPHMQ+ikMjIURFf9wjwEmWqsalFjSHR4KGemoDQVQ0z
         ymHw==
X-Forwarded-Encrypted: i=1; AJvYcCVPFfQwrcouHnXWpNRo4BvLP7rdBMtpFI1OcKPNiVG5FwH0Qf/xhz/lcNBqNQobiGu/y2WKLuuE@lists.linux.dev
X-Gm-Message-State: AOJu0Yxu/IjR8L1WQkkXx2aFtW3ewZKCQCkKZYbhsHrMBHCkVQrB1LX2
	0xUOQcfCHoOmwGlG9lxbXZnJR0zsS1S0cx3h2RoTJZvhfR6TwaLslLSWoZt3XbhJQmKr/V+W6xf
	VeJMRk+Ikz50Zi4GLJLI7s17WBdJeEQI=
X-Gm-Gg: ASbGnctvAxqMwRLZFaGFE80DQmIzumC2vjjJtqEsL52o7jAqg/gZlgkvjhrvyRfuUp/
	OhtkToqXBU/61uznSzvAwxw5HISffv1Nl9lyLjTfbbS+JeBk27hTZbHId3w5SVZj/c57AbpYQlc
	suhT00p5vzaWYaNed/xXgv69KmkoHQhBLy
X-Google-Smtp-Source: AGHT+IHQ0WA1MTUyC6cHQOw0z+tsCUEH0shIicp1agCv9Ylpi4oiC765zmtaMYFB7Tkm8FdLcYHAnrnZmM6rCS/lHhg=
X-Received: by 2002:a17:902:cf03:b0:21f:356:758f with SMTP id
 d9443c01a7336-23414f2f960mr82446905ad.3.1748359359182; Tue, 27 May 2025
 08:22:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-3-ojeda@kernel.org>
 <CABVgOSm8T+_kXY78sioUHEcG7rYApfWK2Gfxkrvw94Dz57G0oQ@mail.gmail.com>
 <681912de.050a0220.383f17.18c4@mx.google.com> <CABVgOSnqtxwYQBbed_-TYr6D3BZJ=MT3KVv-eXUFbnRm1UyETw@mail.gmail.com>
In-Reply-To: <CABVgOSnqtxwYQBbed_-TYr6D3BZJ=MT3KVv-eXUFbnRm1UyETw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 27 May 2025 17:22:26 +0200
X-Gm-Features: AX0GCFuo2q6SOgnXa03Y5boBAZLUrzMqZnJGPrSsiqpZAwCDDg2s1k_ev0Vzb3E
Message-ID: <CANiq72kSjCueyXQBONE+nOOiHd-AFTu91N55a=pu07Z6iNjyjQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] rust: kunit: support checked `-> Result`s in KUnit `#[test]`s
To: David Gow <davidgow@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Brendan Higgins <brendan.higgins@linux.dev>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Rae Moar <rmoar@google.com>, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 6, 2025 at 8:33=E2=80=AFAM David Gow <davidgow@google.com> wrot=
e:
>
> FWIW, having out-of-memory situations trigger a test failure is
> consistent with what other KUnit tests (written in C) do.
>
> There's both advantages and disadvantages to this: on the one hand,
> it's prone to false positives (as you mention), on the other, it
> catches cases where the test is using an unusually large amount of
> memory (which could indeed be a test issues).
>
> My go-to rule is that tests should fail if small allocations (which,
> in the normal course of events, _should_ succeed) fail, but if they
> have unusual resource requirements (beyond "enough memory for the
> system to run normally") these should be checked separately when the
> test starts.
>
> That being said, I definitely think that, by default, an `Err` return
> should map to a FAILED test result, as not all Err Results are a
> resource exhaustion issue, and we definitely don't want to mark a test
> as skipped if there's a real error occurring. If test authors wish to
> skip a test when an out-of-memory condition occurs, they probably
> should handle that explicitly. (But I'd not be opposed to helpers to
> make it easier.)

Yeah, agreed.

There may be value in differentiating errors coming from `?` vs.
`assert!`s -- i.e. the discussion in the other thread. It could even
be a different error state if that was valuable -- though I think over
complicating is not great either.

By the way, before I forget to write this down: I talked to Alice
about this back when this discussion happened and she suggested having
a `Result` that carries extra information -- the location. I was
worried about the added cost of doing that in all cases (i.e. for
every `Result` in the kernel), so I suggested doing that but opt-in,
i.e. with a Kconfig option that would be in e.g. the debug menu. Then
people could typically run their debug kernels and things like KUnit
with it enabled, but production kernels without it. Then later on, if
it proves useful for other things, we could try to figure out ways to
do it without too much cost.

Cheers,
Miguel
