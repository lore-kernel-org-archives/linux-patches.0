Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B75F7B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 13:44:51 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id bk32so6371869oib.10
        for <patches@lists.linux.dev>; Sat, 11 Mar 2023 05:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678542290;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pMo24R2nEA7iChoM7QuGjDsI1h1/AgEIEbWkCIWJOSg=;
        b=TnNs0bN5v4rus3tzKno2B4iiF0cq+FS2t4T3ALDl8ZmabCT/z4Fl7WLc65a+1tKyTY
         /nBW2dwRG+7CwLbQ0e2NZrOl73vjOe23fXtgivkLYk0e7ikJJRXdWMD0KGK3l4ka7UNL
         WF8nyn2HDoZKINJhDZFMxi2YU7qgcrJ7VpN6hzbwZeCe7sfh328GsFvVZxFnVDV2PEhs
         sVz0UHh82agpbHQ0AlJxPmNo6mV+7NTYZJv47c0cqZKDPht1Uc+pyec5QnCf1hwE6rvL
         QSI+JeCz2vRDOreRriGPEr0l48r9e0AZb+FGvca8ecZMERDfc24XLcOfcUKFm5peYrWu
         Fang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678542290;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pMo24R2nEA7iChoM7QuGjDsI1h1/AgEIEbWkCIWJOSg=;
        b=C11Mi5Ijrjn0Z5OFcS9E8evlAhJGqJj0s/2tlIxLimStlKx+dZPjTk70J48eD8OQxB
         /psUonIS8SMMu2R7bp7lHA2278hddaw5Vpb1+BqFIiXx756yCPwEryDz8CPP9/ixXLYD
         vxJdXvOO3xqOrT7RBnDBF/lW3WegVyWgRGX3lQGjA5XY2kpdPrsIprtpKi81OCQBaVdd
         uENE1pvzR4znw9bdzAlhaUag0I7bgwMS/okZhfhLKR5O7X6tIdyYAP6G3sDsk9zxFmTB
         WIPJwMAopUwVE2kA0Jdc/KL4/g5d78cWGeyp74pVbeiTf3MG0QMj9/R1d36jRbtMvIm3
         UYYA==
X-Gm-Message-State: AO0yUKXn11oukNEpsit3dXEYGCW4cug/3+kBK0rlQzj8+0j/t89DV0ge
	9pU8uBVbcgmB71FDdKx1AV0=
X-Google-Smtp-Source: AK7set+DYhICjt3TNWVNa5fvqrKJXtq79yCcLEWdrU13G2XpO1ODOg9F/Ddb70ZolkDqYpSYEL3DuA==
X-Received: by 2002:aca:f0f:0:b0:37b:385b:c965 with SMTP id 15-20020aca0f0f000000b0037b385bc965mr11852112oip.2.1678542290417;
        Sat, 11 Mar 2023 05:44:50 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f3-20020a05680807c300b00383e12bedebsm1051140oij.9.2023.03.11.05.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 05:44:50 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 11 Mar 2023 05:44:49 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/356] 5.4.235-rc2 review
Message-ID: <84feb33c-55ac-4c86-8121-e528069ba44a@roeck-us.net>
References: <20230311091806.500513126@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311091806.500513126@linuxfoundation.org>

On Sat, Mar 11, 2023 at 10:20:37AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.235 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Mar 2023 09:17:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
