Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF2C1FC2
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 08:40:35 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id b17so25303665pld.7
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 00:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AST8wGQKJArsqYW0kCGPhdVZT3sTkTmujS4WjL+NxjI=;
        b=NgpjJG/PXpBxQj62UCoL4HVIcqRe2KNPmjaQBsKSBPDKMCyRJT7uRiJM0uhkPPyvgT
         +OxRJk/Uczyh4GdZA4gdx9N5hv46pSwLdLXV4r0soC8kyD/TWDnugUWdrgdjhBLUi3Zq
         4RrJvg+Iaw7r2Rt3aKf2zTs+22fZLsaV304H8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AST8wGQKJArsqYW0kCGPhdVZT3sTkTmujS4WjL+NxjI=;
        b=6l/dV4JD3HfZFA6RLnDrGZzi9t38IaUOdtR0Wld0WE23RqmvlBAd+IjraUWWqvVi/9
         V1gqgVkLwWY1NoVuEbaaesSiEYIUfr8rI6zflLahP5okY7tYUMgZ1APE9Pj5RzJmOOI3
         5G0VFntaooyU3svfMrFOnozenbSqE7WigoT2HMYI/rPuT5NykRY0NGCkyiwDSIDlr3Jm
         dKWZslFWIRWDMWZKwckgIwgNXMQwVoa/HHRXMNYhdMrsUDAlhzangihNpNKNBzrT2Lhx
         gFGz6+abAN8XbjDuMQYG9NKJs753AK0hz153IUaPZduoIerXH9pZXKIl60Niavp72HFw
         0/VQ==
X-Gm-Message-State: AFqh2krwFeXA+gwYZMdcFXzdMBZaWczxNRmXVxNMvDIsnYccOV0dfiDu
	y7r9xWRlGXZiHfF5SSJTPuGuYQ==
X-Google-Smtp-Source: AMrXdXuPpQNF/nPCZyv4sWaHWIsXo4q/4J5nG2Vi04UxUG6u+WPIGskqjdNLXMuFW2uCNIbn10Gl3A==
X-Received: by 2002:a17:90a:cb84:b0:229:7110:712d with SMTP id a4-20020a17090acb8400b002297110712dmr2303896pju.45.1673944835035;
        Tue, 17 Jan 2023 00:40:35 -0800 (PST)
Received: from 80aa54ac8722 (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id fy11-20020a17090b020b00b00219cf5c3829sm248105pjb.57.2023.01.17.00.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 00:40:34 -0800 (PST)
Date: Tue, 17 Jan 2023 08:40:26 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Message-ID: <20230117084026.GA10@80aa54ac8722>
References: <20230116154803.321528435@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>

On Mon, Jan 16, 2023 at 04:48:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.7-rc1 tested.

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
