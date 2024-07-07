Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870FD558B6
	for <patches@lists.linux.dev>; Sun,  7 Jul 2024 18:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720376407; cv=none; b=YeD+jw4FDsEz1ZQ++k4C9dUnWH4WjAXKk84x7Dkh6Ojg7U+Z2e6Wrc6jy/vg5YcHfH+tbqGpjJ4oHtxB79nazkcyA0bUOnCbsKTvEnJ+oPjhDutMXUGzlK6JajcyMQPzwKxNTCFx4tgkZF+k5R7UHGvs/SY3Y/qKz+BcnbgWwB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720376407; c=relaxed/simple;
	bh=IgVGCT2xxQj0d6AEWv1d2oISYtXfXK5QvKatWJYOnV0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hyP9F8C3iFvtqBhPGXUgy8y5Mg4+sCZ8UExQMBZCSeKhrVfu8taxphN2kQTGA6jKzKGUxl1jrB9nV+VLIhHJRuAz/2JwLFkxZmkDMlGrhfEDwdeHV75qwqYHIigjN902NXajMlbRLvqp4W4YgJt0ZYyLMyok6wXqDncghRFR5Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O4jrXW4X; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O4jrXW4X"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a7527afa23cso388545066b.2
        for <patches@lists.linux.dev>; Sun, 07 Jul 2024 11:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720376404; x=1720981204; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5v0Nkh0XR+jIko5z42PL5jDgcJnA00NhojDwz4yKzQ4=;
        b=O4jrXW4X3rCy8KIAmmi5jV0Jh5Er1tXSUoFpH/PWI5NRsz9CrGiCc5dyFM2UGm6o0z
         2mRLD9mEsmpnh4nN6K9ZYJoWGAIBjecAdOsAd8wWUmflhU821SMZT7bGzC+WdiD9DKD7
         bhL+T2f6dVEMboRp7tKhOJT6UXDvnIMAP8Sjs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720376404; x=1720981204;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5v0Nkh0XR+jIko5z42PL5jDgcJnA00NhojDwz4yKzQ4=;
        b=SS0xfujvC5Q9xACECDnTxamc3Robr5WJWVZJiKuJUUjxiBSuRHg8/hxzA79kaqnPCd
         r2d3WHKkqs1/jpyRD8kkZFCE7E7brGqq5HJNXiZYisNOr7gnkcKuj6v7zSv7iLQNEOI0
         7JovSP1RRTXJOY8gdT3vuBrdjwB5HEG0q+v4HCiuREay3D9UD80WkBmXyqqsd8jdsvNW
         SWxODr8D5Zq5kG9aec8w8/KSvdclRdTTzsjpfyFLgTcexNWw9fiSQwYKXuU4hjfY8tRU
         JAIJo6TNx5pBXOgEdenAkCMc1tEIGxHmbuoxDNMJn7MHZVHlSB1qYfIKV7JZqqcDYRHg
         L0Jw==
X-Forwarded-Encrypted: i=1; AJvYcCXyO1mXxgeCn62s9CvE4yvIfsQqu9dmpJymN3KHndePUiLqL5bzPj88g8YL0zgLxlG/c6KZPmzeDeURTJ+MeH1I/PycLqKh5Q==
X-Gm-Message-State: AOJu0YwW/e9S1lz+lEKNkS1a+3E7kA9N76bFVDN8iIugMfzq4rmKVWKl
	1v1GtGj8wyqPST931hArGdGuAyOPL1Ja3VLidlqEpbScoooz7eOJnPeODz3WfBJw3NQa0492Ie7
	3o+LgGw==
X-Google-Smtp-Source: AGHT+IFs+9tbOtCPH31lIBM5ROYKk9CAvNx6zg4pCwtLtDTPSZpKqPGpyeGsLsdftC4WHg7mP4rocA==
X-Received: by 2002:a17:906:c00f:b0:a77:dc23:5625 with SMTP id a640c23a62f3a-a77dc235698mr387570766b.22.1720376403549;
        Sun, 07 Jul 2024 11:20:03 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a77c65ffab7sm261151066b.61.2024.07.07.11.20.03
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jul 2024 11:20:03 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a77b550128dso401909166b.0
        for <patches@lists.linux.dev>; Sun, 07 Jul 2024 11:20:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUbxTPufgpDlxnaw2Z5RX68gJqcJzGqqDBaIXhapTtu9xndt43D5L3gUiS/Ysatp+Z5O05chOsRhGKjTxDhRftzlXotxxy2rg==
X-Received: by 2002:a17:906:bc94:b0:a6f:58a6:fed8 with SMTP id
 a640c23a62f3a-a77ba46f8femr721323266b.28.1720376402830; Sun, 07 Jul 2024
 11:20:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240707002658.1917440-1-Jason@zx2c4.com> <20240707002658.1917440-2-Jason@zx2c4.com>
 <1583c837-a4d5-4a8a-9c1d-2c64548cd199@redhat.com>
In-Reply-To: <1583c837-a4d5-4a8a-9c1d-2c64548cd199@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 7 Jul 2024 11:19:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjs-9DVeoc430BDOv+dkpDkdVvkEsSJxNVZ+sO51H1dJA@mail.gmail.com>
Message-ID: <CAHk-=wjs-9DVeoc430BDOv+dkpDkdVvkEsSJxNVZ+sO51H1dJA@mail.gmail.com>
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

On Sun, 7 Jul 2024 at 00:42, David Hildenbrand <david@redhat.com> wrote:
>
> But I don't immediately see why MAP_WIPEONFORK and MAP_DONTDUMP have to
> be mmap() flags.

I don't think they have to be mmap() flags, but that said, I think
it's technically the better alternative than saying "you have to
madvise things later".

I very much understand the "we don't have a lot of MAP_xyz flags and
we don't want to waste them" argument, but at the same time

 (a) we _do_ have those flags

 (b) picking a worse interface seems bad

 (c) we could actually use the PROT_xyz bits, which we have a ton of

And yes, (c) is ugly, but is it uglier than "use two system calls to
do one thing"? I mean, "flags" and "prot" are just two sides of the
same coin in the end, the split is kind of arbitrary, and "prot" only
has four bits right now, and one of them is historical and useless,
and actually happens to be *exactly* this kind of MAP_xyz bit.

(In case it's not clear, I'm talking about PROT_SEM, which is very
much a behavioral bit for broken architectures that we've actually
never implemented).

We also have PROT_GROSDOWN and PROT_GROWSUP , which is basically a
"match MAP_GROWSxyz and change the mprotect() limits appropriately"

So I actually think we could use the PROT_xyz bits, and anybody who
says "those are for PROT_READ and PROT_WRITE is already very very
wrong.

Again - not pretty, but mappens to match reality.

> Interestingly, when looking into something comparable in the past I
> stumbled over "vrange" [1], which would have had a slightly different
> semantic (signal on reaccess).

We literally talked about exactly this with Jason, except unlike you I
couldn't find the historical archive (I tried in vain to find
something from lore).

  https://lore.kernel.org/lkml/CAHk-=whRpLyY+U9mkKo8O=2_BXNk=7sjYeObzFr3fGi0KLjLJw@mail.gmail.com/

I do think that a "explicit populate and get a signal on access" is a
very valid model, but I think the "zero on access" is a more
immediately real model.

And we actually have had the "get signal on access" before: that's
what VM_DONTCOPY is.

And it was the *less* useful model, which is why we added
VM_WIPEONCOPY, because that's the semantics people actually wanted.

So I think the "signal on thrown out data access" is interesting, but
not necessarily the *more* interesting case.

And I think if we do want that case, I think having MAP_DROPPABLE have
those semantics for MAP_SHARED would be the way to go. IOW, starting
off with the "zero on next access after drop" case doesn't make it any
harder to then later add a "fault on next access after drop" version.

> There needs to be better reasoning why we have to consume three mmap
> bits for something that can likely be achieved without any.

I think it goes the other way: why are MAP_xyz bits so precious to
make this harder to actually use?

Together with that whole "maybe use PROT_xyz bits instead" discussion?

               Linus
