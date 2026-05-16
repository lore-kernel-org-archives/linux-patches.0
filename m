Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEFD3E16AF
	for <patches@lists.linux.dev>; Sat, 16 May 2026 15:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778944135; cv=none; b=RFa4IlqPkNZ6KLprJRPCAPps9VdpSKrRvqLHTwqtxKQ8jzBDH5eLIf77pjcn/0Ksx5to0K5EwgGVkbZBPi4yScvQxrO1mlthKXABlE+opbumUkl/rntERKQgT5ffiwiAFnxH1Umd/lbaR8rRg+F0aQ6NwhsXK9Xm3Jswe4EGJ8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778944135; c=relaxed/simple;
	bh=HhYbxy3zEpD+7odCYgwaqqCvv88DNcUidcMyf7yR+WA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SR6VVbBL54Oaz1FMPTrBcVS8mEfsMFczdPr9pq8W+VPwauTsF6TNU+rJ+xC2GS8FOe1fGmPkT7ZASmzh30+I8hdqDOsPk2LG5YT61HbmjpikvSAx0YJs1Ygl98JHzpw7S42EFCjrD1PlvAKRcjHMfOJ286esf0MUsSnzpn5l/S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=Y8imgXlY; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Y8imgXlY"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-12ddbe104ccso515477c88.0
        for <patches@lists.linux.dev>; Sat, 16 May 2026 08:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1778944133; x=1779548933; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5UzPVeljAfAnCgUHiqp0t3POZa+/UdpXL7GVmJytOis=;
        b=Y8imgXlYHwqNW8bIqK2NESxjC2bKjba2mfxEUN9cS2P1j2qg2fo0Jj7W9pof8UMoJA
         GPKL1i4ckHqDVHPz/nf1BHuM9p2n4dHjJOuYOvAzIwcZ9/i3mAoECWl03bL80YN2YBm1
         YcKs0RtFJidRbCJYMuc3n9anX413gMBjrHa1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778944133; x=1779548933;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5UzPVeljAfAnCgUHiqp0t3POZa+/UdpXL7GVmJytOis=;
        b=Nlw6Ehoa5kitGRziIs+TshRbH2AAIrDEkfdbc6IXFqjsbXLnF+d4bejE+jiQQ4rQ69
         dP2injp3GMzsYfuP2UDA77haD3MWzHNeAXalkTyYJsqXRFe3NGdesVrFjoNgQ/Z5JXCO
         BTRt6QkdExYo5ICzzMtfqc+Ed7o/djkKOuwqr+N+xpYYUEwpWfgDbY3A3STL7vxJOtvN
         UaU0zoI8PMXONU9A7AfXFqcGhwiaTajUGD7ka6ODz0987gD6H9BLr8agTrsvAslZHpPr
         SI2aiukIaAB1hJ/rHq+IG0BNx2fWKUVia+P0vQ+GOI8uF3EpRJBv9dlFVZZG3FgpLH3v
         AYCg==
X-Forwarded-Encrypted: i=1; AFNElJ8TC9fIzoT5rVWk5L8elbToOLPFLuMfxcDeFH/4k0jyh8yFLQOfnPy6jHnyDYSctODHvLjppkK8@lists.linux.dev
X-Gm-Message-State: AOJu0Yyxl0vjYBJwVmuIgyghAKinQDku8GtXrHxOIpE1AZhpSPvgQCU9
	k0DM84HK8kLT2LLwsqr51VYEKhi6amzlHZB615+1epEoE9GF5HQ1xtpaacEtKy1YqQ==
X-Gm-Gg: Acq92OFd6nGQuV23e8ARpAMwU1fc975D/u5yCKvtFDQ4HVKbmLWnGb0zeMYN72h6guA
	aFjmlC4tTCdrxM1IdMYCvoSOEmj3YTGdGpjLOjjLD32N0HwPAso8W9bggqVQPdx0+9g4VC52WmJ
	qFTqDMiTGeClLnraGlWl6dPMa+EPzMsT117QEt8mwrIT15o3EZJM2jfL73owHD8q2/BG+qBDQ8g
	cLr9V4XBeCH/peEZGYrrCK9X7uGxHBfamtSjeb8h153dpDmbGhrvhZwDjQ42fPorAEGj0vqX9Ev
	Xn07qFWmSPQD0+NouYZUghrQMmS6CwBvr2Y2+ZRf7oBBWydFznAA7PY5dJ+WlEx02cLP1Lguef6
	d6rpO2HCmGThl1NDFzZ6Ac/sfeVM05Q8xLMAfHg0FKS/zlimjR+LiOaC54FEeI1GI+it2jgxPdw
	SVbcZuLJyTyHJJGaGf/ASduvHHsSP7Bv32hTtoIDAsJzcsh+v0kYFC
X-Received: by 2002:a05:7022:2507:b0:133:679b:8f96 with SMTP id a92af1059eb24-13504950ad0mr3419247c88.42.1778944133258;
        Sat, 16 May 2026 08:08:53 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.106.149])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cc2351c3sm14925442c88.11.2026.05.16.08.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 08:08:52 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Sat, 16 May 2026 09:08:49 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.0 000/201] 7.0.9-rc1 review
Message-ID: <agiIgekiP3iu1lOx@fedora64.linuxtx.org>
References: <20260515154658.538039039@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>

On Fri, May 15, 2026 at 05:46:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.9 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
