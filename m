Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F93143DA5A
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 21:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774993965; cv=none; b=pKfAD3z5PvdZMaG3XIiHqGayuRJgWBtEtJEHqtUTnn52ofu5ihbcwrnYVs8CPJwmPDpngtWaC48T82iYzzm1SYr5YdTz1HJCSnrS0UUqDeQW3pEfVrsabOkQJAwyGR8WbNZLm65QyVQHGPzk5FnFKguzvyKHP3MEjg7M5U9Huwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774993965; c=relaxed/simple;
	bh=y10E6H4r7pQB73J7o1hu6oOKr0ve6Q859QkrRIrAwyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dcaYV1QSwHiXYo0kn9Uql8eqbC8Jk9UnWex/Dz+kObhhqv7a51BSoGMHVDjX0xKDY7k+odSg5FXg+Ig0EkETECpGfGS75wpvHdlbJQTDG0r1yJZ9gxCLhOMvHW7ZQB08bP8r6hWNQCpCSrviOs3sfTSBnTHjObhXj4BxbUWU7wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=R29bHFRR; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="R29bHFRR"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-12713e56abdso267059c88.1
        for <patches@lists.linux.dev>; Tue, 31 Mar 2026 14:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1774993962; x=1775598762; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pr+nCOzje0Y3eH3B+Z95VyombtuPnwAQxZrx27WvHq8=;
        b=R29bHFRR936WKnAy+yvXRoT6Y45O5cbKPOyAgV2Nasq3FrLhJwNoa8juEDR0BAZ66a
         D/TfBSrfkO+U5DbMJKFDHmXJ4vbyxT0HAG4bou78FywBIIw/X7NE1N+3ssAyNnKH33A0
         gNSk3vtaW53gFIF+KarrY/FfpXTRlThpo0Qoc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774993962; x=1775598762;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pr+nCOzje0Y3eH3B+Z95VyombtuPnwAQxZrx27WvHq8=;
        b=I2PUhaf9osEEmdmPMOfbfZCG3l7lIKRjibUCatNBOXqBFhHMJGt1IYZnfmfzU4w2Rr
         u/XepWnjaITVxSwlms4fhKVkCJDhI65L5f4WgXPgPnEPXiuceMMm2cv9Pv1WtaL4hjuZ
         BloXzpOOSgk+yETavwOyXzOq2Gc6IG5NVHZ+ri6mtzL8EOaRl3qvYzywbMVejQmtX1RR
         MbWYcK5qapfcLGmn4zY4DrhfwIkSmf88iNq2b2MgI/3yNvKflC9h8GezNVGfd42KDl/p
         Lsxji4vt+6dHUm8rxLw7TEGuegmA9/VztAwQ6mIWrX12sRnccA1+m36Zftdrayf0sbm+
         wlPA==
X-Forwarded-Encrypted: i=1; AJvYcCU+W+s7OlRPyLECd2g4Stsh/gaEuNacX0+OyssN7m0cHVX/A7Ilrxl0en1cD54SX2QQN9rmqbR7@lists.linux.dev
X-Gm-Message-State: AOJu0YwGEXplvJ4YQ6qW+mjQfQbxT1QV803EqkRCDMBfhPcxhAyDS0Ao
	lLDLJApqFhl34C6xtr95MM6UTB7pyDvrdEhIHhMADcCjMBNxcaqKVygK8kyN/C4uvg==
X-Gm-Gg: ATEYQzzwZcR3z2AqOVLroeb807r24RcSB4l4izf/Zja5qfgS+Ttz51t1l+C4AndchHC
	9BZrymoYVbFrAnCi4a/hqVCuOkqfBo8zdve2EEWvqK1brO4K4mhea4234Vo0oI4k3ffYxh9cwyZ
	bQerhqxtWabvWqtCA5IOoPs41+7uFNReUuBMepc3YOFENwU+V5ik85t97o1xHigG3P9vXKzKgLS
	AhwiiIdYzs/2sB+V7Juga4nkSiSF9JMYHzUF5iCW3PEbIMi6WW7qu1kOBPOljvbKpsqq/yB+HPW
	v5f0DcudXhnfDXhC+c0erhN4sqfvZ79R9VsHkMJk7QOvymuAWmcpCDUjzaSevTmtVPlqLho/fB5
	BzzylkHMnnhnFsPSGdNflUnoU61cz2jCvw6MeqbTsQLztXLtLXWK/tyoXtGSB4OF7cM7gvAeGzx
	ou+gixbxAmnVSiciLAnD0EE8X5XvUheZ++U8NSFeRyXw==
X-Received: by 2002:a05:7022:307:b0:11d:fbf1:1e27 with SMTP id a92af1059eb24-12be687e353mr498165c88.19.1774993962313;
        Tue, 31 Mar 2026 14:52:42 -0700 (PDT)
Received: from fedora64.linuxtx.org ([216.147.124.7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12ab97f6994sm11172991c88.8.2026.03.31.14.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 14:52:41 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 31 Mar 2026 15:52:39 -0600
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
Subject: Re: [PATCH 6.19 000/342] 6.19.11-rc1 review
Message-ID: <acxCJyyBSuje85Cw@fedora64.linuxtx.org>
References: <20260331161758.909578033@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>

On Tue, Mar 31, 2026 at 06:17:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.11 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
