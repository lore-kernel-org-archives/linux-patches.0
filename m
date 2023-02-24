Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FA03D92
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 20:52:03 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so526599pjp.2
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 12:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=55mt+kuo5dWkNyekw++UMrCQ9c2eDryyoLQGraQZpU8=;
        b=PQ3//o9BqF/cCeFQ3Q1Xv/rY74hCW/eRKF38tLjFgGOCR99BqrWq0Z1TmDTmssrMtw
         KRsVOpJ9a+/eAyMeQAoEOu751ZJEZA0gMoES3cjoTU7FtwEeDlLdH5ex99hv3OBGxZM/
         Ww+f/8B/pGoMda4TM+YyDvLNPyGEe1cY8hiLLpcvyFB30w3Oa4txe99onuCvANlX9zkp
         GhdR7L1rwM6PQ59DvdRHq3URtyV2+A+jf30pFRrpM98vbViML4r7tz54JNrViqzhQV6l
         o2wvooKm2S3ozFKY2MzzjS7CVFlm1ZKR7jXKqPop9Cx1PRni7UE3dnNcqGsmchSjvdOm
         acJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=55mt+kuo5dWkNyekw++UMrCQ9c2eDryyoLQGraQZpU8=;
        b=3aZ5MfM1WS2bZ0u+PTdSi08PZd2Xgavi4cJTkDILT+wu+Fd7rWP2DyXvS+qSgpxXaW
         lTQnfnZC2mJdyzIoz3qAW2ACPNGP9JzD/mSzmEKocNZgYFuH3RiGsoBvQp02Fh73NMLb
         a2HP1J4Z7/1kzsN6cEJcHaM8A+CEckupw5T+0zWlNW+5o0WeKyDKOlSg3A0SYJBj8bmi
         HtA+rRC85BVjpan2pSIeHCnD738llKFhGDx6LZusF/bglwQy82lP6/EO3RHzEaZlkkDX
         sdEQSqhzrEfAgbrHS8vfYJHeH0M5YrMQLDA9VnWY0eoOC2oBzAsAVUYvmlIxgHsBefBj
         URLg==
X-Gm-Message-State: AO0yUKWrgFTuJrSUVj4QKVHb32iGg6e/r64SZMIjxeO2i+ZToYRzGSQt
	d9TXYSVfJ9Spdj3S0wACXQhCbGCqMR4Rl+RbfmL9hg==
X-Google-Smtp-Source: AK7set9jwyl5cVUNpA1/XKIW8Cs28uP4ayT0pKHGrhJEcpKF3dfiREuG6JLl2PYLQ5lISV33j6Q9QZmQVEAdjse1W7k=
X-Received: by 2002:a17:902:b410:b0:19c:b7da:d41f with SMTP id
 x16-20020a170902b41000b0019cb7dad41fmr2274382plr.11.1677271923389; Fri, 24
 Feb 2023 12:52:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wiZ9vaM23eW2k4R-ovtcWLyL8PWvnCG=RyeY4XXgZ6BCg@mail.gmail.com>
 <03dac14b-ed62-3e2b-878f-b145383ea9f8@cs.ucla.edu>
In-Reply-To: <03dac14b-ed62-3e2b-878f-b145383ea9f8@cs.ucla.edu>
From: Slade Watkins <srw@sladewatkins.net>
Date: Fri, 24 Feb 2023 15:51:51 -0500
Message-ID: <CA+pv=HPfatoLpQj77HWkzsg+tHK6AVRoR7h-eSY4=EyAFuocrA@mail.gmail.com>
Subject: Re: diffutils file mode (was Re: [PATCH 5.15 00/37] 5.15.96-rc2 review)
To: Paul Eggert <eggert@cs.ucla.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>, 
	Guenter Roeck <linux@roeck-us.net>, stable <stable@vger.kernel.org>, patches@lists.linux.dev, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	Pavel Machek <pavel@denx.de>, Jon Hunter <jonathanh@nvidia.com>, 
	Florian Fainelli <f.fainelli@gmail.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, rwarsow@gmx.de, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jim Meyering <meyering@fb.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 24, 2023 at 3:20 PM Paul Eggert <eggert@cs.ucla.edu> wrote:
>
> On 2023-02-24 11:16, Linus Torvalds wrote:
> >   GNU diffutils have never actually grown the
> > ability to generate those extensions
>
> Thanks for pointing this out. I added this to our list of things to do,
> by installing the attached patch to the GNU diffutils TODO file. If this
> patch's wording isn't right, please let me know, as I haven't read this
> whole email thread, just the three emails sent directly to me.

For what it's worth, this looks good to me.

Thank you,
-- Slade
