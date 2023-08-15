Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80574134CE
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 17:10:32 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-26b4cf4f7b9so1525757a91.1
        for <patches@lists.linux.dev>; Tue, 15 Aug 2023 10:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692119432; x=1692724232;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EYdhrRPoIlIRXXfKbw9S5JsNJe2WJ2NJpGUUcBViuhI=;
        b=pwoCagXIfl96R/opXEAUP+dHFevGyhqCbQyZxHhbAafyWu9FNPMhw2OmjEv1t1pSiS
         U5zAQBWobW7IUu+DM+vrOhF6xvBCyZeAD58gV7gvJFGzLgW7AzuW4k50n/e/2+FIjL7c
         Fd77luBmH7XX8CWWvaq5cXGwYfn7df4suDfRqizKYKCHdXwLCPDj7vB72YpqNIikSRj6
         wK2jvuxsTKr1TTm3Bi95vaucLCv9MP65OrFqtkVAQXDzokPz4sDa1vqIsw5pNFgRQ4pX
         1pzR/B/cUmglWcZpeu1geHfHKU6gTCDFsL5jNfRRubVlX4bk4mXoUzVOiyd4i3Z+5vXO
         ssEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692119432; x=1692724232;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EYdhrRPoIlIRXXfKbw9S5JsNJe2WJ2NJpGUUcBViuhI=;
        b=iRMGqIUOUZHSNUI9u8Itq199875zUtTh0GZVZ5aG/4BNBmZs+ADIJ1+dhAYPU+gqrD
         Rj15LdXgiDYe1sDEfnkjmWc020JkCRloisgkSEuuWd7HiPXTVMnN1cmkRqmjCOyInXaY
         c42V+I/eKmIYZpZdsqo/Zi4HxcC8empcIlt+ITuIxH+F77BHyiKvXIRNDYhpZedNBgMA
         KObz3XUuzH963ZgpeogdnzgLcD+TwWTJ5XoevBEhPPIpUfg/zV+tE2MRmmOzeyFapsCl
         wOTQSTHuijbrIDC7+pJa06vI6MtQEDhPyvUJMi868sQPzbaIqQOLcqt/cBYaSYh8menX
         jObw==
X-Gm-Message-State: AOJu0YyM/3vyus/xq6f22L7odv/3KCewsp8+10dIrp9sP1lJ07uvwhS5
	nkfWy9VGpjvreDTRhfuF9GfLJrE+hVIAxHvDxak=
X-Google-Smtp-Source: AGHT+IGTrk3U+CCTZUiSw2p6YVRkpLPMX29/XVJ7rrPu9jFuVljhf6uPuYVobOSrOt2Z6Kmi5RUQe+6AhGFQuK2qS0s=
X-Received: by 2002:a17:90b:8d1:b0:26b:4f2f:6da7 with SMTP id
 ds17-20020a17090b08d100b0026b4f2f6da7mr6086242pjb.1.1692119431831; Tue, 15
 Aug 2023 10:10:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230813211708.149630011@linuxfoundation.org>
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 15 Aug 2023 10:10:21 -0700
Message-ID: <CAJq+SaAgxAHE2S=w=R0OQvbNx269xgoUgvk+jNfqwvwqJF6qSQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/68] 5.10.191-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.10.191 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.191-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
