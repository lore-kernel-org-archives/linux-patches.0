Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D807E197A7E
	for <patches@lists.linux.dev>; Thu, 25 Jul 2024 09:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721900623; cv=none; b=rPm8/CXDoqU8bk5COod58gqgqfLwNDcW7rrBfxB+6dR1YC7AAsntYcPR5pEgw/D16Ck2YC9nw6l/dI2p51WTGiQyXCdZGRnD4LGQhT/gMOCpJPjS29pxra9X+VmGBlzAm3o+IByPri9Hc7h6TVeYGmMLWWWjlDiKaIKgnh9gwho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721900623; c=relaxed/simple;
	bh=OfRkrMGGgNibJB9z9Co5Oyh5Kyaj4J7TqHXMn4wIC+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aqHLZ7JT27+GeRejUIxfji8xG4aXHPdJwEgMxmxEMn/BZys6JaVdy40FbtTbVZjfUzs4/cIyaaiKUR1Iayw/A2SV7wx9a2FxBPqUEHFeoKht8Bf6pqK8vyY1FDghDjj76fWPAzd8i+xpa54S/JiW7mozeNXvYkkZClDEfXoIjN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EqcymnPB; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EqcymnPB"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-428035c0bb2so4170735e9.1
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 02:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721900620; x=1722505420; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=084GPfdeuP46Jz6Dyrdsi8DzZT3jnbvpNucHJZ1TuaA=;
        b=EqcymnPB84VUiuzngFqmumou1Wj/ra5B6KeOIUlLLj8MXjlepmlVsdjuWf4ZGR9nlX
         TIZt80ErRnr5TKAk8jl0jGvACL2BfZuqK8vyaXQfLRAn6dYv3TC6jONRHZNBC9/4ZWvz
         qBUKRhMlqRKKt5K6YTCGXHTCYI6Wp7h42WmhKMT0rNqQCnapOBALnzTcZtZ4IsuHUbd7
         l5T2hnk4/xFuyIP6oZOOmK8Ti4gAVBOwFBEZjsNywLTQfW65s2F6/2rbXkjWEN/Z5ZKM
         mQY4N8pKkMAMYmfykVfcu3EiEmb2xg4pavoK7vGu8/aYiemnBmFJ+7KBcAxAy/LalG0r
         reIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721900620; x=1722505420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=084GPfdeuP46Jz6Dyrdsi8DzZT3jnbvpNucHJZ1TuaA=;
        b=j1FL3j2R3SGtsmBGzTqtbPtvL0cytup9EE40ixl0pSdGOuC3awVuc0j8LscQibLlCS
         U0HLh+k6QNsLPiVfnpj22O8GhLzwxElj6eSe7Poy/ELdscbku8QCVb6zeW3wvF1FNtjU
         oqQHrYctOQG2S05I0DozUiUDhNot3bqDZf4nuwlc7T4dzWKi7qUO8pDc7UjgRQYzXqgd
         vTiY7p/G7nUXpfJXFmPb7Zl4ehWHu/PJaU4sECAGWI2zqs7AGabt46s7NwyFcjZw+A5B
         2JB7Dq+3aF4XhyO9Pr+X7Pe3HP0IF3AuwcJUdhZyjrmwiQx0BprMFo3Z1ak/F9fEDfMw
         HniQ==
X-Forwarded-Encrypted: i=1; AJvYcCULnHUAB7P+oIOt9N4C4IDJaIKLV6EBeBOs6n3Ud6+W6Pg7+n/0DFavZ+NPkpoP2Ak3jHPrtl1xSzfYrwCpkWGjiwwcGJWYvA==
X-Gm-Message-State: AOJu0YxyOlbT1Ox7V9l2SSxWVryKrmJQD96OjVhNqWkSBZ3Tg+h9CDwz
	V9ZR/5xAViJKFy8TacyIWbmEdjE5vdn2ZHciKTnYqITij4Lkfddpi93te2Al3dwuP5P9J3+gIjc
	AEWUnQ+A5Gen84GsEZ1wWUZPdfnKTULV2K9c+
X-Google-Smtp-Source: AGHT+IE6X14IZDQ5Pvi0EHuAL+bLPA+DtdyDVXsBLCAhdXaKVx0/zepn3uPZTG5qlk+pSFE1iO35aByaX/zvkbfjpw4=
X-Received: by 2002:a05:6000:b81:b0:360:8c88:ab82 with SMTP id
 ffacd0b85a97d-36b31baa2d5mr1493373f8f.30.1721900619824; Thu, 25 Jul 2024
 02:43:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240724161501.1319115-1-ojeda@kernel.org>
In-Reply-To: <20240724161501.1319115-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 25 Jul 2024 11:43:28 +0200
Message-ID: <CAH5fLgiCLxe3bjHtf3frY3vOsYucu4cFDtDR1UUZYXCGwxLv8w@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Rust: support `CPU_MITIGATIONS` and enable `objtool`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Masahiro Yamada <masahiroy@kernel.org>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 24, 2024 at 6:15=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Hi,
>
> This is an updated series to the CPU mitigations support for Rust. It
> also has the patch to enable `objtool`, so that we can start running it
> for Rust.
>
> It would be nice to get this applied soon, so that we start being
> warning-free (since we already get warnings under IBT builds via
> `vmlinux.o`). I am happy to take it through the Rust tree if the x86 and
> objtool maintainers give an Acked-by, or through any of the other trees,
> as you prefer. Otherwise, I think at this point we would need to make
> Rust exclusive to the mitigations, which isn't great.
>
> With this series, again, x86_64 is warning-free with `objtool` enabled. I
> tested `-O2`/`-Os` and the Rust versions we support under `-O2` (mainly
> for the `noreturn` patch, which uses heuristics), as well as IBT vs. no
> IBT (i.e.  running on individual object files vs. in `vmlinux`). I also
> did an arm64 build.
>
> Testing is very welcome for this one!

Verified that this eliminates the relevant warnings in an x86 build of
the android-mainline kernel.

Tested-by: Alice Ryhl <aliceryhl@google.com>
