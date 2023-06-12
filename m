Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088F6BE66
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 23:36:19 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-bc4114d44a8so2979552276.2
        for <patches@lists.linux.dev>; Mon, 12 Jun 2023 16:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686612979; x=1689204979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Uivj7/Q9yql/xb9uKNQvnL3YGWrQU/+WuXKXtQJByY=;
        b=eXCH40sdXoq5OtFW5Wc7capgAZvIj6/HX5LXYosL5HGQloCoZh+N+ZyRCgWqULbQH4
         R1glfSo0owUEDeOnlYYwNuBdGQiOhISlWhMXgQlRbw/MbXWMX3CrdNqVurd0m7EfOVdA
         qzom7zN7kpS/iPmG3LQfkTQY6rV+SsRd8CCVPxjIawjJar0oZIVfnib/MAcqS+GZuEjf
         wE/DhBMulPSc2ySu8SMLpF2uq0IdAJU4OiK3K+cDAytsefbELr4HFxd5SLl7PDZ6nhM8
         JOjOylyT+BJHQdcVwqiZD0WmkqT7SBi4yWjgGhWl3PJmFZOuQrQ1uO+069gIUdkMCjVT
         zumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686612979; x=1689204979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Uivj7/Q9yql/xb9uKNQvnL3YGWrQU/+WuXKXtQJByY=;
        b=TOmOYBZE924ERSAlMuCF0bWXy91AQEP796w+1uMk0YwirdLzJYe90mEixLnM0Z+yP9
         gDqKv3Akcp8Ji7jd5p1LrCuMO70mlU4D9OETveGmmYSDVqfvPzoEQ2PP7LH7kmWMiJ1X
         74/a/DwsBM+RMkl5Mn9OOVGVjQdsEQ0UzrEkgDQoEy+8H/Hu+xYhcCbBF/EFiAigJAz0
         e1aTB66hu6/3euTsf2BmqkABtvA7AWPDr1Q5k+hTYVAU4vbkpndVzuBuaQrEn6TtF6Rs
         qzy5QVWedkD9KOIph4sZC6Be95wZNXjQ/uAYAQ1PoCIeyEiQsnSETLkvF1Qy7ifZhONN
         u4mw==
X-Gm-Message-State: AC+VfDziNiQj+ANiMr3m8hBR+DGDtYsFyqaV5BYSpGSIVFIS8O0Hf02V
	uI+G857wEQYcyTLyGn1he3Lkb3CIkx4xeJ7ZOZU=
X-Google-Smtp-Source: ACHHUZ7FHp11Pap/dBpkC6coJLr9NQfk/SiiHMoYewbngISWHMgFGtI9hTpiNtlAQ8aSMRh7mCvY7RpVQCY78QEHfrA=
X-Received: by 2002:a5b:a4f:0:b0:bc5:4f79:a7c5 with SMTP id
 z15-20020a5b0a4f000000b00bc54f79a7c5mr134129ybq.26.1686612978754; Mon, 12 Jun
 2023 16:36:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230531174450.3733220-1-aliceryhl@google.com>
 <CAGngYiW_3HfebWZO5S=RXFqhNnsbnix-NaA0UGYRnRLd4SK65w@mail.gmail.com> <CANiq72=DJBW82L44icrrTo=_jrv=BS3cd10s6WuraXX7suW4tg@mail.gmail.com>
In-Reply-To: <CANiq72=DJBW82L44icrrTo=_jrv=BS3cd10s6WuraXX7suW4tg@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 13 Jun 2023 01:36:07 +0200
Message-ID: <CANiq72nUkuQ+Bpi6+UE6hMwtngs=yiZcH826mt-wox=7Nq9wWw@mail.gmail.com>
Subject: Re: [PATCH v1] rust: error: integrate Rust error type with `errname`
To: Sven Van Asbroeck <thesven73@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 12, 2023 at 9:04=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> Applied to `rust-next` -- reworded for clarity. Thanks!

When working on the KUnit changes that require this, I noticed this
didn't include the `CONFIG_SYMBOLIC_ERRNAME=3Dn` support we originally
had on the `rust` branch.

So I added the `errname` helper and force-pushed.

Cheers,
Miguel
