Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE363D6A
	for <patches@lists.linux.dev>; Tue,  9 May 2023 08:07:07 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6439b410679so3378681b3a.0
        for <patches@lists.linux.dev>; Tue, 09 May 2023 01:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1683619627; x=1686211627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f4cw59kPp6A8r0eMeccn+YgGUjrNQrYf3COqrBqWzs0=;
        b=iPcDFbd1lygQ4F1Bu7qfUjBBUUcYBUdy99AVsmAlYCaYknGCUjhMKTTb6PZdvuQ2MX
         zgYx8Fn9O0L2wIhejJ4bSuNtC83Z3iCQpu8sk8Ihw7saNEfeNaO5lYlua/ZPIA3gKmk3
         wSrnuT6pA8yinGPw0duk8IUjv/DwdM3883ynM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683619627; x=1686211627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f4cw59kPp6A8r0eMeccn+YgGUjrNQrYf3COqrBqWzs0=;
        b=fHnhiruUe7ofuALNP14oUhzBxYV4HAeqRM+vVJAP048HUmPGmeUJMxgBN3SOLERPWW
         PpWvYFbE7cBN3A8XxlLI2S/qjt6CEicZkkIvCi8BityqJdw7By05ke17KIt4tJv7wWcL
         tv+dA4fr9lW1U2JtyzFTUZMgb2DUY625MFm1Xubb73Om1q+yZZCMWnnXdkkMhWHtVpeV
         i424lePOPdaUIoNWq9hC3e5wnMM9LWss7+S5WqtgFoxAfoq8PyPZG0P1AFE0eoEF7G45
         Y+akPSuMxMZQUCvTcnUV84fAUG2r6TE11LNgP5Ke+a6A1iAEccIYOBHDVSjWgLzSbzg/
         RkkA==
X-Gm-Message-State: AC+VfDz2c2slH1m2YaQtPMfcvGmQ+66/hKXMH1en+CfCmmcclwMmzixM
	voJrfCdjnap6lJhblRroY2lWkQ==
X-Google-Smtp-Source: ACHHUZ5mtkoo5NjkUfi/hBEfAL0GATyBF6WKT+ImyGPyuyHfKi6mBlfFBGUBQQLAyoZHVqKrByc9iA==
X-Received: by 2002:a05:6a00:14d0:b0:63d:2f13:1f3 with SMTP id w16-20020a056a0014d000b0063d2f1301f3mr17321113pfu.33.1683619626805;
        Tue, 09 May 2023 01:07:06 -0700 (PDT)
Received: from d6921c044a31 ([122.199.31.200])
        by smtp.gmail.com with ESMTPSA id j11-20020a62e90b000000b00571cdbd0771sm1165640pfh.102.2023.05.09.01.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 01:07:06 -0700 (PDT)
Date: Tue, 9 May 2023 08:06:58 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc2 review
Message-ID: <20230509080658.GA152864@d6921c044a31>
References: <20230509030705.399628514@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509030705.399628514@linuxfoundation.org>

On Tue, May 09, 2023 at 05:26:44AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.2 release.
> There are 694 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.3.2-rc2 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
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
