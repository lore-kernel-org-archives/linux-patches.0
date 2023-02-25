Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A6A17E8
	for <patches@lists.linux.dev>; Sat, 25 Feb 2023 05:14:42 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id z10so759705pgr.8
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 21:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X7+3E0JQU0FxnGZ5BiSmvm8Hsg7HD/6qbOk5w5ZRHjM=;
        b=bp8w2aAldxm/p/OyqulRx8jUytLCNBv+0zrDx+48+YYCEIEgvcekPK+EOvzaMhXmdm
         K2tIHohT8IF4hLdjyQ+6otPmdFxt/27jK3erFllZEVRwRrVX+F1NosY9FFIS8MLx4JtI
         km+YcszsNlpD2cG9tCM8K3x6oreYS0/P/qUz8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X7+3E0JQU0FxnGZ5BiSmvm8Hsg7HD/6qbOk5w5ZRHjM=;
        b=gU7J4emyOqK+GA1lMmbmyvNcD6oTis20SEriB5ZkJbv8DgMaYLmUnV0F2lHh2+2xfh
         Vt0JxVFGVJPgFqFn625HvauiIO9byi07R/fPVArVFXxNHJl/R0cGkSkSJDoDO5MB2zfT
         p/UnwbCqCUEXKyW6rUBWjBqK/cWSDR2KEzZ7pnSTavqpssFnQQ7DkwRoMMe6gCfjDSyE
         l1TARgxcTRSiyZSUBzDm38m6VjzsGh01N9RX+4p6+wg5F7m/UdGK3gzWk7dnnrr6KD73
         fVCYOFcTfQgjH9SBYl/b2nfqecFWBsFXwk5WYjjB+kTRnXKczHtrP3coi8XtlHM6v+g0
         i0AQ==
X-Gm-Message-State: AO0yUKWOf5c92P7Lp5OX9XjjI3ya3IrjD4WtYo7REyRjsCzDrHAmbv2x
	4ORsOHrDpceCx8KEy05d0nJ6Mg==
X-Google-Smtp-Source: AK7set8C3FnBa3BGaJvZ19hytTcjHR88q+nZp1elea7y2fP70VuzavEATg6qUnTZ4FAD1YUGwalOCw==
X-Received: by 2002:a62:184f:0:b0:5a8:b705:4dd3 with SMTP id 76-20020a62184f000000b005a8b7054dd3mr16642468pfy.13.1677302081607;
        Fri, 24 Feb 2023 21:14:41 -0800 (PST)
Received: from 5d49c37e6aa9 (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id c1-20020aa78801000000b005d866d184b5sm404294pfo.46.2023.02.24.21.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 21:14:40 -0800 (PST)
Date: Sat, 25 Feb 2023 05:14:32 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
Message-ID: <20230225051432.GA704396@5d49c37e6aa9>
References: <20230223141545.280864003@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>

On Thu, Feb 23, 2023 at 03:16:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.14-rc2 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
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
