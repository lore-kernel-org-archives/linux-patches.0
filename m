Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496F82F3A
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 23:05:20 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id b11so15135308pjp.2
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 15:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Gcur06YXVkpMCUTbS1b/OnVOrutrgJBtjqG3uOLRXak=;
        b=Kq4NEanaCGU52P7s3v3jGRzbSfwCAVDjno72X8vKFdqCzVRZrgtjrUA870eQKayPeh
         M4zl2U8Rn0ov/0D01FgYWSkWBXu5b1SvtNxG5wZ1BzKIOB/W/c9p7LeRcyYfdMM+i8ZF
         7gdDUY5kMhf7HA+BPFwsuQJaNsaEb9q7IDB7GJfY7wh5TEhBtLrfs9VG5KpEn41+lWl6
         HGcyXKv27IGU2/TZyQOrV83e0fAxVtgvSFv8/s8rn0hUypZHyHdH0TM9rOAyzHegSEWF
         2KktVwcvAFzF7MXDvAcVLplnS4jawB/BCrd97ticupTb0U1lypXrCfh3lSbpXXPm+rNz
         y1Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gcur06YXVkpMCUTbS1b/OnVOrutrgJBtjqG3uOLRXak=;
        b=QXSvldOrkaaHqmKC09pMjxftslJWw2x6ll4YiLd2DwMxQvoGoiiglgA5byx965PDUH
         0F8CEOD5RUv9oJ6cCaWM5deNF8O8xPAexJwIchuJ8OFB6FH2XsnGYH4e7WRIfRaJdRZF
         cafL40WdTk5/opsDcNJL9/GjrGf4n2J+zMvK7vXzbWAHEX+Xwwq60SR23lQ9vpRMMyPs
         laz6fsGdM7MXMjcmAAfSIvpoeOon31WHAzAamIzqha9mWqxLlk3m4blwHN4ywDQOwTEz
         toBN7BCbqxeXIqMpLbzK2UX4wZeUJSOuCZKwmAZDJDWM9mFs0D3aUratGIAi6bGnPjpf
         v06Q==
X-Gm-Message-State: ACrzQf2UA5vB/30Dbm9uXjsiBuOCvPD53Yq/AkhEWeBHfdOLUCkaKKxJ
	U3hlZlSxJ8ErICunZYHeOFGzAfG+YRPCDwzklCg=
X-Google-Smtp-Source: AMsMyM7SqemD9JPp8GWfXJpXFIGp1dsxWi8Tw+x49gjJjHiIH4LM61lJcXMaFVFEWLwJYXtbpuclxFRPJUxYWxskNEw=
X-Received: by 2002:a17:903:1211:b0:178:a692:b1e3 with SMTP id
 l17-20020a170903121100b00178a692b1e3mr60279037plh.48.1667948719734; Tue, 08
 Nov 2022 15:05:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221108133354.787209461@linuxfoundation.org>
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 8 Nov 2022 15:05:08 -0800
Message-ID: <CAJq+SaCAUWM=ErYEesXQ5PNSsy6AxJWUpHhKcN0MH5X92azxEw@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.0.8 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
