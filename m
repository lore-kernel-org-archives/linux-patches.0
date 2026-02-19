Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29C73EBF3E
	for <patches@lists.linux.dev>; Thu, 19 Feb 2026 01:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771462837; cv=none; b=IORZQf/xmAW/JkP88O59xlsUY4mzW2zqkQSUoBN8/03+UEEa8RS1o8mYJTZ0qOYNbZ3zPWjTFci4CaFz2ZIcS9GYOs4FXF86SWF7gIj4y/pTOSRRnhr3zTc6ftXQRQNL+ahw0m+JOlTfQsVtHggFZmXNyFbWMe5artVowiXvj3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771462837; c=relaxed/simple;
	bh=CrYGpZOdgx/VVNb7ESrBhqeXHHh8DU7h8Y6OB7fQVJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hpRofTAmGMry9Q4A7ulfPWVq2v651QA8m2DM66cb16xjdcpmCxSWkGbrCcmazb0m+yau0HBQ44/LX7kjXGziYToqWg+3ub+hkG6RXZSeS8QY/KtvdbKNaIKzw7pN7D5zqci4W7DaXqw3BDIQddRq5rfqBfmBtRZUg2+Eof0/4Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=iMD5698H; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="iMD5698H"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2b740872a01so1014091eec.1
        for <patches@lists.linux.dev>; Wed, 18 Feb 2026 17:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1771462836; x=1772067636; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HflinJnhMVfy7OwrOiRm9fnxuy0ODdINIjIvT2Yjqck=;
        b=iMD5698Hg1a+woeK7V6lO9z8Ufe5amJ9kE0G1vmVwMBogxICBVNrjpUUBrpA+xJFed
         4LJC0qriS+388njvP/xB0y+W8PUhmf3GmlhUXTftlfORs0KzPORqzW206hWx9C6DXxpT
         7GW4AcyQKr8+3+tja6hiMv0pft5aGUotM4WYA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771462836; x=1772067636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HflinJnhMVfy7OwrOiRm9fnxuy0ODdINIjIvT2Yjqck=;
        b=kSCdlGWN7yKATnilVaGrXnaXoDaEJfUgStqr/4UiC+MftJwUtEj+976j7Gs/C/rULI
         17KtbbhnVzz52LaV73i6PRsXk1gJBzfHtrQ9qdH01OO9iH8QsNulr+2gDmIVVh09C5ZU
         e1ssDczMgRWFPjBkbf/1r1TLzNVNY3Qas1ZnlFIvRk1d2V8loB7Z45q5RcwjCCIyoxeJ
         ex4iunzud9RGbcf4KO22LdKPfUphiVMjFB046WK15K0CA/0F91kv8oPXrPmLfWWgG+AB
         6aG2k3z9/JR9UmqPoH63b8yiN7sIOqjVI8U5VaoUuO1q5MxyiuSnNkgipN7eHkWKC78W
         pJ0A==
X-Forwarded-Encrypted: i=1; AJvYcCVFd+rjc80xaKcCFdE/FmQq3P+qTh6zStAFwkPzriKTFtYnI+xsKurKj0dC2zBAQWJmza3jubHM@lists.linux.dev
X-Gm-Message-State: AOJu0Yzcr23wUWJrb5ZU9fYEjv5/ZiLsnHZDYVaJb7v8W2NBI4c6t16Q
	JH+ME+fQP36zeBDib4RME48j9pMIAuY+j0kskX6AgkcHMppIFlmwiZ1aW5ys5BReCQ==
X-Gm-Gg: AZuq6aIOcSw2/Uh3hsYEoOLTgP5c3mEw8dpr4e7ETUFXPEwe+49GME6SV0TMU+eVPO0
	A0cpMG3UL9RlvVtHCtaYfS3LX9lofhYzmn1aMjbkBXBPo9eXxOIfo1uC6pfiIYmp4evOR/NZlOH
	ACch/xdxCEN1Vb0Jpex8ZSYykWdilFxn69xdL5IcSa2Zx7QyCbLWWA8Vvxuat4ffGmqMbIPoWFE
	jnpgrKCxb1BvEpd3TYcBeYKHvblGFMZOdqAO4CaHay89uGZfyAKC1Ye9Y3zWHV24/Uj6mJj7Bzg
	33JZ9Kpm07zU0JzL1M3ogQluZgf+WNIEAXyDnqUKdVcx6sdW6SsbRqFTAxeGnwwqeHBKOogvntA
	jasHUZpX922vbl2UfhBpB9SPeePNYc2yh8+HO5936sAocBWYKqbxURFg+70N+XvBel+/vP//Nu1
	TCgMr3UUTLrRemnfEl+ht+ai+0WLBQrOqmMCvo7hyOuMri
X-Received: by 2002:a05:7301:6091:b0:2ba:a341:5bd6 with SMTP id 5a478bee46e88-2bd5015e9afmr2697034eec.25.1771462831121;
        Wed, 18 Feb 2026 17:00:31 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.123.157])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bacb543d80sm22788030eec.1.2026.02.18.17.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 17:00:30 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 18 Feb 2026 18:00:27 -0700
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
Subject: Re: [PATCH 6.19 00/18] 6.19.3-rc1 review
Message-ID: <aZZgqwq7gQ2zaDTx@fedora64.linuxtx.org>
References: <20260217200002.683975158@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>

On Tue, Feb 17, 2026 at 09:31:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.3 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.3-rc1.gz
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
