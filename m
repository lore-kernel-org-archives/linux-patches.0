Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0769417D4
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 10:33:44 +0000 (UTC)
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2b69dcf45faso28042421fa.0
        for <patches@lists.linux.dev>; Fri, 30 Jun 2023 03:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1688121223; x=1690713223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WMvg4+xf/FpT2l2ger0oTsMzr40HAUi9gV+dNJ+SQAU=;
        b=ptIyYvAGr7z2ddcaHcOP+a5GUrlPfF7+kvw9taw+/uSBqODpirNaXfrjvvaah2YJO4
         1I+MABWWd1CMrpSEEL8XCWF+dfhQzuerODUen0VCYKl61KpU4edsHLHSNb/e/8KWVpku
         iNLrIGxlbqQy2MJ2uLDoqkplGXbaoeRbvFubhmM+C1vjdZzT36cvY2cLUfGGOAlthxMy
         Kh158t2XgN9f6kdlcWlCDAev77ibQ4onJGwHEAzLSGieQ3K/ZWUP8R3qYUdsxz2QhyET
         f4xJYykbgbt91ep0t8+htl6DigRVG61IO8UFbqxQubKQCzQxU/VD0s+nXv4n4DdCNVjA
         ythA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688121223; x=1690713223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WMvg4+xf/FpT2l2ger0oTsMzr40HAUi9gV+dNJ+SQAU=;
        b=lPYWrzS8MvxYBYtxtjeOIfdwdVZUNwChkmCHIM4JDBZbmJP/YddsoCG8CLZvJv093O
         FmSpGaDwWqE0m2ZUCEC08fydPg2nEnpW4x4WUpCU2f5R9Z029d9lIPMzDF5pU/GRSMy6
         TuVy5h68ftNJZiUobTRU3j8GJ8KBOYne0N4c/9deyXyn+5S/W9JS41febELOd63HZPpZ
         1ZCNq1J4EkX62/EBLDv/Q8YfJHKQsHIo1VUt4Xo9wKh3npMNmzN+Byrsda/mD6QHVfix
         ZnjNkZwTf2sPK5p8Ag1VYy4ie/gsj06/b8pAJrXK2JxWI8+8bxDFOov9phwUwh5gDUoT
         7pNA==
X-Gm-Message-State: ABy/qLbGZ9DAPUgZ6VUCMtGuIqAy7y54hKeC2A5AIHbC7IXf0GQWoesg
	ZzvHeT0ziVYKObWmE8IavmH41FvAL/TuNCvKVoReIg==
X-Google-Smtp-Source: APBJJlG2u/xyzuJ84ph37p/iQTjUyhcv/0ujEisW8iOXdWjzS2aHJnQdoa55ieUt9lpi45BGDEBdxvotYQGcYJ/euZE=
X-Received: by 2002:a2e:9b0b:0:b0:2b6:a5bd:da2d with SMTP id
 u11-20020a2e9b0b000000b002b6a5bdda2dmr1739785lji.27.1688121222628; Fri, 30
 Jun 2023 03:33:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230630072124.944461414@linuxfoundation.org>
In-Reply-To: <20230630072124.944461414@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 30 Jun 2023 19:33:31 +0900
Message-ID: <CAKL4bV5Dhh3n0cLnd7wvgheMOrodFkCLa-RpzK9f3NW+n0jsKQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/33] 6.1.37-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Fri, Jun 30, 2023 at 4:32=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.37 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Jul 2023 07:21:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.37-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.37-rc3 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64), arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
