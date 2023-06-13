Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4C0522B
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 13:33:37 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-665a18f5643so1316275b3a.0
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 06:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1686663217; x=1689255217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GDuT6deuppaGzOF76rAk+CwnbEIhY/GKVuQjsq+mDj4=;
        b=QqRliXEzkC1F3k61fEliuQzfSPewrB4iwlZ1YvEDGqemk9ukbF+Ipn5NawCn3If6T7
         wFd36rOqA+TruOiBQEfe13L0q8W4QnJIAXby5sfXFeiuXHp2vHtxC+aCQsiUgzt+vbQH
         H99/eTgz/chIyZRw9/JAtTl7JkoC9lx+GlA+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686663217; x=1689255217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GDuT6deuppaGzOF76rAk+CwnbEIhY/GKVuQjsq+mDj4=;
        b=DM+JaEIiT38hfKRSB1NRr4hAHWmqWYU/n5NIIjPe5eP+4ajv4tYwAxqGR7oAOE0L9T
         wS+UC/8bQkv8Sm+HuYDxFDL6A3ytqZcXiGOvrouwIEPN9Pdndr5DHpQcFrR0pICtQwbH
         8PVEFAMYvgG/vLfzfa15HU5UQPemDX/u3aWdNNcud0NOF8xB2C/WUAH2WjaunXDcm5sx
         SlcfhMe3+um8sMyTprIL4kfKmkB3iSUHEPOsB0BVAaBDce8dJBGazdTZseMAPRqui6q7
         6W5/N7D5N3xYnE5cwMCi4bdGnUYdWuZLRla+NWpMUOaWQKRMxT60vOrhDI9tLM70i+2S
         Mayg==
X-Gm-Message-State: AC+VfDy9VFkRSw7uzfk5tAA7aR/JJX/os7WYORLEePhHNzGh6ifFe0Lb
	Se3r+XDlnh9K/+ExC5gQ8aSepw==
X-Google-Smtp-Source: ACHHUZ4/xdrivhTL1rQ3Gt1wk1T6Eqgqjsme0XE8IWTsyiB/3talV8VKGcBuYSmNi7D1QiDGsj0J7A==
X-Received: by 2002:a05:6a00:2d18:b0:646:6e40:b421 with SMTP id fa24-20020a056a002d1800b006466e40b421mr14852100pfb.1.1686663217099;
        Tue, 13 Jun 2023 06:33:37 -0700 (PDT)
Received: from a1e48afe476e ([122.199.31.3])
        by smtp.gmail.com with ESMTPSA id v9-20020aa78089000000b006475f831838sm2280004pff.30.2023.06.13.06.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 06:33:36 -0700 (PDT)
Date: Tue, 13 Jun 2023 13:33:28 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/160] 6.3.8-rc1 review
Message-ID: <ZIhwKHb2B+py2SIF@a1e48afe476e>
References: <20230612101715.129581706@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>

On Mon, Jun 12, 2023 at 12:25:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.8 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.3.8-rc1 tested.

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
