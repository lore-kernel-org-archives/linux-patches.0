Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8222BEC2E
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 05:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770357182; cv=none; b=bDewQNXEBzq+HGNwdXCm+vxUk4NuO2x9FEyjc1OXJt0HewvfVgcgISyAQHb8BIQrM3vwTI3lbbGVx5OJPtJCo476/uk53uik09xhZCGFZtDP9UTGlQkJiPKC1GVScTIXP2XMlfvbCAYAOk5ayQeH8qDSVEhRo8URFMmNblcuh1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770357182; c=relaxed/simple;
	bh=zcxwfI4uRfYB10MzYgvsHuxkdgPklYPSGmqS8PjduFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NHd5Z34c3kngn5+ePtwLyBxkHHiyyR92EK+9BYcEB3PIE+COZSgKYwnwHRjZhvwrXgw3i3fpDpsfHIplN8HsV3ed751LOzTHz/TVtafLE32wPRTj4evdCGxLoALshMxM1HwR349YvCZVO/6+vGm02/g/GG1dmeYiAMmBO0Oj4UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CfNA6TPi; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CfNA6TPi"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-432d2c7dd52so1780985f8f.2
        for <patches@lists.linux.dev>; Thu, 05 Feb 2026 21:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770357181; x=1770961981; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=45KwLY90crDx3QHYZBsR7+lDC5BpcTTFrxqVy+EIT1E=;
        b=CfNA6TPi3hWZBcBYQh/HcZh4164HNoEAp/hqQYzjqCpL9wpmQ4q0pzTxEp+LitjMw0
         cG6DoncFNbFogVJMcTijxSIrNLU5pNblD6qPE5Axb6PeR77I5CsagRaGLiu4qk+6MGLW
         wabooP/914g/E1VB1BIaVdM0hyBddfdP5tPyT+E7Oex6v3w/wYcg6Q+IRqGexe49WNvi
         DwENu6oq+EKNZEJwPo1AsWWC1mOx/FyghtkcNP9sikaPcUMZHUzHPw+tCeDGblI1Hpyg
         9tfAIWaXH6PJ17S5EtjSnPUu+dGD6ThML1QopIecwyeQpiCxgHgWHgcRCPc28hG03a0n
         4Qdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770357181; x=1770961981;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=45KwLY90crDx3QHYZBsR7+lDC5BpcTTFrxqVy+EIT1E=;
        b=uy3VbfEjtA0tdSj+V83wqs/JVFY0A3XnUtS08n4t2Xsi6LKRrlT1GcLoGPIk4Hr8uc
         Fr79jbd9AptNfaUnghO8zxFjPrCcW83M40660//LTmr8XdhYYATnF4i/UCSUV9VSHhS9
         2cyaQrh5CDDm59E8HSCHZqMsUHW1b5giaJLDA8Fn0YpiZlwoOmgpZ8pTzuyIyR67IPnQ
         uJm9lVplLLSOmhzvwdv5RJZalPC/hToXPUIlvtLi65qcnhZJqbvncyQ02SClZvQUzU65
         3PUsx/bmQwc74Ld0SmqI0WKj9PjiV0MArIgaKHjRk+bvhaPSbt043GFJF4oApF2cCzHg
         H6vw==
X-Forwarded-Encrypted: i=1; AJvYcCUxR46vRzJohX1R9PPYia1XKL6mHnCusVbzWtLcCNjoOFouWnp4rjQ7joNgsFwoZBj/4CpMFUFG@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6NMoerD/Lg7Ub/U2YBXasgK8eJpHh2bHYwhZX9EwlRXHsnIVq
	6wnvWKYa/rYbSH9HZ4Se0ElvMBhvTz6X+QYNpX3fjCC0/jhybz+ArVmordVfjcoJfQk=
X-Gm-Gg: AZuq6aITyAJw5Q1pf5sHi6Q1vdMgSzGzm2KlAIY45VJ4pyZp+ocK2QE9qWcEPbWEYuR
	5JgFUPF35Xdu2gpuUs0Y0U1UGWM9VKfZi58KgZY7LcgWCqmw7A2Cg1rFpAvCjwpVmFDzquo8+u/
	BXvdpOW9j1AAWQTQYZSsrLKs9meHckm8QqucPmuLhohVuW6P9Hw2NA1uglv10jWVzFQobjKQqil
	tQHRZplNgUpahmxE0E3xH4Fn6XLY2zkcEQvx7FUVQEemtSQgBlXHMRKhBJ2etby/XHWT7RrcuM6
	enHbONiEIy3rMtwaxpfKzM7xNZkrgcNJjc57qsYWAr2fSIjmlfpX7CjLxZ/zmSii/rM+53f71rv
	gCGV7OwMBYZricZcO78wZ3m4x0zsyh45RTHXBO7mM/xsdmJM3Nwj3C5cDvkBqFY6C6qjTFumb1V
	pV0C8Pyejy38V9D+1EDskGboLME4TXYH7qRPM4yMOmQ2cs
X-Received: by 2002:a05:6000:2209:b0:430:feb3:f5ae with SMTP id ffacd0b85a97d-4362938fbddmr2226746f8f.55.1770357181005;
        Thu, 05 Feb 2026 21:53:01 -0800 (PST)
Received: from u94a (110-28-26-119.adsl.fetnet.net. [110.28.26.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4362972fa4csm2952428f8f.26.2026.02.05.21.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 21:53:00 -0800 (PST)
Date: Fri, 6 Feb 2026 13:52:46 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
Message-ID: <a5ro6s4gnnys56hjl2ju5q6iyujgot7ztkpvxa3dwabektjori@2qctvmzar2u4>
References: <20260204143851.857060534@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>

On Wed, Feb 04, 2026 at 03:39:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.9 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/21724288947/job/62662113823
