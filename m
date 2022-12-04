Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5133C3F
	for <patches@lists.linux.dev>; Sun,  4 Dec 2022 17:36:20 +0000 (UTC)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1433ef3b61fso10984690fac.10
        for <patches@lists.linux.dev>; Sun, 04 Dec 2022 09:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TXEZvr3bKu2vBIW+lpuSVItbWZwpWlZ50nx9XuTinWU=;
        b=K5E0+LOnggn/gYMPFlw4zI4PSzD+JHSdGy4UU6wttfDL2DlzF3ueIgIOWR7oRXgHct
         xh9/3Brq5EmMilnZRjlVNdphsZo4PWHbyyb/k6XiLdDRWtE6JynFvaohTeAc9fSEii3/
         O/cJm1NIlZq/KdCpD/QjSgbxheAoTFj8fsV9nL/J0zC0HAwKKezkr0ZseQAaU0n9/BBJ
         xMdieALMDasrbQlarT2uBdq5jLLcve65SIkefFLHCVyhwxyGzH4ePF+6ikpWycWuWATh
         XP5BoyplLSdQ/zWMjnzqnSv5Vl3OeM3M9Lsn+L0yP14j8Ftd9RDrKoOmoHz0LwrkqcoQ
         AIDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TXEZvr3bKu2vBIW+lpuSVItbWZwpWlZ50nx9XuTinWU=;
        b=baq9QkT/D+9IHAJhvkIXKBPC8GYLP4U3kV5UIb4OIidfkTlEtQK466lVGcIJGvEJTb
         lEIwbCAwT9iaAjMdPhPLGI7TXHsdQizDmJlcZur0AFNg1IcA0O1LDf92uRZclJOau0hx
         wwU2s6hjZt9JjLcZSHqno/g/lXtB8xe+6MrKgYEnFqkPBqYSYbPDt4RS1cmg7UX30frQ
         kWsLk3X2RQHZJL5SIQVjzvgGgQWXj9JyoD8gSbEPqOgxCjANICdvecUwdxr6zxAWY2Dj
         ijTqFNuevDOajXWRiQ6se79tsAjKV1rQFR3buS80LMKbABTQAxAjR91N5x3X8wTDnX0X
         Y2Yg==
X-Gm-Message-State: ANoB5plB1i/dQ64QRI/IENpHuxWLFkZqmbslgkj/4jBIpOK+3OD77Ttj
	20vHFeeTq2HenViV/4FHZYGjuoo+l0aZ3keCRG4=
X-Google-Smtp-Source: AA0mqf5xGkkp4TyK3rNiEGg6B2v4wlLttK5ZifOyxNPE9HKBFN7/u15rFv7uwOIrxKmrz2YDbDeQ4YFqtbIlts4XwsA=
X-Received: by 2002:a05:6870:6c02:b0:143:80af:e36a with SMTP id
 na2-20020a0568706c0200b0014380afe36amr22895324oab.254.1670175379350; Sun, 04
 Dec 2022 09:36:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221202161502.385525-1-ojeda@kernel.org> <20221202161502.385525-28-ojeda@kernel.org>
 <Y4qNR+Nn9utDftHq@localhost> <20221204103153.117675b1@GaryWorkstation>
In-Reply-To: <20221204103153.117675b1@GaryWorkstation>
From: Wedson Almeida Filho <wedsonaf@gmail.com>
Date: Sun, 4 Dec 2022 17:36:08 +0000
Message-ID: <CANeycqpNW0E5fQqD1Qzqr0p-3cgs5k5KgLusragaSWbrmcx2Nw@mail.gmail.com>
Subject: Re: [PATCH v2 27/28] rust: types: add `Either` type
To: Gary Guo <gary@garyguo.net>
Cc: Josh Triplett <josh@joshtriplett.org>, ojeda@kernel.org, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wei Liu <wei.liu@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 4 Dec 2022 at 10:31, Gary Guo <gary@garyguo.net> wrote:
>
> On Fri, 2 Dec 2022 15:41:59 -0800
> Josh Triplett <josh@joshtriplett.org> wrote:
>
> > On Fri, Dec 02, 2022 at 05:14:58PM +0100, ojeda@kernel.org wrote:
> > > From: Wedson Almeida Filho <wedsonaf@gmail.com>
> > >
> > > Introduce the new `types` module of the `kernel` crate with
> > > `Either` as its first type.
> > >
> > > `Either<L, R>` is a sum type that always holds either a value
> > > of type `L` (`Left` variant) or `R` (`Right` variant).
> > >
> > > For instance:
> > >
> > >     struct Executor {
> > >         queue: Either<BoxedQueue, &'static Queue>,
> > >     }
> >
> > This specific example seems like it would be better served by the
> > existing `Cow` type.
>
> We use `no_global_oom_handling`, which gates most `ToOwned`
> implementations (e.g. `str` cannot implement `to_owned()` because it
> cannot guarantee allocation success).
>
> So the Rust `Cow` is pretty much useless in the kernel.

It's also implemented in `std`, which the kernel doesn't include.
(Which is actually good for us, since we can't really use it.)

Josh, how do you feel about adding a `TryToOwned` trait to
`core::borrow`? This would be similar to the precedent of `TryFrom` in
addition to `From` for the fallible case, and would be usable by the
kernel.
