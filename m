Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60091779AB
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 12:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721998045; cv=none; b=FlyveZajjKGjOuh3Ose5QICXjE8bH5sBAYeCduQwVTUVFva4TdrK2o6EpoLWAdAPiVOBw/QiszQngGmsmuW8/C72yopIrzEfDKwyAjztNYyUpyZiwby8Q1JBFWHe7ZJ9pjkQTzYdbpKz3widrqef3AI/x64ndOR4K2iftMRAauM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721998045; c=relaxed/simple;
	bh=AyDcpglcnAZJu8d4p/qX2MF2idreXS8s4AoxvlcBbZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dT6/LZhc7eqGI2yBIF0dbMpp2FyhoEPWeG/ZuE9PlEyvn4qoepQg49iNTEzYqxo/i/H80Il9Pf5u7CxprO6PbhVJMbLpYTAsUMOCDfzS5CexZNp3zbh6/ZGHGK8PjAx3IIMQ5nSGUNj9u8EE80SHhtpkt2iXZiL/Zr/TtkE2Ulk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heitbaum.com; spf=pass smtp.mailfrom=heitbaum.com; dkim=pass (1024-bit key) header.d=heitbaum.com header.i=@heitbaum.com header.b=F3Pz8v4R; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=heitbaum.com header.i=@heitbaum.com header.b="F3Pz8v4R"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1fd69e44596so4567315ad.1
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 05:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1721998041; x=1722602841; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8l8joD/B/Ny0D69O5QWhryzHOxOF9XKcR1JNT/d3NAw=;
        b=F3Pz8v4RT8o7nF7m2rkIzPCYZ0o0hEr8OYmHc4Q2hULB6ujdWJqsP/eiEyLLHGm4OM
         O/u1TyAekYZPhha+lkW3NXcYKfMQmDQ8k5ylGezGK42xYGMwBG6wjgjSQnw5kXiZwtyZ
         pK3PK8e1WpAxsxMAbu8wNGA7UjZB8wDE3Touo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721998041; x=1722602841;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8l8joD/B/Ny0D69O5QWhryzHOxOF9XKcR1JNT/d3NAw=;
        b=F72aeoVDRcib6q/eS+c3anzAco9ranwERKpmwlu8TyhkIvxEI4D3tlq+xPu9rUDMCF
         FITkWla02YjHyfNOueTouwn7IrTsLybcbqTQUZQaUK5LG7ntxkYf6hBSjEfRKOEVwdgH
         PlIhjhYHdg9AJCFhKnXBef+XHKEj5u3xyfSm4QnBQbfzf/Ztd80Mj/VZsjo8lPn3OEOp
         CAcefzj+Q31779twaOOAaDxfOUw3wZBLdntho+EAW2Jaj3EZHkSCzd0ey08uPE30jcyH
         QV/8iH+Qus56XlsZVplkcY0Is0XqJH9hbg2kIVZyNTQNn0PXNrfxRabBvxv3y/BVecxu
         mXVw==
X-Forwarded-Encrypted: i=1; AJvYcCVAvhU0F1AQc+pIRUeemH1KEOq0fFPa4X2mkd/1dU6xedFwGMoSlXQJMjZpk0NHNg6sJ+sMeeLSNYslByAg4w0AZ7bD765tWQ==
X-Gm-Message-State: AOJu0YwMMldZHvNUqkO740akVK+ccpMXRoUEuMEuxumQ1/8Q1y/LpYBW
	HU0rENbTe/D6UAVBq8443z8l2fsxjucTBgxPw2Fl3l6cwQU2Dxv6CySK+n503VE=
X-Google-Smtp-Source: AGHT+IFKQK0LMOyyZckLxck2QvcJ6V4ue+gRwuncvfh5n1T2VrUXoDHQ2luoru6Zafq5PoTw0Wx+Ew==
X-Received: by 2002:a17:902:d4cf:b0:1fd:d4c4:362a with SMTP id d9443c01a7336-1fdd6e25be0mr129047395ad.24.1721998040930;
        Fri, 26 Jul 2024 05:47:20 -0700 (PDT)
Received: from 536e1befedf2 ([122.199.11.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7ee8177sm31287905ad.124.2024.07.26.05.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 05:47:20 -0700 (PDT)
Date: Fri, 26 Jul 2024 12:47:12 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 00/29] 6.10.2-rc1 review
Message-ID: <ZqOa0HvI80LrQJfL@536e1befedf2>
References: <20240725142731.814288796@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>

On Thu, Jul 25, 2024 at 04:36:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.2 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.10.2-rc1 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
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
