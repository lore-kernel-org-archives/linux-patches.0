Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C946231195B
	for <patches@lists.linux.dev>; Thu, 16 Jul 2026 20:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784232355; cv=none; b=OBeI1U1+Hi9h2tI152WMpjS1pgckYncciPupy1+5x2mWdoAuIZ3m1ZzgpZQQ/14YVT4YPeTHxqUoJ3T78QmDF+BUHLtDSw84kH62fgT8c7SxzhBOckM7yHOYxsUH1LgxMUxps/WB0D8woIsMwq5yGjPJ2Vaik9DI8NzZl/5DUsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784232355; c=relaxed/simple;
	bh=bS9vgBmB3tygjnM6Lk0RmXc5gL4e61i98UaQtJFsyUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZVd2jIofrGFGZr/w9v62A8PQ1RcPn3TDk0Mo9yuN/CDpwdhuVSct2RMCVals3KuBCCnxSdGR5L/MS3BS38iyxocc5Gw1uGCsj6YUOT2PXm7awGHScqXAVPbUkPfrHfgaltTXoELfBzN4z2o+Yv0V21MjKwuU3DDnHydwssOGmP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=Vjg0HAsS; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Vjg0HAsS"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38e347638adso1938176a91.0
        for <patches@lists.linux.dev>; Thu, 16 Jul 2026 13:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1784232352; x=1784837152; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FPLskKBTAYLzNg31/NHqPBNxF5CkLTQz2CVmxWqlogI=;
        b=Vjg0HAsSLL9Gw64c79joKRw687BE6eTI5JfTkvMVwjUCTuNbejsDXhLuSYNgti1EQk
         22dBVz0bDU0PxotbZuOL/E5Spw1cfC268Kgybs0epj9xQRTS94I86cf08uARLikOcriU
         WfN1OdRmOsLbvHunetNunxwnSzimL6TwTFW4I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784232352; x=1784837152;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FPLskKBTAYLzNg31/NHqPBNxF5CkLTQz2CVmxWqlogI=;
        b=QdwWIjG6sQod1MlIsJGhyJhKwJlA3iwZ16435awG1spJUkWNr45Y07Vx6RTK9KSElc
         cRlhENDReBHAE6uH8Kgdb1IBffyuLHIQWE7nHMbpFJDSbvOJM0HfoOIQgzp3UdIpIorc
         Xb8HJNfvGgEBkHGNuGdAwE0oyp+GBCLDk1ygZ1dFbPw554vcdjIj+gqIjDDs0qvGvyfP
         t6wLpFrT50j1ZlWG+s5e95yt1SkIDWATahIKdHePPN+Mzah/GFsmXX5bgUl8NPtU7nbu
         77g1FlAfgRkH6kVuUbZoW/e1YLY9QEQUXdvuJYThpNx9zo2XFB8YdT3UJpgp0TdmymgH
         aDIw==
X-Forwarded-Encrypted: i=1; AHgh+RrguuiHpOgxhYRWF5+b6Srpa1tE863xoF+MNwb+Na8OYZdXe/ux/q3Ktpxz++yWd5t+e/xcfsee@lists.linux.dev
X-Gm-Message-State: AOJu0YyNX/G6OwHIlWHfQwIiyvjZbAy9XMLAPxiQWR5I9iOlX1eBGf1x
	wd5wak7I2NZNWDWKqUTaTp701sI16dg2X92Dwa2ozVnhBiSOGyl9+DKceZbwJujXWw==
X-Gm-Gg: AfdE7ckvBnoF4oXCWIWOyIES5O67ffE6kVhB8EZuoyXhdc6ES8DFkQzPFfo7f0uYdhI
	8TzwAu2Cnxz7dop7pugLzhm3WjXDX8YpC3dxyUlCtKfcJ/Hm4ZZulkbaVuDE306jR2OrfQ4tJXJ
	bbCOjCyxNtTkH2N7EvQyGmDDlIR+vi5jUyeICamFmGkuAszZFG1zvbhM5Lqftu983vpcPYc7Icg
	JWvZjUQd9fveNR8o0gSdIocfdNbsMuVSvHKyYgVy1oRh+s7hW/evNOzZ4+W+jTfFjK3MwEpVVja
	fWmj6VMuNFbVb7YZxCK03QUzfr/+CYS2JfBnovUR0DqbkDlQKIXXswjLyR7mxdwLI4kVL8aimYj
	f/knctk2M46Opu8/3HhVYNPI4np6Y4en1NTDo2Ti/x7t9F1+ZTm8Xtni8EstV/fhVFVmmsMq1yd
	B38b5+MMV0xf2SFiI8QuttU5XdurewaA==
X-Received: by 2002:a17:90b:4e90:b0:37f:d265:18c5 with SMTP id 98e67ed59e1d1-38e29ff7302mr7496601a91.18.1784232352105;
        Thu, 16 Jul 2026 13:05:52 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.105.87])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31413c78531sm12492180eec.27.2026.07.16.13.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 13:05:51 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 16 Jul 2026 14:05:48 -0600
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
Subject: Re: [PATCH 7.1 000/518] 7.1.4-rc1 review
Message-ID: <alk5nOGCzt5oAb7X@fedora64.linuxtx.org>
References: <20260716133047.772246337@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>

On Thu, Jul 16, 2026 at 03:24:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.4 release.
> There are 518 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jul 2026 13:30:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
