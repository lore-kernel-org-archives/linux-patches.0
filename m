Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA8C2848A8
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 01:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781661050; cv=none; b=Q1V8iYrHUSW9m8S7JBIUz5GrVOJdCuNvcxr0GYnwwitMXvwGtCdtOvGS13jFP4LQrJDR/7u2T2v3TsUKVzrqrMKo9g9X86i/vLnN0qSALkjna0q+DXgVExbpgmTB0mDFOjezGuhzEjNy0aZ8yQSz5/j+9508G8M7GQ5C84mLEdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781661050; c=relaxed/simple;
	bh=36eol+W5QDKiTjDwYRi2AEoywncUv7wm7t08F7b2omU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jUg+ox6eI3M+ZpLeqOAE3CdHMLzj29bkwAYBT3iqAZsSNqq2XI3T3779NhCOuwXi0A33VTdqyTJSt3lmgQQPXxsX/CkoFZtNNzJ0Hr0ceg6LA6duRnJksrB/P5SilDfGtJt4HJz2US3UkI1nuBop2/AoHARQSKtevosfvSGNqcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bcOJdeaT; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bcOJdeaT"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bf0170c80f7so886127566b.3
        for <patches@lists.linux.dev>; Tue, 16 Jun 2026 18:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781661048; x=1782265848; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PnWmqmwNUX+53776sKPk5CT0xeyvh75Crh6p+5PYjcA=;
        b=bcOJdeaT4TLpwifzIaVkuwv8cdg7vwvDd3k1WWlWzYitn+tjXEhoHqyT2NVPqBCp4W
         cjnqdMGWLXg3CCgkmJWP0w19uq+M3BkY0g9i054JTx8IvJ/T/bpstnr4qD5qPiC/I4Xh
         lVDW7A5rdcOvaGX30iF9dKuQ+iMgMYHNb+BpDl/wsV4gu65jHtgI0zdTcfRxkWPgSa35
         K3z/n7256GzK+LijfCXji4X8Z9twb3wFstg8tM4FFlForrQotLQj/5e9FQ52TqfxrlEh
         +yUlqNv6z3/l+F0fB1RH6tBAEe+0nXUc+Gx9aHtHTB+76OrFKrwSr+fnF6YXA8aPNALx
         Mheg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781661048; x=1782265848;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PnWmqmwNUX+53776sKPk5CT0xeyvh75Crh6p+5PYjcA=;
        b=BBQVloRjIUnn8B4rr2iBzJrv+tdtvgdwh8l/Mm/bgdotF1ZWSWnSUj4eS7VFoSqgxJ
         SVTKqmOOjOVFKiru/IyC96qpQHbSNKwobJzFTEN4jmwMZWXu7t6PS2xL027FK5dVur8f
         2zKw0wmDA4pNgGscvLOIscO9/uOObfOF6PN02noUC3FIJldG1L31+4q8UXQi3A0hUIwt
         DWtw3Z3+bcQFpxfD8iC7BZEGe5pjcsJ7ejztQZTXbVQeR4Xh15GlATiyORn6GjxCP2zj
         1XxV9Eg+cQF1vlEXiboyKfK+wOhSP46IffW3/NFgmS7mV/mkI6BV7zm7qviNE5JbfDnu
         scVg==
X-Forwarded-Encrypted: i=1; AFNElJ9YrejUML1js3U0UcB90E5kVMnIgjuchnn+JN9MPoHIbFWowKqhr7PJr83kHuDijLUWKLNrmkWl@lists.linux.dev
X-Gm-Message-State: AOJu0Ywi6mZlw1nm/L0D+igt75N+1A8iezgzn0xydiYf43kOYfrKnTdR
	wqP8VW0UNDSEFxFWJYAC+raBWB5VJtbEMbOM/HuqgY/h3/FXOlKkuUkssAFkHE63UuE=
X-Gm-Gg: Acq92OHRczutRdFfCcLTsQgqX2uX9duE9W8nP/fSxlQipb1K4X6W/bXlVLnQYsZoNQX
	ipIZVGcNVcBEQA1QazmVBW3htPil50fAimfJSwndMgdo0zjV1qcNFybw8jhfflYVMqpqhvieMI2
	XAItMgw1+6Rpoj/wrgN3vApRFiT0Sj5Tvg0El4RwJIGvvfbAc43YJQRGTIcLSvybvyWq6tUwHTQ
	oxXzNAXPOwNKmFz2hVxE5P+LkuFxhC6Y9z+ycXJ/cy//5wsdpZnJrceEfP6JKQIaXd2NgoUOC0p
	Tnz6wCNIKNEx5xZWIcfLgliPEa9zHPg3U4Mpba1Je4GdUsZBeQ8TAFLV3sZPNGLZiIKC3SOPyDy
	jTmkmbcowXDmlnOfcONX4tANBRhggJiEzklDw45yLtrzBTONQGd4sr9fSmkMsvIfN05/Zh3praj
	KfU4VsThCs35rLtBSoGHN3+gEVxT75fGquUVP95g==
X-Received: by 2002:a17:907:270f:b0:bdc:9d31:3f91 with SMTP id a640c23a62f3a-c05a4e0e729mr86294466b.15.1781661047776;
        Tue, 16 Jun 2026 18:50:47 -0700 (PDT)
Received: from u94a (27-240-202-183.adsl.fetnet.net. [27.240.202.183])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c866325d156sm13111103a12.13.2026.06.16.18.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 18:50:46 -0700 (PDT)
Date: Wed, 17 Jun 2026 09:50:38 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/325] 6.18.36-rc1 review
Message-ID: <ajH9WauCvr0u_xg1@u94a>
References: <20260616145057.827196531@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>

On Tue, Jun 16, 2026 at 08:26:36PM +0530, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.36 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/27647340765/job/81762433328

[...]
