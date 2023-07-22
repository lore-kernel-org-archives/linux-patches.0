Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326DC1D2FD
	for <patches@lists.linux.dev>; Sat, 22 Jul 2023 15:51:58 +0000 (UTC)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-583ae4818c8so12164817b3.3
        for <patches@lists.linux.dev>; Sat, 22 Jul 2023 08:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690041118; x=1690645918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GCi1Uz5o7zeVrFMLJ/4tgvXXXKZHZ4kvnCTkqRPWjWA=;
        b=AOL3KXHdbXZMFcjTHwc6CCED5VEqhzTh4nbizMd7FgDA1zALz3PvEWgSwMKoaAhg/E
         8ea5/DnMTu1CBpSXbBpUmA6MNnky/bPsaD/vE6Nh6vRNgYta0atW/N18fR4rv6iXVvWY
         6HrgBGEwSZdbtBmz3NbYCuUfORAJ4sPIXkXcPlGIxNSV5na4JdOImlrzv0R/a8woaWqb
         ZCeT14KmIN6MYia0WVSbjYApmeCuiXUYDb8qLs5ALA0dhC69NAQDqODLoaMI59sLfW5v
         9Dfm67dXjr0G9pbEhEataEP3nCRxDNxYeEuUGxg3KGjVT1YKa0t/2bKwCQUqhz5XiQPB
         6OKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690041118; x=1690645918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GCi1Uz5o7zeVrFMLJ/4tgvXXXKZHZ4kvnCTkqRPWjWA=;
        b=bAQBDSMk/YGq0dWVuFT8aAjkN3N0QTgVXM33SM4IkBvBlGLneOilHMwk8AGnTuJ8y+
         vKhKxxj4HeCOR8xGzo0wzz02uPociil3Uekg4ub792IYo8FCixXN8IJXtuMnVZre8eic
         DTJcmlqHe7FDVBCWddC0+1x21praMElyW6qNijDZUL3OPelaXStjLpRsBx/32xsNZr9b
         el96I7UqYNP0KqrAxLDI2YKXE5Kk26O4uslA/tt1RFnHd0fa0+GhDJb0ZTycKUVAaciM
         FAO3XsvovaEqL7O17voKlKYBRnI4ffxPhruGV28tdaOjH8viBT3br/y4fSPSbDjw2/AC
         vZnw==
X-Gm-Message-State: ABy/qLZOutret9pgijp34L1eKayGRhm3xDFsuJ6m97uswCjkKKFBHQfp
	j4DKnrwuTibZL+iMs+5iORiPtVM/HsfsFKMl8to=
X-Google-Smtp-Source: APBJJlFGtjGwoVBX6T4RZLs+O9K/oMEKrvNEmTfDepBNpMwxth6UkVuiRcQi79TO2WtMS7kRWnjdz58tBZhbRYxqTWo=
X-Received: by 2002:a25:fc05:0:b0:c41:a05d:5da7 with SMTP id
 v5-20020a25fc05000000b00c41a05d5da7mr4021208ybd.5.1690041117961; Sat, 22 Jul
 2023 08:51:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718055235.1050223-1-ojeda@kernel.org> <CAK7LNAQ-hjW_19fjA+E-bQCrXcVPdN4-GvzAnEnYzna5KRVXew@mail.gmail.com>
 <CANiq72kZjOGvRKoRxtgG=2DhJnMJK9TCQtTmeef_B=nLcLQD6g@mail.gmail.com> <CAK7LNASqumGb0xvSa8n4Heasz9BKxgk4mvzNXsfFhZE1G+Bxbg@mail.gmail.com>
In-Reply-To: <CAK7LNASqumGb0xvSa8n4Heasz9BKxgk4mvzNXsfFhZE1G+Bxbg@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 22 Jul 2023 17:51:46 +0200
Message-ID: <CANiq72kD2wxXy2ri8sBhVJ4y-JJiq+kYt_MRZwuwB9uGkX-_jQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: avoid creating temporary files
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nicolas Schier <nicolas@fjasle.eu>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <a.hindborg@samsung.com>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Raphael Nestler <raphael.nestler@gmail.com>, 
	Andrea Righi <andrea.righi@canonical.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 20, 2023 at 8:35=E2=80=AFPM Masahiro Yamada <masahiroy@kernel.o=
rg> wrote:
>
> Maybe, the following was a breakage.
>
> commit 295d8398c67e314d99bb070f38883f83fe94a97a
> Author: Masahiro Yamada <masahiroy@kernel.org>
> Date:   Sat Jan 7 18:18:15 2023 +0900
>
>     kbuild: specify output names separately for each emission type from r=
ustc
>
> Before that, rust_common_cmd had --out-dir.

That's right, good catch!

> BTW, do we also need to fix scripts/Makefile.host
> in case the external module Makefile creates host programs?

Indeed, we need it too. [1] would fix it (tested it with a trivial
out-of-tree Rust hostprog).

Do you want me to send it separately? i.e. to avoid losing the
`Tested-by`s etc. that we already got for this one, which is the
important one since that actually has users.

The hostprogs fix is not really critical for stable, since it is
unlikely there are users at all (we just got the first in-tree real
user in the Rust+KUnit integration coming into 6.6), but I guess it
does not hurt for the same reason.

Thanks!

Cheers,
Miguel

[1]

diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index 7aea9005e497..54adf2e2ec51 100644
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -86,7 +86,7 @@ hostc_flags    =3D -Wp,-MMD,$(depfile) \
 hostcxx_flags  =3D -Wp,-MMD,$(depfile) \
                  $(KBUILD_HOSTCXXFLAGS) $(HOST_EXTRACXXFLAGS) \
                  $(HOSTCXXFLAGS_$(target-stem).o)
-hostrust_flags =3D --emit=3Ddep-info=3D$(depfile) \
+hostrust_flags =3D --out-dir $(dir $@) --emit=3Ddep-info=3D$(depfile) \
                  $(KBUILD_HOSTRUSTFLAGS) $(HOST_EXTRARUSTFLAGS) \
                  $(HOSTRUSTFLAGS_$(target-stem))
