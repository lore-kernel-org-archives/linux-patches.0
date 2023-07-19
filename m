Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CEF17D2
	for <patches@lists.linux.dev>; Wed, 19 Jul 2023 04:58:57 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3476d0b5295so29525315ab.1
        for <patches@lists.linux.dev>; Tue, 18 Jul 2023 21:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1689742736; x=1692334736;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xx/nlFjtu4ARcPKwXdYmnkb99UM/dQKiVgI7KMRPIGM=;
        b=VQaYGcC5+WLtUiJAamvCvUXI9h0WDtf6H6gPpm7L4TXt2YDHaPeg7SDQCxXAQbapnG
         5OWlkvmOlZISqLIn2WmroOJdMHvOPMrIQhrfqqySiwNhqzeHV9t6UE1DcUx6Afyx4uLw
         nsDXqp5hLQXwosWTWmykXon17uRtDXf5Mt0UM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689742736; x=1692334736;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xx/nlFjtu4ARcPKwXdYmnkb99UM/dQKiVgI7KMRPIGM=;
        b=EOIDDr+ZyBWXof64lkt97kz7yg4VroLcQ8WdjJQdNsWbZhm3SPujkpfQi4Xo4XexkQ
         JoSSIb7URMOJiG2xhptf6ziqxbPeXKWkFCqerul7+HSDvoxLZkN+CkyMQ2k2kW+Qcgzm
         nGMwckmH98OSwvL9//JyUrzDNFXnClmcwbxnWbI/SUv6Pgcc5/uQI72Ehvet8L1Q/80N
         S3TEvAHnP0j1j+a2/a2QkXrY93jyBr15jrwu7LBavcSR6xwmvOkejeu6A0993La5g50U
         goufcQFjuy1o5n8VmSsbHxlRFyZeAcW+hpa0gg+dpCNFXbGxI5bKQXOjbsJz7VklxEMy
         WAuQ==
X-Gm-Message-State: ABy/qLaR2tB+IH7TW2oieA5k2kuYvV+rAqm8IlffX5cCf2IB3nex7T3E
	4WZouURjbBao2fPlVU3mUUazjw==
X-Google-Smtp-Source: APBJJlH2mIKMnmpMa5BwTtRfkel54/muJVaPz4sXZLak232jtyoBEh3mzEjcxLrSHDpjK6NTMIfmJw==
X-Received: by 2002:a05:6e02:219b:b0:346:7741:3ea9 with SMTP id j27-20020a056e02219b00b0034677413ea9mr5170367ila.3.1689742736583;
        Tue, 18 Jul 2023 21:58:56 -0700 (PDT)
Received: from a443afd6f3a9 ([122.199.31.3])
        by smtp.gmail.com with ESMTPSA id e21-20020a170902d39500b001b9dfa8d884sm2759468pld.226.2023.07.18.21.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 21:58:55 -0700 (PDT)
Date: Wed, 19 Jul 2023 04:58:48 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.4 000/801] 6.4.4-rc3 review
Message-ID: <ZLdtiMeTL7ZSD7nW@a443afd6f3a9>
References: <20230717201608.814406187@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230717201608.814406187@linuxfoundation.org>

On Mon, Jul 17, 2023 at 10:34:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.4 release.
> There are 801 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Jul 2023 20:14:44 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.4.4-rc3 tested.

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
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
