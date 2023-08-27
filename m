Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8650E36A
	for <patches@lists.linux.dev>; Sun, 27 Aug 2023 01:33:35 +0000 (UTC)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-9936b3d0286so278206266b.0
        for <patches@lists.linux.dev>; Sat, 26 Aug 2023 18:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1693100013; x=1693704813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RT9M14f+fzjM8J0OEHrQ2CYoCkLyH8rDZSUrhqLTE98=;
        b=470K4TIKA+UDx0xKr28T1LnbGBAo1YF/MzNcqB4YwDRaPOst6oIQ8KybSDan8xbUEz
         novt/Z+sR2JenoGTUKoYy9VIwEX5cFdb2qUYg3jyKxGmmV9wKH3OkYcWmzsyZO7hDS3i
         V3Q+bxpU9zbOp/p+u1NEa5FV5JaOjF4baZ/iauwu/PTBRgbtv5naW+/ceY3HJxlR1RNH
         vZPi9aqYbl21ijBLx4FmzQwBVU4na3WBuiDdt+MVrRP9FD6tcmHUstH/EZNli8Pl4hYG
         arP1gzdXiyG2vmVvBqObIQMjeIYAmi1vwFPCazMI1c6cKj2gt0uECg1nz4S4C+PVcHvV
         q+pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693100013; x=1693704813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RT9M14f+fzjM8J0OEHrQ2CYoCkLyH8rDZSUrhqLTE98=;
        b=Ej0nA2hiZ+GLWZ/1t7cZOxVZlA+DeW/9K4UK+BJgTRLF5xhpltjCnU8j2J8WKxOJbu
         KqIKkSmwZ8F7eefjXID9dSzAuL7+xb8o2TPMs7gVRXmSNMjCgJ6118kCU9QVdd3T1vku
         XenMFIz58grd4teM7tpTMb7szn6g5KCxha1wC70NJV4qb+xjGgidjkR5IiLr3oElKvK6
         YdnJ5s6A1HP7q5Zt4c5E3SPwiF5O6Y60iDVBBe5FUlJOD4I7gcSLlvI0kjkXYciXz2fJ
         7SbAgZ6XY/DFNg+l8tmpILTzlh3QWg07pjeU4yecN0R2dcJwhJTEq49mxZE7+iy9smuT
         cxyg==
X-Gm-Message-State: AOJu0Yw6khk++Xb7vzaCJg+ogEJrgC7Xxv7MJ7pa2r89MHVFJyboMx5L
	bBSwhChgzk4hatVL5NC/W9kcrpemJUPmUneXE6QCzg==
X-Google-Smtp-Source: AGHT+IESODDnD/Bq39TxKw3pzqhTqWzhiSv0AMsfq+/Gt7aC1O3n9dbtLNKKv4hMcfA8FUflUhDP+nFfgroLq+u18Fo=
X-Received: by 2002:a17:906:cd2:b0:99e:1041:f849 with SMTP id
 l18-20020a1709060cd200b0099e1041f849mr17616654ejh.20.1693100013381; Sat, 26
 Aug 2023 18:33:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230826154625.450325166@linuxfoundation.org>
In-Reply-To: <20230826154625.450325166@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sun, 27 Aug 2023 10:33:22 +0900
Message-ID: <CAKL4bV5npEHw3kfK_b4wbPZ0sEpW3muLzq6ENV2Y-7cqsE25Qw@mail.gmail.com>
Subject: Re: [PATCH 6.1 0/4] 6.1.49-rc1 review
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

On Sun, Aug 27, 2023 at 12:49=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.49 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 28 Aug 2023 15:46:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.49-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.49-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
