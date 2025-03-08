Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308A6BA49
	for <patches@lists.linux.dev>; Sat,  8 Mar 2025 15:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741446937; cv=none; b=m23uhXpuyuIoRUu91H6iWjjvFxR2PUPoqbI0yhWLqXoDon4ma6liYtl4ueWSTXeMjRU6exrGjXwfBarJebvEOO3mOlLar5InFvOa0CXyNrNMwJ5lg5zgtD3qfzCvaEBGSjibo49CoD97fduBQ2krlkZaeagHNVK+eEq5tUqGq8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741446937; c=relaxed/simple;
	bh=AgKij9icPxUHdQ7wp2XVGsyE9+Y8y2YtloBCQAhf6fE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDK+0MF8AxDUMJtS3TZvWHhWgK5Af9V4Ew/4NXZsuR3/0hKJKeHMX9/PV3Kpq4eTK8Bkts/Hfz5mNNM+DzP3GG8oN7FH84MwTBEcSYJ+c/zBs9Hh9D7bJXE7j7okiBRo2MxEf+Iz51wlevAXATKCrngsK7r9QDI727whrxr19p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BvR1m7Jw; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BvR1m7Jw"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22435603572so19288265ad.1
        for <patches@lists.linux.dev>; Sat, 08 Mar 2025 07:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741446935; x=1742051735; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HxE7kN91mnx/dnYRUE3PA94yocIq8DjPSrJ2/CcwosU=;
        b=BvR1m7Jw6NYj2l/BJKt2rv78YOFV8fpss1aNGpuqdosJBpsmV7d+lrl0MzJoRPlYY9
         e+gRQiswW2y8XWKeAgG3klKwim4b8X7AnFpLVLfcN15tMu9xpGhE5c9bcPuakUOV+cew
         dNbZD3ji+6shiCf0D+8EsfhhZB7R3O47/dDrfd8XE9sfK4OJusGmH07QExBOcZ4oAJPU
         eCxKbLg/O3+FkrAjwKTqGD+ftDB7V2cs6EQw2kV1SDshzpUMF3vEI/1cZ2HVr66Ruj4/
         7H+oBfoKR0mfVeEnThM/+oBE904blNP49rgwmV1SolSwM/BFcE3UPBp6RZ3qmwaxo4nG
         G+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741446935; x=1742051735;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HxE7kN91mnx/dnYRUE3PA94yocIq8DjPSrJ2/CcwosU=;
        b=fUVGzFfJPjgqK6lE5ShgHgtaIz2yqeVO6OTrwZ2Q5BpaKMyUEXULVpJfq0+9MvdvQD
         dK9ZZMYgGaazHoxbh7DwZ25jpG4RYo9IoeLEYM3bspfnhdvgaAmYijSJgkWqXbXq7kMv
         iqCzjLcXhtdncv0z24y/2h3r9XT1SzZ5rxFrLiY8Itwz+VJGjbUiocbdJagKKddH2hV4
         f0RSZZdfNGrll4jDbsf6YQmNQp+U3IsGhZ8x+cMuvqmGrtmLNiGutTlwcIS0RDb72ImU
         7vlWhCxztv+v6IY8t3F7MQiDZi3QhHwqePryV2Showe42L6nnK1rWCTSDAMxuVckpubQ
         FMGg==
X-Forwarded-Encrypted: i=1; AJvYcCWOrLFTSRAQ+qjwmk0nlH0pJrftrBRpEuNhKrxmHhcaJSUdAr2V5XnmbRGWCYlR+O9klFfIQ6jU@lists.linux.dev
X-Gm-Message-State: AOJu0YzaYO/DcWOZs7EikiG8h0HbP7wvZe6vOcW5HCD+1MpsRUcXh7M2
	ANsFP0YwTbdW/rwks6UkNaWknLu8ymNBPfj6VLmxBgh4z5BXPm20
X-Gm-Gg: ASbGncuA7LMMadAm7HMuYwbJcNhM9ZuF1fDIoBMlti0Y1vMuR0aA6xNktX4iIR8Rfny
	OBPWQOYcoVHymboExHz01pcrE09co83+Lk03E2VKZ1dMO1ZKqPA3eyldnIpTrOTZOz6ZXkIu4O1
	SA687uCPiAXTNGkGqymNEIx8g0aLdA8dPZyLwTYysgzRXP5cg8PBs+ZR2ejJXaEKgTWtxOayJxy
	CrUveIFMgu5d4ZMJ7nzoPhFtWDlYU9BSW5+3QdcMHb57ARm1GI9vNI0bThcvvLlKdZdCkbeqtwR
	bJ1mY4jfvAV8zBNU/2gWzq+PlUBdG5gDGMZw5llvugnH7Uf6BnngFFwUpQ==
X-Google-Smtp-Source: AGHT+IGiXzCA206tUytfYMPn7EP+aqEfLAeC1T0h8hyqwwHJG1dER7GMyHIxzmAh9tnrtjt142Mbfg==
X-Received: by 2002:a17:903:1c1:b0:224:1001:6787 with SMTP id d9443c01a7336-2242888665fmr97038475ad.4.1741446935414;
        Sat, 08 Mar 2025 07:15:35 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109ddfbcsm47942015ad.21.2025.03.08.07.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Mar 2025 07:15:34 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 8 Mar 2025 07:15:33 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/148] 6.12.18-rc2 review
Message-ID: <1c813c9d-de04-487c-a350-13577dbdd881@roeck-us.net>
References: <20250306151415.047855127@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306151415.047855127@linuxfoundation.org>

On Thu, Mar 06, 2025 at 04:20:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.18 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
> 
v6.12.18:

Building loongarch:defconfig ... failed
--------------
Error log:
In file included from include/linux/bug.h:5,
                 from include/linux/thread_info.h:13,
                 from include/asm-generic/current.h:6,
                 from ./arch/loongarch/include/generated/asm/current.h:1,
                 from include/linux/sched.h:12,
                 from arch/loongarch/kernel/asm-offsets.c:8:
include/linux/thread_info.h: In function 'check_copy_size':
arch/loongarch/include/asm/bug.h:47:9: error: implicit declaration of function 'annotate_reachable'

This is not surprising:

$ git grep annotate_reachable
arch/loongarch/include/asm/bug.h:       annotate_reachable();

Caused by 2cfd0e5084e3 ("objtool: Remove annotate_{,un}reachable()").

Guenter
