Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0AC18C01
	for <patches@lists.linux.dev>; Tue,  9 May 2023 19:59:06 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-643ac91c51fso3601520b3a.1
        for <patches@lists.linux.dev>; Tue, 09 May 2023 12:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683662346; x=1686254346;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+qFLfy/RaoHobJwJIwlBPxnMu6peJ2rAXISdMhNVcn8=;
        b=bwJ4F5Mi7rgxj74IL2eWTgEHDb5ITjsRwmhmoIsr5y3/PaHdtyBOo2aJM+7LelOLMG
         Si1SlqfuZrzdkpRSCia/ir2gcwAcwBUeA1KB2alc3KS6LFnxgegAPeD1jV9ppAjzZRYy
         zbDVcEq/tnltqCyAH3QTyqVKxAF0ztfOtpoeQEJhacQzjfD6AQfUEEtRQGsxcfbbJmXS
         zwqg7kPhwsbrLEeq8lV3Rr/xHFPDgkWQh3JcVuuy925539uKYhN01XXgXIVaFIX2wjsI
         +PqCt8gxbyKzj4PrlRSmbj8GhTz1HUv7rgTUimRIzurTuTGAFfyOygg9TQYwrTYat3ro
         8k2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683662346; x=1686254346;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+qFLfy/RaoHobJwJIwlBPxnMu6peJ2rAXISdMhNVcn8=;
        b=BEtMrCfN2sURMHih+5kh1BbdztI8fKVsbEDNniUMNkxp6OcvJvHo21Z7t9YtCLgmRC
         mP86AF32X6jXAwcVr76amyEWbOM3pkga+eft+F/xgspvLZa6956lwxTOCV4fOWyj1Cf2
         nbzIWs/T6dqKqBWZq6v+IPtO9yxUCfcTcFYRTo28NqxPHcwi2xnadF4YGFCVYF+lq7q0
         aC00dIStkxdvEVzGyNMWCK3WCdYN5OdrL/dapMnnZ/UBWBXi5EWCHL9KOWwB5ZYNt7qO
         0wrX6erqjdULj4PKINlQ2qyOeuVQwzmi+zTyYBvS6ZK3Gh2k/KvJe3qB2LzkBin6SalL
         m4kg==
X-Gm-Message-State: AC+VfDxywXypbLsBt3vdPU6usFBw2Ob8sFPGfbLQrZUfU7d5SnwwXsq3
	/9IgnhvmF+PAWUo6FOck4jc=
X-Google-Smtp-Source: ACHHUZ6ud33kVJrJ3TG6+Sx5LPatnQ9P/Hv9S8gNX1O1rpCqT1BJCT/wbMzfMfyviwl8IMuYhNQiSQ==
X-Received: by 2002:a05:6a20:72a0:b0:101:8ff9:58c5 with SMTP id o32-20020a056a2072a000b001018ff958c5mr2536706pzk.27.1683662346204;
        Tue, 09 May 2023 12:59:06 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x12-20020a62fb0c000000b0063f172b1c47sm2164563pfm.35.2023.05.09.12.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 12:59:05 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 9 May 2023 12:59:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/662] 6.2.15-rc2 review
Message-ID: <4adbfa4a-33fc-4caf-a58a-a27a8e296f13@roeck-us.net>
References: <20230509030701.507375024@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509030701.507375024@linuxfoundation.org>

On Tue, May 09, 2023 at 05:27:04AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.15 release.
> There are 662 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
