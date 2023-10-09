Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1691A701
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 16:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X5HSxGi0"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-5a7ad24b3aaso4990387b3.2
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 09:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696869085; x=1697473885; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eze8ie+K0Fy5Qmq0xuinAFfSz+bncxmLAfx+2FZzmLY=;
        b=X5HSxGi0lOfxKhFE1uJsuWHSKUD6hDZSlqjhAHHD277AKFFvBWfpDP/0qpy7VL32I7
         RD1mgnGdB0vkWgsqEsTE9ZtdJvolL0uzXXAlUrLZIt2MWBSMFLRm46X5YpTb7L6Yiv7u
         fZgl46GoEpxgdAfCOcJUj6QJz+w60nUJdN/wm6VRyolQMtxtfniQSy0hiOb9ney8Y301
         OcaQkBjWrGYn3P74TafiEDKGyeEHrnOJ/7nQM2QJNiqe4r8iArLczhI3NLVrS50xogxT
         oa2hf/mIVlEknMQ0NESXMCUBG6vmI7/CKiATuGAllsak67Mj8of+X9UD+uxtRocQ2tEz
         PRaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696869085; x=1697473885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eze8ie+K0Fy5Qmq0xuinAFfSz+bncxmLAfx+2FZzmLY=;
        b=FGPwS11b0DdMeDsgMjL2xDII6nKWv/BjOXj7NjzfNLYCy2B09+eJiGTmu1cu7Bw+7H
         /F6Ks8anRqN5DTQeFt++W89QSHttTU5dtts4f/On+4hYNOvP03kyf70Ce1655jvq7EiK
         xjHktU/YnI0RxXbFzWC/o0WyGVfbrhez0w/G9PMtp5TvF8vTFTdEQ0e2rFC8EEGtFNds
         AD3HgqCTPhCCqAhKgIJJne2lmT/s2ulD/achuJTvgJ8Tb97ao9q7JSVUPA8/8WCFwt1Y
         QNo6UF9aMOyNitRig2W5oXEURNAZfLYmQthZz5sd/i8KqMeMJGKDeqQHSV6FDbuqifpY
         bbAw==
X-Gm-Message-State: AOJu0YwcOK745DIXzHsFxsmzBD3nylFgViYgjGaCoJv6mY7stgusTYGF
	3+4wXn9NsD2RpxUU29Fa/hYXqHu6s33T1bBNklY=
X-Google-Smtp-Source: AGHT+IEhdF0N385lZK+iiOZdfMf/GK//ZQJ8Uqf3c6acgxf6nsox+0RfhDnEpvWZr4UyD76HUprix5445+z4ukZOq2A=
X-Received: by 2002:a81:a1ca:0:b0:5a7:b516:6eab with SMTP id
 y193-20020a81a1ca000000b005a7b5166eabmr598674ywg.15.1696869084836; Mon, 09
 Oct 2023 09:31:24 -0700 (PDT)
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
 <CANiq72khuwOrAGN=CrFUX85UmPdJiZ2yM7_9_su_Zp951BHMMA@mail.gmail.com> <CAGSQo00gJsE+mQObeK4NNGDYLpZDDAZsREr15JcjD8Fo0E4pkw@mail.gmail.com>
In-Reply-To: <CAGSQo00gJsE+mQObeK4NNGDYLpZDDAZsREr15JcjD8Fo0E4pkw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 9 Oct 2023 18:31:13 +0200
Message-ID: <CANiq72kK6ppBE7j=z7uua1cJMKaLoR5U3NUAZXT5MrNEs9ZhfQ@mail.gmail.com>
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
To: Matthew Maurer <mmaurer@google.com>
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

On Mon, Oct 9, 2023 at 6:01=E2=80=AFPM Matthew Maurer <mmaurer@google.com> =
wrote:
>
> If the IBT part would be helpful by itself immediately, I can split
> that out - it's only the KCFI portion that won't currently work.

Thanks Matthew. I don't think we are in a rush, but if it is not too
much work to split it, that would be great, instead of adding the
restriction.

For retthunk, by the way, I forgot to mention to Greg above that (in
the original discussion with PeterZ) that I did a quick test back then
to hack the equivalent of `-mfunction-return=3Dthunk-extern` into
`rustc` to show that the compiler could use it via LLVM (by passing
the attribute in the IR). At least at a basic level it seemed to work:
I got a userspace program to count the times that it went through the
return thunk. I didn't try to do anything on the kernel side, but at
least for the compiler side, it seemed OK. So it may be way easier (on
the compiler side) than the CFI work?

Cheers,
Miguel
