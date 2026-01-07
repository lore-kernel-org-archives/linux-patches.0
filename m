Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645392FFF94
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 12:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767788391; cv=none; b=UI2cM8AYU7z8n+tze8+aL5HpQJ7K+b0Unt8UjNvcKoItmkJvgrPgTAZ4YWPhDITrhe2E4NitKXg4b3g3z54rGpqJ+u1wArVWiLuNFU4FT3tjNZ6CNE1DKAG1W6EQ4+wsSdKoncX87PPUD7FGsbOwdtT1zX8Qd4CLrHLPJe7Iahg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767788391; c=relaxed/simple;
	bh=Mu1+X8A0XxLtnlBs/EBN9zzVFOHeTf0WZ4E98xG+KMg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KOLQ+B80DngOEFNdWFnijmxtUtMKuCF0MKoAjGm9XxdN5M0qA6SdFHH68HWrEfWetMCEH0Moa6w9Pc1U6TO85dkjeP8m3EvqFfIziYlAJpylIVzAx6aVUof1fivc2cuV7NFd4G1+VfQJYYBdL1f80ZjqFxrS/I5lwQYAHeUbsM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=X8UIqkDS; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="X8UIqkDS"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1205a8718afso1569558c88.0
        for <patches@lists.linux.dev>; Wed, 07 Jan 2026 04:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1767788389; x=1768393189; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pvuE9ihmFnCr8o2OGtZIe27QeseGcOqNk9QMk+mpu0g=;
        b=X8UIqkDSEPBtuFA/J2xygfSw75CSxwUMQFegsJHLNjnGn6HWmBzL4yCrMuj/4Hbvt2
         I7+ovaeygpf8eau+WnXJ/BoavyWn7bbMTKgEBTQjDKhxbgaKcAn8a1+NQrWfprJUsWfz
         6KnhhTLbjpD+oCZX2aG16geICf+gmitkc6K8+9XvHDmwFSVXbPnJyppK3ZbimRxUvOKT
         oXoz7AhUmmcz4JuXrknWdHxumooftyoi1sAEguco/+kUJsjwqTkNsqUsehSgeHI+NYzB
         bHVQhWSbtxWRcdM0tB+ndA2+6Z6seVC/TJN5EhH7vKf2Bc8CZEBllz4qDkLJ1DCTVnt9
         sEcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767788389; x=1768393189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pvuE9ihmFnCr8o2OGtZIe27QeseGcOqNk9QMk+mpu0g=;
        b=ta3pHukGZ6EGLlpSrqmqyAUIHqxDWcXNCv0ZdIAE+UFyBSBf9s3ERb+YOEgxrWRmIa
         jU6U223XIl2SNjFDjjLicpy/SjA87q9oTrL5W5jBrpd569mtVKhRH8ixjDARjXl+5Umh
         Qx8h8Imz2/iAn6Cxg+dowBGyJGe8nsY/fJse1qLAVbYMJBbu8d8vRU1ftefIBzMYAp0l
         ICJe8jLwK452ySlSseKv3gMYtfTsAO+3EO/b7oZQj7SGqW9/W36P+1ev0u76sAO3J5u0
         TBQCj0IFCwxsho7L4Z5RrqmMz0nYBWfg9chK2hg61gw6qfiZgmW2DJ+MlBg1gmt8nUd3
         5yXQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4qheHNxs5HcwmDDVtpU6OQwy1y+Z/eNIPv/BVcL715f9/1MEPPkI9XBuiWFNc0wnRUtKK6OTt@lists.linux.dev
X-Gm-Message-State: AOJu0YxPD1dHpaeAgCJ28RzStMrjHTaLg85o7Evtf7xpXnHR6pf5z9pW
	7LMsG5Qbh1T4Xa1Y++HB6j/o93+9FyX/YIP13t81bfHFj6YE/qgK3WjT9Z1PofnTIeYasXz/rcY
	1ufsMulGiIMOHqmP+KnLFZMkYau4M2Gg/ARgQRBShog==
X-Gm-Gg: AY/fxX7AXRgwgqNJc1xsZou1YhBjAg13owPi7aDrpdTyqJXfvzf7tIpYy2/yO2OWpoU
	Ia3/vPFsULetlzYYkPVA+pK041dE7yuEgK01iGaba1ZLLuAjCavS4C/Iqqy7KqitLO5SgaQR4I4
	9QgRFVzMPqzs7APn3DX2lr58JPkewofgQzUxOZgSkELUEArhqTaSVLl/yj9kKYdzqS2rEp1SqR3
	pbu5JpsMqONuwxuR11SyxmaxJgTBkEPIsAelZrY2amMIQC/sz7AdECm24cj98S4ZpBspzrc7Kuy
	fSy11y7xC5KhFEw3leAZlK7Rk61u
X-Google-Smtp-Source: AGHT+IEft3dUm/8D/0fazDdjnIvv6B0r6uOHtwuQTQ5AJ6PLdsByaL+oeh7g9t0imBgPdmNGxDZXaRbbbRdl34DkKFA=
X-Received: by 2002:a05:7022:609f:b0:11b:9386:a38c with SMTP id
 a92af1059eb24-121f8b9d9a2mr1756023c88.47.1767788389155; Wed, 07 Jan 2026
 04:19:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260106170547.832845344@linuxfoundation.org>
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 7 Jan 2026 21:19:33 +0900
X-Gm-Features: AQt7F2pjHlkRuctOjxZHGF_9I6pM9iXzbiWpVFuOQU8IzapoOg5lJtYWzMdAwIM
Message-ID: <CAKL4bV5FRteV1L23Vdu3xfkvnibXeg0Z14ghV1rXPEFnxthpZw@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/312] 6.18.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Jan 7, 2026 at 3:41=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.4 release.
> There are 312 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Jan 2026 17:04:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.18.4-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.18.4-rc1rv-gdc7c4cd6ae5e
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20251112, GNU ld (GNU
Binutils) 2.45.1) #1 SMP PREEMPT_DYNAMIC Wed Jan  7 20:49:02 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
