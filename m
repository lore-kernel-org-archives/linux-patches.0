Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954FCD30D
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 17:36:59 +0000 (UTC)
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6b46e61638eso5589107a34.0
        for <patches@lists.linux.dev>; Wed, 28 Jun 2023 10:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687973818; x=1690565818;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4nyR4pSQ1cteEH5hMJQ2lOpFk/1iVCMplDzpJI/rgU=;
        b=HybE2rOXJeX6a7CJ3taZARLGZRRck4BEmCG+kDi3YXvLZOKUe5uot0NEyl/MeWNeeW
         +QLyNO+1/jfnCZNLx0sMuEAlFwKPmEO7aEyA+rWkRxyAUJYhK1omBC9V0jWzQ1WhhhBQ
         XR4avZgKQAAVYHwa9rAQoMHzd0jpAxmvST1iWpxr7seRaE0PuCcAdl5d40f+QUzPFmJj
         XVOacFs3Yui7ogpDa2Y1h1yQ197nCl8g2vnvgTq4QxCqwLBIa+0ignDc5G/GW8qt6D2/
         JK8WeVdo5occXkAu0Ud9BrDfGYXZHIL0YwOGbcxa2exL/+qexqcq+p6yEEeP9Px5nLVW
         X9YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687973818; x=1690565818;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z4nyR4pSQ1cteEH5hMJQ2lOpFk/1iVCMplDzpJI/rgU=;
        b=P9YdkxpZExTeAsBSVfqAyEO8YQ36Maz5zLWDe91WBIUTeUfsghpnyr1BCwFjrJlxZ6
         /2wwfF/fXKK3uUmnJJfGZpGcxgLNruLSmsbN4Kpoj/IDmSelFTVQhC9Hv7Pb/y/WYX3E
         BCrPYqGy7rdPGexOkhIFQiXhY+nZcgaVxJwyjo5or/R/ERhGBkgwX7gAOWTbcDuMniIn
         KHfQLsBg67AVlW7dJ9segFT4qo10jdqO6FbXwQpJCVosHhTdmRTAqUoHKAd40cxOlf7J
         sEMvDq4utkbwhnBCTT/UkMA6qjn04RUwRYF4Q+43rtHocSw+AhzKzs9urrDSnuouP6No
         qAAg==
X-Gm-Message-State: AC+VfDwzAdAMKeF+kmBt8F4Y5x2bT5KIfz91fjuiJloaUNqkpa2xfYmy
	FFYvSWpNPVFMQvK0IvR9Ex3zLpLmPLUCT//fLzk=
X-Google-Smtp-Source: ACHHUZ40l7rmNzki0dFjuYCz9aKuE4ayaRBINwCHQepH9gXpXMG1yQ2RY979sUBcI0v20KKd55sfoWty+P/YvIq57GU=
X-Received: by 2002:a05:6830:2089:b0:6b8:6a83:2b17 with SMTP id
 y9-20020a056830208900b006b86a832b17mr5354604otq.33.1687973818470; Wed, 28 Jun
 2023 10:36:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230626180800.476539630@linuxfoundation.org>
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 28 Jun 2023 10:36:47 -0700
Message-ID: <CAJq+SaAjMMsaVmFar8ON2UZmH0qEt=ffCxeJzij-9X8zOsw0fA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/170] 6.1.36-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> This is the start of the stable review cycle for the 6.1.36 release.
> There are 170 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.36-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
