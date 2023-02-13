Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0E6AD52
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 22:08:41 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id w20-20020a17090a8a1400b00233d7314c1cso5755333pjn.5
        for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W+gcSvHvU6UymGoZz45RAwy5Vsnkl1I3eLa4JIYkdC4=;
        b=lEikct9bSEZRL11bxmcmWgyEywCcGKveo64ho6fIWJG8NSTP5wcH7GvgHp1wAEmMUy
         vSrLKxvxE4kKk7FEs8gSeRag25/sE0MACEQV7j0ZPCRO0QiP2SDeKM1xtGHMqa025zNX
         A++qjmrJyeCPNnrP4RXT/0oowwJSXKKkhqk+PVL+GNjCZ51iOWpvfpOLUGM/iHboHqbE
         h8c+r14XS7eNR9LJZpTfJVREzt3XqEVA5kFw5/2d3oJxfFKD0N0e9ondMjCDBpag7bg6
         oNOQZIEzDRTA1oeRoud8pc7mSs4VTCoU3mVBi6iYIbLc+BW1V0kOv6fZBjdQQuzLMIcq
         MDPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W+gcSvHvU6UymGoZz45RAwy5Vsnkl1I3eLa4JIYkdC4=;
        b=YvNko59D3sBEItxM+k76CYRwzpwT9OuRdTKglqq/WnJ3bYbPxFZ9py1B5S64ST7R3T
         FpYCar11Q7zCm8nREHIkwfIg5i9ml89u+/mPTnkca64jupcK3/3q1THKuZa0pBw38+uq
         H2NwXfBJbJsrsqthl/w22W3jQQeg3/LF4zYfTAKkRpxnA0bfdvtXI2hW3Zf8ekTMxSNx
         dL4+6bCQ687Uy7pBD3VJLvwmW1OdPotee06KcMRwa5oLYyXoHbwlRQF+j51KXBabowVu
         zqXe/FOHSLoWYMYEhTrj4xLajntjVR2KzcvdclF6aujVqqZk7KR/EjvJhmZCwrQCTswG
         KOjQ==
X-Gm-Message-State: AO0yUKUqwrh7js5PZQYsisHRMc1KQxfh2XISp++7H6OnUk481eLmufzf
	NibZn7bS33ujGrHnBUC3TK95zZtYD8gXPyxH9rk=
X-Google-Smtp-Source: AK7set9Z2gYHrqDUdqHRUENE74lt4pZiEBYUjRjGkGBfT6LexXDlA2xYO1tTf2N2OJbM4tRXoeN26UVw5Z3iwSWTaUo=
X-Received: by 2002:a17:90a:656:b0:230:8c47:fbd7 with SMTP id
 q22-20020a17090a065600b002308c47fbd7mr4487345pje.102.1676326121038; Mon, 13
 Feb 2023 14:08:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230213144732.336342050@linuxfoundation.org>
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Mon, 13 Feb 2023 14:08:30 -0800
Message-ID: <CAJq+SaCcXmFn-qRPgVUgLc_omG0EgZctOQ9e6DxkWAm4Uz7OkA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/67] 5.15.94-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.94 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.94-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
