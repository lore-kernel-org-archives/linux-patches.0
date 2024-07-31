Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBDF45023
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 19:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722455230; cv=none; b=uxmhCxqWq42lIqD/FLrZluWcTrC2kN16xY1JichURyu5K3NK9Nsbbl1RSHgLdqtAhilvXrlpejOaxvtgcgWYYHxckTpj1+KlUSQOlzXtzn8VUiuFKgwTbIBgRQrtAC+BD5+18QkeM0uZg5znvvYDWPWCqkkiNRnnnQTuR+qqkS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722455230; c=relaxed/simple;
	bh=68IEEl4T4i3Q+A1hsoS06kb7yEO9aKYPzH5dciEL+IA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uibjb7nMlmWUGRwqg0E69L5ho07JmgNtd6egswope812jUSdUy5y/v8WB9uHHkFap84yu81zyaIPMWFRhkgAPiVV1/rvJS1qDGAwuvreVd3r7iIHJ8hM1KJB7H3nQ9Yi5Gq8ncQAkXBYOLqQgciDSs6IschpiaA0YOEh73CVkoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=RjdnMroj; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="RjdnMroj"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-81f83b14d65so274123439f.1
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 12:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1722455227; x=1723060027; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L9qmnQ6BfkDIeZVz78CLRQGm70nI1Qgca6NQE0QO5TU=;
        b=RjdnMrojCrFQx73ltXhaBjEEHKFzgphoJRouhJLNkNA5K0xJTSWf9BrAbgJv6RJ/Eu
         tAG7qQSIcgwSODuIiNePbWWGVHJnXO5va7xi309kNTsqfNLO6qbHb2B0d0F3NkkeDEfV
         3bWIRTt0GbyyhhRBzprKj0ioIv6e+6a0o3Tqg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722455227; x=1723060027;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L9qmnQ6BfkDIeZVz78CLRQGm70nI1Qgca6NQE0QO5TU=;
        b=GF82lFWjwWG/dK9rfiIPxDfM66n9IGcDlsZ9DQ6J2qVzPV02tZ1gDu1a6IBnEuTwg0
         fsEVK69W35Gz2zuBX0KdRkuPjqXDXS8aDQnTv0aVYqtvDF4MzWnOeWSGHVo2V8/RRZkc
         bb0bCI+pDy7bxD8O+DSAvcqxtr6DOGLE6Ej9yiRxyNiL/yxh+LJHr6saNB8XOX8zSmHB
         8vea7SuSwX3te+0s4c2QLhD8nYHTh7ZpT5Wo0MsTLtpJJgLr62H+za9Ka9pfuyHozGhc
         uvVF6DWLE0br3gAx0KZqG13OFJVQaSQHgOwxAK5De1694bIvbw9ppmfgP6PlgjMJ63QS
         eTnA==
X-Forwarded-Encrypted: i=1; AJvYcCWFBwmbjTo/mpBF0ohIIq+mOrxesRbxRNddtauLhyLicqo2pUyqR/rY1Zn8iFTbsi5J8TsM+M8sbyiRPYUziTs7P6GOh66t+g==
X-Gm-Message-State: AOJu0Yy7GKHhRpvJn5To7mX9TOP4u+v1YS+lxR8mvMtC89W/hqgblwPs
	B1KfdRRAnoCd68KeAfjUg7bIqpNGdOI+Qqp5KGB8/m/ZV+eqU5vzKEJlE1+m+g==
X-Google-Smtp-Source: AGHT+IG408dxXKgXzbPbvVUq8CBwbTdlcfEckKAmt5cAomdh6fvurEijpX0Uy9o21Yku/co4S8HQqw==
X-Received: by 2002:a05:6602:6406:b0:803:cc64:e0bf with SMTP id ca18e2360f4ac-81fcc0e8c62mr40513839f.2.1722455227582;
        Wed, 31 Jul 2024 12:47:07 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.171])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c29faa83a0sm3348439173.55.2024.07.31.12.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jul 2024 12:47:07 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 31 Jul 2024 13:47:05 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc3 review
Message-ID: <ZqqUuZqqq7O3nLbs@fedora64.linuxtx.org>
References: <20240731095022.970699670@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240731095022.970699670@linuxfoundation.org>

On Wed, Jul 31, 2024 at 12:03:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Aug 2024 09:47:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.3-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc3 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
