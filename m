Received: from mail-oa1-f65.google.com (mail-oa1-f65.google.com [209.85.160.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4453573171
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="d9Bjw8D0"
Received: by mail-oa1-f65.google.com with SMTP id 586e51a60fabf-1f055438492so4450887fac.3
        for <patches@lists.linux.dev>; Tue, 12 Dec 2023 09:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1702403766; x=1703008566; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GhO7i0g8+DEMkg+DsYpqZaGmgA2sy3F5nbL7wCmBS1U=;
        b=d9Bjw8D05mbvSdJVYauESFd8IvFz5txVt7tsSO26Hz78MMzkWl5elxU+rUlzn1kocw
         w2kS4yJ0RRVccqS4X3cwbV5satv/fbRkG33rXxHxOJCNq9/Okv4NPe2Lrv0IHNExxsTD
         qTaU3lSX4mFWRo6CMczxBocszsHlNKc6Zklck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702403766; x=1703008566;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GhO7i0g8+DEMkg+DsYpqZaGmgA2sy3F5nbL7wCmBS1U=;
        b=b6osDcM9UE6MX18sjZdzh3FZ4aRy8ququuFOIb7zmkpYqkwJe/a0UmFC4vV4STMF+y
         3o2Ej1QEj1cmpa+jXM4QgXOaKjM/KbYLtc5CfjmLB7GdepPsXvvx7AWumEr3aj6g1s2G
         gKGB4R9J8P58/9CFd3Of6bLCR4EMrSvGxZRxhssZWdUxvCK4jGjnVBXLJVAfIFOydI4j
         eC9PuvBc2Afkx8/dDSOVeC6aHpgvahZJF4exkFLDdDrlqC5rsETMEbY6DAw5ELwLGSpM
         z6kcI8ReDobgDtYo4hMqS0U1QEKWIvMMf0xScbTwY2Q8Iv1zY91Zh2v3tf32M+b75Yg6
         Lh8g==
X-Gm-Message-State: AOJu0Yy/Sb2ZZMTXuCqczzOg/vw6ez3+d72IIZrgrb7dJC5zefCcfeUy
	cRJCaVNnKUKuv6fiuisV1FSUEg==
X-Google-Smtp-Source: AGHT+IE1HD/oLSOYMj2B+IFoC9wztLPu0au2lOiT2+Zr3iFAqi8xJaGfKRpN/aRGMvC921QVzFRVTg==
X-Received: by 2002:a05:6870:d205:b0:1fa:2602:2e9 with SMTP id g5-20020a056870d20500b001fa260202e9mr8329662oac.8.1702403766102;
        Tue, 12 Dec 2023 09:56:06 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id wy3-20020a0568707e8300b001fb38204e42sm3315094oab.20.2023.12.12.09.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 09:56:05 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 12 Dec 2023 11:56:03 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/244] 6.6.7-rc1 review
Message-ID: <ZXies-AXCT0ZXuT3@fedora64.linuxtx.org>
References: <20231211182045.784881756@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>

On Mon, Dec 11, 2023 at 07:18:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.7 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
