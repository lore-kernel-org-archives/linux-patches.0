Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1422F5B
	for <patches@lists.linux.dev>; Fri, 14 Oct 2022 18:35:09 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id sc25so12250833ejc.12
        for <patches@lists.linux.dev>; Fri, 14 Oct 2022 11:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dlOttIcbfyJ9Meuwl/3DVPLPY7LTZL8V6KpgIWHa/o8=;
        b=bo+sSeamjV3ogFeVE4woZcjggXzUoZaHSUx6jp0WPOZzpXDNmcc/cEcYdKtM48zH7e
         Q8hrssyWU3nff+vqi1+2UwgCpwkQ9mNZwhoxtCYtoyOImHoU6sr2EgS5FSVJHeHv72Gx
         ivMoH1EYL5oEpkIYp3Altv+OuFDnh25XvMft3oq6CAX7Lg1bHdcRUDF5uanM4EvvYYLH
         ScOMwLnABxganJ5jJ69lPKPQm06FeCCSHiH114ov0w+bi1KMynXHAw6J/ybjpBOkwQ60
         Njc0xgYtm7geqQcvVxY6MqZQHxUA67w1M6uCS77zWiYeNi3Td5G/+xAI/uKs52rqfCAx
         VPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dlOttIcbfyJ9Meuwl/3DVPLPY7LTZL8V6KpgIWHa/o8=;
        b=rY+ReMrxSeuHrWKVlvdkw6PDY0Na9vsJbGZ5Xztct8PuvR1ylgqIq+H0GOCxZJKtik
         nAbN4sj/wIHWwZWpp553hDsKxEpwQPv6YDAA18+lDeN36fnV+STgAaeMv+GseAfNx/hM
         rsrbOjq3Ce+qw9p2wtjFBTrdM3+mWZ3q4mQ1juh9FtIcjn6NW1YBy9AX3V5ff331qmZq
         cC1HnaM0bcX1l0TaxaYVOr8O1Q1L6DlNR+qb+VWCe0gi3XziSYn/RZsAv9fYPDA1icE3
         IW17FDGH9eFIo1QDpxyQBDdv7mG45rojfwE2f2A7zZNpeqZEUrX3ULzBlYL+Ujj8VoOp
         EHiA==
X-Gm-Message-State: ACrzQf2cU8mekdv90BWvBZzfjFvUXnDFlaR3X4MvuFGyIA53h3oMxXI7
	hXLmwAQGNquly+bS1QBGYMl0UAJMk00BEV1Jjl03+A==
X-Google-Smtp-Source: AMsMyM5PxvI7q1eLhIz1kRuPl4pgKS5NxzGTkhgVaLLpKkixQpMznDKsv3NsRyMn7CuF+C/HYyOrjzaNom7zJdwX7EI=
X-Received: by 2002:a17:907:e93:b0:78d:46ae:cf61 with SMTP id
 ho19-20020a1709070e9300b0078d46aecf61mr4483765ejc.579.1665772507710; Fri, 14
 Oct 2022 11:35:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-26-ojeda@kernel.org>
 <Y0BfN1BdVCWssvEu@hirez.programming.kicks-ass.net> <CABCJKuenkHXtbWOLZ0_isGewxd19qkM7OcLeE2NzM6dSkXS4mQ@mail.gmail.com>
 <CANiq72k6s4=0E_AHv7FPsCQhkyxf7c-b+wUtzfjf+Spehe9Fmg@mail.gmail.com>
In-Reply-To: <CANiq72k6s4=0E_AHv7FPsCQhkyxf7c-b+wUtzfjf+Spehe9Fmg@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 14 Oct 2022 11:34:30 -0700
Message-ID: <CABCJKuca0fOAs=E6LeHJiT2LOXEoPvLVKztA=u+ARcw=tbT=tw@mail.gmail.com>
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, 
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

On Fri, Oct 14, 2022 at 11:05 AM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Tue, Oct 11, 2022 at 1:16 AM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > Rust supports IBT with -Z cf-protection=branch, but I don't see this
> > option being enabled in the kernel yet. Cross-language CFI is going to
> > require a lot more work though because the type systems are not quite
> > compatible:
> >
> > https://github.com/rust-lang/rfcs/pull/3296
>
> I have pinged Ramon de C Valle as he is the author of the RFC above
> and implementation work too; since a month or so ago he also leads the
> Exploit Mitigations Project Group in Rust.

Thanks, Miguel. I also talked to Ramon about KCFI earlier this week
and he expressed interest in helping with rustc support for it. In the
meanwhile, I think we can just add a depends on !CFI_CLANG to avoid
issues here.

Sami
