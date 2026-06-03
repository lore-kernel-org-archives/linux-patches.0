Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894CF395ADB
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780500422; cv=none; b=WO+bwFa9iJAY2Z5Edk469evpDDDEEV/dEXU+1LbzDd9+pvHbPaFXBwfqnpJM8e/IHneLPI4KATmy4AvhzC3THKTsOa0lL6exVzLcqvZAT2wAS2UDIe7MRysIoW+tdout6zM4X95sUm6iE5/3fSDEGTkvvpDsmYCkU392yizxSbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780500422; c=relaxed/simple;
	bh=5wR6ldRtC07oE2OfAwKn+DBv+oDO9pj5vEPnyj7TnCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V0YkDlr2+V5ZgYGBn3uYIc5LwEfWcrVRc0B42kM8sYboCih0mWy1GKR4so1fh5btZFGBoFWC97l7c8w417FFQHQmCsSTmqek9RCdS06MU0yxmo7RPhsz1P2sTqYhKh+KUohdN1ncfw9ZFCIP9sKBnbYOWom2lgeCxm5NFIV6JaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KGE/rxQr; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KGE/rxQr"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bec450b950dso531110266b.2
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 08:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780500420; x=1781105220; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EdBrjWRKLAumno5vFkve2ATlSCQiBIWYVQeSXYhWLKg=;
        b=KGE/rxQrKgnRgUCPHSdfS+1/Bcw75L5FsXpYnUbVJssFG3/AVIwiZsLs5S9Wdqsx1I
         rFhWIPqPzjFEyXbqZaGnNdi8r7wBTlodISIv+Xm9iVmiPKT0z4x92Si9H6cOExOj9KTd
         hU+0435HkuNELQzFa7+8Mqd1k2nXNtjRFTIJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780500420; x=1781105220;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EdBrjWRKLAumno5vFkve2ATlSCQiBIWYVQeSXYhWLKg=;
        b=SCAPyPjPo+tCsnpzb+6jl/fGp1sKVqvMmNYympXPs13blYSSbm/tBdZr7DAhPr+Iz1
         XEH0Li8W5QzTNvvKBkirl5LBmvP12PUjmHl04Qz19ZhAZ0x54Qk2AEMCkU6Met8Y83ta
         wnjX9MqXbNnGyj1o6mw/n/xbfrYKxmeEB3GUYfvrtKmczYeFLEHwyq9rcBYBmXamJDHt
         bendciJNvIcjMmLJAjX86+vyQSMoWlfGwUkak2V4dK0w8kdwyzfHHEYJ482VvgAyBN5p
         mMJvpGT/2dyhvkHHPh9wBuN1nzdbWsRy/0KQIILlFcSp1KTtP06S0OARi8fmnouXJEy+
         mQvw==
X-Forwarded-Encrypted: i=1; AFNElJ8UryDt1o4IApOKRvEMAgnWL1xyZjSRPgiB75J01iLEP7Grfq6N9kysdFGgF3cXImBEBl7GURvt@lists.linux.dev
X-Gm-Message-State: AOJu0YwW1CS654rBpGNX+8frvk54n4NPy5yiONjq954QHU1JdopQYHEa
	lJ++NJ/yI6gPWfIXq70I5/0jqRvPzPgPZBem71jNQEm1sT1pmEu96WSECNXizy4tH1eB0FudqAS
	UO0nC94PQIA==
X-Gm-Gg: Acq92OE2bSLXcyPf3aAqdKhz2OevurZG4zJts9na9tNeoMnaD8WQSnYX8rDyBYNGsme
	T04M7HnwmsVri7x5wHLnHs0Q1+SKa/WhwT4HbxZ8ChY1Wz2m7dAev9MK7tRo06vqRVnuT9sQKS9
	Awl+7SOGXjUhiYUMESfu0xagjYpRiTU2FWg+ahpyz1FYDgMsiLd9FUQ0Br3jKkmG1py9+WjgQ2M
	R6Gy3RdTGOsdy9+kKiBthCKLE+RBNXWFRLfcX7te8AwYq/6xAT/5bErjtrwOhklhsAql6SktrS1
	5f+qw3hHtkhDi84JY1aItS7mjzoEwmjCzX9pvYPkR5IofsiSMBMuiM20bQ70g5xGCVqPpvzT10Y
	zsbyhpSD2W4K4zWN94VCdqAvrtFxPsIR47gSUsgbSo9WofSLE8al8Sp5BYG7tK7yTy/9bTE78Tx
	wn7EArLC1xy9N2c2XNFbPsMl/mVWNlIvN8xzBy+J+0/gT5r5r1p3H7ysDx2vpzAmI7XAh1bOGCy
	eAnqujnmGk=
X-Received: by 2002:a17:907:1c94:b0:bef:36f3:7263 with SMTP id a640c23a62f3a-bf0ad206d70mr227495966b.17.1780500420029;
        Wed, 03 Jun 2026 08:27:00 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf055305d40sm167704366b.45.2026.06.03.08.26.58
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 08:26:58 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bec354815b9so384927366b.3
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 08:26:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+QJD0awcHyQp530GBW2XnyWmLwVBGIpPrGCMLL3E2s5gxSNibLuEq6k7kR1kInGRvcqSuXNw0u@lists.linux.dev
X-Received: by 2002:a17:907:3f0e:b0:bed:19af:f8aa with SMTP id
 a640c23a62f3a-bf0acf0f958mr176902766b.13.1780500418629; Wed, 03 Jun 2026
 08:26:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <20260603-navigieren-pleite-stilvoll-60e6da66b1d4@brauner> <20260603-raumfahrt-unmerklich-ertrugen-c4ecae70d5f9@brauner>
In-Reply-To: <20260603-raumfahrt-unmerklich-ertrugen-c4ecae70d5f9@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 08:26:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgV-j-G3d+899Zm1pQ=NaJrddPz=GKcL5Yw5DTUM=GaUw@mail.gmail.com>
X-Gm-Features: AVHnY4Kj73Z8AasW6cIfq1Oi-uE8PGC_0Rj2_P-0GPM116OFy2hMKOC9XAw-q3o
Message-ID: <CAHk-=wgV-j-G3d+899Zm1pQ=NaJrddPz=GKcL5Yw5DTUM=GaUw@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Christian Brauner <brauner@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, 
	axboe@kernel.dk, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jun 2026 at 06:40, Christian Brauner <brauner@kernel.org> wrote:
>
> Prior to the change add_to_pipe() returns -EAGAIN the moment the pipe is
> full. So iter_to_pipe stops and returns a partial count capped at pipe
> capacity. For a 128K buffer over a 64K pipe the first call returns 64K,
> the test drains it, call 2 returns the remaining 64K. Done.
>
> After this change do_writev(... flags & SPLICE_F_NONBLOCK ? RWF_NOWAIT :
> 0) then calls pipe_write which does not stop when the pipe fills. It
> blocks until the entire iovec is consumed.
>
> I kinda think we need to preserve similar semantics.

Ack. We definitely do need to keep the old semantics.

Looking at the patch again, I think it's that

    (flags & SPLICE_F_NONBLOCK) ? RWF_NOWAIT : 0

thing that is broken. I think splice_to_pipe is *always* nowait - but
has the special conditional _initial_ wait.

So I think the RWF_NOWAIT should be unconditional to the do_writev(),
and instead the code should do something like

        ret = wait_for_space(pipe, flags);
        if (!ret) do_writev(...RWF_NOWAIT);

but admittedly I did not think very much about the details, so I might
miss something.

Which also then probably measn that we should just keep the legacy
wrapper in fs/splice.c and we'd just need to make do_writev() and
do_readv() non-static.

Because I'd rather keep wait_for_space() internal to splice (or
alternatively we'd move it to pipe.c, rename it to
"pipe_wait_for_space()", and change the 'flags' argument to be a
boolean to not make it use that splice-specific flags etc).

            Linus
