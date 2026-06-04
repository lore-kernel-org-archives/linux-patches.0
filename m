Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641FE439006
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 14:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780583071; cv=none; b=s73mDHjZ5QUQEsRwdmDvRakVuahRcymVxwjz4n83O5lgVMQu4hvgHMV+z5BKenLhh5QfBmU9VoigP7P8V2E+QR3CIH01l2D9CDKABSNQcXvtwpLtMcj31mye7sPnaGAFPGK3z0bW5Kh/N4+WDKvfTOAfJygWRTbvS7cc+Mf2O7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780583071; c=relaxed/simple;
	bh=Ecbl/t5OYeJ4mb+vVa4qoGM4jTXP3pkfic84pGx71kY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jwPOu3yKSp15b2K72qedvozgnyXor7b3M2EuXmY11jk/5tKflYIttX9jZJiOqhF+IxgT+00KRQ2jPQy0xM2qrh1EmFzDSwJveF1Jl041FQ3fFmKcz6gMVaZACz1lIxldvRYp2ZIz8xI84ehM/Q5IH+FhRDsC42VX4EQt3o1uWis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gj434yhB; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gj434yhB"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3965f215817so7001911fa.3
        for <patches@lists.linux.dev>; Thu, 04 Jun 2026 07:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780583067; x=1781187867; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lAn7tUi15DsxPNLBVxb55DsaCLzi2ItCgQT81dYuAAI=;
        b=Gj434yhB30ZliG2cREfJvRlrXhCLGNy86CTLf93WaE/SiE1q3s0CEEDUN4LQTtFUh7
         wIFDsYceDDvQKEXvm3C7KUEIFA7KWkh7YGZxqYwtHGQ352iB0LpVNXOOZUDPOfvZ182q
         RGNSo/z4BD7/AD907DtwMDeAg2LQ9x8dD41ss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780583067; x=1781187867;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lAn7tUi15DsxPNLBVxb55DsaCLzi2ItCgQT81dYuAAI=;
        b=natBXoCmYvZ0PnOFA3iqmCLhMELclW01gpC0qXh0fI6CO99xiuPkjVw0gcaa3jvdL3
         DbHabz53LXCLqfz3F2ZXN89BMF/yPS+Du3gvwIjQSWflfbSoVLIyP/Y7eFFY/Q7x/0FC
         BhjS09+o81pmlCq/wDEFIkQl/FL+f+2/gpobbOpLt43pml3oKpEuo+scrlrHZI09UmlJ
         TuD7w52xdnVqef43yC2bWbBGkEpHxr/L6umMK8kO4NKMTZLlZW+7hMv7B/vAUArl/a4c
         aykUqvyLq+y+mJ2aN1cgLpkTauck6WaFFtrlFS/HmQUwl1YWJjNSS5ZraU9y9DNmX9eI
         DOjg==
X-Forwarded-Encrypted: i=1; AFNElJ9q+LoqK5MZ50kKbFIfyGYOcZwpCjaQy1Gz8zmdYcMpN6bZGyvxJ7Lp1/4mWcQDaZPNjtYQmKjr@lists.linux.dev
X-Gm-Message-State: AOJu0YyyIWO/CxHRVXuxwZv+Cdzsy0lIRmnGWxkcqKlt9xauyKQAJN+9
	PWiLC3KaJq2c9g0EKPvfIO82rSbGMBNVkOlYc1M5H9vL17/Bc5ZKSta2uEeZEVGv/iMrTVKGjWD
	o/iBQCLPOow==
X-Gm-Gg: Acq92OGTLIjy0y28hHSO/bMkvPjYIxKq36o0Ff+S9BlVOY7FeempoK56839hPozdru6
	8jWjUjkU4TrgU5fXHbYg05MZoeAUCpvKpKd83F0ovp/48ajaPYTiz6AAxF/fnjTAQLbSqkBhmGy
	6tYGYc5AqDT5voR2DefSEzXOQOqF5/zaWNEFFVTbyQ5SBv0O6Th7wNqn+/sf1Izd2HJ7ZYQeCg2
	yAS57PeX03C8Ys2JthVjDsCOVi2u+kKJELR+heHg3NPtWi4zEIjwJYzl9pOTdqyQhISyFMsTp51
	e6Y/Glx9mCu3lZPnrfCG31PLm6bn4txBT0cGaWZVbk6m6B2s18ixfhVNmScRX+c4yUyHJYG6tY0
	NH7RfIT4bSNCINBnJQudwlhw2wimf523SUllhq9h2wCqLtRXTAvSrjyi2/R6HNF6u86nRJBnJzk
	bRLpLuR0sYlW7CRn7JlZDzcbdYngc7Z7+M86JR1HPx6BdCZn3m3hztJCUfxsO4xRhQPdUMsDd3l
	4K/cGOdbEpxS4g1sAvicw==
X-Received: by 2002:a2e:bea9:0:b0:396:a4ba:f257 with SMTP id 38308e7fff4ca-396af180102mr26554861fa.12.1780583067462;
        Thu, 04 Jun 2026 07:24:27 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-396ac2be18csm15904071fa.19.2026.06.04.07.24.27
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 07:24:27 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5aa5be9ab1aso800666e87.1
        for <patches@lists.linux.dev>; Thu, 04 Jun 2026 07:24:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8l2KJ5DG5aQ7RXWBQWu3KiZrK1T9pYIEvX4auvwUXVZ5kwtB9v52Ub2lbaueJI9vR5r3n8C36f@lists.linux.dev
X-Received: by 2002:a05:6402:5296:b0:670:8add:2b8d with SMTP id
 4fb4d7f45d1cf-68e72739555mr4177743a12.24.1780582648047; Thu, 04 Jun 2026
 07:17:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
 <20260603211736.755139-1-safinaskar@gmail.com> <20260604100609.6b37f500@pumpkin>
In-Reply-To: <20260604100609.6b37f500@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Jun 2026 07:17:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
X-Gm-Features: AVVi8CcQ0yaowxPCFqM7JCGZCz4oCGBQaQ6sAmWXnRpVnXINniRqjS3Vb3FRVpM
Message-ID: <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: David Laight <david.laight.linux@gmail.com>
Cc: Askar Safin <safinaskar@gmail.com>, metze@samba.org, akpm@linux-foundation.org, 
	axboe@kernel.dk, brauner@kernel.org, david@kernel.org, dhowells@redhat.com, 
	hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Jun 2026 at 02:06, David Laight <david.laight.linux@gmail.com> wrote:
>
> Something needs to ensure that the high 32bits of the fd get masked off
> on 64bit systems.

That something already exists: CLASS(fd, f)(fd);

It ignores the top bits, because 'fdget()' takes an 'unsigned int'.

We have been a bit random in how we declare the system calls in
general, and we mix 'unsigned int' and 'int' and 'unsigned long'
pretty much randomly when it comes to file descriptor arguments to
system calls.

fs/read_write.c in particular uses all three cases with no real logic to it all:

  SYSCALL_DEFINE3(lseek, unsigned int, fd, ..
  SYSCALL_DEFINE3(readv, unsigned long, fd, ..
  SYSCALL_DEFINE4(sendfile, int, out_fd, ..

but then anything that uses fdget() (through one of the helper classes
or not) will simply not care.

Does it make sense? Is it pretty? Nope. Does it matter? Also nope.

                  Linus
