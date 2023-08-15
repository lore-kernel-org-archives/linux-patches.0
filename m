Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E96313ADE
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 17:07:56 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-26813478800so3220625a91.1
        for <patches@lists.linux.dev>; Tue, 15 Aug 2023 10:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692119276; x=1692724076;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IfnBPQmR5aKREIriV/5IUmnU6LBPlzSZxgIT4j/hHjY=;
        b=g1o+GBOmqgdPyGBdCrc4qUhlPgRGJy5a49DnyQByaEtsFFeSA/55HbCEWVCMXZ5Bo/
         xWETpO+2e/nWDuVv2yRhTC49zjLIvvPHe0xVquBbH7CH5FRbJ0y/duopQ7z2mh4Cfl0W
         2fG4k/IDyBk9kjmmu85L5viegl/46BgvM7n1tMFNawIx1MbNcRg4KDjpq1uAXdZgqfTR
         z8y0uacEkPKVLpfrRhvvYBluyya6U2annLUZu70u8j9+iw066oSFl3KqNJnyXZKpDVKr
         2A38zXfwmRuAT+pZYlLgL0SwXlpfLmrmZVjWkDLUQ4co2O48W0lHgH83xBAAh5gO/AY1
         zzBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692119276; x=1692724076;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IfnBPQmR5aKREIriV/5IUmnU6LBPlzSZxgIT4j/hHjY=;
        b=eHy3V/a8QKGjFKZNjDVZ+nC0MJzG/akOH38ns5Twr+wFQhUKVFLIweCACqG2awhY7C
         tzun//GqWJTNOeBc625tBnQxsHE4pCwYR7LrSOYJS1H1Nxg2neRur3khCG7vAcbVwYYX
         m+QrDz+TgVdH0qiIgRYL/BEV3Trhr8Xum//HYnyom6ggpcmYnuPErtS6TuuZksLkQ1+3
         NF5IWJfV+eA05xdTCjAzWm30q0J+3z2ZXHjnK5hpLNjlVeWcC5Sm4mpUIrY7k25s8Bhx
         iT6DYN8jI/uztmmAyD6J7X6JH3BX6ZoFwdTtNiVLlsuDMB7d0tOgdgR1PKHPQtK2qibZ
         82IQ==
X-Gm-Message-State: AOJu0YwqGmtiMk9nrWLo3l5kvQJJwWNJ4ywo1YYmnAkJoJpdKgT3PSs3
	khq3qAu707cU7EulYhLO7i9+YNPAgXTQPS3ybNE=
X-Google-Smtp-Source: AGHT+IHbZrHeipVo2piqPvyBgSPpQA68tJvSvWC79m9yJlxEIGYRdt46+9nXHa45IhR9nYBoQxcxdmEleaN9Qgt03no=
X-Received: by 2002:a17:90a:69a1:b0:268:2c60:9969 with SMTP id
 s30-20020a17090a69a100b002682c609969mr9886712pjj.47.1692119275603; Tue, 15
 Aug 2023 10:07:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230813211710.787645394@linuxfoundation.org>
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 15 Aug 2023 10:07:44 -0700
Message-ID: <CAJq+SaCcK5iPN4+Ow+aMz=f5BGQkLbo7zfkLsoaLsCergLHMcg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/89] 5.15.127-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.127 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.127-rc1.gz
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
