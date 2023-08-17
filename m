Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0238313AEE
	for <patches@lists.linux.dev>; Thu, 17 Aug 2023 17:33:03 +0000 (UTC)
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-58d40c2debeso634667b3.2
        for <patches@lists.linux.dev>; Thu, 17 Aug 2023 10:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692293583; x=1692898383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p10Nsn3UUYujdaLPfWNIgLTSpN0yddWofKJcx823OWE=;
        b=nNRbqn1Ejrt8n+5/QMN1sTX3sfbpn4Q+ZYi3x2mtDhr2CIvSrHqrg6AtyEZene+thU
         bteUIhyyRVAUN8lrP0jZziVbksniAAvxHGl7YVAFvo7qZFo+gpHtSJ0wJB6hcoCjjv04
         yzBLjiKiJeM0bc9ExPanYN6jKUE+P/JGlk4p0s0Sw551iJdJ5tuU1+2cLkMnAztqVhOV
         g2mceooq+CFC618VIsUABsxUupz3BebZfZEkZDnMIJo5kXDWbjwF5rFn+lM4FVnZl4zF
         CGPtVvBVq00EN/aTKFld/SY9sh3s+fuebcU1apzxOhq/wYFiZO4xHImJ97MWKUiRytlB
         vwHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692293583; x=1692898383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p10Nsn3UUYujdaLPfWNIgLTSpN0yddWofKJcx823OWE=;
        b=ZMQShG1BAGd4Iyfe6aBtIHcKO+/1ZeJPnBEZ+FbcxX4FuQTMVqf8pM3pqA1HB1Qv2L
         Q+yL9oXSD7FC7zCPQHKPJ2uMajttumGxR+sVvSTWw5EgWInL38xQDsQaPC7y4FItkjc6
         KN4AknvbCV9wz8xmKqiakPnq3ZtxExKv1yCOmZD5cPDXvyhgrMg11C4rew3ziV0M51+A
         58C4WBNgXg37u36+2FoceO5CpxVu1Wz/koq14J5vUoXgp6/1tF5RvDIBStqHxJllN8WD
         Rp3Tzc0z3+M4fMPMU7UrdABOI2GeTmTyYGWH4pkh1/NA2S/C3v/DLDWEAoQdobTcm+NA
         EKsQ==
X-Gm-Message-State: AOJu0YzWAn+aqVoAMLSRuVtvLW8ztngDjdfqMzZ/8jHCGVK8nvpfoJ5p
	VSx6Pp0RLe89L2rrjmxViYI/h1r2cs48An5Y8BU=
X-Google-Smtp-Source: AGHT+IFe+BIU9PEPLSkSj/B85mjLNLWYbhPPrpuD4UDLZFT1jM5uy04aCvzKUcnYdCVFPINeX+rNOMZSn0u0PgfyqIo=
X-Received: by 2002:a25:ca54:0:b0:d71:8813:1e72 with SMTP id
 a81-20020a25ca54000000b00d7188131e72mr233379ybg.46.1692293582793; Thu, 17 Aug
 2023 10:33:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230814092302.1903203-1-dallerivemichele@gmail.com>
 <2023081411-apache-tubeless-7bb3@gregkh> <0e91e3be-abbb-4bf7-be05-ba75c7522736@lunn.ch>
 <CACETy0=V9B8UOCi+BKfyrX06ca=WvC0Gvo_ouR=DjX=_-jhAwg@mail.gmail.com>
 <e3b4164a-5392-4209-99e5-560bf96df1df@lunn.ch> <CACETy0n0217=JOnHUWvxM_npDrdg4U=nzGYKqYbGFsvspjP6gg@mail.gmail.com>
 <20230817084848.4871fc23@kernel.org>
In-Reply-To: <20230817084848.4871fc23@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 17 Aug 2023 19:32:51 +0200
Message-ID: <CANiq72nfAxDzsF6-k3016Gt=ngM4n0W-vgXUi-pacKLMXhjP2A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Rust Socket abstractions
To: Jakub Kicinski <kuba@kernel.org>
Cc: Michele Dalle Rive <dallerivemichele@gmail.com>, Andrew Lunn <andrew@lunn.ch>, 
	Greg KH <gregkh@linuxfoundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Davide Rovelli <davide.rovelli@usi.ch>, rust-for-linux@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 17, 2023 at 5:48=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> This is a bit concerning. You can white out Rust in that and plonk in
> some corporate backed project people tried to cram into the kernel
> without understanding the community aspects. I'm not saying it's
> the same but the tone reads the same.
>
> "The `net` subsystem" have given "the RustForLinux community" clear
> guidance on what a good integration starting point is. And now someone
> else from Rust comes in and talk about supporting OOT modules.
>
> I thought the Rust was just shaking up the languages we use, not the
> fundamentals on how this project operates :|

I am not sure what you mean by "from Rust", but to clarify, Rust for
Linux's focus has never been out-of-tree modules.

In fact, the whole effort since the beginning has been about adding
support for Rust in-tree, unlike other projects that e.g. linked
`rustc`-built object files into an out-of-tree kernel module. We have
also been advising interested parties/newcomers on kernel guidelines
etc.

And, of course, the Rust subsystem is definitely not trying to change
any fundamentals. If it looks like so, then please note that, like any
other subsystem, we may have patch submitters coming from different
backgrounds and not part of the Rust subsystem team.

Cheers,
Miguel
