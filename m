Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CF0158527
	for <patches@lists.linux.dev>; Mon, 16 Sep 2024 14:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726495824; cv=none; b=MJUrK4Lwp9lClcv8iV0AGLrnSWvZMhpfHy8TF5rbiJn7pVXLB7LImZD4zrS7jkdvpRXhb7fDR8Yz+tMEVV+9bA4AS3r6ELh7JtmuobB3mfQmgHFsB2/biVD0clEhi41QVx044M4Nqrm4Ciau8Mjw7n943wHIK8DbiKHaSphil60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726495824; c=relaxed/simple;
	bh=Z+VVMYEinWZISnatS9m7WZOCo5cTANY4O5vrS2RyMg0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e9RpidWW7VdDmYhmjvdhP2+Kj9sswRqehNmPRtTIBaEBTiG2fSG8T+hNf3jktG81D/mA1NeFsvgTTLcmaFL+hp4IAHSDs95li5FZyqeHHP083PV8dTr6QPqxfss2vrn5sQlSW1ShYrhH3Wo37cMjBoWojMMSiDBh0n0x+Zl61ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=l5H8HQDI; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="l5H8HQDI"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-42cd46f3a26so26780345e9.2
        for <patches@lists.linux.dev>; Mon, 16 Sep 2024 07:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1726495821; x=1727100621; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qf3XwMadpbdi02w8khiprAJxJ2YHAsadcr9JrJBY/mQ=;
        b=l5H8HQDIx67ggZtk6tdhfujNzWgW6YSxi+FRYXmSWf2mnSKCyaaREsHRQsx+CUxFRq
         sp9sp95roUBaxXaBF6v4Kaxj7F7L0wJpJjkp0xPi442AvU9DY6S7SsHE8iOIdvb/YnvD
         BObJKYSAv5d7Aq4WV5d8FSdtgZHPz1T3KzZ/1d92T055iStRwM4ro5wZcXF4MB+Qonc9
         t63nyWeFEJ6mDzvFIsyg18zMIBaxjd9a52uNG0/eSws1AFahkB/b44OZmd7PmM40Pny2
         gIsb4EBopYIxuOvvOchCF6+QwTYlvpRm0OIUvsHhakYgB2fjOdd2E9cUczhctBoMFurw
         XdlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726495821; x=1727100621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qf3XwMadpbdi02w8khiprAJxJ2YHAsadcr9JrJBY/mQ=;
        b=fgzI/PLXXskUT53ew0+hUTGrun02VvOH2iJsj2+TaFP1+kzmbbofq4towXO4U98Qtw
         ClceWQJvk2wYTCZPdsfGeWHVza2abLkP1faRYM/gQxSKyulXdyF64IguFJIAHVv+YPUc
         aSejQHRZkEBFLeimpyxAL1TfIKH2lqMOSQ7nEllX+5e3KOgrB9czZI14UaRLYjF6fthM
         hP3tu2m3IQEA01Fm1oGB2pGWpZYIUQ0+hgs7fHjfNx7oWGYhYS+Jfmrj3C2IDdVdDzIk
         wd9oJgeXFKSj1Uloaj0qpVNxgQFw3V+q/TB5WS5DCtytBzXblomoAIqhY1z6vhC6eFQf
         hFcw==
X-Forwarded-Encrypted: i=1; AJvYcCVsxazWlOvUXZRI2pQeM4jV64XQuBpC4LH29mTvBTh9z8I4mmLo/5gfd75wV8uM0yi7ZUYvBL9l@lists.linux.dev
X-Gm-Message-State: AOJu0YyAc+78SZM4+uMImxILbnEzaIfP6Dw4kFXgi2ElExwStG50DmHd
	Dey9BT7yzVaVPqED59oqzql32rhGxamE3C1kpNnrhbpVvjW9ZlA7yuZYqrdK6Rkgn9uwshOm76U
	KAKUGyRTQBV3UFcoae/vPOkbhinXaalLP7d2LZw==
X-Google-Smtp-Source: AGHT+IGNe9zsNe9IEEFt6FK/qfeqEqaQ+brEvCCBY98xBgyALI4wNUeQsrdsVTt0cieNkT1+Kekc7iDWS736YTEtFyQ=
X-Received: by 2002:a5d:58d4:0:b0:36b:aa9d:785c with SMTP id
 ffacd0b85a97d-378d625a662mr6649923f8f.52.1726495820589; Mon, 16 Sep 2024
 07:10:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240916114224.509743970@linuxfoundation.org>
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Mon, 16 Sep 2024 23:10:08 +0900
Message-ID: <CAKL4bV4JAGKpTZ_=jOX2npUwe598AbSM9gOekgzRVAhaa0xgLw@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/91] 6.6.52-rc1 review
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

On Mon, Sep 16, 2024 at 9:09=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.52 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.52-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.52-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.52-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Mon Sep 16 22:24:01 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
