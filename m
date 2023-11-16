Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0362D039
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 11:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="ktW1+dHi"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-28019b66ad5so515119a91.3
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 03:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1700133492; x=1700738292; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xit1Esx4idoFgZhfPLc9TTvkzWtJT71XEeJRKrsKB7E=;
        b=ktW1+dHizgSEcn7KPgHBZLngG4vCxLOjXexuVEzFxbsXzV/wwRfA+2Hy49zjXPKpDT
         MZSyGMmH1im5BtHDrho6rTY5J6hrxmgwOhnKHPkZ77rEIC9n03UjfjEnUvJK3nWt568D
         /N03ipVqzbC9awbi3dv5KuSdSvDj3z+TsPlfUV8qWO/D9+jJG8RZ1hULq07TXQ6k0WoW
         Ps5ZIjpQsCV8aJIhLEWfxfJbklFSx2ZADnoE7f+DyQLF0wkYub37lUOgrR/gC0UVQP36
         Z3JlfC2ErYWtJmsBOxwFNYcU++3ziBjv+6dPKkA4C8I+Zy/bdzpwzdAQCndYztnxFF6J
         uJcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700133492; x=1700738292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xit1Esx4idoFgZhfPLc9TTvkzWtJT71XEeJRKrsKB7E=;
        b=SYyXy9pqmp8DKkTBgUWufyIJTXbEoDgc6egjLocfMjfgz/KvIQJLosVNM+4ObF7wgR
         CzD1KDGYSVtVROfYf/YbaWbX2QMx0esQfdWJRHtZ3MlZl7CR9CHQ/Lx17Y7gCL0/d5Q6
         Htq+lrmkdFuV1zYom/0BLO15qr9uM/rZdV791dY/9UR0PBg1gvJg9LnYsNDpJP9QUrhs
         QaV+NIuMpTH4uEAUCauqtZ0SO1KpGuyNI3HhK74SC7Gt/f7Vb3eKVGhcph55wj/41XRh
         B4smFh4FDEx9ZLI790/VzEoe64DlD8fZZdEnms4JojEAWMKoen1o+IQ+vWug88NzKsuA
         P/NQ==
X-Gm-Message-State: AOJu0YxaXVQKmZTt79eT4SYUeiSnGrjCdyKMsKwOp05H85lQsifdtYDd
	/Y4mr8562OxJiLSsbBbhG56HqCEhd8/Hat2pfrvZrENieYacCDeNa9I=
X-Google-Smtp-Source: AGHT+IFd2C83fKKWAojxeTf534pIRJKEp0E9M6JGoAbow9IEjqCGzjTiSIlV/+gwzJLw/BrtQ/YgfwkBF5TnJcOR6GM=
X-Received: by 2002:a17:90b:4c44:b0:280:3a0e:d34f with SMTP id
 np4-20020a17090b4c4400b002803a0ed34fmr15750920pjb.10.1700133492428; Thu, 16
 Nov 2023 03:18:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231115191613.097702445@linuxfoundation.org>
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 16 Nov 2023 20:18:01 +0900
Message-ID: <CAKL4bV4fE2_79yd633QUZy3c7NsHZCSgUD0JxsjsM8KF1zfj+Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/603] 6.6.2-rc1 review
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

On Thu, Nov 16, 2023 at 4:32=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.2 release.
> There are 603 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.2-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
