Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A703928640C
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 01:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780537957; cv=none; b=SKLf3cDZxNwzpVaQBEDR8xH7pOOra6JjYAl92cNhR6hXquAKSBlEN72ItMAa3l88lFGsxVdCR1jNWdOuUozdhNSYhKTxH4cleren5lqfYwk8G9zxthnqF61mZekPfYuJ2PSW16vdoUelXsa5lVca9JTO/2PovmNdd1XcLzBAHiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780537957; c=relaxed/simple;
	bh=n1SkdCcNZQRg1IgD5sSmDSj8j+GpuHeY4/Td660VL9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gfqET62z3AH8nKfgnZlH4OvCbu4av70x4pQQUI0HpDDN1uQc6oyiExOBNvQAAtCjwEI3smGU88X/U5JVk+wPcy5lGLLd7pXD8CD5KPSudvbpgM+ezk3R/zttol6pf5DXayNMVm68odf6rkphL+l7TheI8vt4XuTRfVmzbPkOmkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jh6IxDZQ; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jh6IxDZQ"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bec429c2bb1so20877966b.1
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 18:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780537954; x=1781142754; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ti3H/yNlOCN9jiz2PA4OGwlivuSMT91KkxAffb1eRD4=;
        b=Jh6IxDZQ8Ul/GMNEOTP/naUaOR0hoqk7Db3f1wyS7oNvJNOsGcTNY8LbW4is9dVUX1
         RPvKNioXJmKeqOFyZvbuE6/kD+tOoD4tnB2hludv9WSpRC5dZyTYYc5hT5H7Tnfu2Kta
         SVvSj4kzFf2BTXZ5gYxIHNQjmCBGOXnTFFVvk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780537954; x=1781142754;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ti3H/yNlOCN9jiz2PA4OGwlivuSMT91KkxAffb1eRD4=;
        b=Xlw6eqNjvCHQPmH+x9m2adsdea2fFiCv+ypiJJA3y23e9XROzS3GHWsSGNqnxIdFQI
         fbJaXWKTojyr2lEwYq2ey5vLd6DX8DYgz5Fut9NCDpX0O6My/SFz08Phbw9w1lnq35ge
         0VfWhQ6mAU9md6iG8qbXgyBC4f/gZYCCwuOIp4w+oefsPBXw30JAqWEHm70UXroORmN3
         //PGS1szit4lcGU4sfhvBNCiNeBu95UDNiDxOGVMrhvN6Zzg2oteRjnC80UO6CEHIBYY
         xSh/yhxOxHkcb8QBobcPTuJejJn6qblrS+UYIfLRQs/x5YQP9JwYgPB54pZZG9rQ0WFq
         QdnQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Rgc9x/UV8YIrL0Kcl34DB5K5Y+vX6ZS0c+1jr1VhkKswduUheQUScDvSkkAcyVBrW4LwHf/ET@lists.linux.dev
X-Gm-Message-State: AOJu0YyzrbkwHED9LLnsCe+iVvkDjmT25HVWjaSHw5CXxAdFD2dp7qsJ
	pLbVjG16xTPIx0KlJtwPebqtlkidtpVYBLFD+K65k1G8jqB3/Ru6Xeyr7VglAYMswLocrGn71r8
	Ag5e54HnjaA==
X-Gm-Gg: Acq92OHtybXHgwmeM9eiCvFpCcf7g5w+ieeupBWtiNEARZA+5NlFhalB3uzsMOfUeqv
	vuGXvdETHvHJuzWwnHbIkTeEOTgbNOfVRVvC6So1V/lo/iicYZrP1Yt9Oe7oXTFAaOkFkN8lxeJ
	1ZYLXVCWKWT0ZaA7IQqF9XupAsXWAbRILBbtYcV4EYe1MnGzj/8W7msu+nVmcq8W00QsrXm4D9q
	FCi7n6MDDqj7/3Dmja6pfTvrh8gyAZXpZukTu54l4taBVV8w9OAyMKkA1MlqD7Gy5mtW3ZyYHCI
	iv6bhK+EInO9+AbVJodbTkqvUpyfMURP+gmmZmw20+1mr2YRxzXzrKhjqZSwLYze7iMnAtLidyZ
	UzXv56+nzo/CNU/KcNTuQKxOxB1DGweZj625ttvuDFRW4Z8eXe6Y0MKf7WFyohFcFeQiVqn4As2
	PBWvy6PFVEsxVrav+BKhQu6dH3W4k1w4qrJ5hC2J4nKwBIgTaRV0iwTqh6U6aAQaEH80z9j0TW2
	s4siNvN7Bo=
X-Received: by 2002:a17:906:5a53:b0:bec:5865:6c63 with SMTP id a640c23a62f3a-bf0ae3feed9mr218954066b.26.1780537954051;
        Wed, 03 Jun 2026 18:52:34 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf05228a16csm230512566b.28.2026.06.03.18.52.32
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 18:52:33 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-68bac6e24fdso178855a12.1
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 18:52:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/Lr9p2ij7YIdd7narIdfGSI+cl2EivPQtvFOuYr9dXgjn1Fl4ENxqRA6ILdJuXwzrFw48swlbQ@lists.linux.dev
X-Received: by 2002:a05:6402:550a:b0:66d:d2f9:520c with SMTP id
 4fb4d7f45d1cf-68e72250122mr2844444a12.19.1780537952777; Wed, 03 Jun 2026
 18:52:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com> <20260604004559.1112474-1-safinaskar@gmail.com>
In-Reply-To: <20260604004559.1112474-1-safinaskar@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 18:52:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgPzxQL9Bdze=qnSa5v8A2D6cPaU0Bi=j4N38+ja1NkzQ@mail.gmail.com>
X-Gm-Features: AVHnY4Ia6Rugs2gzhFv567LCSFsgwGvMvJbpyqp7BVsPOVMqNGKAIqxMQwoy6bY
Message-ID: <CAHk-=wgPzxQL9Bdze=qnSa5v8A2D6cPaU0Bi=j4N38+ja1NkzQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org, 
	david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jun 2026 at 17:46, Askar Safin <safinaskar@gmail.com> wrote:
>
> For example, in vmsplice I do "CLASS(fd, f)(fd)" and then I pass
> "fd" (i. e. integer) to "do_writev/do_readv". I don't know whether
> this is okay to do so.

Oh, good point.

It's ok in the sense that it will work, and it's not really going to
cause problems, but it does mean that the 'struct file' will be looked
up twice.

And *technically* it's a TOCTOU race, where the first time you look it
up - in the vmsplice() wrapper - it could be one file, and you make
decisions based on that. And then pass it off to do_writev(), and it
will look it up again, and now it might be a different file.

Does it *matter*? No. Even if the file changed, and is now something
else, it's just going to be a different file that the user does
writev() on. do_writev() will still do all the appropriate safety
checks etc, so it doesn't really change anything. It just means that
you could pass what you *think* is a pipe (because you did that

+       if (!get_pipe_info(fd_file(f), /* for_splice = */ false))
+               return -EBADF;

and by the time do_writev() then looks up the fd again it might be
something else, and now the user used vmsplice() as a really odd way
to write to a another non-pipe file instead. But the user could have
done that with a regular writev(), so it's just the user being silly -
not something that really confuses the kernel.

Coimpletely harmless, in other words.

But it would probably be *cleaner* to pass in the 'struct file *'
pointer that you already looked up once instead, and use vfs_writev()
instead of do_writev().

And I do suspect that the wrapper system call should use the same

   SYSCALL_DEFINE4(vmsplice, int, fd, ..

that the original used. Because it somebody crazy had the high bits
set in 'fd', the old vmsplice() system call didn't care, but your new
emulation system call will actually see the high bits on a 64-bit
architecture.

Again - that doesn't actually *matter*, because "CLASS(fd)" takes an
"int fd" and those high bits will be masked out at use time both in
vmsplice() and in do_readv/writev().

So it won't affect any behavior, but it does look a bit odd in the conversion.

And I already answered Christian wrt the change in behavior: I think
RWF_NOWAIT should always be set on the writing side - because splice()
never waited after it filled a pipe - and instead that
SPLICE_F_NONBLOCK flag should be used before write to check for
whether we'll wait *before* doing the write like it used to do with

        ret = wait_for_space(pipe, flags);

in vmsplice_to_pipe().

(On the other side, vmsplice_from_pipe() used to do
pipe_clear_nowait(), but I think that becomes a non-issue with the
conversion to readv()).

And once you need wait_for_space(), that probably means that the new
vmsplice() wrapper simpler needs to remain inside fs/splice.c, and we
just need to make vfs_readv/vfs_writev non-static.

              Linus
