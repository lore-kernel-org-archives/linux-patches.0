Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CEA36B06
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 16:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LuSCz2KF"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so19129a12.0
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 09:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696867271; x=1697472071; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zy5f8ORtjUWrgt6sYe3zAtjW8P0Slkj5alaIenUuvkA=;
        b=LuSCz2KFHlb7/SUb781A+y3eH5ySFbYRui0YN6dlkVPWSavVlP5V40BDRwzbRac0Qf
         jc/n1M7mhKT7knLXGdWbo1bqcS7Au7XcynM/nhAoqd8AuYD2peJ4ZyutHTFkHY+qf8fq
         WodP6PiXnNnO2vUEp0AtD0JMhdszsL+gkuqe2ti9BLdwNsPd521qCGbj1o09vk5QIVGf
         Y7yMyVHlKfgwZxhyiaW7+6kbUQtrE4Yn4HQ+6v8NCR/4xgEnOl/ZsZQerSVii8umZG4D
         Wji4vvTTyXMU5ANeD3CJvTUQ5XPskGQIe/BNloGBe7shVuUf9WgKmg0u9kcVQ0sxuaZt
         F7ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696867272; x=1697472072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zy5f8ORtjUWrgt6sYe3zAtjW8P0Slkj5alaIenUuvkA=;
        b=bxxZPUgGDP8Gv1FiwjTgZIdoxlhs96+Q+bEEzKHv8zByyP2nSnJSsxWM/B9x+8TUBQ
         W9NPyth4QdAYHTN6kiL4ojGLz/LZQ3UQvRDawwS5bPIv3hm1O7O2+UmwNznZJB8/Y0L4
         EcNKk63DJ8R2k2Z2QokAxSgRbhe7Rhb0ocKBC+MVftyA3ISDFfOoo8PBgaXhGd++htV/
         oyQyHk6EQyxjMiNcOp4wSIzqxvzGSDu3DcbYmzCcBFu5lAUlzRrMgmAzC5+/ejQlZyDy
         dgDaocmLt+QLYX+fqUKIWB5qVvxL4cVp3U2CLMu8W7WNabwGuUuaXCqjVqX3o8CwHPr9
         OfrQ==
X-Gm-Message-State: AOJu0YwBe0pfL3hhdXOCFrMBsUs8MaTbv29N9TrKZjTxQ4Bhvgzx4d6m
	HOjG4R3H1tHCZvpNEdgoFLivcYgrkA44Pap4uR1qUw==
X-Google-Smtp-Source: AGHT+IHMBy+3dUtNsP01KGzd8vcaNjxx/WJQdaZekS0DI0TUctsOfctSoMaVeTw3eiPY4I0DEmZh1AWM2/zlPyQ93IQ=
X-Received: by 2002:a50:9fa4:0:b0:538:5f9e:f0fc with SMTP id
 c33-20020a509fa4000000b005385f9ef0fcmr404150edf.0.1696867271482; Mon, 09 Oct
 2023 09:01:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-26-ojeda@kernel.org>
 <Y0BfN1BdVCWssvEu@hirez.programming.kicks-ass.net> <CABCJKuenkHXtbWOLZ0_isGewxd19qkM7OcLeE2NzM6dSkXS4mQ@mail.gmail.com>
 <CANiq72k6s4=0E_AHv7FPsCQhkyxf7c-b+wUtzfjf+Spehe9Fmg@mail.gmail.com>
 <CABCJKuca0fOAs=E6LeHJiT2LOXEoPvLVKztA=u+ARcw=tbT=tw@mail.gmail.com> <CANiq72khuwOrAGN=CrFUX85UmPdJiZ2yM7_9_su_Zp951BHMMA@mail.gmail.com>
In-Reply-To: <CANiq72khuwOrAGN=CrFUX85UmPdJiZ2yM7_9_su_Zp951BHMMA@mail.gmail.com>
From: Matthew Maurer <mmaurer@google.com>
Date: Mon, 9 Oct 2023 09:00:58 -0700
Message-ID: <CAGSQo00gJsE+mQObeK4NNGDYLpZDDAZsREr15JcjD8Fo0E4pkw@mail.gmail.com>
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Peter Zijlstra <peterz@infradead.org>, rcvalle@google.com, 
	Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@google.com>, David Gow <davidgow@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have a patchset enabling support for both KCFI and IBT in the
kernel, but it uses changes not yet landed in stable rustc, which is
why I haven't sent it to the list yet:
https://github.com/Rust-for-Linux/linux/pull/1034

We've backported the changes to rustc that need to be present onto the
Android copy of the compiler, but it will take 6-12 weeks for them to
hit stable rustc, which is what general Linux is using.

If the IBT part would be helpful by itself immediately, I can split
that out - it's only the KCFI portion that won't currently work.

On Fri, Oct 14, 2022 at 1:40=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Fri, Oct 14, 2022 at 8:35 PM Sami Tolvanen <samitolvanen@google.com> w=
rote:
> >
> > Thanks, Miguel. I also talked to Ramon about KCFI earlier this week
> > and he expressed interest in helping with rustc support for it. In the
>
> Ah, that is great to hear -- thanks a lot to you both! (Cc'ing Ramon)
>
> > meanwhile, I think we can just add a depends on !CFI_CLANG to avoid
> > issues here.
>
> ACK, thanks -- if you want to send the patch, please feel free to do so.
>
> Cheers,
> Miguel
