Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96AA54666
	for <patches@lists.linux.dev>; Thu, 30 Nov 2023 23:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="2gSGAms5"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-285afc7d53aso1466091a91.0
        for <patches@lists.linux.dev>; Thu, 30 Nov 2023 15:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1701385270; x=1701990070; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S1cVYcm/OeSo6BOhKq2FohPdg3opafKLsK7d+uEW++g=;
        b=2gSGAms5IQ55t0t9/4L7Bd19Wx82tb2xAcO2pDZ2KXlVMNoPPUumGVZ/MuUR4DIfsh
         yYQkUqDLQrR11Qm7ffdCQf14DfozoF58+W4b5ELhbhaXSloHVpWcEAMD2Q5KM16CHlgB
         31kpmvD6zdRIJVIEme7QXZu4m6taqJZQ+NgmbvghjHUqr6OMDCimQ69hMYvyTuZZYkos
         jbgmIDUtLQZ7zk31WL6RZPjCfacJFsrqn8LM5kIfk1BIGhDqAV1FN+ATLhtsSBuoNOAV
         Pf9e3WWDELzfj/iCDTpweqNZo6IwQIDLEVGN7XqhIo8jc8gS5ylUMfv1kgBDnhAJsoGt
         zrDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701385270; x=1701990070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S1cVYcm/OeSo6BOhKq2FohPdg3opafKLsK7d+uEW++g=;
        b=voFQiNXPZ470Gd6tTKdexyoDs6LQcs9e7Ev7+zAF/AkHCOPwnZTsjbqQBzSlNJD25P
         2H4BcphCLKx1/foI1rs4lpPdQgvDMh34ucwq1Rd3RACJSDor9nW7phN870+9t/fIZdBN
         SIYgq5QrYVWwbfpPGM2Q8kPtvSewG7IvSnOuQH1jzneWkMRlKucHbOE80tep4H4H3yiB
         feV+sY5AKaxRxOp1XmqN5ZVaGLW8yIa4+yByC2kBDfQQNWsoaVSZuUG6HzK27UAePs8a
         pAUrT3anzB+BtoUJb4MSCs4Kc1QqLaUF3VJxgIpT5T8BG6G5KSkY6xXoCLwFwalJ2amp
         7cHw==
X-Gm-Message-State: AOJu0Ywof7736g8s41eq/y372HyfOMGaERhXYYgXXg5OjZuhMbctNz5z
	vUqjxRpPR16LDbUf3iFwqIn1Vl5TTIV6jkhcvl7PYQ==
X-Google-Smtp-Source: AGHT+IEdrStr8HreR71H8RgH+eVepHBA/3COgP49K7ESslFvasx7ODg2jWp1x8fYZmT0haRhQ9m/vFdzQPvWb1TtQsQ=
X-Received: by 2002:a17:90a:1dd:b0:285:9940:1bac with SMTP id
 29-20020a17090a01dd00b0028599401bacmr22407438pjd.2.1701385270090; Thu, 30 Nov
 2023 15:01:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231130162140.298098091@linuxfoundation.org>
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 1 Dec 2023 08:00:59 +0900
Message-ID: <CAKL4bV5f+0Pbc5wLab96mqHfhHxv2rKDh+yiz196cSSvw9TU+w@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/112] 6.6.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Fri, Dec 1, 2023 at 1:23=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.4 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Dec 2023 16:21:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.4-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
