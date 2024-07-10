Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD1F12C530
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 13:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720618585; cv=none; b=LvXCIvqqDi07BQB9wj2TdMSmRCWjb9F2Sy7UAvc3s5LTPfeTeSIIy6xvkC6M8eTvZ7rWBnv10gk5Biw3NQ7Edn+X1b7D2HPOJD6qOvUVl5RPrjuXVwOqocJ+ZbEfyw2psldK+PzN5fuXHM5vwmvRo5a6RTwZcJbdXSRR3P/iTLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720618585; c=relaxed/simple;
	bh=WcNEWQKtSC+Dj0jBIox3Xr3GfAY2vvuavazXjG/PjMk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r1SdMDcIuFIcnCTeBhtP2+B4g+38DQWN25SOsnG9QVCScLda5scUp85UO/1pJZDFRog9lsVllMYWrfUB39adZaZ5mxKJXSqntiEQ4nP35WlswYHWmjWzMfvs5i9cIQSLW+GDwk5VRCZV2+EaKC/l+Gp7q3vXh6eU7IgcuBF8aXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=ZOrWtFyi; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="ZOrWtFyi"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2c980b55741so3962237a91.2
        for <patches@lists.linux.dev>; Wed, 10 Jul 2024 06:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1720618584; x=1721223384; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+5I4HocYoLlRWtU9xSNyyq0WSjcKj0wutOR3acSvmA=;
        b=ZOrWtFyiQ5Cja/gOZt+iXOB1WhKOmzmZaEnOBjXewVLLZqrgnKl5gmz8HWGRqjl2NZ
         5cF8VcxpCVeVRmN+QDi0UwsxU2KJWvlxs8xWheS+vBqkPrqNqQFTKlxAGFR7oqh2hEn3
         J+A2xz9iICJBTl9pUGbRencjhSG/NKGb/VvSHk6aXd05UG6AvLIZcaN7dvdUENe8EPJh
         T+zl5bn8rukr9oZcD1CpMfZrJbnsWxR0ZQ/4rPUMRfb06qoe1fuF4r5+14zgBE3P9L8p
         mJ5SXZLxK7M4JYQuFUSUrGANauyYobPz+Y319TMTuESs2zih0uGxeGSLXRiysYep81oB
         Yk1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720618584; x=1721223384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H+5I4HocYoLlRWtU9xSNyyq0WSjcKj0wutOR3acSvmA=;
        b=QXZQlGhvAzA+0/BvGXQi3AFzI8jsnUTsL0j40VBVe4WIqbNgMcKsNMQRiRybTrO4nj
         9vK3hhR5yadxuCWBe3HbJ+m0bkCwfl9RPuL6+mn6fLt16+0BcZXYWafsEZX1j9Cqxtsp
         fbOGM2zDjBDqPVISWlazX/h+ojbb0nFjE+QDIKtq3iMMYYKttUUsZTUYle0whMi1eTYk
         Z51RI9rpHRp5BvC+K1rePirOKuzNC5IXgpi65pmZS4zRtO9vdA6MSltsMBHEPPjVSbcg
         Jb29rtze5ZCw1rA5Z0Uk9GnC7q+GHxYC6uInc9IKCWsDUDBxBxTbI5wYTA8glv7VSGF9
         t05A==
X-Forwarded-Encrypted: i=1; AJvYcCXJrJZe9XNioT38oNo3VcMniqXrm1qKA+Z8R3Q+0xcMJcdiKlu34ak1WMPvw58FeChUTa+lcQteBuWGwnF6l6kgLVyQ8AZb/w==
X-Gm-Message-State: AOJu0Yzo+jtkFIITICvm+g8yYF0JlOZaQemK9ITe7GmoeVKEkNK50jBe
	DETDbGU1SjhepUACeX4popcrCUqw2tOoQlUAUrW+7glvPF4kc3DkPqrmUDFs7oEfSE/95wq55B3
	Q0FWOhn3zVT8Kd78QHP2n97f5XZ7B8iXIqNUGBA==
X-Google-Smtp-Source: AGHT+IGVWjcx2CIKKhJpC93dsIDJRQ59BMorlnyl7TRS9pMm/YWO3qF6CzwWosQ+pKzgyemjtuMmhhNtcB7dLeMy0JM=
X-Received: by 2002:a17:90a:4b46:b0:2c9:65f5:5f61 with SMTP id
 98e67ed59e1d1-2ca35be8f0emr4813325a91.9.1720618583619; Wed, 10 Jul 2024
 06:36:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240709110658.146853929@linuxfoundation.org>
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 10 Jul 2024 22:36:12 +0900
Message-ID: <CAKL4bV4bzzKhUv7u3SUUDD=dp_KZ35K43faoZp9aQp5GmUfTCA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/139] 6.6.39-rc1 review
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

On Tue, Jul 9, 2024 at 8:12=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.39 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.39-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.39-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.39-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.1.1 20240522, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Wed Jul 10 21:13:34 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
