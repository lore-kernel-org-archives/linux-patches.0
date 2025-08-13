Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71A62F83C9
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 20:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755116115; cv=none; b=ddNIQd2O78JoBzrhlxPkW2RIbxDUMbH8mtIyQGx9sfDaQNq4a0pSAf2k5Jsfrs625bcE8GnQL4SR1VNAoMS8Eomr0V+Jm46F45Kj/bNQadrXONjSgWf9LtU6nqw7Xzuepfx2Vm57h0gEO99U6v1ULb5srFjDZqaQo+6Sey/2KMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755116115; c=relaxed/simple;
	bh=/DpqAeslv8bRmsN2sfqbbHvqAKqaJvH3JKfHsdO27s4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rxvPJRNoYJR7OjemkY8BM4Lgtaa3x4ZiVyQauOukZ2te/6tSXO+XWay62iRMtB4xIX3EKnTcOC+7hIWUB0at8NB790kYZpt1Jo3yYDSyFumP2KibEgAr9y0T5XtYLr4xmT5hE2IBOYFLcVnoWJSHIrlbfnKqvUD2MkNo0mxW8l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=ct9WBeeL; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="ct9WBeeL"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-88428cb5dfdso22006939f.1
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 13:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1755116113; x=1755720913; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HcgwJo67fSdIwhf/Y1kaVkQkpR61CWnlebZ6dKIeM1Y=;
        b=ct9WBeeLswyiG02HkXOuzUN27b7ddnP7RTUbuKtzmJAdps7FhAyqGNfh828ILag3R3
         KajI8m1kJ6g1eQwlekRt2AnJjOZtuwX+5AF18vrcwnIMbIQSpDCB1ofhSYlIrfvfox4r
         +hSthkkgGpY0JEuPwW+A86X7K2IsIx9lzWOT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755116113; x=1755720913;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HcgwJo67fSdIwhf/Y1kaVkQkpR61CWnlebZ6dKIeM1Y=;
        b=gOREkAOkE1KgiK9o4v3K8wXVMmHM/Q0gZT6KdzI4Fb1dl2YWigSK+yAr4fZLcKuJJE
         JKel4XZwi1A5mxgwcanVQXoPobu2JaETOMwjYmxmIlVo+M4X1y1WNoFZvOJVi9/7ks2U
         ESZOBDOiOvOti8niZa0Y2vk4qB0LG/EZhVKmLeUNb/mjB+i+gVALG3/NQmulreofMNqf
         hLzIhNJCXPBejE7Ax3aH60HuvnkIhNC0TGYRvbVAOjF+YQR6Wljxp0i5qfOZuQXH6VpX
         NYrqUzy0J4JXkVBdVvUUQSu4IpjqsCpj0/8JG+n2WNjIWLCJxxy8ruGn/2yJ7BW4nlnp
         j3xw==
X-Forwarded-Encrypted: i=1; AJvYcCVfmWARPTmbMrLwwnZr54syGEYGPdvWlKZWzZBPL7tumKPwjAn6WtKC2pic6m4NooEyfT0X0HWu@lists.linux.dev
X-Gm-Message-State: AOJu0YzFUPY+BL5Fuw0P3N2MaC3rVztxLS2Sv9Bj/uUicHZanlmDW60f
	8gNBDaWoOAWF8P8qDLWZZm18GKrPg+shFuLpND7OjiCZMUAZkA9jQQ807t8pMbtKUA==
X-Gm-Gg: ASbGncswF6sNIAVY/h+OgVwZb4fDsWeDAZrEoaIySqjp/k06H4BMoALCDdOj3ltXepc
	mMb4Z9OFj6xAT1IRo26mSek89kea7W39Iwmzg4Ax+DL449OJzhgaYs6WDbEuud/9tK6fBhgZNKC
	h2NFSZMNbpyGThRR5M3lRL0WYOw02liFRWuHKOGFnOezA2E00T/Rv+n0iqh1wnspecFwdv1Idnn
	znLIIQ+XBkQ73+s3ZsxoeEXd1pwHOTNf8qJArdIuhgs2MfBgWi95oDZGmWYwy3cVgrzlvx908Cg
	pNm6f+3MOrn1FNKCeVp5fwS330kMYmis3R9MWaj9gVj1N6ZLyKkI3yt0cECqWIdGFS46+JR3i8D
	Ewj9GBeq8Ee/5BRxtIO7dGcLG5XEa4jRt7bPRAtM=
X-Google-Smtp-Source: AGHT+IFIT83RK1BgW71T/A/tIXZmBd0yTKosCWQhpckCX2xdMMMQJzk4nn/G4EkvLEe5LUihAUVh8w==
X-Received: by 2002:a05:6602:7184:b0:881:8957:d55e with SMTP id ca18e2360f4ac-8843446d220mr16540339f.3.1755116112915;
        Wed, 13 Aug 2025 13:15:12 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50ae99cd268sm3906199173.22.2025.08.13.13.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 13:15:12 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 13 Aug 2025 14:15:10 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.15 000/480] 6.15.10-rc1 review
Message-ID: <aJzyTmxsakkQ0SCB@fedora64.linuxtx.org>
References: <20250812174357.281828096@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>

On Tue, Aug 12, 2025 at 07:43:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.10 release.
> There are 480 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
