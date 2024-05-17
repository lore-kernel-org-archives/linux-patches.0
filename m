Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2CFBA2E
	for <patches@lists.linux.dev>; Fri, 17 May 2024 04:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715918908; cv=none; b=FTtSMrHs/rKiky6qzhzhj093NAV9+UuuUUvCnXO3gSsQYjOgH66V2rhZxPwPWh88obzDdNf3hch9fQAteMeennTiQQTH7MNvj5IOGCM8/C4T7AqXTW6Z20FFez7tO1TaA2U79ZV/LiWpWxqqmoGSvI6lRrubOYAODYI6kNwnyAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715918908; c=relaxed/simple;
	bh=6+Uz3blSvLFobZIL/OP5jNoLWkv1gFs+020MMxFWXwg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B2Ym351nNf2d0Ndse2rbdjIFJ2T84CMAIaQWh78QSrp7DCjc+0xeHNjjUOqF0sJBw8ftBPwQIw5PHlX5s/DQ0zx/jTFHZ20dICxEsEYYEEOI5olHFTEQDRPbjeFeeNLInrsDJ5K8d9nEgAJO1EZ7JS6GJRza0QSNtbTgUT9PoZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=b1akA5sD; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="b1akA5sD"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-60585faa69fso604365a12.1
        for <patches@lists.linux.dev>; Thu, 16 May 2024 21:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1715918907; x=1716523707; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X7pYmolyX6LtzqiyQPnIUtpzHGrCDTdggEyxoBqZiFg=;
        b=b1akA5sDOpme5LxA9IlIkw1TePI24FCB/JXiJsuh/12/QC6FC2Pn+ihy1DCDtKMrSk
         kEjs07Ve2HHHX8zal02ceyKaV6Cn3BQlWyIdE9pgUYkdIKhAWBzT8t0POPYCuNRCJVV2
         +wX49rCgZt97IvcyllXEHBIYiDBMHF+g0FMGQGcHHyPnrs/ZDDAcQ75QaeATzttkylgM
         /TZDmqA355lVTkyBsd7fCvPSXNtI8Us/4YLOFrk4gOdD0KWLpELS3V8WG5f0eAvbaRuf
         Q3JMl8MGvBpp+e2JlRpDMFuxHg2lrm9Bz4Himt4lZiIinHachUaZMQ+8cYfgqsvObDIs
         rM1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715918907; x=1716523707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X7pYmolyX6LtzqiyQPnIUtpzHGrCDTdggEyxoBqZiFg=;
        b=jGwHjllFqTFSZ3vyzUVXRZWZY5iArNNbiensz0l17tqn4KTLZTbyHthyvY+1zVr5Ly
         FXO2BtCO8SItpwQR4KCyvMhXfMUYXBdxuuY+lTI7AJFCq9RYVbM2DKfgiC+L7JO0XRfY
         89f08jMKLjfxt6keCvupPpNjuqSILNgXCS7BkUTvmWANiAxHZkPIJDV5WRqU0XaTAIaF
         S0lbKXKaJ9LAWkg3wtBGVDMTe5idHveS7jvMQaEuimXG2ZawwiGhZCb282acc5m9zL1X
         vSF8Lbhj/GT/70F+0ZmVy55qC+9h9IuHq8ZYqmeHITbVhMgGWC9r10omkqraQ3pweAKP
         V+mw==
X-Forwarded-Encrypted: i=1; AJvYcCU2Z/4UwjUxlZXwr9N43m9bJxnc5mOn5FZRP1WOJkD684p+P7kwH/CPYandvjuJRSqd5YS/1EyCzo4hSgLsnutMshccy5NADA==
X-Gm-Message-State: AOJu0Yytz/B8f4/ngNIpO8vBsWd/d+EhJIJPom2E0vWEsqLMoNYkezZV
	hzjh8isx6gcnJdMYDYon42Bsb/YJ/fBos/6+tQp0xA4K68cf5D3wjBGVt8Nu8uYhfHVa9Xe+7lH
	R4vv4HLgyH8CS2Hv1aIHvWvSbMNQIGXwZCO3R+g==
X-Google-Smtp-Source: AGHT+IGecLsqL6tl9xvM8D8czW3bdjhLtsJutGGzjXKsfLl5VIFbzdyGPn9xWacjZDMmALlIDR4wRadonqzYDPPQcEQ=
X-Received: by 2002:a17:90a:51a5:b0:2b1:54e4:e125 with SMTP id
 98e67ed59e1d1-2b6c76f9388mr28128174a91.22.1715918906790; Thu, 16 May 2024
 21:08:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240516121335.906510573@linuxfoundation.org>
In-Reply-To: <20240516121335.906510573@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 17 May 2024 13:08:15 +0900
Message-ID: <CAKL4bV4nWc4GtqbbzG_vAVwNxvmwTc3WZLDuOHeTfOim3azgig@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/308] 6.6.31-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, May 16, 2024 at 9:15=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 308 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 May 2024 12:12:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.31-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.31-rc3 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.31-rc3rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.1.1 20240507, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Fri May 17 12:30:22 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
