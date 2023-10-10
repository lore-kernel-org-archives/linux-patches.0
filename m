Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7DF24C6A
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 15:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQgLrR3T"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso4609238a12.1
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 08:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696950564; x=1697555364; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nTeWqq3jl5FawKSID+DoaxkM3CPNpkRkh0wkQJ5fbxQ=;
        b=PQgLrR3TgJb8AXsFJ018vsn0ShgwBWR3xlewwWgE5Ivy9EZsrAzHNK2NAP3YyDHM84
         H46saM+rdfeUs61N0xCxcERwKaiaEnNlk0HlmlBYCZP1rMxr/zz1MFLgg1tdiy5OEtbk
         4nmLs1kl7dGuXxiEN4JOD52MYerb56Z9NnqCGvppqcofxaItz5rddErj6iIICFhQNZSt
         mcIShZfddoobdQvSrSgMCyeaY43atkBoujeq4p/hybU+lb38QVK6efkUQf5ZwX18Mkox
         9l1oH7eO7i+aJXOX7fKaIPYDVKiXQYS2iszxOIRibagWXzeS2zdg2Nmmx2Gdw1czH8bB
         rfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696950564; x=1697555364;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nTeWqq3jl5FawKSID+DoaxkM3CPNpkRkh0wkQJ5fbxQ=;
        b=pGXbJNSZc4ZAkaJkL7wNyfM9lKrGj2sifm0DRp0F82Vw1ZA1ThovAzAlmbBQaw2/1x
         A3c2Whe2ZK0B+zUcHxlJRMqc9m+4/Q1TFj5pfHxm62Y8XnQy9eQxw/LnfhNR2NTFPEzU
         xWASI7pDDb28MehzjqthYeQg3G9K+jv6wINOF0r00J9Vzp5MprnG+Lskw6wG/S20IW5D
         vITLwRV2N3/jcmqSn7aPR8CHyYNtSj/Mw/6nioCw5mxdKsbDhMILX4L5HGxYAdKcSpM/
         qo7GkFGM3t1zIkhoi7okvxMZXMZKQDHAsHM2tKpY99Txm7PX30YkaHf5vRTMIXwahqR3
         uE3Q==
X-Gm-Message-State: AOJu0Yzh2SgsQOEamzq/mrmtYQ/zLvI8WEC+1q2UrlTP/77b+JodhM3v
	rziK4vash58mSKyUEXCn1my61JnbOzz6djFz8wM=
X-Google-Smtp-Source: AGHT+IGE13Cewo15WURJDAdpU6z7zKzguK8r1Mul1KQJyl7+6HWzaEz12tNtzPvJgUFZ0LHCG6ha4GSTGyT7Retw6Pk=
X-Received: by 2002:a17:90b:8d8:b0:268:13c4:b800 with SMTP id
 ds24-20020a17090b08d800b0026813c4b800mr16999401pjb.21.1696950564066; Tue, 10
 Oct 2023 08:09:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009130111.200710898@linuxfoundation.org>
In-Reply-To: <20231009130111.200710898@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 10 Oct 2023 08:09:12 -0700
Message-ID: <CAJq+SaC8gksd5o9HazMcL2vNJeRnLmnE1wDX-Mr47Tf5A=ChWQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/75] 5.15.135-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.135 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.135-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
