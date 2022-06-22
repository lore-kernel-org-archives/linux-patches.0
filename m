Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C961843
	for <patches@lists.linux.dev>; Wed, 22 Jun 2022 15:07:03 +0000 (UTC)
Received: by mail-ej1-f50.google.com with SMTP id v1so34825477ejg.13
        for <patches@lists.linux.dev>; Wed, 22 Jun 2022 08:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JtKGSY+EwrQu/E5It51yjVvXryiaGnECNUkZx2C4dtM=;
        b=cO9wuTZr6hgOa/H1lK7keG1p9tQrXY260EO8+oqIMG0rOplL4rfYARo8Vyl+RNL1Nu
         2ChN8E89q/fP2nuM60LHVef8iu61TUEfg8Ruev/INvpgj47kR9zATBkGpmxeoBDpHqQ1
         sGeyAvE8N7wyhhoOmzWimsRxUC7f5iqyx3kVs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JtKGSY+EwrQu/E5It51yjVvXryiaGnECNUkZx2C4dtM=;
        b=X2nhTbPLiMQmcz/ItG5dABFXUtKgaQ/sKg81t4LEn562syOvuGA3z/TZBlZ21LLsaY
         0gYLqg+dY15RpEIvprXCDE77GKfoH28gpIssSBAEsBnIzok+T/fPUVIUJ80DqJ7/M/Ci
         fmQ2LTg+1hf/FEaZ0HGC0FjVed9s5TyO421a6s6j4ftERkj1i6yR/Am7KoqPxtzJBaev
         sREEg8DNJ7W/s9dtqvZseiKBdjrRDbVcHCNfjMx3TlspobLmJfIipbGVr612EjlVCdqK
         x/t+x4FzfeYn276mBQ98oGYJpzt+xLm/ufBsasgs5XL4bVUCuuxksguoQojz9dR6HaUT
         Dpyg==
X-Gm-Message-State: AJIora+BHhfR225cZKT9U39h/5MdZq7XODeQpxQFtdnSkisJLhUCxY9J
	vcG0RqsxS7exO+7I1jGstVwoxuLgXMFENxEF
X-Google-Smtp-Source: AGRyM1sNocsHh62Uqm8GqnNKAQXl0Y4KrsYTtDEmNvEKhf+yhwjhEfyMVhdbCHiCJZGxxIVGrH/PiQ==
X-Received: by 2002:a17:906:8513:b0:711:c67f:62b6 with SMTP id i19-20020a170906851300b00711c67f62b6mr3475774ejx.657.1655910421735;
        Wed, 22 Jun 2022 08:07:01 -0700 (PDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id y4-20020aa7ccc4000000b004316f94ec4esm15311796edt.66.2022.06.22.08.06.59
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 08:06:59 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id j5-20020a05600c1c0500b0039c5dbbfa48so11256676wms.5
        for <patches@lists.linux.dev>; Wed, 22 Jun 2022 08:06:59 -0700 (PDT)
X-Received: by 2002:a05:600c:3485:b0:39c:7db5:f0f7 with SMTP id
 a5-20020a05600c348500b0039c7db5f0f7mr4500199wmq.8.1655910418839; Wed, 22 Jun
 2022 08:06:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic> <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic> <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic> <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
 <YnqqhmYv75p+xl73@zn.tnic> <Ynq1nVpu1xCpjnXm@zn.tnic> <YozQZMyQ0NDdD8cH@zn.tnic>
 <YrMlVBoDxB21l/kD@zn.tnic>
In-Reply-To: <YrMlVBoDxB21l/kD@zn.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Jun 2022 10:06:42 -0500
X-Gmail-Original-Message-ID: <CAHk-=wgmOfipHDvshwooTV81hMh6FHieSvhgGVWZMX8w+E-2DQ@mail.gmail.com>
Message-ID: <CAHk-=wgmOfipHDvshwooTV81hMh6FHieSvhgGVWZMX8w+E-2DQ@mail.gmail.com>
Subject: Re: [PATCH] x86/clear_user: Make it faster
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 22, 2022 at 9:21 AM Borislav Petkov <bp@alien8.de> wrote:
>
> and frankly, this looks really weird:

I'm not sure how valid the TSC thing is, with the extra
synchronization maybe interacting with the whole microcode engine
startup/stop thing.

I'm also not sure the rdtsc is doing the same thing on your AMD tests
vs your Intel tests - I suspect you end up both using 'rdtscp' (as
opposed to the 'lsync' variant we also have), but I don't think the
ordering really is all that well defined architecturally, so AMD may
have very different serialization rules than Intel does.

.. and that serialization may well be different wrt normal load/stores
and microcode.

So those numbers look like they have a 3% difference, but I'm not 100%
convinced it might not be due to measuring artifacts. The fact that it
worked well for you on your AMD platform doesn't necessarily mean that
it has to work on icelake-x.

But it could equally easily be that "rep stosb" really just isn't any
better on that platform, and the numbers are just giving the plain
reality.

Or it could mean that it makes some cache access decision ("this is
big enough that let's not pollute L1 caches, do stores directly to
L2") that might be better for actual performance afterwards, but that
makes that clearing itself that bit slower.

IOW, I do think that microbenchmarks are kind of suspect to begin
with, and the rdtsc thing in particular may work better on some
microarchitectures than it does others.

Very hard to make a judgment call - I think the only thing that really
ends up mattering is the macro-benchmarks, but I think when you tried
that it was way too noisy to actually show any real signal.

That is, of course, a problem with memcpy and memset in general. It's
easy to do microbenchmarks for them, it's not just clear whether said
microbenchmarks give numbers that are actually meaningful, exactly
because of things like cache replacement policy etc.

And finally, I will repeat that this particular code probably just
isn't that important. The memory clearing for page allocation and
regular memcpy is where most of the real time is spent, so I don't
think that you should necessarily worry too much about this special
case.

                 Linus
