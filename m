Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79A217FE0
	for <patches@lists.linux.dev>; Tue,  9 May 2023 17:03:42 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-643846c006fso6501505b3a.0
        for <patches@lists.linux.dev>; Tue, 09 May 2023 10:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683651822; x=1686243822;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aQVqoDuYiadvLKIDWNHU9bvAIHfwA741Xo32NGJHuhA=;
        b=HronIf/B3jRa3EQ7+UrJchlxryWkOmAVtFa6NQDDU5aO/EXIC9Db5Dz6Vk16j1lN2e
         u/2yi/lV5GvIezLePpSS/io+oo9FCSE/jfwuUhtXVV0WyKq+9acSXtak+9CvqTxgXMCy
         jDlXm7vlSUE4lx2pYpuxJW9tFYrTPI4oe5v+vzGCkQsi9zktitU3U0RUzWHUwWDxou9C
         8wVDX0E6n797bqCdVasPPmpDKqw92YliMEbY7ojO8cwigOYTbKhgnGD+kI698Riw3CXF
         6ob1fX+polBN5tsDqmTNejdmTXw5XveWH6S29cRJxexmpcd31E/cxM/sZGD5kDV8ICd8
         rulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683651822; x=1686243822;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aQVqoDuYiadvLKIDWNHU9bvAIHfwA741Xo32NGJHuhA=;
        b=f1w6Z5+c52vWSAmAnFtMJwBoYckZSkOujbUKTqbYe8iQdW2NGO1L8FBGnjVKn0CEkO
         UK53NX1DIvTGgq44vfzuYjgvLjJrDbYR9I+Ltp1cXl3MpeXhv/rqmsPSNOjwhZqosa8s
         7zalRfWdImr3Z3CSbeXUyUIAlC4uo1HgDtfVGMa51Km6/qZGIvGk7tuLepZJLFbB4nt0
         NkxU8yju1sR+L8q2Es5kCe9QXNN21E9ngQz7VbM1EvovXb+vwmfg7bEDueztp2JNJiGX
         mBPrEL48DqUd6JvoY5s8d7uxjFdX2HqYGb2MHXaP7v/aCK57z291UG4W7CJOqOuOZ91M
         1L1w==
X-Gm-Message-State: AC+VfDxRZWnJf4RwqNqRmzv5YFnPq17f61bhJmPE/Clu35ca46lFNFfz
	+WpW3fTWjlar6e+juFo7yqx2X9H6kN+sJCLgIPmlg+g5r6g=
X-Google-Smtp-Source: ACHHUZ7dxAWTjtm7E9vWztOYHrkAC3+lQLKpXAWrh894XjXoT0DY0kVTIYcd5lbLibLbGAfpZrnSjgo/rGj+eKJN4Bo=
X-Received: by 2002:a05:6a20:6a04:b0:ff:6979:ebc0 with SMTP id
 p4-20020a056a206a0400b000ff6979ebc0mr15733360pzk.50.1683651822281; Tue, 09
 May 2023 10:03:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230509030611.521807993@linuxfoundation.org>
In-Reply-To: <20230509030611.521807993@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 9 May 2023 10:03:31 -0700
Message-ID: <CAJq+SaC9ctdNzvupkZJTFpTy-Gx2Sgkn5r=r9+R2SHmR1MziEw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/370] 5.15.111-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.111 release.
> There are 370 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.111-rc2.gz
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
