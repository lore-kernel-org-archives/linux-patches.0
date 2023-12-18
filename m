Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D4C129ECC
	for <patches@lists.linux.dev>; Mon, 18 Dec 2023 13:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PytwWA3v"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-5e7415df4d6so1620567b3.0
        for <patches@lists.linux.dev>; Mon, 18 Dec 2023 05:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702906414; x=1703511214; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/XTxombejJvrSz1c0NBYh3w/CnJqcWskHUIi/zqhoTE=;
        b=PytwWA3vXuk5YqIDqehfJfxLN3kwmnV9dKspBI60h2682LLP5xjSLOXkFjyhJ/v052
         Gh+jUZo+NwcHjCcwKzdDjJzE3t8WRJni1Vce+ySMChdXsW9B+VQEcgUBVZ8TDAAa/Ihb
         2hMjv6kDZW/KA7L2A5nicQDK5jXxMML+76pUSfhy+5fOjbz9WnDY/YG4XzQLYK5zoZ+M
         xd9RFEsJIs6cuIJDRgpAmdTt3WFA7CwpOfulI/4TaQBAh/hW7waGkuL68V/6cBwiCJGi
         ERNKwdQ0T0jIBstmZj5gKd1qbZZEZF3Yd7lDbUNSxRdNKjHPg7v7/KtnrBdETYkz4/08
         38pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702906414; x=1703511214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/XTxombejJvrSz1c0NBYh3w/CnJqcWskHUIi/zqhoTE=;
        b=LtccQ3kOAPnEi6UNbXjORGjsbSvW/osEOEYPSdsOW2LJmJ44juj+0ZnJ1ySMdxPIdB
         qgrnGm48ZSwD3YIxuDVttPFSK1TEjQ019SbD7OJDyTWogl+WCRltu2MrViEESwEi4ASH
         6cv9r0Ii/NFyC+Ncl9vBBZAGWG+QnuM4TQ2dx0xJZcjQ1WM/zLDmgoHkq2OVQ5jyAXbH
         Hxvw9bXIJ3Ysq5EPBfYIXoEavXWeut5f2hy1NgsFyTrHH/Miqm2RlmMuGfGANDsjleUg
         +4sxrmHxLkHeUEuzz/nf4Bif1IEtKJ7IseW2dOdMm/YdsiJV9YMxC47MWUUOx0si8VbJ
         MP2g==
X-Gm-Message-State: AOJu0YxHusnlpsczMkvFNHqGnPhkKX68/w6KrORQKn950LjIdTaup86A
	Z/GuWeUTSu7to0Ut03tJqR2Y2SO6gxSQsiIW05g=
X-Google-Smtp-Source: AGHT+IEgynr5hzCh0Yha5bdcybxD+4XDoDnyLoi/Bwrt1GyqD5BuO0u/e2Nyf02WVuvJdzMUrAZd3A7000NFrBCts2s=
X-Received: by 2002:a0d:d241:0:b0:5d7:1a33:5ad7 with SMTP id
 u62-20020a0dd241000000b005d71a335ad7mr10904091ywd.36.1702906414703; Mon, 18
 Dec 2023 05:33:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231214222253.116734-1-ojeda@kernel.org> <CABVgOS=LXUzRD-c63sxn0FMfGWvxCPP1t_8nY5Xgk30Y9qMAcw@mail.gmail.com>
 <CANiq72kw326HyrDM0v0mFNu5jfb=eL1a+k-idr-5Vbc6_gmY2A@mail.gmail.com> <CAK7LNAQ7A79fMg3Teh7H+NRwnztrNU73s5C_fybUVH+vEX0YeQ@mail.gmail.com>
In-Reply-To: <CAK7LNAQ7A79fMg3Teh7H+NRwnztrNU73s5C_fybUVH+vEX0YeQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 18 Dec 2023 14:33:23 +0100
Message-ID: <CANiq72mjSVqLNrdhK6H+X2=9ydwzX3RM2jBf1AwRFngSJ2kQ9Q@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: add `rustupoverride` target
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: David Gow <davidgow@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 18, 2023 at 1:10=E2=80=AFPM Masahiro Yamada <masahiroy@kernel.o=
rg> wrote:
>
> In principle, Kbuild does not require internet connection,
> or proactively change the system setting.

Yeah, that was what I thought. I agree it can be surprising to have
Make targets that modify environment/system-level bits (i.e. affecting
things outside the build).

> Rather, I will manually do this one time for the parent directory:

That can work for many people, yeah. Though I imagine some people may
want to keep builds (and sources) of different kernel versions in the
same parent folder (or even other projects). But one can use nested
overrides too.

> If you want to provide a way for automated settings,
> you can do it in a script you maintain.

Sounds good. In that case, we can send to the list your patch from the
`rust` branch if that is OK with you (i.e. I understand you would
prefer to avoid not just `rustsetup` but also `rustupoverride`).

Thanks Masahiro!

Cheers,
Miguel
