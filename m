Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB822EC0A4
	for <patches@lists.linux.dev>; Fri,  5 Jun 2026 17:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780679973; cv=none; b=WQ/4gG4z8TjXIAwEgI/+Iuu4/WbH/LgdNe1HSnlRZy8f1DlmITmP1kX1YTKOY3PdTjisD5UvjFcoKmIlHTwcZwtFhH5eJ7wFo+5GdqmOqR9ctMbbA0UnmNI8CuHq22NF73zV49gWMF76k3ZZNZS96wOUfQO4zmVcCkGvoHQ1LJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780679973; c=relaxed/simple;
	bh=cx8Rkcij++nIhZcQtMX+8UhBOPSebFuHtinR8U8Auj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jPe/7cSH+mMKXiAoMvWO+BMASYoVNA/TEQye2kPrmTFySU+1ivc8227yjEdPptCdkzjusu37dCxEil2s7Ue6HphPNa5NP17OyZIA8/KH/QCi+Zc9vLZjdBSpMKz6iwqbPPFHz0u8xMVPDioydAbXa3RlrmZvaeIqOZunp5IQp7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZhFyMxMl; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZhFyMxMl"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6877c719cb0so2951165a12.2
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 10:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780679970; x=1781284770; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zbDn0l7MCqGrATagRYR/CBho/Q+7UgNMgo5uDntFVrI=;
        b=ZhFyMxMlBW0PadRxxM72EDv11pqjvjkg6iQi53TUfI0Z+1iVtdg1+m2xWhX5jSvmZ9
         mkSQgvDr2WWPFlgIBfmO88ERzAxBzUdSoKUKeObMHjRHRiUYdjeckzndZt4692E7mkI+
         b+rktm6XBPpcrStCFPapvvgeIDXEtMUuOWpI0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679970; x=1781284770;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zbDn0l7MCqGrATagRYR/CBho/Q+7UgNMgo5uDntFVrI=;
        b=CVb5wnRaOI3xeg3uFP9tnPDcWFAmwBsLE8Nf2FvI7abtzAX6uV+flyVoKP806bOwGt
         CJnycre7p90+cc82Jj8wtSwLXmQ5hUX+1uslhS3OmiIzCYi/Eqf7VxWK3flPxoqBb03d
         goeA0hX7SkNUTU3CJ1x7Dmj7cvI3yzr1QePPsALM1XwntHiWXM36OIrchhAADnyFzUNR
         AfyRy1MXKPkxXodGJL4MGthS8vGbfDTqfg4nwPOJPNs5wd8jVutN5BjiMPD7Sx7Y958f
         h8qmH2E80+GsDMWkomC9k4VKNGz7Xp0avLFTO2JPEoFNhYFThFi6zLiydFdNHVN79pAL
         I2xQ==
X-Forwarded-Encrypted: i=1; AFNElJ+gBR8iEK83Llta9E212pEGM4W7XsKAQxIr6TDlQcQjbA6vzHY+18HGAqbutOwYytuc+MynG/g+@lists.linux.dev
X-Gm-Message-State: AOJu0YxkaZn/n+GY9fKq7X+DaK82dTt9GHH8njpEk5dNgbqCqwalAFsJ
	HrNOuYCl7SFObwcEuK8PZ86nKyHUozvHRF53KzrtwrMRYt+/Nw73yMhJxigww3o3yUNIm/I5ArL
	Q3JPO7v3Puw==
X-Gm-Gg: Acq92OFPtwAl7CUyZSDl5f0l+ZpagkP1W/ABJkbewLu0fK8e2gpn9puMWnMxILcvZB/
	MekyyeOcWxgy1ZSlvC9p4143OnluiAS5OP7Ez6or6X+DcGJI6H/rckdK+CWLaaY/+zlZN3POuuZ
	/RZmJtxsG+RqZkL9TMavk7NZT9nKzB/SaEkPuBBPqLGgILI9rXuVp9sASFnqYBtBow6xGLk2FI9
	dsqYEqCJmAoYLJ/z4NjUiPpaMziqfv4F1UJ9xnaWsrcSNmUoWtycvp4xHrNSvMKrnq5sD/2sKtn
	ieEsyoK5CXEuBq7232LvBV6CzdcZqQ0klOiKAHvWaW8OneWgO9zllhX8eAgbdmouS0ZI1I0YlUk
	Yaz0knlPs9ew+c6ectiYJPG89lbwsshV6dCHO0ooyz0J+2+ghNjTXs5xMcndizrPFtR1Fawp7WA
	D2CtBWyn3upEb2E27mv5gic5MchyAl1ZIjbCslxDYARzKhMraVb0iGXggOQy2eySKiCZMX5Geab
	XNeafeVMjg=
X-Received: by 2002:a05:6402:845:b0:68d:4450:d21 with SMTP id 4fb4d7f45d1cf-68fa4e1bc89mr2604195a12.8.1780679970260;
        Fri, 05 Jun 2026 10:19:30 -0700 (PDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68e65851d7bsm3934999a12.14.2026.06.05.10.19.30
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 10:19:30 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490ac357c55so26390175e9.1
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 10:19:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/Qk7Uv3ViPYPn+EWS9xQx/7R3gbGophleoqkU7Q6OQ60fJQGHDQismrF+Ucb0Blrxbm+PazbPr@lists.linux.dev
X-Received: by 2002:a17:907:2d92:b0:bf0:59a2:4ccc with SMTP id
 a640c23a62f3a-bf36fd9bc68mr283989066b.3.1780679543586; Fri, 05 Jun 2026
 10:12:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
 <20260603211736.755139-1-safinaskar@gmail.com> <20260604100609.6b37f500@pumpkin>
 <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
 <20260604183829.63c35fd9@pumpkin> <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
 <20260604223216.73468830@pumpkin> <CAHk-=wh1Avi8FGbWkt9k0Z-KXWB0spo5mQyowO8PB2sJ3unbkw@mail.gmail.com>
 <87se71jps4.fsf@oldenburg.str.redhat.com> <CAHk-=wjkZSAhxykvG6tQM5DnBoS30_XCKkYpCsQwEGcxJb=i3Q@mail.gmail.com>
 <87wlwdhrvr.fsf@oldenburg.str.redhat.com>
In-Reply-To: <87wlwdhrvr.fsf@oldenburg.str.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Jun 2026 10:12:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiTQr4YYYUH38srGvWAq3_UpDeAPR+qZWVyf-ZU7z8Hzw@mail.gmail.com>
X-Gm-Features: AVVi8CckZsnJXSGEqzilnfJFExIfoQ08Dq0LHvA2PxDFlkolpXQtrHtyU3UQHDE
Message-ID: <CAHk-=wiTQr4YYYUH38srGvWAq3_UpDeAPR+qZWVyf-ZU7z8Hzw@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Florian Weimer <fweimer@redhat.com>
Cc: David Laight <david.laight.linux@gmail.com>, Askar Safin <safinaskar@gmail.com>, metze@samba.org, 
	akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org, 
	david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Jun 2026 at 09:30, Florian Weimer <fweimer@redhat.com> wrote:
>
> > Uhhuh. But that is only specific to 'bool', right?
>
> Also char and short.

That sounds like a complete ABI violation as far as I can tell.

Scary. Because I would not be surprised if we have code that assumes otherwise.

Now, the kernel *seldom* uses char/short types, and since compilers
are typically at least self-consistent in those cases and we don't
interact directly with untrusted sources.

The system call interface is special, but we wrap that for other
reasons so deeply these days that we'd not be impacted.

But we also do have various assembler code, and I certainly wasn't
aware that apparently compilers have been walking away from the old
ABI rules.

I did find assembler code that clearly uses just 8-bit register
accesses and function calls, but it was all _entirely_ within
assembler. The low-level debug printing in

    arch/x86/kernel/relocate_kernel_64.S

puts the character values in %al and then calls pr_char_8250() or
pr_char_8250_mmio32() with it, but that is *all* in asm code.

I didn't find anything obvious that calls C code with that kind of
argument though (which makes sense - we typically call the other way:
C code calling into asm code, not the other way around).

So at a guess we're fine, but it's still somewhat unsettling.

And maybe others were aware of this, and it's just me that has old
32-bit x86 code in mind.

              Linus
