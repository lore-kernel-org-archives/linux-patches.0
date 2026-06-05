Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A80C3E9C21
	for <patches@lists.linux.dev>; Fri,  5 Jun 2026 15:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780674873; cv=none; b=XkA6DX4Haz0eKknqkB0CrOsS2+4o+yvQlo32QFtR7FSpUAUt6QDfbYiZJKV42gEZrMXZWO1oMpqa9ZjyNShJSP9CecEvSUqMsmrQPXU+NgCdJqrDArw9GdYb0p0deAlLk5DbtSVj037a6QrIj3zJzrTbVGMTpIvJaOsuC/WAg9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780674873; c=relaxed/simple;
	bh=Fj3s5frbyB6TsqrxQjPY0GZVgFWhmiPiWsC9BqFUZ+A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QbS7KbJGs9YZdOuNgpnBvuHn2GgMjz2YKbrtFpPPt0f0l7Y0IizdD1Jjbwqgd2pPuYJOKPaD1un5ZYaG9UtwHMo8c8PeONiMnLcAzite7bqI97JDHAT198ypcYXAjslktXI+74NycaEylzuApePmbsKYqp6N1k+rhDXCXlkbHEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZZ3QPotE; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZZ3QPotE"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bdb3fd39045so265674066b.3
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 08:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780674867; x=1781279667; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1hPSWEkREGIx4yoYWkytVFmLCkNUDGfpLW+35vC71FY=;
        b=ZZ3QPotEeCok011jXsXz7uHK4Thn4Ru5+e4DAkHeUeTEdMrCK3Qa40Po0GIT4WVFsd
         CeqkHpht0sKa96Kac9SYDpNwED/RI3WRMzZpEewfEB4u5Vgss4pVhhUNnp35+dOun8Do
         nZe5Rl+cSVYMfLZIhH1ZfDNfkNHSEh4xUGKEU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780674867; x=1781279667;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1hPSWEkREGIx4yoYWkytVFmLCkNUDGfpLW+35vC71FY=;
        b=Du03zs43TzJbQbmtozG/RP0YiB39bS8eOiC25BZaCySnQVjU5QTRkp8UxUmY9bkzmc
         xJmdyauttZ6396gojxBCNkONC9w+gJhsh6TVtLVPvaSzlQLuMwH3GD+DuIJ7ieC4jK0Q
         lmG5rzxbRPKa3Y+TO04B0vis0p9w3AWMpex+zCjowAiqeUBVqOTXq259fZDBFX2VbaUi
         kKaC+bG1cJa4NbUXBJEFUhAsIRiGl+QSTlcCv+xfed2heMCQkufvmvwAXmVVxc1Ku7n7
         krjDKWYEsjsMPRgeAH1LaHdAuuReg1iaw7ThA3jND0LK4FWwevRZb1iQoIbRMGI4gDdh
         D+sw==
X-Forwarded-Encrypted: i=1; AFNElJ8gTLvoJpy42KOGI7nbz+MpNmr4YMImVd6S/32x66buo3LWcALVoBGR+5orDe4Tewaqacvh657f@lists.linux.dev
X-Gm-Message-State: AOJu0Yyy/CeElv5CYMr+U3+SvcL/cIu9u9QBVGYUAxiuPE3FBYrV7MNH
	ualQ4Xr0hp0ut0omuMwl4pImWNAGynlumCSwfKUmehbQwUQga5eBWM6O3P+PCh51ibBrcMk/Q/k
	VXz9zjah5Qg==
X-Gm-Gg: Acq92OHFHTKjGijB4+Qyoi92OcW6+9jf+TZ5SvOf1+OtcizvDOJvffVNTbgt9NIbltK
	8ExF/x90vjvDty/R+q79ggbJfR+oZfo0lIsoVdMWRplTuU6K+U+DWVHhKPvEZbC7LKKgGy7G3vD
	7CpRt8Wvi7InuQkb3Z90YB4mDt15RtDwN0/khqiZQCwB2cWVq05noLIl7ceesjiE/dSWJBN/9cG
	ZYNjDaRZzHnTtty9BAETv+QcLab4t6UZ7eydeIDek0sG1pyO+gxXXGM9ghglQeGSEEi/9vHYtFr
	l1sCop94rkae48rMoNXoUW/W6yJzR99KQG+YS7EKR2Z3mQZ8LhEww2qf973oxKyB08eQ6TGM7ZJ
	84Bvg4rzXNph6gDgGbC23pXekYISBWN6hpiPh7CQatTF3SKuCNcmUuC6s5yDjp+zA6uUJK0s1oR
	p1/Vzc5IQtFLHf3UCHLpm6l1bWUzOHoDZZDJd6y6DzNhzZCv5h0faHiq73BkW8wG7PVFjoADC4c
	NeK4aXF25k=
X-Received: by 2002:a17:907:d40e:b0:bed:4545:8bfb with SMTP id a640c23a62f3a-bf372e1f898mr240999766b.40.1780674866451;
        Fri, 05 Jun 2026 08:54:26 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf0559f4144sm470096666b.58.2026.06.05.08.54.25
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 08:54:25 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bdb3fd39045so265668566b.3
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 08:54:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/rTHD3PqTKd5NgD+LlUvaL9ZucfGRpJTdi7SFs/eAl9zsfzORH/k1B4zVMV9u8tW3l09ApPcTm@lists.linux.dev
X-Received: by 2002:a17:907:741:b0:bef:d760:93ea with SMTP id
 a640c23a62f3a-bf37234c965mr227182666b.30.1780674864895; Fri, 05 Jun 2026
 08:54:24 -0700 (PDT)
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
 <87se71jps4.fsf@oldenburg.str.redhat.com>
In-Reply-To: <87se71jps4.fsf@oldenburg.str.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Jun 2026 08:54:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjkZSAhxykvG6tQM5DnBoS30_XCKkYpCsQwEGcxJb=i3Q@mail.gmail.com>
X-Gm-Features: AVVi8CdvqDsmiM-EYrTUflKR5aYKg4JuQO6h_hoIzVtXJtUhEM3tfPOlti75Shw
Message-ID: <CAHk-=wjkZSAhxykvG6tQM5DnBoS30_XCKkYpCsQwEGcxJb=i3Q@mail.gmail.com>
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

On Fri, 5 Jun 2026 at 02:33, Florian Weimer <fweimer@redhat.com> wrote:
>
> * Linus Torvalds:
>
> > x86 really doesn't *care*. If the caller zero-extends or leaves high
> > bits set randomly, according to the x86 ABI that's perfectly fine: the
> > callee will only care about the low 32 bits. So the high bits are
> > simply not relevant for the ABI.
>
> Please note that Clang does not implement the x86-64 ABI and requires
> zero extension.  We see increasing problems from that, now that we have
> more C code calling Rust code.

Uhhuh. But that is only specific to 'bool', right?

If it were to have the same issue that powerpc(*) had - that 'unsigned
int' has to be passed to functions with well-defined high bits - that
would be bad.

And I'm pretty sure that clang doesn't do that.

Anyway, for the kernel, this shouldn't be an issue simply because we
typically avoid 'bool' in arguments or structures that are exposed to
outside.

(I say 'typically' because I'm sure it happens in some broken UAPI
thing anyway).

                  Linus

(*) I may mis-remember. Maybe it was s390, not powerpc. The s390
compat layer independently had a similar issue wrt pointers, where bit
31 had to be cleared. s390 dropped the 31-bit code entirely fairly
recently, but it caused some "interesting" code in the already
disgusting syscall argument handling wrapper macros.
