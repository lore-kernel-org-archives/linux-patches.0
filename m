Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFF91E507
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 23:21:08 +0000 (UTC)
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-78caeb69125so95140241.3
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 16:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691623267; x=1692228067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k5o9z8rIozKDSWMTZU5ytSG47Bk0bLqtkW/aG47vTbQ=;
        b=Jf4T6AMa/ohS1+2qM35/DkAfQJj76hPqJFrRE7fEADiiE0jnz0b1mNgeWfZqcmEFeU
         R/a/pkbuPS+lsQWTYUBVn7HAf7zBSFZfHu951lrOKFzWoTPzBv8DVnptc85rTQUE4nPH
         KWW9MjGtj0dz3r0o3OeuJiCiUU5oMBXZggbcKUyYoqiyjZdheznqno0hedR7VIJNSbh1
         4U288qLcHkohljB6pgTL9ryznkKsi/6tQlTuk+XUqeg6R2geZHQx8aACKOjynf4vMTQo
         mC8W7a70i6XdSQDwuNjKK++R9yhzccVNLlfPUIJDtk1dsppJALDACS1tCkYNyRaZ/UdI
         xdWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691623267; x=1692228067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k5o9z8rIozKDSWMTZU5ytSG47Bk0bLqtkW/aG47vTbQ=;
        b=k9Yuf9TFrD6Hqo+QRkp6GLBrh8u5BnwFL5oBFhEsK9e4lFg1z5nF3LHFXI9kZn1nh/
         Jqn/A0EvzRRothdx4GZ9c/TBX08/ayG8/jUAGWHZ66IzNF+T/HoZEHGOCNPCgMNhX0F1
         NinDj1nzmb5XDj3Q8efpidq9Ur+yv6HwM8h+N6S2PB5zJiI/Lxil5GrcFRc9vA8WygcO
         rHuNxp4cTPjbleDf1G+h26fnlbafoMD28HWilJNV9+eLXuFrgu7pqVYCJ2JZULLCX7HJ
         rUr+Sybc59ouBhdZDkNper7Kp6xYw5W/ro5iw73Ra3RScccCHrpqeiTHww8vOAczfigF
         D3jw==
X-Gm-Message-State: AOJu0YzvMBVmShbCxzp+C+0cn1HWDLvMTMSjcc6s1+hp5++nXc1cYg6T
	sMhil109GeOt5yOaAq5ugvAS3mGcazJde3f5W/E=
X-Google-Smtp-Source: AGHT+IGqPUs/d80Szj9z56iymuDqM5vj3EeTgPS4VDiZqmrFqxhEWSd6fHGyQVSFkNuuJWPw7w4fy99kM+1/sJu3VMs=
X-Received: by 2002:a05:6102:156:b0:447:4432:7400 with SMTP id
 a22-20020a056102015600b0044744327400mr581937vsr.16.1691623267476; Wed, 09 Aug
 2023 16:21:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230616001631.463536-1-ojeda@kernel.org>
In-Reply-To: <20230616001631.463536-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 10 Aug 2023 01:20:56 +0200
Message-ID: <CANiq72=EpRVK14-ShY7zdKmNLTfXMz=JdU5YPcivVN8TDpF0YA@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] `scripts/rust_is_available.sh` improvements
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nicolas Schier <nicolas@fjasle.eu>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <nmi@metaspace.dk>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 16, 2023 at 2:16=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This is the patch series to improve `scripts/rust_is_available.sh`.
>
> The major addition in v2 is the test suite in the last commit. I added
> it because I wanted to have a proper way to test any further changes to
> it (such as the suggested `set --` idea to avoid forking by Masahiro),
> and so that adding new checks was easier to justify too (i.e. vs. the
> added complexity).
>
> In addition, there are also a few new checks in the script, to cover for
> even some more cases, which hopefully make problematic setups easier to
> identify and solve by users building the kernel. For instance, running
> the script externally gives:
>
>     $ scripts/rust_is_available.sh
>     ***
>     *** Environment variable 'RUSTC' is not set.
>     ***
>     *** This script is intended to be called from Kbuild.
>     *** Please use the 'rustavailable' target to call it instead.
>     *** Otherwise, the results may not be meaningful.
>     ***
>     *** Please see Documentation/rust/quick-start.rst for details
>     *** on how to set up the Rust support.
>     ***
>
> I also changed it to avoid setting `-e` as Masahiro suggested.
> Similarly, I now check for `$RUSTC`, `$BINDGEN` and `$CC`, instead of
> `$MAKEFLAGS`, as he also suggested (but I gave it their own error
> message rather than use the `${CC?: is not set}` approach. This goes in
> line with the reasons outlined above, i.e. trying to give users a clear
> error of what step exactly failed).
>
> In the test suite I included previously problematic compiler version
> strings we got reports for. The test suite covers all current branches
> in the script, and we should keep it that way in the future.
>
> The patch series also include Masahiro's patch to remove the `-v`
> option, as well as Russell's patch for supporting multiple arguments
> in `$CC`.
>
> All in all, this should solve all the issues we got so far (unless I
> have missed something) and improve things further with the new checks
> plus the test suite to hopefully have an easier time in the future.
>
> Testers for this one are appreciated, especially if you have uncommon or
> custom setups for building the kernel.
>
> This could go through either the Kbuild or the Rust tree.

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
