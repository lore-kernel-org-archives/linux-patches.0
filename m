Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E78F26ADC
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 07:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769067321; cv=none; b=RCT9o9OFrPsLVBMSj2cYd9PM/LWhioTp/A6N8gMamNIxwVmqzHxzkJ3rGZl5htRWFacZqgQw827yiP3z2HfN4Wql0YAYjM6SS21Yvxpw2jeSBGBo3+WFkpV+hC8QDjKrLXI9H4uoSpGifGCyA3M89IaOJnuLnQhTpBFoRMF7XMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769067321; c=relaxed/simple;
	bh=2iN5lbu+BXwCaoxQ1XK4zZjy0ei1HYYY7eZfwZy3NE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mxug9UgBLZdf9P5Uj2FSLDuJH/2Cg6p7+XoDnvFtY3U5eI7h4T7Nl4oPEON9DU9R3jm6Fk8LOg9TKHjZVeYY27g6S8lqt/Qem+JoSAn0YNmQVTEdXyuWjZbCF1RKVFY58SrtMwNjit3g0goXKbE9MG9CN9BfNdWdpxMqUY2QoDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A63zJxxm; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A63zJxxm"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4801d1daf53so6724115e9.2
        for <patches@lists.linux.dev>; Wed, 21 Jan 2026 23:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769067314; x=1769672114; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K/c4iWuGgvMsbipzVLJDviIzSd9C+4jxSnU6toS/nSo=;
        b=A63zJxxmsh960zf++xQAc7gTwfgsXktTQ4jKclvw50qk+8jZaJvJwQoshPHxAmIv44
         xktl75JixGb/lpBjiG41J5bK3N5D2NSOgunT1WxSvZ0tEBh6i7gwEN5R7TvN3RqBDl+M
         WRhOvLUQVMidZMtxondspJ1S1EokM3djcI8yu9jQO2MPSGSJl2od5RQVuRGJCqtrx5hw
         DlG3Fjxfs+3ZUdmh2Sp9cEez95wxGG+1DJzeML+dbd5SjL/wWEQTuuaWkwDr6DvNY6X2
         wkIvJUo1qWbg5WirpRbJUgjA0JTLoF4ldivBv0OL9SyWBspVzPP31uiWJV+RwHW8T+es
         Cq/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769067314; x=1769672114;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K/c4iWuGgvMsbipzVLJDviIzSd9C+4jxSnU6toS/nSo=;
        b=Bgafso99gi3iDFpWyKCxh+/x159FuC5St6EtKlyA/2BVgyqwQzUGRUttgO89Cx7jeK
         8AQxXUvfUpW0rbTb9knr32UixYLiTTU3ebZG902fH4g7SjBBeVvPerKf+4L1OEYYVohJ
         4mlB4VTks8s0CVcVgKsFsfhDGqIF7dgeZMx72m6/HFbWXGdaRXwSjro85K8e/HFM4n7s
         0rJ4wcYnmtd/EzCdkg5QFx5AV8Moc1xgi6W0KyFpsNPwZUqpp8lS8aEi0h53HO0Ywwbg
         ddEcn4RrNRWzaukKy4dOQXGU4LfR0DSsyzvyeu6Ve3S+/wcPZM4lHPUpDJylIMlpT/+S
         sx1g==
X-Forwarded-Encrypted: i=1; AJvYcCVBEVC/CyQtCqB5NqJ6xQI2xYgvaucPqToo/8QuZMOtCGZYflLf5GrYl7NO05erutN0EPrhmR3L@lists.linux.dev
X-Gm-Message-State: AOJu0YyiTy1lMNkdYtphBuQCfpl4dKl5iWuGVJ73zG+/5plpq1cPLkaU
	P/ZlG+Kfx/2U5LEbgJrisXV6QN+WH45/Ugha8l6k5dbuMgl5hyjtgIullzGKNA9eVgk=
X-Gm-Gg: AZuq6aJgUbkAKuVYoKN2ucPAhjYMN1ubz5Slp1+IKLQ5gz30plryYoeEWRe59n1G+cE
	czFKY5Z0Pj758sKN+VFgb47So6eXUBbi1m/wPbeE2vBE0xcpuaK23g6Ggm6t4bMwZcGXnGQOGFp
	cIRIUuy2c/Wrzrq5nrZyFRK9vdDxbw7jagEW89ANRCG+/jKT0Wx7FZ+5tOy9Yjm2bsvVP2/hgQR
	xPvkmAa/NkivTq2peUApqjOYrHmPFPsdWYogWolhuksJOLIyyTkUCI9CCVWTVzgujoGAQK5yj1D
	yHRSSqsxUvynrcUAf2VTc9UZ9C4X4NReIe74TpmBn9Sxc+Xf1FF6QD6EGQ7VJjqmBP41CL59ect
	kZmT7mDgYHve+kvDWaDl4Xq5new8IsdfZ9X9k9eGSaJedo36P5fUO3wzPDyZUpbTp7mlYXQCpqs
	j30bxjV5pgQBZFed7IYQ==
X-Received: by 2002:a05:600c:c16a:b0:47e:e20e:bbbe with SMTP id 5b1f17b1804b1-4801e33c332mr298525115e9.25.1769067314132;
        Wed, 21 Jan 2026 23:35:14 -0800 (PST)
Received: from u94a ([2401:e180:8d84:7ad4:271f:53a4:d001:6caf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190ab96fsm175958745ad.13.2026.01.21.23.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 23:35:13 -0800 (PST)
Date: Thu, 22 Jan 2026 15:35:06 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/139] 6.12.67-rc1 review
Message-ID: <ricqscwhc52worlivstcvtmc5qnr3ezlbauhlpxjhp44wu6wrn@6j3nsrx4fs4h>
References: <20260121181411.452263583@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>

On Wed, Jan 21, 2026 at 07:14:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.67 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes on x86_64.

Link: https://github.com/shunghsiyu/libbpf/actions/runs/21221602824/job/61107573550
Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

[...]
