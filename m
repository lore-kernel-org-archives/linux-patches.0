Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18E07E1
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 13:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742564866; cv=none; b=ccvVv8Hy7QrrpO+0VrIqE8huatHz2ISiygidACIpA9plOWvppsw051QG2N4jAs9qmfUOSP1wndwkpmSvzC5d6JYd4FjtWhExEroTAvN4gmvDVB5vDFILm4YMzCzUOUQqrDKI0JZHOBeQ+SqzVrDJO8FPedU8lQUcPBT1+UeKnb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742564866; c=relaxed/simple;
	bh=zto+hD4T8Rl0wGhIV/0xoa9IwhY4ZDqaQa3d6Xj1HKA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tS+pKWUTlqTa3KmfaNJPY/jNWtvZhTuakcGmDRNhDAakjzSiEIFxyavXFaHgU5C/+bgFX/xH5VcFKaruavUpoxFjTZgyctoNuEaZsnKlJg03gWOvhrcWqcmuKYHMAbmdglz3vkm0zXsimuyUNMwio67qxpcTur0owsOIM9azmtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=cToAyQy8; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="cToAyQy8"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3012a0c8496so2564863a91.2
        for <patches@lists.linux.dev>; Fri, 21 Mar 2025 06:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1742564864; x=1743169664; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8nQgLdmlUqdr9aYe+VPc8RjHS/d3j/W4qOBy0BpvdI=;
        b=cToAyQy8qKQthemvaCrjFTYqXhsgQuFbS1I1HQMU3DiPsBqkOQgFTRWjXcJ+CqFKZe
         /BeZFo7CA4cLgdyU24qPb4/dHu3ctxGT4IcPq6AueRuiKSuppKZaXo2l5CsTizwkMC+b
         Tjln7Msz1qg7SqgttO61vl8aiNptlt9dt76d+/1cU94aLcFGpzDL8+oOvBMgRMAyrDnS
         2a+iWRjmBqdsxF/CEmKznofbpKFTPLdP+2tsftYsv0yiIkZobTsSCE0KI7VPLwkUIQfp
         CzAz1Cb7CbIkm42GGzn4/YmgYTMczPQGf4flI4A4RwUnIeztN1D7L2212T0czwUlZp66
         89pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742564864; x=1743169664;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O8nQgLdmlUqdr9aYe+VPc8RjHS/d3j/W4qOBy0BpvdI=;
        b=EthhWFwywbrP5NJW7SrX+9EtjA009cPk4ykzsY0lSMEE7vTduK8sn7EVPd/xTGE5Ub
         ZMs839ny1LimsjAsYr5TOkuBRNZz4jrUDwlRvaY/OLs8Mf3J1Ki6lgN1+Xpls3R4QDY6
         tOXJTw38y+Od+ROpv3IEZuLR2XBX/zJGN3DTti0qB2MK3hjBNr4mdYEb+LwtK0RfNi9E
         5RaymThN8L102e6Reb1/LQxzS5YOD0dE62NALt5RRFwwhIIAegyeaLkzRRngfq2tDVU2
         cTvDsV4u2nuH+3WPDK0GFa7HDprkMwRhw+25IMQD1rLEj4vKjGJsG893hv9UjsEudU2A
         qEWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjO4JnOoViEgpntE5Bw3vpvgOuBM01ZLZqMcMkgWYCKMLnB+G6sxNg9IhYC+F8lhJ/tnKEmWmy@lists.linux.dev
X-Gm-Message-State: AOJu0Yzta17rz4JUQWhi5efYg1UTAxXG/QtpiCPHZDZ17Vy4efunP5LE
	rk8AB/8XWkEG2KKD7XVmB8F+KiYpirCPmtycgDWpM+NcAkd5OVyXzdmbuSQRXKnGt38gSnR6Mqt
	OmqGcmPevEY3rr2tYkpXkKb39p4d8bdeQZmiI4w==
X-Gm-Gg: ASbGncskG+mwOtZdjS4LSmo1fiVC9CSCgMM1B9Zs8XkLeU8lP7mTSt5hWWGfoRqM9Lx
	ERfXWaEhzu9+iSUvMQU9SNCDTWP+1YeTH2NzN+t0MRRDLqlvV4W8ENNUHSV8C9T2AlSgZYj3r5G
	cwujVitC5J0potIpW9/9M76sotukffu6kO4HwW
X-Google-Smtp-Source: AGHT+IG9gHzXZS2MDHa4IE9fwTzJ1H0FhHqAo4iMsZRn/mh9NpHgxYoGlNF8O6uvXxiYLj+Zs6L/giMBpxyi7SPgYGU=
X-Received: by 2002:a17:90b:2dc8:b0:2ee:f80c:6889 with SMTP id
 98e67ed59e1d1-3030ff07367mr5795406a91.33.1742564864003; Fri, 21 Mar 2025
 06:47:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250319143027.685727358@linuxfoundation.org>
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 21 Mar 2025 22:47:27 +0900
X-Gm-Features: AQ5f1Jq_-0xkKqLvecUc-RyuF4NKyutsPZK2DjPZzNY6v7pHHsBsKKACW7x7r0o
Message-ID: <CAKL4bV6JL0A2eqhC3wkppUyJLEXfTZW9qqVOHnY4p4qy8zLjAw@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/241] 6.13.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Mar 19, 2025 at 11:35=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.8 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.13.8-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.13.8-rc1rv-g14de9a7d510f
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Fri Mar 21 21:51:52 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
