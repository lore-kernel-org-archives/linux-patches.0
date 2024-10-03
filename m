Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0E46F06A
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 21:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727992324; cv=none; b=kp5D20ngMHw5sbGRo4fiYfMSrZ7s/bD1JnCFsiTRr4teWXX8b3fid/2YCXjPgp1Gvs00z3/PhVSuPiPy1jc6d5F8i/k8gEkLLa28D3uiqJNLrINzYLCWGm56gd2f6evhorJbSWudCFbeFtnuT30TwqoIk5h69lMl4AJD8z8oEeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727992324; c=relaxed/simple;
	bh=Qkgylb9eQTwPDhGkklvlART8vOuDVtTpvqJn4T8hEuc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OM55M2Rjo+kWEYwMsivxNVWTLUEYsm9Cb9PtdCdo7DMB/AmawhYTftweCRP1fJ0a/nUvEROmwrLflBymplP9G2DOV/84LabBrYne25yz7rM7RDbkFsQc1r4PF4dEU9OwhOm+bsIOjN+UIrIXjW4v1B4k/LQRS64wT/qGt/H/4QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KqBoN2gk; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KqBoN2gk"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-718e0421143so257310b3a.0
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 14:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727992322; x=1728597122; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j1ocYpbXaC5mU/aFXMsvBK/itd7YFUGOalmomO/3cJs=;
        b=KqBoN2gka9jW/nCrbM0yfIUeCn2CwmhB0x2Q2fxRBaqZOHdJ8KvO0jjGCvdrSzxkWK
         UHYf7IO86TZZZl1sX0M2iNAG9TbJv8oo5s4jpoM1gU4hVdCJVUc0+sccw5/oZTL7Qplq
         Lt7TSi1M2JnZ5E8xIFUTpua+lWJZtZ7KFnJJ70K1Cf7b9e/GHOeVExH4K7Q4DjRvQUwO
         BYmxFZM5z2yWBY/IxTgkaDLY5Hi59OkFA3dvRiWjj4zGHLPE9oAddaCO3vCwYh+Hw/IE
         Jitt7X3GAlLYqXwmhYJtk8GznqkexZmjA3S9jNJeHDWals0LejmZyskAYdUP3d6zWz37
         TmJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727992322; x=1728597122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j1ocYpbXaC5mU/aFXMsvBK/itd7YFUGOalmomO/3cJs=;
        b=R47YhUklYDwiWN3SgqQIFgfKzpNmQEege8qNm4ZV8OACuAJa1A94HSgefKSXTEptFY
         seAFaPuJntn/za9qnl1nb9qbx/UMUI++1O0BEMbSeGq2aZIwtlzDJGaYmPcQs5zaCPve
         uO2bTIK0/7zU5TCz5wWkRePDLzThFFEhFduz6SVouADQWQX8+LZtxHuEoXV4O/wJEnbu
         UAzrmLGOMzJYlu0ekfct8I2zNOcG3RyzBntEcDNpOzlcd1E3RpPJhOLgYf1/bWdot+gX
         dci9Yk8EzXNLc1fBsRNLTST7Irwf2eGXzHVF+UaEU4Han8le196/ANNsqug9W5Jk8cbu
         V+Wg==
X-Forwarded-Encrypted: i=1; AJvYcCWMh5BXSSoFGmSUO8bcf6l1K5msWOXaErWnM47dznpJCznFsW0MRCusKKqttQGUoYw1HWIYqSCO@lists.linux.dev
X-Gm-Message-State: AOJu0YwPm2TOM967p8QDsgqE1r9CW7enX6Jw+aDSYci+o8x8zP5dfS8L
	4Ui/G+8vHMdyM3Jf0NyZxXEjgsQWMJXTtJqcAVsgT5j9qLnOIeiQdAPMVN+Y16ZHw0gkY/b119b
	2GVKfvIndhaulB9dVhSfVy3fFY/4=
X-Google-Smtp-Source: AGHT+IHTh3t5d79tqkJbOqxEb5kcbUgEmnwOVGF1GZDA1wqj2rKreT3LCSAdvi67msvAAPCh9G8GXqYnPiYwwYJIwPE=
X-Received: by 2002:a05:6a00:464e:b0:70b:705f:8c5d with SMTP id
 d2e1a72fcca58-71de2446c96mr317654b3a.4.1727992321935; Thu, 03 Oct 2024
 14:52:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 3 Oct 2024 23:51:50 +0200
Message-ID: <CANiq72m36NBNaSLL2phtFPKL3CYdamSOzd-e2t3imP3nY9ed0Q@mail.gmail.com>
Subject: Re: [PATCH 00/19] rust: lint improvements
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 10:44=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Hi all,
>
> This is a series that contains a series of lint-related things:
>
>   - Cleanups and other improvements and fixes, including removing `allow`=
s that
>     are not needed anymore for different reasons and a workaround for
>     `dbg_macro` detection.
>
>   - The enablement of some safety lints so that the toolchain enforces th=
at we
>     write `// SAFETY` comments and `# Safety` sections properly.
>
>   - The addition of `.clippy.toml`, which allows us to take advantage of =
a few
>     configuration options.
>
>   - Start using the new `#[expect(...)]` feature and add documentation on=
 it as
>     well as lints in general.
>
> Overall, this should improve the quality of the code and documentation as=
 well
> as reduce the time needed in reviews.
>
> I want to mention Trevor's nice work on lints from a while ago [1]. I thi=
nk we
> should still do something like that: discuss which lints we would like to=
 have
> one-by-one and start enabling them (and perhaps have a file like Trevor p=
roposed
> etc.).
>
> For the moment, though, I am sending these, since we would like to have a=
t least
> the safety-related ones enabled soon [2]: now that more code and develope=
rs
> are joining, it sounds like a good time to start enforcing it -- it shoul=
d make
> new Rust kernel developers aware of the need of writing them, which has p=
roven
> to be a common request from reviewers.
>
> If needed, the series can be applied partially or split, but most of it s=
hould
> be fairly uncontroversial.
>
> Link: https://github.com/Rust-for-Linux/linux/pull/1025 [1]
> Link: https://lore.kernel.org/rust-for-linux/CD29DF8F-7FF3-466F-9724-BC92=
C14A68BD@collabora.com/ [2]

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
