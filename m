Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF5319F40A
	for <patches@lists.linux.dev>; Mon, 28 Jul 2025 06:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753682813; cv=none; b=j4chR4ksBHFqlqtSyC8t/V9H6NzRMwF6IW+v8pyJ5KAaB2+LuiQzTlNO26F0RaU/cjB/oAeBXAC0pMEzHEeL8JLclPivIuLGSmgXMTxtdjR+5O5HtYRCxRgJ2iMmAVoN36z0tmOsKI8Z0VmK08iTm4Mp4BdBqeBiY7NZLAeT8MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753682813; c=relaxed/simple;
	bh=6BuxxmxrMXuD+syryXFAu4e7ozMwiP9HtTVrGgSqrTA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILKqKQBSmSwsLXLSB0pfNWjjyDgjR0K/nOPT3r0q09l3s5KVABWBRtXmxsg8RQnWN6y671gs2r9kLl3Dm9CJKj3uZUpJECIwyK2LYZrU3N4P3Ik218KttfbIrlbf2/Q0hXB4hNeGUd1jgp3x1o3p0YULtw+1/mxwvdqm5MOTOGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OyQz+ywy; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OyQz+ywy"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2369da67bacso1573125ad.3
        for <patches@lists.linux.dev>; Sun, 27 Jul 2025 23:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753682811; x=1754287611; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6BuxxmxrMXuD+syryXFAu4e7ozMwiP9HtTVrGgSqrTA=;
        b=OyQz+ywyM6m4LOisKo4v7fsDw4wDO/4qOyld7wVjUcYJgolO31yq3lRzijTEdAY8xP
         OlND7Q07/chA2KCgv23u6aqNZCePgunaPllwLduEQur9Q0wGDfU5lzntXrnnyIJ1u3K8
         j4lxlQlwdEJ03JYkvxHzUkmKp2PfQNQpyyMmimzFyNhljKGFMGQ/gRqGUCnxVvHsfxPw
         NnYqca0pFKZE7miYzFY08ReAWZPMpBQahhXUra4LZ2BYeV1tkIGPOrzednsi3O3pTPD/
         fn0dvhwMA1ygHm2Fp85SNj6VunWnkVUEiWZUxtZU3qM8SMj+xX5vQUy6uFuzK40ZIzZi
         eCzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753682811; x=1754287611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6BuxxmxrMXuD+syryXFAu4e7ozMwiP9HtTVrGgSqrTA=;
        b=pih8a1DKZVkvqvdQBXZPRte3PhcHifQhmHIrPwWPHauoNr0tZa/NQh9wjC9jU7dpAP
         mE+X0PXKzlnKGtg/P5TXPrP5t/HpVwmgB2o0rmSd1GnUknGYaW1zvXFR5d3ag1O0XWEH
         EtW1lUyganL6Y0Jn9ygsdPjbQGBG8ywmGNmP3I4ZpEQ4GLI6w54PBeKeZnt/pwUHNUWi
         K2IiqZI+JSDQ58IMpdefPWrrvWL6UMRMiyTb3pgv2FUunFKYYs9RC8FAhqungm9f3jxq
         Lu4lHkyaUeIzqGG8PyQObQwP8Wl8+BV8u5gO3F4K6kPWBST84f5zYDS+Ug1OiMZxdyGh
         x0/w==
X-Forwarded-Encrypted: i=1; AJvYcCUhzLD/WQY7hNtMKzEdKctQkMEHq8Uly68BOxrddN5EJdEBqb9ryLqQ2ZhUyt7IGgITZCZkCotB@lists.linux.dev
X-Gm-Message-State: AOJu0YwFx8bYlGLRYuW4N4hpYRA+aE46kfUOeMv6LL1R8XfnNDfCKCK+
	bfLde86moyCHNfxP9G6EuOg5JPETQF87u+Rsml8qkSw0EzEVaR6f+TfUAwvhXM6hwknk9tjpYd+
	0Eetg9ySATd7uAIsOzqhnBqSYdLSyofo=
X-Gm-Gg: ASbGncvoytQzPj+RJaxHEJ+vM14qT7i0gy3qyWNCxgadcbg+eFMk6HPSmypJkOdZtTY
	9ka2xJHDsGrrknYQt53euzv3XgEw1NT0A55h/4rXeKc3gFsIdw/W/Kflt2hVkzxWzDWUpEzaHL7
	8xgiTNcYIWFEO5TRtXR6JoREDOUalT9oKsULDDXmlvJacbABE86yeCgDOAauEF3axXRqrV0jUhi
	gKxK3YM
X-Google-Smtp-Source: AGHT+IHdhVmKZwChbSTO0ZEh7G/lQCCa1ZWLqXuMsDUl5T7xo9Vns0QP4cG8ipR9HWfcbqvofCO6RnASD0hnrFNm+xE=
X-Received: by 2002:a17:902:e751:b0:240:cb:97bd with SMTP id
 d9443c01a7336-24000cb9c7amr23866415ad.7.1753682811331; Sun, 27 Jul 2025
 23:06:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250727092317.2930617-1-ojeda@kernel.org>
In-Reply-To: <20250727092317.2930617-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 28 Jul 2025 08:06:38 +0200
X-Gm-Features: Ac12FXx2eH1NIUNOlaMWd3xqdYk4d5QjO6acLe_IbBpmXiVXK0DqqgtW8QrHL5k
Message-ID: <CANiq72kYpHzp8ydtkfdb7FN+YjfFNjpSqtgC0Hm1tSy05p4n4A@mail.gmail.com>
Subject: Re: [PATCH] rust: workaround `rustdoc` target modifiers bug
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
	Guillaume Gomez <guillaume1.gomez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 27, 2025 at 11:23=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> The issue has been reported upstream [1] and a fix has been submitted
> [2], including a test similar to the kernel case.

This is now fixed upstream (thanks Guillaume for the quick review), so
it will be fixed in Rust 1.90.0 (expected 2025-09-18).

Cheers,
Miguel
