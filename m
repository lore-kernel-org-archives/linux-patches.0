Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422FB3C37
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 14:27:14 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id r7-20020a17090b050700b002404be7920aso35659882pjz.5
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 07:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1680704833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n5Q02pfG+OMk1kh4JZ7k9vPqYbgDWeWrEDJEsiquIG4=;
        b=OKG4h15dRFM8loga0ZloBGZgnF3LHC7oXhkOBfSthdmOI1EvekxAnPab3OhpRM4ip7
         oYkUFKrGyJ9t91H2ZZgyogELlpEPRaxyzj4dgYhEHQtku9+aw/+4mGBSuyILq75Helph
         jIBLEzMI4bl5eJG5iSZmAim2Il85wh5bnxi8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680704833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n5Q02pfG+OMk1kh4JZ7k9vPqYbgDWeWrEDJEsiquIG4=;
        b=Lq2T7a5iQ5DNjqs9dLMSqsts/UisAb07ci0tMhA0D+ryTDGIXsd9nXN0VKEHsTZ8L9
         8QtODGSCbGzw8wkLoJQ4qlAtG50KUSdfoWPenWeDVbje6Zud0+ScF8UNJL+1QmCikDrS
         Hoq9bDJuNyJGhGNonq9YogIqGxMTOmN/MECK9U/bWxiNDr3Y7RTlBlJ3mfE9KeOBGUZH
         SA7pDxjGRVbawYFxhbr52WcWTEYOsE8oFxcExL34ZM0fwbIHHo3TL2kDwSH4iGW3zxpz
         cX9ZxYSKytZPd7ciewI9UOhlNS4paL5JzfmxTbQug5QJmMeQ75S0tA9eLDZgyUkGJ5GO
         WTqA==
X-Gm-Message-State: AAQBX9c2zEWEAnuwkkkCScWXrJxrwoFuy5k9hlli4cuf67nMWAPtcbHp
	gc6LMzShvsB2XSE9X7rqrAVt2A==
X-Google-Smtp-Source: AKy350bdTWZsUp46cZZT7/E0Gnd1Xdy0heFNW1jSTFgn0+eJMFdjYMnZCiPf6VmMUxVQNMG5RAZeDg==
X-Received: by 2002:a17:902:db10:b0:1a2:8924:224a with SMTP id m16-20020a170902db1000b001a28924224amr7755865plx.25.1680704833368;
        Wed, 05 Apr 2023 07:27:13 -0700 (PDT)
Received: from 90aff2bdd59e (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id j11-20020a17090276cb00b0019e5fc3c7e6sm10224782plt.101.2023.04.05.07.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 07:27:12 -0700 (PDT)
Date: Wed, 5 Apr 2023 14:27:05 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
Message-ID: <20230405142705.GA8@90aff2bdd59e>
References: <20230405100302.540890806@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>

On Wed, Apr 05, 2023 at 12:03:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Apr 2023 10:02:26 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.23-rc3 tested.

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
