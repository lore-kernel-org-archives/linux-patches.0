Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2751C3E
	for <patches@lists.linux.dev>; Fri, 30 Dec 2022 05:35:49 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id y19so1873567plb.2
        for <patches@lists.linux.dev>; Thu, 29 Dec 2022 21:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ODk49GpDxZuuliFxoD6df4iLQLl2k/kbKceWdXGuHE=;
        b=eaaEYESO/KNWKpsKq0KRFNppqNRawyOutNV+7UhIfKLShVE9poRySfAeYp3/CWxVfL
         QPUAP7o19bYO2NQKwf7vC7ULJXFKEGDOXNR5+1T3eZt8wwOT8x8YGp3+TiU3go4BimAF
         smnqPp1wLHCYuLSMChqnRTN+/hCwtoFKt24PE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ODk49GpDxZuuliFxoD6df4iLQLl2k/kbKceWdXGuHE=;
        b=jsPxdQuvTIidZkeJZJdg/NK/IDwpRHjGmy9ttTdEDclLRcs1cCPW/KHgZO+GEDw6qr
         YG4Orw6dmkS2ysHNLoAJjuRmsvOfWwUmEI7Oz5qABBRd21pvRvfuI5psaO4QbyTF0vbj
         nsbSfKGID41Ld9vQToFiFN8ila+mBvBX+SqxLhzJqbv7hj5x3ePMrMKB83RhUV+5UNkr
         9lg7we5cV1hPzlv5JlL9OXUFyekRcqHbqGvJCODgdnpCQ1yF8zHulgd6AQB6MoD9yKDF
         s5pNJsyBMFmOpedUXAiPHL9USQTV3VSNSkOXPIhKQOTTComEUpA0h/fdatGx3wwFXIw9
         HTYg==
X-Gm-Message-State: AFqh2kpzxCKI4fghEgxGzXR6XBR5+/kXGKsngSjfLaCtNZ8n0qeiBBzs
	KgW7Q4Kb9gavMpvOMN6sMeT+DQ==
X-Google-Smtp-Source: AMrXdXvHxYrkb6oA/LY+xgb7wVy1uGetD21x1eEnvFN0CTBJ7y3zBy2MqFZV3qLpI4w4Wy3d8fFG+g==
X-Received: by 2002:a05:6a20:7da3:b0:ad:d982:4538 with SMTP id v35-20020a056a207da300b000add9824538mr48131281pzj.55.1672378548717;
        Thu, 29 Dec 2022 21:35:48 -0800 (PST)
Received: from 9137d54f73fc (lma3293270.lnk.telstra.net. [60.231.90.117])
        by smtp.gmail.com with ESMTPSA id v12-20020a655c4c000000b00478e7f87f3bsm11691781pgr.67.2022.12.29.21.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 21:35:48 -0800 (PST)
Date: Fri, 30 Dec 2022 05:35:30 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Message-ID: <20221230053530.GA9348@9137d54f73fc>
References: <20221228144330.180012208@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>

On Wed, Dec 28, 2022 at 03:25:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,

6.1.2-rc1 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)
- Tanix TX6 - Allwinner H6

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
