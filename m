Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA68179B2
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 20:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714509607; cv=none; b=UuhT/HTKcdpmeBRjSRWOLF7c0xbuwV92G+1Ma6nl6TiHVRvDvH6+G6oE1Vk09Xk0cjnZfTGeNgFpW/NAEqn1fqmaDnXSBqwcChMubhpkoYzPl19oGaVh3kV4IbgeMZWWuDCMrSCY+Sc7quCLxuSDNDR4vrP47ElZoDCz20t3Y4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714509607; c=relaxed/simple;
	bh=oQSngsPwHpqjPWpk2CQtdzD5TSEeud66qrlHa2cPFsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQr/pWblMAIWuTK8k97E+JD267rE1MWhmYlHRkBVC1e0UzBEysW6gzQ55WgCraR5s+GkKj/2T2dFxGiJlMkXBYkGP5LO4NMQwVnJ+XecApQGzezHmmgiag0AyO6ScR3iUwBpzh2uErBs1Dm3bOPDqxxPymGVQxX4Jv9T0AWalrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=ZDhijEhC; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="ZDhijEhC"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6ea2ac0c217so82288a34.1
        for <patches@lists.linux.dev>; Tue, 30 Apr 2024 13:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1714509604; x=1715114404; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2YYgSWxhf4zOPIcEbuWf3i+tS5g0up/+LJ/wCKYsmNQ=;
        b=ZDhijEhC0Lx8OMRlUeyFQwiE/lfrieSTaughVk757LpTxHNWz9pYRFOQBADl+mIfP9
         DhZT1ABl5Zr4iz4vDy/hLfSsrKHmP61YIiKB1/EOmGIZoSWK411zkhcKXpeXssYkIhFD
         PhxgsAkZsujqKd1HgrY8lv52B75jwm2XBDeig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714509604; x=1715114404;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2YYgSWxhf4zOPIcEbuWf3i+tS5g0up/+LJ/wCKYsmNQ=;
        b=PfoL4Uu0DWvKIFn8WPhVX0c8Y6B74LWHUB1ZnhbBbFI3VaxxAWsUpElRpLgmROUQ0S
         R4w966I4Ahjq6tSqvywSksvovsSyb1qQ+SPt9KIJZk7DHol8sqsOapo+oN799GeDVxvG
         xb71510k0QIN74FfBhFo6fs5cxA+MtpRYTXDbzaamugeMa0+gXeWzbMHTNx8z7Ai0WoK
         pFjXINZZy1vnkwZKQ0Uw7UbZbTFuwhd2+NscsdotLbN+L4+65WlWL5POtE5OaLHAtA+O
         UPe5LoZNCw6uvjbj/62UTtSKRjnt/1x2jeFPDAU3pI5EYncBc5eKeQyYpsEVvxMw3CNQ
         +M+g==
X-Forwarded-Encrypted: i=1; AJvYcCXrcINDKJmvSpuyrun/6/OhnWEPeqDOeHrtuVYqyn7ziHs1fD287Y+kewtTYXRVJzaTFGNY0H8RN7TuCtErrpx6MxlW3A1yYw==
X-Gm-Message-State: AOJu0YxpicnqaO5octvnIwUwk3LoIS3SsxYrMHvaPHum8s5vYmpFaCid
	LW8DilmbaG0VAulm7uZA7Ax1HloAB07Pd3wG+XjUSq2F5JRPOANxHjZkv0eeEA==
X-Google-Smtp-Source: AGHT+IFRIwaOZIJKk9q6FINe4lpZDhEXBbf7mbgHPgC2qdcV1d/X97KO1ZiGdcpPPLnYfRdPuBcpvw==
X-Received: by 2002:a9d:6d90:0:b0:6ee:3f5f:c4ef with SMTP id x16-20020a9d6d90000000b006ee3f5fc4efmr1871923otp.0.1714509603829;
        Tue, 30 Apr 2024 13:40:03 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id l4-20020a056830268400b006ee64b1c8dfsm395000otu.23.2024.04.30.13.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 13:40:03 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 30 Apr 2024 15:40:01 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/228] 6.8.9-rc1 review
Message-ID: <ZjFXIftVw8F1VT6T@fedora64.linuxtx.org>
References: <20240430103103.806426847@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>

On Tue, Apr 30, 2024 at 12:36:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.9 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.9-rc1.gz
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
