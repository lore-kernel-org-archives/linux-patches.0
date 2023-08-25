Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9982CA9
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 15:40:04 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-26d60f27491so655058a91.1
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 08:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692978003; x=1693582803;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YIv5AfNee+1ahX6EDRzSKbY1j9QGGz1vV6vHz5xp9OA=;
        b=UF6nE3V2KmNNvnrImpgihEdjrx543d36tiASAtwDGHI3CMtKa3KQiEbqHK0Cw4F08/
         faj1ezU0UUKD8ZQth9WHx6J9UGNXpkDXxRacatjqD0vFPT04g4goK/9pS+OPRgb+IYuM
         ZWGqXjFH9o7/00JZ5VRKkfhCO3MrnoZ8ezVn0RviZSVYURPfGA6hYnb62cDksMa0azvF
         gEuXxPp11KCwVbH6gM94p9ooTdJ4AhXcPotNxxiZNDQ0pIamJtEFCVGJAR8Zg9811O7y
         NLtpl5nyBDs7BcAwtLk3BNXDFDRT2aKwYoma05cTELpVvDX5OctFLwTYRhrdrx9ZabR4
         eDdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692978003; x=1693582803;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YIv5AfNee+1ahX6EDRzSKbY1j9QGGz1vV6vHz5xp9OA=;
        b=KfZ6AEDkpa/jIolAwRDOi/IPHQ5lsI55UqPW9lBG25hrE4yHp0RsePAr0skHNJw2tf
         k//yd5wGWlm6l+deKa0K4jLT15sJsfrKi0nDR/yz+hJbF50my9BcmHREAXAv8fc4W+ET
         DYO9IDHJ/KdAjSt4xn8OTG7+zrYdfiQeleZ51O3DsCh5pef1SRd1P5J5vwOL8eUER+hd
         r1DgNyLbQOmMdguQhzbc0hecnFqzFQvGFg8tPNdCa+svqaMzwrwMI2YI7ahkeA48i95P
         /WN5yfO0bjmvc66ko0cpVZnsvqBysXmK5RMYUWGAI0oe4GmaesCNqOWPMlrcgKH/sJVE
         q7Gw==
X-Gm-Message-State: AOJu0YzFDuPW6hPJ7ix//Z5o5m2Cp8F3xD8NoxGAukVCAtDBjaeA8kJs
	aSsnmMx+KCIzPOdw9HZT9ic=
X-Google-Smtp-Source: AGHT+IE7rtTxs6Fqu1KJZIStxt4EUK7nepiEjIDUJgTf7bSmwpnDmwRijYF5IKd+Ic9hEgxle9WF7g==
X-Received: by 2002:a17:90a:df07:b0:268:fb85:3b2 with SMTP id gp7-20020a17090adf0700b00268fb8503b2mr15033161pjb.7.1692978003454;
        Fri, 25 Aug 2023 08:40:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ft7-20020a17090b0f8700b0026b45fb4443sm3704829pjb.4.2023.08.25.08.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 08:40:03 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 25 Aug 2023 08:40:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/15] 6.1.48-rc1 review
Message-ID: <0ee210a6-60ee-4db0-9445-e94f6ec80c6e@roeck-us.net>
References: <20230824141447.155846739@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824141447.155846739@linuxfoundation.org>

On Thu, Aug 24, 2023 at 04:14:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.48 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 26 Aug 2023 14:14:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 156 fail: 1
Failed builds:
	m68k:sun3_defconfig
Qemu test results:
	total: 521 pass: 519 fail: 2
Failed tests:
	arm:fuji-bmc:aspeed_g5_defconfig:notests:mem1G:mtd128,0,8,1:net,nic:aspeed-bmc-facebook-fuji:f2fs
	arm:bletchley-bmc,fmc-model=mt25qu02g,spi-model=mt25qu02g:aspeed_g5_defconfig:notests:mem1G:mtd256:net,nic:aspeed-bmc-facebook-bletchley:f2fs

The usual f2fs crashes, and m68k:sun3_defconfig still fails
to build with "Inconsistent kallsyms data".

Guenter
