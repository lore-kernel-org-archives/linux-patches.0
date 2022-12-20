Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991591876
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 09:20:41 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id 21so8099780pfw.4
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 01:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u0kUVeZvZDV2Kx8BbblSmig5GTII1WAhwsA2y6hEzi8=;
        b=ZVTPWKsXd1fzOA2wA22mD9Rt4Ju6SJK/sY2lgW28dsjZToWoKY0HgpHD81zIQPgDbg
         ax946E9pCm3lteOui4VJgyAD5UsRNg4YJfNKatOL4oiWTY8sSZmMAwp2ybbmJtzHqe6p
         zGedDflXJctQU/CijWcQtCZXuLss78Z1h5gbc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u0kUVeZvZDV2Kx8BbblSmig5GTII1WAhwsA2y6hEzi8=;
        b=zn/hcjLppfq2zRNKpqFAKS0cFJXZpNEKiM+r06I+0G/O7DAXgDnPBbYcX9A8SvDWsh
         wbCfuW5T/sbucsDvZzs0hu/lZcddu9z3YAB/EwzcQir4atpOEOCZbKST9I/5nKec/ZQg
         kUi27wErXgeNTn8FT1QR9L8BydG96+96WQ8QcSuWSDH2rXShXsz/owkOx36JjsW/rpCp
         jnDJwN33pHpalabgjH4Ra2UCX3l4JTZZYal+qHMdZYYjf69zxKMGtj/WHCBc5pPBoTQG
         h1QpbVwMClyAM0hqr4SFQKpusiRT6NMxKp9xoL/HBsToHknOTP1RP1fxFL/8OeHzKcS8
         zNIg==
X-Gm-Message-State: ANoB5pkPLPTQdHs5KNV8bIqq89tcreHL77/MUVDGKI/H3vHh17WKPQiC
	xuM3KmOnkKWBttrF1npsp7CYyVqMaPsP870e91QPog==
X-Google-Smtp-Source: AA0mqf49lj61k6YHOJb6LKCtzVpzarpMBrdoGW0/AkN8gST9ofl9jS8iP7p5fDZuCz57F2wvnaJkcA==
X-Received: by 2002:aa7:8c04:0:b0:578:202d:a33e with SMTP id c4-20020aa78c04000000b00578202da33emr41586500pfd.20.1671528040886;
        Tue, 20 Dec 2022 01:20:40 -0800 (PST)
Received: from ec167f3768ca ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id d26-20020aa797ba000000b005745eb7eccasm8135211pfq.112.2022.12.20.01.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 01:20:40 -0800 (PST)
Date: Tue, 20 Dec 2022 09:20:33 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Message-ID: <20221220092032.GA955642@ec167f3768ca>
References: <20221219182943.395169070@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>

On Mon, Dec 19, 2022 at 08:22:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.1-rc1 tested.

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
