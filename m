Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FC0C2E0
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 10:50:51 +0000 (UTC)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-579de633419so51126117b3.3
        for <patches@lists.linux.dev>; Tue, 18 Jul 2023 03:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689677450; x=1692269450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1QDt0Sf7l7pQV8orH0tWzg0eiS7P4OmFAqlO08Oj7A=;
        b=OwEuP7K0L6BBLEOoRWNgc13+QZSqASstXZdoqrCVLhfxwQx+f8AtBu0wLOadrkZwWF
         dSbXadM46AKh+Jkifu77ufI5Ul+C6u0Db1lGML54C4Pow0W0QSX/upPygTmQhJXMolRH
         7bp9XlsKFhbpUPK5TgMaFIcx3tdBF8j0YyYxHnpCHAAxI2KQjZNCQreecd2OFYzJuR3T
         KyDdKON0f0Dn8v4vCo47CXbYE8h2MmWcprU8kBn1Y7Ivd3zGOfXNIOif2eMeG5gkU9dj
         fdHxozKZFkl+0huY8jaG5V4pSJ7iO3C/gttf0ydiApMaLiWb1LO41KfA7sC846XgDfpZ
         opLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689677450; x=1692269450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k1QDt0Sf7l7pQV8orH0tWzg0eiS7P4OmFAqlO08Oj7A=;
        b=YGCNv3n68Dn2skozTerk1R+sp+YMe7OCkhsE2YyDmh+7MnPoW0eYcyC/y5qWe556wA
         SWa58h21XlwjGuetAoZutBbGB0TZwdLor9eiLL2qI962NR1ql783VgVQTkeON+RqJFay
         NuIFvZxmeUH610QZe87vHQdveHapqXDjPdnUR9NxjBYaL4ArwWL3Y4sTU73vKAaiHwBX
         hBCTOhjXkPH4T3LFe0zR68mpeCi6/++tzuAVH5xMUmS3iOsls0HxQPxCLPvrNuWhkyPd
         vV/2RarbBQuB0rQv0yH7Lv4+ZXkw+NcAjH7bjEF5DPHzTXgV5ZjTsDSr4ug/F5vQDGME
         zt3A==
X-Gm-Message-State: ABy/qLY5YlFMoV6XLXkW3MkBb+Cd3TQNX1RHewOrBDjJbbNzDwKETKO4
	pXSLRe2Uc0eIy/+Dgp2qZ9cZKtbDyRQq1e4BHvS4JAqBrj8=
X-Google-Smtp-Source: APBJJlEEHZSBU905UJoBlQ0tbX9EIC+PNtKEcVq973I/wi35dpixqOtiOfiXL+/VGe6/40ITgyhg8C5o3fny82zoAC4=
X-Received: by 2002:a0d:ce07:0:b0:577:cd0:681f with SMTP id
 q7-20020a0dce07000000b005770cd0681fmr12915048ywd.26.1689677450701; Tue, 18
 Jul 2023 03:50:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718052752.1045248-1-ojeda@kernel.org> <CABVgOSk+YOdmpnBpLcx2sC3NN7amdpLf-C35EpvYmzq3SWHAqA@mail.gmail.com>
In-Reply-To: <CABVgOSk+YOdmpnBpLcx2sC3NN7amdpLf-C35EpvYmzq3SWHAqA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 18 Jul 2023 12:50:39 +0200
Message-ID: <CANiq72=7X7nooVnoS6JxXBwwFGGGJU5eNVNUu=g33-YQjR9vnQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] KUnit integration for Rust doctests
To: David Gow <davidgow@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <nmi@metaspace.dk>, kunit-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 18, 2023 at 10:38=E2=80=AFAM David Gow <davidgow@google.com> wr=
ote:
>
> I like "location" better, personally. The attributes work is still
> ongoing, and while there's some benefit to having "file" and "line"
> separate (it could potentially simplify some implementation on the C
> side), we'll cross that bridge when we come to it.

Yeah, I felt it looked a bit better, but if later on it ends up making
things too hard, then yeah, we can definitely simplify it.

> This seems to be working well on the existing cases under kunit.py
> here. I'll continue to play with it, but no worries on my end thus
> far.

Thanks for trying it out!

> Thanks: while we're still arguing a bit about exactly what the format
> of these will look like in the KUnit/KTAP attributes spec/patches,
> what you've used matches what we've been proposing so far.
>
> Let's stick with <test name>.location for now, and change it if needed
> when the attributes spec is finalised.

Sounds good.

> These are all (still) looking pretty good to me. If there are no
> objections, I'd like to take these into kselftest/kunit as-is and if
> we need to change anything (e.g. for consistency with attributes when
> they land), do that as a follow-up.
>
> Thanks again, Miguel, for all the work getting this going!

My pleasure -- and thanks for reviewing it so quickly and all your feedback=
!

Cheers,
Miguel
