Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237F7AD58
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 20:01:01 +0000 (UTC)
Received: by mail-ed1-f42.google.com with SMTP id cy6so1766360edb.5
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 12:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CycpbGYPVV7t0eKpbJzs8In3XpyKLfsIf6xBO+wlbU0=;
        b=Wa4InpbaYI/Bgwr0JgNYDgEz2pEKz09JbCGGPcgDYXzpyBOGYuQn1jTnf+awYVY5TG
         gLywfm0HGhJKHLdeJ3zH0UpPwFVP5ktSE8crVmyIP4jjR+qM9Jcb7GYS8UNVaOy8QiDJ
         1JiA2yPy0NMZBsUoU6blsiasOsEWPmL6hnlHo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CycpbGYPVV7t0eKpbJzs8In3XpyKLfsIf6xBO+wlbU0=;
        b=JfqmzDiEXMLlEG9MQDY0Lpmp5Edpuz4rQceIEAf1nPTNOKwnaE78Gc+OsnV+maCaDm
         IJLCQiSJir7gCJcZnaCuWJWAbTGBJDR8x10LNtvcJY07Ev1hVihMhD16+31ISLxd7mv/
         AD8fSp7ZpQSV6YIbqIdbzBpGxNDHVgnX8NxyAxE7vNY9bZbNNu52w2kow7q/UAD78sW6
         YFuW+gYyEGqsJUksSRiXX5URjjnM66dZ3NamRMCHBWURBji01GcDtIYyUFcck3X57GNo
         2Y26DeGXNhrJcTIi9HmaOeuFArOqwIybhS45C4O4I/bcvjAtfalUR/zh9/6P2iW7t68H
         sV3w==
X-Gm-Message-State: AO0yUKX8TVBX6OviKANb+X7pJVBUvHEbZqxrZyDAA+2F+toNvi0oABbk
	Y3osrxaXcVQksx4Pavj8/NM5Sli3FfTyhYi4zT3MSg==
X-Google-Smtp-Source: AK7set9GWH2QWaxEGhr1R9ujjDuBYt62Xnm5fBzguGENmAatOWDPRBKbB9KTM18Q1faDwtZp0aWhsA==
X-Received: by 2002:a17:906:22ce:b0:8b1:bab0:aa3d with SMTP id q14-20020a17090622ce00b008b1bab0aa3dmr28326043eja.8.1677268859766;
        Fri, 24 Feb 2023 12:00:59 -0800 (PST)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a22-20020a509b56000000b004af57500d5fsm96121edj.54.2023.02.24.12.00.58
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 12:00:58 -0800 (PST)
Received: by mail-ed1-f50.google.com with SMTP id i34so1724820eda.7
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 12:00:58 -0800 (PST)
X-Received: by 2002:a50:aa9e:0:b0:4ac:b616:4ba9 with SMTP id
 q30-20020a50aa9e000000b004acb6164ba9mr8016701edc.5.1677268858123; Fri, 24 Feb
 2023 12:00:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wiZ9vaM23eW2k4R-ovtcWLyL8PWvnCG=RyeY4XXgZ6BCg@mail.gmail.com>
 <20230224113247.07a660eb44198499314a9e96@linux-foundation.org>
In-Reply-To: <20230224113247.07a660eb44198499314a9e96@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Feb 2023 12:00:40 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj-+PTUfu9NsdDt3p7tLXbUH-KJPBz+r4wHX075fydEOQ@mail.gmail.com>
Message-ID: <CAHk-=wj-+PTUfu9NsdDt3p7tLXbUH-KJPBz+r4wHX075fydEOQ@mail.gmail.com>
Subject: Re: diffutils file mode (was Re: [PATCH 5.15 00/37] 5.15.96-rc2 review)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Eggert <eggert@cs.ucla.edu>, 
	Jim Meyering <meyering@fb.com>, Nathan Chancellor <nathan@kernel.org>, Guenter Roeck <linux@roeck-us.net>, 
	stable <stable@vger.kernel.org>, patches@lists.linux.dev, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>, 
	Jon Hunter <jonathanh@nvidia.com>, Florian Fainelli <f.fainelli@gmail.com>, 
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 24, 2023 at 11:32 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Can we use git instead of diff?  I tried once, but it didn't work -
> perhaps because it didn't like doing stuff outside a git repo.

Just using "git diff" does work *but* I would strongly suggest using
"--no-index" as in

    git diff --no-index -- path1 path2

because without the "--no-index" you will find that "git diff" will
use heuristics to decide what it is you want to do.

So if you do just

    git diff path1 path2

and both of those paths are *inside* a git directory, then git thinks
that "oh, you want to see the diff of those two paths against the
current git index", and does something *very* different from showing
the diff between those two paths.

And I suspect that is the exact reason you *thought* it didn't work,
but now that you tried it in a new test-directory, it did work for
you.

With the "--no-index", the ambiguity of "do you want a diff against
git state, or the files against each other" goes away

Just to give another example of this:

 (a) when I'm in my kernel tree, I can do

      $ git diff .config /etc/kernel-config

and it will show me the diff between the two files, because while my
".config" file is inside the repository, "/etc/kernel-config" is
clearly not, so I get that "diff between two files" behavior.

 (b) but then if I do a conceptually similar

    $ git diff .config arch/x86/configs/x86_64_defconfig

then git will see that both paths *are* inside the repository, and
think I'm doing a diff vs the git index state, and since I have no
changes wrt any checked in state in any paths that match, it will show
no diff at all.

So if I actually want to see the file diff between those two paths, I have to do

    $ git diff --no-index .config arch/x86/configs/x86_64_defconfig

to clarify what it is that I want.

Also note that "git diff" is *not* a replacement for the 'diff' binary
from diffutils in general.

Doing a 'git diff' will *only* generate the extended git unified
diffs. There's no support for any other diff format, and while there
is overlap in the command line switches, there's a lot of differences
too.

So "git diff" is very much a "you can use it as a replacement for
plain 'diff', but only in very specific circumstances" thing.

                 Linus
