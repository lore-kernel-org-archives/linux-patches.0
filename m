Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F3633E0
	for <patches@lists.linux.dev>; Wed,  4 May 2022 21:10:12 +0000 (UTC)
Received: by mail-lf1-f49.google.com with SMTP id h29so4438315lfj.2
        for <patches@lists.linux.dev>; Wed, 04 May 2022 14:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BzzdOhDCt7eGrJ7xSteppF2rocbVTzQejsLnteplBXw=;
        b=G/uHV4KHjrOdCRN0Bt8mqA4pguX8W1qcHv0gGuAd97wP/QslpB2qDFxa7IfUIT5J3t
         mUbsems5znzgRkH9P2ZlZb46huiEXWv6fSYf2SgGQ0krbAOm/yiILUWx0tq9SyUOIvIX
         jZcvCaQ1+6pvBACBzKU8inDQoZxGLDjiJD0uI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BzzdOhDCt7eGrJ7xSteppF2rocbVTzQejsLnteplBXw=;
        b=OZhFKD0bMB4ZPSN8uPnSog5/kqv2B8OgKCkWk8eSJhpW8haC7Wjo/99rDFzSAqAVxq
         mJgrandavCVijoQlaEMdwiEPETMyNouOC29qFK07NyLitZ8zRg0mFhqts/8vmO/LVnIH
         8kJYlqnmJn0r3IMY4skT4roMh7xwtEGoADc1d9iWauOrZby564deInLr5bs8UuYFVNHN
         cxFFWcV+nnEVxVUF04WQ2UvdsT/aAC8VT69gKpHCY4fmUM5evQBOFOeSOuMXzkaPB4A1
         Ly3SYllY66ZaLxfsjleynpTawoBVPuaMI0gX4m/VNaNewi9NeJWm9mOJe5FjDqyzVHEl
         /kbA==
X-Gm-Message-State: AOAM531kK/uynCLb9rfumcPqEo2l7klb5fh41rclVePhgoSAhYWodzW8
	s7WBUEXTlwIYYYCyoKuVnzHG1uDW3imRVIpnlj4=
X-Google-Smtp-Source: ABdhPJwPaOhVheewFsABugWg2kzowoFYP2cNUj+edriO5+pF+EeOiyH8aG4t+te0Fghs2nMIDvMctw==
X-Received: by 2002:ac2:52a5:0:b0:471:fd11:2768 with SMTP id r5-20020ac252a5000000b00471fd112768mr14564376lfm.318.1651698610780;
        Wed, 04 May 2022 14:10:10 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id h18-20020ac25d72000000b0047255d210e2sm1305142lft.17.2022.05.04.14.10.09
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 14:10:09 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id t25so4424136lfg.7
        for <patches@lists.linux.dev>; Wed, 04 May 2022 14:10:09 -0700 (PDT)
X-Received: by 2002:a05:6512:b12:b0:44a:ba81:f874 with SMTP id
 w18-20020a0565120b1200b0044aba81f874mr15971597lfu.449.1651698608781; Wed, 04
 May 2022 14:10:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YmWm5AXdwgwu57KZ@zn.tnic> <CAHk-=wgFnTbbeR0NAsGGsoBBThXt9Zh5_acN47r4CF0PdgSNeA@mail.gmail.com>
 <YmiK7Bos+zLAvL0t@zn.tnic> <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
 <YmkdxaKdc2w/3I7o@zn.tnic> <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
 <YnLMSWbz6BNfsBME@zn.tnic> <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic> <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic>
In-Reply-To: <YnLplKy0Y66SsvQw@zn.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 May 2022 14:09:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
Message-ID: <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"

On Wed, May 4, 2022 at 2:01 PM Borislav Petkov <bp@alien8.de> wrote:
>
> I could try to do a perf probe or whatever fancy new thing we do now on
> clear_user to get some numbers of how many times it gets called during
> the benchmark run. Or do you wanna know the callers too?

One of the non-performance reasons I like inlined memcpy is actually
that when you do a regular 'perf record' run, the cost of the memcpy
gets associated with the call-site.

Which is universally what I want for those things. I used to love our
inlined spinlocks for the same reason back when we did them.

Yeah, yeah, you can do it with callchain magic, but then you get it
all - and I really consider memcpy/memset to be a special case.
Normally I want the "oh, that leaf function is expensive", but not for
memcpy and memset (and not for spinlocks, but we'll never go back to
the old trivial spinlocks)

I don't tend to particularly care about "how many times has this been
called" kind of trace profiles. It's the actual expense in CPU cycles
I tend to care about.

That said, I cared deeply about those kinds of CPU profiles when I was
working with Al on the RCU path lookup code and looking for where the
problem spots were.

That was years ago.

I haven't really done serious profiling work for a while (which is
just as well, because it's one of the things that went backwards when
I switch to the Zen 2 threadripper for my main machine)

                  Linus
