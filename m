Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73206EA6
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 02:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="XyG2YIua"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3b2e22f1937so3408498b6e.1
        for <patches@lists.linux.dev>; Tue, 31 Oct 2023 19:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1698805728; x=1699410528; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3NOS13AWfl+zD92mnNkBlpojb9vC6m6JveBvE3ib1D0=;
        b=XyG2YIuaV2fQSxDP7FMlMEKYe+RK1ng0ADiv0GyhmKU9xOLBiGQEm9WMltS7Y3ljyu
         0GmXMHwVp2B4lbM+BG4pw5O0X3buHTJJnZm8cP/bp0xPdQioVBHrIcNeLbVvpvjyxc3f
         7VJUE6i0QVdQjuEeqxv0imsy1+5LQIIB1owzc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698805728; x=1699410528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3NOS13AWfl+zD92mnNkBlpojb9vC6m6JveBvE3ib1D0=;
        b=KMpOQgDtVkFEq3v9+YvA53w7Vi9zDv9ETUClu6oiJpwOG0xtNx75zagUQJLNoIHtVr
         odQbwYOgMjHSrgyATEg8Nnp2I1jm5C4B4h7SUaEgUnJua2HdsiK6FsrPuyMjro+C572M
         TfEO1FjhSCGuXCivR+LeQKIPxYEcWAPIHtdjmYpHMuyErBsSvSPmYPjr66WYHNbBPkCG
         PNlwLng0ZSkLRrTTt5Sgv9rBbM0PPu5Bc0vJxgUBuzphT45wR84Xlre6m0wkt/dYMF5L
         Gt6CTOR/dOK6OCARTdaH923R+srh7m3ACKuJRdG84dtHzELOiwQNqbhw6uUM92BXc6+H
         O6AQ==
X-Gm-Message-State: AOJu0YxLp4p1EYoniSssP2mmAZBPTOr/ai5FkUVxrg6JJV80oFCTswge
	9wufVJyT/g/+S4dcNXAW0AWSGg==
X-Google-Smtp-Source: AGHT+IHOvyiAUD7ZHPdpP44HLsndQ+RdyPrWrmwj5thEHMOLwAMgNq37HfZjGr3nOGtKfd7GtWMEuA==
X-Received: by 2002:a05:6808:3a85:b0:3a9:cfb5:4641 with SMTP id fb5-20020a0568083a8500b003a9cfb54641mr13949893oib.48.1698805728594;
        Tue, 31 Oct 2023 19:28:48 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id t2-20020a0568080b2200b003af6eeed9b6sm101348oij.27.2023.10.31.19.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 19:28:48 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 31 Oct 2023 21:28:44 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.5 000/112] 6.5.10-rc1 review
Message-ID: <ZUG33Hft8a4XYnrD@fedora64.linuxtx.org>
References: <20231031165901.318222981@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>

On Tue, Oct 31, 2023 at 06:00:01PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.10 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Nov 2023 16:58:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.10-rc1.gz
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
