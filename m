Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80810361
	for <patches@lists.linux.dev>; Fri, 14 Oct 2022 20:39:14 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id y17so3116145ilq.8
        for <patches@lists.linux.dev>; Fri, 14 Oct 2022 13:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I2M60nT7NfeWvq3ak/v2N3tIFMmZCLJVdqTc5cp8Xpc=;
        b=I6gJ7IskSZPiBU2Q1TJQ/Ma8kXejg9qi55V3Fj3QjHitxLeEFVvxRHJKmVHr0ybmsa
         f/lZP+Hu09gLoanlzOEODO+n2BYlRnaH34wyfBfPdi5SK3GYcAEu4iA16NGLd9ldm1z7
         EtC3SFQVRv6fTuSO2v0suM81LDqojTi3sGZijXCQyPAA7G5t6DqZhevJQzEojdIulVeX
         cKfQ0q189mU7qF/E/AJvsfiCMGt1uNfpu/0jTQ+kCmVwuelcvwFo/pChdW3RIHkP4/vT
         KQFpsa74fuk/qxuArQ+wdfWDF8QEKhv5ElHGOx7224IC8RlSBoCN/FwsXSMC+xUjgi9u
         e4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I2M60nT7NfeWvq3ak/v2N3tIFMmZCLJVdqTc5cp8Xpc=;
        b=HKDj0YrbtcwUSr2wxhPEGDXRzRSZHU8US+k5NYIptclAU0AEbwp3S281HrBuhxJIKF
         62/nDN/fqt70qf1Q2awI1P7+CV7yyLABp28LVlHNq9x0ZxBH/UHoP4H61v5Tu1jdW56f
         R5LI/RVUo2EroDyb/fGkskURvkZdNdQvaJLbDKMHznvRiNlin2RhAfEXrs+x2Lm0dqW8
         soCvaO+7WEbr5+yxRPDClBD9u3tzhW0l/PdRPKlVXZ25VAXEvOLJGKR+VpVjdg3hbt9k
         RSG9pPOnDbqy6QihXvQiwbxiISrK7PHFP8hXSpkNnSejPU99ho+i2guudLfEvLHEV4ij
         8wcA==
X-Gm-Message-State: ACrzQf2Jr8hfd0uapnyeTLXsTJAFv1dnfjQaTDxHHWvVtmqRE6Ds4Mnr
	CLEAQ8C7wqtcd1G//U8bzPQ2wjUEhge1s27yny8=
X-Google-Smtp-Source: AMsMyM5Can0Irp9kFx+wv2SRI++DMRnZHKowIIiuGGnnpb0qry9EybjOc3WUqIfJNblWZVVzNAta514Kg7Ydywu2Kts=
X-Received: by 2002:a05:6e02:1aab:b0:2fa:80c2:8375 with SMTP id
 l11-20020a056e021aab00b002fa80c28375mr3419698ilv.72.1665779953595; Fri, 14
 Oct 2022 13:39:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-26-ojeda@kernel.org>
 <Y0BfN1BdVCWssvEu@hirez.programming.kicks-ass.net> <CABCJKuenkHXtbWOLZ0_isGewxd19qkM7OcLeE2NzM6dSkXS4mQ@mail.gmail.com>
 <CANiq72k6s4=0E_AHv7FPsCQhkyxf7c-b+wUtzfjf+Spehe9Fmg@mail.gmail.com> <CABCJKuca0fOAs=E6LeHJiT2LOXEoPvLVKztA=u+ARcw=tbT=tw@mail.gmail.com>
In-Reply-To: <CABCJKuca0fOAs=E6LeHJiT2LOXEoPvLVKztA=u+ARcw=tbT=tw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 14 Oct 2022 22:39:02 +0200
Message-ID: <CANiq72khuwOrAGN=CrFUX85UmPdJiZ2yM7_9_su_Zp951BHMMA@mail.gmail.com>
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, rcvalle@google.com, 
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

On Fri, Oct 14, 2022 at 8:35 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> Thanks, Miguel. I also talked to Ramon about KCFI earlier this week
> and he expressed interest in helping with rustc support for it. In the

Ah, that is great to hear -- thanks a lot to you both! (Cc'ing Ramon)

> meanwhile, I think we can just add a depends on !CFI_CLANG to avoid
> issues here.

ACK, thanks -- if you want to send the patch, please feel free to do so.

Cheers,
Miguel
