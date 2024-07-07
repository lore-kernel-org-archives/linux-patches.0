Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85C95C8FC
	for <patches@lists.linux.dev>; Sun,  7 Jul 2024 19:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720380186; cv=none; b=rFqaYHHYB/OtS4+Xjg8boFasFCg4rn5P5kNi7w35e9hOV1hSKFvBGynvAKc7wNH3Gat6gIk1ZZ0pOdGgDbIZH1UsDstRnCre5U4ve0ofqqANQN1oF/0NkXS3bS/mtMNp6hZIAc97CgP6H57VsvwPJHYksahNH8vrcR/NKR6OmNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720380186; c=relaxed/simple;
	bh=EpPs/PieXAoJ9C1Niu2SR/rTGpSjbWX77CzmDxsNsCs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MM4G/2lF16xje+fkZ/ICVBobvwQnnpM1yRhVFLOk2BbKcmSA8MejEE2i/LY1tnQ8UaFOcAzlIdj20b0jcDqmht3MfEEbBu/yw7D2kzXZNhcmcVDOVx1gBTSi21PaA1Uyc6k6eui4lNCL9wUinMMLFnOzbLmPLRphUNcc032v6uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RvH1QKKG; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RvH1QKKG"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a77c7d3e8bcso278346866b.1
        for <patches@lists.linux.dev>; Sun, 07 Jul 2024 12:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720380183; x=1720984983; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r0kqfSkBdmswPIG4hqXsZ+rgeH3ZVa2Soxi8UY2qccM=;
        b=RvH1QKKG9y82rZVaog0/eFCkTg45EAO5FWNx4q/XAGrfAm+9g633g4WLvvhxbtHstp
         JTIJ+kDLIWkplbw+ZxR9o9UbgX3q9YW0I/A7cQXJW5oZWqnk1Sp6uQPO4pZPWU/QV2/I
         WNbZtjKoTLmlya6ahYVs+IHU4zpv/FrGNfJPw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720380183; x=1720984983;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r0kqfSkBdmswPIG4hqXsZ+rgeH3ZVa2Soxi8UY2qccM=;
        b=IenmAsh5js5DfzGVSymfWLPtPYXVqlEF6xWa1nRWB2H9cJd4jA1bcxJLwmifgJx6J9
         XdCD3IPzn/17P9FnyogdygzBHV38a0QJqWlDuy5/e2xqQPGMr9Nq7a/emRyxlZfmo6A2
         blbZSNQlMIHcOR2f/Lmd/72It7vym4vw/x5aMPUfDlA98fIiTyW7HJBbsdyj30tkZr5k
         +0e8fYSZhvVUBrz9s5Ubj96pcmNeeQh32dsqfsUkAZkOpQQTlGTQ95prMzXWYfnR7vIY
         514lDzoqfNJxDng6RpRmBq1G5S2ztd/r+UE12SxANOVKS9btBuIKD5hd/ks5jrA06A3b
         sqfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWESmcToL3eID+9IRRBkUv5VJAvMdy1x7PZkoBQoR+A/GgHH3rJG42lYujzRV3OBMaZsE463hcW7nljOdIGZdzt8h90NNRLag==
X-Gm-Message-State: AOJu0Yy60Myr7myYk9+B569SVKeqJh3Hg2oVMknPW8orYdM0zuTrymMl
	9l3hG1yEwdeXcB78MZy6FX+XkHi6QIIjMgdIwmsN/Zlfvtwy+ArNZgRvj30TkiI6paFfoVwHtRa
	3n386dA==
X-Google-Smtp-Source: AGHT+IGDZ0dgijNa4j4dQg6cqZ7q529Y4BHoIEFDIs82TnO5TWEC8fam7EFEY9hlK/h1vFitZGwO6A==
X-Received: by 2002:a17:906:b74f:b0:a77:de2a:aef7 with SMTP id a640c23a62f3a-a77de2ab232mr308223966b.44.1720380183051;
        Sun, 07 Jul 2024 12:23:03 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a77dd3da395sm187481166b.72.2024.07.07.12.23.01
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jul 2024 12:23:01 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a77e2f51496so142084866b.0
        for <patches@lists.linux.dev>; Sun, 07 Jul 2024 12:23:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX10vQlVvcbdF0mlMwfKqu4KUEEJqbzsPVXSKApDrik/Iu080CFcK750+ZF2aTQ9jpo+uMZbH74AJPOApgDI6nO28GGcfbwpQ==
X-Received: by 2002:a17:906:7708:b0:a75:3c31:4f58 with SMTP id
 a640c23a62f3a-a77ba46fa2bmr620405066b.32.1720380181227; Sun, 07 Jul 2024
 12:23:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240707002658.1917440-1-Jason@zx2c4.com> <20240707002658.1917440-2-Jason@zx2c4.com>
 <1583c837-a4d5-4a8a-9c1d-2c64548cd199@redhat.com> <CAHk-=wjs-9DVeoc430BDOv+dkpDkdVvkEsSJxNVZ+sO51H1dJA@mail.gmail.com>
 <e2f104ac-b6d9-4583-b999-8f975c60d469@redhat.com>
In-Reply-To: <e2f104ac-b6d9-4583-b999-8f975c60d469@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 7 Jul 2024 12:22:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wibRRHVH5D4XvX1maQDCT-o4JLkANXHMoZoWdn=tN0TLA@mail.gmail.com>
Message-ID: <CAHk-=wibRRHVH5D4XvX1maQDCT-o4JLkANXHMoZoWdn=tN0TLA@mail.gmail.com>
Subject: Re: [PATCH v21 1/4] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: David Hildenbrand <david@redhat.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	tglx@linutronix.de, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, 
	x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 7 Jul 2024 at 11:52, David Hildenbrand <david@redhat.com> wrote:
>
> I recall that introducing things like MAP_SHARED_VALIDATE received a lot
> of pushback in the past. But that was before my MM days, and I only had
> people tell me stories about it.

I think MAP_SHARED_VALIDATE was mostly about worrying about the API impact.

And I think it worked out so well that this is probably the first time
it has been brought up ever since ;)

That said, the *reason* for MAP_SHARED_VALIDATE is actually very
valid: we have historically just ignored any random flags in the
mmap() interfaces, and with shared mappings, that can be dangerous.

IOW, the real issue wasn't MAP_SHARED_VALIDATE itself, but introducing
*other* flags that affected maps that old kernels would ignore, and
then the worry was "now old kernels and new kernels work very
differently for this binary".

That's technically obviously true of any MAP_DROPPABLE thing too - old
kernels would happily just ignore it. I suspect that's more of a
feature than a mis-feature, but..

> My understanding so far was that we should have madvise() ways to toggle
> stuff and add mmap bits if not avoidable; at least that's what I learned
> from the community.

It doesn't sound like a bad model in general. I'm not entirely sure it
makes sense for something like "droppable", since that is a fairly
fundamental behavioral thing. Does it make sense to make something
undroppable when it can drop pages concurrently with that operation?

I mean, you can't switch MAP_SHARED around either.

The other bits already _do_ have madvise() things, and Jason added a
way to just do it all in one go.

> Good to hear that this is changing. (or it's just been an urban myth)

I don't know if that's an urban myth.  Some people are a *lot* more
risk-averse than I personally am. I want things to make sense, but I
also consider "this is fixable if it causes issues" to be a valid
argument.

So for example, who knows *what* garbage people pass off to mmap() as
an argument. That worry was why MAP_SHARED_VALIDATE happened.

But at the same time, does it make sense to complicate things because
of some theoretical worry? Giving random bits to mmap() sounds
unlikely to be a real issue to me, but maybe I'm being naive.

I do generally think that user mode programs can pretty much be
expected to do random things, but how do you even *create* a mmap
MAP_xyz flags field that has random high bits set?

> > We also have PROT_GROSDOWN and PROT_GROWSUP , which is basically a
> > "match MAP_GROWSxyz and change the mprotect() limits appropriately"
>
> It's the first time I hear about these two mprotect() options, thanks
> for mentioning that :)

Don't thank me.

They actually do make sense in a "what if I want to mprotect() the
stack, but I don't know what the stack range is since it's dynamic"
kind of sense, so I certainly don't hate them.

So they are not bad bits, but at the same time they are examples of
how there is a fuzzy line between MAP_xyz and PROT_xyz.

And sometimes the line is literally just "mprotect() only gets one of
them, but we want to pass in the other one, so we duplicate them as a
very very special case".

                     Linus
