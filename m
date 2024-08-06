Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ADB15ECF1
	for <patches@lists.linux.dev>; Tue,  6 Aug 2024 21:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722979800; cv=none; b=ul5KnUNkl1fOlyjAq96SykcD7fa185QvWHLfNM38YNlI5VG7cHp6dZMbLRFC5RKAXmQ/5OSoWi8XHnD4x9NiJzgqEhJMumiLtJPlUPgBcSu+peZgLA22xRZl3Z1tXsdJ27jPrEMVbyryluWqlBjKPJ/xqjZK/uR4G7Ts4or/OnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722979800; c=relaxed/simple;
	bh=YAYm883qR2b+0OMMEKEDDwX0rE3CyHC+yxTlu4vjzeM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A7JBVePcXEb3vJ+aR/b3hd1iPJ7cQORQYGRd6Eo7nF3I6xzahhH9+BDVxH6hec51Y1SqrM5TjpeN+mx28fj7D/a3fCKNlV0COyWk9fHX0LYwB/TG8Y2x+n+OyZcc76S850DxWk370I5xc+zP+6o8+i5VWXWzkIk5HRqoLCoY/Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SmbHu0a/; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SmbHu0a/"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2cf78366187so834735a91.3
        for <patches@lists.linux.dev>; Tue, 06 Aug 2024 14:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722979798; x=1723584598; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YAYm883qR2b+0OMMEKEDDwX0rE3CyHC+yxTlu4vjzeM=;
        b=SmbHu0a/0WTfufwcjvTOqFfjRQCI1r7CTBtqnkpFSdDAWLE7ddlfc1a8lPDjtavOFP
         Mo0IEqXvDNwcEJyuz5iQjnUjWBlAsonOYRWBzy1Pc9aymNE8SiFPCE66zZeZd61B2hZ/
         keriz05J7U9Cx+hqnuQsKdAKwzDlLPs2KaROwzaWpAOMzURUYH73Hh8az0PN43AdE86K
         o9QY5tFqLw40aFFMAiDCpdV4dOWI1FdAEs+c4AzYvk/CUdsdcwn4a77KsCLv3/8zvLsI
         ZrUT/B2hb+XMrQtjK/onoOcbjvULyzBY8/GvDgNMOP3Hq8AmILv4/cIvautFuJ/iCBfB
         gLOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722979798; x=1723584598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YAYm883qR2b+0OMMEKEDDwX0rE3CyHC+yxTlu4vjzeM=;
        b=VSVBzdwPh9qaILJxmrED30jbx2e9sH3C2EO8ufUOyPNh2jG91c45DiDyZ4CGDqJFaP
         u3qw/Ch/2wXmY+AYkqTp1X0gnMM+WsKa7/HkZgN0X/SFmxNgaNh6nQ6D5U2pTFyq+bpo
         ft+WH2LThsMmSA/jhyhEEf50vpmc23/qIE0MiCemgxTMNl95pTKugKdMNJNlnTsd3tlW
         yP8zbZeq9h0WPm3ZVnH97WgdwNfF5Y4hdVJCqCyFUyvVLZ2bXNthjD3Vfiw/P4PewRyJ
         EWzA/WOPg2uYJUH3ViATGdXToHHVdHd1a9kzGeY0cPKEh3lH8Z0ADvS7b8pAdb0zcx1o
         gpwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcSM9rqKwQLq9C4Ve+k8qwCrOeBTeO4Jq4qTm1+/zW1fheIvRd5j6srb6lZo8TF1GT3i+JxMSEmmn5LfCjYisAAw6R6PeTiQ==
X-Gm-Message-State: AOJu0YwKJ9YxjUpD4PEW09yX69bv8C5j+ftaaxti+5HAiMittQGPZdpW
	NnfAtD3SZNCTy9K7Kn8KUYTcNJuuQcwxSrSZskVkEZ64ZVj9ejiK7v4kBl7fga+wGPAdAQhv0Oj
	tffsmINNTM2VqBcctYOHmbJjxB4s=
X-Google-Smtp-Source: AGHT+IEzClk6wi93u2N1ixrRD20SSYcAePSE4oKBt1hQ8ZNBYd1wNxcRTjFOXdxvnz2DSbe4P7vhA5aUuctrQ5oTFLo=
X-Received: by 2002:a17:90b:1652:b0:2cb:55f9:b7c5 with SMTP id
 98e67ed59e1d1-2cff9415bbfmr19564109a91.12.1722979798377; Tue, 06 Aug 2024
 14:29:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240725183325.122827-1-ojeda@kernel.org> <20240725183325.122827-6-ojeda@kernel.org>
 <202408061241.855CB28@keescook> <20240806202217.GZ37996@noisy.programming.kicks-ass.net>
In-Reply-To: <20240806202217.GZ37996@noisy.programming.kicks-ass.net>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 6 Aug 2024 23:29:46 +0200
Message-ID: <CANiq72k1OvLEV2uf56vDXGvWX30YWa_r6ewS2fGoqxVGcqf9LQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] objtool/rust: list `noreturn` Rust functions
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <kees@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 10:22=E2=80=AFPM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> So it would be fairly simple to make objtool consume a magic section
> emitted by the compiler.. I think we've asked the compiler folks for
> that at some point even, but I don't have clear recollections.

The section sounds like a good approach -- we will ask the Rust team
about it. Then perhaps we can get Clang/GCC to implement something
similar too -- for this sort of thing we can use the shorter cycles of
`rustc` (and their unstable features concept too) to experiment with
these things :)

I have also added it to our `rustc` sublist of things we need.

Cheers,
Miguel
