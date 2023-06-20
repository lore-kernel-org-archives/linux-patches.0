Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2BD2AB30
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 17:09:35 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-66872d4a141so1518254b3a.1
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 10:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687280975; x=1689872975;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AH7smoJDEjhySYAN4Nbmd7D2SdU9xURDtaEN4YhlvK0=;
        b=pEEjPthVqnfnzDbp4Ms0Up24Q86e3kzO8/fBMIQpAbcWIRMzWzqtNc5c+b/Ss8IBHn
         LINMBN8Npu0326qCj3pL9gXxwKfDtr7g2E3OUsGoKZSxhBnNjGLDyQFD+DJP0Kp5vYod
         H2gENSgYMI7HbLJ/fG8+ydnyGYXqABDDQWzAZ/OxiJwcH2+sKfEZ2147bkqLRA4Ig410
         pCdQw9m6qyuPMNY5e0R17xMJOXBsLPLWGipVrSVe1gwkYxo36RzTMM6p9yKoJ5eE3bQl
         6kRCmLU7LZr40dHjLRibbG+wdTPzGIRlNJqR+yEJjoV/+dFFIDQe2y3IDEebJdxORA/s
         1CWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687280975; x=1689872975;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AH7smoJDEjhySYAN4Nbmd7D2SdU9xURDtaEN4YhlvK0=;
        b=LnnHrItocqL30tFay0+kp0/qrMZvqsQLnVi0Ol0jTVfzCTIPhw/m8j2qqvUYbKZTrO
         D46LqiEocSO13w8zpfUGcbhUUkGW9MY1/8gxmt41MjpYJcgHW8uEtezugqFuWs7jZuZ8
         iaryhviM9KgMze1fwE/BmGmPq516xGVEs6VYyyRFFBtB2NKqNrT6ZegccXxGtsWlRzPt
         GzUuRzZ3SRekj+vL3TZ5rmG3mALiSD15Gssi0Ae/pBAwmV1pmaHrBa8zFHSYghSALMj0
         fvXm64a62VgGfOZRQVnnCAQA80ulHiQA209PQ6PU7i2pWoe7NJ+FsIxlnaUDMLHo0jzK
         GXBQ==
X-Gm-Message-State: AC+VfDxFgpkL7idtcTsCUCki0u97h/a91d+tpTtLTEqu/1M+twT7KyNq
	sGIJEvsQbM4N1J5FFxvGSs2wrDWS8c9x54M+BKY=
X-Google-Smtp-Source: ACHHUZ60J+gO05ipD3Cd1+0tv80Qk06PK0gZxHuqqIcxxrvVPfzNaZB287U9Ed8ccLMgYURRra0i9WoIau9LmacyMIQ=
X-Received: by 2002:a05:6a00:3a24:b0:668:83b7:fd02 with SMTP id
 fj36-20020a056a003a2400b0066883b7fd02mr4526808pfb.31.1687280975538; Tue, 20
 Jun 2023 10:09:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230619102157.579823843@linuxfoundation.org>
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 20 Jun 2023 10:09:24 -0700
Message-ID: <CAJq+SaD=z96VZh=ALnwUtKLZU5HobJxO9Zr4Rev9QbLUmdmw=w@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/187] 6.3.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.3.9 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
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
