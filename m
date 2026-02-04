Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22BE39526D
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 21:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770241175; cv=none; b=NUeb7y1Lg4WhKLUXpXRc+HffYovizD/an5JT/QJLCHq7iAhhLRuGzId9BM/m4Axp1uNWo3lO+vZaO0V/y779CsoVcfEyNK6HtsipKCJxeY1+pMWBn/nPGj3QLHU982M5NIoMKLfJVqGxeGsuvGXdOSZi17Dd1klUPl8HKqZybPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770241175; c=relaxed/simple;
	bh=yIyBO22gdX+03XlD2vJu6z0wiYLNMKGiocjqRG5zoYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ttMXAV7kH7TLGjJGzk/uvW46Er91biMfQJrxAoqDVD0dwMugg8h+DZsUf2ab6p1cYYlaAOMYrZrfiYkNbNFRKBm4Y8fi8uXjk5mFFwiPQ2ZS6b4SNK7aKPRMl1Fk0I4873MwpkX5g5FmQMHEpMY4xbifiW9KNHarD0m8baVpTSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=ddOL+wUY; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="ddOL+wUY"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2b740872a01so404511eec.1
        for <patches@lists.linux.dev>; Wed, 04 Feb 2026 13:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1770241174; x=1770845974; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IqdmuWK6GfCtv8Zt1a9cnHoLg2M8wAjxRFOas0xgkbY=;
        b=ddOL+wUY8lSN+Wpox963hYegukybWqYmUW6uKJXFkLYEAJITSPNJYFNrkwJkGZrHIi
         ZePNFfE3gaYxfevZ535IFU6SuN9aO8zvt1VbUEn2IF8m7Hqzldyzy1ujydd0W8ygT0bI
         qlQJDlFFrH/tj/r4SwIgZI1+RPZW/dm7Cm/2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770241174; x=1770845974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IqdmuWK6GfCtv8Zt1a9cnHoLg2M8wAjxRFOas0xgkbY=;
        b=Y0Q8oaI5eEFUhUzA2B4GDIjMU2vVNRTB9hgEjSvosrT8ajtru6tvYNnTDiwbAe/Ofv
         PqIW+csiFg2RtVZsGE2tAWJ6m1zPApzV8SvHZRMgu8fCDEQ58EAK4ppZnG6aLsQAIVab
         Nlph4fACImVgIxWV9NtynjO1WGC8JIFxDif1Q2PexCNKPxMpSAEOj6GhY6PT99lDKIri
         RYRL5QbAmPMbiRJKVEUDQqRgHITcjaQYpMHyMMU7KEm5EeeAt6lwnpFjeh/TnKTnMKFK
         idR9w0dOaqUsAaNY1Jd0Nf7sLANTcndGqye6LR/iRwG3vu6U1tS4DvNPTqS7eW2a9bDQ
         pZpw==
X-Forwarded-Encrypted: i=1; AJvYcCWS2pFkKYpDQoA/76I8EBdgfMXgVYNraPty2ns6nGnAyuiplJiAQJHPGgqKAlNsGllQJ2P/fmE4@lists.linux.dev
X-Gm-Message-State: AOJu0YyxVp3Q7YJUhBteDhvMiW/7IbRsaPCbT8f9vTwQK/k8Dj1RX4c7
	Efrhp8WsJAAUdjToUnMqnhJaG1oQoSZrXsgNV+FNYmstZZo8xcqVCgu6S8lssmNPPA==
X-Gm-Gg: AZuq6aJvfKKcTz40FgYxer0d4M69bqxtwRNsqNknQwgWNq7o5tbES/Ha/57v4+kl5IC
	LwA+50yGuBMcPW8ucy++rGJZWmBbhXdwnTqUAyR5nRuQ0MrTXQ5LrkcP9c5Pxp85RWnIm1dABsz
	x+2a9mQA/jSX9GLwyKRUAAjXyFAIqmH2WXFssak3KVPYG7LiSzjzzliWl8mKcwCkUovlp/Eb2ow
	46/fr5Wmig2/1izHtAEO5bZzHtnk+XtK1MVrmUbqxOApEVgdihMlzmRN6kVNz128Hhteu+H8wQY
	ePnKFKKU4Wz+j2fSLezHh02v3R3Qz6pCx7bHLApb9+BvmPKjz86Q5IKDITkhCfkjVD2/29JNqHG
	uCobzbieIfsO9R8vd/tkuOMc3okb7dmbody1Utp14M0PPvB5tx4cEm+98JRQB0HSL01/6t0sbax
	c3SAHyC5y6Utr/XQXU04zGLelDOaG5TN0=
X-Received: by 2002:a05:7301:4b03:b0:2b7:e2db:4a14 with SMTP id 5a478bee46e88-2b8329dfacbmr1949567eec.34.1770241173961;
        Wed, 04 Feb 2026 13:39:33 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.121.74])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b832e1299bsm2540989eec.6.2026.02.04.13.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 13:39:33 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 4 Feb 2026 14:39:30 -0700
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
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
Message-ID: <aYO8ki5ZSu4ff-2T@fedora64.linuxtx.org>
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
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.9-rc1.gz
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
