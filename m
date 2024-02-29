Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE4016FF2B
	for <patches@lists.linux.dev>; Thu, 29 Feb 2024 21:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709242413; cv=none; b=B+8aMFX8ulIwgRD7l/rRA9xMqjU2s0r/Mv0/OnOzGwN78HtWFL83L2v7A2ZnUH0ZDI44wVTyx69PjfhSKFdWCGb7roggm9fiXEyrGtCBPSJjqe7ju4BmnHSN/yep1mSTGugkDSfocp1KSGnr3iWKXCK5R7wMJZBVXvgK8bmaWdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709242413; c=relaxed/simple;
	bh=BnJoVXU1CaeQbXBgRnIHjar/FV4NrO1c9oIQRiWiPpU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oRmnQ8rRwLuKPMGiRM5Lh174bp6kZOK5KPCETdzXSeGVK4wIHcRjNK2ti1YhAwYfLS8tsdTaokYOUzhSoHD2JA6+qJvhseMIV2pU6jOfjKB4NsWbzsvMRL43B8rp9DhklOQpM9fIEpstoC+DVTwSNka1xMb3visERnJU1AHHeT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bgiRNYxU; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bgiRNYxU"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2998950e951so982050a91.2
        for <patches@lists.linux.dev>; Thu, 29 Feb 2024 13:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709242411; x=1709847211; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BnJoVXU1CaeQbXBgRnIHjar/FV4NrO1c9oIQRiWiPpU=;
        b=bgiRNYxUemHwycHcD528wPdSHVVuWVLlYqj26+wyj35wDG/ZpxYCYO2NlMQ33cseSo
         i16COCOOkEoswEOZiQsVGREtFjTBWxyzm8bfNbN/Jd2+ZA+uvBuZ2w3Iuc+1feeOHjHB
         YHBEFfw3q+BmqY0cHiwWRnSOBVhNawtuLF+5zABIpeSWhmKCrTTIUnPTT+KWAjR1EYyZ
         /TzghlNmSyIC0tUiQoYigkMPAYdQStuSQFQrN6UGfQlGmX9+8erM1TMlquYCOLrOFSsK
         hprFjWyWljk1S5t3EfdzAWKApc0P1j/V5cOCQIyGj3rHw2qZ4SDVWwd1Xf0XneOQCxCt
         M4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709242411; x=1709847211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BnJoVXU1CaeQbXBgRnIHjar/FV4NrO1c9oIQRiWiPpU=;
        b=Wn2O/ymEB93K1O+aVRp/5t9IlX5KsJ3Sebfr9UZtZiACzYX+9mOixZeXYmetmFOEWD
         lve7J4r1SN+PWK8RfgfjFXqS7A74g9fnaKYMyBCjDcF/w6J8GwbbG6N5IHt5KIP3/PjC
         uwP/ICb+QduR9jqrxA+VVWDO9qjzJSpFVFh5Z9pNTBmn8ar7MFOMC3sjcbB5IrjRcov3
         sWYqv59QxBThs029FkSbV+J7VjZuodhrQgOB6tgtvH98MhdQR3midrXrbidTdxEvCnXR
         eeH/74xZg5vGaQy8wEI5aKurFAywQjMSgKeWzGNAmm8JhtTYXaybJI49/9i2cng0KarW
         LSPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuqJ8b+8OV/a8OjDOcRZSfDViKvwfM23tagVVmbqnhETCwb1ymZpkEH8ci/zMtym1b5eBXMXBxyVZTMcsPJfyNN9QxznAmDA==
X-Gm-Message-State: AOJu0Yxdv9GkGFbPUDSeiuOE1uLCE2WZ6Jez71J0qwfo6TjIs3zbrHyP
	EblxBcu23v4hDzgXzVaaIQvnFEW8dtGHpS0M8Is9G/eeKqRf6MDH+1QVKOmi/VF66XQeXkpmzeu
	oBrR4tOFSnZRce+HIVUfy5JS00Dw=
X-Google-Smtp-Source: AGHT+IF7bVmqxeMhoRHyZpvokOgbCs4iWKcEFiGPNztP7CIoyae8cJUfmp8uTM3OBZKV4OvFKxKIP+IJE5Ov5jLH6Xw=
X-Received: by 2002:a17:90b:104b:b0:29a:cbfb:5b28 with SMTP id
 gq11-20020a17090b104b00b0029acbfb5b28mr300141pjb.13.1709242411118; Thu, 29
 Feb 2024 13:33:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240217002638.57373-1-ojeda@kernel.org>
In-Reply-To: <20240217002638.57373-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 29 Feb 2024 22:33:18 +0100
Message-ID: <CANiq72nPiVDV2WY_jCuONz_arWRVyMMiRT5iVb=2xqoXnZYW+g@mail.gmail.com>
Subject: Re: [PATCH 1/2] kbuild: mark `rustc` (and others) invocations as recursive
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	linux-kbuild@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 17, 2024 at 1:26=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> `rustc` (like Cargo) may take advantage of the jobserver at any time
> (e.g. for backend parallelism, or eventually frontend too). In the kernel=
,
> we call `rustc` with `-Ccodegen-units=3D1` (and `-Zthreads` is 1 so far),
> so we do not expect parallelism. However, in the upcoming Rust 1.76.0, a
> warning is emitted by `rustc` when it cannot connect to the jobserver it
> was passed (in many cases, but not all: compiling and `--print sysroot`
> do, but `--version` does not). And given GNU Make always passes
> the jobserver in the environment variable (even when a line is deemed
> non-recursive), `rustc` will end up complaining about it (in particular
> in Make 4.3 where there is only the simple pipe jobserver style).
>
> One solution is to remove the jobserver from `MAKEFLAGS`. However, we
> can mark the lines with calls to `rustc` (and Cargo) as recursive, which
> looks simpler. This is what is now documented and recommended by `rustc`
> and allows us to be ready for the time we may use parallelism inside
> `rustc` (potentially now, if a user passes `-Zthreads`). Thus do so.
>
> Similarly, do the same for `rustdoc` and `cargo` calls.
>
> Finally, there is one case that the solution does not cover, which is the
> `$(shell ...)` call we have. Thus, for that one, set an empty `MAKEFLAGS`
> environment variable.
>
> Link: https://github.com/rust-lang/rust/issues/120515
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied (i.e. including the upgrade to 1.76.0) to `rust-next` --
thanks everyone!

[ Reworded to add link to PR documenting the recommendation. ]

Cheers,
Miguel
