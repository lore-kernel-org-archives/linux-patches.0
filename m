Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110FF262A7
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 18:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XeXVo7wy"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5809d5fe7f7so913649a12.3
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 11:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696531211; x=1697136011; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5l5tCbT7AwXclsm4TT4kUF89MnMcwGKVudjWa61dhCI=;
        b=XeXVo7wyReY160id/omuGw5aQMME5HlTUa6Z8dp8TX2P2/GbST10OHLtV8MtzpN2g8
         j0EkmB9dqMLPePqDUL/v8kSWkZg97PK4Oq7X8K6Mt9TNu8joqpYAFj3KNTB8XWtUwnG/
         tHhyCyo+gypcPbniH5yLk7LzkLNVmYxhxMm6tnETbfmWNxCwYcd2oKQKIbB4Oc6+6EsZ
         wmx5OiTtgkZg5eENbvNdKlwe7xGaONfdS+z2pVHgc2sc7uaFwrEGZ9zQ/GabyC/S+rVD
         kuRLbY9fljkpvt5iJdyLShj83O5w//wIL/U30d4ieCP/N1/9yJah6R84Y+TXZ5wzblOd
         ra6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696531211; x=1697136011;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5l5tCbT7AwXclsm4TT4kUF89MnMcwGKVudjWa61dhCI=;
        b=ZSTjUGh2PhCitkhn2TyXI6RpnnTcI1SzxczZmUPJTasGs4fsrrQ9IRvfqzQ40y8JwZ
         X9PCjkk4x6yL5hDcD5kYuF21exlsSQ9O9nwCx951ha8nUxtWCz7n8nY4QJS0QT5JgCT8
         cTAlH9/cefG9Nv4pr7R9UPJeayw+HdqDeH80yRB+8ul+7swINnlVXA3KCwnYiu87yUjJ
         l2cfV2B9+0fvNhUfl1O7dGPeJDIaUvezHFCM0HQvyxswc1mg3uCRoQXaF2naWjfB2Jgg
         xSGwnPh0Q8XZJ0HKFFsLI0JSIFEEPecaHszV/5fCBMwuyK/Zty4gm7JvX5czXHQg6M57
         mvNg==
X-Gm-Message-State: AOJu0YxkE4nnfz+dRtrasedZTKeaCGNMrXvACNvUbuDSLy71PJ2y11SP
	KtEj03hjR51Jxz5DhvbU52bgKqB6zRJemdoVXk0=
X-Google-Smtp-Source: AGHT+IF/js+fEc1ftTbwYZS92jYAx564Bi6HrWVPF0MfbN0OYNLsdz98od/UVOOEVKKC8hh6iVNAcw7/egXCoYgdNB8=
X-Received: by 2002:a05:6a21:4981:b0:15a:592c:131a with SMTP id
 ax1-20020a056a21498100b0015a592c131amr5424851pzc.30.1696531211273; Thu, 05
 Oct 2023 11:40:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231004175217.404851126@linuxfoundation.org>
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Thu, 5 Oct 2023 11:40:00 -0700
Message-ID: <CAJq+SaATWw9L7JEV2CU+46xACCvqYwkGxoNB04YuMFJ7kOL01w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/259] 6.1.56-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.56 release.
> There are 259 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.56-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
