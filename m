Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7EFA21
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 07:42:27 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id q9so8324021pgq.5
        for <patches@lists.linux.dev>; Sun, 22 Jan 2023 23:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IptttD0zrwJVBHp5bq7+qjBs5ITPKtnNpW0l4jsQDD8=;
        b=Y/Y3FQZLk+38WgNCmQ2OEds8uRmKp8aAxAXLlryFng7Rd1c0zkOatiPk9MVWHg1BSj
         hIdSrzm7kOd4b7Zhy/dL1Wow5ZGv8JYLa6ixF/PUcbb89KtIPMW5d7tsvUkW7g8JnCLU
         hzi2Ot7NA4GUrDD41EutU3IfEywqwovLxNahs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IptttD0zrwJVBHp5bq7+qjBs5ITPKtnNpW0l4jsQDD8=;
        b=tSyfnPU33KM0gHB/YXpKz/8Ay3kGUzl0Rdlm1ufmbeFVblvu8YrkxJMxCTUxG94qsw
         Wz2twDBgNZU208HrwlDWWklUI+L7hyieFcBMMAVnhtltMB4oniu2b0fvBQSTl56kSoJm
         pGjyxVsq0mQ/rb0eZONdlQ1x4RNXBJNxQBxxiGuA1K/2LRkOyf2LXxJHrwQUut7oZbRU
         4V1cx2wkTJEa75dnlJyYRzdAPRZ8PL+tHCmS0TDrM3nqIPwMaEGcoXgnJlnabamxbwcI
         gLj3RK0GIkPnFsyfU+REOSULsSwAO1oz6bfmGmlPl7W7QLtyGUmYCnISuUW+wEuju8nR
         OKGw==
X-Gm-Message-State: AFqh2koHSGq52uSZALWgxx8lpi6DEP5FOoeObe2HibyxVMRRepco2C4T
	lwaGrlDWIr8J9D3d5Wva3wi4mg==
X-Google-Smtp-Source: AMrXdXs/81TXfWznGLnO9cWhRlZliwMffE/3OQvySFgG0JWO27eatGQvjwmpdBdxcRxyDX+HKcQTOg==
X-Received: by 2002:a62:1488:0:b0:586:b33c:be2 with SMTP id 130-20020a621488000000b00586b33c0be2mr25117581pfu.26.1674459746487;
        Sun, 22 Jan 2023 23:42:26 -0800 (PST)
Received: from 939e86c225aa (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id a10-20020a62bd0a000000b0058837da69edsm397042pff.128.2023.01.22.23.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 23:42:25 -0800 (PST)
Date: Mon, 23 Jan 2023 07:42:18 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
Message-ID: <20230123074218.GA219043@939e86c225aa>
References: <20230122150246.321043584@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>

On Sun, Jan 22, 2023 at 04:02:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,

6.1.8-rc1 tested.

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
