Received: from mail-ej2-f3.google.com (mail-ej2-f3.google.com [74.125.228.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7C9320A37
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 07:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783062974; cv=none; b=sXCu23nV3Y+PhWW2iOVpvc76SClVnVpDJUhgoGW4elmtJLG+Ra0v3d96A91WS98Dlinqdi0s4oRACr6v0ayEoeoLg7EdF2PUy5VzhydBeGQqIZJoYHHXtWpAZ4vzObrmIoTi6p6GOLLeXE/jmhj25CUA1X/LRpxa3pUtxHAbBio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783062974; c=relaxed/simple;
	bh=0bRCW/0G1EaCEUzVrCTzra1GYsba1RlFOpEqB6cyziE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bFkwVlvlcwopTcivvOa3zfAC1gUjSFw4RB7XbdCTEfKrCM7BSHP+YipYD+Ulca71IfpaqzSAM3HteZzxiFgDrcxsRan59m/5qbkGqW1Bg02GyTfRMPQ7sr37d+61+GuhIQzpG8Ko+vITIt9Ss8Ws2JHoH+RKkYXb9BBTRJ1EFpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MbV9dveF; arc=none smtp.client-ip=74.125.228.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MbV9dveF"
Received: by mail-ej2-f3.google.com with SMTP id a640c23a62f3a-c1268e71e78so9316066b.1
        for <patches@lists.linux.dev>; Fri, 03 Jul 2026 00:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783062971; x=1783667771; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yEtuMKx0BNg5wnLSISs/1Vqqgf3SkbjWVf7WS0QWr1E=;
        b=MbV9dveFO00/3zb/tQKWwc3LtLhB6E27/VLZfwAWOm8MCo+nKjijUNjnBmxOY14srh
         0XS6PjkqGbluiMFhPSVhTkNXSHZdZRjfISnQUXE9Tk5t0cxXxhzDEsexy3En//bTs+ig
         RrDRQQApvojHp9i1yFY2I4c68LMsQa1Vv8Cz/R/LPNGNtKp1fRgqnULOroxdqglDcT0k
         91Mp9MoN2am51NUrlEUrU9kwROF+c5Os7fjyIS2jvdE7Gw3PiVBke9B0HB8bnbUlfmxq
         VL6vGp4Vz4jmQFEg1eJMhDrdm2warfno3Ca6xioAX3sIUH0WKG1lykdSoKM0SbYdrGCr
         zc2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783062971; x=1783667771;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yEtuMKx0BNg5wnLSISs/1Vqqgf3SkbjWVf7WS0QWr1E=;
        b=lDflS6rUvtECiTyOH33ZwltVYlGutZjye9dceIBJacEtqf/YnVU1ocstYqyrcr9CY6
         PFbseTx4EKcriCmlP6hGrChUr8/tqxhLMl/Zjr056XbN1/CUp7Y9MryKfSrOhnYHv1A6
         PPSGSVSDCWk5dBz1XBJwSw3YRbFiIfu2c++Lk4tPhR6DFbo3thYIUb9pqa2ObEslr8ek
         OuduH0gO60fF9ww4Zo1avnyZAJfPu9nwAW6HADfxN9eJmhg5Ko+JPypA810ioxg2JOvs
         b9A4mH0fQ08tdgQmRjxrUqbPmigmZtwG/TqSW/cEuVVHz2kx6v/JAqTfN+E7dXIAONDc
         dnvw==
X-Forwarded-Encrypted: i=1; AHgh+Rr8tmKCvaFaRQsVNLyWgAqi+3uMeOilTvrzPH7Pr6nS1GEsNj6Wg7elfLSutGrB4G8JBDpb7FYz@lists.linux.dev
X-Gm-Message-State: AOJu0YyW1XvA+FzYsy1TAcB9PNmyMlRih+41U1ZBU8270VcTWF8eTqsq
	ldgOjuj+hXiqEncEf5Jiwn1Gc7UTyy0XQf/T8hlyK1s3lGNECJGvWoCiluzpBy86mf4=
X-Gm-Gg: AfdE7ck6zHtA175l0T4FNvmww1EVGxkt8jiTWiC+gqm53WRufAsTo8+BjjoRyY2tnT9
	rqyfhsl2to/7v5F5lPCo6kc0Y1mI0Mltdmp1LWxmKv0jqh5z8oDRPGfPYvysSMPip8jCqnhxbIy
	T0NdpaWvb6zV16mxZeuWRudLO3wxHyf/qZ5DqOXJ+GIYdWEpIViEE3xco0xuZwJ3K1ilV2JbZFN
	r94ycPPbfJ/L7dTb0ipNH49wRvFjcE6IdWDl6y31KXiFeTAJhqASNOqJ2hJkfEelfBL1dRTDooC
	PI1xpK4A4MyafQFLpPQoef7mfUrSr92/H2S6FaJtUsFBU3uFlgaXPQNy4LBrcN1rUcg463qpq2Q
	R/9Kh6jZ4gu1PFfCRwprRB68kNRrVWAgfuvT5y/vmFgI2fBM8CGnwnrZ8hJPpxff9QSSBh63ZTz
	Zwz9BVfUE5QlWXbr5c48GDuspWKzWsubbWQZuZhIFsFmQ=
X-Received: by 2002:a17:907:fd86:b0:c11:fe9d:2544 with SMTP id a640c23a62f3a-c12ae4a690bmr346459966b.22.1783062969233;
        Fri, 03 Jul 2026 00:16:09 -0700 (PDT)
Received: from u94a (27-53-162-24.adsl.fetnet.net. [27.53.162.24])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a310003927sm3402688eaf.6.2026.07.03.00.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 00:16:07 -0700 (PDT)
Date: Fri, 3 Jul 2026 15:15:54 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/129] 6.1.177-rc1 review
Message-ID: <akdhbLZ_CEa1QvlX@u94a>
References: <20260702155112.163984240@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>

On Thu, Jul 02, 2026 at 06:18:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.177 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps, test_verifier
in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/kernel-patches/linux-stable/actions/runs/28642578397/job/84941873172

[...]
