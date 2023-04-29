Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F8B17E9
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 04:09:37 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-51b6d0b9430so371086a12.2
        for <patches@lists.linux.dev>; Fri, 28 Apr 2023 21:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682741376; x=1685333376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V0Con/Jz4tEvXZScEVRW69KuDDaq5x6EC4u6W1T1IEY=;
        b=WyzCGY7X/28Ot6DYMF4UB5zL2i1s09pWqHdlc1FCcA2SMUPR/viRshhCdP5xFbA6f0
         4bT2lqE6gfa4uwDA53VNyTEmuCpvT3+pbRkPk6KkJ5JydYBxP7stwsj0td3rmMWbSBhU
         30hNAk+Bp6smAiE2YA4Zjh2LjXgSGZ6j718LzAssch17/fvA3XDLwyFvp1d38wSrA4kK
         ZFISB+1k2XKzVs56XeF8mBc1sgh2Irm2l5M3wJZV4MVUMsXcnflu6HEEH9v2NeGMvlAU
         IKguyXWI2eM52qQaN1CI5uc7uDlremOAOqyjuEy8nZSOclLaoo+8LD1nWjWeqc9Y6Ilu
         UMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682741376; x=1685333376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V0Con/Jz4tEvXZScEVRW69KuDDaq5x6EC4u6W1T1IEY=;
        b=S7U+UnalBlMU8I1/2fnr5KiThbBCcSXa7LSwmOgUpR10ZvY5rUJcWYeWT8IzirZNWi
         uVIEleX0Ir1RntD1k/miSG+VGW+jdm8CxqF2slfynoXYv7KQNJWSDncRfJqwKUlgXpx9
         CVe3szfgwMIVkc+uWeULLAFWpOh3JZqmpyOpU18d3Wano9ktYD040Qs6m253q6FXDEGP
         4nAR0QPiQpWVKRaxSui1IBFU3JFFgb9Y/Hz0WHP9zuyWzqhrsIz8mPlDvjbsQGjYYHGF
         zTeh8dRoy5aJ35s+BxLib3ObBegkLmTjGJkh60QOSRCL5TCNChUwEtopi/YLB7/nEqMk
         LKgw==
X-Gm-Message-State: AC+VfDyLbe6Dx1Ey3YTtyMJs3ef8RVp2MKYmGqwkmmmpPfDd7esVRDGr
	s7UR1eXXZYUH+ou05IVnOwU=
X-Google-Smtp-Source: ACHHUZ724HPW0hI44McbZGG01VFq9tlTf7PzQIJa+01j4EnH4FItTAYi8Vg/L3EcoaVHPrfFvW1xSg==
X-Received: by 2002:a17:902:d505:b0:1a9:9c5d:9fac with SMTP id b5-20020a170902d50500b001a99c5d9facmr9322324plg.33.1682741376375;
        Fri, 28 Apr 2023 21:09:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p19-20020a170902a41300b001a95928e9a5sm11058023plq.121.2023.04.28.21.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 21:09:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 28 Apr 2023 21:09:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/13] 5.15.110-rc1 review
Message-ID: <3c5a4b87-14eb-4d39-8f00-fe2793de3216@roeck-us.net>
References: <20230428112039.133978540@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428112039.133978540@linuxfoundation.org>

On Fri, Apr 28, 2023 at 01:28:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.110 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Apr 2023 11:20:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
