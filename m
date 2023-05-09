Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3790917FE0
	for <patches@lists.linux.dev>; Tue,  9 May 2023 17:04:35 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1aad5245632so44167055ad.3
        for <patches@lists.linux.dev>; Tue, 09 May 2023 10:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683651874; x=1686243874;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cqwYJC2a32+Z6h234kt8dpAjjln4imJVcBQC4D4MUi8=;
        b=jaY2ZrpWSQ2CfwkRMbKibXqOX/GLsR53W6H6XyjXjqvx3qsNBjGX6/PABq9XQAuDfz
         GKRoCrP73N/US1bT0/K8BaGTY+q/5ZuIRCn6FyS28za/gpHn03b+d4O/HByy07po17KV
         n4YYjgDnG+BW1D91s1bz9do/4fcfZB4LOY4sgkdT79r5+s9qb7EavfGuigho+b48HSjV
         XFhqvoueCNXhzppgDLWYUDeKoYeRBBWcwiEsCaRXyYZSF6jYJ2utDV5/7Y5aioRVCUSH
         CYlkV4+DrJ2Gg45DIti0YTMGf79wj/NebLWeJ9cTzzMG5AWr2eYC8fFLgznTsFn6mfp+
         rxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683651874; x=1686243874;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cqwYJC2a32+Z6h234kt8dpAjjln4imJVcBQC4D4MUi8=;
        b=EZFxtyYvLMwGA1oFOnjYlVgrv57u29uOqwBzAU4qhQyMNu052Kr2Dccn13ycf6AGHX
         Nl9pm0yNDwQOu442tNHOQBKyA4BbjjM/8xsyVIRWrQ7uQXgpIlJT29DbPGIkADG47hbX
         15qm9ibJBy+8gHLHuGTTjdjOVveW6rCKnZblsVFNFvZgXZEAAp7tv5J1lsibjRoXwNTI
         21zfTljkCp5Y/BmCst34F8wCyIhhrPMp0CrsqiRjr7vJqwFpoCVwPdlE8IAf4sPlgBTO
         Nh0ZJegJGc2eial92F04of8mlTwasyfXUv3eQv0Qxt6/bWlCWi4AbUDYfodWynu9fP3V
         k2jw==
X-Gm-Message-State: AC+VfDxsIHGEKq00b83PLbq4vjhQ0vJ/E8p4Eh1V2kJHEpSWgm/xBq4I
	sxTT0/HCMvulXzXHBLmhJ5fVhuAT6VEfnEyRt+g=
X-Google-Smtp-Source: ACHHUZ67/FhEiGui4khV15HtrKuQbRNbJ3wk4wnpBI377nKp9v2/95FfYMrHMF6HJ9iMcA61OBTtybgJyICWz4PsBFI=
X-Received: by 2002:a17:903:247:b0:1ab:16cd:51a3 with SMTP id
 j7-20020a170903024700b001ab16cd51a3mr19228370plh.10.1683651874673; Tue, 09
 May 2023 10:04:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230509030653.039732630@linuxfoundation.org>
In-Reply-To: <20230509030653.039732630@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 9 May 2023 10:04:23 -0700
Message-ID: <CAJq+SaCr5qarZJPRdFkWFXppoAPx4KFEwOKiVm8rSkZ53vseNQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/610] 6.1.28-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.28 release.
> There are 610 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.28-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
