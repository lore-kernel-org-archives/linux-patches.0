Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA102FE56F
	for <patches@lists.linux.dev>; Fri,  5 Jun 2026 16:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780676852; cv=none; b=CB0AcESMgkFamb9Zv6M1DcooUcGtYUV4vVrw3WIU45d2F5WtMqut5lRn2CIP7mWrcYof9M+luk94UyFRfOKOdzatvw1twG2d8Ik7uxhYRlUQzi+ZZchov6wQ2b/10rBCFrgUXjDTtzyrX2oAp1G1dyaac8ASeo51mrZJADMRY3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780676852; c=relaxed/simple;
	bh=xhA0BnyaS18CqnQuFNEb6UVKH5NtNpGJdPqoi2RFSA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SZNYnXxuC4N4MzOJGD1IdwLa0Jv5g38he8DgYKpnucW4Fzll0m6DPJ8+AGSxtFgLA93Q1Hd38WHwsRT0KNF89PE//3MgFgkU/kL8E3FJTiUIt943/O7iJHqw/wCaioIGVjomtDeDQsJkJJJ5LJH9SfVL0b8uhT0wnFUXiVxiAPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RrjgErUk; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RrjgErUk"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-bebb72b845aso306106966b.3
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 09:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780676848; x=1781281648; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2QDQNJjYqwPm+P0wBS/rB5uazpPW4+3idJB2lp6tmqM=;
        b=RrjgErUkZN8NMlrkIP0UqzMH21uIceXOAhOBSoqKe7wxd7Q7wTViJMurb470zURl/q
         xyRhW6fiItfREa1hUzHlbcXyq21PSJhYEzJ7sURT6hpqbQ5c6KU3lN+P6ZNc2st7cSXu
         2ZBfskafLysqywDAzOO5Pk1dZ6aO9yZwBWBbo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780676848; x=1781281648;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2QDQNJjYqwPm+P0wBS/rB5uazpPW4+3idJB2lp6tmqM=;
        b=C3kBSWNqTj+0n9DD/5KmzRZvEj8MtAel/KO8ziC/RA8cqL2cI0Q4DS0duMaOBit0Gd
         hjI5PX3KaJy+D7oz5cxiXvpFmJTLCTUamWCbLEAS6fVnsWWARt3it9me9t48ndJT8U46
         MJqNZ+kyaI+ksgAfYrU8uPhNqMY8tx+swo433qTTc5FpdLNtu3IpMhfBP553HQuu5kqd
         tX//gD1LVArMQtuvCYnHkiw0vLYSPVkhFeYzV9OPlGBbX1JjACeGPhhiE7k/mRC0QEGh
         d/j4h/xxouXgmTIsng0d+TVdgrbmgKN+50RxwY8qXN2xIkugwd7pr1j6m4wxGmauSf6M
         ZyVg==
X-Forwarded-Encrypted: i=1; AFNElJ+eL1KsNXmXJLaYUxQ4WOhqePa206QOJ7vZjEQCnGgsP44c0JrBUh/IM7OzFMH5hX37Xl/K3Vq4@lists.linux.dev
X-Gm-Message-State: AOJu0YxIvTrbWRaNd9h2TuXNHF6awFdTiwMHxUx//612T7tR8jpQeyJl
	QDdVvUhGCStEosLMAph9Kxfysn/2GW/a1FiHrh6GuoowJOqXWb1rLbIX18zFDTcWrHJ9tYaKAnT
	kmg1GGnId+g==
X-Gm-Gg: Acq92OEgLSuWJdJ7S3jXtFVJ++ipCfP5evjpwBJULb3ezDZmHUm0nIMp7HR1CPtQdJI
	IaYGlYcPVSkZyKKWftHYuhOyifZqEehVXWZtoTAN1eX/VUcDjkp3NZtf6LELvd2anohAEYjAcsD
	SuOUH3AoI3cKJy5GwEYb+PYbgVa7tfxWm7mTWQiQy38Q1oHm0YuYwU1dMZsIs5am+0Lk1BiZ6Ym
	HU/v9C/s77j2noPd8KdzjH5HUxAWRkcdgQLObiE5c60iQEGsNRNh+V5KrFeB2H3K7e7Z3odrsjH
	LWEMF25xeD0jkunzDkbrW8JFR5jLZ4cMFzUUPMf+C0K+8hwM/5UDT5ZbdJWywe19tkJUbpre/Oo
	ns+P3210wliqhmIneLYYbooRzcKTWlQkjQfgobBjW70NFW2RzkBNT4h7M4JGECmDBYmjCkdLG+L
	znytlL67/BXHsbixLyC7CJzQBy1rdM1pz0Gn+wuNMDUbM7WyP4HjEZnih5C9TihIZPYZUW0kHZ9
	BlNEoL2SOE=
X-Received: by 2002:a17:907:6d24:b0:bec:fad3:5b58 with SMTP id a640c23a62f3a-bf37234b03bmr232133366b.27.1780676847904;
        Fri, 05 Jun 2026 09:27:27 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf054e04a89sm481097266b.41.2026.06.05.09.27.26
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 09:27:26 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-68ced97b6eeso3098133a12.0
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 09:27:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9bTvFsxyYhzk5NKBPnn08SdYrkKDpYLDN64hSJn4Prcz0nenwn92BXVrYWZ5RbTzf+nBUwhDNM@lists.linux.dev
X-Received: by 2002:a17:906:4fca:b0:bec:5264:ee9b with SMTP id
 a640c23a62f3a-bf372c2dbabmr257257066b.36.1780676845718; Fri, 05 Jun 2026
 09:27:25 -0700 (PDT)
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
In-Reply-To: <CAHk-=wjkZSAhxykvG6tQM5DnBoS30_XCKkYpCsQwEGcxJb=i3Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Jun 2026 09:27:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=whMTq8_2rpYoZgoxVCwj=LsvfzHzPuwo-NcizT7J24MPQ@mail.gmail.com>
X-Gm-Features: AVVi8CcJjF0IzkUXs5jB8j5aKjJm1d1LQ0EBlpf4RydnYVXz3zkkVCs-hralHh4
Message-ID: <CAHk-=whMTq8_2rpYoZgoxVCwj=LsvfzHzPuwo-NcizT7J24MPQ@mail.gmail.com>
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

On Fri, 5 Jun 2026 at 08:54, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> If it were to have the same issue that powerpc(*) had - that 'unsigned
> int' has to be passed to functions with well-defined high bits - that
> would be bad.
>
> And I'm pretty sure that clang doesn't do that.

It's perhaps worth nothing *why* it's horribly bad and why I think the
powerpc ABI is nasty: it means that *some* things are done in 32 bits,
but other things then expect the upper bits to always match.

It caused security issues, where user space would (for example) pass
in a 'int fd' what was value in the low bits, and then had interesting
upper bits.

The range check in the kernel would then compare fd to max_fds - using
a 32-bit unsigned compare - and see that it is all in range.

Then it would use the *exact same fd variable* to index into the fd
array, but the compiler would use the full 64-bit value for that array
dereference - without having ever checked those upper bits. And it had
passed the unmodified full 64-bit value around the whole time, all the
way from untrusted user space, and the kernel code all looked
"obviously correct" and had all the proper checks in place.

If you want to bleed out of your eyes, take a look at the rather
horrendous macros in <linux/syscalls.h> (and the sometimes even more
horrendous arch 'syscall_wrappers.h' files).

They deal with issues like this - and others - with some truly
inscrutable code. You have to be super-human to be able to read it,
but those wrappers are why we can then just do things like

   SYSCALL_DEFINE2(setregid, gid_t, rgid, gid_t, egid)

and it will generate not only infrastructure for tracing etc, but also
the code necessary to force clean up the types for the architecture.

                    Linus
