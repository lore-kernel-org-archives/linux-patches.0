Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A975D38734E
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 21:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788210093; cv=none; b=t0/V33PlN4B9FbVqFF0mtyUIb7c2vPPG9UTbUkG3buHmQ567+1suVd1mr4t0Lch3aF1x0LH8xluwXlo4gAamy8ugTY7nSoJ2h9rJGlOMivdFNlXgNtkRSATZzROPP8BnYBaXS5y/aOutVsUnTKLPn8sECMQ1xMp0ODmr+II4I8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788210093; c=relaxed/simple;
	bh=pE+8eFdRKh1hGGyR4Z+bhB2cCRSgLo/w1hS3iEaFlJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uvEU6NoFDcrRlaTBJrGLpmJuNc5n1GVSgY//ORixCMxYcAE7eUz9Q1bOQyM7tlRRa6SpyJQbq9L885R3jbN1CTvvEeoe8hxduWW8CNNX531Pk3QL6+kURV8M1YMXoMG9TyJa3mCXEbztvwZU4YMo8hJvluiR8owEEfw36Rdwor8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Py8wdam6; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Py8wdam6"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-499ac87c92bso1749235e9.1
        for <patches@lists.linux.dev>; Mon, 31 Aug 2026 14:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1788210090; x=1788814890; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=T16UHF6O50SV9JqJ2L46KlCjGiQzlMBW+cyH7AwVLTc=;
        b=Py8wdam6m0KDiDj8WrtNHgGty8pe2qjd7j0SRPd4aKzpq0rfs9b6u0LztGKTWTuT5P
         OB1nUIypnonCyo0+5Y06pg1jNqq53xsYTsidotQvEmfsPgUgV+uCqxebiGbthHBuYJg6
         2JxqJZVDYZ0ANc4VqOuzqRtryyBg1v2vN9UOWogcxkttP33Sp2Iyz+/xPQqKFlaG7eM9
         8rlG9E+qqWvoDEhkWXa1j6EiXwDzFBm76hKahVuK6Gp3/re7mtVQMVuu1RMkCwDXAk51
         kHMmiG0RMfd+/hH127AZEv3jELwEXwohb3u32wzbNZ//zM6fo0trakL5EerMaEk+Vx++
         Xb3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788210090; x=1788814890;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T16UHF6O50SV9JqJ2L46KlCjGiQzlMBW+cyH7AwVLTc=;
        b=JwYCOkU9rUr919LC3hL+JADiFvyOFHFdRpgM7RsumRjbSmWISxjqC1WbLHBHPFcA/x
         rJG6Cz7ZCWetgK3hec0WLs9F25aH0Z1Ud+mHWdMBKL6QxAUzkMRHrL64auzTrx2qfo4P
         SMlUmW12qFEjipaIde2DISc2jm8RZEkpCdSuTGPlnz6h9FNZ1voGXWSZfLyykOc264yI
         IubSraj5Sz57BCoQZNMQi0o3jyB5d3W6tvUa41EbVpa4jTGfppWgscQsHGd2DMvNyaog
         dNGlRC0YgAMFJ1ORUunnLoymF9MAiAvhqcloi+d93rOX8lI94J4yiyMwd4jj+mHdtxJ2
         3lmw==
X-Gm-Message-State: AFuF++lPq1GnirQY/gSjwc75CLl8/eDRMDjDXpcpu/kG5r73NpbKet8N
	JIcBjy97L+01XcgpHmV33IVfRzplsx/H0RXDYIKRkjvZhfxW9qXI3hY=
X-Gm-Gg: AR+sD10kXhvJr4hrMYNzWZ4SkBhQ2J4MniYMJKsgOqx8BAjFR46Jih+IGRGv6hkrbG+
	zRFBA8MXrUSb5JAOUqUW/kLfUyTKp7F1rsb+h+ulltTS69she3Z/CNjKkUWRZN5YmhxVhrn1t8q
	KfbVY+j6Y4TOq2vEVxN6vHNeVJULToLFvi5xw1C95CZV92eoYq3lrFpfu9vBLp2y8aIMLGZMUPw
	IqhxjVb7/wmTRjCZDN4pdcnEAMP9exRySbUhmvA4lqNGHNqEjN0btP9lMx1U5FOd+b/Y2KEiLG0
	o2vL69D/RBvNBAfCp+lzfqXyoEdnKDrhNimEcqlWFHbHI7ZdKEjK23YNi7if60b1Ei7IywzfpDz
	l8V5964DFd4kZHhcswJwb440IxCUlBkxuGyaHUqlWad9BK2QHNQumrcHnrOM9s1EAH5ITQ15kWf
	rVNxUM4hlJdHntJc5vYYmxAk1ADLe6jkx+k7Vpol4lByNDeGAUvh9SQQrWvC2JYg9B4p6lC0CR/
	mWNvO/Ti3HLD8em7JIEfWunJboUKS33z9SZF/A=
X-Received: by 2002:a05:600c:5490:b0:49c:cf18:494e with SMTP id 5b1f17b1804b1-49ccf18498emr290412295e9.12.1788210089521;
        Mon, 31 Aug 2026 14:01:29 -0700 (PDT)
Received: from [192.168.1.3] (p5b057bfe.dip0.t-ipconnect.de. [91.5.123.254])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49c5a903eebsm196381175e9.4.2026.08.31.14.01.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 14:01:29 -0700 (PDT)
Message-ID: <22743da4-c97a-4e89-a43a-31ef43bd576f@googlemail.com>
Date: Mon, 31 Aug 2026 23:01:28 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/91] 6.6.156-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133359.468089036@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 31.08.2026 um 15:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.156 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
