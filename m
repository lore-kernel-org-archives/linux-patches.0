Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647971AB6FD
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 17:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725298831; cv=none; b=H56+qKBPvE5P6F7UBH0R2Lk6p5Aj/Cc5M4N1KKneyJ/wXMyaHNXI666fR7sm/fvjmnnK00SksxAhka+ZeC3VxG/TgkqU4zDnFFg1Jw1sGh4E8vzJnRuSV4V6jFSlfviuVZByj+Uq+TJh1v3ZfvJ0PuiAeqbfEBzdE29SzX8szCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725298831; c=relaxed/simple;
	bh=qP1BNYF9CvG8P4XyqvF82TLJHMnRmeyjZtDrqbypFNI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gL/0ivHw9M/HtZpblT6EigFYpJg0b2De/wpPff8M/a6Ra/823pNIL+ADh0FwEecAOc5626NgYIIW3Eb1YFgcqxGQ3fBfv9cZHA5bzq395EeO1XsFuEllnbQSqM/+QcQ6OOE5q3mBkFT5VCNs6HEasy2LJaxokj6qDBKhXWMsVPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y/0UslCf; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y/0UslCf"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2d88ec20283so137219a91.0
        for <patches@lists.linux.dev>; Mon, 02 Sep 2024 10:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725298830; x=1725903630; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qP1BNYF9CvG8P4XyqvF82TLJHMnRmeyjZtDrqbypFNI=;
        b=Y/0UslCfKwAgVudu88y10VFdXJYuZIfuuwlVvAU26kRvQLSS4l9lbZ1rNNeaE0gOWB
         OkcUnNTupvLacGLkZ049VHLi/ww7QvMsaSIFIuWvnQjxecc7Y+d+cDNZD8qZK2Qsf8j2
         nOJFdZKOQC51DwUSbkYlUqD+tDmd3C4ZZPRK5Crra1ZdOICuF/AoQokDKhmWqAwUDtyv
         7nVLyRycCCsEGXMb9Y8JLkhPTaZQCdhtYBKxqUevK/9cm2JQ6MiXqpeMw65Vm1iklSku
         zF+px+2eeG9on62b2PPevqiNXlSnsAfVSNLJeqFEiu66HF2e+UTtFS5Od6U+0Pd3hVKe
         ZmJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725298830; x=1725903630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qP1BNYF9CvG8P4XyqvF82TLJHMnRmeyjZtDrqbypFNI=;
        b=u7/giTv4mB8+iqQejrlTM3FRRWXYRprIkM0NYCpcaY2yDsSkQRsVuXdA1R93VEwqnW
         throwAkFGtspy6rtypLyWrCAbsZ4SqmA8uSR8MWWKGv9gJ9GNj9M7KNYlMvf8xZGtzbp
         X+/gxZuwBoIqrsS9VBPQuK7LUCmY5m1wGH6LVOWa7/wFit7FrxnjNtvIwPQV4W/jcP/d
         SLLMcMi7TphRi1TmWGGmt3oYZ9lICVv6bHVz2/aYoojinXCaVtngVXXcPdG4b/MMnsK+
         QqX7jzAbypmjgt4r7E8IyBIXfA9PgzIujXhB+DeRMrZF9jGYwrqrCv2PPvBbRGqaMKP8
         aiLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfDR5Go3KbJkb5CYCRijFHAgc+A3ii/OuvCtqXxqQlXQUgKwaveUstKbG6CnYIO3/mw3E3kW7i@lists.linux.dev
X-Gm-Message-State: AOJu0YyssyhxViubcSsTksFKO7Kslo/nHQoSbG9/dOJWOpL4WpyPTW4W
	JHxERcbrOyDAigtlKn0tJHWa2hYPnj6WFM8Y/FUnDn3xohByKQLs1VW6cnSzdSem4NvJLtR0XCV
	0HZoXulPPmpLSXEYnVUtyyKiAI9w=
X-Google-Smtp-Source: AGHT+IEHmqyO7GwRfTbpbFxNAgQ9K9y6/sEieLEBCsDTgql9k346ENF2eMrSw94HNq1V76QYQC+WBYGkoNzAHSYD8YE=
X-Received: by 2002:a17:90b:33c6:b0:2d3:cab7:f1dd with SMTP id
 98e67ed59e1d1-2d86b741b9bmr6540512a91.1.1725298829667; Mon, 02 Sep 2024
 10:40:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240808221138.873750-1-ojeda@kernel.org> <CAH5fLgh9Moq_9M+zMu300ohK=mPqkLyS6cpQ6An2Q3THCPFjaA@mail.gmail.com>
In-Reply-To: <CAH5fLgh9Moq_9M+zMu300ohK=mPqkLyS6cpQ6An2Q3THCPFjaA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 2 Sep 2024 19:40:16 +0200
Message-ID: <CANiq72kUBPnua1Pob++-6SJ8MeGxQMfrePY9SQVd0DZp5VU-2A@mail.gmail.com>
Subject: Re: [PATCH 0/6] kbuild: rust: add `RUSTC_VERSION` and
 reconfig/rebuild support
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2024 at 9:29=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> I tested this together with Rust Binder. I also ran this patchset
> through Android's CI setup to verify that it works in builds with
> CONFIG_RUST disabled. It passes both with and without a Rust compiler
> available to the build system.
>
> Tested-by: Alice Ryhl <aliceryhl@google.com>
>
> I'm happy to rerun these tests for new versions.

Thanks a lot Alice, that is very useful.

I sent v2, in case you have time to give it another go.

Cheers,
Miguel
