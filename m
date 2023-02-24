Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB22AD58
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 19:17:12 +0000 (UTC)
Received: by mail-ed1-f43.google.com with SMTP id h16so1225806edz.10
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 11:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HH0zAL0zwAD0TFUh4VaOGtbBT10Co7dyTSR8JSwAXuA=;
        b=GtNE3Ed1l5jwOVYSMAkytt7K/8+r0xcYErBg1jFJR5NuoG8BIRbsy2Au89zhNyAcQ5
         Qset4AKkaxqaU31Ahm2BzjHwj5/D3tZRCwbV3hv+mTG4u7BFAaWSjvrxeuWemjLrqLBl
         2/r5V3P+oRo0NvtuhmHFYeTsTmraiROQHo6n4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HH0zAL0zwAD0TFUh4VaOGtbBT10Co7dyTSR8JSwAXuA=;
        b=oEsoV6qydeZbEpJZ7mxUN3Qs81g3TEGi6F0PgG3DksRSBRsYexq3JMqnhms18qjw1z
         C2x08tO5o4xCAvuNKHs0fB9gtPdNyTNRZYUyNzhiU05+MHhYa3dTrgNDq4mhdX3q8oyO
         XSx0V2HpoFtOb4ahX8dxB/9NxMbY6VSlhqzeqcTbX4SYjATFVlOQA5OoV1uJutOZkpKt
         3+XU3EmY3WXOVngQovPFC8fCDqtk98ZJVwiDRXFBveOfOTVmaChbHtPN6dsQpbDvwbHh
         rYDd1zJnVbmFVLoiz7blG9nz5yhERLZAiPJWcDhmNaSgyID1d2/LDe9i3n8JehSQtjFK
         /KdQ==
X-Gm-Message-State: AO0yUKWTB8pFxKlXOnPemPGIXvQ8DP42JnAVhqCUdbLIz6DcUcS6terC
	bXQyok5klyFErkyj0W0HnTP4q2tKZQzKBb2HKg+CjQ==
X-Google-Smtp-Source: AK7set+dMidsE82aGs0Vd8iTvg7LvC5ZV7WsKvlcnhX39dXqzNKH/6cEWqeeQQ/bl8KIaBYvYJ3C0A==
X-Received: by 2002:a17:906:f14b:b0:8b2:7150:dcff with SMTP id gw11-20020a170906f14b00b008b27150dcffmr25446328ejb.23.1677266230137;
        Fri, 24 Feb 2023 11:17:10 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id t18-20020a170906949200b008bfe95c46c3sm8421195ejx.220.2023.02.24.11.17.09
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 11:17:09 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id cy6so1334078edb.5
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 11:17:09 -0800 (PST)
X-Received: by 2002:a17:907:60cd:b0:8f5:2e0e:6dc5 with SMTP id
 hv13-20020a17090760cd00b008f52e0e6dc5mr545864ejc.0.1677266228845; Fri, 24 Feb
 2023 11:17:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Feb 2023 11:16:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiZ9vaM23eW2k4R-ovtcWLyL8PWvnCG=RyeY4XXgZ6BCg@mail.gmail.com>
Message-ID: <CAHk-=wiZ9vaM23eW2k4R-ovtcWLyL8PWvnCG=RyeY4XXgZ6BCg@mail.gmail.com>
Subject: diffutils file mode (was Re: [PATCH 5.15 00/37] 5.15.96-rc2 review)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Eggert <eggert@cs.ucla.edu>, 
	Jim Meyering <meyering@fb.com>
Cc: Nathan Chancellor <nathan@kernel.org>, Guenter Roeck <linux@roeck-us.net>, 
	stable <stable@vger.kernel.org>, patches@lists.linux.dev, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	Pavel Machek <pavel@denx.de>, Jon Hunter <jonathanh@nvidia.com>, 
	Florian Fainelli <f.fainelli@gmail.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 24, 2023 at 8:55 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Ok, it's not quilt's fault, it's GNU diff's fault from what I can tell.
> quilt relies on diff to generate the patch, and I can't figure out how
> to get diff to notice file permissions at all.  Am I just missing
> an option to 'diff' somewhere that I can't find in the manual?

No, I think you're right.

GNU patch was updated long ago to understand and apply the extended
git patch data.

But as far as I can tell, GNU diffutils have never actually grown the
ability to generate those extensions, even though at least the mode
bit one should be fairly simple (the file rename/copy ones are rather
more complicated, but those are just a "make diffs more legible and
compact" convenience thing, unlike the executable bit thing that
allows for scripts to remain executable).

> Anyway, quilt can handle replacing what it uses for 'diff', so I'll just
> replace it with 'git diff' and that seems to solve the problem for me!

That does sound like the right solution.

I don't think the diffutils people really care, but let's cc Paul
Eggert and Jim Meyering anyway, just in case. Because looking at the
diffutils git tree, it's still actively maintained even if the patch
load seems quite low.

Maybe there's some patch floating around that would allow diffutils to
also add those mode change lines. A quick google didn't find anything,
but Paul and Jim would probably know (or can just say "yeah, not even
interested").

                Linus
