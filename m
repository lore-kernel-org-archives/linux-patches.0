Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9D56FB9
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 00:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721954133; cv=none; b=Mzx+VPJhFMXL/E0ZxrujdcAlXRN56BzDv5Xe4mrzYV5AcCJ2qMfDMy1DeK5Kfbci4l07BEvzGE9KUgyANf2WDDJh69GXlSEvqXOEgkndA84gfHknOZ1xx9t2r1zyaT8zFqXE/wAzsOTX5HDK33Y5Oe2V3iuOQC/ccqMtKf7rg6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721954133; c=relaxed/simple;
	bh=gUHi8K+nRrFhm2tkVIoYdt2I7EROvpExxq4ozqWpWZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QR9ktMwjAOS+CkGhs1ByoJR7E+ok0No1mLSa8Ieg60v4PRgvzuNT1kkU0H7u8jF+BQqyczbOHo78gx7d+La9QLQF13u6p9MzvbFLDAZcngE89lg8JxgsAnDPGHUozuc7i5wTQhIXJrApgoEOlVbgNg6jrhRQLpuX81s38u9DJ7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=bOEgOpyO; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="bOEgOpyO"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7f6e9662880so34917739f.2
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 17:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1721954130; x=1722558930; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=71USRuNTycixHdXXGZ4dVWpw2ONRzjhFib/VWt9Kxxw=;
        b=bOEgOpyOE1kcx20AtiBJd8r3RbedFDDvBqzN7kWPloXT+bV8Ar291PQFRQdOyTO8mc
         8NwbsNTPQb9i4zXgvYb2GigDL9NvTw1wce5+dBaWZ89WdpzsxnR3dULk8yFD4JZjm+1M
         a9uOmwcl0l6082UX0TMjXc/KMARxaSAVPs23c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721954130; x=1722558930;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=71USRuNTycixHdXXGZ4dVWpw2ONRzjhFib/VWt9Kxxw=;
        b=gV1ogsDgysL0Azrb1f3qJiKN2xnJqYvb139P6Ij0dHTX2RC3hGj0bwZEPayKQov6ct
         KBAGoUjs+Vkcf35OFi5q21n3KnCyqdwcZnY983mHibE5P3Aa8HNEMVadXp9T8dN8yMmK
         jAiKjwIXlbAPUE0mT5lbdnc1m2omVcGIcvY9OaBbF5/7BkqCLGbscEjrS07VLizgyENc
         tKsYDj5eAguozYoMinheq0XJSk08Pn4Key8QoJEBSaMjMn5H/8GUTPgC16NtBtZnwwWe
         6LjGhwNjFCCjw6FUEHH+PUG6BV2YDc1XJbAIYmQmmc+tEqUWmCrsiRG7Y2gXmvT/25ux
         /yIA==
X-Forwarded-Encrypted: i=1; AJvYcCX33B91cdspKNUk+hswoGAnLlzRkod0oTfS9JT2ZoV/oreuz2c8vY7Y1XTPjAN5w3bP5sd65GA/J6KpjOWNhSLBTPWTStGgqQ==
X-Gm-Message-State: AOJu0Yzq5MGwA732SjbL/WGghAfF4eKXeFkvIG9/52WB/2sqEH3S+Nki
	JUu7q6NBrch8KlzBFaJgHhc6YQYvDgUv0Oz5Zfrmr0H0J8lQTeL+Xr9Mr1IDog==
X-Google-Smtp-Source: AGHT+IF2kB/EqSqSasMOsiUttph/+3l/XoSlVhheGumAPP/a6+FfLUW1HgRH/5V2V6/m4a/hCuac/w==
X-Received: by 2002:a05:6602:1605:b0:7fd:5a50:b217 with SMTP id ca18e2360f4ac-81f7e3e5bdemr505143239f.3.1721954130477;
        Thu, 25 Jul 2024 17:35:30 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.171])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c29fc0b1f4sm607189173.129.2024.07.25.17.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jul 2024 17:35:29 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 25 Jul 2024 18:35:27 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 00/29] 6.10.2-rc1 review
Message-ID: <ZqLvT4tAxTSmBYRW@fedora64.linuxtx.org>
References: <20240725142731.814288796@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>

On Thu, Jul 25, 2024 at 04:36:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.2 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
