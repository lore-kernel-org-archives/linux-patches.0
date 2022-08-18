Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748B24434
	for <patches@lists.linux.dev>; Thu, 18 Aug 2022 16:03:16 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id 10so1423979iou.2
        for <patches@lists.linux.dev>; Thu, 18 Aug 2022 09:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=THIPiI23EIP3ZHpv9IN+trkncwr+QUSgAlM+FVJ0cpw=;
        b=gKHDaXjqmxkXczwFZ7vrwwvJ+cQGm7eRd41xNC5AbgGsDmadmgyXn73X5edHqacOsK
         luOJpLGZMPnfD8r/6fDx2IsHtTqKCs0N9yyeYvBTKoOmDLkydQGCNkinOV/anw27TKC2
         1tGLCaAF+tSTCIRg3ENHh8t88yUo3ZeGiEKfiViDXKsDYV1G8RDAtaykU3qbmit2uHNO
         RQLJo2Io14eULOgECYjyoiICl5CQFHKGI9wueZS7rRaZzSygv/JZ0BKMqu3fFkmRl7fQ
         bfZZr2EXBbr1g4Gy0xBtMLEuQMgWAnS50hpMJeA09Y/U0PP5w+Tu+q39SAsvN6Q+nAUh
         HeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=THIPiI23EIP3ZHpv9IN+trkncwr+QUSgAlM+FVJ0cpw=;
        b=nXnfMB2T9w+a+FLMfK8QaCa1IE8YpRsr8uAZqkSA9zPvmsXa8ipmx+Sd85HfpvQMHq
         VKcM3s2EUYgt1HUqHajMeUa+CAprhgN+8WmFkOpCvyuEs7j3KVYgGdNZ7jrjwnjIC35c
         f6XV0TJxv04oLsMaKZROxl3iv6I5eiTtBF/4em85LyvhBnF2ZruyTHQ93D0GFMSSGWdg
         uNPIxMoSHjEkZzt0Mt3eXDtCXPyknebUIVWIE0ki2UgmJLf25lruQahoqlej4z510BM/
         6O2525SOLppR2LXDQu9Huh5XQUYSoNmCNy+OPifZBx4JfMEm83UvTj04BJNYBZBloVmZ
         X7ww==
X-Gm-Message-State: ACgBeo3MSCdyx7QmEU8DnNmww0WhOq95PbHaOneDnyjdzDAMUEj1lNkg
	YnKEdnfRTcMm3Y1zrMr1D4yb4sualosEGzDXtME=
X-Google-Smtp-Source: AA6agR7EkCIFXFfJRO5hvuXzeculnD2voC+Lmb5zyPoiU/L6jyMuwFqJMQ7GjK3Yz5CgI88bklSaQDCMnTc7VcagAZg=
X-Received: by 2002:a05:6602:368a:b0:688:3aa5:19ab with SMTP id
 bf10-20020a056602368a00b006883aa519abmr1662728iob.44.1660838595542; Thu, 18
 Aug 2022 09:03:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-1-ojeda@kernel.org> <20220805154231.31257-7-ojeda@kernel.org>
 <202208171240.8B10053B9D@keescook> <CANiq72nR2eAeKrY6v=hnjUjvwfecMsSC6eXTwaei6ecnHjia8g@mail.gmail.com>
 <202208171331.FAACB5AD8@keescook> <CANiq72=6nzbMR1e=7HUAotPk-L00h0YO3-oYrtKy2BLcHVDTEw@mail.gmail.com>
 <202208171653.6BAB91F35@keescook>
In-Reply-To: <202208171653.6BAB91F35@keescook>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 18 Aug 2022 18:03:04 +0200
Message-ID: <CANiq72mqutW7cDjYQv4qOYOAV6uM8kUWenquQyiG-mEw4DURJA@mail.gmail.com>
Subject: Re: [PATCH v9 06/27] rust: add C helpers
To: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Geoffrey Thomas <geofft@ldpreload.com>, 
	Wedson Almeida Filho <wedsonaf@google.com>, Sven Van Asbroeck <thesven73@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Boqun Feng <boqun.feng@gmail.com>, Maciej Falkowski <m.falkowski@samsung.com>, 
	Wei Liu <wei.liu@kernel.org>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 18, 2022 at 1:56 AM Kees Cook <keescook@chromium.org> wrote:
>
> Perfect. It may be worth stating this explicitly with the helper. i.e.
> "This is for handling any panic!() calls in core Rust, but should not
> ever be used in the 'kernel' create; failures should be handled."

I am not sure we should say "ever", because there are sometimes
situations where we statically know a situation is impossible. Of
course, "impossible" in practice is possible -- even if it is due to a
single-event upset.

For the "statically impossible" cases, we could simply trigger UB
instead of panicking. However, while developing and debugging one
would like to detect bugs as soon as possible. Moreover, in
production, people may have use cases where killing the world is
better as soon as anything "funny" is detected, no matter what.

So we could make it configurable, so that "Rust statically impossible
panics" can be defined as UB, `make_task_dead()` or a full `BUG()`.

By the way, I should have mentioned the `unwrap()s` too, since they
are pretty much explicit panics. We don't have any in v9 either, but
we do have a couple dozens in the full code (in the 97% not submitted)
in non-test or examples code. Many are of the "statically impossible"
kind, but any that is not merits some discussion, which we can do as
we upstream the different pieces.

Cheers,
Miguel
