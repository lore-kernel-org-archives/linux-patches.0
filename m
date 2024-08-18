Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56119154C14
	for <patches@lists.linux.dev>; Sun, 18 Aug 2024 21:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724016854; cv=none; b=kCpjBWB7JmW44xLYDPBF5doeNh9imASZxhto7rqWeq7KIsh79UZVAZzkODiyjFDyxnbBRUo1ZF5S5Dnf1DNu5rl8wn2XCn0nd6Oh//9jn42LnX7KDSfF6YmXJkov/Jei3PESCA5zd958tmRqXgYIjWcSl+9QRyoHBa+8M3ADRQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724016854; c=relaxed/simple;
	bh=co0ZFxYWxEgyO/etORsMhQApUZ9masoa0CJYA7UyUFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FrH9QHvX2UH+sG1396RfqYTFqsxwyPt0OAcgkklPqXHz+nMKZFdTq6GfLPbTkhqCF10oXtWNBPmkSgzOZYbjVEmbLHBRwBNht2tS8RmN+4aPtIuEDYUGTC6q0OOM99JWhCVTu0l/8KA96s4AKZiIbwvJ5SRvKfMfoYFa0r2q1RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I0a3Oz53; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I0a3Oz53"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-710d0995e21so2667794b3a.1
        for <patches@lists.linux.dev>; Sun, 18 Aug 2024 14:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724016853; x=1724621653; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8xB9N2CyUP/tubBRh3HVqclY1aMiqp9wGW1/E9J9qt0=;
        b=I0a3Oz53F6GapeKgEvLv+6Y+TT4wZrzL8tLtOnzqLIRAScxfFJu+GuY909WCpF5c6p
         kj7CFrQxIFD218GiFU/OdlGXWfIg9YA6CsPJTZUWO686qW6tWXW7RlsUoiITF9jWZvdz
         ACvTwsxgxi0t6waZIuQVX8X+waSknD0xW19CeLHOTwmF57lh409JBimJzM3+E3kK+jIj
         +sagsZNEpnKMKfzrOsV7bPbnHZBJGkncTqYr8QqBeV25E/BiJJsr7CR9jcYatGY9avSt
         dwbv3PRz35KvYErPTP5YR96dxiumqxJYz81Ripq2KugfML2gHcGiS9I159PoCQRJBr5a
         bq2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724016853; x=1724621653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8xB9N2CyUP/tubBRh3HVqclY1aMiqp9wGW1/E9J9qt0=;
        b=CCmZhEiJR3883DBuuGxvUz32CPgzuCT1dJqwsLYWGVoUw99PbUEoM4lnE987+XfqiZ
         ba/vvkAOfyBbZSN94oxwM++D+1FgO2sVAmxs3G9R5SKYzcr/xRBYuSGVuWvdsG4Ziazz
         OnbcrjvYL6CC6mOq+vWShIno7brmt7U9AMNfObE72g4oB91U2qzgsk1bPMdT9c21PLHx
         7mm8CHmKuIfPZjTu+OOXT90c23zyJ9hANpWyzd7felQE9ns1KSWLAoyd39Fp3qtyN5sq
         NpvvXDIHRefNPPpq8xIBxd96cviIEScu/oIxIJtj5d04Lc/H7mW51qq8wxSWqSHYik6U
         83Mw==
X-Forwarded-Encrypted: i=1; AJvYcCXdC6IHNvl4ymNj1kuTh/HqE33drsz4CFMtvifAdUypOyd8NDlSGVodAljm8FeFLiE4UOWIHP826hxN1/UQBZE80ALQm3lKYg==
X-Gm-Message-State: AOJu0YxBf3SOmrlEB4C9M+pyiAzIdyj7pBehyu4kzKDwH3mXKIW/OhWf
	fi/aQcMEhtDsqJCpwHnl1uLM+Q+EepXwSVtTfcK1WeoRU9yH+bzRIGOEkPH9lZ9bWLlceFILH8E
	/m/b/vjYR3Vjjj1r9W2n9+IDXkKVSahKQ
X-Google-Smtp-Source: AGHT+IE2oB/OF35u00ICOXXfqe7uDqKEOVBsN3Q+lxAijVdFjL04veni/mfqZNesLIhpDWgJ77HfYSdRLvo4mJfnTb4=
X-Received: by 2002:a05:6a00:1404:b0:70d:262e:7279 with SMTP id
 d2e1a72fcca58-713c4dfbb8cmr9273590b3a.3.1724016852546; Sun, 18 Aug 2024
 14:34:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240725183325.122827-1-ojeda@kernel.org>
In-Reply-To: <20240725183325.122827-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 18 Aug 2024 23:34:00 +0200
Message-ID: <CANiq72mCuPNK4ZRDvvpCz1_=OfSU+ek=ami1auypbnehcfruuQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] Rust: support `CPU_MITIGATIONS` and enable `objtool`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Masahiro Yamada <masahiroy@kernel.org>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2024 at 8:35=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Miguel Ojeda (6):
>   rust: module: add static pointer to `{init,cleanup}_module()`
>   x86/rust: support MITIGATION_RETPOLINE
>   x86/rust: support MITIGATION_RETHUNK
>   x86/rust: support MITIGATION_SLS
>   objtool/rust: list `noreturn` Rust functions
>   objtool/kbuild/rust: enable objtool for Rust
>
>  arch/x86/Makefile               |  7 ++++-
>  rust/Makefile                   | 22 +++++++++------
>  rust/macros/module.rs           | 12 +++++++++
>  scripts/Makefile.build          |  9 +++++--
>  scripts/generate_rust_target.rs | 15 +++++++++++
>  tools/objtool/check.c           | 48 ++++++++++++++++++++++++++++++++-
>  tools/objtool/noreturns.h       |  2 ++
>  7 files changed, 103 insertions(+), 12 deletions(-)

Applied to `rust-next` -- thanks everyone!

In the `noreturn` patch:

    [ Kees agrees this should be automated and Peter says:

        So it would be fairly simple to make objtool consume a magic sectio=
n
        emitted by the compiler.. I think we've asked the compiler folks
        for that at some point even, but I don't have clear recollections.

      We will ask upstream Rust about it. And if they agree, then perhaps
      we can get Clang/GCC to implement something similar too -- for this
      sort of thing we can take advantage of the shorter cycles of `rustc`
      as well as their unstable features concept to experiment.

      Gary proposed using DWARF (though it would need to be available), and
      wrote a proof of concept script using the `object` and `gimli` crates=
:
      https://gist.github.com/nbdd0121/449692570622c2f46a29ad9f47c3379a

        - Miguel ]

    [ Added `len_mismatch_fail` symbol for new `kernel` crate code merged
      since then as well as 3 more `core::panicking` symbols that appear
      in `RUST_DEBUG_ASSERTIONS=3Dy` builds.  - Miguel ]

Cheers,
Miguel
