Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E88D15D4
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 20:38:12 +0000 (UTC)
Received: by mail-ed1-f42.google.com with SMTP id i34so2086342eda.7
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 12:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Wh95Rgg4YcfKm/rGes24KRLFGSCx31GDq9PEvrBLE2w=;
        b=HDl3QpnsHSrQh99PiNmsE/a34XldQI4WWD78I7BQjyE9b9z647fzjLVaDgFu1bKMnU
         CiPshUbbkFbN4oWWR4oxeir5QCWQhI+SyuVY66c4rsVlx08kt1P6eeNP3HR4yAy33qpy
         ko5w9buE6lBG4AzV6whLaV0OnBOseRCGdf1YM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wh95Rgg4YcfKm/rGes24KRLFGSCx31GDq9PEvrBLE2w=;
        b=H9NPeGPhrrfS9j1LrcPJhr9yMsvBQLwfVs19q1YLMh6Ft9aTAGelQqoWbUN3Dp4UcS
         AKNj7aZpBSXZ3i8tjQqqQKVA3jrVpFEh+SvlWPTHFh5qdBtUPa8pc21u4dujM1u5/7nK
         mrQiCYJDldCPycMcbLRhc+K2xQOQ2ZC8VadCWN6x+hX5GRzwhZ/gf4hZQOoaI8qHsOz5
         0BgyghBiQPM+HdVC93iGZIt/oycXVbg/WTMiQp4HpNs7ZWC4kLohV4nMjew0BU6ZLEWT
         nMPW+WjYtwtOtVS2kIT84IWbjahAuT0EoUexvqoeIvFy6AUdac/8pesUvhJMjNDBnyOK
         6ZeQ==
X-Gm-Message-State: AO0yUKXx866pBG3KijlWnOyNzifYfWVpq2J15UIMj6ja2QkJiXqF2l5+
	Uy5ors/0A/KFVWBZthSiKMCii4o58fzhxVXQjQhwIA==
X-Google-Smtp-Source: AK7set/4sTeQmFB4CkOmuGVVnPH9AF9I12KAc2McVf6TCGTaf9a9Txlu/zFRak+oDKjA4e1tZkHF6A==
X-Received: by 2002:a17:907:2d0f:b0:871:178d:fc1e with SMTP id gs15-20020a1709072d0f00b00871178dfc1emr32042813ejc.77.1677271090262;
        Fri, 24 Feb 2023 12:38:10 -0800 (PST)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id zc18-20020a170906989200b008cae50b0115sm7503944ejb.87.2023.02.24.12.38.09
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 12:38:09 -0800 (PST)
Received: by mail-ed1-f48.google.com with SMTP id cy6so2123662edb.5
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 12:38:09 -0800 (PST)
X-Received: by 2002:a17:906:40cc:b0:877:747d:4a82 with SMTP id
 a12-20020a17090640cc00b00877747d4a82mr11917828ejk.0.1677271088924; Fri, 24
 Feb 2023 12:38:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wiZ9vaM23eW2k4R-ovtcWLyL8PWvnCG=RyeY4XXgZ6BCg@mail.gmail.com>
 <03dac14b-ed62-3e2b-878f-b145383ea9f8@cs.ucla.edu>
In-Reply-To: <03dac14b-ed62-3e2b-878f-b145383ea9f8@cs.ucla.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Feb 2023 12:37:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=whwDyVKYtv+65N=ixfHR82Hxn2gm+VLqNR-PY-de3wXnA@mail.gmail.com>
Message-ID: <CAHk-=whwDyVKYtv+65N=ixfHR82Hxn2gm+VLqNR-PY-de3wXnA@mail.gmail.com>
Subject: Re: diffutils file mode (was Re: [PATCH 5.15 00/37] 5.15.96-rc2 review)
To: Paul Eggert <eggert@cs.ucla.edu>
Cc: Nathan Chancellor <nathan@kernel.org>, Guenter Roeck <linux@roeck-us.net>, 
	stable <stable@vger.kernel.org>, patches@lists.linux.dev, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	Pavel Machek <pavel@denx.de>, Jon Hunter <jonathanh@nvidia.com>, 
	Florian Fainelli <f.fainelli@gmail.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net, 
	rwarsow@gmx.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jim Meyering <meyering@fb.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 24, 2023 at 12:20 PM Paul Eggert <eggert@cs.ucla.edu> wrote:
>
> Thanks for pointing this out. I added this to our list of things to do,
> by installing the attached patch to the GNU diffutils TODO file. If this
> patch's wording isn't right, please let me know, as I haven't read this
> whole email thread, just the three emails sent directly to me.

Looks good to me.

The whole thread isn't actually any more interesting, it was mainly a
lot of "how did the bits get lost" confusion because it wasn't clear
whether it was some local script or quilt or whatever that lost sight
of the executable bit.

It starts with a report about how the lost bit results in a build error at

   https://lore.kernel.org/lkml/adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net/

and there's discussion about how this has happened before and how our
kernel Makefiles generally should try to not execute scripts directly
exactly because our ancient "tarballs and patches" model never
supported the executable bit etc.

So none of it is very relevant, except in the sense that it would be
convenient if diffutils did support the executable bit changes and we
wouldn't have these kinds of things happening every once in a blue
moon.

Again - there are multiple different workarounds, ranging from "we
shouldn't do that then in our makefiles" to "you can use 'git diff'
instead in the quilt scripts".

So not a huge deal - but it would just be nice if diffutils just
supported the extended format.

           Linus
