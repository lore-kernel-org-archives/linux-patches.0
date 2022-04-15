Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216847A
	for <patches@lists.linux.dev>; Fri, 15 Apr 2022 22:19:03 +0000 (UTC)
Received: by mail-ej1-f41.google.com with SMTP id r13so17330273ejd.5
        for <patches@lists.linux.dev>; Fri, 15 Apr 2022 15:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2QtVXGfSn2N0rkhidefIOm+8RgDS4TB5h/qBI4Eiy4c=;
        b=QrGEuSyR0q+jdL2W8Yhgv/l15leR2PlJ+RE69Nk92ZEWjEl8top7q6+TqI0Qpj6GaE
         U9roWFN8VsX0OCnyj8L6IV78ggtpLzOOecvtS+46P4uqkAm4b5Zn2f4Ld/hwOYNyPxl3
         +GyIq814tNewte+DEdt9Cb/wYaupvpSLtaywU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2QtVXGfSn2N0rkhidefIOm+8RgDS4TB5h/qBI4Eiy4c=;
        b=dkZRJ8K2WBnnUaJY14xKSQQuPrX1GapFdWPQEohCDhuE9q9YVgAfp0OeOGWr9s2uD4
         NSYWMJXRRi6Hx8XlKgplqT1PRGK3iCoPV0oM3eMbGh++5tz5ulm3DIOM50pplAdSUGtv
         NeS4pdVVJEefOtwFm9xQYTP53Om/NHY6/k8HoeQ/w+IlIFdCcnFgbdr5ZfB4QsoBvx4u
         6uodO/foeOYsb9OZJ20OhG75Au9UTPfx5pV8tXtK/2yK1UxtKAo0hW26jXJ/h/SSkIMD
         exCltivOoGqHEvTPMIO9c2P9FlK0VzZS2tCmTj6gFGmAPNpVbissfzQ+URCrRQyv6X20
         qUbw==
X-Gm-Message-State: AOAM5315Dh0kiV0G+ub93UBDwN0dVyZmORJaagXjPpAJqAEJn11qkBc+
	w9bq5fxa10AbEylSZK197riAUSwUyEN6LEWQSVM=
X-Google-Smtp-Source: ABdhPJyOVAfzdVdqZfIzScrdwo/J50CGdP85LqkKYcMTra1vXqcMzm/DaTU6cTyke4/0QIxy4ZlAqQ==
X-Received: by 2002:a17:907:7242:b0:6e7:f185:18e2 with SMTP id ds2-20020a170907724200b006e7f18518e2mr774863ejc.577.1650061140995;
        Fri, 15 Apr 2022 15:19:00 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id z10-20020a170906944a00b006e8a6b20129sm2012240ejx.29.2022.04.15.15.19.00
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 15:19:00 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id k23so17339244ejd.3
        for <patches@lists.linux.dev>; Fri, 15 Apr 2022 15:19:00 -0700 (PDT)
X-Received: by 2002:a05:6512:3c83:b0:46d:452:5096 with SMTP id
 h3-20020a0565123c8300b0046d04525096mr653490lfv.542.1650060667675; Fri, 15 Apr
 2022 15:11:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org> <20220415021328.7D31EC385A1@smtp.kernel.org>
In-Reply-To: <20220415021328.7D31EC385A1@smtp.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Apr 2022 15:10:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
Message-ID: <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To: Andrew Morton <akpm@linux-foundation.org>, "the arch/x86 maintainers" <x86@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@suse.de>
Cc: patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>, 
	markhemm@googlemail.com, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 14, 2022 at 7:13 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Revert shmem_file_read_iter() to using ZERO_PAGE for holes only when
> iter_is_iovec(); in other cases, use the more natural iov_iter_zero()
> instead of copy_page_to_iter().  We would use iov_iter_zero() throughout,
> but the x86 clear_user() is not nearly so well optimized as copy to user
> (dd of 1T sparse tmpfs file takes 57 seconds rather than 44 seconds).

Ugh.

I've applied this patch, but honestly, the proper course of action
should just be to improve on clear_user().

If it really is important enough that we should care about that
performance, then we just should fix clear_user().

It's a very odd special thing right now (at least on x86-64) using
some strange handcrafted inline asm code.

I assume that 'rep stosb' is the fastest way to clear things on modern
CPU's that have FSRM, and then we have the usual fallbacks (ie ERMS ->
"rep stos" except for small areas, and probably that "store zeros by
hand" for older CPUs).

Adding PeterZ and Borislav (who seem to be the last ones to have
worked on the copy and clear_page stuff respectively) and the x86
maintainers in case somebody gets the urge to just fix this.

Because memory clearing should be faster than copying, and the thing
that makes copying fast is that FSRM and ERMS logic (the whole
"manually unrolled copy" is hopefully mostly a thing of the past and
we can consider it legacy)

             Linus
