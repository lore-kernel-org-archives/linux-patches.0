Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBE12117
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 08:20:43 +0000 (UTC)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-5701e8f2b79so11184987b3.0
        for <patches@lists.linux.dev>; Thu, 15 Jun 2023 01:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686817243; x=1689409243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z+g1EITlpyKqSTNS66gSjpFolTiPe57pV55f5skYdlk=;
        b=kPeNuOVaNVXIRJd9crDCP1FTb0Cs/gxo20VHoVU4zinJgQfhdUGCgvHLXIPjx1LkuZ
         z+CfqoYGkCRbgxUN/NrL5KQJrFtiPy688H6ADOssoN/n2PJETlRRloSpDPBwiwMJC/6I
         n+sYBQZVxD/d+cSSusltZZKQJAIFMi34CGp/7nl1oy0pkKZ9cgvXms2FipS/uiXuff0o
         8DP5XrYfJdVnVQkNxwL0ATqkUF9qYv9HQ1zS704VUtL7OJoqcRiWpdkLacb7ozdwAQC7
         jMdMhTtSWkbaxmuMQ0ki2G1meDzNUUBojElAgOpJa+pqDtGwWv81D68MJQkzRC4mSg8M
         B8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686817243; x=1689409243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z+g1EITlpyKqSTNS66gSjpFolTiPe57pV55f5skYdlk=;
        b=c9WYgg92H0359vIFGGhfX/8g8oB/946Pr0rnxDmFGohifcdpkLbor/AWqEZnY++Zvf
         mkLzAjSNgl/mqanyQI9YSIs2+40TqsuD4ME4ohTTgBquCeXCh+dRThmcwSzbxvaXjLvE
         z3uboiK1/McjuEu/MzDdR9dGId5vjv2cM1kjYMiogfhqdpNDv0UHhJn8nyDe+W0P3jSg
         RFMJMbrPZW9KZPWSSa5Z6ERV19ecisuZdR4Pw2tqBlUsS2e0tJ7rVAFNHKuGWQqjFCL1
         ZTULiqCzXojifyA2LEUCffbp27B8AV8LE9tClkr3Qz0Zl3TkzWKh6UVnWEG3xHv80VIw
         w4Uw==
X-Gm-Message-State: AC+VfDzKAREWw2EdEBg0yS932ORXB5EtqtVt20lr9Bl9aGnJdVRkwhpl
	yRdldT7sbxzvqk3WJhup0Lc6L9vZfksrgSzpWpI=
X-Google-Smtp-Source: ACHHUZ5wZcHqgLWPneYowEPyb/vMtXfLcl6iVcQDr0Pg9watznu/kRbkN+YQH+842S1lRXtj9sJTCQXadFTZxb4w2rE=
X-Received: by 2002:a25:240d:0:b0:bd5:4e6d:9159 with SMTP id
 k13-20020a25240d000000b00bd54e6d9159mr4103388ybk.17.1686817242809; Thu, 15
 Jun 2023 01:20:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230614180837.630180-1-ojeda@kernel.org> <ZIps86MbJF/iGIzd@boqun-archlinux>
In-Reply-To: <ZIps86MbJF/iGIzd@boqun-archlinux>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 15 Jun 2023 10:20:31 +0200
Message-ID: <CANiq72kHEddR-D17Ykr3xtU20rDJn517fqHRUX+-kWHjYqu9PA@mail.gmail.com>
Subject: Re: [PATCH 0/6] KUnit integration for Rust doctests
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, David Gow <davidgow@google.com>, 
	Brendan Higgins <brendan.higgins@linux.dev>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <nmi@metaspace.dk>, Philip Li <philip.li@intel.com>, kunit-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 15, 2023 at 3:44=E2=80=AFAM Boqun Feng <boqun.feng@gmail.com> w=
rote:
>
> Great work! I've played this for a while, and it's really useful ;-)

Thanks!

> The assertion warning only says line 35 but which file? Yes, the
> ".._sync_lock_spinlock_rs" name does provide the lead, however since we
> generate the test code, so we actually know the line # for each real
> test body, so I come up a way to give us the following:
>
>         [..] # rust_doctest_kernel_sync_lock_spinlock_rs_0: ASSERTION FAI=
LED at rust/kernel/sync/lock/spinlock.rs:61
>         [..] Expected e.c =3D=3D 11 to be true, but is false
>         [..] [FAILED] rust_doctest_kernel_sync_lock_spinlock_rs_0
>
> Thoughts?

Sounds good to me. However, David/Philip, is this OK or do you really
need/use the actual/compiled source file there? If you don't need it,
does it need to exist / be a real file at least? If the latter answer
is a "yes", which I guess it may be likely, then:

> +        let src_file =3D format!("rust/kernel/{}", file.replace("_rs", "=
.rs").replace("_", "/"));

This would not work for files with a `_` in their name, like
`locked_by.rs`. I guess we could still find the real filename based on
that information walking the dir, which is another hack I recall
considering at some point.

Otherwise, if "fake" filenames in the line above are OK for
David/Philip (I suspect they may want to open them for reporting?),
then I guess the `file` one may be good enough and eventually we
should get `rustdoc` to give us the proper metadata anyway.

Cheers,
Miguel
