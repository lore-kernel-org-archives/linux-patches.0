Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934F328ED
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 14:38:55 +0000 (UTC)
Received: by mail-vs1-f45.google.com with SMTP id f23so15445183vsa.13
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 06:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KRU/Mil2/Cn0wlylXq7PWdU4aS/7MOdCPh+sd7lM4Ek=;
        b=TlOYWovu1/4C3AH4v6gHtFk48F5kE+WGwULXVqbuZNwoavh9mn7xMAQoA5rd165aTb
         FradEzbYegmFDHFW58C6UbWIPYD+0TgRN5OGuHtBEL/DFodZL3G7pcG2pSWDiy4kscLd
         8v9ml5l+lCmW9K/bZE+Z9s5KxmVxSQ1oScLZTIOR93BytwVhOBpk9q+WnxPYTVSArdkB
         SESzfiMRZXuepaj4hxogoHdQiauAPe8TsFKGM3Mxw6+wLzRQ1kOBR/QZTxDPNok0Cnaz
         uv5AvTjLJ9qDdKsc4Lqafnw4FODpO7fowDs35KVCMNfGmMW5pEi6Djva9E3IhIG7r/0q
         HTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KRU/Mil2/Cn0wlylXq7PWdU4aS/7MOdCPh+sd7lM4Ek=;
        b=wjEP4jfKZcXjkbSCUnQZS5njwQrBh+taYAL1sm3NZiKOymFyRMfn5D1TJw3qgrjd+1
         Q4RLEEKHK2WMtPoGlBK2yi/cgaaXFy1pfJjfCVykl923ZJdPnVLGT8np11kU1Dkn91nM
         714PgkhIKAR2ptqRoDswLKOo5R0NegMlsNp0fB/XVpbbciIsdJ7i7rQ/kFPeUO2J481N
         2bjk0DCVxOrHAvzioF/wIwpdFCBXH8CMpIJBU5E+Q4ovZ/BZ9SWGpgdWB8+UV9LzuaQ8
         cZN7793hKCH7X13bLOLock9fYZsqj8j06r0lVIxWXC+8YGFbe5G/dRhOowZbMiG/cvK+
         k4CA==
X-Gm-Message-State: AO0yUKVf2DMk+ww4e6PTpugUsKCKiemEw/sE4bBhvZJyT0xpVKutaBD2
	8ppL/rAjzV8ZfHFyPMVxFHcRmERKFsdcc/O46rJV6g==
X-Google-Smtp-Source: AK7set92kDhiLsYT2rc8uVgLLx9awLk+m8hYTvq/N4btKS5iC8vlmSaqeDDCSSg5WGfEss/5zbmtqhFO9CIwNrCBeiw=
X-Received: by 2002:a05:6102:1161:b0:41f:2138:41eb with SMTP id
 k1-20020a056102116100b0041f213841ebmr538860vsg.28.1677163134299; Thu, 23 Feb
 2023 06:38:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223130431.553657459@linuxfoundation.org> <Y/d5KdOfh5rXUeqk@wendy>
In-Reply-To: <Y/d5KdOfh5rXUeqk@wendy>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 23 Feb 2023 20:08:43 +0530
Message-ID: <CA+G9fYsG8t1qO6MzJ=OYmegDwXCePafWbYjCc=JgiF3Mk5yQxg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/46] 6.1.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Conor Dooley <conor.dooley@microchip.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Thu, 23 Feb 2023 at 20:03, Conor Dooley <conor.dooley@microchip.com> wrote:
>
> On Thu, Feb 23, 2023 at 02:06:07PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.14 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.14-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
>
> > Dave Hansen <dave.hansen@linux.intel.com>
> >     uaccess: Add speculation barrier to copy_from_user()
>
> This breaks the build for me on RISC-V, you need to take f3dd0c53370e
> ("bpf: add missing header file include") from Linus' tree.
> It was broken in mainline too, so it is probably broken everywhere you
> backported it :(

Thanks for your report.

I do see arm and arm64 build breaks with following build warnings / errors:

kernel/bpf/core.c: In function '___bpf_prog_run':
kernel/bpf/core.c:1911:17: error: implicit declaration of function
'barrier_nospec' [-Werror=implicit-function-declaration]
 1911 |                 barrier_nospec();
      |                 ^~~~~~~~~~~~~~
cc1: some warnings being treated as errors

>
> Thanks,
> Conor.
>

- Naresh

--
Linaro LKFT
https://lkft.linaro.org
