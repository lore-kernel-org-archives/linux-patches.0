Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A076733A03A
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 17:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756834393; cv=none; b=qD6ZpZ0pru383+ptsNnipzbJDYVtzZuFl7Xd0nEWeX3IfhzVegkK3PPAxXgN2XAA1KbHcjLNPaEV2KMqr+z4TsMb2VBNJULu/jJ16mlVpVCMAj/fN0G+AyhfPYMCUaAyghtI9cKODYiuJcOSAtrRIy84lD9SP/bT5JXmrmr6h0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756834393; c=relaxed/simple;
	bh=vSi44c+F/pB4RK/I8Cca9wMh9fClcpeVgwxtyoNWbyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T9Xmbd4k5O4N6ILHsw6rZ93s9T5YPR22cfJW10mVe6jnaaTwhti1gsvJBSXzH75ehWQ3YUDR0O2/ILpRS8L0eAt7KT4x6xlIpXLO+z9gGcgP43DBNFuyPt31/X0GOFzbZIq7fXtdmEMJGl6biQaTpDk9l3qiGf/kJkcSBgWGmyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=Yt8kgQ/4; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Yt8kgQ/4"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7452b1964f3so4479641a34.1
        for <patches@lists.linux.dev>; Tue, 02 Sep 2025 10:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1756834389; x=1757439189; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4KTz2L9raB5dHv0DWKjVffzBC8rLB5luuA/g5XJUA0o=;
        b=Yt8kgQ/45RpoX6jcL/2Mm8/qGglq21y2tvxpbqP9I+uEwcnlk1Q2DrQZ4FKauct2zY
         85aO3dbuWCBwNgDtWPZjGqHcdpJympR/P/IRItyx1G28cKZl3FOMPAn2abSW+6TtbQIs
         8rgXVBtBPtMSspX03CmBbg507vJ7SNqgdoElI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756834389; x=1757439189;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4KTz2L9raB5dHv0DWKjVffzBC8rLB5luuA/g5XJUA0o=;
        b=C7RG+T0KEauh8eoTG94nx1nlsZ98OIEbhyLa1gAdz2UjI9F8i6ctuS3KCZP5AakDtK
         7v4V7wi4RCwqypKYUZ2nJaByTdijZEVGwpwZHftvOGiv32xKGhp/j6ocnstymG88WkJk
         C03Nr/lRc1VN0njnx9zXnvK9ZRuPxYCHCeEGkZuGjblaw4bMpjVXLL9P2NBIQQVOoiuH
         RaeWA9rViXYCsLcOebPL1Qzyl2K6pdkvyVF5VJrRIzqqMH7cyKV1mqD/ej0IfYMtlkOW
         qgHC+BKjRfInOpzLLyvPzIpMW9frolHmT70EsfIee5szZtig7etfpBkTIFVn+xeo8N5T
         xcoA==
X-Forwarded-Encrypted: i=1; AJvYcCWBDnFFL8l1MhIF+6bIDWGgc/Ol8NPkw9O/Dwt7YtWAJuuVKJYg9j88qPML8pydQM2BenhU+Cz0@lists.linux.dev
X-Gm-Message-State: AOJu0YwXEiwGEkY9657z4gofQ8nHUOTGKWLaH71mVcRkIbD0WoUj/Rxf
	tfR2KJRzJMnvjIk6II9o4o05R9790TtP/B9h2hKOio8at+CHXczUiR3aZgf+USoh/w==
X-Gm-Gg: ASbGncsVWbqkGb3pMxlsr8cCMveOK649p6qIlxVcJfZp3KRSx0SZRVQqbmmIjP+OP1s
	wcZnbNA2oDD214y4PDMZycsyAVfVuTb5ndJ3RNEXkQa9NOI27unTdUtntU9OoGRRyXfZyH1G6qB
	3ipiwzYN9yWO7dxpyWJaDCkjl+VFpj0pxOxQEPqqdDDjyICvGwyWz5ZnDcrzveRtgyW9hNlkvBd
	kSVzBCRtRg3qUKDNdnofZmz3e20zOxFYvYwOTpjbM1GlscFqXpJulY9hOX5m+E4pgY6OW6tyzr4
	GZFEpTPpCwjdSJZBXYjMU28Btnm2PV+RdlaIjShcj5H7QkbL1sCI2sNe6iz4Hic4NBKzO3Ui6NP
	4xhWRzWGZ4O87rWNDwtU907FPolk6xHhnKIVm0nLxn73vhXcxxKgXdf5ktvhjtw==
X-Google-Smtp-Source: AGHT+IEKZod48ntPYt/3uzppQZfzX++dethMHjVfzgn04A5ervfNM2G9qXouzn43QjM7p2KfwjeESA==
X-Received: by 2002:a05:6808:1483:b0:437:75ea:6c68 with SMTP id 5614622812f47-437f7db9457mr5956448b6e.43.1756834389567;
        Tue, 02 Sep 2025 10:33:09 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-745743cd46bsm1705070a34.40.2025.09.02.10.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 10:33:09 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 2 Sep 2025 11:33:07 -0600
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
Subject: Re: [PATCH 6.16 000/142] 6.16.5-rc1 review
Message-ID: <aLcqU_rQeFwezfkm@fedora64.linuxtx.org>
References: <20250902131948.154194162@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>

On Tue, Sep 02, 2025 at 03:18:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.5 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
