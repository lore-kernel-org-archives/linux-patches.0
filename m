Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5336101
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 08:08:41 +0000 (UTC)
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-48d0e695fa1so444865e0c.1
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 01:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692950920; x=1693555720;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6QcQszMmxdJXwrdj7qv0i9KCRG16x6Uvx3Pa+z1CyMw=;
        b=kEtf7/dJtTkeGYA9DS3Z7w0+USux+OmEZxVGCz29NkVWX3Qsq3XmhIxosoEibdvlge
         4kmMeo9X53/5rlLa4p2CGlpDlmsCvSeaH0IKkM3p0YX0ZSgdo6FhQrFm8DSA+/HsPwNs
         Pdtqggstnu370CZL4cGFTUMqwRXpkVk1EAupqfBGoCFn2zu1qO8jNUtTTkty8KOa46Vp
         oH3ebYMo8M04POs8Yf7S+PbOMfGyqDx//XmIlrvcgiZASOt56kIdPdDkK8Ck/45lXwhM
         3mpNpnLHi9PZ31O6pv8fH/7rZ5A1uAk1u5sF4Q9Z/OniV6tKFgQPVwhjX9Pm5HttSW0G
         /JoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692950920; x=1693555720;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6QcQszMmxdJXwrdj7qv0i9KCRG16x6Uvx3Pa+z1CyMw=;
        b=JonO4hVdrFJmHEI7Z3Fo1KQOO0+0po6frIQKPcwe7QN35ZZ8vItT7dDXb8w22iCNux
         KrL1zsjIiXf3hkjMpnzNPKxLGtQ8Dlbsn6pRC7ETSOwy3mO7xEyDdi+U/8DFCn2xjUH4
         iDYf5+sqdLGh5tTk+WZayfZqPqk2LC0MNMzIugwq9TrCP2ztVbLg3q++91PF+KWcbV28
         2OqkCfjyMhf6E34Xxd8sM4sXlKWnP0KHII47ju+zBg567rpmLrJAm1sIQJzuh2QVFELK
         ZPONz/YEoJnJutduPiVLKTM/WKqZBF2XWNf826HtXu7w146l9KFoNDScEZ2fa/cwwr1P
         Hbpg==
X-Gm-Message-State: AOJu0YzWn0ltH/W8vO0vjtzAAl6mqRt62ZNW0g0PL0sIHSH7Buvwvh/7
	vep6GvayuFKZEysIhTjONWRCd10yUmq5EF/pp92oAw==
X-Google-Smtp-Source: AGHT+IGKlUoZqLtAuC5n6U8/S/LEQzMs7GSNBs/X3ca/L9sMnytTCYWAR49NLSPWdqYY3WSdtWOyVrio55hiXGg7eeY=
X-Received: by 2002:a05:6122:c56:b0:48d:392c:c7d9 with SMTP id
 i22-20020a0561220c5600b0048d392cc7d9mr5516493vkr.6.1692950919958; Fri, 25 Aug
 2023 01:08:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230824145023.559380953@linuxfoundation.org>
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 25 Aug 2023 13:38:28 +0530
Message-ID: <CA+G9fYvNipSR9HDcWT7F6j+yvy87jsbzLG-vUQSGH-o2JQv4nQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/139] 5.15.128-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	linux-nfs@vger.kernel.org, LTP List <ltp@lists.linux.it>, 
	Sherry Yang <sherry.yang@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 24 Aug 2023 at 20:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.128 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 26 Aug 2023 14:49:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.128-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The same test regressions found on stable-rc linux.5.15.y as reported
on stable-rc linux.6.1.y branch. LTP syscalls chown02 and fchown02 fails
on arm64 Rpi4 device with the NFS rootfile system.

Test log:
--------
chown02.c:46: TPASS: chown(testfile1, 0, 0) passed
chown02.c:46: TPASS: chown(testfile2, 0, 0) passed
chown02.c:58: TFAIL: testfile2: wrong mode permissions 0100700, expected 0102700

fchown02.c:57: TPASS: fchown(3, 0, 0) passed
fchown02.c:57: TPASS: fchown(4, 0, 0) passed
fchown02.c:67: TFAIL: testfile2: wrong mode permissions 0100700,
expected 0102700

  Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
Do we need a backport patch ?

  nfsd: use vfs setgid helper
    commit 2d8ae8c417db284f598dffb178cc01e7db0f1821 upstream.


## Build
* kernel: 5.15.128-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 00e5f0b76767cab779762a1d27fc17c1cf2a3606
* git describe: v5.15.127-140-g00e5f0b76767
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.127-140-g00e5f0b76767

## Test Regressions (compared to v5.15.127)
* bcm2711-rpi-4-b, ltp-syscalls
  - chown02
  - fchown02

* bcm2711-rpi-4-b-clang, ltp-syscalls
  - chown02
  - fchown02

--
Linaro LKFT
https://lkft.linaro.org
