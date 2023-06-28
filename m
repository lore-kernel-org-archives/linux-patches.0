Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DD3D30D
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 17:38:24 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-262ea2ff59dso2249699a91.0
        for <patches@lists.linux.dev>; Wed, 28 Jun 2023 10:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687973904; x=1690565904;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7FWhZzUWQQi1tn9CDiAjHRiSjyYdxBIHiisyfcuALnk=;
        b=MKU6TYNb60d5i/7SVDVRLeUfRY5xkQfoHN3je9GGJ1kLgOONhg1vwK7rV9PQ0Pho6R
         t/UQGvtaeA/2EZEw4H1Q7V9QaacpkK0MsRQY0v1OvzkFiqO5qX5qBM5Bw/R3te6sixRi
         gSdvRGemqrZsHn0U0ABxRljOWfQlUSQAYFwLmiJdbxGpkmXFvIuYNQBEP8fndg637+lC
         zyfvnQfhabeg2XkJfZtIFsIe9f7i16YqTq5SuOIjtIY0W80uNvxSYwQmV9QiCovOAXFQ
         +xI48j4WoS5LRpWQFyKSg4TSxCEuxFPL5K3d7EiYSKmyJRDAlrWwYOYbJz0R0tjPXkGC
         waYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687973904; x=1690565904;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7FWhZzUWQQi1tn9CDiAjHRiSjyYdxBIHiisyfcuALnk=;
        b=KIwQSDqOfweGIAMN3FsAtS4hBnYsTxwYO7skPdJVZP8SLsaZkblMJr21Hs8zbK1Xmk
         xYPjt/1JnXx0iAMy1kHv2UkcL+If12jkvLodD4a8HRjO7dNA+LGRmI8Wuru0qWUiw21H
         b0afTfeq63wxU3lK2KmBQR8wU00Gmr2es0Lb1tkLNYUjLSoWukuveud66duOt9jIP/lM
         ufBCJn5xB1Ry3LcSD4zqeVZYWXcvpbg4Twll0ptnCf48myeb2j+/d7m2jmsnHbRpgy4o
         iWk3YifC3BWQjGrFWTzfeHyFTvSEcmb+k0Pm5Y8D+QGzyWrKNTVlmF3fX7HSlwzmY4e0
         Ab8Q==
X-Gm-Message-State: AC+VfDxYRBwrAkp7JAjsL0ra8ZUgYWiapEuAp2Afw/ve59ok64/y1Yji
	XObk0kLEN9zqvgALZhtvADb55R42JqXM52fZHhI=
X-Google-Smtp-Source: ACHHUZ7Ii0hg3v5HpVTrlbUORVopAMTBarNCka+bvhg4JYVWBIFPPqUC7edhH74J7EdiRMFllvEdSJkNNm6CqmOnhls=
X-Received: by 2002:a17:90a:359:b0:262:b22b:8ab5 with SMTP id
 25-20020a17090a035900b00262b22b8ab5mr10233703pjf.17.1687973903727; Wed, 28
 Jun 2023 10:38:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230626180805.643662628@linuxfoundation.org>
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 28 Jun 2023 10:38:12 -0700
Message-ID: <CAJq+SaDkKp7p59WQjHkRNYxaqOkZMy0TMMvXCx1to5vC9zmTUg@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/199] 6.3.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.3.10 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.10-rc1.gz
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
