Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8FE321E
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 21:31:00 +0000 (UTC)
Received: by mail-oi1-f182.google.com with SMTP id c129so3115728oia.0
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 13:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=becLM1VwH5z0CNZX94TYWkxV4SssS0v5+RD3px/6fNY=;
        b=WCOotyPLbeUPmiZLBjD9mfoq1zTocAD5kd4iCgh8d8QivIMwzLPbtRJqZQz/Ol6oyp
         EA70nQoqO7yML2HPiOkMR14L+zU5eHdNJISwa2EwvwIuZcu/ckHCnLqYpsqlamjCgY1Z
         xUydGVybLhnr4TTzWmwBTBH//j8TJ7+pEK3SCoJb6H2sUueigOtgQeMv66A64HSgwRQ5
         HMNQFmfpdGD2J3/dYzsShzqqGxYgjAbaFTKEwkBKIGAFNczLbEZdbg4ebB1unJ832+FU
         0rcufNBmq/tkTR4zURw+70i4TVcEYLHQ95CtsJZrftlFCozI9vC77Ym8Gw4Zuzq6M5RJ
         fYTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=becLM1VwH5z0CNZX94TYWkxV4SssS0v5+RD3px/6fNY=;
        b=EacLj0w/x0DoxUqJCIiRLSWEzUry6dR61dAMXp6o7rmUtfXOea4cw2FHtzfLwR7K9v
         Uf/glEMDL5+rc5BJes65pTymcVJaBnyTAID8alm1t91BuZs0xKuuMcgvOdHqYGR2ylxf
         KPAz/pGjpuGStFXGOlXG8HALdH5ooepjurNsIEux94F+oMDxpUR/d9CHci4e/Tw1Fa8W
         2pOgf68rj9f1uTnzuL6z1+FwuVOeLXf2hEkmcrihhAxDind1578cPIIq8ag1mcH8s52B
         jzLLDM2+iU/5WeOv35IWCQJmZVGQ/lQawPrBZ9A6gfhSN9WLv/vOC37bdk9mRwc5l8V2
         6gQw==
X-Gm-Message-State: ANoB5pkFQgEU7/9FsILSjYVdX4ZrGnpaF3P5pmp5nieIAWi1snMcm2ZW
	SjewE5o7mdFYL0jUdqNQshY=
X-Google-Smtp-Source: AA0mqf7An314fgilxpsLdgTLmcvipSCdSAYqlDaZJHiM/gQFWYzewJSRz2gvuh5H736YhqzF2eJc7Q==
X-Received: by 2002:a05:6808:2101:b0:35e:80f2:65cd with SMTP id r1-20020a056808210100b0035e80f265cdmr13560619oiw.35.1671226259677;
        Fri, 16 Dec 2022 13:30:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x8-20020a05680801c800b0035e7c48d08esm1234034oic.15.2022.12.16.13.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 13:30:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 16 Dec 2022 13:30:58 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/14] 5.15.84-rc1 review
Message-ID: <20221216213058.GC4067594@roeck-us.net>
References: <20221215172906.338769943@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>

On Thu, Dec 15, 2022 at 07:10:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.84 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
