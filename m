Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886402FBE17
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 13:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759326421; cv=none; b=JHjKaKR/2E/VNXWjNvM0G/lWllCAoeZ+yRvsVqgLH3alHobqgZ9aK8H1jLVBg4Y6cOqDA0GJ7zZ/chVXewgmHBDp/0v6h0Kvh93WpNEGE3nRWtt2HbcKYMCbLo+/XiIof4VM8nZNXG17x7oyWr+AhfGaEjYILzH1724WIMvD7/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759326421; c=relaxed/simple;
	bh=XnzBrKkqhtzozb80b9whPjYrJYlVgO3E+tv6VeqoZHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WksZWkPZ72hC1RbQgSLsFr3gU3BuepAsEGa0FuduONSXwhAULjB7vyeyoPoBFE3pA073ur42jEjR/WfRnPP9t0jHRKgf6ac9zwgHwsrL9KB/WWFXVVXBDmgcf16F3qC8rPkR+c89pSH6p5mLeVAvN8xfaImJLVMWuYpqun5k6Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=hCRMSNja; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="hCRMSNja"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-42d8a0f09f6so922725ab.3
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 06:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1759326418; x=1759931218; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W45Thb4hNfN9gWdtcaFXe+UzJhkD5Q1/J4+NgR3g+ZA=;
        b=hCRMSNja9Vzxhy3DCwns/LyTqm2UeFQcrZPeGuZBX7+t+G9LVMhM/NRGeFlt+o3PRx
         XPTkeUTE8W7WnNF2W4kJmBKj7LKVFUgYYhzV1Mi2aW2l8loi83f2ER/9tEQY01beDl7j
         LArxOBbnfkeuzyw0VuM5TdItAa4Qp+Fo/m9BY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759326418; x=1759931218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W45Thb4hNfN9gWdtcaFXe+UzJhkD5Q1/J4+NgR3g+ZA=;
        b=Seo9/Ahujw27m6NWCK4R/ZAjFNO7pu34X/f6peBEbx+gsdJSkoiz11Y2GKc9wPMDOe
         hxV7ESlz5axjpS9EavKfpo75XabwYA72BhPxbPybU5JYwzfwZvvT7mSKwuQEh1QlJlrR
         HtRskQmiW01oR1a8gT4PhjGNG1RCtx9h3kec6jD3LIdO4amtAfGjtrJx1fc4SQ1bZCBR
         QRv1AnLTROHON+n/b0rC10h1nEk8f8QRlgiqO+MZguLh5o0QWcWFlp/VlMAwNoPgAbV4
         uVcE0NenBKpv4mdGaqVTcYBVCwSyi3jTYjgpSyUodRq3tsfAAEyBo+ZHwshVkIzciTmB
         fr/A==
X-Forwarded-Encrypted: i=1; AJvYcCVYbMk2lWgXg4IPesJuLZ6kf9vssbNINjKfGF2rWvwwQKRkdlGmZ1/ZfgBl+HMPgfvAQ+LXgwED@lists.linux.dev
X-Gm-Message-State: AOJu0Yzb4mi2M06QJpEOoMmA4Pt3Hxa/7OnlIm0AzOvMYlOF+dA6xhmh
	DHzK2mtUnMsZkN2+oLwyy5ySPkw0Br/cmVvC7oEc3hRlH9KkHknYVOaNidSUt6UteQ==
X-Gm-Gg: ASbGnctmCWBYm4g4fbK4RjXDIl65Ac+IW8RlQzCCFTE+Ku8WB6+yIDDJaMbN0U2peV7
	EeN6FDIc6POVooTHtVskAAvsGj6nM/X6KuxCYVrAEHMkmdeyMcmjCy1rDnWcVXQIKdbVVvdRvjD
	v2dVvNgBr5QCjEyHewvwudVHPsPALCQlvwRZnbfIILh9ns/dy1QHFokyhcTBw+lE+De8xe52bgs
	HqJl4NsIussIU/rM5U63TaWbrb1B6m2kRSpWKXJ6LrlVz4rzhULjDMetTwjos7MZJqCZiJTwmmS
	5Snn2FSEeMnUgppPIvomOd4qpsr+maJJ+mGR0w9vKPoy4SbazpxcSr+EXZR4p5DrO7T5FTVly43
	C4oXB0sq7FW3XX2zBNscKyJXu8gtlti67rp1O6ZnUJEnpbgV82VVkL7tRJHegeMYsCmk=
X-Google-Smtp-Source: AGHT+IGcnVVpdzqOl2yJnXH/xAk2zhNyBvJcfPwTkWYHDx3ZGcmd+zfU56UdL8Te+QSrukeDpCOkzw==
X-Received: by 2002:a05:6e02:1a4c:b0:41b:6e7b:3e9f with SMTP id e9e14a558f8ab-42d81676819mr50599705ab.19.1759326417830;
        Wed, 01 Oct 2025 06:46:57 -0700 (PDT)
Received: from fedora64.linuxtx.org ([216.147.121.65])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b58db188dsm288004173.33.2025.10.01.06.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 06:46:57 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 1 Oct 2025 07:46:55 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.16 000/143] 6.16.10-rc1 review
Message-ID: <aN0wzwSnbG_K4xtU@fedora64.linuxtx.org>
References: <20250930143831.236060637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>

On Tue, Sep 30, 2025 at 04:45:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.10 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.10-rc1.gz
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
