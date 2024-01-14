Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266892C1BF
	for <patches@lists.linux.dev>; Sun, 14 Jan 2024 23:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="mr9Rkc7M"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6db79e11596so294821b3a.0
        for <patches@lists.linux.dev>; Sun, 14 Jan 2024 15:15:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705274137; x=1705878937;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QGViPHtjJMlurFPTzBSSPEkkat6LUsMaxd6YuoP9bZE=;
        b=Eolzi9d8ODF6cFr7liYeLQh2BoWtQ6vkQadFTCBvweLKq4CVX3u5vgPZF+mO70N/R4
         9TshjAqeNCfCw8Oj2BKRDrXebNsTfWrNlfBvNar1cHWpi/ICzXaSiFVcuRvAnjWmNkyY
         ZZCJIaUWXf7+3A24jurd7tM8PQKZSyBJD8jrxzhBO7Lzxt+cH+/sspZ5/yLj1bI+xQsj
         q3kPXHeOCD9wbbuGGT+p5HiMujjoCCCiVhbfLLVV2LESCZgctZXdPlUxqWBMLiCl887m
         XzW9RiToYZgEXrJjmDm5lhIVh0hyjVUr2moEBQptT+5XTOw5M3/IClNSNW/QkEfyPhx0
         ezsw==
X-Gm-Message-State: AOJu0YyoV4UOdH//yurizbNpYwYJC3PG0muoLL6CPlHBLUAzy65BLBKR
	2LB9weGDi2UAHzMkMs0haP0=
X-Google-Smtp-Source: AGHT+IGX6Pz3j6wT5XGBdGkNsTcNQay3wFitLsf0ZTkMu21EsbWQmrDkQcFXNxS/GAzmihrtd2gFnQ==
X-Received: by 2002:a05:6a00:4b0d:b0:6d9:bf50:196e with SMTP id kq13-20020a056a004b0d00b006d9bf50196emr5766190pfb.19.1705274137340;
        Sun, 14 Jan 2024 15:15:37 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id ei6-20020a056a0080c600b006dae1c8c817sm6495523pfb.74.2024.01.14.15.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jan 2024 15:15:36 -0800 (PST)
Date: Sun, 14 Jan 2024 20:15:38 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1705274134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QGViPHtjJMlurFPTzBSSPEkkat6LUsMaxd6YuoP9bZE=;
	b=mr9Rkc7M5rCAcuie0IEgYS6HZeCbDJJr9e0HB5GhSydRms/1CC31Db9XU/abTy3Rt3+wxY
	/WCIUdOnJKbyNGP3ul8Bl4JC+DR7eLl+/7mPa531B/x8WSVL5VpYns9AjVVh6+X7VaJ6gs
	k5boUZ7+XYk1K0rAjcmDb3KGXp0SST4SaQPW77BqTGHakjURR3oYPPSXQc+G4y1g4BENmq
	nAE+vZzxjx0ow/g/rCllZdsP+3cZwddxZPeGDPk2HM5IQitjHtO2QhFHuMJ9Yfs4nHl0hP
	ypaN/9p1M0d4Mk0jAXJL8/jesps+V1C/KvA8D1XUd+BpYGkNUXY8fjsAMlLrEQ==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 0/1] 6.6.12-rc1 review
Message-ID: <k4fx6zf7tohistdg4dt2vuz7h2by3k3w4u2xulzta5drkvevye@2nki7zdt4j4l>
References: <20240113094204.275569789@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240113094204.275569789@linuxfoundation.org>

On 13 Jan 10:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.12 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 15 Jan 2024 09:41:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

System runs fine, no noticeable regressions.

[    0.000000] Linux version 6.6.12-rc1-ktest-gf44c56831910 (rbmarliere@debian) (gcc (Debian 13.2.0-9) 13.2.0, GNU ld (GNU Binutils for Debian) 2.41.50.20231227) #2 SMP PREEMPT_DYNAMIC Sun Jan 14 19:53:04 -03 2024

Tested-by: Ricardo B. Marliere <ricardo@marliere.net>

Thanks!
-	Ricardo
