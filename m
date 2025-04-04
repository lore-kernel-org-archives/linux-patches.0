Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D4A19924E
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 21:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743802755; cv=none; b=oV6zcroaXf4v6jgTu6Ljrg/p/AGDSMkgHxrxZ2ubFeFfFlWpVsEgb4frYSxvrv+mJ3N1+q5b5NHlEylOmo7HApvVEI5E+pNRvmTDhhR2JAzqRWDst3oDt5OqJr3Ufy9P5bW6TuKPT8bCmcJDXut2s52WTqR+i6Vas7n3hKKqJRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743802755; c=relaxed/simple;
	bh=QABGtXWp+PTfrHwfQTr0E/H0tw1hzN30Yy/M1wIGo/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MxbwSv4ptGfw9Iz0tOB9vwzBBqEBFrnBT+HteVze/Dnkna6J+N6I7b6a3yh0FJvtfITvicLN17ZoKyaqr/Vl7aYpmDNHM/kTb4aZuajQ2hHFmY2CBluuTd308fBHdkGkBwHv6SwoqRAmMpNmxmz4qkfDqSj9jU48wr8On76sF3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=EENrKAen; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="EENrKAen"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-85db3475637so106518639f.1
        for <patches@lists.linux.dev>; Fri, 04 Apr 2025 14:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1743802753; x=1744407553; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ENJyUpYAa//xspw6u0+Ksfea+gHqJHq1I/Onh0TI3hk=;
        b=EENrKAenGdH21TzYNTFIR16V8/leg+HimaGHgYKreMUJ6jidgSqdOlPHkLwgkn4jF6
         xtN+xS8K9VcWUJUwbTwOwVcL13PsFuw9NZmlzpxYWA8seBwGK1zORRuUiNEVpxY6+ZBn
         t+nGXbn3OYszLHnzS2zaEqCJLbUqMkoTQo/bM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743802753; x=1744407553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ENJyUpYAa//xspw6u0+Ksfea+gHqJHq1I/Onh0TI3hk=;
        b=Aafn5b7tppCm88Kd9uQ9AciQO/DVvhI+t7OqeSN/wlsoGAkYi8pNeR1y5DuWpXwpgu
         9k7po0WilQVc56eY2Jq0k3Szg5tUL54r9GMzoCDSZ4o0UmSKGN+7D9s3c5ZPrhL1nNhm
         V7hboK3vUkYIIPg4snVHVyaA4DvzehWudFtNWwILTQf2EU9qLBC+QYrSqEzNjnb6kMYU
         a/VEFIZQA5G09KNsaMFJr21rvdZ84c2rHWljT7bLM9J5zZLA/gGgLt5Vnd40nFsinSA8
         mZgZrClilQB0yDf0Tbivh/xKTd0OP/RkE89UvQSjscJBCTKsHZbWKirsGjreSlEaYHwP
         CJgA==
X-Forwarded-Encrypted: i=1; AJvYcCWZ6L8xoZSgKKGZWMu/hjwSBU2plPf1Lx1Ufz/yLk+rIeApELL6IuFHA80QNEMgDPQecU+URceZ@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7gC5LNRAdxnem8WQViP+LUoBRWcw9tWLNN/vTslWTa7So/XLN
	+0s5HG63X29YL/eLN+WO6rQg5pavcHtgjLNE822kB1FSBP6CwsP+cjOwesSXXA==
X-Gm-Gg: ASbGncvDEMB5TCKsChTbjKCZbrM/hMX3aFepR/8IDEwP1KiGLuLESQoqzo0gI3LS4T5
	Ke4Gi6VMefTW/zv8JqkNZ/wT9XiGr+gFQxV2kitrvMkoxRm7nBLo9oY/39Mw3yYYtbN0hWYJvrP
	IFRytV/Mqlrcmrl7UkCzNKg1bOKueNfOfQBM8QrvHMP7bsdMkyF/yEC57a8jBEuEf4Dl2isEZTl
	rEtwT7cGxF7iW2l1DdenhPaiDNzB8YcQufKvbAsIMAswuOfKpTRw7VZGDiH+2zD1Hw7S6GPr8ZY
	BcI5+mFs5qHOzv2jenAr+nt9vI9Bb3l4c7FEkzpdOCMaU8JtpatptVvw7/bJBQ==
X-Google-Smtp-Source: AGHT+IGbcf6tz83rGLyBLgsZksMjls6nLeRdxxAHiAxj22AgIjPSRs4Lq7yykuQU6PSnh2BoV0s99g==
X-Received: by 2002:a05:6602:3fd5:b0:85e:16e9:5e8d with SMTP id ca18e2360f4ac-860ef3c3fe5mr1303615639f.7.1743802752986;
        Fri, 04 Apr 2025 14:39:12 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4b5d3f057sm990829173.113.2025.04.04.14.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 14:39:12 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 4 Apr 2025 15:39:10 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 00/23] 6.13.10-rc1 review
Message-ID: <Z_BRfgnJ_6gzLlCI@fedora64.linuxtx.org>
References: <20250403151622.273788569@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403151622.273788569@linuxfoundation.org>

On Thu, Apr 03, 2025 at 04:20:17PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.10 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
