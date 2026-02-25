Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66F1283CB5
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 07:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772003143; cv=none; b=NQU3qwcIfeLwGKTZssLp5t3ArClEHlCD4VnxeUGf2vNeviig+0KA5+im68JuueLcEIIb/yyoENP3zsT4x89fW+HfAQp6oc5jrqAAGFRaI4x+NvTCrSAwqYQaCh+RGf4ZZJcQEkJ24wxYG+x86FQq1/daxcvrbTOIic2v/TCSAgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772003143; c=relaxed/simple;
	bh=oaiN+3Q6JNH8HN69LB/Dz3Df6D3B41uiZsYqTvO3sQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C5fd1xsMJNCy/CkQdtjlL+ianiXTrNZRhnG2KJxnY+ALiDqy5dHhe8lUakJjPm84mrRbCrQBmy+41KjNCa+5MjVc1v6eQFLl9IOLRDErHIrGiBfRS8dsv7y2TkVVZj0XMhb90oq/K6RrOA6MiMilskZX70ebE7q/g32BbGWhEkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dALNDMaX; arc=none smtp.client-ip=209.85.128.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dALNDMaX"
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-4806cc07ce7so60726875e9.1
        for <patches@lists.linux.dev>; Tue, 24 Feb 2026 23:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772003140; x=1772607940; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=twOtzFU4v1Xv/698z9QHqw7hrH4sKsKYh/GTOoz43aU=;
        b=dALNDMaXaYOcrQA7iz79wo0oHBe3ZyPXk+xlsHCuyrvyVxue3JZRoH+e0K4rh1Wvx8
         hmN9t6O6YmFOvcagp17vtZDb22I2tAfCrM1kx6NAMe96sAhKilrlXBe5mgWbWWbuLQ6g
         kiNB8O5cq9Du3kZhzw/ghbD4NsAkyJin1YHfR/HdljI2Xvck00jjVYLXAe0HswhU0fBk
         xb+6jHjE0/BWnPezye6WeWGYow584d/4xTzUNlJPFdOIvebrs9vYvoE7XRU21bgoCv2k
         WGmMFC+ONbMhm4sn/htsDD6PVZpHyZhzwdObA4yfzG7iOGYJiJK+Umi1cUXfAmOBswU2
         8Gvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772003140; x=1772607940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=twOtzFU4v1Xv/698z9QHqw7hrH4sKsKYh/GTOoz43aU=;
        b=pML0Y8tdS568i3SsMj0wjMmZGiIuni1ZzfKGwteRvUdwHvu7dHL8N1aeGWoyti7KkT
         kDZEndj0G8bu7GAgFQUxvk+1fIXn758JHetAHlRz9TBvWJCJ74Zii9UftV2U2Ivh55iD
         6iugWYuHN86oDzCZmnGc3NGsydZMYn7HCALU1QQyD02Yf7KkcE8fIPlu3UPi2mEJ37cv
         Hm2F3WoYzKXghtpySiOtV7pPc7/6IKjU589KDKzAntD9RnZiwOxGl3lZ3xN2kLigxTZX
         Oyr5i6sUqNy3O1a+9BZOsxIbyynY06LihaulE1XGcLw/2g7Vs2zilYXQYG1V6CX9k2d1
         r6ww==
X-Forwarded-Encrypted: i=1; AJvYcCUW9NReAUDsuKJdGtwa2RZBAsq09lSkjAKjXPibLv8wEZ9GrXfzQamDVMHFHRlrR8emyXsuF/hu@lists.linux.dev
X-Gm-Message-State: AOJu0YyY64TfPmWUJTlGnK/BH+1TJW7shf70Xtmm5JlLFuxknHFIp8Gf
	2O/9TeX+Tw/pB+b/BIASLNZ4PAn03FWk43A4jzX+hB2waClEQIhnkZGPXQE1oZYMo/E=
X-Gm-Gg: ATEYQzyxnRLBi4l3EuaEwITzYT5/JJe21MgDlF/l4+tpGxgDD7ImXZC1qlRpBx7Tgzy
	lCmFN7xPIZd77UQHLNZguMJyb2rlsXq7wJ+6fcyqJhy5BB7nWrzdOgOTfr4egxK+vKRRvIvsIwg
	C+tFqNJkY3ep/Ys+NcF574BGOXBNhdRwiCdaq+5oR2ChkwsLAcqqkcSo2RXGjLgjGQVVmrvP14k
	vMwsmvpM3VjYrZovYE0CXzPFaReDGAQ1f2OjVjPW0v8jwWR5UWz8Rcl9SnRiEz7OXhN4YG8p6p6
	5SQtYhN2tT5Hc80zJ5PCSzrJbxA2nwGLvxVjOLGvVXxJw0DerO5VQj6y/SbXBqWlgJiQSN7m2J0
	i3AOgIlRed/tmRFtDwaJfE+u8EBuJeYvdujqPVH/gAtuv//9IMJd8DAarqlksLeWdLsdypXdFgh
	TS+wr1ikLifFqv1Sl8ynG35bC0KEGFWFACb4FNvwKYF7xgsp6JxRGN7xgSy7yt3+HxdfeUMNHib
	kmsqgF0uJD1k4+pvSMa
X-Received: by 2002:a05:600c:45cc:b0:477:7a53:f493 with SMTP id 5b1f17b1804b1-483a95f554amr244376705e9.23.1772003140189;
        Tue, 24 Feb 2026 23:05:40 -0800 (PST)
Received: from u94a (2001-b011-fa04-7b92-b2dc-efff-fee8-7e7a.dynamic-ip6.hinet.net. [2001:b011:fa04:7b92:b2dc:efff:fee8:7e7a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd8ee179sm12219386b3a.61.2026.02.24.23.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 23:05:39 -0800 (PST)
Date: Wed, 25 Feb 2026 15:05:26 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/641] 6.18.14-rc1 review
Message-ID: <mybfdcdw2sckodsnqhplmjr2om5is46olusfdfetk6piwpd6og@pplcuojmdcso>
References: <20260225012348.915798704@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>

On Tue, Feb 24, 2026 at 05:15:26PM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.14 release.
> There are 641 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Feb 2026 01:22:34 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/22381308704/job/64792250146

[...]
