Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8402A2046A1
	for <patches@lists.linux.dev>; Wed, 12 Feb 2025 09:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739352464; cv=none; b=YG9fJx2UJ4yjbDBvAX97/+GAmmXese3Vje6sx11g06uI2bTlKjdSG2Z4Tj6ok+a0iYUAcWnb2Y1AwBYMwXH0JjNs/wqKD0oaeUpv6w6UKu38HZSOIDg1teaLeBEh8pD9Dvyy6p9SUXxz+j4gpW6SGx2ShVoGG/X94wmlj3ChXWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739352464; c=relaxed/simple;
	bh=B/wuOw3hID9CJP9Am9Ym39ADJx9EIF0zXIaexPlV3eQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=koLOuS5Tr9ZzAyKCTcEz6CJXeTpE5nFadu0J/h6OOXvlT5c4EzsCZCRmNh/GvhcWsdbUBeMGuy1VXfCiXhm+fS1Q8QUeFHnc+kkQaN7gUQmZyz+jNBwZ7nNd/ax6QGpMGxwB1OwK8eSP+5fmckZoPv2uFsrWLmkyyDM7oWTrZ8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yAhCPXnr; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yAhCPXnr"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43956fcd608so7194605e9.3
        for <patches@lists.linux.dev>; Wed, 12 Feb 2025 01:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739352460; x=1739957260; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bc1m1amq8DZ3YHH8BDcjtNrzUYHqM5J0JjXdezkBnZY=;
        b=yAhCPXnrac2nGxb/zUa0FRX1oN3iZOVbK6xuQCRoVnTsZfKRper17L7uYKDEWLFPhz
         tb1AQwc6LSVJp9CAPYFRRmp1StSGjj22FjVT1+YVnM+ezbcy5x4298NT754I1K+ZKc8Z
         jKfKoFQwAFzttSoTz8xDlvPIKwsddB+GQ6naqojKVQ6kWVFmyJj1EwJUZ28YIjeoReG7
         eWMEtAWTevvyVgzW3lFzvedcCT9I6V7xFXp+1ruhDhb6Ca4WbqcHm7BdelfnXCTq42HV
         U1hvJKFx3pJIZ5axB1TS+g7+rSkMeLwRRJvzrvJ1nONiJSr8b7CNRQqXzoPI9XDX2UUz
         VtPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739352460; x=1739957260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bc1m1amq8DZ3YHH8BDcjtNrzUYHqM5J0JjXdezkBnZY=;
        b=hShHo9x4ETFXk1x7Yq6G5izxGdRxPDPTOGhrcCkirjOkWztnbfLuNrQtHf+O5mlGHb
         K1gYDPitKXOcoU4cEibUvX2zjY44kuDtpfMsg2+PJTXpZFg9bm8YIs7NoGQdJK9vPzoy
         DgZeAVFRIkvTpucel/ygiEHCAqIPAyBg/wd44IKDaIvSfEMCuc4pHZ9TdhwMcDRjv2Nl
         P3gmBjxVQPC7H9TAScw525mkcxmTs/1xmRMdBXsmeqK9LmpqnO62G2Vi+alEzATBKZPu
         wg7wY8A5bbSPPk4V44veDq+H7V5W370tseRda7bnm9kqqp5WHa5QQ7wLdiC/R9H9VEG3
         s6hw==
X-Forwarded-Encrypted: i=1; AJvYcCXjhkvc6o8J0wSlabzOTLMJKI9MGrvSx8rszBxX4hj+InHZnbuDaHytujWzB0ttvJJYAsz1flH9@lists.linux.dev
X-Gm-Message-State: AOJu0Yxzs4cqLzaHfeqyZ8gKy+evNG4Vv8z6YYJeFhmrs6ozsjcW97Sb
	l0X1huhg5xneZnffuUEUrBmxWvboea6wim+GevWzMWpaeBVTwBZbs3718qBiyDHe485VVWGKJKL
	zmhWDSSL+1KnzEwmO+xZqbR75ZAIRb1ePEJ6S
X-Gm-Gg: ASbGnctbivBSEvHXpjtrOqP9hE0Dj7dhfMsojIi8RVeFzqtukAo05WwNi5xCxkI/aJF
	N5rfJ7/+bGGGtml7BoiIdJyphvxnmIXpA8+3xcDeUh0k5vCBojFGtXCWoO0nUbQ5p4/OOcTrVVg
	==
X-Google-Smtp-Source: AGHT+IGFvvPcb8mwE7p42LVWeaeA+rWLPBy/3/tBPUkRHCkxCRjbs9fMbGYAzeixSBWbbJDbiF4tjdlW10GZogWG+oo=
X-Received: by 2002:a05:600c:1d14:b0:439:5516:dad1 with SMTP id
 5b1f17b1804b1-439581b76e6mr21779605e9.23.1739352460098; Wed, 12 Feb 2025
 01:27:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250210163732.281786-1-ojeda@kernel.org>
In-Reply-To: <20250210163732.281786-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 12 Feb 2025 10:27:26 +0100
X-Gm-Features: AWEUYZkYetDDLcmE6nDR_-R5xfXvCqjqr2MixcJqSNgrzdBxocsoOKPAtwlLknE
Message-ID: <CAH5fLggGLbL+oTfOPjtCvw1cTLzJU6e+dmZoF1uy1QVTtRq3yQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: rust: clean Rust 1.85.0 warning using softfloat target
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, 
	moderated for non-subscribers <linux-arm-kernel@lists.infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Matthew Maurer <mmaurer@google.com>, Ralf Jung <post@ralfj.de>, 
	Jubilee Young <workingjubilee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 10, 2025 at 5:38=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Starting with Rust 1.85.0 (to be released 2025-02-20), `rustc` warns
> [1] about disabling neon in the aarch64 hardfloat target:
>
>     warning: target feature `neon` cannot be toggled with
>              `-Ctarget-feature`: unsound on hard-float targets
>              because it changes float ABI
>       |
>       =3D note: this was previously accepted by the compiler but
>               is being phased out; it will become a hard error
>               in a future release!
>       =3D note: for more information, see issue #116344
>               <https://github.com/rust-lang/rust/issues/116344>
>
> Thus, instead, use the softfloat target instead.
>
> While trying it out, I found that the kernel sanitizers were not enabled
> for that built-in target [2]. Upstream Rust agreed to backport
> the enablement for the current beta so that it is ready for
> the 1.85.0 release [3] -- thanks!
>
> However, that still means that before Rust 1.85.0, we cannot switch
> since sanitizers could be in use. Thus conditionally do so.
>
> Cc: <stable@vger.kernel.org> # Needed in 6.12.y and 6.13.y only (Rust is =
pinned in older LTSs).
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Matthew Maurer <mmaurer@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: Ralf Jung <post@ralfj.de>
> Cc: Jubilee Young <workingjubilee@gmail.com>
> Link: https://github.com/rust-lang/rust/pull/133417 [1]
> Link: https://rust-lang.zulipchat.com/#narrow/channel/131828-t-compiler/t=
opic/arm64.20neon.20.60-Ctarget-feature.60.20warning/near/495358442 [2]
> Link: https://github.com/rust-lang/rust/pull/135905 [3]
> Link: https://github.com/rust-lang/rust/issues/116344
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Thanks Matt for boot-testing it.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
