Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939B520408E
	for <patches@lists.linux.dev>; Wed, 12 Feb 2025 22:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739399342; cv=none; b=bTYYO9l4HfMTRFDfn9Q+Va+FCuTo3pjebOxZ1Kh5SaAOxfphEYj+a5xMoTFv6T20eGBcrcVREsUeGZE0jJDENtu5S/IiUO4heWtQ516OI4BHtZtFKM8fGAztY89LL0nFQBbsJMwHd8woPB/hRpUOAlC/ed4k+8p3Y/u0SBe9wdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739399342; c=relaxed/simple;
	bh=olRmeoWJbLFymDQz+cYE7O9G2aS/9jPA+woKLGiFgNM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ABkP4TLuOjLaPRDoVnlx5864B54BLCKYunBpKglF2OJyYqDrPCNgCRtw4mrHDWZYuC2PoLp/CjOQd6njjith2DyR8LBIeokpiXdpoZiDdFBNqIqajkIElsiocGWHzm5VJX7sXhvb0kTOo7urq0M6QKn3xebF7rV3mYwYhAk8zLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yj8dPiKK; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yj8dPiKK"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2f45526dea0so58111a91.1
        for <patches@lists.linux.dev>; Wed, 12 Feb 2025 14:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739399340; x=1740004140; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y0ISjjYlFd2w3B9BHStKW17Hk2awDabFxHbFIHma1pE=;
        b=Yj8dPiKKbCagUjcqAZRTVIP3hTYM8XnlLf94ltDWf6ZqDbe0v3agiTvhPtZ8RMlzaM
         JaYMdq7jr7VmBz7arhsvrKYvFHif48MXqmWVyNmAfZu0+gUtFL1VH0iRc6BDuuZDvFOX
         6BUFSORCmGSTMZlCrUdJp5guvR9QCI8PFyzXf4e5O035lBI0T/o2mGF3hzfQEwI62X/G
         npvP102eON9IXVQJd8jXDcL3VmWDU9iKUrlQfw9id6wRzkqjcSzA8Umq0jruY+1LMsN5
         jY8sPbl9qG51P2ST1TR7dipzNduQGyMchrgXjIThjuB0Pf3tpoOkpL/vDkZJe2/0w8ha
         ZZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739399340; x=1740004140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y0ISjjYlFd2w3B9BHStKW17Hk2awDabFxHbFIHma1pE=;
        b=EhVZerG20z8kIhAmBdvYoICWSOz4uZ2brjWiSfKYxI8IHHeVqfkojyeppzHK10zE6S
         zUh6TVrZlxatZaCAwsZhF4jnViWyHWTkLA1e74cuiGW+q1OFGiPeFWzNcKPEfovqGyDo
         HcddxxL6DPMNBGl7LJ9oqlZvFnwfkeUiLRnCr7yQztQgMilrsO9JJC3Ew6q2D1yVe/Hg
         hl/ZviKRg3zfkru6xRU4dXDvxaHnGA5hP9UoqncQhfyQkFBYCH1YAzwxiwu2/gKXwXdS
         hV07SXF43vuRcSecOzQxoXLzPj78mEQsTbALX1kGVD6iex8kKJP2D2yN78Hrw2zmrvPJ
         UL2g==
X-Forwarded-Encrypted: i=1; AJvYcCU6J7Zk9mpdVVOBIWxqJdUx/vKnhTSRbekgXGt+b2DcIUcHEJ2QDYE7RC0osLUo0YVIInKkTQrn@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/TEUsTPgu43fIfcQbUy2zDUd0bmSs3JJrhZEjQqBd84BjU3Qz
	c0tkNR8NllXbsybZsdzHVtkbR9UgAGNKgmDfT/xpunzt3bA8d98jEIidFVFMNSNoBn7tc8/Bi99
	/8RBiDib0uCeqk0wlzOzpDC9aNOw=
X-Gm-Gg: ASbGnctbjHkO1X6b/n+DtUUU4dbgWsSRdIDgoGkeWG+lJYRPljfKhln5+cSNbzpeNBG
	ssz/X48nJfRcFy8aom7YrtSycEYivNjxF1BNJ7NGpNyIf4AQetwUcsRfnJfyodpilu5BWE/Ys
X-Google-Smtp-Source: AGHT+IGq+yPlgVO4dsKAOv/QQxkZUjh556uN1Ur2VQHSKRppM/rFN7XROxwcs8o0k1nBNY/IrDjnXGzRXpmi3u55nj8=
X-Received: by 2002:a05:6a00:3d03:b0:730:915c:b77 with SMTP id
 d2e1a72fcca58-7322c36bf0cmr2710792b3a.1.1739399339623; Wed, 12 Feb 2025
 14:28:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250112143951.751139-1-ojeda@kernel.org>
In-Reply-To: <20250112143951.751139-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 12 Feb 2025 23:28:47 +0100
X-Gm-Features: AWEUYZltnP6UMrmvD_9KnN-NbTFvWz3zGVp3W1kw8rCGt6Iqjmsr5YvFs1Qinns
Message-ID: <CANiq72=8D4X1RBCmB9d+DTkEzifzn4nTcS7-hWHyHUxe8v3q0w@mail.gmail.com>
Subject: Re: [PATCH] objtool/rust: add one more `noreturn` Rust function
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2025 at 3:40=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Starting with Rust 1.85.0 (currently in beta, to be released 2025-02-20),
> under some kernel configurations with `CONFIG_RUST_DEBUG_ASSERTIONS=3Dy`,
> one may trigger a new `objtool` warning:
>
>     rust/kernel.o: warning: objtool: _R...securityNtB2_11SecurityCtx8as_b=
ytes()
>     falls through to next function _R...core3ops4drop4Drop4drop()
>
> due to a call to the `noreturn` symbol:
>
>     core::panicking::assert_failed::<usize, usize>
>
> Thus add it to the list so that `objtool` knows it is actually `noreturn`=
.
> Do so matching with `strstr` since it is a generic.
>
> See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
> for more details.
>
> Cc: <stable@vger.kernel.org> # Needed in 6.12.y only (Rust is pinned in o=
lder LTSs).
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks everyone!

    [ Updated Cc: stable@ to include 6.13.y. - Miguel ]

Cheers,
Miguel
