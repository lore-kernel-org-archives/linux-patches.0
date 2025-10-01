Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6102E7648
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 12:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759320635; cv=none; b=JWirNLz86aFHuTN1xrLMYKBALOj+2YKzwS3depQ30Xn53eTBsDjDAw+DCDzyj5OBa3pvHSbW3MDc6S+IUAuiW6ghHUUZ2WawIT3zdAlmmrDsYrYL2cEOL4dqSIy742dtwC9zwJh5vvHTOHXRYYj3nxn3aLUPAxKb8czuaDsEw8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759320635; c=relaxed/simple;
	bh=pvMGaqY63vMpQ2YYUKa3njQxeuJ6aYGwkhm8mUrKcsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TcGo7E+mzuEwXEpZfVTq5SLScnmtySM1q9l4A3lXwYMo6UlGWGyX49mcmBxhOY0P8toPzgqoUNK2jKoqM2PUV+wX6byTbpFOZHtJy5rpmwUHqvaE4/XVdTTCyx2G+zlAmpSRj6Tk+Y+JYjRptMZ4efdZGe8Vm4SXcb/2lodcLLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A2+oIvAG; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A2+oIvAG"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e48d6b95fso45430925e9.3
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 05:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759320631; x=1759925431; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yt2/RiqsQaPl/L3x5B+o48QDSFj5vHrC7SC05R42/Fw=;
        b=A2+oIvAGm24UrCBLzjCh2W6xSBh6CG2mdHuS2i6tjJdUWBIfX8avWQJtc006eB0peO
         4wcNd6AtXWulY8kS+sDB0qjxT1+XTb3bgeyyPhbWfqJ7fceRKDY3HIh2rTPp8Bi9cAUU
         /uvlm46n440vNlKT1cHqYk6QhYKa3zGqqTOvBtlaliyhPj5/6nNDtUgfofxYafYJdKJI
         81UpZShsJ313Rp2KpmblaB/mXztin5uYv1W4+91TA37cN1n7Szif5ObOd9jzHN7oDVt2
         /hkF8HpkQgyUwxTgS2fV1ldlM1nO4xyOMIhbVTiTn8EHsks0dUU8T9WTugDS7VuTwPTL
         azGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759320631; x=1759925431;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yt2/RiqsQaPl/L3x5B+o48QDSFj5vHrC7SC05R42/Fw=;
        b=byj+hYe9XO96eZNxucT6SidANAmP02l1+BAZWgDRdiQUCJay98CUBl6uuVq7bjHyCt
         8y6GkNwUxQzp6LrLDxYcztv8S0vOUUkin1mBMeRM9KaQeyTCc96nz5RtjMmXLGtdSq/B
         nbkhsjqUDYiOECg81BMJvluQ1ImrOKLa2j2jKe9A9WNIpyG4dcorZzdfGv3hYIo+uVWf
         OQh0kL8mskCbNOoE3BjNuPOkBQ+M0bBZouPmbT1j9MqUZHo79bFEiqPmj0NvFxHv7P5H
         gYw9AZGsbPSAa0vR7TF3zor+ENN5RSkYNTO8ggXoIHzRrQJqkJW+HN2+uBPghReNQ/j8
         2tMg==
X-Forwarded-Encrypted: i=1; AJvYcCXdbLgjEYEFey3SJ7yuHBjXrUulaffuCm6bIH1yIZ2IPs8mLso1Hnto2lJbyra37y4RnWvAHB5I@lists.linux.dev
X-Gm-Message-State: AOJu0YwRuYRN1DKxhpbnv9F/VItzgxuWaSWzS6FKgrFORri84mdkHfNG
	QpFfiMOQJZYFO1CJ9TvEVTSyauNfCdGuFRLbEt7bMWuaPKCiE4vrmNx0QobCmikZRM4=
X-Gm-Gg: ASbGncsbOiRJ0czbIVwskEjjPTlGcfGqQwcSVgNFieSUHAjzdO7v9s/3Uysui7Qjmxe
	CEEwycWl47E6ftDraeLk2UDVuyEKszAf50dAdeZlNtkS4v15ELjXBvhJwfq62w/mLDBFV60CCPQ
	d/NSp8B+WE/Dy4F1fAR1GNnXrHS99aikUiTwy3nhy2tkwes/H5bFpkda+uOWRpRMqJ8tfwFFOtY
	o0cH0ES9cB8EGU2hb8mT2VXmQOyQ2wz3rV5FmUMqWg936L/6uIs6+stnB8Vgktr+R8S0vpd/rkc
	na+iv5HYq2HCk4CKp5lEA0LgAKMYDhIxWDyp8xm5DjSY7yWcmaH/4Fj/5RQWfhdyqmuMQPOCIbb
	AiIyjFO2dYY0fVRCfiZQ+UnUMM25BMy2uyWgGEmiYJ14X8W08zROelV6drJ4GphI=
X-Google-Smtp-Source: AGHT+IG4Fv3Ws0T0hfn9FRi9J8Hy8qhXiWqsQ+7mqBAvBUVbcM7w8H1ZOknsFTXOA3cvm76Wrim5lg==
X-Received: by 2002:a05:600c:8206:b0:45b:88d6:8db5 with SMTP id 5b1f17b1804b1-46e612192d5mr31099915e9.12.1759320630850;
        Wed, 01 Oct 2025 05:10:30 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-40fb72fb21esm26937295f8f.7.2025.10.01.05.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 05:10:30 -0700 (PDT)
Date: Wed, 1 Oct 2025 15:10:27 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, Arnd Bergmann <arnd@arndb.de>,
	linux-fsdevel@vger.kernel.org,
	linux-block <linux-block@vger.kernel.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Ben Copeland <benjamin.copeland@linaro.org>
Subject: Re: [PATCH 5.10 000/122] 5.10.245-rc1 review
Message-ID: <aN0aMyU1D3N4WQy4@stanley.mountain>
References: <20250930143822.939301999@linuxfoundation.org>
 <CA+G9fYvhoeNWOsYMvWRh+BA5dKDkoSRRGBuw5aeFTRzR_ofCvg@mail.gmail.com>
 <2025100105-strewn-waving-35de@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025100105-strewn-waving-35de@gregkh>

On Wed, Oct 01, 2025 at 12:50:13PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Oct 01, 2025 at 12:57:27AM +0530, Naresh Kamboju wrote:
> > On Tue, 30 Sept 2025 at 20:24, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.10.245 release.
> > > There are 122 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.245-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > The following LTP syscalls failed on stable-rc 5.10.
> > Noticed on both 5.10.243-rc1 and 5.10.245-rc1
> > 
> > First seen on 5.10.243-rc1.
> > 
> >  ltp-syscalls
> >   - fanotify13
> >   - fanotify14
> >   - fanotify15
> >   - fanotify16
> >   - fanotify21
> >   - landlock04
> >   - ioctl_ficlone02
> > 
> > Test regression: LTP syscalls fanotify13/14/15/16/21 TBROK: mkfs.vfat
> > failed with exit code 1
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > We are investigating and running bisections.
> > 
> > ### Test log
> > tst_test.c:1888: TINFO: === Testing on vfat ===
> > tst_test.c:1217: TINFO: Formatting /dev/loop0 with vfat opts='' extra opts=''
> > mkfs.vfat: Partitions or virtual mappings on device '/dev/loop0', not
> > making filesystem (use -I to override)
> > tst_test.c:1217: TBROK: mkfs.vfat failed with exit code 1
> > HINT: You _MAY_ be missing kernel fixes:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c285a2f01d69
> 
> You are not missing this "fix".
> 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bc2473c90fca
> 
> You are missing that one, but why is a overlayfs commit being cared
> about for vfat?
> 
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c45beebfde34a
> 
> Another overlayfs patch that is not backported that far.  Again, why is
> this a hint for vfat?

That's test output, not something we added.  LTP tests can have a list
of suggested commits.  LTP doesn't know what kernel you're running, it
just prints out the list of commits.

https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/fanotify/fanotify13.c#L436

regards,
dan carpenter

