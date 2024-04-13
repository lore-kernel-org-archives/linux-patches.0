Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F45E3D56F
	for <patches@lists.linux.dev>; Sat, 13 Apr 2024 14:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713017522; cv=none; b=bdyN3D4Q+VSwI0Uq6Kl7i6U0erOCQI3NhCqPiKzP2gsbZ1kxX48YzYebgAJs76qevUHDsAEvvERmWakzaWDDnS/WNsGYIAP0hWDbIYV1qUQmSA5JIRDFGFmRJ2BJ84/gCKqB5/PMoCqqNVqwXVQlGiiz/H7v7JpaYstKPgIK1Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713017522; c=relaxed/simple;
	bh=qYYzrjG2ox687/KVEYrd3L48WfictZFnMFD9YgtiSaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DU1FQU/hGJz8PRALh1eSZPYqjX6VmEB0IHVkHCrtg5v/Vxy9/Vo65ZLpEaBp4s1giCDOG1NqaMJ80MhYkgneehOUCV7fX3Vqw03U93sGzEgsgAufGIVsCbQlwBEqGh18c+63vpCGPBFRwZIlDsva3/dtEEcxxUYhsT4UCtu8fak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W1q87UNW; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W1q87UNW"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2a2dd2221d3so1314098a91.0
        for <patches@lists.linux.dev>; Sat, 13 Apr 2024 07:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713017520; x=1713622320; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j034miScG2h3n489b6gEKjqfM17fESZEXBWf4eIV8kQ=;
        b=W1q87UNWBaIetGBmnZg0psocZIsNZlwjCT1vTBveTr53torRGE8R0+kYHinjHvuwQF
         lOLrEWwJad3OKaPc2H/ipBe9hYOjDnS07lVeJVT7apPChFueMfQmZXrUpQavHzOLqtuB
         Sysn3bUg0fhVR4jlkYvoqAtVZa0tMUuzNTFbjfusfmAl2SKyJMY44NR/OtyvykIB1t4P
         Shmcp2p68ggktHnJL/1W1jhQNAQCpKbHdLHGiDwjeIjJPmIygbrIuF2dN9ErYLBOQuBD
         4ea/OxCbzjKTTVXozWiYqGHd2gnBbaQ6abBnMkW9XddB61l+yHj4VFz8i4iwGBmJzipB
         x1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713017520; x=1713622320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j034miScG2h3n489b6gEKjqfM17fESZEXBWf4eIV8kQ=;
        b=kgaVzY2Sa3KmqKF97QNvy35o7nN3mmCQ9lxp44Hfu97XGwyeIy5xoAha9t/MsOfU8G
         vZ2lnMVmysqz+/jAQnW3l/UHABHkj+NyvU+byHmqpx1UaOVCpkR1xBIF/3pRTwgEe6Fx
         Sw488yy4sE2LtuZLW/fk1esIrx2edk8wTYjSV0zcKGzhVquzbQpF8IbQT/Xrs+YJQOL6
         eKSH9EuA2QDizKPLkhdUgiF8wXV05JTWxGoZkxDhCxaYpinfFVLMCNpL2LzNf+hTCFlU
         hdSOe2iIPb7DY9dG3A3L4HmHgrlTabG3zjwmPcFV5oJqzif+j6iOsFqijCTpYtWH64Cl
         bkEg==
X-Forwarded-Encrypted: i=1; AJvYcCUQEHHOzgP/IFnSdlnSF9CytIfqGBDpBX+2Q5C+jx10ialll3exrdCYBds6s5Au1sqQsteGmerLqfLwDCxcM02sBbRnp7Uj4w==
X-Gm-Message-State: AOJu0YxiAh0qR2TyDleWF4KxOmbGkmxiFN+SJS7q/bIxlmMgQQ9gpaWP
	UU49PDvu8C+Txoyr9AqDqpkBuGIF36P6dNHedyC0aCltuMuqbnyiXttYNw==
X-Google-Smtp-Source: AGHT+IFsqWM6Mb9S6gqS3qSFxMmALzWfWm5RfnIsL4vwTlmyphCOXxLPFC31W0J3A64pZSOvCoyKkA==
X-Received: by 2002:a17:90a:fb82:b0:2a5:3399:b703 with SMTP id cp2-20020a17090afb8200b002a53399b703mr4798789pjb.11.1713017519795;
        Sat, 13 Apr 2024 07:11:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id mh14-20020a17090b4ace00b002a26245adffsm4231036pjb.41.2024.04.13.07.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Apr 2024 07:11:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 13 Apr 2024 07:11:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org, aleksandermj@google.com,
	ejcaruso@google.com, oneukum@suse.com
Subject: Re: [PATCH 5.10 000/294] 5.10.215-rc1 review
Message-ID: <9ac4f94c-414e-4c12-bfe0-36aff3e318bc@roeck-us.net>
References: <20240411095435.633465671@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>

Hi,

On Thu, Apr 11, 2024 at 11:52:43AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.215 release.
> There are 294 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.215-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
[ ... ]
> 
> Oliver Neukum <oneukum@suse.com>
>     usb: cdc-wdm: close race between read and workqueue
> 

Just in case it has not been reported yet:

This patch is causing connection failures (timeouts) on all
Chromebooks using the cdc-wdm driver for cellular modems, with
all kernel branches where this patch has been applied.
Reverting it fixes the problem.

I am copying some of the Google employees involved in identifying
the regression in case additional feedback is needed.

Guenter
