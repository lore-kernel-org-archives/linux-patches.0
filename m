Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4F98F57
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 20:26:18 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id c7so25467860qtw.8
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 12:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mWQdhtHM3K1oyggbO+2dMJUZwBODavvxc7yTyFJ0lYI=;
        b=YDVCUDbgAeW0hVhs/g4JjH8kmsFuPnrsSO3rAzaQ8238JVlCpbbDmM/of5LDiFQ3ZR
         LsAhZ7OQBiszg4rGxhyYNLNLxWf8NjQaNJc7Q3pNZtyzmOdKo7YOKp1HwocTpMcHw08J
         Lp1wNe7fgslKvAudNAcF7WhpB5/QExxKAzdR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mWQdhtHM3K1oyggbO+2dMJUZwBODavvxc7yTyFJ0lYI=;
        b=q3O4+zXxCsLSWxC9gKb0uktSPM3IeyJ0v2uUXAnF8Zmd/0ULpSMEUKeYA5gBN2JPuz
         x9/hdq1WKhu1j4irIpYEWWl9mYZe/diXBQGTIS4d4qEksfe8HpzqV6SsKSJVAPX2FMYV
         Bfdt/dOF9sdhxyn5RRxo5U0ZDcFQeWL4dpIO/TjP2O/bdTE5u7NYviLWMQuxIkAAN2GA
         xwZMf5eb14lijim2ww15RZMBmDOOjGKJZZExqqy1hLHMsSum6F4NMx4gZLoSF5PSfidF
         VfK0bDfUVVgvHfA4L+V+GcB8lP34Zor7tVLAwSB6odUKx2ca4iktjn8KqQRAq9kKnpoD
         D+Uw==
X-Gm-Message-State: AFqh2kraJd2Ko84MTYG8oM9zz3SfjSFRmWBiCj+6dzAAagKhJ9edXZXQ
	EuJGRuNwoN7LmYjPSlnKFUEWPjQeG/c4vcMf
X-Google-Smtp-Source: AMrXdXvPnKBJCHigz77Ip4kZcro8IZebCazAeK2Uol44dVWr9r0xwMX9N8RuqJBrAoGOXtl33ULj4w==
X-Received: by 2002:ac8:6641:0:b0:3a9:7f7b:b9b0 with SMTP id j1-20020ac86641000000b003a97f7bb9b0mr57407056qtp.45.1672777577462;
        Tue, 03 Jan 2023 12:26:17 -0800 (PST)
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com. [209.85.222.177])
        by smtp.gmail.com with ESMTPSA id l3-20020ac80783000000b003a4f22c6507sm19258302qth.48.2023.01.03.12.26.15
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 12:26:15 -0800 (PST)
Received: by mail-qk1-f177.google.com with SMTP id k3so15336025qki.13
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 12:26:15 -0800 (PST)
X-Received: by 2002:a05:620a:1379:b0:6fc:c48b:8eab with SMTP id
 d25-20020a05620a137900b006fcc48b8eabmr1659307qkl.216.1672777574921; Tue, 03
 Jan 2023 12:26:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230101162910.710293-1-Jason@zx2c4.com> <20230101162910.710293-3-Jason@zx2c4.com>
 <Y7QIg/hAIk7eZE42@gmail.com> <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
 <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
 <Y7SDgtXayQCy6xT6@zx2c4.com> <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
 <Y7SJ+/axonTK0Fir@zx2c4.com> <CAHk-=wi4gshfKjbhEO_xZdVb9ztXf0iuv5kKhxtvAHf2HzTmng@mail.gmail.com>
In-Reply-To: <CAHk-=wi4gshfKjbhEO_xZdVb9ztXf0iuv5kKhxtvAHf2HzTmng@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jan 2023 12:25:59 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg4SRHF6AhYDcgyokN2BMjra91Ns4h9wWPachhf-x3=xQ@mail.gmail.com>
Message-ID: <CAHk-=wg4SRHF6AhYDcgyokN2BMjra91Ns4h9wWPachhf-x3=xQ@mail.gmail.com>
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

On Tue, Jan 3, 2023 at 12:15 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Jan 3, 2023 at 12:03 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > That buffering cannot be done safely currently
>
> .. again, this is "your semantics" (the (b) in my humbug list), not
> necessarily reality for anybody else.

Just to make an example: fork() is already problematic for something
as fundamental as <stdio.h>.

That doesn't mean that we do a special fork-safe stdio.h
infrastructure in the kernel. It just means that people have to do
things like fflush(NULL) (or use variations of setbuf() and friends)
when they deal with fork() and stdio interactions.

The random number generator really isn't that different. Periodic
reseeding isn't something stdio has to deal with, but having a
timestamp in user space library and forcing a re-seed isn't unheard of
in other contexts.

You don't even need anything as fancy as an actual timer, because it
doesn't need *active* flushing, just a "oh, it's been too long since
we read the random data, let's do it again".

And yes, I bet it would be a good idea to have an actual library for
this that handles (and *documents*) these kinds of issues - exactly
like a <stdio.h>, just for randomness.

I just don't think it should be involved in the kernel - again exactly
like <stdio.h>.

            Linus
