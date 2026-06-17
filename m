Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583A42848A8
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 01:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781661077; cv=none; b=RnzHmI8LOdPG6D9pFHtXY3kv3i9MX4aaWKN1Ud8gpn+4txg3X0Krlkh3iGqCSWeaQXiMfPhN61rAnpNo2CDkM14MOE0/RP4TPfuTEdqFFRJKl4xb0fLsn0kZKCgoWV4UgJIZlo7C+/s7os2YMhvXxc5hcgkhN+928p6+8UI1aZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781661077; c=relaxed/simple;
	bh=VCchtsxVM2fH38qZB1msSHANcaGuRLHfHBHW5cUJ7m4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNSsT2UOOe5xhY82tokC9dDpt/NKpUH8hZY4pCNK0dbiDC600TmizerCl5UfG7M+6Rc7TGj/MZBQxTAu0u+74QAqKwKc2yraTZKF4unw627gESztlMX+MqRfHe7C3gwsJh06J2zh0jZ/k7Z6GzblRFQxPWUhWdOmC8GqYxmJwqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PRo7k+s4; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PRo7k+s4"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bec49f7e35eso686959066b.2
        for <patches@lists.linux.dev>; Tue, 16 Jun 2026 18:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781661075; x=1782265875; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t4VyfNlebK/GSH3qwV5tDtdqyj4VFoDsHhNLx6q8FQw=;
        b=PRo7k+s4KEAPzfse40WimkOWmKPO0/DXnXriBbI3YU0w5bv4MriSfqKJmaz9uyCekB
         DD0UfeOHvr319FFf6SES4TGGlotCVTTBRBLxEeB2PVsJUZoR3EK2tYiq1nhpgiFU/Z4c
         CW3GCbDSsNdDXLeKjSZbn6kpIt4MQhsREVmR8R+EJIy41RSsiBePD1lxKMiIc4yos6Gi
         0ZQLgMRhvgtacV+MeFpQo4GEYTnfTRWFFHdR3y/VtdjBv9E3Tzu45C2lvYRX7UTeJrWX
         mDNSUAhNZRDSLqJdoSEnXdgT0n016251ny8jO0ediNGdXmvJdUwX/LwFmkGUnSF79a8z
         zydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781661075; x=1782265875;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t4VyfNlebK/GSH3qwV5tDtdqyj4VFoDsHhNLx6q8FQw=;
        b=SPa4WYbwSLbIoq9Y8/tgVAprAPCdOSkV3xqlJlFNykKgOvqQ0mg1Hd/O0ka4gAhMYW
         XUeXztaQsUOOXUA2f6ZajMgB8VT3+4DaL5RY9J3K7tl9v0DiyCWxlJDWHEvzWxuIGhHD
         1MP7xpwjJ95MTMPYbnyLTi7ImSBJ30D8Y3AONnQ10P72fCEqm5Cbt60FAk7e8jcYYeRC
         2/8B+DM7rvCUIDbjJQFwJW2bcko334YZYuaRVcYdiNmP3/DSmveiA+3V2k0nJtv8muEP
         X6/iIgLMxFmpDsrmvsIhdsWCQJagW+h1ATCnjIJypXMYUB5YwSW/nBaYU/tCnF3kMI+Q
         RWXg==
X-Forwarded-Encrypted: i=1; AFNElJ/zrP8C7Bw4r9R6LDyxDuYa/10DEOZ5VmhF8wQKKj7lb7P5nweOSdq1fnureqQNztNhbJxZg0rd@lists.linux.dev
X-Gm-Message-State: AOJu0YxKqqvkdguWbH4iZZnBaKG1cNRPgU83t4biVBxXWeDoAyWHw5SC
	c7s1gAyhVT8fQ4/jY8hsAFJ5kBlu//JlSZf8Ay9iYzlIAq83CQYrKI3qE5gZQmhS7/Y=
X-Gm-Gg: Acq92OHoywMh3uH7JDsr87yxAFzro8J1XHglG9VfeFbatZRdVeGRc3FYBBmqdj7XjSV
	D3hRSDQQj5rr0WYMzcJ94rZ8vd2TUvWuQVHC7ppT9TjaZjvJEhf70YhChCKlK9VwwAORYVijgnT
	gvehC8NP0VdYbvEm8yuzl8dUnh2sxv9FCAOcuUkiVtmp2SOWAByhkrX5whLF08RJeQA8+DdGpU/
	aSlzFcqcEB/C483IqhWyPivls34Yli8ctnBrsajCmUTeG9tTHcxA7xSnkRDCn3F7zzp34E63NPZ
	HVtAWXQBWf0JOL9YwO+MDQTfgbHM086gGL90Dcgr6kxrHeMER6oM427LHJ/8LF3RFsInjM3T16g
	U0VtF+Yj4902nXTV8XzdeK6rS2Sg7wlFaNSjDEMEcp4sURmacly47c02JUEyJ+sjZA29vOOvknu
	aEituM+0YBgUsiDjXI6aZozH20ET+nIS9R4auRtg==
X-Received: by 2002:a17:906:cc52:b0:bed:e0b:5b0d with SMTP id a640c23a62f3a-c05a4c16e03mr77326366b.13.1781661074914;
        Tue, 16 Jun 2026 18:51:14 -0700 (PDT)
Received: from u94a (27-240-202-183.adsl.fetnet.net. [27.240.202.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c4327ac794sm146042435ad.46.2026.06.16.18.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 18:51:13 -0700 (PDT)
Date: Wed, 17 Jun 2026 09:51:06 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/261] 6.12.94-rc1 review
Message-ID: <ajH9eYhd2AN06ROT@u94a>
References: <20260616145044.869532709@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>

On Tue, Jun 16, 2026 at 08:27:18PM +0530, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.94 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/27647340765/job/81762433321

[...]
