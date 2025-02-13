Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3FD2753E1
	for <patches@lists.linux.dev>; Thu, 13 Feb 2025 22:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739487480; cv=none; b=Gcsq4O63beh8fKhcZSzcAmOhZYnn4SvB9bwgrvQRCnk+NS4ddSm1x7/2iCxVEbdOGZ+2c00H1svFYQnLNCT4Obqly3uPRGuZUfB7iTXyGnR+OvL+0qNFZGdoY4RKj4mXWEzZ22zBIGf/9FMly05rFmqHgCqgjlmftatECGfGvYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739487480; c=relaxed/simple;
	bh=Smto5Yxb6vav2wHm0QPt2rfaxx0mEaFrjpQZAsln/As=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SCHQOtRLfZiTBuwH+KkWTnB4aEHG7mriMCpkGGdCzPAmstkladPz8tS943b7UtAQUrURCDsZN8R8hpkBamqJKmXFnVdPAWJlsndF//+qpEHF/vM+SdxFv9VsVzj/yzLwZH5GGfDP33FAWGNS+xXSHqBhSefhRRlTSa+qfwN4mio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=UI4J8Ql0; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="UI4J8Ql0"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3cf8e017abcso3875445ab.1
        for <patches@lists.linux.dev>; Thu, 13 Feb 2025 14:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1739487477; x=1740092277; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=giMqNiydqfL6yBj4hJcOnss0/v5CTlMHhDcOLath6f0=;
        b=UI4J8Ql01fK01koxhBqpbvd/6XjkAX0D1z17UW0/AzA1BfrdSbyW4/oeaAt3+MaJW1
         JKqWbRnMCvKeasz2OYQrn0o//aep9CaD1pUSxtbhzOXWE+UmRU8ZiOAHe32JuUdZ3rHa
         G7fYlI13eMEMgKhefnAcd4538xUBMxKbAdYSA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739487477; x=1740092277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=giMqNiydqfL6yBj4hJcOnss0/v5CTlMHhDcOLath6f0=;
        b=DkB26rDnZrxt8HYgJz/UOB1Zz9pYkMCmb3OwbR7pB1H0dR2VIHBBijzXSVqozlu6uC
         JAsePpOtya2Dp2bgoC8NZfh4DVGnnvzCObh9LUuLPot3GpBMGy36BbFcsRH/t2y2cOTk
         OBcF7bNR/T0HRgwt1+VDWrV9pTx9GhGkKlxoOqEj8J7qxoSpyHwUurHDdhGyE5iO+pSI
         +zdtt2HMJi5HEawSu9iqCX2cf9BK9IMSzZE5fNYDHimCCxQFsBE/Wa66SFeeQC7GZtsF
         8Dzu3Qetie9SsNrQ90poNwDBt+WRVJUBraRYZjRJ1WBkmc/m7XqckejvV+cNSs18DsWj
         UJwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOFsZm7XwbyPr2Sc4dt3WAaFM4ObvDJ1j13BAqaBbo0RcsEadAEJ9GV2pjQQABizH/mZY630pu@lists.linux.dev
X-Gm-Message-State: AOJu0YyRrqY/pPpcbckWJVy67Pd91LZA0uX8yuvRciMNwnvMevN/QA8D
	K1cs1JSEaVio5gudefBGo1jbRUrnAVZdB/u1kBJbw0O+z6FnseN1pl2I5IKx1Q==
X-Gm-Gg: ASbGncsKRajO/Ij7kGUw2NwCuHo0Jj3ELvFhD0V7/kjj9SWTpuNJJZHjZ8wVfO0B/mZ
	XdiHR5jdDGsr/G2GvxIIMKd3Ps5R3qT1pUPsRejbjvNhpdznsN82t6d6LgGLsy8ojVBHwiLi++L
	MquYcOgUQODmpXhEjmFKUJLIc6gNkOqJv1aT8Iz8ow1xhlnhJX3XfIty8JiPxZ/VOI6rnu1LaRe
	VB2PuQl1iNs48YlPO1DY15gtsJ0qLPkjzmNmzpA0L70DtsEQJVaEAzvG96W0i+gaSujS3E9YkD8
	J8WEEnZZaiOqUacsabEYIsiXy6aPrBle
X-Google-Smtp-Source: AGHT+IEzoq0TAA6AIhRAC9HUAPu5NTo0Qc2xIPZ91yk2fGKDrTwVk0kj/so8NbRnYKTQQLoBadEh9A==
X-Received: by 2002:a05:6e02:3989:b0:3ce:78e5:d36d with SMTP id e9e14a558f8ab-3d18c23b7f1mr50464215ab.12.1739487477453;
        Thu, 13 Feb 2025 14:57:57 -0800 (PST)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed2814883bsm538141173.19.2025.02.13.14.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 14:57:57 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 13 Feb 2025 15:57:55 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc1 review
Message-ID: <Z6548yfCM14jmgqs@fedora64.linuxtx.org>
References: <20250213142440.609878115@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>

On Thu, Feb 13, 2025 at 03:22:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 443 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
