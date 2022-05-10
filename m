Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C408C2912
	for <patches@lists.linux.dev>; Tue, 10 May 2022 17:18:18 +0000 (UTC)
Received: by mail-ed1-f50.google.com with SMTP id p4so20852745edx.0
        for <patches@lists.linux.dev>; Tue, 10 May 2022 10:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1zNOhYhMmOf2oC+35ttTupc2oZM3Rq+mPFR6uZmiyWs=;
        b=SVtOS8E/bEl5utAGPbNiPoiwfX4boLQX+OlSQkP6h30LngrZXUTEQwcWzn0S2n95U/
         o6sPQWgS4PKMB+Wl41tlBAJEC00agmRTO86/bMz3y/tZXrfw/STez1ah+3+0AEd97gq9
         39C5HSNM+CjnCJc8Wj5JyVL/bXtjI9OJ7aX0U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1zNOhYhMmOf2oC+35ttTupc2oZM3Rq+mPFR6uZmiyWs=;
        b=Cdw3LpEHwsdtsHugtggj8tJaW1IXc3SOufGfAu9kWkmqn1szDDR9563IfNyZTB3Rv+
         k9tXFEZKI9tPqdGbDR7fNno4L+wvvoTxF7FdH0zABOmgd68oTNN2amAQWtKcv1JQBJWk
         UZssAocTJv/4Rc4umOAU/E+KKMnJktV7G49deTEs8c2We4RAu0TLkecRT9H/d++G2Tze
         zYMaYzT5Otz8Fcx23Kble/TbzPcHAP6JL2IWOKVTt3AKLUvMyVWQa/ZdPw7VqlH7WDBQ
         /sTexVnxrSXFl9rMhmquj/zxfwlmVDVNqy6qHuSoeDl9BC9yObYbRWWgMBMJQRUwGMyJ
         9nAw==
X-Gm-Message-State: AOAM530+DVrv2JZgJ/lWQYrOgoUeq+jF6TlvAw3d5xD2YUVhwhs1Vky1
	Hj/H+Zk64XPHnU8qcqM+7NuD92De6CjlWN+X
X-Google-Smtp-Source: ABdhPJxmOunAOyqGZXZe6pj9QdyAY16YmpKEzES03jkI9xcmZ+5eq/aU3rNTHoGvPV6H48VSFdCNPQ==
X-Received: by 2002:a05:6402:1ac4:b0:425:cd55:a953 with SMTP id ba4-20020a0564021ac400b00425cd55a953mr24747380edb.192.1652203096809;
        Tue, 10 May 2022 10:18:16 -0700 (PDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id qr48-20020a1709068cb000b006f3ef214e5csm6480919ejc.194.2022.05.10.10.18.14
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 10:18:15 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id c11so24719232wrn.8
        for <patches@lists.linux.dev>; Tue, 10 May 2022 10:18:14 -0700 (PDT)
X-Received: by 2002:adf:ec08:0:b0:20a:d39d:6ab6 with SMTP id
 x8-20020adfec08000000b0020ad39d6ab6mr19343203wrn.442.1652203094068; Tue, 10
 May 2022 10:18:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YmiK7Bos+zLAvL0t@zn.tnic> <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
 <YmkdxaKdc2w/3I7o@zn.tnic> <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
 <YnLMSWbz6BNfsBME@zn.tnic> <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic> <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic> <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic>
In-Reply-To: <Ynow8F3G8Kl6V3gu@zn.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 May 2022 10:17:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgRm26_oT-JR+TRzDsfhD1TRxfWDM=j6kJerv+m=NU-yQ@mail.gmail.com>
Message-ID: <CAHk-=wgRm26_oT-JR+TRzDsfhD1TRxfWDM=j6kJerv+m=NU-yQ@mail.gmail.com>
Subject: Re: clear_user (was: [patch 02/14] tmpfs: fix regressions from wider
 use of ZERO_PAGE)
To: Borislav Petkov <bp@alien8.de>
Cc: Mark Hemment <markhemm@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, patrice.chotard@foss.st.com, 
	Mikulas Patocka <mpatocka@redhat.com>, Lukas Czerner <lczerner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Hugh Dickins <hughd@google.com>, patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"

On Tue, May 10, 2022 at 2:31 AM Borislav Petkov <bp@alien8.de> wrote:
>
> > I haven't really done serious profiling work for a while (which is
> > just as well, because it's one of the things that went backwards when
> > I switch to the Zen 2 threadripper for my main machine)
>
> Because of the not as advanced perf support there? Any pain points I can
> forward?

It's not anything fancy, and it's not anything new - you've been cc'd
on me talking about it before.

As mentioned, I don't actually do anything fancy with profiling - I
basically almost always just want to do a simple

    perf record -e cycles:pp

so that I get reasonable instruction attribution for what the
expensive part actually is (where "actually is" is obviously always
just an approximation, I'm not claiming anything else - but I just
don't want to have to try to figure out some huge instruction skid
issue). And then (because I only tend to care about the kernel, and
don't care about _who_ is doing things), I just do

    perf report --sort=dso,symbol

and start looking at the kernel side of things. I then occasionally
enable -g, but I hate doing it, and it' susually because I see "oh
damn, some spinlock slowpath, let's see what the callers are" just to
figure out which spinlock it ls.

VERY rudimentary, in other words. It's the "I don't know where the
time is going, so let's find out".

And that simple thing doesn't work, because Zen 2 doesn't like the
per-thread profiling. So I can be root and use '-a', and it works
fine, except I don't want to do things as root just for profiling.
Plus I don't actually want to see the ACPI "CPU idle" things.

I'm told the issue is that Zen 2 is not stable with IBS (aka "PEBS for
AMD"), which is all kinds of sad, but there it is.

As also mentioned, it's not actually a huge deal for me, because all I
do is read email and do "git pull". And the times when I used
profiling to find things git could need improvement on (usually
pathname lookup for "git diff") are long long gone.

               Linus
