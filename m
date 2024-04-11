Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692B41C4C5C
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 15:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712849902; cv=none; b=i8W3jfkOzlmW2g/Wkx6wmN/w5a8CYGsc2Ya6DHv9AMDpUKqc9ylMQYIHvijD+1oh6LtilYa3/ylXdrcvK+JwstA6eJYGZqAj9DhB6Nj/ghqM5PZB+oMuBjQH6TKR+dBx/L5T+tWe4TPFUazdjQm6z7IREThiG+GnrNQ0INfr0d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712849902; c=relaxed/simple;
	bh=c7ZbKM02ozoInY9TLL5WaNcYw6jZxIxWCpv/8aHKlWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sYUj34NdUd6AhgkYuneFY99zXt4+kXf04S8mVHUV0mTvXraPjjpN461D9mFm+mHRaXFFQD7rijszOQzuhJNgFkqiZFD+Ci4/y0sCZk/MffPNNTSG5Kul8Iqr2Hpix/uVeQvVBoFLHh58qCtSLPwKjnU9ZrkUFpoVeLQQdhB1pYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=NwhCcvsB; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="NwhCcvsB"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6eb5310e9fbso293284a34.2
        for <patches@lists.linux.dev>; Thu, 11 Apr 2024 08:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1712849898; x=1713454698; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SQF8pW0Q5UZae20gtyOFCGbbxCzCiJFtoc6YhdkZSao=;
        b=NwhCcvsBOWbYIogK+bHYUNdtRsmYRE9xcBgQMnWYSspTRz+oFKf9Lbyz3HWjYae0Uc
         5SkwZWCNIc8VmP/2bIxS5n45mWSuhOLg03UBMz8pfYpFgN7h4NCb338C3uZnoUICRKSO
         BOsidID4EtWozs6jgkjvqjkXYIggwJB3nni78=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712849898; x=1713454698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SQF8pW0Q5UZae20gtyOFCGbbxCzCiJFtoc6YhdkZSao=;
        b=Y6a3Q5sOnw3pOmhZc55stN+w4KuPGqREofsMTcZv7K5eUDI9Lpzgo15WWu1ClWPhEn
         BOv3AvCDOcOvNDUldo2BrqS39p/b79Cg5LoMXms92ciX3YeB1j1R1vpTFP00znrBH37y
         0fwikwe/ZLSROMgkCjUFK4llcqGAeStRdFcX9Rw1ZelUFtWEjWCJPMsHxyJ4vG5V27gw
         Bb9CS9ymfaeKeagAPsWXSBeyQ4vT3ZUIzndoDRcnYzA1S/ho+ZSDeFsApHpRPPaW6fAz
         TPqnQN+SeBYjqvGRm7W/gnb9jE3u7QH3cm5Jw4HkxOej99lAM47XxrMBm79XaWpYo8rY
         kAwA==
X-Forwarded-Encrypted: i=1; AJvYcCXhrglTiY78C/T+e5XMRdBiU2nPzMl5MEvqCFDOcILIafRkP3I00cvFnuxWsOKTjf+ahAWzyDr7xPLDDXag86YI6Gkgp2io4A==
X-Gm-Message-State: AOJu0Yxrk66BXJYmsPBmokYigQ3u2awz0YJg2zzGY4vJIgey1uueZNbR
	9ogwviGY5vncUh51UB1Ve7YucbmbqieI95JykvHf230D5JVXbWuK9heqt5BQTw==
X-Google-Smtp-Source: AGHT+IHuutycOm+XsRHDl0LWcOxTy9NbRP7BpNLELnhVE5UZheCq3gAcUJShOSLCoSLKJdlEGR/O1A==
X-Received: by 2002:a05:6830:4d:b0:6ea:1189:de3c with SMTP id d13-20020a056830004d00b006ea1189de3cmr5851360otp.34.1712849898444;
        Thu, 11 Apr 2024 08:38:18 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id q14-20020a05683033ce00b006eb507d4257sm238520ott.33.2024.04.11.08.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 08:38:18 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 11 Apr 2024 10:38:16 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/143] 6.8.6-rc1 review
Message-ID: <ZhgD6FVwprj26KBU@fedora64.linuxtx.org>
References: <20240411095420.903937140@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>

On Thu, Apr 11, 2024 at 11:54:28AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.6 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
