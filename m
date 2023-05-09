Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6943111BE
	for <patches@lists.linux.dev>; Tue,  9 May 2023 11:11:06 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-b9246a5f3feso8684593276.1
        for <patches@lists.linux.dev>; Tue, 09 May 2023 04:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683630665; x=1686222665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vkk5DCy0z8eSEQJVhraU0gyt2AdUF96RHlpvGnmt4l8=;
        b=jWHqrlv1baM2RFyMyWnFWvRvQzJwzy1tI//qEiBRlo7NtLAkNSSADCHP1qXq2HKOXw
         4ylVczxZLkaVP5CHkls7q1hHxLD9XQlHp2eObYN2YwWNBhhumPVdMc60Fe0yZcD+TBKL
         fATB2lmJZK+t/B+KdFaQ1eBX7oo6DrSMhiRAegBaPghSGt9y0PI8jusxxywFJA8/XEG0
         UUD/6hRxCrT7bNkKCmwmb53CsaiENjSM4KedxejCfcAE3JmR3Ga7lj0MWT9W5Wsp89fr
         AINQdsIMhgWTgeVny665E9o666cv3Fu3un2KgJ0M9BzavlnFZq2WM71Uxia4rsnaA1oA
         QtEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683630665; x=1686222665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vkk5DCy0z8eSEQJVhraU0gyt2AdUF96RHlpvGnmt4l8=;
        b=Dslc9sb364JzxYm9DwEEGLyeKU7motWZD0C2dayjPzjAxGekd1dsEc+SqzbZOgyWmh
         /mcbWaXA6jBdTvpAUfN7exl2Fsrav5QOip5irR4gjx+HhpRlNp9h405QL+WaWLHvP2iM
         ybt4J8iKNDdmKReskY4VP7zy5nMiFu5IKL7RFhUsRLH+FE8ovvPO1+gF7q2JoeZ94FJC
         JyawvSuGWuk34wpEQL3tt57wlI1BF9vgdlVSbvey/i6R0NX7SuI/chEz+hEJV3w1MXwF
         KOAV6zq3beIZCl4pj4g4KYeALjKm3vqm2OtCUccPNRLZye9PYx1QrXYFlymBU9ISQVDx
         uCpA==
X-Gm-Message-State: AC+VfDz0t/rta0goOpCAzrPH8MfZQkzR4EYuIlm+/vCRbIvDwE6m1DZ6
	CWaYlqoKbfIFrC2F0ZjAND0VNg9cT5DjytlMD4g=
X-Google-Smtp-Source: ACHHUZ6F9VU8XtGo+n2aInAJWRWYS2JnkqgFQhs0oZ9WPnE+YhEjkUNoi+ZYf4bu9RXqyJMqktr3zZL0nifP5dHX+xo=
X-Received: by 2002:a25:2d4:0:b0:b9e:7896:63a0 with SMTP id
 203-20020a2502d4000000b00b9e789663a0mr14839271ybc.54.1683630665536; Tue, 09
 May 2023 04:11:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230508124701.443ba331.gary@garyguo.net> <20230509080700.1608146-1-aliceryhl@google.com>
 <2023050937-scouring-truck-d7c0@gregkh>
In-Reply-To: <2023050937-scouring-truck-d7c0@gregkh>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 9 May 2023 13:10:54 +0200
Message-ID: <CANiq72=g=CnEQTkc50qozUdOBZECr7Jr2NCRfGFaKh751i6Sww@mail.gmail.com>
Subject: Re: [PATCH v2] rust: error: add missing error codes
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Alice Ryhl <aliceryhl@google.com>, gary@garyguo.net, alex.gaynor@gmail.com, 
	benno.lossin@proton.me, bjorn3_gh@protonmail.com, boqun.feng@gmail.com, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 9, 2023 at 10:46=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> It depends on which arch you are building for.  That's why we have
> per-platform errno.h files, the values are different for different ones.
> So you need to handle them all properly somehow.  How is rust going to
> handle per-arch stuff like this?

We can do conditional compilation in the same file, possibly with a
Rust macro which takes a nice table that shows all arches at once.

We can also split into files like C and move it to each `arch/`, there
are a couple of approaches for this. This is best for `MAINTAINERS`,
although these headers almost never change, so it is not a big
advantage.

We could also automatically do everything based on the C headers, too.
Back then it felt to me like too much complexity for little gain,
given those C headers almost never change, but now it may be worth it.
Or, instead, having a test that verifies they are the same instead,
and that way we don't introduce complexity for the build itself.

Alice only needs `ERESTARTSYS` so far, as far as I understand, so
perhaps it is simplest to only add the rest of the non-generic ones
for the moment; and gather opinions on the approaches above meanwhile.

Cheers,
Miguel
