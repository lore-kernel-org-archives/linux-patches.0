Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3E422B8CF
	for <patches@lists.linux.dev>; Thu, 29 May 2025 16:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748535450; cv=none; b=YEdoSi+rCa8MtAOYwXBa3yId61pqX+6ADfRFE2s1757ewCigwxF8BBBiYTC6C2vSnt3FqwXiROhWa5w5pgom5QnpfpI0MXHVCDsDnE3HN3I0VF/0oJh/jrXtYbe6Nr3Pf4ORTW/VqKsUtg8iM6RJMbvjrOlq5AEiY7/czgt+6zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748535450; c=relaxed/simple;
	bh=FY8UJr/g+f5NMmL3wgjX3wt97XPE5ermVVXqzKDxh8g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o1cnIzQCQg+0o3/eyPRqNTrCoRGFaSDdvjD6cYXIeBR+ecl6tBuQ+wcGK7t9UERcWmEdDB5xe9atGQPnYKCug3hkf5CmUPDURshz72FuBkBKFZmo1Yk1LHhL1YDaqO2gAN69lgX7F7qetr+iTArnB6h7WTx9gfZ84iDES6o4nYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FA/B3SzK; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FA/B3SzK"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-32a696ff4deso9322261fa.1
        for <patches@lists.linux.dev>; Thu, 29 May 2025 09:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748535446; x=1749140246; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2jgJKTXVnj6f8YCLQX9p0jhEG5ZRzucQkXQ/lqtbPwI=;
        b=FA/B3SzKgLi9PQPTndysdAXi7PW5Bp3uBf/HMh+wqhacte1x+repe+ZqMn7jaILjXS
         Uh+t0ceFWhgGofvPlCEMRYiDMlvj2KltZJNpQ2XCPn6tAPlCXZXIxtilgd2nknAI7HcU
         jgg8JSFBBL/uPr5etz3XP3il9/1ntdwN2cqPv1/BIapXazqsCehAiyhI2wqLyQolskQV
         DYd9yMFme7GU8I1x5e+aFU7XyXPTT5SVGT2LDcUIvGSny7WU5n++S2CJY94FgA2TwzX/
         b57AHbv00hW8MZFt4nZjd3/83gxCpfleQsnrxsUgWxFLPYEdJ91I7skoVCEyHNkWbe4b
         7GpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748535446; x=1749140246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2jgJKTXVnj6f8YCLQX9p0jhEG5ZRzucQkXQ/lqtbPwI=;
        b=RJerN5yVF+WWFyQ6jE9yjEXYjK62ptWbNTW2g7cuZc3mx1CqITw+CMFNO55kkL3oNl
         wNvC9tRNVvYc2dFarXV7cpBkwjIptMB88I+76UFJGQoZEwwmLWzC3aqdram+y2RZYv8L
         NMf6KTTuefYtu7R2O5lZE1Vn97Fe84ySZ3PKNwB4fgUe5dPGqDzDb0QWAz4qSv7d519Z
         m5Ep1ledfdvssfh8BLRpx2uaRUNjCXpBWTJv+XrWtgqgoGX10PfhLrj+UhQu9mnyyskl
         Ol9wXLzpO6tDZ3XWIsrZ5dzcVXNm1iZiE0R9iNcAAq81OtLgCvSxvMXdbSS393Ohhf3t
         mIAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUE+HyV/AH9a6nY5/2EPWIp6+TWbkASEAAFsB8lslyPt2x3/98/tP809VhNeke1Uwb7PAe9BKkz@lists.linux.dev
X-Gm-Message-State: AOJu0YxCNGFXBy1iw7Q9wl2dzWur0YMMEY0TM4mwytnW938BaJp5gi/p
	KICkFXInBPK/08WNgy6aC0mDT59AQ960N+gU4MWdp16plLKnveY3Bk53ByZYuMR+Hukv3GZgmsE
	6tZ4zM2kF16ihWJwO0Og2U5Tm11fhiQ==
X-Gm-Gg: ASbGncvqDH3+V+U3lvU05C2t8zL7jJsrYuNdPT0Vc2y4EeVmz/Ixv5QtqlBOIheuDGa
	9HaagdGJyQ0kOEhAHsXD8gQ+DQEZ3KPE8TckGFl8dZoXFT/PuoyFauaW8HMDqzQ2n5rnaUHNeUV
	IFEJZNjgEMIJIKZ0Z+pen8EZbhjmUvgsbqe9VOa8QmhFFSktY=
X-Google-Smtp-Source: AGHT+IEymqDwVw9xb6SnmJx+Z0cvqa6rUfL1KnraMAqKFT9Y938Sfu2Ihk2ACz/8Bhs5ueNFlxh7/9XoAvhSlH+rqSw=
X-Received: by 2002:a05:651c:1549:b0:32a:6c63:935 with SMTP id
 38308e7fff4ca-32a8cd295d5mr1661941fa.4.1748535446050; Thu, 29 May 2025
 09:17:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250527162513.035720581@linuxfoundation.org> <20250527162530.470565771@linuxfoundation.org>
 <CAMzpN2hwSXUybfvcas2X5213V=Ow+nqGqqurC_tjfCdb44aFfg@mail.gmail.com> <2025052945-squabble-romp-6304@gregkh>
In-Reply-To: <2025052945-squabble-romp-6304@gregkh>
From: Brian Gerst <brgerst@gmail.com>
Date: Thu, 29 May 2025 12:17:14 -0400
X-Gm-Features: AX0GCFt3X3ZfQfNuUHPxH832YhIHcNZGBocfQfbrKm3jTaQuo5E4XRm35NDAYrw
Message-ID: <CAMzpN2inYN7uXgdfDXwDPWRp0WnEYkOew1Ys=bPPperrwCz5uw@mail.gmail.com>
Subject: Re: [PATCH 6.14 426/783] x86/boot: Disable stack protector for early
 boot code
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Ingo Molnar <mingo@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2025 at 2:34=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, May 28, 2025 at 01:52:16PM -0400, Brian Gerst wrote:
> > On Tue, May 27, 2025 at 1:39=E2=80=AFPM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > 6.14-stable review patch.  If anyone has any objections, please let m=
e know.
> > >
> > > ------------------
> > >
> > > From: Brian Gerst <brgerst@gmail.com>
> > >
> > > [ Upstream commit a9a76b38aaf577887103e3ebb41d70e6aa5a4b19 ]
> > >
> > > On 64-bit, this will prevent crashes when the canary access is change=
d
> > > from %gs:40 to %gs:__stack_chk_guard(%rip).  RIP-relative addresses f=
rom
> > > the identity-mapped early boot code will target the wrong address wit=
h
> > > zero-based percpu.  KASLR could then shift that address to an unmappe=
d
> > > page causing a crash on boot.
> > >
> > > This early boot code runs well before user-space is active and does n=
ot
> > > need stack protector enabled.
> > >
> > > Signed-off-by: Brian Gerst <brgerst@gmail.com>
> > > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > > Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> > > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > > Link: https://lore.kernel.org/r/20250123190747.745588-4-brgerst@gmail=
.com
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  arch/x86/kernel/Makefile | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> > > index b43eb7e384eba..84cfa179802c3 100644
> > > --- a/arch/x86/kernel/Makefile
> > > +++ b/arch/x86/kernel/Makefile
> > > @@ -44,6 +44,8 @@ KCOV_INSTRUMENT_unwind_orc.o                       =
   :=3D n
> > >  KCOV_INSTRUMENT_unwind_frame.o                         :=3D n
> > >  KCOV_INSTRUMENT_unwind_guess.o                         :=3D n
> > >
> > > +CFLAGS_head32.o :=3D -fno-stack-protector
> > > +CFLAGS_head64.o :=3D -fno-stack-protector
> > >  CFLAGS_irq.o :=3D -I $(src)/../include/asm/trace
> > >
> > >  obj-y                  +=3D head_$(BITS).o
> > > --
> > > 2.39.5
> > >
> > >
> > >
> >
> > This doesn't need to be backported.  It's harmless, but not necessary
> > without the rest of the stack protector changes.
>
> What specific changes?  I see stackprotector code in this, and the 6.12
> tree, so what commit id does this "fix"?

Here is the whole patch series:
https://lore.kernel.org/lkml/20250123190747.745588-1-brgerst@gmail.com/

This patch is a prerequisite for patch #8 (Use relative percpu
offsets).  It does not fix an existing problem.


Brian Gerst
