Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236A427A938
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 12:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745498280; cv=none; b=IFt12f5WIsZ86/soWlXsaEIY+Y83eR/B/sOVfT7btYPtiuDasqbANteVlNxgd3AnqPLttFtpPljwOKsuAUSJWqI7V5IKWvuMCnlpZiY5jCMgTks8Cq/SNQyQughsRXrFfLHgLo0LsKMDWdfYxcWmvm5AWaSP5bVDkJr+ZiSFi5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745498280; c=relaxed/simple;
	bh=y6xwBroK6Cw33bDi3/bZVR2AEIsdxRcF2bY256Tok1M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DhPA5UfoaLsAG7l+xsjtXEaVnGNEbewoiRfDpQEcl52TIzcjrj2+UNc72PLSUJp+Hm5LAKbvOy2nzU55as0Pg6SFGqGOFemgBIqggaqe8NuvAOeqXDsO8PSvU2GZvRS9lnDzM27VUrWA6h7d4GfIXic7HpnfVLsb69PTaVMC7LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=UxFVS1p3; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="UxFVS1p3"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-aee773df955so1760238a12.1
        for <patches@lists.linux.dev>; Thu, 24 Apr 2025 05:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1745498277; x=1746103077; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nZpWL/S+NSRUlk5wqUBhROOnOk/3l0ze67ok0V8c+5I=;
        b=UxFVS1p3OPDI6nm2veFH5Ov8diGCaEUByFLeO8iXEuLMVvbckiVCaXmFZ8OI+ikZQ8
         l4cRzHT9NXeJy62of3/p8SsBPPSam7lGpBxGpvQWqHl2FS/z/72UywQqYbNwNOI0OYBM
         DXJFUPLXGFBIzHvPHTX+KeE8WPxS2DAb9FJbbDbCKCbw2O3mmjGDGwunSih0moEBNfvS
         Fpj8PqdgvESStnEf0eNETp2ehZweucjxp5KTaq2MxpU7m/sshjhYX/vIbYJd1uS65oM+
         nkvCBwA1EyHCEgvb6bt7k1JT/bO0/mKRnBNq6zYuWezrxRrKS6xLIBomWYDoO/BosFmn
         m5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745498277; x=1746103077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nZpWL/S+NSRUlk5wqUBhROOnOk/3l0ze67ok0V8c+5I=;
        b=uCzLm4cR0IUfgsgoe06hNy2DeyfeagT5i4Eucr6eKz5hRMQwmEEvGnktJHf5IL2tfy
         rLu76/u0be/CrJNJQnjSERozpkVMm3MXzLajSH+kbZXCQVxHx+Gmjc/RRLvF4NfUCdl6
         fSUgYSU03lAYY7DfJv5YQ5gJlRhZ3j7+jfjI3uK4Pp7Q0+nk2TAJI50/RTd1qrqCYryJ
         72YAXYvIceVnx7aiPxhltWUWKQNtfjNVkRaSgVR+7ZcP4AVcbzfPq0j+KkfYccSscRMG
         Ps3i1Vcgs6iVkFCeP45McjuXX2zswvePVrksvaS5b83UN95/tRaAcNWVkf9lGc/7BiiJ
         RIaA==
X-Forwarded-Encrypted: i=1; AJvYcCV0iB75dS+xrquvTxIDzQdGG9ttDAB3xxQuO+tPT/9f9EZlujAVZNgkeHrQek7uCHYZE1svY8cU@lists.linux.dev
X-Gm-Message-State: AOJu0YwjL1NyvSBygVwVr6Uxg5I1KyJxvV6Rmz+pEvkJeOPfr9+GlNTK
	rT9kudQi2MyO5EfEcZ8JW5RTWEaNKz/EkPOUGmXmevdXCfBC05f1DpbLoSv9ka9pAIvp7YrJmTs
	dcYfgpfiUmeG8eYnttxgpjq4cgYkMjRcWU9jyhQ==
X-Gm-Gg: ASbGncsNnJ+yaye+/YwR64qbAqfvd7Nkz8brQ/Tl4PWYn8Ay6u4IW1yJRHs0CsNl6Pp
	XAEC/uOQAcE4QymI2tsxMyg62M5Rqf3ydNVZUBc4kU14KAYdcC9u7OIzK+gz/98Bg4Urh9xbiPa
	BeiQFfZz0rRcaT3HtcH3C+c6OLKGl+KFbk
X-Google-Smtp-Source: AGHT+IFZiMB6j3ycGd0+0mt1gFr0C5pjE8ZeKmh2QCQ+qpdXY6INn1eOuR8jJhehu9q6wu/xF32MCcHREH5Z2qVs7zo=
X-Received: by 2002:a17:90b:28cf:b0:2fa:2133:bc87 with SMTP id
 98e67ed59e1d1-309ee37b4f8mr3286435a91.6.1745498277298; Thu, 24 Apr 2025
 05:37:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250423142620.525425242@linuxfoundation.org>
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 24 Apr 2025 21:37:40 +0900
X-Gm-Features: ATxdqUG7SveaxlChrXmWKmEOOPp12zjRNih3IrQJPBkjwP-JegqpOJKeUEoj8_k
Message-ID: <CAKL4bV4AZY_8WmQv25XC5EiuRzTS4gfCoo_DDq0evfFkMmHZqQ@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/241] 6.14.4-rc1 review
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

On Wed, Apr 23, 2025 at 11:47=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.4 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.14.4-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.14.4-rc1rv-g86c135e93323
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Thu Apr 24 21:12:13 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
