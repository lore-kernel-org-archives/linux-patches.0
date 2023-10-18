Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A02BE62
	for <patches@lists.linux.dev>; Wed, 18 Oct 2023 16:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EThAMv7U"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-5a7af45084eso90220337b3.0
        for <patches@lists.linux.dev>; Wed, 18 Oct 2023 09:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697647282; x=1698252082; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3VlPSQFKxSvHpa9DFEsMWBHHBdkSCrb3dmsVnDHyyA=;
        b=EThAMv7UMWNH27WP7+v2c7QYzE1oGr6XrpPts2OICZHF/j6CZ9k73LgtO2vfmfv61e
         5tbQsxAtKnyCR0Pt8N/8myYRvHiENy+svbeHISz/Snp7SFke8gBA47FV5/apMPlPNnZ8
         CJI7RWp/iC+2yAweyS5xLd1umbJAXIImNYrk6wOgeLC02mzN4pY6rQkOzxAhuTdEViob
         62PkVzRFVRlCsvO9UDYK9fBMzBUyRNpknm4JtnQZxqfmjo7aEvxgzbLfxnGXa6EbuPZf
         y5KJH5uvyuGexhM5qviKGxl/QF+nJiFj09fbFMrORTl2a3tFNirOEVghWJKF0/0X7hYm
         nwUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697647282; x=1698252082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E3VlPSQFKxSvHpa9DFEsMWBHHBdkSCrb3dmsVnDHyyA=;
        b=q1rcUm09lJwy44PtsX4YSYcZFbLF9vREpsZby736QRSay7/DgDWMdGPkIsDFOEiJnF
         aLT+vLvIK5ZWwVypbV80QH2q4egfKryJAmupP5PEpmtXBglVFzaKYsUdhDyW5MAgyZgQ
         hvUyKRN5wPUuLJe5mO73JtAG/E1xwYedGWdEGFAxWkHLNe6JUFYmGd7KQbJeMdB3hQsT
         EbvfQr8Q+rUJHqyK9C/bMbwwOPSoSN/C9MioTcwtTuxsne4TEolDpAyNTZ1wwVXBMw19
         B3oFcDF+iOTa/g1aNqRpRS9qh8Zi51EZTqezbUTQ+EKkP+jhjFIkC6898PXQplvEOKP/
         WK4w==
X-Gm-Message-State: AOJu0YzbMjqblneFyYibTT+L1Zu6sfQhtjvFBoXm0A+OgTd+I/2PsSBv
	Qd4P8AXn8oJg1VZUgGl13d4Ju4paKVxOA5WKrTs=
X-Google-Smtp-Source: AGHT+IGeMWtpzMDExoSuABmjNGqR3PFNyAVZrVg+01vy33KHXMOMHhwIQ38DWCms00XgIn2FEgV/uD7AmSicFFB5XUc=
X-Received: by 2002:a05:690c:d89:b0:5a7:aa7f:17d5 with SMTP id
 da9-20020a05690c0d8900b005a7aa7f17d5mr7105458ywb.11.1697647281835; Wed, 18
 Oct 2023 09:41:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231018160922.1018962-1-ojeda@kernel.org> <d47553f1-1832-4c69-8a8c-71c58048ff30@lunn.ch>
In-Reply-To: <d47553f1-1832-4c69-8a8c-71c58048ff30@lunn.ch>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 18 Oct 2023 18:41:10 +0200
Message-ID: <CANiq72=E7TPLcq-yiQF9E8a33ghbogPcbv-yMqFKBxMQ0oOxNQ@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: add "The Rust experiment" section
To: Andrew Lunn <andrew@lunn.ch>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, linux-doc@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 18, 2023 at 6:27=E2=80=AFPM Andrew Lunn <andrew@lunn.ch> wrote:
>
> It very unlikely end users read this document.

We can add a note to the Kconfig symbol too -- would that be OK with you?

> And that statement is
> not limited to end users, it is true for everybody.

Agreed, but that bit is meant to emphasize that end users do not have
a reason to use it at all (unlike kernel developers etc. from the
previous paragraph)

> What we should be saying is that Rust for the Linux kernel in general
> is not ready for production use. Developing drivers in Rust is
> currently for experimentation only. Given the experimental nature of
> the work, there is some risk Rust will never be ready for production
> use.

The risk is that Rust gets dropped from the kernel because it is not
used enough, not so much that there is a fundamental problem to solve
in order to reach production.

Cheers,
Miguel
