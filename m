Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1A614281
	for <patches@lists.linux.dev>; Fri, 13 Oct 2023 12:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bqsrch2v"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-991c786369cso327856466b.1
        for <patches@lists.linux.dev>; Fri, 13 Oct 2023 05:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697199483; x=1697804283; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kfMcaSPK1nNALi0ZL2/STHAwFBjikJyI73GljAs8CFY=;
        b=bqsrch2vNEmYdIETJQyJ+lviXtTUlTMnt8LTfkCHWgNgffqq5FblRIfcUsvS6Q9u5M
         LFeP7jUhx1le/HR4nDNp6HjJ8KQxKqWTDYaIXJOUlB3GKT8MuLi4apofohTSH1Ah5X5J
         uqQxEqYbgWD4c/jMVCd+U4TuZabSosw74nHhnR8FSScS+N3ZXf8EWqc2UKBHQ6ga4WIt
         9oZudraI93cJJO8UcPqRHkDgoR4EoE2MQxPJv96sgCBitz6qioi4G7k4t+fWg6yPfyh3
         r+5GdLQycfvUqV1WuMZepY/RN/TLhtB6axtbWpYO6Rh56fdykmi5xCfs7YGbYMfZeeTs
         4PCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697199483; x=1697804283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kfMcaSPK1nNALi0ZL2/STHAwFBjikJyI73GljAs8CFY=;
        b=rVDjd5cA+7JiEafP42XdN5neFfuCDc7nuRHk2J1QUd1EBRHw3+0RiLprVN+N8ltqhs
         qmZP1rY86Ou+rOcWOa3SRtYVYVPWYa6OH6JkAawbJk2LWQxulnr2TrZ6iDyXRIvVhdxn
         C33aFEo3I0s801Xjt9ab1bgkB9OXS6nfGVFNERlSBlu75bKpB49yGUDhSP5TQMHcYmv2
         kxzhtDTbJ02Og17Hgk2nkQZmvwwOSABCd9tirqDAWz1XkvE7b8dEdCPHrWGuG+qcWKaf
         mdYNijFleM6u/qh9JU6Q+vkP2yIBni6+tDL8kSzsWpT8SC8vRlYqcKOJfR9DmzSYMjDv
         gf8w==
X-Gm-Message-State: AOJu0YxQ5bhOWd2syPl3f4U7Q3jIW6HZt/oIA+INJ+2mvFebHXa6M9jB
	74Qc/hp0T1hRMXDSfqC82O905bxKptyfLRoIylOGUg==
X-Google-Smtp-Source: AGHT+IGQJ9SEIC8vE0aqfRJOcMNPn+seOjJOdw/SPreQJQAaFkIsSMzyhkSV+UwdtrZcN9HIBGcHUUvxmzb9X/Yth+w=
X-Received: by 2002:a17:906:fe07:b0:9bd:e036:387d with SMTP id
 wy7-20020a170906fe0700b009bde036387dmr587057ejb.21.1697199483200; Fri, 13 Oct
 2023 05:18:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-26-ojeda@kernel.org>
 <Y0BfN1BdVCWssvEu@hirez.programming.kicks-ass.net> <CABCJKuenkHXtbWOLZ0_isGewxd19qkM7OcLeE2NzM6dSkXS4mQ@mail.gmail.com>
 <CANiq72k6s4=0E_AHv7FPsCQhkyxf7c-b+wUtzfjf+Spehe9Fmg@mail.gmail.com>
 <CABCJKuca0fOAs=E6LeHJiT2LOXEoPvLVKztA=u+ARcw=tbT=tw@mail.gmail.com>
 <20231012104741.GN6307@noisy.programming.kicks-ass.net> <CABCJKufEagwJ=TQnmVSK07RDjsPUt=3JGtwnK9ASmFqb7Vx8JQ@mail.gmail.com>
 <202310121130.256F581823@keescook> <CAOcBZOTed1a1yOimdUN9yuuysZ1h6VXa57+5fLAE99SZxCwBMQ@mail.gmail.com>
 <20231013075005.GB12118@noisy.programming.kicks-ass.net>
In-Reply-To: <20231013075005.GB12118@noisy.programming.kicks-ass.net>
From: Ramon de C Valle <rcvalle@google.com>
Date: Fri, 13 Oct 2023 05:17:50 -0700
Message-ID: <CAOcBZOTP_vQuFaqREqy-hkG69aBvJ+xrhEQi_EFKvtsNjne1dw@mail.gmail.com>
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, 
	David Gow <davidgow@google.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 13, 2023 at 12:50=E2=80=AFAM Peter Zijlstra <peterz@infradead.o=
rg> wrote:
>
> On Thu, Oct 12, 2023 at 03:15:12PM -0700, Ramon de C Valle wrote:
>
> > [1]:
> > https://doc.rust-lang.org/nightly/unstable-book/language-features/cfi-e=
ncoding.html
>
> I'm sorry, but that looks like a comment from where I'm sitting :-(
> Worst part is it being on a line of it's own and thus unrelated to
> anything.
>
> This rust syntax is horrific..

I understand where you're coming from. I'm still getting used to Rust synta=
x.

>
>
> > [2]:
> > https://doc.rust-lang.org/book/ch19-04-advanced-types.html#using-the-ne=
wtype-pattern-for-type-safety-and-abstraction
>
> I don't speak enough rust to even begin following this :/
>
> > [3]: Wrapping a type in a struct should achieve something similar even
> > without using the cfi_encoding attribute since the encoding for structs=
 in
> > both are <length><name>, where <name> is <unscoped-name>.
>
> You're not talking about C, right?

Both C and repr(C) Rust structs have this encoding, but I understand
the problems with doing this in C since it doesn't have
repr(transparent) structs so there would be a lot of casting back and
forth. Maybe there is an alternative or this could be done for less
used function pairs?
