Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518DC1F9A98
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 17:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734544679; cv=none; b=mX4xlNgRdMfJWte3NQGEezQZP+JrtKIMIgOAAOlyDjlXOb+MUlviz2/qzX0MCJbvoXH8cLeqlnkucZhLeYsWx3dUvddOZsION5IkxnMfmtFuGD2QopzWWKpoEbJNvI43KmxSaImEOIWZYjWwpCHZAO516+sdLnbvVMZea8Y8jg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734544679; c=relaxed/simple;
	bh=RWrr/PILJwxt070WUEquDMpPRS2pWp97dIBVHw8/Qik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qVc7ZUbrukeHAZfN16Q2y6hfNJFrlSHIpwsAPVofItp3VxQCTnikde5kdSeGJPGX4F8UUC6pXDDFc2IIpcaT84XmzcC/yhBl8qbIQIUwnegDqjoq/9FPTzp5gK5efnKF0bb+pO3HiPt7B3/0lBoNIii+oFmDVm7OC0h1hPFiEgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=YZH5NT6b; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="YZH5NT6b"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3a8c7b02d68so55190605ab.3
        for <patches@lists.linux.dev>; Wed, 18 Dec 2024 09:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1734544675; x=1735149475; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PyssnXrBwQm6Ar4ydeuKDWy1xoN97D0E6DenEmIPu2k=;
        b=YZH5NT6bELqRLQ/BqfPSq4NzzaMH1YVvk47hsJZVMZXRHzG5Oe3BccnhcwgKUADkFi
         m5vYft1UBYLza16ceuXUUnOYc7MvnhzWpKT0Sxk/iUrt3TKmHdXX6YZ6ybyTx4UxDS3O
         GgtlyF+TZHLKjHWqLfNaFcuykQlUFYJrbnP1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734544675; x=1735149475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PyssnXrBwQm6Ar4ydeuKDWy1xoN97D0E6DenEmIPu2k=;
        b=LN1HztFuZifhHuGgt+v1tSM2qmuDGFg3CbrNyEdK3U1tTQg0+YoUyYA8KmX91v0gQi
         /S80Wbvnk2l0/Ea0YD8uqNJaEWeQgo/Ql5hddWuP17EemP8jMzJCYuZkxNavofMqH9eh
         RNRoSNqHzzpLKWtSMrdCGiawowuh4mLWyL+DFdJNWp9BgedlKjDB6+Celv2q/AQsd9kg
         XAcYeP5zhloLzMp4kHRn6DREorrvT1U1xR0h+yqtQbqIhis6cjQ18wdiPi9mGVELmvcf
         Q4F4MAwLUugw8ijha7DfMf3K/D2g0dkNAzMiOPhzQUrapV2M9HyNn7wfgiIBdn/k4trM
         Lksw==
X-Forwarded-Encrypted: i=1; AJvYcCWmR/ZdzFkpoFoDC/iKBormuRRuyvsxrWtPnchIi6un2aZP60Yhqld3jP3+xmNfoQm8JYWm1WU/@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0BkHuF5OJWiToABmowiNSxPyqFzJDdPDLCRu1QKqbmPmScVEO
	L6qYdhyQv1QP1myNUfccmeFFbYwmxA+K4h6RMMzDWj0L2A1XAtW5keNvPVMjgw==
X-Gm-Gg: ASbGncuHmxkWrH6j72fEEz4Jum9r1n96r8McmVx61y4A+qMAAlXVJKreL3Y28bTnQZV
	jNYrbQoeNmWnv6udRSvGEw5pf24cXHB7W+Kbukva8Jn2f7dQt8fLhbrfGGRE6TlUorYcFUOTVqn
	Fq5hPyExY8Pfd/RI5YJTufwzoMtauPC1DSqbEn//WlBepQyNqDF8E9fh27s3gQquzs6k0QUHLpO
	H69M34e1PErd/KgkgwXcsKrL0HERJ2jaCJUig8U+AMv0FcxQ7eYNF2JpMKZ55WAR1WMI9HF9w==
X-Google-Smtp-Source: AGHT+IGEtCTnlSFMk32o4qbissvyC49r2rKKEdGcxJJUvN0CPkcHEYU87NouDIua0tLZhmd0ChJDXA==
X-Received: by 2002:a05:6e02:1f08:b0:3a7:e047:733f with SMTP id e9e14a558f8ab-3bdc0133223mr45969865ab.1.1734544675287;
        Wed, 18 Dec 2024 09:57:55 -0800 (PST)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e0368794sm2324087173.25.2024.12.18.09.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2024 09:57:54 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 18 Dec 2024 10:57:53 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/172] 6.12.6-rc1 review
Message-ID: <Z2MNIaPQdm9KgBCP@fedora64.linuxtx.org>
References: <20241217170546.209657098@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>

On Tue, Dec 17, 2024 at 06:05:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.6 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
