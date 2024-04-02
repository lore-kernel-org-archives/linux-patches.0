Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC84558203
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 09:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712051332; cv=none; b=Z//IN06wDc4BIXzRQt4tQTf9rfyZEmvxP/PAv7jA/wyNNg5p0+Ob6zKMqKwuSxRdMOVDFAJsbi8Gyh/OgQS3Wj+PPup3zsuRnWcVcxFKdipPAzDRIp2fhy0qURbez8142ZEJynGpLaUgWQ2e6+Ybzwzu7cmEZRcg3rK+x2A+vRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712051332; c=relaxed/simple;
	bh=/6opIaW565ST1SlftEf3TIDZp0a8kcSv8D9Tuf8A6MA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bekg89+I00ishBXHLqOEzxXdvTgyRngQDGfqdEYqUie1aQBqq5YZx6gdXZLxsztepwOQxfRjBjGnnNB1gjZZpUQs9ZJ0K0xHQ7G0t72mMZ0bAhkgUQJJEaz+H25BK+MxKTwJlIYOCAnHCbN+li1ZXv6syjY06fkZKYxXIQbn+8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BPcFR8Jo; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BPcFR8Jo"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-7e096ab9287so1725601241.2
        for <patches@lists.linux.dev>; Tue, 02 Apr 2024 02:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712051329; x=1712656129; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A4P9MrH43tW9abxwsM09/mfJ8gZJX942gU6DHzH5JkI=;
        b=BPcFR8JoCHAy4yeYhzYEojjVALwIhdR/TQXtQpDtCyNEEGIoSYeTUcYLdWr+T70ba/
         ochd+LsPNaAgqDE2Iugj6VRpemSvCSfQ5B6qw/uI5RTPGAjk9lq40ocGNEOOUxpuoh5s
         TRCzAyF3CbFOuTxRu8f2zEld3RTFRB1TauYYKSqFmlZlCjIsMuKhTgIp3q4gHguzuYLc
         LS+YPpznfpaB99GtGDfxfNuPRKabs8m8tePf43fSdxxO8vyaJUKLXpE5oVCKu9ULSCYa
         oZvhKr1fSBETxbtPrP7cRbWa9OGpjRMhNQzEMHqJDJ6jc0nDZLLlZQ7AfWXgibZEG4hi
         vhew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712051329; x=1712656129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A4P9MrH43tW9abxwsM09/mfJ8gZJX942gU6DHzH5JkI=;
        b=KAKKy/IEDlhjCAW1LlR1zwispNrmJuadXZvHT6sqU8/gpvt7BBNgY6m2QiM4NdutF9
         MikZucN23jT6SLyhUQILcYjh36LXNinFQxx15DA2+UjT79b45scKAaURbwcEQzV9S/Uw
         fMwz9khdNz9UKeRrpAOQriqjjC+3tDGXfA4+iS6ZhSl9j5Zwrw+Gll6bj5AGYg8jn7tA
         Se+9DQwm8zMyW1NJ41QYEheuzm08obpMHThHXSxj3kBvuU4y+InBUG0QjhOirb2ChDXi
         9vK4elLYohEuibxcelqQzJfeXjYcz9FtfsJO3ECf9a2g7WyOmV6DQQ9txvnomcBS9snP
         n+sg==
X-Forwarded-Encrypted: i=1; AJvYcCUh1h2MBrllizhrrmTlcxPQthbECv4bWV/DTqdZ8rOlzfQbWtNSHpIIW7sBq46QCk1iE5xsekI7+qSBrqqsFBvFvkxZcmH7OQ==
X-Gm-Message-State: AOJu0Yz45n0rHDuFot2Ea8d8bYK8XGhznpDVEwjZtjndIk85G7Vi4O/g
	c/snUfgiWRusCptd+hCJT3kc/es7vf0hDzIbswHHB81IhVbMoHY9qKt+JEU3VWNLOWTt9XUHrdn
	WXtqDV+7M3yfTLO1JdlzuHPsIX0omkU3hVxhn
X-Google-Smtp-Source: AGHT+IEuI/3Rm82F2eFCVLgg9j5UIQnVXaNnxGLIK9710lNnknOhJaLAXY9bxHdptvhHHGoFFNiYjlFvjJefD/9iG+Y=
X-Received: by 2002:a05:6102:2172:b0:478:618e:f0c8 with SMTP id
 i18-20020a056102217200b00478618ef0c8mr6431208vsg.11.1712051329606; Tue, 02
 Apr 2024 02:48:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401212303.537355-1-ojeda@kernel.org> <20240401212303.537355-3-ojeda@kernel.org>
In-Reply-To: <20240401212303.537355-3-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 2 Apr 2024 11:48:39 +0200
Message-ID: <CAH5fLgjS5NeXHTqqgcb5nhC9XZ1qSzh5tWD+fvNUf93_PNGWdg@mail.gmail.com>
Subject: Re: [PATCH 2/3] rust: kernel: remove redundant imports
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 1, 2024 at 11:23=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Rust's `unused_imports` lint covers both unused and redundant imports.
> In the upcoming 1.78.0, the lint detects more cases of redundant imports
> [1], e.g.:
>
>     error: the item `bindings` is imported redundantly
>       --> rust/kernel/print.rs:38:9
>        |
>     38 |     use crate::bindings;
>        |         ^^^^^^^^^^^^^^^ the item `bindings` is already defined b=
y prelude
>
> Most cases are `use crate::bindings`, plus a few other items like `Box`.
> Thus clean them up.
>
> Note that, in the `bindings` case, the message "defined by prelude"
> above means the extern prelude, i.e. the `--extern` flags we pass.
>
> Link: https://github.com/rust-lang/rust/pull/117772 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
