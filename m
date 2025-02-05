Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793AA215F4B
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 21:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738792621; cv=none; b=M1ZoZy65OImWgEO8ga3F178l/PcOrCiuKhcxISqBH9CoOAzZ4aJhUDiBNGwOXhiU7WMiMvaBMPI5D4KWkV/a6tA2BA/TjXqvQ4P7gKYk3Y9UQ25iwdOrErb32GoBZZDELVANOk54m5KZZ6g45nGJsXX75hoFyYNfiXHN0M5OWhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738792621; c=relaxed/simple;
	bh=+ozLHxhArw7MVnLnODmfn31z73WbsqHrsJgwqe4g1D8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EoIxzZFjnBqjdYEl5+f5CeqgV4BY0aL1+0u4eBCoLS4hOuzkLyYQITq26xdkpMWOzKr/7R4egyUagVLC4FvgxP7t6QoyZ4eKYvP8Mjl8pVf4/ibszLaE0OUo7dRD49MTAihJU0UAtnXJ1MVC+YNW0KaXkUtYxQ9Kh1aieQU1WLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=h+LT8a15; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="h+LT8a15"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-844e39439abso8824939f.1
        for <patches@lists.linux.dev>; Wed, 05 Feb 2025 13:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1738792618; x=1739397418; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p+RqOTSnSPXG1MBUyv0qD+rReSmeSDZ6Q4z10LKFiFE=;
        b=h+LT8a15kAD9B4bBrmsP92LjKLks2aawOmlli9qd4zZIiw8jg4uglpY++el5cbG/Ep
         IafCNxtmMkI54wDCn6r/zd8Kw/S8c+Kxmd27a/aPTTBvBfXCYCBbARVOtTsRR7o4aPJP
         hi2JlqaTh9u3KHvAfxTZIyJiLd/yBv057Wpcw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738792618; x=1739397418;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p+RqOTSnSPXG1MBUyv0qD+rReSmeSDZ6Q4z10LKFiFE=;
        b=XfFO3hWiVfPuzAvP2DC2k2zM1how2TNqi6cvSyvkr1sU9CPKz90IoGOD7xN6twBrgY
         sWGzF2HJHmKLAIj9WNcHIDRiLxjbiKJ4MdwmxA7cYv2wyZ2fIYzJi9N5dwVw0WBQtPnS
         PXGDpjgZ5i5BvBujusNEJvNhQkR8sCR/T8UHoectZtJ3bZwNwFNkt/dJevpnwOYrev7y
         cI2TZ4T+Y4Bjy+4nLRZL9jtAT/yQIxr+n6U9Gz9HHOdsajhe1eMQwk+A57dShdna4C9c
         InLPlws+Ya/ypaBTG3C8NMWUAkT8KTcZV7asFwvm6YCjKqr165Nf3FJEmabcz5OrE8/i
         X4FA==
X-Forwarded-Encrypted: i=1; AJvYcCWUlD8F5mUJ+YWCDsN5fU0lI9sJY7kRX891tnDxY0IIUey3YSS0mPJwNLoISMdKdfp4aATkItiD@lists.linux.dev
X-Gm-Message-State: AOJu0YydIvtpBA9C+k1rWaTeDfYDA739m8c3Kk/Rc1gBBogFGXdViHOR
	4190BVcpNfHL8GI6S0cgRI6yQf/9vzS/ZYGb1e/+ily7TpJXqP7kHmVSlX1TOg==
X-Gm-Gg: ASbGncv4XQiVmFFap8TCYsokd3HbfEc4hgcSrt2Z4QXHNDgifZromRcRFjRsAI6oTLo
	Ic9iNqWlQhUhUQDwcnglnWBG7EHPrbRwiwBS9keOb1F43kEb60+M32FamOynaIbDf7TzYsQIJS+
	PbeZ0GJxpqWOmgOdSFHT/4fR0tlge75SC7lH11jye0MpmTBwGJ6cwe7YqTkH+h+qriy7tLc6sg+
	qutEi6AFM4fsk/dZDZxDTk6XkxS0DeShcWZ2tOFotYDO0lyAOYchx9b1KRxqW4e1FiTL1hnadiy
	+myPWfuQSUcWstyUpDTG8dMwzXySX/D7
X-Google-Smtp-Source: AGHT+IEWlXmXQnDihwBVnSYlw2n6wPB+KmNglO3Os1wffGg3OKOkA12y/hS3Nmj7qmF2gTqtJ9Wcjw==
X-Received: by 2002:a05:6602:388f:b0:84f:54df:dde4 with SMTP id ca18e2360f4ac-854ea43465dmr545587639f.6.1738792618515;
        Wed, 05 Feb 2025 13:56:58 -0800 (PST)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec7458ecf8sm3421542173.6.2025.02.05.13.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 13:56:57 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 5 Feb 2025 14:56:55 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/623] 6.13.2-rc1 review
Message-ID: <Z6Pep0H4X7Nty9tu@fedora64.linuxtx.org>
References: <20250205134456.221272033@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>

On Wed, Feb 05, 2025 at 02:35:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.2 release.
> There are 623 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Feb 2025 13:42:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
