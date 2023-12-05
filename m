Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70F160BB8
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 16:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rd6qP/xo"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-58dd6d9ae96so2480383eaf.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 08:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701794683; x=1702399483; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=66trihcq0zl6sdBww2Rlr95fZrHC76YJZk2mPSlTty4=;
        b=Rd6qP/xoIiYv3I/gedBEr4l3assGp+Xwvy/pSHzSDzBKOnE42jheT80pa1IpuG2l7a
         k9IwUs3w0COwA6RHKxW6cCVO7bESOaopRL+PoGrZIQAH0Iinbgf1jVoc9BH/l+HO+C2A
         mb+FpweA6f71cI0lJeYJfDCa3qqBgiluGvi4upFpy9GCrbs6F/p5Y/OxHiXol6IshnS2
         GYTXTpf4u/Lr50z0FA7QWNyRLhzU1iTHhphPJALc5zQqYnhRcMAKmJaYiluSTCUMEQxR
         Km6wLPJ1OrHVcHws6j+QI1xv7tmUJAWLcDbhxj3V+W/UNzmZUa978I6bMWHY3i0xgHk1
         pTMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701794683; x=1702399483;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=66trihcq0zl6sdBww2Rlr95fZrHC76YJZk2mPSlTty4=;
        b=gBdanyM7+R5dVnnCIBgB4pIlF7x2XGLEXY0a/Yaa89/lmMX+vPWdsSfpiFgsy4eWZw
         V2gtoZDhIiQITboKWMrWz7paMgWBq0j2/8V4UKupC7SZ2fJ6Qb0JYCz3s/uVKkdHbZ+w
         yeBtxePsjROuPSvI1+udcvbemA3n6/bk9xCqnznscHQogGmx8Js4HOCFdq2RcF2Uv9Wg
         hLSqtkWYJ7SSCBT6u8n/6Ec8bD0dwgJUzXjD4xbFt1BDsnpEf+2HlJmKjOLDJYEclP7w
         /Wby9T64wdYZJ+1opxCJyL/93JqQ7wsbfGTYMqPlO9t4ktZfbMAcKwIBx6yuO4P5bC3v
         WyQA==
X-Gm-Message-State: AOJu0Yy6T/r34nvPuWr0uOFXEroLIjxt+93dLiUpzVBagBwxGWj8ewWX
	PLNkNBjSSBSGK7A4zEQTEwhsh/KexqY=
X-Google-Smtp-Source: AGHT+IEzZb6Bldz+nyaGHnbOJgHdRm3EIq2ygKWuydiC0xBSuHl0DRoapcQTN+i0aFlNFH6mragYaQ==
X-Received: by 2002:a05:6820:814:b0:58d:5afa:b79d with SMTP id bg20-20020a056820081400b0058d5afab79dmr4427015oob.1.1701794682847;
        Tue, 05 Dec 2023 08:44:42 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k29-20020a4a311d000000b005902414710bsm680866ooa.6.2023.12.05.08.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 08:44:42 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 5 Dec 2023 08:44:41 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 4.19 00/71] 4.19.301-rc1 review
Message-ID: <00cbc776-a02b-4b1d-b1f9-f75dc119018a@roeck-us.net>
References: <20231205031517.859409664@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>

On Tue, Dec 05, 2023 at 12:15:58PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.301 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 147 pass: 147 fail: 0
Qemu test results:
	total: 439 pass: 439 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
