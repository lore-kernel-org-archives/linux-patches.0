Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FD1198E60
	for <patches@lists.linux.dev>; Mon, 23 Dec 2024 23:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734996241; cv=none; b=NHlsjVTuawKaS41e+kD/K8p0YOpJsBEWrw9H4VjzNFEOrcQEYgJqVmEuy/iEbbfX9a5iOvYL2SlddZIl1SDvufvrLOg5iUGBxjW1nHpQgqdnxpUFmkjelVrXNKIrb+sQ5q6TVkK78vIcYbV36wMaPcIBXLGpPmGfyKH3edzKuQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734996241; c=relaxed/simple;
	bh=XxRBMrZwBvgLFSVqcmdNITUgVenxPQ6jGTOI3cDVu+A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DvfK1bj1Cwol+OTDnSbuc4JxU2ZOzV1cW4GNn90tBsnl7Hq3fz/V7Vfk0xW4a06lIDltvmO6jsMFKOtoVKWn5il2y6sVXzVDh8cDW3wdgk+G/3Biz/s48XSG+aR1XAIwTi7RXTGruXwfyvP0knTsPLAHFBGOrx202nkE+MvuXXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=g/fhnSqT; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="g/fhnSqT"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2eec9b3a1bbso3413349a91.3
        for <patches@lists.linux.dev>; Mon, 23 Dec 2024 15:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1734996239; x=1735601039; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nu8BnE+0embuj0Jexzr2atsg2wE/YBGIbUUyn+izezU=;
        b=g/fhnSqT/htas1HyB7nCKihTPeET4YNdaJ8EKObtXA2Va23D04eonH1zGl/bV0LPSk
         Gpw/BISUquvYuENcr7IhYb3a+eiCjbzAtkOv4Zs0UwW6GWUUsSbO53HkZHgVDXPTscup
         eRcEoaJMRAcDeXS8DAG441vriA/kSjl+lodoemuqWHBzmUitBg2Nb6tOsdzPZxjKAaaF
         mowg47HXy0S6nzDKBp94qSmMl3y594PK/Kwinru90KMd8vWn+JEf4Od31n8LFuDgc9vQ
         Q0DXSxWIbLc2I2OHZCl/g6Ff7eOxj/+qMOyZCF1cwevoDzMEjkyRdn9tuCWx60cVmXx3
         8mBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734996239; x=1735601039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nu8BnE+0embuj0Jexzr2atsg2wE/YBGIbUUyn+izezU=;
        b=XZvH1NXv49t667qz9jDCs7nVjn7VQ9R9BuJSNZdinAT082PfwTDmCEBTLQLqrgS7xn
         rOxTzibQjBY3NOnlK6+8QIuBapTB+f0/IRMuAWxa76AWgXTwPNKxSdtn7hb60B0XRVka
         +TvA1M0Kk6uHfEGFz4F4sLS3ztgVcAVByaUyALzWIZgekby7BIbaJCV/bx3v2uv1UYYA
         +Z9cWbjghKPzm8rDyx9ZFlHh2ObHZ2h9kRv52GG2KpNhTqWXLLU4cBEqaEACYVegvpmD
         qI4Y5wc5AXMKJsVhK25cCcBNek8s3Ai7B13ejyPjOuDOZo1ncdCi52PT3INaFV8WwSe9
         Z2KQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYF52eWX64qyiBT6RZ382dDKtZxcMTOXMzYjUc5MkJrDnkQHOUpOJaPo9xbZpGfKlfHy7SdUIn@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+aAPq2jOQyokrNir1KqUJkL1UJBKAHgPYf7nnbYZh25fyqdnq
	x+HvQHeVINZT5Z17uYmvslp72LOUNykpOw7fXGgwFcv/YsbsTg28gtCAdjnjStfadsMDD9n35NB
	DRUWf+oK4I/9BFkNmVUEv2gPn9gGEhS3XIYJ0OA==
X-Gm-Gg: ASbGncuB//OGOdjsk/rUlPfp9StIHleKq15LaCvMMuTy8uUz+HzP32K0ALHoCXl68ED
	JBas1jbhHUQeet6mLPe0WSwvZdxr5P1jxJJRW
X-Google-Smtp-Source: AGHT+IHFm2Y/NQwVFIvuy9YKniReoPPy7ISeUyNFk29SB3r9RmBIqfjn2PVmpP7CAYc+6F8IqCch4cyqAhj/oNUAT6Y=
X-Received: by 2002:a17:90a:d00b:b0:2ee:9a82:5a93 with SMTP id
 98e67ed59e1d1-2f452e1d13amr22438502a91.14.1734996238883; Mon, 23 Dec 2024
 15:23:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241223155408.598780301@linuxfoundation.org>
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 24 Dec 2024 08:23:48 +0900
Message-ID: <CAKL4bV6N+Kj7_6VGOxKX3kom5Mj+H-GUwEbe2T0JN9c7D+LgEg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/160] 6.12.7-rc1 review
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

On Tue, Dec 24, 2024 at 1:00=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.7 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.12.7-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.12.7-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Tue Dec 24 07:47:05 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
