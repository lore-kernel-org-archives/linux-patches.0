Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E581EB5DD
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 16:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753288055; cv=none; b=RmmKbJcVlAkYQRsnmB0YqbTM7mBcct7s9Ae0SplKO+R03A2BMqfCLyUKfgxQKCgi7QcG2EjF0Mz8DgXlOnT1R4lIBMClKzpKZh7+n8yxCPU4zkFjgfrDGqceifcrlo8zmIZxVmvbmNhiELhuFlxkk/VFcIfk/dLFCJT++RdlUVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753288055; c=relaxed/simple;
	bh=QHsEWJ65EKEeUAnjRO62w45lv6VLZRWBmcs6bu8I5Y0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9gIyuq2OUZSeDbvRi6SITSrHxEo93v1slp1PDENir3dfNuIJZPMecMaFgGRahN+UesW0oFUwY6P/nW1OGXYbevRUd7Lw4Pb1uWT8j5r84kAnnFJX5NvC/15CXABBUpfysWLXj1pXIK13XTjSHRYr74jw90odlgZUg41uhSGxTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=fZ2fer8N; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="fZ2fer8N"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-306db05b292so46119fac.1
        for <patches@lists.linux.dev>; Wed, 23 Jul 2025 09:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1753288052; x=1753892852; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/6A0ra1sbjas+5Ydcn1mY51RGT/qA9lEFtptxsAU7TM=;
        b=fZ2fer8Ncs6HzfNskq3STaWq+kzgLsnIITKb/haBIwoxUv0mAorRtcVRF1YaXTsR9r
         yXIQGNzWljW7C59vpJc/Fmp1znDyEQ9CsRNNncZcIR4IBPZDHSVUQ07tXRyKN3o5Q978
         kDVgbdagSTn+ZZIGiM/vBpRRY6WjS9bAukljA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753288052; x=1753892852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/6A0ra1sbjas+5Ydcn1mY51RGT/qA9lEFtptxsAU7TM=;
        b=L3T6q5Wn5ocEUVlE9Mtr01VL3JufIXgDZoUNoKS/E4WPBrocanr/T7vDIjp29OHnG5
         2KP3XDktwhcTCAUhmcWD4RvdKbRMHjnBUzml+911uK/MPheTvl2KEf8XkzAcNyEYj13J
         BQyxp13JxsVv58nhhK/2zjJdQ2I6iLb7J7aAZ9K2Jr5BlOcAOkHWYeXBcvdfBgiqFz+G
         dgxiPk0QxMm/EaEeJ6H5P9uj7rgW2IhwJkWcaJm9yvumyqcQAyE7QNgHXpuZTG/y7WAP
         bXmsZI9Vu70YMkCrVQAFDi0E3LJLCrIfORv8M/mEf0gR6FY7IwN+8qaa8J5ZEcqoRLW7
         3AWw==
X-Forwarded-Encrypted: i=1; AJvYcCVc4P7UANbQp5RrETUzZC4u+hPdryQ2bzDorPWtodRAl0YE/YeXx7FLKGsbRMRgY6QI+xTe9Pxq@lists.linux.dev
X-Gm-Message-State: AOJu0YyYKeMkGXcSUmnPf7S8Xzl+E6D9ddNiv2vfuXxTK1Ybh5vccgmC
	RkFOYGi3arUWizsidcA+A81BOARw1fxFJkLUDNEzZ1TmuiwyN9yYqRGw7GrdiyjU2A==
X-Gm-Gg: ASbGnctT4EZZzBPyuxbXSh2ktb/M6cs+H/LYpt7w0C+FKd/gfodhtt3Z3URo6UVAXIz
	g7noEQAxC6wells4+eZZFB06xnM593Il799d9b/LDr0Z6F09R5+D4M/Q7z+j/Lth54UJ51blT1N
	RQJ7LYYtZ8DGZKq2DXd4W53v8y9eIZwPKWWIY5Kca6ZPsNZfFI4I9SfPWzu9bAK/aO2FCIQo9vV
	R0HGcEwXKcxhLiefTZ+IUYzOHhn3YoXfqS7tBptGDTco5j7CtRqB8isA0yBFEa02UPArBvTeiyf
	0sa/L/pvP5KUOPStOj9X4Qt56CROjRqMVPp1oVIIRgKFX1GXBF2EW1hLTznAcdOWKKIE42OC2WV
	Sq1k91hyLioc4QdjKkBz7jylsCTaeO7K0EjnnT2c=
X-Google-Smtp-Source: AGHT+IEO8bpmfpwvvlzRcmZt1Ivg71kovZ+W+IOSknlxinA5MmpXthLTgUWvuZ4sxkkWAFZMhb/IIQ==
X-Received: by 2002:a05:6871:10e:b0:2ff:9663:ca48 with SMTP id 586e51a60fabf-306c7350031mr2041806fac.39.1753288052151;
        Wed, 23 Jul 2025 09:27:32 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-30103d1b601sm5150726fac.24.2025.07.23.09.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 09:27:31 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 23 Jul 2025 10:27:29 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
Message-ID: <aIENcUTPkxpM8nlO@fedora64.linuxtx.org>
References: <20250722134345.761035548@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>

On Tue, Jul 22, 2025 at 03:42:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.8 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
