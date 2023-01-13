Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9A5627
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 23:12:23 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id 188so24139075ybi.9
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 15:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BY609W+RhGncJpLGsLFTmsHR4NCyfTU2HTS8CdOqR80=;
        b=BBLnmu7wTpyRpe1vlSApwJwOufO4BV2eXl8TNYC9oUJBKH082MttNKekZu41Pusf9m
         VmfJY4sr3we8ivvg8AJjtAGHmZCSZXt+BYZFuCNC1/j6iawjyIKQlVvQKKPiGt2F5fRE
         BjTkdPI4pDiWuvuCxVhCQfBOdIgBWJIwLEw/3tRTKIQJJOxLXKmlEBpNBoTQmslLiYrq
         ByKa9bMiyp26P8upBsPMMyrfkeWZDxgpqFaQb1jVNzq6/OLBpMBe33IV8qfcG+PoMtPh
         Ewg377TuvH4xJFzn3ahp+hGywE5Kb1w3ojHCFMZH0ok9JoRTIhKonHFFy2rK8BFCBeLa
         P0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BY609W+RhGncJpLGsLFTmsHR4NCyfTU2HTS8CdOqR80=;
        b=YoYyKyMmtzTazOAcT51Q6k/W+rynn/HcrcYBGJqJgOKu21bywWx+y/idCVK3rGqpHd
         R0v4abNkdv9lZYB3UZgVhYbkY6rwcX8speE20Ph18HvWWzz5/nMt92ZRe/SWBB6hRJ/B
         qtFsev8BD0KnPSWr2x7utwpBNZg3Q+gsMW49bo8YBYfyDllUXsNbSCuNocKHVAv0xl56
         9+qgCOtDj7KuNIFFixdG22MkXQ03gI1+3t0n1D80hUojo4XYcdpBYNoJJUmNwnYYXVWu
         4q2X9QdDVeNJlFwliBu7GWnxlSoijH5XyZpn7+5eCvJ4a7GGrkBwhZakOiTfCfvycVQ1
         qFuw==
X-Gm-Message-State: AFqh2kpPszymbdg7/bdYSOyZgOWhbM+i13gcI8ElocubSdcVePpSw9eE
	DwZSCdWZK4TjVEuIQsJUoQevq355SoEuZyvyezBMgAtrE+SUaWZ0
X-Google-Smtp-Source: AMrXdXuW5kHqYbDDTnFNIc+bjFmllra2oA7YOJ1yhQkhHBtfR/MKTNzI6i3veu3ZSRaw6B5iXKRb18lX3OuNPu4wyyY=
X-Received: by 2002:a25:7702:0:b0:7b4:bdd7:e631 with SMTP id
 s2-20020a257702000000b007b4bdd7e631mr3698278ybc.507.1673651542817; Fri, 13
 Jan 2023 15:12:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org> <20230109204520.539080-4-ojeda@kernel.org>
 <CAK7LNARuGz=oFukWH4g=7zg1EbWP9rxpVXPgPrJBKHzLQW4N1Q@mail.gmail.com>
In-Reply-To: <CAK7LNARuGz=oFukWH4g=7zg1EbWP9rxpVXPgPrJBKHzLQW4N1Q@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 14 Jan 2023 00:12:11 +0100
Message-ID: <CANiq72=Evg9pQLCdtr+kTsr4fEewjKCkBw2dBYTB7WbPVy2wtg@mail.gmail.com>
Subject: Re: [PATCH 4/6] kbuild: rust_is_available: check if the script was
 invoked from Kbuild
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 12, 2023 at 6:29 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> I do not like this.
> We do not need to cater to every oddity.
>
> Checking MAKEFLAGS is too much.

I agree we should not attempt to catch every possible mistake in the
script, but there have been several people hitting precisely this case
(the latest is in the linked thread in the commit message), i.e. some
people read the `Makefile` and notice the script invocation, and go
execute it, but they are unlikely to be aware of the target in that
case.

> You can check RUSTC/BINDGEN/CC if you persist in this.

This is fine, and actually we should do it regardless of `MAKEFLAGS`.
I can add it to v2.

However, that does not cover the same thing as `MAKEFLAGS` is trying
to here. The reason is that even if they see e.g. "RUSTC is not set",
they will not know about how to call the script properly, i.e. through
the `Makefile` target.

For `RUSTC` and `BINDGEN`, it does not really matter (and we could
give a default to the variable, since the name rarely would be
different). However, for `CC`, the logic that Kbuild uses is more
complex, so it seems best to me to let Kbuild tell us what the actual
compiler is.

Cheers,
Miguel
