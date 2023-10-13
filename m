Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA941CF8C
	for <patches@lists.linux.dev>; Fri, 13 Oct 2023 18:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bXilsNZM"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-9be3b66f254so34308666b.3
        for <patches@lists.linux.dev>; Fri, 13 Oct 2023 11:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1697223305; x=1697828105; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vTnCuQhHu4vMJ5ozMAEPYZByiFfPswag7KkaGVloQKk=;
        b=bXilsNZMeLN/83iYugfEkIMMzrvAQ6OG963gIdsn7/2WezF7w0oHWXu2Sg44+QmaaA
         gJ/9Rs3UjvWCTaQ2HRX63Jlc22vq5gumKTBOjMbQqoFkQNB4e0w9qzePO7KGzmNdZdhh
         pfiIjfKh5FQ7gJOlQfcIgV0YGgoNw05+9WdC0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697223305; x=1697828105;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vTnCuQhHu4vMJ5ozMAEPYZByiFfPswag7KkaGVloQKk=;
        b=e112QFcXn8JbAtE32EjaAN0YIf5NEC95QQDW36CAs909bpuiH5s8kpkj1MqQMR9/O4
         s6fM7e0GskCzraB+6lBo54fqgLBXo7QGc8eUotlreOH8n7HrPR3CVZeAO/NWRo23wjqD
         4HKZ8YDVGVpVIoBhp6RpcNZDa7jDEbnf2YXeiMzjkPGM0oYiafnnLuVeC8gYNKfJa/CT
         OyfGmKSEcdfsH8JIw4PfYjppz6QsophoFQJG64KO0jAOEcsIHcOeadIP45pBCuecu+Se
         OKmfd7ZYUGGPZkGSk0SVcw1wGyJpltVxYLka3Wukwx4/CJoSXwWSdI7wzdubD6HATDWb
         BxvQ==
X-Gm-Message-State: AOJu0YyIKclxnowfWGj3boh+LQ7lFqmGuh+3/qXtSfJm2fKtgL755LHT
	LSQB0m2OqZ061JlQvrklRUMFPwq5pXaaou13Hmb54w==
X-Google-Smtp-Source: AGHT+IEwLp8+QWRjJWcqaO/tiBaxtnsrW3NvnhVsmeW7xRGUW7ulia2S6ej3VKiuQ/nDkUOChWOU4A==
X-Received: by 2002:a17:906:cb:b0:9aa:338:4a0f with SMTP id 11-20020a17090600cb00b009aa03384a0fmr23595796eji.72.1697223305404;
        Fri, 13 Oct 2023 11:55:05 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a6-20020a170906468600b009a5f7fb51dcsm12592578ejr.42.2023.10.13.11.55.03
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Oct 2023 11:55:03 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-9b64b98656bso385345766b.0
        for <patches@lists.linux.dev>; Fri, 13 Oct 2023 11:55:03 -0700 (PDT)
X-Received: by 2002:a17:906:2189:b0:9ae:6ad0:f6db with SMTP id
 9-20020a170906218900b009ae6ad0f6dbmr23995223eju.71.1697223303355; Fri, 13 Oct
 2023 11:55:03 -0700 (PDT)
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
 <20231013075005.GB12118@noisy.programming.kicks-ass.net> <CAOcBZOTP_vQuFaqREqy-hkG69aBvJ+xrhEQi_EFKvtsNjne1dw@mail.gmail.com>
In-Reply-To: <CAOcBZOTP_vQuFaqREqy-hkG69aBvJ+xrhEQi_EFKvtsNjne1dw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Oct 2023 11:54:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjLUit_gae7anFNz4sV0o2Uc=TD_9P8sYeqMSeW_UG2Rg@mail.gmail.com>
Message-ID: <CAHk-=wjLUit_gae7anFNz4sV0o2Uc=TD_9P8sYeqMSeW_UG2Rg@mail.gmail.com>
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
To: Ramon de C Valle <rcvalle@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev, 
	Jarkko Sakkinen <jarkko@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@google.com>, David Gow <davidgow@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Oct 2023 at 05:18, Ramon de C Valle <rcvalle@google.com> wrote:
>
> Both C and repr(C) Rust structs have this encoding, but I understand
> the problems with doing this in C since it doesn't have
> repr(transparent) structs so there would be a lot of casting back and
> forth. Maybe there is an alternative or this could be done for less
> used function pairs?

We actually have some C variations of what I think people want to use
"repr(transparent) struct" for in Rust.

Of course, that is depending on what kind of context you want to use
it for, and I might have lost some background. But I'm assuming you're
talking about the situation where you want to treat two or more types
as being "compatible" within certain contexts.

There's the actual standard C "_Generic()" alternative, which allows
you to make macros etc that use different types transparently.

It's not very widely used in the kernel, because we only fairly
recently moved to require recent enough compiler versions, but we do
use it now in a couple of places.

And there's the much more traditional gcc extension in the form of the
__attribute__((__transparent_union__)) thing. In the kernel, that one
is even less used, and that one use is likely going away since the
need for it is going away.

But while it's not standard C, it's actually been supported by
relevant compilers for much longer than "_Generic" has, and is
designed exactly for the "I have a function that can take arguments of
different types", either because the types are bitwise identical (even
if _conceptually_ not the same), or simply because you have a
different argument that describes the type (the traditional C union
model).

I suspect, for example, that we *should* have used those transparent
unions for the "this function can take either a folio or a page" case,
instead of duplicating functions for the two uses.

But probably because few people aren familiar with the syntax, that's
not what happened.

             Linus
