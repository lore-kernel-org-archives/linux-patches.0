Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCDC8F57
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 19:54:54 +0000 (UTC)
Received: by mail-qt1-f182.google.com with SMTP id a16so25391692qtw.10
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 11:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2Xug8HsBhB4vw61CYQrO6p56II484h234IA/MNnX9p8=;
        b=EbYiDfIyp249xUh5FwvkVnPr7aBXtVFVGZSFtl9pIKq68SODoEw8kZPQnYL8sXX69z
         F8E5UHAWixIJOtaSy7hFVhbt6eKa4sXCG4zalB7Ox/hGl++YbRVBW/YzL9Wjbkm4SzAX
         YQKeVGr58BgkVk4yWdEMW4R74YCb6drskvcyg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Xug8HsBhB4vw61CYQrO6p56II484h234IA/MNnX9p8=;
        b=Y6Vx//rtiqZyueAn0FwWIy1rWIgvAvtZiSN5v/9ytzbl4pDljmetiWtyZkOpHLUMN/
         86j9Y/0oqNhbAAPiE4plvG640UeV/yb9+1WSo+LsgTUiE9egFa7p616s3X8QFvctqmIR
         Z7H5p6newVwgVAQYDf333r0uJZNSFRNn8L+n5Xig4cYqkOOY2L4Zqns3jy0wbmLPBXgA
         CUI+CVVqAYmSKyRjx7Y235vC89YtqilHAr9y6Msq+IBWGkCxGKUkbFsMXArNbF9XnHom
         iMRzMWBUE3lGi5WaSKLSzaL8Oc+5wy9fmVgsyolKB542/8nedrwzd+9GdLqxAAjZRZyb
         vXDg==
X-Gm-Message-State: AFqh2ko1UTxZA6z0JP4Ql8ZbXVCLvnFtFBxjVrUGp/E5l6r4ZYfQjx9m
	bbsYE+Rjy9Y1bx/2laMBe0mtsxhPCrIdUQHj
X-Google-Smtp-Source: AMrXdXtMRDy9v29CCLySYcLHJQgUHYlWjWvCrstaYc8Vi46M73Vp5kGvoZfnpQX/3Zo3HDPk5R4C2A==
X-Received: by 2002:ac8:4a86:0:b0:39c:da20:f6df with SMTP id l6-20020ac84a86000000b0039cda20f6dfmr61280040qtq.3.1672775693310;
        Tue, 03 Jan 2023 11:54:53 -0800 (PST)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com. [209.85.160.180])
        by smtp.gmail.com with ESMTPSA id i17-20020a05620a405100b006fcb77f3bd6sm23312291qko.98.2023.01.03.11.54.52
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 11:54:52 -0800 (PST)
Received: by mail-qt1-f180.google.com with SMTP id v14so22634560qtq.3
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 11:54:52 -0800 (PST)
X-Received: by 2002:ac8:4913:0:b0:3ab:88cb:97cb with SMTP id
 e19-20020ac84913000000b003ab88cb97cbmr986538qtq.436.1672775691842; Tue, 03
 Jan 2023 11:54:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230101162910.710293-1-Jason@zx2c4.com> <20230101162910.710293-3-Jason@zx2c4.com>
 <Y7QIg/hAIk7eZE42@gmail.com> <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
 <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com> <Y7SDgtXayQCy6xT6@zx2c4.com>
In-Reply-To: <Y7SDgtXayQCy6xT6@zx2c4.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jan 2023 11:54:35 -0800
X-Gmail-Original-Message-ID: <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
Message-ID: <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, tglx@linutronix.de, linux-crypto@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 3, 2023 at 11:35 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> I don't think this is about micro-optimization. Rather, userspace RNGs
> aren't really possible in a safe way at the moment.

"Bah, humbug", to quote a modern-time philosopher.

It's humbug simply because it makes two assumptions that aren't even valid:

 (a) that you have to do it in user space in the first place

 (b) that you care about the particular semantics that you are looking for

The thing is, you can just do getrandom(). It's what people already
do. Problem solved.

The system call interface just isn't that expensive. Sure, the various
spectre mitigations have screwed us over in a big way on various
hardware, but even with that in mind system calls aren't some kind of
insurmountable hazard. There are absolutely tons of system calls that
are way more performance-critical than getrandom() has ever been.

So 99% of the time, the solution really is just "getrandom()",
generally with the usual buffering ("read more than you need, so that
you don't do it all the time").\

Which is not at all different from all the other system calls like
"read()" and friends.

And that's entirely ignoring the fact that something like "read()"
basically *has* to be a system call, because there are no alternatives
(ok, mmap, but that's actually much slower, unless you're in it for
the reuse-and/or-sparse-use situation).

With random numbers, you have tons of other alternatives, including
just hardware giving you the random numbers almost for free and you
just using your own rng in user space entirely.

And yes, some users might want to do things like periodic re-seeding,
but we actually do have fast ways to check for periodic events in user
space, ranging from entirely non-kernel things like rdtsc to actual
vdso's for gettimeofday().

So when you say that this isn't about micro-optimizations, I really
say "humbug". It's *clearly* about micro-optimization of an area that
very few people care about, since the alternative is just our existing
"getrandom()" that is not at all horribly slow.

Let me guess: the people you talked to who were excited about this are
mainly just library people?

And they are excited about this not because they actually need the
random numbers themselves, but because they just don't want to do the
work. They want to get nice benchmark numbers, and push the onus of
complexity onto somebody else?

Because the people who actually *use* the random numbers and are *so*
performance-critical about them already have their own per-thread
buffers or what-not, and need to have them anyway because they write
real applications that possibly work on other systems than Linux, but
that *definitely* work on enterprise systems that won't even have this
kind of new support for another several years even if we implemented
it today.

In fact, they probably are people inside of cloud vendors that are
still running 4.x kernels on a large portion of their machines.

          Linus
