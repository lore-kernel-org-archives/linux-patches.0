Received: from mail-wm2-f1.google.com (mail-wm2-f1.google.com [74.125.225.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29863019AA
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 07:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783062028; cv=none; b=iowGplvJ9H1iCCTC7covKo4aJ2fPr/A6z9J4emIiMq+2Sef2Qs2Pd7SWkxalnyGSY5sWKfYZTnKK7K67GNB61GeIBZEQYCgMg/OTzSPQbo60YV+Vy8qusldSLttQVzorFa1vtWADebbH6ZTHQV7Iiz7nvhmoVgSdIAAfUB5fZv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783062028; c=relaxed/simple;
	bh=Av+FGjwoY3yk/xo27LgIS6t5fs/LExN+zH51SpAyCVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fM2RvDdcjZbkhGaf4xNzge6wi9C4LAxCdElsTvVhH4n6LDGKNv0BYgRKxU0wNdq3Yt7jORfBVDjWsVPdifGMx1ljb63553VK7Z7YpN8IW0QDme4atcWm24KPCU5yNEVvBi/oI7IW31OxeKD5ZnYsayr94sOkJemhzu1sf0z5qRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cD8saRX7; arc=none smtp.client-ip=74.125.225.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cD8saRX7"
Received: by mail-wm2-f1.google.com with SMTP id 5b1f17b1804b1-493b7dd83e8so548325e9.1
        for <patches@lists.linux.dev>; Fri, 03 Jul 2026 00:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783062025; x=1783666825; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B4fISY5Nru22VZDWDI5xhsl3OaYFamOr1yzRy76AwW0=;
        b=cD8saRX7JfBHsdXKB5Cz42Rnxpe9f6fSGfayII4BTLApF72i3DaIQUvE4bOswVbdHi
         7kQsL9o+rFjQ+DC+puvPreU3yNihZx6rUf5KJ4DBB+amKHX/AMHGXaUW92liHoSf590c
         loFkTAaLfD/aXDW2vcKZ+tS93RBdhgyf/Vo3+UA78MaYpVS6Lxh7yw7cv7h3FVNLjbyl
         uJFTIvAtPc2mjeQdsVLZww4w9NgI7xoG6+CLsdrU4NKIBndMD4rk0jm309Ggv/1PQr0o
         3NpWR0dbDTzJaJ0/Wo/iZhb6fSrgkRPazHkKSnUMUhqZJOB5BTlF6zr0roCjeXq8oiYI
         HS1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783062025; x=1783666825;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B4fISY5Nru22VZDWDI5xhsl3OaYFamOr1yzRy76AwW0=;
        b=YoHUPWjnO9naPg4PfAIVadR1t7BZir01C6PIMSmFIoMUA51lc0Ie0en7qnQPeM7KcI
         t6dwuTV4LoXVKv0bFuwxHhBhHdcenC4ZNbKorDUAdU77VjPHEWYZtuN+dg4w1tSi/kyj
         ONQEHyYp9iMynWDCu7X+XR3ig8n3zbKJKbm9ab5DUdxINCxbcUkNvwe+Nyv677TdzMHZ
         93nrDNCI9gndZY2yyMZJMsA2ba0EGbnu84pM8BtygFDv/7fKr19Q3FmackQpx1wnFHAk
         WlWJmfN0NgT/LOJgnW0vH618pmsDgShz1EnjmlEwMHkzS6I43CX8FN7Bo4ickLaRu4QI
         ZzVw==
X-Forwarded-Encrypted: i=1; AFNElJ8aI3GuZY4qCsGLW4AzcnNdCNI8Iw2XAZDCV4IxBt1DnnB5ROY4M8ZzctK5LNUoXmGpe6C29cnl@lists.linux.dev
X-Gm-Message-State: AOJu0YxEJvVhE2RCJQu/umgQoqmudCK6hz05WX2eeP1yuvKz3yrTEaTf
	yNKYoCnQJ20DzdjtUSeQcob6Vb7kfCtbLS3IFmqLyC0LKcXX+hQWOBS6QH+8lgTE9iM=
X-Gm-Gg: AfdE7ckNlnufu+xgzouwwPjC/wGQAauURrwxYSaNBavPvOQZjjI778a+tw895zpLsPg
	9UzEQI3TX2DTylhvBcgRqhIHB2ZvQpMhmNqud2Lpa8OOuFMNljLbJAUXoqGVNP/SU64xU1akY2a
	7Ev/8eDX7la07XmGgSmzVzZmRyWs2nklgEEgjSKydxhGEHUoN5I4dCiVtTYW8hArPo8ZDYb+c3l
	l6B2gT79ZH5vKdd20wx8g7yAwGNRI/XaETnvgJ8yBgBSKxs4ueZZ9W/LzMorseme2G/El42WqmZ
	/rylZY10L5ejYuvEF4KRqzsxDMJqQ+96RGR2GA9SFqJ7eRsrwgzEa0mcyVabj2r6ytLFwuEuEUt
	sUhljCXD/0Ic07xRnW9DelLrlMKFnQgiD9fD9EWZnRoBXKLx7lBHRF6EFeI3VAPES+cVVHS87iy
	5HShod8Xo/Q41Xl7EVG7lcHol5X8CiP5W0
X-Received: by 2002:a05:600c:a4c:b0:493:c55e:9fa1 with SMTP id 5b1f17b1804b1-493c55ea121mr87125075e9.39.1783062022761;
        Fri, 03 Jul 2026 00:00:22 -0700 (PDT)
Received: from u94a (27-53-162-24.adsl.fetnet.net. [27.53.162.24])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-497d17d3274sm3706972b6e.1.2026.07.03.00.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 00:00:20 -0700 (PDT)
Date: Fri, 3 Jul 2026 15:00:08 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 00/60] 6.18.37-rc1 review
Message-ID: <akddu8pDgJ3itnfh@u94a>
References: <20260625125645.554579168@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>

On Thu, Jun 25, 2026 at 02:02:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.37 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps, test_verifier
in BPF selftests all passes[1] on both x86_64 and aarch64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/kernel-patches/linux-stable/actions/runs/28642657596

[...]
