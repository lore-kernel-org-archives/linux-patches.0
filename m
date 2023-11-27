Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2101A3BB36
	for <patches@lists.linux.dev>; Mon, 27 Nov 2023 17:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KSrg4SAJ"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-58cf894544cso2404153eaf.3
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 09:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701107895; x=1701712695; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gbVUsMmhBFYQhL3K5acsfFEdBlZV/KGoXmBwjmEvAxw=;
        b=KSrg4SAJtiM8G3E84zrlhUnkCkuUjODi0FZD2NLJBD7xAKBP4xKG2EOv3LXgNc0eR5
         aMfmq7fKOQgS9JkrfCe+yVMPioSdB437V4iVY/VboeKdgDNFktCwNIixfEGER+xljDt/
         3lA7sBgFTesXpoRaHiqO4kSDRaYC8O4/VhaYCpSOptnV9VXNQFjG/lR0aTZ7Tyq5UKJ0
         gNgWivL2ay9OTd3c0U/h14qnAMg3mO56pMqEHhKifpHzx0vyzK6m7f7ha+Gclx+Y/Cpe
         gQ14IiClY2uMU2rWKQdhstEMAjsrrrP6FEvHOkGKHoIuP6RYCzzkgpSACBAQ3e4V6BZH
         sl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701107895; x=1701712695;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gbVUsMmhBFYQhL3K5acsfFEdBlZV/KGoXmBwjmEvAxw=;
        b=GBMcmXpAetXHtloJdEauPF+AqlFIjMAJ7cH2Squ/jYCKBFtmh0hXRqE82tDw25sF4e
         Sakz+Xe/r9l03Te7JiEQ1bBAjTf79rWqi8ONrLw2nMRLtrlswVXqjZq6ZQYs7gO0qQE/
         au0ruEyjy2Majh2tFfxmMvIzijuQxoV8wyn2DmiAPwMWPcS0JLvyT5rX/DUk3o+f/OXi
         9aAdHN1NJsW/+IUjFJa4Uwm06ZUWhV+Zzd7vIz/CJNtvpoLla2gcovH9qjZPXC5rF05m
         v7Cji2ql/T/hacCbq7mW7A6JDsvdhXfe7y56ls2Mn2PEzp4EtVgY62zd9BqtnsvL1jy+
         7QUw==
X-Gm-Message-State: AOJu0YygawxciCKiySYe7dWLMoD5Y8YOlGiUlJhTwgB7Am8ctbMdGpt7
	lGfOlZ8mF/YWy4Z/r3dA5D69lDkj3Bn7pRJiTlU=
X-Google-Smtp-Source: AGHT+IEQvQcO5ygU+WPtLyMNZuQgwtHC6e4Zk9S9tzuV6H91tnxuiHnljv6ue6dwtR8xy5TU2B0P2NPhEvaXmHpGFRY=
X-Received: by 2002:a05:6358:52ca:b0:16d:fd6d:58b2 with SMTP id
 z10-20020a05635852ca00b0016dfd6d58b2mr10877692rwz.17.1701107895165; Mon, 27
 Nov 2023 09:58:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231126154418.032283745@linuxfoundation.org>
In-Reply-To: <20231126154418.032283745@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 27 Nov 2023 09:58:02 -0800
Message-ID: <CAOMdWSKKEQ05J5UYXj9oGUYfitkReFoS5rBKeDMXo0vUkd6L_Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/525] 6.6.3-rc4 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> This is the start of the stable review cycle for the 6.6.3 release.
> There are 525 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.3-rc4.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
