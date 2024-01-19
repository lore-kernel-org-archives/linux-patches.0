Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F4D405E6
	for <patches@lists.linux.dev>; Fri, 19 Jan 2024 11:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705662290; cv=none; b=J8eia1lZQcBGp/g50QFa5+baulaz6mPd9w7+iSRw0TpAEqbM2HRUkoSbonjclIsufTRhICxvNV8vvcj+hnKj5gJGiWZ+9YJlBj1GUxVULpv8oQLE9rAPq8AiYc3CxzhqnXSJuax+ziaLEiVOeDQZzUsXiomz9LLX2o/jaaEC2GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705662290; c=relaxed/simple;
	bh=s/TnUOaVcirHIg/27RVY/AorYQLtc2gpCHWKrVpCmDs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bO16Y4G+o4SCv0T8/r5WAt1CLHyf5tmvBIMzZ8ojDylmI4SlIzNnZ04QQ21oIJubHwoA9vu4DWp62ocjlQRm7O6KlJ+Wvppf70/Dksg/IXP2OP9btZc80RyAK2ZSG5XeOp3UxpWBooawdAwSOjMl+frHtp9a8WRdzGXMYt/clPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=NK5R9DDw; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="NK5R9DDw"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-29023dec816so649363a91.2
        for <patches@lists.linux.dev>; Fri, 19 Jan 2024 03:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1705662288; x=1706267088; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a4xkGKMnZA+oZi5Rpvd1qJz0dx1vB0koQJUBRdc30aQ=;
        b=NK5R9DDwwHsBYAY3e3ygb/hBEeGrFBZjpNB7u4pZ7icPG8Zn09QFE/6Zj/qdAfKzmA
         h9ygyqo5kNX5lLhpCydpFvENtECVE8Pyz3WwmpoYODLPNfJky57a4hyq3ETLNUF5VUP2
         9FLmblOFixet83toxBA1A00shupkkrYwHq/reLq+BUBvzs+XWuu2ddrzU5/WPxYbCYBt
         axIFnxKbeEYto+QtQt+5ICGFZWagRDYaUjmtbQ+nwJboCJ5ISywj8aqobXV2/JAkFY07
         InFh90LKMj6e4yuGW/N6sNrw5qn8/LRuZk+ufuxZIw69zdKcd0hvz/0fzrGSM7hezcwn
         gXGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705662288; x=1706267088;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a4xkGKMnZA+oZi5Rpvd1qJz0dx1vB0koQJUBRdc30aQ=;
        b=qaeCsmsIxB11YqDVM8ceC5p50iAOBUnyXNlyxFBfaTIrnHIopeK8RQ1ESevIGcG/SG
         gwNL3SSpewM22RiXdCrLqN4YtwpOc4MdKu4bsdUjeiMGpK0ku04cJfvOZ5GVlHtrJjBq
         67pMoVh/kkLbeEPwAEpHPzhFx1ERDLSBokgbUxr0D0Mu8fgnl2/KOkjm30v1U2WiRAxb
         UajuMkj3M0U0bxMgxH9h4oqJ7h8v0knqRa4PY3sV7nGa7FONbWaedjQ+8zTtI0JPzCdq
         jnqHm2b81UOCEcdD0//apYWMALr7s4pwOxM2OzOgRLSoxkTTIto3+/T77KUsqnwcKgv7
         aqJA==
X-Gm-Message-State: AOJu0YwDabTZJ8GBYVwXqsArVON/HL54osGDAm0XwX8hQIeqNeCmUgRD
	FcyNsLgSZk542N9OuR6tmZEk0LhC+ZYrFNt5keIFFLv8sjchnGogeVcJoPGb+1tGQsepUETbO3H
	NqGm3b5csgZKkyz0qFAF/xFQPFrDFIJpL5FFhj8NCuRCeajSmeihu/A==
X-Google-Smtp-Source: AGHT+IFotxPDd4F3itxeYpRkFweI0JG79cmCQ+lLF2JoYLy0Qd3EZyAp9j+bDU8p23blDHElTZaxPzY/AvfmK8F7adw=
X-Received: by 2002:a17:90b:2285:b0:28b:fe06:5dfc with SMTP id
 kx5-20020a17090b228500b0028bfe065dfcmr2116750pjb.29.1705662288325; Fri, 19
 Jan 2024 03:04:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240118104320.029537060@linuxfoundation.org>
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 19 Jan 2024 20:04:37 +0900
Message-ID: <CAKL4bV5YqPvGj5aChTaXCAhvimGjU2dWWhEn5pykoaMj3AcejA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/150] 6.6.13-rc1 review
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

On Thu, Jan 18, 2024 at 7:52=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.13 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.13-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.13-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.41.0) #1 SMP PREEMPT_DYNAMIC Fri Jan 19 19:33:56 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
