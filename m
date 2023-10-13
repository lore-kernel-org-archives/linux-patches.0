Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9F121A0A
	for <patches@lists.linux.dev>; Fri, 13 Oct 2023 19:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="exC4QrRo"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-9ba1eb73c27so403550566b.3
        for <patches@lists.linux.dev>; Fri, 13 Oct 2023 12:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1697224940; x=1697829740; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yMlHIs+RXRwcCam9b7W7YcpdMJXw0XO1+U1rinkBh7Y=;
        b=exC4QrRoeOAxLMoQ0KAJhgvEBqX4GZCIkOnOukctLun47TFnz8ZSkPBBpr5KlCWZcA
         9gdYKBWungHHr8sAXN/GjUTH3RY3sgMvlgLUG67l6YagGkC1CGaqzBwetLM8YhUjRZnT
         Zc6HYtXJKe+2f3+9oOwiQCSOZ4/G0//j1jjTI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697224940; x=1697829740;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yMlHIs+RXRwcCam9b7W7YcpdMJXw0XO1+U1rinkBh7Y=;
        b=tMWzAEd+MJFo7MgCmb5QrLEGGCU4nCCBdJMCybO0p0Rv76EDJaEYnnZwS01dooXxkd
         j602THmkjyv8xLTCmHGlHnVPcqH5Xit8vBRzXfSoOvqo9BiXrGmHaFIL23WxSyslA6EX
         rbfrTz6zLlux0aNMBSlHVdYnVFmsmtnB6j1Se/iHAe0e3mnnaDOefRmdkG1CJku+CAkH
         4a7r+y2RP60W4Kl2SVzyF4MN2P6yEseKxAALWNpouKKztZ8RmMupA3bru1rvWA2Ku56J
         EuhfVYChCD3g2IHmOBUrB6mzNT7c8H7WiTVQ8YFeE4lSW2syA9vL1vxg9h+vIg6j71bS
         Lovw==
X-Gm-Message-State: AOJu0YyanVM9DCMKCCNKZ4889sVcoqu2gIblxNoj4u6K30wA+aKIoiZi
	7wyzrU1roo7p4r1j+Z6olDwS8MhXsC7bVwsHOfHtvJuX
X-Google-Smtp-Source: AGHT+IHlinxZcZLi0SbE8fCODmnOtly5R35apnKV8ugShIZzDyayp/9xXCYXWtkNs77jIcJrBhRYzg==
X-Received: by 2002:a17:907:1dd2:b0:9ae:406c:3425 with SMTP id og18-20020a1709071dd200b009ae406c3425mr25872408ejc.0.1697224940604;
        Fri, 13 Oct 2023 12:22:20 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id lz11-20020a170906fb0b00b009b97521b58bsm12776397ejb.39.2023.10.13.12.22.19
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Oct 2023 12:22:19 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-9a6190af24aso407534166b.0
        for <patches@lists.linux.dev>; Fri, 13 Oct 2023 12:22:19 -0700 (PDT)
X-Received: by 2002:a17:907:7790:b0:9b9:facb:d950 with SMTP id
 ky16-20020a170907779000b009b9facbd950mr17575861ejc.72.1697224939431; Fri, 13
 Oct 2023 12:22:19 -0700 (PDT)
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
 <CAHk-=wjLUit_gae7anFNz4sV0o2Uc=TD_9P8sYeqMSeW_UG2Rg@mail.gmail.com> <5D8CA5EF-F5B0-4911-85B8-A363D9344FA7@zytor.com>
In-Reply-To: <5D8CA5EF-F5B0-4911-85B8-A363D9344FA7@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Oct 2023 12:22:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiiBpw-0MKBbPkvo54=Cvyi0b3_1bDtqbgiD4ixd+OPow@mail.gmail.com>
Message-ID: <CAHk-=wiiBpw-0MKBbPkvo54=Cvyi0b3_1bDtqbgiD4ixd+OPow@mail.gmail.com>
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ramon de C Valle <rcvalle@google.com>, Peter Zijlstra <peterz@infradead.org>, 
	Kees Cook <keescook@chromium.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, 
	David Gow <davidgow@google.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Oct 2023 at 12:01, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Transparent unions have been standard C since C99.

Ahh, I didn't realize they made it into the standard.

In gcc, they've been usable for a lot longer (ie --std=gnu89 certainly
is happy with them), but the kernel never really picked up on them.

I think they've mainly been used by glibc for a couple of functions
that can take a couple of different types without complaining.

           Linus
