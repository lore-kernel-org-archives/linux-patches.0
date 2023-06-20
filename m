Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0D92AB32
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 17:07:45 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-66615629689so4303493b3a.2
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 10:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687280865; x=1689872865;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h08iZ67gSYZQc3WCT8YBnzAa6Qcv3ozAhy/u+AkpJl8=;
        b=aOLxKrRJZ6WW14Ax0HKLHn54/1c6uWdrXdefvepkOK0xoz/JTrZDBbRljmHSwTLSBw
         zHGlywKoPM4SIxVbSGGJNbtl8G/OvreLfwNNuuFZ1q0fbnuk/gyQ6TiSu1bFtfb1IeKL
         yYEE3D6b/2yb6l9AlISZ+4YntQG5Bk8AMLEVSp91zxbm+HS6P5skRZafpbGZ+Pbveqh0
         VGF4dU7Vv5qQJYWBEVRytlCMKHXc8C8Q8S2w3d5gKXt3UqBS6rEXCWmoBqj8o5bsN/vO
         muW+/PN0+yVsHf7ilvlX/SFIOA4NscamDAGyxw5hvGpbypXYAl7S4NIzm5IrbHrfevBZ
         8iQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687280865; x=1689872865;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h08iZ67gSYZQc3WCT8YBnzAa6Qcv3ozAhy/u+AkpJl8=;
        b=OfRTzfECdE69A2c5VK/2h79GzUDugTetVXswKOccogRopgBk0QfMOOX3Q9lH1sj4oT
         WOHUhZ5I2f/ol2jpJLuDooWdo79iCVYEjKNXa3KQdOPKSBxENtvU5+kVpaJk8QlVkVtG
         OMAPc9hMMVQWtTAAz/UnnS85/k7G1fHhT+dKjaA7vmAntv2m/de/TaO2SMZFgwyUQrYx
         v/mv/6qOaf3FVJY7uIgNws7GsR7XoaPgD5IyZb0omCc0Q3y/t/9Sa2iL7bHpv9S/RDHF
         3lLfmPhx0ii5Bcp3YsUzBWTHM3fEPhO8hbmAN02+hlWhtUikEpeBVyGzw43hXvw88Sh1
         jvrw==
X-Gm-Message-State: AC+VfDzdKOO/d7i6eC9HCsbjb4cZus0DDjwwG0gyeUmA4FTwMv8H5I/q
	qupP3Xyje+TlYIL5a/iqDxT6Cyvfj98sd0d7k9M=
X-Google-Smtp-Source: ACHHUZ7PXhFpQVAdDnBMoRfKtjpDycGr/zZFDAHuCis0e436e5+1iHqYJokh1WnOt8pTNcrTQkBWJoGQ7jWS48B4zHY=
X-Received: by 2002:a05:6a00:3984:b0:658:f86f:b18e with SMTP id
 fi4-20020a056a00398400b00658f86fb18emr16174784pfb.22.1687280865287; Tue, 20
 Jun 2023 10:07:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230619102141.541044823@linuxfoundation.org>
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 20 Jun 2023 10:07:34 -0700
Message-ID: <CAJq+SaAHfmy=mhXBeo5zWQGTY8Sf_5Puhhr5BKs-mRCDP0WVFA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/107] 5.15.118-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.118 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.118-rc1.gz
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
