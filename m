Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD159476
	for <patches@lists.linux.dev>; Wed,  8 Feb 2023 12:43:19 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id pj3so18279882pjb.1
        for <patches@lists.linux.dev>; Wed, 08 Feb 2023 04:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O+Wh65jPwZ2iDPb66Pml9WSpf/i3Bn1WviFQSAOELT4=;
        b=Y4ur5YRYEXujDSJhVCJwpIz3CAjiott1io5LCS3/AwwJrwlLDCu1FoLhxV6bWlsOun
         512JfBadYS/fMg0nXIHuc35yHLVGH3tDdeJJQ/IA+ExP2h5VK1RpsP9vS2vXpOH8jFvM
         +7uhedfGNQJNWgFGWaVZW8C+fdCRUHa1sJsXM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O+Wh65jPwZ2iDPb66Pml9WSpf/i3Bn1WviFQSAOELT4=;
        b=xmi0q1mLNIVdVTWxUodz/MNI9ryoohXeEdd0OJP/9MvBBkM1UxtEJcGxsdGmqU/s3l
         a4N6619jBrlTPzS8XyIO4HXHvcx2RzAOawz15KAlw+UNSBLgy3rSNCokpqj0XW0QXcBC
         GFbHIlt23palwUEA1nvSVKrgyGAmH6B328Wem7AHso8rCdbcLYQysHiSZBIzAYZZtmId
         +ciS9nTrrNRoYjdya7xr7kHCQIbpY9C7BZssPYnfOOzykOGUBOGbKT9oZAC6M3QnS/3k
         jda5xK+kSeEvh9Ni9hJOKh2Abpsh8pEx0CozexqXeLchP8FirbW9aNyTpLUTO4+iGhoE
         CkbQ==
X-Gm-Message-State: AO0yUKUtEM2SZ3r8oCypCjkLbJwJaX5ur2V7UqUSgsQCYUxX4u5u/Sb/
	gdfzXxCbKADnkh0yOCeOmHDokw==
X-Google-Smtp-Source: AK7set+QT0GP0bBUPF4ShuI0zGxWoOq0+tBWzazN3oEPqceoWb4lucXU/DFyNSI8XvZmcpxMp+xpww==
X-Received: by 2002:a17:902:e809:b0:198:e4bd:86b6 with SMTP id u9-20020a170902e80900b00198e4bd86b6mr8504271plg.67.1675860198807;
        Wed, 08 Feb 2023 04:43:18 -0800 (PST)
Received: from c5da58673b58 (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902c1c400b00186a2dd3ffdsm10873478plc.15.2023.02.08.04.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 04:43:17 -0800 (PST)
Date: Wed, 8 Feb 2023 12:43:10 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
Message-ID: <20230208124310.GA1940401@c5da58673b58>
References: <20230207125634.292109991@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>

On Tue, Feb 07, 2023 at 01:54:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.11-rc1 tested.

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
