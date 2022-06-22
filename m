Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0E2111B
	for <patches@lists.linux.dev>; Wed, 22 Jun 2022 21:07:39 +0000 (UTC)
Received: by mail-ej1-f41.google.com with SMTP id t5so4365838eje.1
        for <patches@lists.linux.dev>; Wed, 22 Jun 2022 14:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vdV4khN9jbInqLI4CoGJr0aFm/O0NmyVKymv5AnToq8=;
        b=XLKkNjFRt1C0ChxBi2kAg8Go9eskGrlfI4csxSmooiP/W7x9Ujt3ZyNelAZ686R9pW
         N498trRQ8h/Q27iBMd+gsaT7IOwDVGZU5ZS48n09MfaRcVZHXqpBa6ZAlDFUIh3F1ViM
         MR6hh0LV1ZnhBVGrTq0GaUQEN6nCffHi5cKQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vdV4khN9jbInqLI4CoGJr0aFm/O0NmyVKymv5AnToq8=;
        b=DTPakEOFfYRNpLL4dhhGBnClx9hvtpJ2YjVd+ZxkpK+xfNwgRqt2p81rh/ocunlLaw
         rJiHGSgQUzSV9lNbL6HnDavoH06/skHk51JRkp08yYAaSGMWDyTY4BWBmNp5MukDBaUG
         LKKS1TmMkI9UR4zOlpFM8f7Tv7Kdu4fE8wU7v6+B8klv4Q+e/zkYPxKT+AnwLbQ8+kz9
         UN9nIsa2ZboKdJ+SAombFWOSpHHEXqw8GyemF4skFoynjTEMrKWrH+8dr+zvnVJswaGA
         cmycz9OAfKFUZ28pyJ4o+wbPfqlvsWd0QWhCisJ1QRb7FoC21EBISZrK0FrD6+mgjTRO
         WpBQ==
X-Gm-Message-State: AJIora85cID5UykyA8nIGqvIe9cw6h8P+xzNwZCjB9FEDc/YNz/oYos3
	SnU8M4qRVjOtZyezjXAQqFVFw5S3gsllYC8V
X-Google-Smtp-Source: AGRyM1vunPqsiY8qXJYZXag7r/D+qAbPgQ1HECyelNEddI49EOU9E9Wc1fKJO5E27/hvBfLdYasiHQ==
X-Received: by 2002:a17:906:6d98:b0:715:76eb:9e33 with SMTP id h24-20020a1709066d9800b0071576eb9e33mr4910512ejt.729.1655932057627;
        Wed, 22 Jun 2022 14:07:37 -0700 (PDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com. [209.85.128.52])
        by smtp.gmail.com with ESMTPSA id cm28-20020a0564020c9c00b0043577da51f1sm9718380edb.81.2022.06.22.14.07.36
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 14:07:36 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id u12-20020a05600c210c00b003a02b16d2b8so340481wml.2
        for <patches@lists.linux.dev>; Wed, 22 Jun 2022 14:07:36 -0700 (PDT)
X-Received: by 2002:a05:600c:354c:b0:39c:7e86:6ff5 with SMTP id
 i12-20020a05600c354c00b0039c7e866ff5mr270015wmq.145.1655932056146; Wed, 22
 Jun 2022 14:07:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic> <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic> <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
 <YnqqhmYv75p+xl73@zn.tnic> <Ynq1nVpu1xCpjnXm@zn.tnic> <YozQZMyQ0NDdD8cH@zn.tnic>
 <YrMlVBoDxB21l/kD@zn.tnic> <CAHk-=wgmOfipHDvshwooTV81hMh6FHieSvhgGVWZMX8w+E-2DQ@mail.gmail.com>
 <YrN4DdR9HN0srNWe@zn.tnic>
In-Reply-To: <YrN4DdR9HN0srNWe@zn.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Jun 2022 16:07:19 -0500
X-Gmail-Original-Message-ID: <CAHk-=wj_MeMUnKyRDuQTiU1OmQ=gfZVZhcD=G7Uma=1gkKkzxg@mail.gmail.com>
Message-ID: <CAHk-=wj_MeMUnKyRDuQTiU1OmQ=gfZVZhcD=G7Uma=1gkKkzxg@mail.gmail.com>
Subject: Re: [PATCH] x86/clear_user: Make it faster
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 22, 2022 at 3:14 PM Borislav Petkov <bp@alien8.de> wrote:
>
> before:
>
> $ dd if=/dev/zero of=/dev/null bs=1024k status=progress
> 400823418880 bytes (401 GB, 373 GiB) copied, 17 s, 23.6 GB/s
>
> after:
>
> $ dd if=/dev/zero of=/dev/null bs=1024k status=progress
> 2696274771968 bytes (2.7 TB, 2.5 TiB) copied, 50 s, 53.9 GB/s
>
> So that's very persuasive in my book.

Heh. Your numbers are very confusing, because apparently you just ^C'd
the thing randomly and they do different sizes (and the GB/s number is
what matters).

Might I suggest just using "count=XYZ" to make the sizes the same and
the numbers a but more comparable? Because when I first looked at the
numbers I was like "oh, the first one finished in 17s, the second one
was three times slower!

But yes, apparently that "rep stos" is *much* better with that /dev/zero test.

That does imply that what it does is to avoid polluting some cache
hierarchy, since your 'dd' test case doesn't actually ever *use* the
end result of the zeroing.

So yeah, memset and memcpy are just fundamentally hard to benchmark,
because what matters more than the cost of the op itself is often how
the end result interacts with the code around it.

For example, one of the things that I hope FSRM really does well is
when small copies (or memsets) are then used immediately afterwards -
does the just stored data by the microcode get nicely forwarded from
the store buffers (like it would if it was a loop of stores) or does
it mean that the store buffer is bypassed and subsequent loads will
then hit the L1 cache?

That is *not* an issue in this situation, since any clear_user() won't
be immediately loaded just a few instructions later, but it's
traditionally an issue for the "small memset/memcpy" case, where the
memset/memcpy destination is possibly accessed immediately afterwards
(either to make further modifications, or to just be read).

In a perfect world, you get all the memory forwarding logic kicking
in, which can really shortcircuit things on an OoO core and take the
memory pipeline out of the critical path, which then helps IPC.

And that's an area that legacy microcoded 'rep stosb' has not been
good at. Whether FSRM is quite there yet, I don't know.

(Somebody could test: do a 'store register to memory', then to a
'memcpy()' of that memory to another memory area, and then do a
register load from that new area - at least in _theory_ a very
aggressive microarchitecture could actually do that whole forwarding,
and make the latency from the original memory store to the final
memory load be zero cycles. I know AMD was supposedly doing that for
some of the simpler cases, and it *does* actually matter for real
world loads, because that memory indirection is often due to passing
data in structures as function arguments. So it sounds stupid to store
to memory and then immediately load it again, but it actually happens
_all_the_time_ even for smart software).

            Linus
