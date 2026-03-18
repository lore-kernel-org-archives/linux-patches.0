Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D797733C50D
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 16:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773851517; cv=none; b=tn1P5JqSkb+0v+oJP2uTe4Xp8O/NINWaZfL2v35PUW5RWCgG8x9INGzXpGczdiPtyY5mepm/TuoHrX8P3n8ga3k30qpFXIQiMGBYod6r3ghN72eoTTWoGMyQbY+7aa8rGiZHl2EBwRHp9CCW/kSCztG0ui7uvTXxk5SOovO7tYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773851517; c=relaxed/simple;
	bh=UpLXNDCkHulKeE+atXxIvdN4wuosQRXb0v+s/5Tsa1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KJdR151u6co+ea7iCnp15VeQh1ajarRrEC+a/C1GQCdcMBSpZ27H18BrwucISorGs31esMAqZQXFI3XTVrX5PGK8Dy1LsNWcrsH53/gXhnow+HWI7oQOhCk4fMf6sDNZ22U00mcX+b60oNI0yvmlyoWQaMA+VXGJziDcS2geK1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=ihiUdJTO; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="ihiUdJTO"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-128d2e3074fso91763c88.0
        for <patches@lists.linux.dev>; Wed, 18 Mar 2026 09:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1773851511; x=1774456311; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4jicqe9EjF0wYf3WWl0C6UzpQQmvQ1pA9LCcV5nPnMQ=;
        b=ihiUdJTOgtxopEH7KNt9jPr738nv7V04nYO/6Lz8LTJgQnKxKOw8gyNWAY0rbqBXHt
         yefj1KhmlOvdWGZnRmxNXCBLSLn9mSHMqzV3uVIWJ2HyCjE+sSSQ2C0Jz2QIKjirm4kZ
         uPAdnjtsEompelsa0A+5oLii7a/mz/V41Px6c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773851511; x=1774456311;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4jicqe9EjF0wYf3WWl0C6UzpQQmvQ1pA9LCcV5nPnMQ=;
        b=QKLRYxQEiWyjwco7pswlq2UMczFOG7S0J1bR6rQ0nzLigDO4dPj/Y14n7u/CekTwOl
         VV+FgIz/IjmS7bsW/y3yYf0gI/uop56frcHfzsD3+fkdxOxIndGO9+vyvc4KxreYDP2q
         hTsaZ9EnUsVtK0V1oILC/qcj5ZaXk600gmCigTDn1VmfBfmqVpjKSCPPONvVNLdpbSeS
         EfgzyHAeeHV8wBVc2B11xaZKjnGXBC9oof+AkYvBOQ1FWXh5lAirzEXV8hu3yoryKaEI
         q9rJ5AF4khfWLYp0I1tIfoL5gzhU6fsNPvYTMwfflHyzs91yzAzQBv3RLjabgLUNUqE6
         mrsA==
X-Forwarded-Encrypted: i=1; AJvYcCXkiZIsKRg7kNoCAktFW6IZoF1Q3orGX3knM36T2IAukV0SY7ZnMeZ/AvSRh0cx+qjW733z9TU1@lists.linux.dev
X-Gm-Message-State: AOJu0YyuUYMFeuHqkOv/Sv5+AnHcjxWs5wpx2nlYGadoB4bEgFZaEgAA
	Hngu+AH15WyLtmjg6wTuVpjvsd2m/daFFh2OvNhcQKJpy3SXlDrzZU9RX90fyOS+kg==
X-Gm-Gg: ATEYQzwLcLBXzSt/8MYSvK6EalL9FeWNoKV7ZI5a2G27PYXr0Kk6hGm6x7P+5O3pVWb
	+S+7KmDU72gcb43qOmr6yvHiL0K7i/wxOxrDL32HJHMsObGYMg2xtVq3zIx7jyo2l9ZZ2y9Kfvm
	L/L5G+I+ATprq0kDSEpH7Ur/sspZ4eAUFFDYmd9njquNdRxEg5BvXolsbM+WilAz6wjMAIQyp7O
	FXN0+Fba8PQaFGrq9QOv4qEYBpOG8hkQw27+Dq/dchY0bD3KCEtm5/a3E1Dqk1Q/0Mf23KzN5dv
	+tAOgf1BbfdoQghtTs37It++cGVbH4FFD0xgh6PoxQ5HBBBM52JLA+K4kBBkKipEB8cxkPPB5bg
	x+3tphC5ZRPbZcFKhQpRYKNa+0zvvg0D6G+hfhZ1R/tpAsytxn5RQ9wdWs3aCR0Dats4CTmbvPb
	F8Opx8ZiklzRBhBS0+K0dcgB1EyNwJEipA0UwMg3VfX8BOzsrn83bPIxI=
X-Received: by 2002:a05:7022:309:b0:119:e56c:18ab with SMTP id a92af1059eb24-129a7146ee4mr1809003c88.19.1773851511406;
        Wed, 18 Mar 2026 09:31:51 -0700 (PDT)
Received: from fedora64.linuxtx.org ([216.147.125.151])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-129a723e246sm3891956c88.3.2026.03.18.09.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 09:31:50 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 18 Mar 2026 10:31:48 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/379] 6.19.9-rc2 review
Message-ID: <abrTdL3xp2sqUJWh@fedora64.linuxtx.org>
References: <20260318122547.233850204@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318122547.233850204@linuxfoundation.org>

On Wed, Mar 18, 2026 at 01:28:05PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.9 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Mar 2026 12:24:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.9-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
