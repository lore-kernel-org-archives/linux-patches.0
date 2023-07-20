Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514691BB56
	for <patches@lists.linux.dev>; Thu, 20 Jul 2023 19:28:32 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-cfd4a94364fso1027127276.1
        for <patches@lists.linux.dev>; Thu, 20 Jul 2023 12:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689881311; x=1690486111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdN8o7AJTx4ZATKNIUy6cq4O3obHD+O4FpBvaPeeNBs=;
        b=Gw9eQqRzINgLnQlR1OAcLm0s4xv3PRM9IQQTuTOs3vfoDQti8YZaQybqCpUz9PZyLJ
         YKzaf6cxIPayhBM9MYu5OL2eNNzIVOIfkDY76CwVV7G6sOgH37XBvSbKs+cEcQIvm1Jb
         UvF+52jNxhfdkAyfwFGGlDm0N2laruZFfOeBFXJUXgbRq9nVPshzAPCTXAoOtA9CZkwy
         vyJH+bpbtVblvu43x3YNXH8CCGF9iGwkBV9jSKi72nacUOz4cPzAm6vBDeIo0lfI/L7l
         1suntjO3PBXS+bPoa5gYCjW+w5osQt8tcuDtme++Ujb5t5oSaLkLpyeBDoFalts8pR1D
         cx9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689881311; x=1690486111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kdN8o7AJTx4ZATKNIUy6cq4O3obHD+O4FpBvaPeeNBs=;
        b=UURZ6i0rvbEhvu0AV721dlDacMSGjzyIqaaxNc1lW6eN6L60PTYennW2JjxNt+7eqy
         hMwkfOIHNblcrC/eSDrB8V1tsen3PYoJ9eTaiNnulUZO6/sOZZuPosGp8y3/iXhgKmS9
         l2QvmZtawzV4UKxqIyGryQ0wTp+OCihnhloWFH2ROvP9UEF61ArG15y3tkhmlinL7+SO
         DyuEB2jHy0csH7whro2t1uTrncOF6Zdheu47Hn1Bb/xiGA+0CMMQPmIEdQNoEwTZVomT
         M0o1z1sIB4lo3OSaH/W6EUG5TDp18qqh0WFksJzuK/QyuqslCUc+MvQgJWxeuaUcHIku
         0Itg==
X-Gm-Message-State: ABy/qLZxRZAkam31SRvtgKqX5qSkrYtthm7l2MVxroz3bCFheRCArl6M
	pCC9BP8RB4NTszPMCycc3M4+2sE7jSIvUYZjjrg=
X-Google-Smtp-Source: APBJJlHGQI9NwyazTFrofqytPGXoMkCuinDMKCYH6DzuorpDpZgCO6qQGnkNna3kmYEdn+EHW9YFBkfnAyUjoTpPxkM=
X-Received: by 2002:a25:4052:0:b0:cfd:58aa:b36e with SMTP id
 n79-20020a254052000000b00cfd58aab36emr2782026yba.9.1689881311057; Thu, 20 Jul
 2023 12:28:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718052752.1045248-1-ojeda@kernel.org> <ZLbTRZMjcFNAamit@boqun-archlinux>
In-Reply-To: <ZLbTRZMjcFNAamit@boqun-archlinux>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 20 Jul 2023 21:28:20 +0200
Message-ID: <CANiq72n5NOVxP37QFXDkOBZTzhGt6EREBruqUyhiqxGUrrC_CQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] KUnit integration for Rust doctests
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, David Gow <davidgow@google.com>, 
	Brendan Higgins <brendan.higgins@linux.dev>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <nmi@metaspace.dk>, kunit-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 18, 2023 at 8:00=E2=80=AFPM Boqun Feng <boqun.feng@gmail.com> w=
rote:
>
> I've applied the series and run the following command:
>
>         ./tools/testing/kunit/kunit.py run --make_options LLVM=3D1 --arch=
 x86_64 --kconfig_add CONFIG_RUST=3Dy
>
> everything works as expected, and I also tried modifying one of the
> `assert!` to trigger it, all looks good to me. Feel free to add:
>
> Tested-by: Boqun Feng <boqun.feng@gmail.com>

Thanks a lot for trying it, Boqun!

David/Shuah: I noticed this "Tested-by" tag is not in the applied
commits. If you happen to rebase, it would be nice to pick it up.
Thanks!

Cheers,
Miguel
