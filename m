Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC3823CF
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 22:38:53 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3ab29af398aso222827b6e.1
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 15:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1695249533; x=1695854333; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1CFASXI8WL+dneofPZI+e0hjnEpkK/1rD0JOrrCGQjw=;
        b=Fm+LN+y8kNEI4L4LP0V7xrZA351Xd4ySIPHnCBeeyr1uRoy0Edi4ucXm1EegqKRPod
         +Yvl8HlzrUpn24LAhWbqT7Ap64EVXDSdfjkC+GvwchS3r6q+4QOHTKzGlIJbxRGAKMwS
         CTDrhWtP69P60eORA7AAr0Nx6hJ9lkpGFlziI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695249533; x=1695854333;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1CFASXI8WL+dneofPZI+e0hjnEpkK/1rD0JOrrCGQjw=;
        b=NJXaq9JWdBQR3GhT9jxcynXu9i1t0+9fTPn/OZpUKtHjhQ8dFbXfB55oqzTj95cNpq
         vFHqHwcdxg5+FP/aZ5/Yn9GUyPKmu9cgeKLGvVx39PXUEIh7xcCpaEePEZyq7vfjadEF
         XKwNZYRUrEx0xR0+B8I8LVeCogRoyKBOCBcD5o1nYh1w0yM+IWDrE9lMpsoroQEqcv2m
         bxV506u8Wl2FkHmshYAB4cZOPB0Am5IKVp2Z9WgiJvS+I+yY0vqNSo9aFfXuohEAxVgF
         KYCp6CSUpp7Ueap7M3v+F8Ghd4tM9hcrYV7/Al844QlrDbudJGnxxaW4aulyeNcC2fM8
         57nA==
X-Gm-Message-State: AOJu0Yxm4/ZGd3BXrb6iBEeiSRDqUnQuSx+L3iRolASiri/DU7UGodrP
	dlPZYJfy1UGw3bBcikPWofNqoQ==
X-Google-Smtp-Source: AGHT+IGhUbWmEAffQC5yTBBemEJib/r36R7qLuhAsphONKsVaV8sfYP8KCR7H+a40zjz8GJXoTbr6A==
X-Received: by 2002:a05:6808:1912:b0:3a4:ccf:6a63 with SMTP id bf18-20020a056808191200b003a40ccf6a63mr4107683oib.55.1695249532790;
        Wed, 20 Sep 2023 15:38:52 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id v14-20020a056808004e00b003a9cd23980esm52020oic.8.2023.09.20.15.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 15:38:51 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 20 Sep 2023 17:38:50 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.5 000/211] 6.5.5-rc1 review
Message-ID: <ZQt0enUSOWLGAReo@fedora64.linuxtx.org>
References: <20230920112845.859868994@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>

On Wed, Sep 20, 2023 at 01:27:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.5 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
