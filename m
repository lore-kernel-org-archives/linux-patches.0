Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534D33939B0
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 11:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165996; cv=pass; b=EEaobUb8tV/lsMA1ujPVkaWMa5y/8telY8JBmKwH/scJ0qLrFo9eGiKBWRHP+YNL3ppQOVzECWDWY5Ke6z9soe0GkUReU4BF4qLj7ARtZK9s47kEvKZENn8xHhqairM0L7tX/tr/jy/L8aNB4qMa+qxKboISPUelfTwqX+d+XaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165996; c=relaxed/simple;
	bh=U87Ve3F+slIiDwwj/zfGyU5acKLqTAX+27VOZ4zryEI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jti9t8DWRLEAh/94zqksEwev3TbuS7/wobgEOPog6k8RvKkC6ew5mqFY5zqntFQgO/bROGkseV5PiWvbuB4RO/NPmwahVxX5btr8nhJJvbHPUNnR4hBC0fbcNMgspZ+gbcpsKX8dnkNmUF85IQE8ACf/Pf1B/Vis5i9Li4A/mtU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=HWRe2tna; arc=pass smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="HWRe2tna"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-12c20010f10so14026777c88.0
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 04:26:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776165994; cv=none;
        d=google.com; s=arc-20240605;
        b=Etfyl1K3ccPcDQAdvMzyUUE/O2ci/ytsfNHn4kySC7YpLAdmImup814nBzHT1uTapd
         2o5VgXzj90SaMUYs5E8lsVkb5TeNHA/H7PT0dLtSLX652rzW15NBB81Q4/D1XYsAtlyK
         4ylYV5riyqVh/P8yiFl9QaC7XgTRjU2z88wwXaT9rl7G/XAedvlwqyNL5+ULgZ2QWfYV
         M2OApvySi5wDwG8yadKtEidn/DYa2S5XtQNCLJQW5IjvAESe4jUCEAreTt4xsp0Xb0ox
         oNtd1QQwwm5l/vNiIBbJS5smHWO+JU+uNC6Zt1P2Uw0nPrCQAAgXSNUakX4ConTivtg5
         0uuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IZ2t8Ae1TdyBWLVMYN0Qww4hRu4fpS7X7Z7GGfCKD04=;
        fh=cs83ksm+hfsJa5ePtntFe97SGHFoND6IRWpuAJRcHSQ=;
        b=eWyayTn0WinUyequgYsjPNGEkWAuTS3zPXLxkJ+LzrG0V4Zl6pyBJ9gM7Qm0jvebdq
         zeXfapEnGcUHm9/+21TOYXGD6/lU7lDr9HxGvH8OSwkmzgRYqKICCWJ4Xe17scfxO57z
         zVTs6R3+nczSOfisagcXMn6jrJhYcGJ0NUAW6QsE+KKyxviD9uAPTL4r0UKTaNgAelBq
         fGXt4vcSWcgnOIZZKjgRCH1eFFbiR1FzRA1TJ7wDfiAnV8a4D4d2kw1+JUhqzf2oSbnP
         dvM66NWK+XXl/vq26/xIQV63Si3Dfbj00tynJYKlD6lzbTBJpa6kEYUJ4xR16Wz73Ao8
         1wHQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1776165994; x=1776770794; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IZ2t8Ae1TdyBWLVMYN0Qww4hRu4fpS7X7Z7GGfCKD04=;
        b=HWRe2tnaL5JIwL4bM+0GVc/iubVpmw7VXZmnRMLn/Asw1IGwUZ8AdI6W6k5Z2rlXBa
         qoUDqEr4VIkfdznhlA6352ImbbmP9M1p0Y4c9odr1oLyvjUVPbmF2EP0uyxbtzvqpbYh
         LhP2IzM5s21Kfk2Xo7J0s4THDeVROEacO5bM7D6+vRfBwxRbBD/OVel/U01EQJs2TQB1
         uyLrQ6XGVzWJKuMrZAvq/c0D10tAE/sqTltfBYnMmuz9H6DfIl0IVJfzjPLhe9FNG1OY
         pFwoXoaSkB36F0VgR4542I2atEejr6w7WkPhMpGUsYwAe8WZnJ5flfK9g/6yN5lpwWId
         FCfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776165994; x=1776770794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IZ2t8Ae1TdyBWLVMYN0Qww4hRu4fpS7X7Z7GGfCKD04=;
        b=Fh4oOCQElQFx2f19J9WI3+z7aPMjIXKSqPa5tHylDNu7sskI9ib2HV1gja3jW7WCxv
         cPtTweHyJBa/xtb+gPbQ2tH7nXwKj8/3BqvhtfSj2fDErCpvhF5ksRabdBjfdcNI6Mww
         adW0hBkRS1ULJAwEA47g+WYLzpXuxjcmk2X+DfjqJ6a2jRDlsxGIj2rFw/vNglmzQjxQ
         TnIA0bm8LtS3ofqzzMSCAmF12ZZKkuDo/NAFKVbpLEmNljEffvqH2KoYmk08yXZCSIBn
         7ZLuSXWXGj5VYK36fy5fz6JUa/2rhD8CweBrJ5bnFvXCV+OlQXl3QFc9HBxgEec5VGNn
         jbNw==
X-Forwarded-Encrypted: i=1; AFNElJ+9vCzO71UfRNzmlCwCeuwcK5WUj3Ny5e3Q8IB7r1a/fDoftBHDcmwZavHeAotKsSX3/IRqyqvN@lists.linux.dev
X-Gm-Message-State: AOJu0YybMkW2xfc1n9d9I3/blWfjRrsa0BRw/03J5L7vxCNnpfiU1jcH
	R6UTZ8Iwf0CEVdr4rxYLkGwaAYeavlizwTd6C5taq54hj2dlCzX/L7V4m7exmO9TkbmdE8sCQJE
	uM2yK2yWi2AHQYftNh3pPLnW/2jmaYIyqvhtGoODUSQ==
X-Gm-Gg: AeBDies4b3sATDMFH4I/2dxsU9Wd9s5QnwaJIpPRIFH5/ge/RE49jl8KacCip2A9/ra
	HbaO21beRK8HRT25GEqyT4FI0Cjpzs/Cbmt5CCel9yJA+DrVihfdX7Odvw+ihZWznzSJhwFcAFn
	a9PE+12lNZhl7Oej0Clhl6U50bpuigGcaQ30yGDqJBugTygk6NOFx/0Bhb5r5P8Pr73mqk0dVTE
	pSxdrRoYxRfPoW/ILOHBQdruaGv1c6Po6XVD19L2dVlVS28my7+y6F1g1OnQ73edaVGPyG2zit+
	UeTKT5sR
X-Received: by 2002:a05:7022:60a0:b0:128:d51a:5161 with SMTP id
 a92af1059eb24-12c34eeb884mr8941610c88.27.1776165994246; Tue, 14 Apr 2026
 04:26:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260413155731.568515178@linuxfoundation.org>
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 14 Apr 2026 20:26:18 +0900
X-Gm-Features: AQROBzCxrSiw-mnC-3e-VB4zdM2rQE4hYWXDBBBLHtPC6QAKGrRqP97m9UDgQUU
Message-ID: <CAKL4bV7Uec+rF_21MuQEpGcX9i9LVeBpqVR-HX3J5LUR88mzuw@mail.gmail.com>
Subject: Re: [PATCH 6.19 00/86] 6.19.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Apr 14, 2026 at 1:07=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.13 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.19.13-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.19.13-rc1rv-g425b22d9f3ed
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Tue Apr 14 19:32:50 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
