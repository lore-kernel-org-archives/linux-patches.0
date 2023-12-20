Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C37348788
	for <patches@lists.linux.dev>; Wed, 20 Dec 2023 19:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lKoNflMt"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-5e248b40c97so626327b3.2
        for <patches@lists.linux.dev>; Wed, 20 Dec 2023 11:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703101102; x=1703705902; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MNikzNGiijk+3h/nmRItuAzAl46HZPOUR0AnDs8oHAs=;
        b=lKoNflMtRtpNCSpOQuKPrQfr/iGq+Sck50A71p2PiQS60XXzgKZMyFA5CTPN1WrFgu
         HozUYC+8RJ3pD/SoP7I0tLESQ+r5e2EvOSXFfXxk2YPojVN0//I+9afg7wy7AVlusws/
         UYAj/KsznxV3QrFG2bNp63jA+rpwb7/ohWj+/WK5m+oA+tDiOSiko037Unvxzj43R8YA
         96OSwWUlyhfYHzUzsAvuHHxTcBJjASgYZC08dLuzCtzi0Q48uIJUnl9sP151LUcrwYEv
         r/OKwGVMPKuAi8tBqRATkoeE6LDIvT15ksm8gkZiESYmfhus9ik/MabNXpLnGdq6g7se
         nS+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703101102; x=1703705902;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MNikzNGiijk+3h/nmRItuAzAl46HZPOUR0AnDs8oHAs=;
        b=Z1Z4vsvLs0PJXUBO9okO2ZWKuVpzDPVF5441ZljhD8DRMATn0mfVxfjicUvWH+JSg9
         nc+cSBlIGIEjz/3OrJctRk00qMz7TosRdL258Rh7u9b7KTVfluVh0wwPgrLFQId1o8VR
         pNwX+MPHeiwO0h+x3xG1R44pN50yLPL/cxD/Mvwy/6ruBSc7zCnDFFprSyLQ2yjaS0F+
         9RBuFQFk09RaAH6YhXmcV8X5XgK5xIN85oo62TevvoSAZARRgbIg4aFSNaxxHAGduUeu
         7O2c1tcSqQoJMl59lOkTdUYkjfJfXu8Ud5zNEr0/qpvWQtsbV7hkLRW9mJWdM0jM5x+T
         LYeA==
X-Gm-Message-State: AOJu0Yz2AuU0n//02xsTV2AIpqYUYp4PucPAZ03MG/WXwc+bza6mo1tP
	0Otil+bh8Y52MLz8tzfZUFQJnxUPdkG3mxzrdpM=
X-Google-Smtp-Source: AGHT+IEMLWLLWrpL4vLO9ZfDNGdjGTubUBWV4duV4vjBrXovq3mYS2P65ifXEI//SW/K+wcmQozczFA57TH//CkBO5s=
X-Received: by 2002:a0d:f4c5:0:b0:5d8:5727:80fb with SMTP id
 d188-20020a0df4c5000000b005d8572780fbmr240889ywf.84.1703101101988; Wed, 20
 Dec 2023 11:38:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231220160931.251686445@linuxfoundation.org>
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 20 Dec 2023 11:38:10 -0800
Message-ID: <CAOMdWSLiqXs2zg0HBKf--htX+Ve0d-=RjGXwaoNrf4CbBS1JOQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/159] 5.15.145-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.145 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Dec 2023 16:08:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.145-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
