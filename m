Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0DB10E5
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 02:21:58 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso14451380pjb.3
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 19:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679365318;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wk7k/qCAEMpFxh6ljdNclCqPNBMbolmdQlBNy8zLG6c=;
        b=b1MSLsahswHQ/R2ruWXyq261SamPgeFglyhnW66D2sIrLNRx0SFsX2VXITmRYCB6CK
         fehaT1Sk5io6kbOcCAYGe2hREFU03baYDHSh2xbF20lhO36WlTb+uSykO6VpHg2RvkVn
         wXpDivVKoVSLiYqu/w1mYxJAluWFnzUd9Nwxd2AXQJjpxxurB3/X+fMG/8ciSgOMcLHb
         8eIR51rNeI+e+iOW9ez/PS7iLRc6f9SGJRd31JzU8Jb5oOT/CYKm82d5R1qClNgfAD43
         8uOf8uMEoHFSTCKKBNRPCIMDKMRnHKxSfc5CE5yqB4tT1QPeq4swNoMiFJ1bilaFgTjd
         dg5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679365318;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wk7k/qCAEMpFxh6ljdNclCqPNBMbolmdQlBNy8zLG6c=;
        b=4oKdYiEBiM8RUt0WGG+s4e//2nOzSAbe1xyPA3q/dD2FIHBXeecG442Rhf1hmRHU5d
         GoU4Y1J/fOqIDvdUfce+eHdoHcK1U1gjVCOo1HnfR25G+Dnk3BAWTLDRSH8YHxqr4ZDC
         /DKhVG3uKgWa4eJVhsAfyWhiy0Cbd/TV11JcwS7m6v9kujgYu1WCIR+Fl0OuH+0Mf+7X
         2soeQFbYyv4jpVnKzZyVVc4DC5/V+jNGQrl0mW2xrscyHK9f717ZydwW6Q48uv+01k0p
         kke7fVkFUbsydVXNg2VTpUKm8T+G+j5X1xIqrZWrtex8D0FtoX7jBdEG27aA2f+tWTiz
         BRaQ==
X-Gm-Message-State: AO0yUKViR1XLlrQKp4eFlM2YSxY4Q9r135F3fcEiyKWM4Bw0RM+saLXq
	EDypcWkaK4qU08fOFHMKCU3GtZKyTW+lycaTpNU=
X-Google-Smtp-Source: AK7set/6yamH3SwJz12TWGOrpA7X6sERswa68dKqJacheL9RN5DQS5iOTenIxqkTYSJIWjI0P/gz4qQ3xJOrBW1iYHU=
X-Received: by 2002:a17:90a:29c5:b0:23d:2f4:af49 with SMTP id
 h63-20020a17090a29c500b0023d02f4af49mr200529pjd.4.1679365318063; Mon, 20 Mar
 2023 19:21:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230320145449.336983711@linuxfoundation.org>
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Mon, 20 Mar 2023 19:21:46 -0700
Message-ID: <CAJq+SaDtjHaEHH0Yo38ygEmXfnTTDEtuVd0bLF49E2W2UGc6oQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/115] 5.15.104-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.104 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Mar 2023 14:54:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.104-rc1.gz
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
