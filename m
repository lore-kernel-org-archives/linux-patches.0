Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDE2185F
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 10:32:56 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id b29so13699880pfp.13
        for <patches@lists.linux.dev>; Tue, 15 Nov 2022 02:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n6bwOxePFh46NaBMZODMDlWticrcCSmbJ4eG9oo6U4I=;
        b=aJLqEIUnLoEcqEpLJVeyLDSI4JWya9I6xfkg+ypjcC6c5uFWQRGrJXG/h8qnz/fzn5
         Jzs2FgEgorPHrC3aZgS5jQ78pKZ1cCLRrDS5D0SUUN26zOBpLJTMEGUPECoFgywkAJAU
         /pMcFh4gMmi34RnkLgcBsknOLsLXoU+L3BqTc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n6bwOxePFh46NaBMZODMDlWticrcCSmbJ4eG9oo6U4I=;
        b=08Q9iV6K0M6EgQ1CgAg4LgnJtbpLGKeYw40BGVFKxl/pqnBCIIdXqqFZ+mtw5ilM7J
         Z32widNcI1gkY2DyVdyxi/m910G04P+/BOxFJ+88dtlWxRfUSWXbgUVxQ+dkljP0SwDv
         5UF15lIwYs0F7kc+1u5uOE5lbl7woc3+m20dlC6wvbZ63iPOEZ43tdsi3wbY6C1NBN1Q
         JRMPmqdGmiL4TKsRkzvkbtcrAAsgO2LobEAwbeL9czWYVRJseLGgay4sfQX51tIlP7eA
         MapqzADO8FZsaU2YdCxR5NOW4nUVyW/+iu9ceGIFbvB0rxnTsVlmkPxDYFf6No+Um3BV
         uQeQ==
X-Gm-Message-State: ANoB5pkFkvq5245HYaPBIbM1Jzd3mUkbQeinPVgJK0RVZuyudcerSU5c
	KpW5huHDvlNt3RBY0clUm3Ssnw==
X-Google-Smtp-Source: AA0mqf6c7cKl4JNJ3YsXWMTQrXcVKdJmUcemuX343NMnE30n7czJ0JHIaY+k8DYxqkh+sEjUJkf/4Q==
X-Received: by 2002:a05:6a00:e14:b0:56c:db44:7b1f with SMTP id bq20-20020a056a000e1400b0056cdb447b1fmr17938099pfb.54.1668508375545;
        Tue, 15 Nov 2022 02:32:55 -0800 (PST)
Received: from d5d3ab63aed3 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id z12-20020a170903018c00b0016cf3f124e1sm9429839plg.234.2022.11.15.02.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 02:32:54 -0800 (PST)
Date: Tue, 15 Nov 2022 10:32:47 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
Message-ID: <20221115103247.GA258@d5d3ab63aed3>
References: <20221114124458.806324402@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>

On Mon, Nov 14, 2022 at 01:43:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.0.9-rc1 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)
- SolidRun Cubox-i Dual/Quad - NXP iMX6 (Cubox-i4Pro)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
