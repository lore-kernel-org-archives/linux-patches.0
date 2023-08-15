Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A10134CE
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 17:09:41 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-565e6502dbbso358056a12.1
        for <patches@lists.linux.dev>; Tue, 15 Aug 2023 10:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692119381; x=1692724181;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nJpr9HukY4Vg7bgiCdmvzVZeCkPZ6fB73+VNjgb982s=;
        b=aY2FP/mEr+BAK6pd6munt97XIiXhsVYgl3SLFtECzXyFH65Wvk/uo7RyO/MQE74N5H
         jR6Hq7IKi/mA1w+q+HwQus68PidMhFoFFzWBwLk/Mpth3qPaSik2nh2EAFtq6ZNeTuvR
         L7ZKOtln0M3BakkOftvjKCp2/Rgf/Lz3Wr0veQCPbrroGzQ972dqFvSdFLFEbqI3YsnK
         8b+pBAIBNbvX6JtdIK7NVm9g3MFYuFTnuWGCieyv0XKSUuVtQzAYlM3Xs/REDNsY7tyG
         03UadGgCC4BOnWBLyH1I4SmUPDYJY9aPhPtpTpQ7/RfxcfFNOnRxmn1la7itifEcNu71
         SPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692119381; x=1692724181;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nJpr9HukY4Vg7bgiCdmvzVZeCkPZ6fB73+VNjgb982s=;
        b=RxG/c+kufltYZub4cDcN5dYbTOV0fUy6UEg4eUc5CDCuTVLuUQ5kbtZ7ZVtlfhvpAX
         Lq06IJU67FdYKvvLbh+tIerdKQCsnYNwoMefCzLwE2ctQjqWEwxwwKUB9mEdBqpHAuyN
         fZKDvc8dEzn633JLzLaaY5jUN9St7YaVAVpE9foqtJsxWGfUd4K6i7M2L71sNEYwkLTI
         RzemPKhWyWno+7QQzL+N4Y8oMJhhFDYVKbvL5q58G+rVB5W5W9h3eiSs9ccCupqnHxsO
         bSQ0tIybiHi/FV0KgpSbBYXwDq7ZEaLPAkf+F2Q47vffDF8OKYARQvfBRHEUUhg8Z8gw
         7H8g==
X-Gm-Message-State: AOJu0Yx41lpkknZZ9kY5ewEpRfjksXFkTrmIVku9HIPni2EelbCqwDWF
	aFC/LTnA6U16HkLl3zSbvIw5q0zSYBR4oP3yNzM=
X-Google-Smtp-Source: AGHT+IFFbNOpjnmMRYNy6zDvhcYi9+4GH0eWnlghm4FvsSQH1DHu4kW6LZ5gcgP9zUG6aST98l8HpklnPw17kZqsU/U=
X-Received: by 2002:a17:90a:4e47:b0:268:3b8b:140d with SMTP id
 t7-20020a17090a4e4700b002683b8b140dmr8401087pjl.35.1692119380767; Tue, 15 Aug
 2023 10:09:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230813211718.757428827@linuxfoundation.org>
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 15 Aug 2023 10:09:30 -0700
Message-ID: <CAJq+SaBSKRgH9Ddt174vdPgOJwY2fDKibGu804VPZ4J_WjPhSA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/149] 6.1.46-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.46 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.46-rc1.gz
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
