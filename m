Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483471DEFE0
	for <patches@lists.linux.dev>; Sat, 14 Feb 2026 00:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030190; cv=pass; b=NG/yjvcd+A5B5xC9ydHIDM2uVBQg0/1j2CrIAQAmmN5n1UhVPayY/YAc2rYgpFZ4dOmikJ4q+wDFK9qsIRtbeO+CjfpdClexkfcMGbimMKvohrXPTMhaaJ6ZkyIKoCF13ZsYx2gBqc9wP2guFueoyiAyVOdm2PoXwXYJVMrtghA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030190; c=relaxed/simple;
	bh=a7PROfwzw0uDYjOmUvdofyVuFC4ks1BIodJ3cizCOgE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d329gNYZqcTDm+WaSK6PTgcHuHEv+gEhe3CadreH9om8/BFX1CEwzi+SRsjtiPBqPo3rJeUI1Cn2UymY969tKeh4LgPMQKoTDPG1oyMgV1L34Fap075MoMpqDfYAwiYAueDGcpaTIqqAlCQwMscCHTBbW9NawRxXDFmyuF5xiZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=R4yLSy7Y; arc=pass smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="R4yLSy7Y"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-12713e56abdso1185539c88.1
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 16:49:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771030188; cv=none;
        d=google.com; s=arc-20240605;
        b=doIOHRsX9mLU9/8jfSTPY3PFFDdVjJffHNC551kWhvM0fwkXKkQLs503h8N/F1QRbt
         uVkHVB+6BMe1Ln8yVQdmVKUOh3IH+GQkiypVUxViqGp7u3fZnOuw2MEVkpWRjJtzW1F6
         piKDcToIl857ESZvF4KwXUYqkRDH1YxuliwhAhMGsTdhf/YS20TQ5doROPXe1lIy/+D5
         IO0wleyAXFKWYRp04ULBFHH0ZbUmlfeocuQhhcYNBOsPKb26n+R2Hig+HqvnyHL5UYJM
         g3wNpN5Nsathhp253nBZPkeed6gHofe9pw497vFoweoW71BQX4Ce79GLEKombPEs5FRK
         K9+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MDeplCTKE3hBZ9MCemPQht+8CuEL/Hn8Q/JJRmPD14c=;
        fh=sO46XbCbZlW3wKv0fwv3ypq/+88dB2WhBOUaD8+qp0k=;
        b=Tg4sUxpUaT1SdqyrP+9R0BWKWjMJtWkSRvy89TZ9pSbHZ6GIeUdRshS+lV/2j9/f1T
         T4C2SCqf0FJLzPyYngax60cDEMw2BFFRU+C3VxvLKlQjb+eoZp992Nhyn5BURPqB1Tvz
         Mwc9gJ0JwTb3HtHJezD/XkIyKrivzL3XKmDDjOxV2/Fl0OO9wjxPFvdBFGUHxurfkgpW
         9bWFkUHc8QYUYIjkhz3wmVKjgCD+HMDCkfNZ8PhEuHCBaI1agwHsRQjJV0G9KUOn+stR
         waR7bhohDsVua8IRfw6JePRsjlKGrIeuz2CWZLMNVCoeKhiBU0nmHq+EyoiSkQkkh2vG
         dlrA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1771030188; x=1771634988; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDeplCTKE3hBZ9MCemPQht+8CuEL/Hn8Q/JJRmPD14c=;
        b=R4yLSy7YmjNSTNRcN8WeQEOCxzTmuLQ+Nv3fXVUj72UAnS/knc8yJ81ja+iiWv5jJ3
         pOp+vk5IaiOzuTCXH6J6nl5uqQ5QUczVOmChK7w2hSJNqJ7iCSnAVq24mspn/Dsp9iN/
         nH2kwEPNKXAdMClVTL9wSmrp44vs+z8DwgcLykU55HAVgxjXcxt5vyCaLorCrDBLtp74
         kqaG77hbmAsNER8DVFz/bYCwNtddU9xRywaGV8Xm9X5NFqxfL/R6B4LLILoJngNP40qN
         DP0Zh+GEXvWo+SEGSsnP4K0yHAZMhKzX/49CeUAiwxCFG3MBpY0rEP7LUs5xzbRrUKsd
         3KoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771030188; x=1771634988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MDeplCTKE3hBZ9MCemPQht+8CuEL/Hn8Q/JJRmPD14c=;
        b=lDDrUSW8irIMQ4SDKiBgiQ1bc1jA16vql1RqB6/+7LWdDGc3nbhgdeA42+EaL5G3Tv
         EOqOURjNxySfMKLlaLS/XcqRYQsI1Ey9xHQEfhGDYJGvty/RM62+kdf/ALj8Xap8hxK+
         lVNzF15Wt+Gyd6dtPkJmfa3buNy0NvdXN+OrXaSkQVZkAo7W/dVgRTN69xSBABXI0fzS
         xNM7vbT6WZOxhdpUPqKkQBSXSRcacgc6E/xO2CItW8Z1F8x8xpePqQsRo4yxX2hoUBfM
         2x5sZAntBNyx2c9ceEORMCtaQxPuoqVZz6bNFCHtiJBsBbZE3LPQuCUC2Xizr2Z/0jBK
         ngXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVglgRV/yzazNbzu1aA9qwJE5J0o/dWA3RCcTYMbhQtaqQhVXchWazoIvV28o5Al+kiEgTrhRd3@lists.linux.dev
X-Gm-Message-State: AOJu0YxJBQBW7R+LY/DOWxoro2JaKD89PH6hbAikyiZuBPmsWC/VMHcs
	k33FHEgSkdQGhImZPzyKCDnFJlSEhlljM/TZTZ/6KY2DDL/5hDUQ2fldnK23W1kvJVIPD2FouLN
	VKbDWKe9zBlzeqVYQRaL+GppOgFoKtRmTB8cObinabA==
X-Gm-Gg: AZuq6aIeKQ7NaN9ZG8Vx3iFUr6DlCIRx193h/Zz2SxqBYDYcliosK9C+wrU6O2lMdcj
	e+BYSbyDg6Y07YMRwnARz6JjbqCxEGcxjD04I2FpUGKPDNMGFKXe264QlxFrHLxrK45ycnjVoVZ
	0aktBwmxu4isWB1rzHSwvnKWG9oZoHNlEpRFXrWUoMleRr1dVUxOfYDaCsVtdlrkYJ5Vicvr2Ps
	anb45QY9WjSorpAeeymH2Zj13Dnh2M1V9f/PdxZlYdX2cBGh8YmzhxSdB10MMs7czdkyb6T04E3
	3Wk24kCT
X-Received: by 2002:a05:7022:628e:b0:123:35cb:96d2 with SMTP id
 a92af1059eb24-1274103d2f0mr909512c88.21.1771030188313; Fri, 13 Feb 2026
 16:49:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260213134708.713126210@linuxfoundation.org>
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 14 Feb 2026 09:49:32 +0900
X-Gm-Features: AZwV_Qi-J_fSbdclz5U2-o8QFNrhomSioWRPng1Ta1jpF_YCy8_tKpJrk64-VMc
Message-ID: <CAKL4bV5HP5PExu4DPHHhiDxt6n=SH2WEpoDGb+JHA+D_6RE+TA@mail.gmail.com>
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
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

On Fri, Feb 13, 2026 at 10:52=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.19.1-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.19.1-rc1rv-gfdd37e7f30ac
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Sat Feb 14 09:14:57 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
