Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50810264A8C
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 15:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739547228; cv=none; b=heIpLGo0VKTcpcjrKILTUMukm0ykWLJtA/QXzpjrp4KrRut4BMBQaCVqFVY+MEC0m+o3QVRL//zka2Jd2FJMg8ViyKtRA21ih0GxXsHP4PosO5TVIYo3VriDi+du5rOwkOIQ1Ar5xzbm33WroSbXI+0L/84GDLOv2/gtzHRpGsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739547228; c=relaxed/simple;
	bh=07AhQZY6eqBCHApP+AXZgM2NZRDZAnYHuj2a4Hr2NjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ggcOAYAs/mX77kXgzFO1uCqyeFx4VdVf+fHV/vtmtkg03RSUuunx5dCkh8g3CJ2Pasl/jxkmJjGc8UKshS7QDISru2iXHJD3bmNO2I4aMxZGpdnEQ7TqCd5pNhUsYWCXK3PGQLa1E0NcZfC5vAPyIIN1GBxt7biskUNjWre3vkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=hgMLQHeh; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="hgMLQHeh"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-85521efa9b5so49599439f.3
        for <patches@lists.linux.dev>; Fri, 14 Feb 2025 07:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1739547226; x=1740152026; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qkMQckh9jiT1iN830+BKZT3u1q140/CKGbZYSL5RY18=;
        b=hgMLQHehccWP4uxzwV8ASM4J0muA9TPVy4f8MmOr8tgkBfARplhYOX/y3NzOOIDcBS
         4lvecg3HeIs1yip9E50S9TYzoLWFZoQvsLL2K+iPMjnlFHGhpSBK1aocU4XLCMY3nHaV
         DsAgXoco1+RBFVfxirlhvXCtt77PWR9eXiJ4A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739547226; x=1740152026;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qkMQckh9jiT1iN830+BKZT3u1q140/CKGbZYSL5RY18=;
        b=O50d1+hTrnn9n3+klQTwklGX7ScdZgtRLA1cZp0V4oTgTWiSp/3Bx/Qdza511qK3Am
         O8heqTlmsVtfFbTV6diS18eY97rYkgkazHdSZ36ZB/lPhNe8Vi5+GMq8OQnCbtxyw0E1
         H6Kg+rbvTKJE2beuz5xtIubYwuN6OTe+9pebQBJcKU6tFLSNTneG+erhvV2aIpMdky0e
         u4cdiWRzNDl8r6iu3R8hZAO/P+g5miOxlTNOK7ggOASMKMhRvwuew8K2TzMDqYfluu5U
         Y9jghKVXIm6ggLjjVA904eNpyzqQqzLMjnleY6kHaBcsA0Exz9BIXRfoLxvCsA5Jqqye
         1YHA==
X-Forwarded-Encrypted: i=1; AJvYcCVxkTpsV9byGk1H3smUGVaOuAl6nNWIkU3cnwZ9gDn0C9ovAa4I/uRtSoMuAcDjzbuX8LCTH2vs@lists.linux.dev
X-Gm-Message-State: AOJu0YzxSNG8YZZqjQFJTNIjPdpDX5iaySlUkzKQhc243827jinjGeuM
	3/L31JaGVfZXJkv6oojmY/NYHDOyXF+kB/m9J+8fbVmMk9zQ+6Ac2VnO9fJUDg==
X-Gm-Gg: ASbGnctNdC987pOCL26t4nTtWS0czD9Ne5GPeBVM1LHIVYCnvnMDl4drt8heqhqZU6p
	gRQllvQ3lUTmhCAUILXYlFQk+GT7F+hYEY7BL+hFjkKZlO+WftMvHYpaIoZD601GH63Hd0DJDw7
	urRl/wmO3AVdUJUCXQEHP9jPeYRgbrUZ4TLf+pI/crW7vvi3SweMPIQ8p/lhe21LeQvBOfDJXes
	jvUhgex5M/zZDNLJ1z++oxZ2jax0FSChUEVvTHqjNmw+z5whI8jrhZBkwKM1OJw+2mXbbXXo4kN
	gmrsBZUwrR7vrmWSjqaEenIFME4DOVjO
X-Google-Smtp-Source: AGHT+IEq9JvuG9VMapzzSQzEygbV112X3NEj6nPsFllTlUf7bexl8lMA4JJVXPsFCKRgGWrgadZhuA==
X-Received: by 2002:a05:6602:1588:b0:855:515b:ba6 with SMTP id ca18e2360f4ac-85555daecf3mr976402839f.10.1739547226240;
        Fri, 14 Feb 2025 07:33:46 -0800 (PST)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85566e63194sm74004939f.21.2025.02.14.07.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 07:33:45 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 14 Feb 2025 08:33:44 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/422] 6.12.14-rc1 review
Message-ID: <Z69iWGFV6szC7Jck@fedora64.linuxtx.org>
References: <20250213142436.408121546@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>

On Thu, Feb 13, 2025 at 03:22:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 422 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
