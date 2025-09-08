Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF18630DD2D
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 18:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757355658; cv=none; b=Gm+F9lAp73cCCEhYXNOHe6YCum8yzvGq0UuenTkCuwgzWO7MZpV5ydFRp4ccnaLGOSvqXDJ7eBnr5youJqtsh3DzwJSrMdKZquZOGvGeOHvGxO2ePLClEizdI6X2X5UjLYyDkk+NZiFxvTB0WU+5nUyq1bfeVT5NbGlwo7yj2a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757355658; c=relaxed/simple;
	bh=Nh5FCkUds8fUdhe4ZcLrZzck+rIGv90oXfld6eJMTBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d4O8VG/bVvY5LiyVzbLUXXJEIbce889cZczICtifDoEilBz/44MKkiSOjpdEanLKs3cskcw/n/spGReBQs9w7p//cQ5tcwn7yftX3LbaJ30tCJWp05NmD4xmmfPftPz3roCitiPhMQaE0FWNF/2bbI8N7rto5rb8ZIn/gOORYbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=ZYUdsp5D; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="ZYUdsp5D"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3f663c571e2so45593335ab.0
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 11:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1757355655; x=1757960455; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KBV+iImOReBPqWH0+/ePZkAazHev8dST5Y3pJ+QrJxA=;
        b=ZYUdsp5DOWBGvZfqG5YJ64gazgNJAvk1Mh+tDCsKQw+BYCvKfsD8wm35yz+txkEsYt
         DXzmLuF5p9lOZR/Aln+Tv8oRuKy5i41r+f8Ue2D2+Aaq2gnu+Bc5YGTMUv2+Devec3gO
         YwWO2V+AuBlZPGJP1l/OD1+fHHMSN8XySZ7kA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757355655; x=1757960455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KBV+iImOReBPqWH0+/ePZkAazHev8dST5Y3pJ+QrJxA=;
        b=XaceJU174mFFfQs5uLgMYlEiHStwrg2+omQVqTeX957VsH7QW0DMaKuNoUH1NQJUeW
         dQFbNpGms4VjmxtI6Rp8jU+k1A5C8Cora7FKHeKDkjR3qVHyOAeV217BluLxxqSm2xG2
         rqNXyGQgssB+yIwiJD5IQxBuQKyrai2jYhN3DIekMVjqIfdW8Fr0ogcGsu46kpE2u6O/
         qH0WJ7CHHEEzZrc9kJXUIfilWRsba370yy5YbAS3rjGrlKb/5i7JXz7a08Ajonm/tXan
         sfiV8QD1dpG5gX+pMixtH+1VPUKYYkZs8eMQRpxK9DlOzNPQZBvcGyA41UcS/z1nUpk1
         7OjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBrcj2b3HiTrmGADvkD7YKfx93HzxKDd2ORkCEMMEWy0UauG+6ArDguTG8xe3OYgO1G4+WVYCt@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5+E2AKjexchQzdE5UU42HwlFgMhs0RZFaT/y7+pyv1Uxj8KIx
	4t0rnRYReP6jkqx3xAL6r7zlEeGf+RkbQ0detQfanrGaWiTZNgucG43weKxZqUiyxw==
X-Gm-Gg: ASbGncv7Ww3Fdm6FJROr3KfrIytMWSo7Gqc2xDuun0GAi9JfxxC+QNlKz90TizmvfeX
	MGKocFQSvOvbZA2bLIaYLu6+0G5pO1b5hNxLSGsXwA4WBRFyheUm1zNh1qrlRPYFTHGIRTu8zLh
	R35rjriX0fT0yJep8CPTtQxdLf4o8K75rPtE+LSYWClKzpFm/TFlV9bH1JwbvVUPae1EUWGgayQ
	ghrchKrRlT6Tp3O57c6FSYhpyv+V9DrpnTTlvW2IvzuRDr2NFTi7m31+tt3w2TykWFxuuHyZxrs
	BJQRNDFin74/OukrYF4+iSg0ai+ibMb8C37NKcewRAlM/jXtOlVgTIB/yTWdA0zxJf6e9n9ABmN
	1QtaEzA9y7yYyoj2/NX0fulvowosaKh8ASbYYxVH9RYiRK6/SEZM=
X-Google-Smtp-Source: AGHT+IE/BUasf1MdEX0bTcfzQ1t5u2MGL0J2BuN4ERdg8XHl+2w+6N/iuG7UlaLA0C1871kNgg5oOg==
X-Received: by 2002:a05:6e02:1aaa:b0:40f:be7d:bb23 with SMTP id e9e14a558f8ab-40fbe7dbdb4mr1707655ab.17.1757355654594;
        Mon, 08 Sep 2025 11:20:54 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d8f31d0b6sm8858916173.42.2025.09.08.11.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 11:20:54 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 8 Sep 2025 12:20:52 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
Message-ID: <aL8ehNxQ_725HF9S@fedora64.linuxtx.org>
References: <20250907195615.802693401@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>

On Sun, Sep 07, 2025 at 09:57:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
