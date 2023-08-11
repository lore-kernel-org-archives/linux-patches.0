Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBD0EA5
	for <patches@lists.linux.dev>; Fri, 11 Aug 2023 03:22:13 +0000 (UTC)
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-79aeb0a4665so545925241.1
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 20:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691724132; x=1692328932;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KkEumRtohfNhdpoDJhISnRDZoUTmKUHTcuDpxxAC/Sg=;
        b=Eo5nhrXDsAnH1q7CsKSmGOuuVDevVflsD5wtRA8azJF2t/k6TG2IiHq8J2hQzNem+D
         yWipkJzcdPI5UI0uM5M3jBMnJJ4GzDgMIHKCoFZHGv+2TAxecoaMqYY4zmSJ0dFyhvPw
         cWi1oBa1/J16JenF5yU7gFwxGmVkLi6PlDO7nnUOkF+Mxkc+u9WNLCe0PsdTxP8Ft70y
         7ksHt0DbT9R1vl2m1AURytAIF+KEMCSC5iGnXQ+09B/z7l0+S8YeUWnkGvrbTFG2/uSo
         8N0PZv6Ekp0ZdPwKVsTEjpp56aCr1nSjZugxapRQkdeiZBXUnOM9mR09xAT3FQ071f1H
         D7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691724132; x=1692328932;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KkEumRtohfNhdpoDJhISnRDZoUTmKUHTcuDpxxAC/Sg=;
        b=E+YH5Q9LuwLNbSflSOSMDf9NPjrwkhu76i5Th7cGbqr2V39PJWXmVyOkIz3BsjjZWF
         KQDu46TRcCN78eXPfIufmaOGf09+r7it2F/egKxQvfffHcUhmw0lu/LeJr4eXQXkiJo8
         MqikjuOKdqH52b6/DGIN8Cho1i2aoQnNf18/Voqz7CsaHEJcbq/37/gAMZ4JOB1cytHN
         uShUEbGC4bvfajbjpokdY1KkehEmI0gOoqFEiTSM/9nkZoOvCrSIUVNsoL9rU+lTPBno
         WD4YVfWB75qwgL/K6PkfOcuQDfblEDkVcJrdb4WjZN/RkwqSwNnHPgR3jWFJrhrJcXVS
         8+xQ==
X-Gm-Message-State: AOJu0YwRhqCUPHMRXh3Cti0YGHJ8q+ydiUrN/86chiTeQ4i5TvLe4JO+
	brLFFf/GWipgSZMvO9dRC6PJRmAl7P5iAX/HW/I3aw==
X-Google-Smtp-Source: AGHT+IGU2fdD5KxBGFfmZ5YbVmA1pRJtMv3ZrL5R8YMkBxBVSZmyFFNwjjWgXkEN553/+Et76M4Xg8624ZbdFTF4TIY=
X-Received: by 2002:a05:6102:3d4:b0:447:4b52:5c8 with SMTP id
 n20-20020a05610203d400b004474b5205c8mr576067vsq.26.1691724132286; Thu, 10 Aug
 2023 20:22:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230809103636.615294317@linuxfoundation.org>
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 11 Aug 2023 08:52:01 +0530
Message-ID: <CA+G9fYvQdQqTqCgbS4sit_Y2AtKtDiWMOkGZjoeSEFhc=M_jKw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/127] 6.1.45-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, clang-built-linux <llvm@lists.linux.dev>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Sven Volkinsfeld <thyrc@gmx.net>, Daniel Kolesa <daniel@octaforge.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 9 Aug 2023 at 16:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.45 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.45-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


While building Linux stable rc 6.1 x86_64 with clang-17 failed due to
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

This patch is yet to be backported and CC to stable.

  --
Linaro LKFT
https://lkft.linaro.org
