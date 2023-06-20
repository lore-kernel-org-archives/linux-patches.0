Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450702AB30
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 17:10:23 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-66869feb7d1so2093940b3a.3
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 10:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687281022; x=1689873022;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=as+0n5OOb8N3j3zxYMsZi2GIrSF9WcrhdV/0bjInCqA=;
        b=kfe7rBblCd0NL0UHp4j69hOkwvnhY59MjpILKauLUDHmrfRK7fsIK9M6r9DbTh7Q2N
         zQQ3rwvVVZxbuQBHHOEJ6ETPiwHxK5QKpWn6kuqHpqMXeUUfjlKwDvTOIAc35NuQ0VzW
         Bo0F7rx7sSadd6Wdb/0kBQhHQzsO1/uB9P6CZdDjXV+yJA8PP8oizXIZ2jlF89BGU6Hl
         GLywxEY1GjMZf4CE1sS5fQtyCdW3WE+1/wz3ZgAyTb6ssW8Oa+edjSnFm/N6esCYPEQj
         /3HPpZYePZTqGO2fT0O7OGtrd/rHdxTUyScTSg/TG4gTa69i5wxvmT+bD+A1tY6ZP4ZB
         NMSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687281022; x=1689873022;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=as+0n5OOb8N3j3zxYMsZi2GIrSF9WcrhdV/0bjInCqA=;
        b=KrSLcbeA/RjZo1FjtDpz9P43eFYeq3VdnHsURkPQhOLWuYXJFHMZOmHAcTpeXsCxsk
         k+gj5dHVai5Egf7dGuaaE6GgL/KwniG1ydyNzhLoB00oAGrxTCecjGkL+8DMaA1J/2rh
         KlUQ+ZBFPPmJmGdxORpzRO0oWywu9ZCS1Oube+WfBFCg8MCvhWXtj5xdQt7QOvJ58K5S
         K8tnwhRIXnrmsBSlOsbN8eiWfmcQ9dBiZRMLKxey0JHYLEb7yvULmgd6DO9HZI7aeOl9
         7H3GA7io1P4TmtjZIYnteoXWUjH1iJg2VaEfLTM8aRLaJ5kDjKS0v8rBj59X+sZ+wTV3
         GWRA==
X-Gm-Message-State: AC+VfDzarlagdK2Nug9fwoWJP3ZO3t2Bp7eBv6kVbBSJav9TqxDgSOP5
	wZ3YhyEakYo0V/1P1wjg4EpnLGG1wQ+qHMpxPIA=
X-Google-Smtp-Source: ACHHUZ4jUSlY4pY1lMKsSh+6IX+B+dl16SNTN1mye1RkfNwQn8Lys6N9EBhOO5h8T0g+a0MY+4wpWxk+mweUUFKt5e8=
X-Received: by 2002:a05:6a00:2d01:b0:668:8493:2545 with SMTP id
 fa1-20020a056a002d0100b0066884932545mr4646529pfb.24.1687281022552; Tue, 20
 Jun 2023 10:10:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230619102154.568541872@linuxfoundation.org>
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 20 Jun 2023 10:10:11 -0700
Message-ID: <CAJq+SaAFXBNp04yLxyuyRrFaYex2B93qU7KHzUGP6zZ3DQLWrg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/166] 6.1.35-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.35 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.35-rc1.gz
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
