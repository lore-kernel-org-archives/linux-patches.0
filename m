Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9424D1DB95E
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 21:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736976567; cv=none; b=PWr2Ksbc1P+mFDYtvsi1UdD4dNNP0YC86LbZfgBC7P8BXAKDw3RjmOs6enzMO/AtTu+rnC6aCUQ/3y+QNmEFmeWBwpNWI+MVMbYxvbMWZQfw+Q/twI/I6GAykN2vEB4mYbkW8sdYCBH3c2V2XiRETHmcyjGjKoJiWOnle8oD8Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736976567; c=relaxed/simple;
	bh=RJn9wLLW+Uqm3UXhw6lKi+ALKeUFLR2ponMqUsUMxF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FBRYBASnYEzlPcUBy5916W8OmaTb25GkuO+CHJ12j8p2hJCwSFpGbwEFLdFBn+GXyHHWTq+Aj6TpcCVt1uaqmZ+HAhFdasx3revc8xz0leNgkSKprTOdXXKUMncBz66uycAVmWoINemmCeGAZRmrGHWFZYUJ7g/SmSvSTP9vAcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=KzxO2nRV; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="KzxO2nRV"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3ce76b8d5bcso1874285ab.0
        for <patches@lists.linux.dev>; Wed, 15 Jan 2025 13:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1736976563; x=1737581363; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NMxRqVKC1OS1+OO5j00J8Q528QAXBH6vrdlisTHHjvs=;
        b=KzxO2nRV+TMKp5P1p8zi071n8VJEqm+fRd8c/f5fBaE9t4CORVBA2cODGIgCA4XHDe
         6X/GVtrH+7MziPBQWH5lXcq4pY0bq2pylKD/faEG1p0s4d6eTw8O5lrF0w0rHh2zfTMr
         B5f+cVJqk8xZxbLNCK4gecSgbVc34FlgU1xVs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736976563; x=1737581363;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NMxRqVKC1OS1+OO5j00J8Q528QAXBH6vrdlisTHHjvs=;
        b=QLnDsKr1GFHS6ZOqw+CLVwTqMJTBB9tV3RXFuJWZXV+bmDAZTtNcuCVTvqP711L96D
         42LHxiH8EdOoWqkWFkoBZrT5klwTDPhCe/HrOCEQtEGYlhCQ3X+l1L+PYMsGXfnLryYV
         k3gaWZqeaa/KXNTMdP6J1+9HRk7fPvjc4qDqPCzuNsCWVrMuHpm6QfpR1fZEyndvzeLi
         GEev9eJ7hKJbgcfhs/5biD4/t7Pu82Gt1kowlJ/+kcfaSeg6Eot4GkyhOtarK12/XqL5
         QemPZEf8fCOwF11rzAK2BHgKbMVSrT5vQI9JpK2bOGANHsnIOKtvMEy16t5NL9cdYGYT
         YXkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiNIBgKk05mlW4LvIMxZyA4ldSNGofwOSdeD6T8FN/bqwExukK0uNB4B5gZTuxFiWfm/JNGj+k@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1jPW5AYAJUkJfaAvsv2tQL/fpAOxPK+1H9hyKT9XuEYf2TM+J
	LvbiAX6i13w4q+QDO9GpmNcOy0OSo/DeT9pSWl5KIx96XC7jZ/4uUYvgulGyyw==
X-Gm-Gg: ASbGncvaJCDkEfRNvmrvLtzZc5HTmQ+rBQ7WtCcbNQq5WRfu3HsKMhn5OYix6LPKMLu
	7mVXKNFvvRMzVQqUKXcfkO4dOPgut6Jzfjgzr0bkb5IXMXWGSivFitlUwdA1xWgEjhdDP9NB+Ku
	F1liSsSsi4cYyLfo9zXnYQ1+I8d5bo7uSBZU2L5EGqPRlfxWeQbrk7D/CfXpVTFPx9a2vF8Oxb5
	+ydPnD8RPzVU2eDnp5c89mEFUWVzy3oo7Ykwz2GTc/JF1A07U5IVmqZuSEw//uh0GKr4AHJ3A==
X-Google-Smtp-Source: AGHT+IFg4MrRsXl7cwIJtfpy44aCizX1v4aAPKIAJI+qPE9zX1Qtehd7vvbt8lnNiLRKPOTTvfqDMw==
X-Received: by 2002:a92:ca49:0:b0:3ce:87a0:f8a4 with SMTP id e9e14a558f8ab-3ce87a1033emr36591695ab.9.1736976563578;
        Wed, 15 Jan 2025 13:29:23 -0800 (PST)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b5f93ffsm4318839173.18.2025.01.15.13.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 13:29:23 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 15 Jan 2025 14:29:21 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/189] 6.12.10-rc1 review
Message-ID: <Z4gosZxzAJFF9pfo@fedora64.linuxtx.org>
References: <20250115103606.357764746@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>

On Wed, Jan 15, 2025 at 11:34:56AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.10 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
