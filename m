Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AA6A94F
	for <patches@lists.linux.dev>; Thu, 31 Jul 2025 02:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753929045; cv=none; b=F1Ee1xjcNvi7GiUD4GF9tWcS5/9A5LTSuskq4zQVweaVZsenVrYk/7BDjk/7D+BusZRXocsz2hmRnMdNH0Fme03+4SGtrfVrWUVLXfN0iL6Y9Mgt2tIs0cVLV06L3/drtdHgaUsQekQvE8Fkfa3MK+lcykEc1lG/d/MKdreV8NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753929045; c=relaxed/simple;
	bh=BGP4l7+uPxiYh3sDyFOdJBPQva2qULDdcMFHkX14DB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k3R4ZmohcK98oNV4uo9Y9jo+mMOPFtJE3P/o2dVD6oovZ4Yg1NSyq9Z3GqlZj2bnIjTLxQL0ozzv5mmw3Opf/Zm328kAzXl9lXHzw14wGmX+o+ZRNLHa4Y/1dR/rsOVh28dNr1j9G3jgVobVME6kCf7r5itgGDnePEsEG//mqd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=P0ayw2DZ; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="P0ayw2DZ"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3e3faafe30fso3921375ab.0
        for <patches@lists.linux.dev>; Wed, 30 Jul 2025 19:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1753929041; x=1754533841; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ushCqJt1jxq6Hv7PpAxgFKijmgypw1mO/90AreCqXA=;
        b=P0ayw2DZGLOXxwOU9ZPAmWNsZy/ydCzCOzujXHt6lN7Aqjz5qybdukfPoyb+A5O2YS
         HYbRvjPaA7XwVqFqA6sfQ3ZsSLSovaMj9P5cGniPBdV+FcsFo6e4hl6Kx/gBUb+pN07T
         x7xw0YV3qy1sSwf+fHDRkrZHzEKz/mEjYaBOE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753929041; x=1754533841;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ushCqJt1jxq6Hv7PpAxgFKijmgypw1mO/90AreCqXA=;
        b=e/TrntR51Y10QG/MJCpWfgp9NT+5T51Fnb/UZg/AcBporyprrsmOdir8RsaLgqtcvE
         DlpGQNiQ+gGh5FxvCHNtaWCQdCb2HkSjKoB8XcSrvHyTa1dUfd/vJfraXkR06ygAoHqs
         Ik4Q+AesdQcQ3xIiKD1h9A0rHBGWpEkJcdi8Ubo7tq7weilhJTDPZIuF4Oii57fypV9N
         crGkH7qcJsakzLU3s5099/IG6kmB12mLeAw9xzxZcKt3rLlBf+vMx0gue3FIT/oXf0vf
         BI+7+Z3X2W+4dr/fA5p3zxADxbY46rv3H6JztjeojMQ+bliU/k0bkQWt64hod+stYLcE
         m1BQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/zcprBYrL1jEmCzwWmKIT9xVeybc1ConzszrtJcIfN5o+JVBtycqD7dQGZ00uZLpo2gz8SN8+@lists.linux.dev
X-Gm-Message-State: AOJu0YxWlQ9E56h7R+/n/ONr1FLAL5d+ECkWvBzHj9RkrQAe/fU1w9Xt
	0B31N3Y9Tk+1nl/QhaIP9byGAosEyOgxVPpq+GBYZzKafynMfhap2Jc87lGSkxf2/w==
X-Gm-Gg: ASbGncuFLaaDsSALwDbRBfNpaObRnT//HcroCKAp04ioLH1Nqd4qAGebulrfnaxve1F
	A4hI+QAkzhXIqYKsr0eJyKf39hRhD1hyiE9ot6OowwlvVIfHHURAzCaosoqZ65OevbsLLq8r8Gq
	lk1KVqNSZzKk7z12dP5cVYFCw1ZhaPa4roIZAVnZL3y6AvHQB+Tu92hS6hmJsOpZOqOwykZYn2k
	kXqeswuIyBixUxxYsOeInwSHFeDScq1HmnGK8y1x5MF1O+9WkW9QNmatAvOGwC7Hdm3FzIBZwjq
	m7UvkoL27+66ZySuXtc/c3aUyT2WmSWTYxh7VbfYGFwYVXBU2budg4swiDAOn+pLnLTv337QPy8
	Ly0TJOtyg+ZGT9Gq2xVrmwsPjEFP3CgctPKjEJgs=
X-Google-Smtp-Source: AGHT+IEpDkOSfzGioCL1XlJHEiBvLDgHoxybZGActJKiPQtp5q7HYKT7qH3LFaZFNhuA+F7wTTjKVw==
X-Received: by 2002:a05:6e02:216a:b0:3e0:4f66:310a with SMTP id e9e14a558f8ab-3e3f624ff19mr92076215ab.16.1753929041210;
        Wed, 30 Jul 2025 19:30:41 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e402b018f7sm2521125ab.43.2025.07.30.19.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 19:30:40 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 30 Jul 2025 20:30:38 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 00/92] 6.15.9-rc1 review
Message-ID: <aIrVTm6WHKLbiThw@fedora64.linuxtx.org>
References: <20250730093230.629234025@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>

On Wed, Jul 30, 2025 at 11:35:08AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.9 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.9-rc1.gz
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
