Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A8F3254BD
	for <patches@lists.linux.dev>; Tue, 30 Dec 2025 14:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767106793; cv=none; b=jZlEqA1ntbD0PczJ+MmDnm4QT14KSo2CdKNfQ6fY2HwBaEBSWcwcc4+pRvfIRr1IRAEuT0D/vvL3ztulUdXvx5LV4L7Ja6aY9H9luCXbBixo44EXXKxqBbFnWXIn/SiyuMkFHTl7M1nFio07oEeYXSb5uWDMK9CFeanVGoo8YIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767106793; c=relaxed/simple;
	bh=7sdKpaAy4sTaJN/M98wTjdHctQ8WEkEfKF9QXapr7GY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZivGY9TtxHKzx8pSX7JWTHltBDZ6nmIifsSMLpjryY+Nw9zGwbKWjuhttpKMcZvwQaofr7xRgj5Aieg0h7qcHnYakHSZNjJY0W9KhTVK/WGNYzmzYizStYmuxm+IP6KJy5/jKC6feOMes1xfFCZvxxkWlAdgjwAxWu24dRivSYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=EG55UmKV; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="EG55UmKV"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-34c565c3673so5062747a91.0
        for <patches@lists.linux.dev>; Tue, 30 Dec 2025 06:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1767106789; x=1767711589; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uvCtBUBb7964OvygP/IWixIiCy3FZv5fu0b66ANzNSU=;
        b=EG55UmKVVUJFJ2FNAe82yjdiFqD0KSk0iIKJJ4OqsPgLkcO5YksXhZdNgSH5YQEnbn
         eirozu0eZRzucujsIeP1pNEwEapUFTzKhK/6BcTz1tZv7mdw8IqxEV8xVxh1kQE8Lkeb
         xVy6T7ONnBpJLP1Au70tF9vk6xm+kAC8WwLYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767106789; x=1767711589;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uvCtBUBb7964OvygP/IWixIiCy3FZv5fu0b66ANzNSU=;
        b=bMMj+e3We5yzI48H9ydtpnKGlHjrtK6H4K+TptYTVJe5D2qXdIh4ed8mOIDna067i1
         pePs8J+qmP3yo+lJwZaRXej2Z7TuAzON5xf6lI0kTcFVXw6tBxJlyAfeUnUuAb8SYwea
         qbbsJ6hBkROurVD/WLMsP6dcHF6mSfya6xnwV2zXxarXpQulROK+QFAOC/FfIaRRGfyz
         uNDyumEikN+67/CXsxwIjg4u0a8HxjApsOsZqhWTiD4vuq7A/Ss7/o/DUHtd22EwuDws
         Q9VGZlW5yC6R4WWJGYKr7ZWzY7Arl+f513vs2b8OBVUrIbCeqfpYQsWCH76KlIw7mqP9
         LOcA==
X-Forwarded-Encrypted: i=1; AJvYcCXGEya4I0Wrp1+67xoGT0USKnNr6/Uxb+qM3SxWxee5+PSuuVEiMzha9wk0Viqh9IARstcRvsEn@lists.linux.dev
X-Gm-Message-State: AOJu0YxC5CNrh7utUN71XZRHTtIx/B8fT2bWsfDYkhr9jCMmNkmvHgt0
	afjMzO8f9BpHw8tE44pUN0tvaTcHcJ3EFV9UBESZcaxaaVzAIPeHNnwRqH9d2JuynA==
X-Gm-Gg: AY/fxX6MTvjlC6cAlpIwVl+XsmKzMW1Jh/kWQKmPLSPLDC4v0AnlnzUq6h60Vmd3ubm
	pZOhqBZy8iEatFCo0cpqI3IlQ/FTjHbQu2YtKoq5Vo56/oIqIQYSph5WvfKBd7ZyqnCByuBpVNy
	Kf156yE77SDB/LrETArc2BK8QZEds19gwKJkKWA53MfmKOyhYFx3v8NVY9isdVMVejrhQ4Rpwqx
	A0eSYxnBAkpXUPt2T3gmf5SBQ2XApKFyHNFlY3u22Tfc5hSii8mxa4s7qE1RH+V759jJS/WMoTJ
	HSmGCydP9KlY48ou0YQMxc0UF9V7JjrJEdWA/R5/mw1f9YDCIWGHtIHNyy/N66qo/Uu0rOQOoXf
	Gx/FFwrQl2aX0jIaXMatKh0BnjQmA9f6AgBeOvRCQyGLfNswCtN4Ys3snDd6i/a5rXzJOe7yshJ
	qOE859TiTWj4++n+9JecjQFBDbJKecpw==
X-Google-Smtp-Source: AGHT+IF0MxrMPuteJxQzw8e1Snaz1xJCkcZKhSP7y82QMdNPwYWZEXdirCP1n3Yf/5a2E8TlT5kmYw==
X-Received: by 2002:a17:90b:4ccd:b0:32e:3592:581a with SMTP id 98e67ed59e1d1-34e90df6ab4mr30491683a91.17.1767106788770;
        Tue, 30 Dec 2025 06:59:48 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.127.9])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e92227da0sm31003306a91.9.2025.12.30.06.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 06:59:48 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 30 Dec 2025 07:59:45 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/430] 6.18.3-rc1 review
Message-ID: <aVPo4dGaSwUVuX0x@fedora64.linuxtx.org>
References: <20251229160724.139406961@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>

On Mon, Dec 29, 2025 at 05:06:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.3 release.
> There are 430 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Dec 2025 16:06:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
