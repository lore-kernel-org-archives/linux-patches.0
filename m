Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A0929AB
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 20:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F856C433F0
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 20:30:08 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="igaM/1DX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1672864205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sa99aiRE7scIwfvML/yhzFWYXLOzBtNC5r3KfyUVDy4=;
	b=igaM/1DXoaajlc0wZFpv2eTMb/wCbWaQgCr+cPlS+7R7LbRaOvS0+3c0iDgYpEjhrUAAZ4
	v3E6qNbzxE3IUEV8kT5zLFeFNORWgdHxTi3UnFPbrJMl3/JjLNSpHqKlH6mLrPGgqBEx6U
	vMO1bd+lWZCrh5WqB0xU5MjUkz6UTBE=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0d648530 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Wed, 4 Jan 2023 20:30:05 +0000 (UTC)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-47fc4e98550so349976037b3.13
        for <patches@lists.linux.dev>; Wed, 04 Jan 2023 12:30:04 -0800 (PST)
X-Gm-Message-State: AFqh2kq3rqiSzTaZlybraD7LxgNkUPLNcboDYAQOk7OABARQyhEc8hF2
	0/thKnmY5llH3XWPKIFZgWExROdVupH5qQsEUiY=
X-Google-Smtp-Source: AMrXdXtnlAdEjqXnGADVmxcmaw0N9w1q4mvc2FZ8ZEIAmo/GMankbc+DPDnEMO2SqEh4Lmm3cojhsNUj9E/km0ZrpC4=
X-Received: by 2002:a0d:ea43:0:b0:47d:af22:b7ec with SMTP id
 t64-20020a0dea43000000b0047daf22b7ecmr2656959ywe.259.1672864202973; Wed, 04
 Jan 2023 12:30:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230101162910.710293-1-Jason@zx2c4.com> <20230101162910.710293-2-Jason@zx2c4.com>
 <Y7QELo9etPM8Tpx5@gmail.com> <Y7RA3bmko0AjO8hQ@zx2c4.com> <Y7RfPnyK/25pxpKs@gmail.com>
 <Y7RmDVI/ScoeBO2a@zn.tnic> <CAHmME9ohJ3JZNjkxuA0KjFW0LLQksgQP5f8bfrogd3+GmLrpKw@mail.gmail.com>
 <Y7RqQNH0OuiYCDeE@gmail.com> <Y7Xg19H39FqTwyEL@gmail.com>
In-Reply-To: <Y7Xg19H39FqTwyEL@gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 4 Jan 2023 21:29:52 +0100
X-Gmail-Original-Message-ID: <CAHmME9p6zwGU33hq1D1Zt9ek8T5ExBp7jLxgn1DVhO4bvOODog@mail.gmail.com>
Message-ID: <CAHmME9p6zwGU33hq1D1Zt9ek8T5ExBp7jLxgn1DVhO4bvOODog@mail.gmail.com>
Subject: Re: [PATCH v14 1/7] x86: lib: Separate instruction decoder MMIO type
 from MMIO trace
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	tglx@linutronix.de, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, 
	x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 4, 2023 at 9:26 PM Ingo Molnar <mingo@kernel.org> wrote:
>
>
> * Ingo Molnar <mingo@kernel.org> wrote:
>
> >
> > * Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > > On Tue, Jan 3, 2023 at 6:29 PM Borislav Petkov <bp@alien8.de> wrote:
> > > >
> > > > On Tue, Jan 03, 2023 at 06:00:46PM +0100, Ingo Molnar wrote:
> > > > > > I guess you missed the conversation with Borislav yesterday about that.
> > > > > > He mentioned that I'd just take it through random.git when this whole
> > > > > > series goes in.
> > > > >
> > > > > Please base your tree off on tip:x86/asm then (or pull it in) - it only
> > > >
> > > > My idea was a lot simpler: avoid the tree inter-dependency by us acking this
> > > > patch so that it can go through the random.git tree.
> > >
> > > Indeed I would prefer this.
> > >
> > > Or... just put this in 6.2 because it's trivial anyway? Heck, even mark
> > > it as stable@ so make future backporting easier. Then it'll meet tip's
> > > urgent criteria.
> >
> > Yeah - that's sensible too, it does fix a header namespace bug - I've put
> > it into tip:x86/urgent.
>
> This namespace clash fix is now upstream as of 512dee0c00ad & later kernels.

Thanks. I've rebased my vdso branch on that now. I guess at this point
it probably doesn't matter that much since everyone hates my use of
the instruction decoder anyway, so I'll see what else I can do for
v15, but still, it'll at least make it easier to experiment.

Jason
