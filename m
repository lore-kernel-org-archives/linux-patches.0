Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C8E10A32
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 08:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=heitbaum.com header.i=@heitbaum.com header.b="ZlvGZ4wM"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6cb4d366248so4383043b3a.0
        for <patches@lists.linux.dev>; Tue, 28 Nov 2023 00:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1701161677; x=1701766477; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3lEAT4IE+5TgDTGRd46y46TF/1k7v9CaLegPFey+I88=;
        b=ZlvGZ4wMYTgw4n/PBjpz1FyJC9m3CQUBSj9qP8PpeyJnMa9PkFdZvvObb37Dckuyaw
         +2M+ujiJhUg3ywh79awcaOXdaZVQFOJH7D0J1lCt0TF0dX/XxedThLvQO2huovR7fgMh
         p9q8kQyD4/d/sEnt3LJqGnNcx2+f3QpZWoxNY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701161677; x=1701766477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3lEAT4IE+5TgDTGRd46y46TF/1k7v9CaLegPFey+I88=;
        b=NzOtXUaLoirPP3UaTkFWslRISKHxUS7RE4iFMOmg/s320HX7arL94ifamKmJwNk8XJ
         tCiS4eXDHiNawjwwz4aV47CVYVfgA4Jf2kO4U1o8gj0dA4USPuUQQfUfwudKHPvvYNRS
         tCneLtJ8qvmoOLloExVDrBeXjvnwEmz6QrsjRcPTE5VarVN4zqN61igpbKK4ar/zTwTL
         RGFSPcqyR+oZbB0+ny6fTTnFejLwczb+K6VQYh2TI2A/n/a2F+A4PTr4nczuNujGTBGy
         3cQz9zo9ypAnDNN0oWL29++84B/OhJf7kwInzXglstc/l8kwzvKck0GG2PKdg/hOVhm5
         PQZA==
X-Gm-Message-State: AOJu0Yx2YAYGhxSqkV3lfO1FzAZ2vgl170Km69HDfDqLkRTOG43Y/ei7
	wUOH8Id802+8FCO0f3gb59qgOA==
X-Google-Smtp-Source: AGHT+IF/gklNETPClvaFFsJJAdl1ueNFy4xOPR3Sk46cb9O3ud98cElsa/5CMYbsEFz1SuE1IoxsJw==
X-Received: by 2002:a05:6a00:f8a:b0:690:d620:7801 with SMTP id ct10-20020a056a000f8a00b00690d6207801mr13935663pfb.11.1701161677532;
        Tue, 28 Nov 2023 00:54:37 -0800 (PST)
Received: from 179c313f1339 ([122.199.31.3])
        by smtp.gmail.com with ESMTPSA id p24-20020aa78618000000b006926e3dc2besm8331807pfn.108.2023.11.28.00.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 00:54:37 -0800 (PST)
Date: Tue, 28 Nov 2023 08:54:27 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/525] 6.6.3-rc4 review
Message-ID: <ZWWqw7BVP5NfY/k1@179c313f1339>
References: <20231126154418.032283745@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231126154418.032283745@linuxfoundation.org>

On Sun, Nov 26, 2023 at 03:46:18PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.3 release.
> There are 525 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.6.3-rc4 tested.

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
