Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38546FC3
	for <patches@lists.linux.dev>; Thu,  3 Nov 2022 12:47:20 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id g62so1471717pfb.10
        for <patches@lists.linux.dev>; Thu, 03 Nov 2022 05:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ai1/5dAzhZlS88IHHgtwtwwh76LpHQeFyO2vtqtpFhI=;
        b=icYgRKfbIswfs6glHbUqckB1v3qAjwvkr6ejII+z+SAaK6aTVUIEWTcnrWKr+Xhyw/
         7go231JI+G9UCcBWpjmHofKcf4eBX/Xcu+R8pbWVxgUhSD9so9MNI6Udf7v8DQSOMGY7
         c4Etx9y17vyHKbIJ1aHuU4XBO9pPEEYlD3b0k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ai1/5dAzhZlS88IHHgtwtwwh76LpHQeFyO2vtqtpFhI=;
        b=r/jEsTQl7k8on6Wdf+jhsbItKyc5A9Czu+37p0+LWMeRQWAG9qnes9OyK4jGG24+aS
         NBfLhNhdzV61ioC7hYrcX/7HP2j7qRjL2b4i+pXXPkvfMDyEQCqnc15V66XM23SgCpBt
         U1I+4u0bP6/uxaVAhVrnTBci69CRv18t8qSmOs9NgKTyEGiZVGLnAxZfm308wMzNP45l
         KXWnjFHwPM0sMLjXYoWL/J0XVQEArzxWJUYNC1brT9U/w/pVrC8OLSwIGfjmgOSCW2Qh
         FJFyzuBjrC0TcPRXnL5z9ostdkZ6BSsN6H6ynFu5+5qgWTklxQ5PzmcXg/CNe3fVSl4B
         hgAQ==
X-Gm-Message-State: ACrzQf1txzG2bK/juGWVg2vF1YIegXb5yd5v+sZMCbOI0oCRbNCiiMc2
	8jO3ETI2Q4nyyt3FUR8v02p7jQ==
X-Google-Smtp-Source: AMsMyM7UNsWm2qcVJhow2AVVmu5cO8//EYQikcoYCSKnbx5YUyXTzHK95pxhrZw+H9G0JwH39w8Tqg==
X-Received: by 2002:a05:6a02:113:b0:43f:3554:ff9c with SMTP id bg19-20020a056a02011300b0043f3554ff9cmr26645532pgb.578.1667479639891;
        Thu, 03 Nov 2022 05:47:19 -0700 (PDT)
Received: from 3532bd7d3047 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id h13-20020a63210d000000b00434760ee36asm722541pgh.16.2022.11.03.05.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 05:47:18 -0700 (PDT)
Date: Thu, 3 Nov 2022 12:47:10 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
Message-ID: <20221103124710.GA9686@3532bd7d3047>
References: <20221102022111.398283374@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>

On Wed, Nov 02, 2022 at 03:29:35AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.7 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.0.7-rc1 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos5422

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
