Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DD53D0D0
	for <patches@lists.linux.dev>; Thu, 11 Jul 2024 05:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720674447; cv=none; b=OaP14WTw1ZBoUH7gd+kCGRZZI27yretzj5LhaB9GiOR1QAG1VBiBHuq/Pg0xiObua4TCEX48pg9lCy82O0kRZPATc5JkYDqHCC/YKP2C7fT0IQ+vgcMrt+U9k7fdb6NZaqqfuymWwA/fkgSptVh/ZN9o4nQpv2g3eO2cMcA6mXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720674447; c=relaxed/simple;
	bh=nGrmC0u5rsERqyefhRnP7/QKTu/yo7p7qovzWnDCLCk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pQ2CioFNBgiAty4wIN0nmEVtx47hjnwe6tMUi61qiOemx5WpqfjPKh80nuscp58VE+sjMGNizb7rLEZc1T+uZkw/dGbMNB2nnKYxGwbkRDObO82f+3pymCTbUgDosOB+IdOF0ogSHFJYZ9rB9JP0EbiGLvlvha7txGP84jek0bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UZ3pD1BP; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UZ3pD1BP"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a77af4cd570so39490766b.1
        for <patches@lists.linux.dev>; Wed, 10 Jul 2024 22:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720674442; x=1721279242; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jtRyIrmKJ/IBvDIrDZPP2KUo8CcYvxcVDEjZhvnGRqk=;
        b=UZ3pD1BPYhCJQUnhAWnUz+2TtS7CRBlWtczV22IjagZIuhali+oP/3jzGKWUoYfX3F
         ZDHukFRXlM2m4GDsJ+u/3foIKpHPEDRyM/kk9Dm2OitLEs27KQ4NZPWonO3NtUe+Zxbu
         MJD7FQ2F6eG2K8uRmNbu/Tc9I5zlJvdMFr6oQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720674442; x=1721279242;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jtRyIrmKJ/IBvDIrDZPP2KUo8CcYvxcVDEjZhvnGRqk=;
        b=LGPjjtrBZj40koVnggn9Py+3sZZVAhhCQEwOr/wTeWtn6s0JBa/OFLpMC/4aOblhcj
         5rTJ794/vENzyA4JTAE8C0AzO6Cz/FnJMKFVxJT2MY2Q6Azbr0pvUAvXtnqYQHSavY4h
         Ge5nLjg4fg1mPGw3J9MR7rZOrbwKslR07itVRUYuIi98QR5bLJeKnhyL++ha8+2lmqBk
         H9th5QqUAQM1RwHjnjl+P9623/TNNmAL/ZSZ/BsJqd1cDhd+0FCCT1axSuUEWllHSjh8
         PwirT6iAq6YN2+Bs3/Lf0jbyym/UirtPNLTG+tM1anogabU2jTZPj8aZa82OGxcgNvD+
         Zbdg==
X-Forwarded-Encrypted: i=1; AJvYcCX305VAyxGe/Y+msQc7ZsYKd3gkjDXLfiOoHPFRWjhV1matxTqte7Gfbe1grhrMlB3jvgrF02rtBQ93LWRoWP8zvyI7WthtXA==
X-Gm-Message-State: AOJu0YwMGWvZ4RG1gSmb6rzzf6ixuAnLcxG8XUSAjP/wGrzwCoiOHrcY
	Ief/9i61x+ed2a3NVhW5PJvbONZtponSgnq5ASdyGwtxayDqnV8BI0zgx8EyAZfThgJwkIvzmjG
	w1e4=
X-Google-Smtp-Source: AGHT+IHne+zdumjYOIhG0RLEm2F9UsJ3nnu0IfOl88XKoYkB/XtqOLnqrg9Ke/qt8XxQQBSWzBPY9w==
X-Received: by 2002:a05:6402:31aa:b0:58f:44fa:a2b9 with SMTP id 4fb4d7f45d1cf-594bb1816femr5960771a12.16.1720674442502;
        Wed, 10 Jul 2024 22:07:22 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-594bda308d7sm2959589a12.91.2024.07.10.22.07.20
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jul 2024 22:07:20 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-57ccd1111b0so369604a12.3
        for <patches@lists.linux.dev>; Wed, 10 Jul 2024 22:07:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUzqZKAEEisz8jiDz4P/ztHpoRj3LzOXcobIIBwyrUbRFHgQZv9wVvrotelT3hVlrKHUhblaX2bsm3WsOAIkH9etACAtjk+Gg==
X-Received: by 2002:a05:6402:134f:b0:58d:77e0:5c29 with SMTP id
 4fb4d7f45d1cf-594bb181cb8mr5703709a12.10.1720674440224; Wed, 10 Jul 2024
 22:07:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240709130513.98102-1-Jason@zx2c4.com> <20240709130513.98102-2-Jason@zx2c4.com>
 <378f23cb-362e-413a-b221-09a5352e79f2@redhat.com> <9b400450-46bc-41c7-9e89-825993851101@redhat.com>
 <Zo8q7ePlOearG481@zx2c4.com> <Zo9gXAlF-82_EYX1@zx2c4.com> <bf51a483-8725-4222-937f-3d6c66876d34@redhat.com>
In-Reply-To: <bf51a483-8725-4222-937f-3d6c66876d34@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 10 Jul 2024 22:07:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh=vzhiDSNaLJdmjkhLqevB8+rhE49pqh0uBwhsV=1ccQ@mail.gmail.com>
Message-ID: <CAHk-=wh=vzhiDSNaLJdmjkhLqevB8+rhE49pqh0uBwhsV=1ccQ@mail.gmail.com>
Subject: Re: [PATCH v22 1/4] mm: add MAP_DROPPABLE for designating always
 lazily freeable mappings
To: David Hildenbrand <david@redhat.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	tglx@linutronix.de, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, 
	x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Jul 2024 at 21:46, David Hildenbrand <david@redhat.com> wrote:
>
> Maybe we can find ways of simply never marking these pages dirty, so we
> don't have to special-case that code where we don't really have a VMA at
> hand?

That's one option. Jason's patch basically goes "ignore folio dirty
bit for these pages".

Your suggestion basically says "don't turn folios dirty in the first place".

It's mainly the pte_dirty games in mm/vmscan.c that does it
(walk_pte_range), but also the tear-down in mm/memory.c
(zap_present_folio_ptes). Possibly others that I didn't think of.

Both do have access to the vma, although in the case of
walk_pte_range() we don't actually pass it down because we haven't
needed it).

There's also page_vma_mkclean_one(), try_to_unmap_one() and
try_to_migrate_one().  And possibly many others I haven't even thought
about.

So quite a few places that do that "transfer dirty bit from pte to folio".

The other approach might be to just let all the dirty handling happen
- make droppable pages have a "page->mapping" (and not be anonymous),
and have the mapping->a_ops->writepage() just always return success
immediately.

That might actually be a conceptually simpler model. MAP_DROPPABLE
becomes a shared mapping that just has a really cheap writeback that
throws the data away. No need to worry about swap cache or anything
like that, because that's just for anonymous pages.

I say "conceptually simpler", because right now the patch does depend
on just using the regular anon page faulting etc code.

                 Linus
