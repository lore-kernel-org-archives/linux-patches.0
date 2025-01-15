Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004671D90DF
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 21:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736977488; cv=none; b=p7urKSVDp/OH3DPX/35UG6sEV/RFC5Cl7hx0Aax+stqoFG1lreQAupc8cO+VJ25X9W+E3RtNW3cpsWaDSRI742BZ/D9Z7i2a6i2HYu6KVPvR3xN0Wdn6kpdvvIlA2gKBzXQEQwqe4ZgXOgtQ2e3C5G8CwxW1thpd2IcmidR3CEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736977488; c=relaxed/simple;
	bh=ktwr+Bks+JGEYPz2bxmRQo+i2FTLq9SbvvFZOGDPuBM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NXcUB+4o6P5LYAo3wJi77150EjizRSofSXt3f8BeQzgQhm3FZhvFAvDmPRM1XfdDK1z0RNbbBpZ4OR5vFC8pPByEiIWpACgs2OZsyuKu+ReQNOlLOs4EuBR/X11vDadjYlnDElZJtiX0XwB9ea/+cZSNpD4gz/EguamOWU5saxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=c1+7s9X5; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="c1+7s9X5"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-216401de828so2760885ad.3
        for <patches@lists.linux.dev>; Wed, 15 Jan 2025 13:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1736977485; x=1737582285; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RvB57iWG41YV/c5cBE56VtHaQNyu0vUymV/5xtD6lV0=;
        b=c1+7s9X5EWzjaC3vYxFhU2cV8ShL6g4+j2dPOzSWYpl3w299Hcd+SfZaxeDN017MdD
         sN+xqDXSr3jO74xScywesIYXLbLV9F9s9IdcOambD+C7Yu3gZYA5VZ6SV2COjWFmYtel
         4UelUrsHdA+VDn5ZhN53O2wThxXLn1SkQr+rpY0ILL42E/DxDO7f4XyaKsSgr9e0J1sR
         Z4+JkreIGXZYX9J6yPDIdUBQoHTD30TCGTXdEbA0gaFCH0HVj3sVdaTuBDwZqAah+dPP
         7nUydeeNYkpQ8sItItdBkieNOAwAgxEBatylD6Imh19UGmGSR8qodLqoY2SUDRHQ6p9q
         YStA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736977485; x=1737582285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RvB57iWG41YV/c5cBE56VtHaQNyu0vUymV/5xtD6lV0=;
        b=ZTKZQa/m0GNjuMgujrhi8zlTJ8WJ8y9fV9urfNqLd/bgTanvBEq3q1hWbpYxUuZZUl
         cMuyd+seJWsYpcXFRLalGsE1SDbNpn63RCYs0E2U3wRMeZQ3YSwKiEvxtD2vI0eOBS5I
         YVKV5cTo/YuUQv9cxNrdCUo7DK37o3r1IC+FWwEs/mAN2cinv2DjxKwgb75Bn8x3gN7Z
         7FBsv4rmNCXp8/kl7DRScY86mRkSGJ5mPRvq1+Tjiz7UtiurXqeRqQEDLDX9LqgTE5Jr
         LK8MvTAhfA1OTbC5CRwWXcNgvJh9gbNKd12KQ66MLNA+bvhzl/0G1iTHZRXT/4dM6ys2
         9r8g==
X-Forwarded-Encrypted: i=1; AJvYcCW3FOXUvyITrha09ORQhbYbhoJuWLAP7CZidmrfYi80Ii2ioBKUHpqqN+2cXLdhpHIIE/eryQvZ@lists.linux.dev
X-Gm-Message-State: AOJu0YwPYf46UZ++3oRKKmyYowRQysnwTd+sFFhuEJq+KTobjt2h1Hlp
	MpGLv+h+VYEAQxbgYN55uw+cGBRXIBkkF3TQJXjoD4+v+lUL3/cLtF+TPEszYj5J7X/nMo4KmFM
	F2b0vWw20+h1koIEwBzejY73w1uB+PyWU4uGklQ==
X-Gm-Gg: ASbGnctqdYJBkx9eQsw39W//kHdhoQACedeOyS4jxx9wmer9JPRDRv18byEahjimjVK
	ubuWD9dxX5GQh/9Q966Fz3ICEgcEgJ6zV2BQUlQ==
X-Google-Smtp-Source: AGHT+IEYXpdn8fhLD//ERvKhi9v6Gra5TD7+h5eUOjnBpp4kMpMLPDHNmKwnTBtu9gBF333DQqP6e4pfNsr/yGZ1IAo=
X-Received: by 2002:a17:90b:54cb:b0:2ee:8e75:4aeb with SMTP id
 98e67ed59e1d1-2f548ec9267mr49215825a91.17.1736977485235; Wed, 15 Jan 2025
 13:44:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250115103606.357764746@linuxfoundation.org>
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 16 Jan 2025 06:44:34 +0900
X-Gm-Features: AbW1kvbcxzww3783hiPRGUKquUIKhrVkJWtiveGXMEw6BJ3sW6loCB8MgyXi2MA
Message-ID: <CAKL4bV5XnEP2ZgqGeHCwX-c0X5C4rPZ7iS0EUNW-hVd2TCHxKw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/189] 6.12.10-rc1 review
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

On Wed, Jan 15, 2025 at 7:45=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.10 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.12.10-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.12.10-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.1) #1 SMP PREEMPT_DYNAMIC Thu Jan 16 05:32:18 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
