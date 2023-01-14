Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A22801
	for <patches@lists.linux.dev>; Sat, 14 Jan 2023 05:01:06 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id y1so25410514plb.2
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 21:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C2OSXYnC3zftc6tOPQXjqTUoejZtZCYM5c1c4T9f3yA=;
        b=VXWrIfXUEs/qTjTjKnS8WGQxNqNX/fkxw7Th7cEOIgFOx/oZoT+PCWc6AfS2YnRyGw
         tmbhS1Mv6WY64p/uL77TAG27IWndr+SIFmG/oqPbPsf1kYajSw3wCE51LNnZdRKk5oH2
         dSiYDFfgbbVIrtL+pVMBZlqst+YnsOfO7kw9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C2OSXYnC3zftc6tOPQXjqTUoejZtZCYM5c1c4T9f3yA=;
        b=lNkaCa82JwLrY0mgR7k/I9nmK4viP/tJgJwqauGr64rynGXIkWAcpzyUfrkP2/GZIe
         8NRO5/wLSZCRIr1UbqmaOpIssAvU+YlWNFKuf+T7p7wDFqob4hF+WgS5W7HfpHr+Jd92
         Nx/RPJxsnCS39BSY5p04NmMpx4mL1STjHAtn56qX9eHAhMR3Dj+HoqkZCcT48Vd7C8dV
         5uzwQ6Mw5l10d5D6/mapxRq5V7sAhuFbJdTqJdvHIApuSZN5xNmGGfeMnNHL9GM+of2i
         sxyf0ywjDfahAmANXYfdnJwMI9us1WTrb5rf0LIvAeL0SBqsGAmyt0PUSIAe9KTaLJHL
         qEWQ==
X-Gm-Message-State: AFqh2kowrTxBGTn9W0qwqNoVq/hSvudAnNxn4gZNg4QdMYToUj5TWwry
	l8GEnYEKFo7M900m5BKHBGkfSQ==
X-Google-Smtp-Source: AMrXdXtWJqgtoq448Tog8QHKKjiKBE4fBFzXtC6778zE2gWCq/RuwVX377z/tNfEcL6XpAu4auwZIw==
X-Received: by 2002:a17:903:3245:b0:186:95c9:ddc9 with SMTP id ji5-20020a170903324500b0018695c9ddc9mr12378008plb.55.1673672466092;
        Fri, 13 Jan 2023 21:01:06 -0800 (PST)
Received: from 7ef5778799b4 (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id z15-20020a170903018f00b00189f2fdc178sm15039833plg.177.2023.01.13.21.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 21:01:04 -0800 (PST)
Date: Sat, 14 Jan 2023 05:00:56 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
Message-ID: <20230114050056.GA9347@7ef5778799b4>
References: <20230112135326.981869724@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>

On Thu, Jan 12, 2023 at 02:56:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.6-rc1 tested.

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
