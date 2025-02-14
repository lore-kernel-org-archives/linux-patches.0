Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429F439FD9
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 01:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739497159; cv=none; b=e0mu2Lk5/rVGQErZeWR7BN6ESeeLmDffV19w5BS63GpWjCGfPQigbTKk47SJ3jnE9Ts/YTgvcVETscB2AtscF+x3sxvwQczXIlXsLK9iEQSflzLEeCBr+wWt7h/0rENIVh6uCf755pGMjIvkJeXUg9RsURSG5PSjJ3Yq/6a1ahk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739497159; c=relaxed/simple;
	bh=9IxhGYBiqmCXEOQC+SsmBi/iEnbY572YamGs8pAzvaI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nbkEhELlaQ6SZ1aknZwYCFXpwX+oRAgDqTm/HMo3vMdi2UnqNXucLxtgRcVr2bV7hLXdF7omcrD39/A3e8uW6MZhLOUnKOPKQcdQP3t04ldlgtPSUK9vx4vZgJmjISdBAT0B+Gz7O2GivNUXKmQeUu3oOa1x+F+pEgUDA9nHJ5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QCpZJaSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QCpZJaSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAC7C4CEE6
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 01:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739497158;
	bh=9IxhGYBiqmCXEOQC+SsmBi/iEnbY572YamGs8pAzvaI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QCpZJaSMvwlOtPipw6P2cmUd735GYuoTwoZ7oGgyosvm9q5hKR/SP0A5/TSGHCFA+
	 BR0kVj9fAbXBEOmNfXfu+V08GkWLc/YOV/KSr0fXaxAa/WlhEChsxDOYG85kX7Fo11
	 ESawMtQbxeG4MFhh5rm/fegF36JvEBXWBb2Tg+AuuDrzGRtQtuZ0TVuH23pcKt6/2h
	 /2a+2mWeeUp/ifkZWJfWtpPYVEd3JfboIquEElv2t5QIDp8w5zBoSbD2oUzftfRakW
	 cK7tx/mQJGvYTJBmVK/RTGoIhDCESXELHgOVsGk0mcVloBzOlbuikspPotWHdJxPLP
	 u7haketNbg8kQ==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-307bc125e2eso15971481fa.3
        for <patches@lists.linux.dev>; Thu, 13 Feb 2025 17:39:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWQrAzDAXjnmqFQAQHvWHWo1MO6FohIk7lGRx4yEZSDqNJukf9dG5ZnLUuuOTUI6MSBbq/SkfiN@lists.linux.dev
X-Gm-Message-State: AOJu0YxONW4lj9f613/N23gAl6dPo2tSMxtQy+3r60rAOwAwNnEeUK+w
	3kTLPxR4xEuWor9FWcU6UK1XXitNxA/WBsShQhjqceV9Fd0CT54AX8zFVP5H38w0l5m7dlmfqIA
	ZiMyTas6InNbAjyKFclLmahLOYrA=
X-Google-Smtp-Source: AGHT+IGEYz+WkoUrySCxtqr7dpKbi6V2S+88qBoYDexCvVUD02b8yZebnuEPHDd5b4ywaSPaelkedcVjstzog0U1ao8=
X-Received: by 2002:a05:6512:1281:b0:545:ee3:f3be with SMTP id
 2adb3069b0e04-5451dd88faemr1651337e87.10.1739497157461; Thu, 13 Feb 2025
 17:39:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250210164245.282886-1-ojeda@kernel.org>
In-Reply-To: <20250210164245.282886-1-ojeda@kernel.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Fri, 14 Feb 2025 10:38:41 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQBFX5q6yyKBJoxMoD5d9SwdKm0c23J4+LpjwA1eh=bZw@mail.gmail.com>
X-Gm-Features: AWEUYZnI4fpDKGlVQ3nPgTvxchXJzpHlGyUSt2uP8tA04Q4qKsA6VL1SMVCFHCo
Message-ID: <CAK7LNAQBFX5q6yyKBJoxMoD5d9SwdKm0c23J4+LpjwA1eh=bZw@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: add rustc-min-version support function
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-doc@vger.kernel.org, 
	moderated for non-subscribers <linux-arm-kernel@lists.infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2025 at 1:43=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Introduce `rustc-min-version` support function that mimics
> `{gcc,clang}-min-version` ones, following commit 88b61e3bff93
> ("Makefile.compiler: replace cc-ifversion with compiler-specific macros")=
.
>
> In addition, use it in the first use case we have in the kernel (which
> was done independently to minimize the changes needed for the fix).
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> This is based on top of the fix so that the fix remains as simple as
> possible:
>
>     https://lore.kernel.org/rust-for-linux/20250210163732.281786-1-ojeda@=
kernel.org/
>



Do you want me to pick it up to kbuild tree,
or will you take it with my Ack?

If you go with the latter,
Acked-by: Masahiro Yamada <masahiroy@kernel.org>



--=20
Best Regards
Masahiro Yamada
