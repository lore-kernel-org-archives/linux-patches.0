Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8BC15A5
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 00:37:19 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-24756a12ba0so403075a91.1
        for <patches@lists.linux.dev>; Fri, 28 Apr 2023 17:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1682728639; x=1685320639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fFTwTFgfpbct6eGfmZUAE1l/8Y7e2QTTmTdpZloJxgo=;
        b=a9Y2JI73PE0/P2LphZdQuIeX21T/zbMqgnk2hcKSsUKr0UWhzGDQsRWE5sP21tP0fp
         pdLw9xV19z6QsMKa1MaM50RaUDRnddhma8LqtdO1DP2KuC02QxiPNpio8OHOfyesBELS
         hOSoYjgSvzIhzSxX39IWrMZ5RmWwuw8s8Z8mQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682728639; x=1685320639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fFTwTFgfpbct6eGfmZUAE1l/8Y7e2QTTmTdpZloJxgo=;
        b=TJ8kGtbw8CFZvfj9RiGNj5LZf+E7C59Cw3kXc91YTg2Vv975QeRTZWjYc8doIEzT/y
         KflGJ5QCOT5eHrVAoGHQGwG8KWQcbXt+0ym4r4dNPwvOozGAgGvRybbhcDRM4nxSCBQD
         DCh1+5NTFAxGkMCBwUVbuuc3+9bAXEcG44ag2lwabYhXS1KwVDYRoicKFdV2DH0NPjHK
         wlXlyUe2vsQxZKomSDDh3ADb/x6SwflTOqcK69sOgS+U7gnY/UUXs4O3ctWVfZRvCdjG
         FNI/AYWOrGL2VuWjyVaX4vuxSikIpjjdN4tnfoHI7dEI8Lt8J+RQN5QC2x4CzRf3APWd
         NxVQ==
X-Gm-Message-State: AC+VfDyn1pZzRDHa4uCJk4UATvnRTR3sOeuljBbPuTpaZrufVsbHefmG
	X1GqvfELoqPOJBL5ezvI8PgsyQ==
X-Google-Smtp-Source: ACHHUZ7AaM7lFfHo5Pv4E1GlexT7X9j78VcNfpQ5SFUaPuV9zpadCcSjk/1t1Qd6XuNwQg8u8VP4/w==
X-Received: by 2002:a17:90b:30c5:b0:24d:d8d2:ec90 with SMTP id hi5-20020a17090b30c500b0024dd8d2ec90mr158295pjb.8.1682728638520;
        Fri, 28 Apr 2023 17:37:18 -0700 (PDT)
Received: from 7fe0d01b56a2 ([122.199.31.200])
        by smtp.gmail.com with ESMTPSA id np9-20020a17090b4c4900b002367325203fsm15400876pjb.50.2023.04.28.17.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 17:37:17 -0700 (PDT)
Date: Sat, 29 Apr 2023 00:37:10 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 00/11] 6.3.1-rc1 review
Message-ID: <20230429003710.GA4461@7fe0d01b56a2>
References: <20230428112039.886496777@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428112039.886496777@linuxfoundation.org>

On Fri, Apr 28, 2023 at 01:27:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.1 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Apr 2023 11:20:30 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.3.1-rc1 tested.

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
