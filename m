Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B360BEA5
	for <patches@lists.linux.dev>; Fri, 11 Aug 2023 03:25:20 +0000 (UTC)
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-4476f713e15so636363137.3
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 20:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691724319; x=1692329119;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5H5DjO75P8j92IjkeuHxrJ9MnSor8v3ZGILNI6rwMcg=;
        b=XmIhtWnZYMYWQEcHT0gSuEBB9pPa3Rbv+R5XM4EzKh+fxyVs3FocWoAFex1NZmMrv+
         hAg7os2LEmpLyIue7R7VHgqAIMV/uxlGDI1Y2pNNh9bkQhnB3HcpjpK9cHUP5GZnkqQ2
         9/sMsESfzIb6Ybmd/i/GBi8wrsvVV2T2P6bEkrzirfHXB81Gbw+XiWv8WTI/I7zv+bN+
         CB4tWlYIH8s8dwOBbHKXWmCU6V6P+QUemdg4RLB1Y2vn71bk+DTI8yOaeV8ORCjSRbZo
         hT2pQ1u95gTQxCEPuKREGaULdW8jlC8ea8cMVJl8Q5llXGo8IrQGUB1/yixC8ZxqODEu
         Kj1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691724319; x=1692329119;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5H5DjO75P8j92IjkeuHxrJ9MnSor8v3ZGILNI6rwMcg=;
        b=iv6p/pRKVVx79qATQyQxud1WIB2lQXicZVY2rxFORWqTE3m+z/Nd1KnS41ThXtlUEz
         2OoYhbvgfIKu+QMsIAnwTYu7fDgPyan5rTgnFRVDs/QPWgmQNNF+92VD3t/AWU3Tcu7Z
         bkZl1r0lpoeMVv17ZI95rsuiPna2tLd+K1PdTUTehtTIVpLneGwy2rx3WzNDh2xRrk7g
         2D2Pt9TpPyCPETzfUs7vwR201Zpb2463eFyhDKKsDRKXE6IR2d20j88tNmMxqgeSne5t
         y1Cz9TTBrbJ8oEDcG3elm2dNtA5Smc/xunkWxWIKKBFWbdxKQTNaNWE0G7CDL7ZviOvf
         kS9Q==
X-Gm-Message-State: AOJu0Ywnc1Rbk6CSyzXZihcmAztXR6Gt02ufBXiQaaSPk/ULU+0FXCu8
	qTSnCvZQ75AG7NLvVeXPvH0505b+CurAL0WR8dRCDQ==
X-Google-Smtp-Source: AGHT+IFoHFOGmN7FsYeiOFT1p95g7zR879og5YZfXKv5JacrXceSlCef+qw5DrFCNAVB4CXBO4XRLf3Mbdins//hbF0=
X-Received: by 2002:a67:ebd7:0:b0:447:ba64:7e40 with SMTP id
 y23-20020a67ebd7000000b00447ba647e40mr656018vso.8.1691724319385; Thu, 10 Aug
 2023 20:25:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230809103642.720851262@linuxfoundation.org>
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 11 Aug 2023 08:55:08 +0530
Message-ID: <CA+G9fYuoajK0n7RNhSqm-ycO6Md3W4ah_Sc=b_KVAQwY=Rt6YQ@mail.gmail.com>
Subject: Re: [PATCH 6.4 000/165] 6.4.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 9 Aug 2023 at 16:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.4.10 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


While building Linux stable rc 6.4 x86_64 with clang-17 failed due to
following warnings / errors.

Regressions found on x86_64:

  - build/clang-nightly-lkftconfig-kselftest
  - build/clang-nightly-x86_64_defconfig
  - build/clang-nightly-lkftconfig
  - build/clang-lkftconfig
  - build/clang-nightly-allmodconfig


Build errors:
-----
ld.lld: error: ./arch/x86/kernel/vmlinux.lds:193: at least one side of
the expression must be absolute
make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1


  Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

upstream report:
-----
    - https://lore.kernel.org/llvm/CA+G9fYsdUeNu-gwbs0+T6XHi4hYYk=Y9725-wFhZ7gJMspLDRA@mail.gmail.com/

Proposed fix patch:
-----
  [PATCH] x86/srso: fix build breakage for LD=ld.lld
  - https://lore.kernel.org/lkml/20230809-gds-v1-1-eaac90b0cbcc@google.com/T/

  --
Linaro LKFT
https://lkft.linaro.org
