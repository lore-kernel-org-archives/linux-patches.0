Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C2C101DE
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 12:44:51 +0000 (UTC)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-51a20c744ebso5500343a12.1
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 05:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1687265090; x=1689857090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Woy9uXIbm09rqBjX1mw8Ry8Yy7O1r7e9UR5ScGw9hbM=;
        b=bUq6B/fjuqhJGJhb5F4omVZxP5j6n2opJA03bG7H4M8PKjLi+kiu7BFjM5zAtTgx5v
         akG2by3SZjL0jaePtm/ixtTEeXpaxulBN1B0PtzRj5OytQtu6CGquxk9LYtodMY/zn98
         yQW4O0UVPAixNUg5QC7ADwdj5ZXawlmiuoucNKFezIhyfofpC3AKNQnvyifz2e1kiTM3
         s8l9gnD0ERusHwVd9bsfhyigW5MTch2mUkCcWUAjjlXWutQBPdc4FxjJWxxfpZvtYO7x
         anf+UraBULroMpoqLiZpH6y7jbV439DB7y72/cOqEFT1mdITl5uVPmiQYC2xWAA15Plu
         1Cww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687265090; x=1689857090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Woy9uXIbm09rqBjX1mw8Ry8Yy7O1r7e9UR5ScGw9hbM=;
        b=DoQjz9u6h+cQ7CLloxOP7vJ2V0Au4GexuvphdBFGrON+5+IlzzrjF679ai9zFogCun
         iA9XY2+XJbz/WTL/h1vAla27FJ6E7MzvIjNFfxNxWHUYwwMoj1dRxJoZKKRvdP0FtX5Q
         o55dytoXrqVOlXG965HMqcnL3vCH59YrJ9mrtv1pS+Yy4hFLOx8/rFgxnwejGSDk6LRa
         zy09aCOus6yljWDjTIvTWbsN6H+6J6Ynzre1e/wCHMvHwR8uymCsu3O5olVI2bnH6HfH
         snL8g5dcdPBd01M1Gvm9vd9EBCpOUjAJT86jpSoKxcQ2q2VO18mHzE3LKLvXIw0v8my/
         2SAw==
X-Gm-Message-State: AC+VfDwgh+J4/d8AZKar4l6Pm04HyKISy3V/yhrUperq+ZkHJgy0pZR3
	e6Z75DlrGZbm2VYPq1xxcsxItTrEw07smEmfEPVqkg==
X-Google-Smtp-Source: ACHHUZ6+prkdM6kZZEktw29hRWVkIfpIaf/jCzXL1Y0+PKO/f1QZdU2GYr6hdrLVYRpcWNFABBLfvyTb+4mDWXeI71Y=
X-Received: by 2002:aa7:d605:0:b0:518:92a2:1697 with SMTP id
 c5-20020aa7d605000000b0051892a21697mr7702125edr.15.1687265089834; Tue, 20 Jun
 2023 05:44:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230619102154.568541872@linuxfoundation.org>
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 20 Jun 2023 21:44:38 +0900
Message-ID: <CAKL4bV6nbRsiufHPdGEQQgCKRBDE84ApYCoAB2pJEhhfP6wdcQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/166] 6.1.35-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, Jun 19, 2023 at 7:44=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.35 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.35-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.35-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64), arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
