Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CB11598F1
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 11:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713957180; cv=none; b=hsH/koT12ftTMEDVlEH00a4WTzTvI0zklEK+s3lyihXb90yRuQig+NL4ok6FxeRt5hpBwKfhHOHPjPHpK6jfduAyM/m8YKuy8PtZCsjI0DHuxNYEyBIlTNDMfBOG89a3X+zjS0zYzBwbmmLUwOOITmGSP+Ni+eZuxHoFNUu9zOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713957180; c=relaxed/simple;
	bh=wmj+hvwsoGodyJmaSnIB2YJCBKYfRJbs/41MVJPknx0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=niyCANza1XYlyDiR6MGx9CeKY76RMjy5vceC8Tc8pus7BDZW/dtjRF7CMRqnZfNjUtlDNIRViW5M72COUWilykioUdMvp8aWnA+IlXUTgzNtgnBHBu07ZaGSOAU19zPrVZ6OwTmfY+FmgjnnRRtHbxKrDv2fQbD1BPXDp3/gxXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=J+oan5gh; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="J+oan5gh"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6f043f9e6d7so7043605b3a.3
        for <patches@lists.linux.dev>; Wed, 24 Apr 2024 04:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1713957178; x=1714561978; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jvc+crjB2MZ5Tq2wExAFBrGTQzTAygNqkxLF7Cs1xYc=;
        b=J+oan5ghR2Xv7KuDevwPUIXMaLvB0qU8z3beNTaZepr+EwixkBKga8Sp2S7aEnanGZ
         ryLJClUBxhk/vhkV4ZAXw6yNmbXThADS14EDx9kEfFnov6qwWsTT5mo7Pjo7uVavPhwg
         VouD1ttBOEVHexD6K2sCBa/WTCDwPYuy7JVUBpoHLmGS7cWor01AveMNGThqqI5Jqzg1
         SVy/CJK8ybYsVyHAFDLrSENs/mk/yH+ebIStZHjbON48BmzTcx4xq/Iwn3zarWAs18xa
         dhsaFNhXnF2FzAh+S+YzuP4pdkq5LFf3xzE1cd+pFhKiJfmdO4j6V8zEdjVgmM0bt/Mb
         wKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713957178; x=1714561978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jvc+crjB2MZ5Tq2wExAFBrGTQzTAygNqkxLF7Cs1xYc=;
        b=MIlBIUOOSQ1E9YFwUDskpvj0GXInA2sorWGyLjp8FmsrKDmE4PXxxEuj948HmfIzsA
         WmGH6SzwcKMIIi4RydqfTLSspcPIZ7sEKU6yXPCjQi/J92sqYK+JqTWZdShcRNB8VPHv
         GIobH/K5+r6DFmir28x3cCmwceSsM2x2JXCE9jp7zrsy3VSKX9JBk/kz6YHiEScLQ52a
         Y3auzOfmLpHgJoUQFHH5b9cjzNJxiGwEZRIqqJgkxHVvtDGVXdZbIMirCCK0LyAOT1Ga
         nLHmt1MAddUBXa1U2YOIP6aXz3tVYm2eQMTgT7LkWxLxoOkoSXALfr9DZcC+IQ3Ihh0p
         cGIg==
X-Forwarded-Encrypted: i=1; AJvYcCWqIHqfWbuPEaBfBlRwT++hlfwc0UfkOEVCX80y3VLVSzwsxDnUnENLD7K8g62wJox4et2Kx2MkGfQQG67cLVRnOL9ep68mVQ==
X-Gm-Message-State: AOJu0Yz4wK6gpyIXO7FkzuaH8WqcwwrXV/D0mWinSeYcyIMsbo2hT13p
	GXFOCXTFMAvPrWTi0a9es67t7dF+960uctpoaWX0qjAIvRPKo47u0Lp4CGblWVBPdAh9bfEOI0V
	4sYqq9i0SSGFCXmO/KTs2HGpF0pCGKHAR9DiJeQ==
X-Google-Smtp-Source: AGHT+IFcZaHSY2rAs7RgXGpaZVJigXC9oX79iU65HlIGhBiIOwEOvRFy714w1FqNIYaJfLgwqpFMCv02vu2I4l7RZoo=
X-Received: by 2002:a05:6a21:788c:b0:1a7:39a8:6ca4 with SMTP id
 bf12-20020a056a21788c00b001a739a86ca4mr2434665pzc.29.1713957177991; Wed, 24
 Apr 2024 04:12:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240423213855.696477232@linuxfoundation.org>
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 24 Apr 2024 20:12:47 +0900
Message-ID: <CAKL4bV6MWQQunGgCZRBzvO9RP=516Au2s-VD=16MfFvDgTGWZw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/158] 6.6.29-rc1 review
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

On Wed, Apr 24, 2024 at 6:44=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.29 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Apr 2024 21:38:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.29-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.29-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.29-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Wed Apr 24 18:35:14 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
