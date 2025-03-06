Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079611FCCE7
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 12:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741265716; cv=none; b=Kr0XMYge2HJkm1gar62+qVbxRLn+kvX6KKTDlS9aRPoQLZj8dovxFoTuGMzPBxAlaIAoXbS2WOi3yLN1fVm6ZyswCos5+1+oC8RqpzR7T/Ddt7UlNz4pjUA8WlM4SGLAnKmWTgYkz8UInTI8WOdL01XHeYoPey633HuFT4wZ9OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741265716; c=relaxed/simple;
	bh=CL8xqMbDSfXJhqryd6RGNfCVZzu0ssYGv1JLaVXfKDw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DFSG1KuCWOqtyPZ1pM84a/20X4eGzPT79AwzyINZi4/X/weV6X0VjmVt2lj2Rmz94m+1PPKFFw4pgE1owgVHjl4WsBz2xJnblBC7WsGIcOmjcfeU8PrgGODseTxkx+srjzGC7mL6XN+UHoz5dMAzHgwPcXK7K/W2Iay/1W38lXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=ByT7Y2Ty; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="ByT7Y2Ty"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2fec13a4067so962628a91.2
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 04:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1741265714; x=1741870514; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ccc/H2dnyXMFfYeHkIhobLxEoO1aevmdpjSTBRDha2k=;
        b=ByT7Y2TyCyCfWISh+XRFSB+8Q/kcgPrKWTRvRI6Q3XJTSgHHgM57LL18Ud8jWIIPwN
         LC8Xl1HaxRxyIuqAUE5jENSdUvQ4GzkpdRrbzGCZ+zdK8I+lZIIe0D2wIrPCXJuqMRbI
         C1vKomTTrLfppVwZysNuM4F8t4oqJ91E7hsv5M/6d7FN7MOI4ueLmX2UYmwXwBBBo/uD
         vl9xurtlIgwBVsVIa6b46wt16kcADKZ7L9fkgSOGrKdXo9PHxHAtZ+eZJ3n6XZdjJqq+
         OmtuA4Z/gIhFtiSLtDtTZsU+zL1wBlOOlWNC4jqWjcmUSwNbbFrYU8CJMVqycj3cPWwG
         BNKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741265714; x=1741870514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ccc/H2dnyXMFfYeHkIhobLxEoO1aevmdpjSTBRDha2k=;
        b=pAenP9jOOGJanDAZKYJ3fiDbnmou/gTnV7+s9eHVLEBWIi2i3Km6mdkIBUYLEjbddT
         n47HhLJ3OSzwndCHW1RGiog8KUKmLB51mEcjVIPTbk3bTpVOkrXAzNMAwXFXM8L+gtz1
         uFPW+jdwFkIwU8ugxrKDhHBqd8T+37/0C/HItMi9YdxJ2vvkleNk77wh6K+m5taHtt/J
         mGEotBB3gIlOPem9E7K0BbQSOz55BqcxFBP6tql2TLyW2hjGoA2h+erkyAp6Ok2zGZlk
         5AjLkauakjJHKPG4XBEE4FwqcMk5l34692CEsrsbCYJD/L/1xRnOQqetOSMMINZmZPy2
         n6Dw==
X-Forwarded-Encrypted: i=1; AJvYcCV7R5Rgl5s2mfuefmHOUtIvM7w4QhZt05r6NHaEgapEW9d8r9o/nZ2HT9PhT5npXsiKyvBeJN8H@lists.linux.dev
X-Gm-Message-State: AOJu0YyH3D2t7A0lU9seUUhfwy0XSN+vwwmdODiLN1R+hpyqqPm+kxJ7
	nwH8j2pyll+KcanWfUhq2VAHC8Y2go7+ciJqvYXecAsfTRTFKuphF2r6Bokyss6oLuCe8W/X4Zo
	cIlHVHjKQTX7EqrcArtLdjQyLAy0vrM4sPFmHXg==
X-Gm-Gg: ASbGncvrgkdd5Ki2lamVnv4OLUwS1MXIieZmPrvlEvSSf3ULNqELRKnv/k7E/1h7720
	xUKgBJjNZxJi6jbNeKz6tW/lILRWfpd7/SJlt6NCHrBvTes2QoJflOx4CwbAcfarUTGAu+2DMjm
	jGzvPUo/HjBmFjbAEGtMCGfMxS
X-Google-Smtp-Source: AGHT+IF7OiPlaCSQEnsXNBjhCDFUemUvQa+NRtTs/JSJ9+1Qyh4+kePAcg2WzwOWcgqtz8B61BAqo3R1eMqK+BSPwLY=
X-Received: by 2002:a17:90a:8c18:b0:2ff:5e4e:861 with SMTP id
 98e67ed59e1d1-2ff5e4e0a25mr6281780a91.24.1741265713650; Thu, 06 Mar 2025
 04:55:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250305174505.268725418@linuxfoundation.org>
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 6 Mar 2025 21:54:56 +0900
X-Gm-Features: AQ5f1Jpv_EZBxAwkR3XhpjU0MlJG0w8trjkFHUomYWnS5F4PAVsYZYvVmcl5D4U
Message-ID: <CAKL4bV4TstXsNOuvqKb7shhdykg73r+zAP3MLQsf0nvGYYT0Rg@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/157] 6.13.6-rc1 review
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

On Thu, Mar 6, 2025 at 3:14=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.6 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Mar 2025 17:44:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.13.6-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.13.6-rc1rv-g30be4aa8b957
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Thu Mar  6 20:52:49 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
