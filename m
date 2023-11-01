Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20978125BA
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 13:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="AGL6/70+"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-9d465d1c86bso456639166b.3
        for <patches@lists.linux.dev>; Wed, 01 Nov 2023 06:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1698845444; x=1699450244; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zqp+tKsbxuT0dP0kvbmRHXQPetcAFAg5Ll5YZH6o/4c=;
        b=AGL6/70+ERdvEU5xK0lK6FgUqWKUBhrD/HRtGCOGmdFyneHIRVCfJP+6Ni2wg5ozxa
         xeEelVDJYlyzEb81eFJGhnMeOEWh9USKnZicr++ZPIQpEuc1lq2bUA7vHS3P02OFpHfY
         DVfDKEM1BKfGuYiP1qImszJ07iTKIbLK5VGXvDiETyXg3NGO8wXjOIhfLrk1jx7Vc1qC
         vpzN/V17n/XsFnPEk4nZvws6ghX2QhMdSYWBElxK3J5g4BHmNVGy/lqi1lNsl/+SkEL3
         0kkIE4B4uNdIGczLlyQ0GEltncO2PP4tHynEWgu4EMM0oMJ/IQvgADPlNcJbLCnBQSiK
         9vcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698845444; x=1699450244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zqp+tKsbxuT0dP0kvbmRHXQPetcAFAg5Ll5YZH6o/4c=;
        b=Nk5gCGH5f6veWHY78mIGHUQul56n6ifDoghsn30YJN88vzMVCAoYY/uu9ZhSDqgFCi
         7+ShKskcBt02Vv0l7xMewQ7ee21x6oVJJ7N1bDPZxUAkntIaXtOayyLQZW5d/9tVfzxS
         JFwQ+Cwoxp1M+N2kJlLCM27HiBbHPJaP1+DmTep/YrVTwP8z1ifW48ywEkmukFxt83EH
         BjRXpuTEHfgt8pXMNv+hMiJiAUFSHikt3eumZgkdHF78cd2rygNacHxq39Y4x0Grix7C
         FtHOrhhuqEqfzR3En4ih/ivNtlngamuHhWWMXPoekac1x9codv2Y887aumzfHFCqy/Ax
         tU8A==
X-Gm-Message-State: AOJu0YxVKrfDr7HgDZRCt9v+jTSCUXqYWHuVgPtLyeeXR5nf/d4Px1qV
	tafSm9DP8GWXksBWXGZcVQL2fA0LW20ACkc3Q9SDjw==
X-Google-Smtp-Source: AGHT+IE0QhPJiUSklN+lm5WtW4Z7Yv9ImCivRKXFVydz+RY3qA5o2XFPaZaGYPiYDAveM7G5Fo98a74g0NEDILnIC70=
X-Received: by 2002:a17:907:7f19:b0:9be:2b53:ac4d with SMTP id
 qf25-20020a1709077f1900b009be2b53ac4dmr1969204ejc.74.1698845444122; Wed, 01
 Nov 2023 06:30:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231031165918.608547597@linuxfoundation.org>
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 1 Nov 2023 22:30:33 +0900
Message-ID: <CAKL4bV743XcEZTObZ2qY58Mz5TZ-GXbiuTMykTTemO06Py2O3Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/86] 6.1.61-rc1 review
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

On Wed, Nov 1, 2023 at 2:02=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.61 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Nov 2023 16:59:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.61-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.61-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
