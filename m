Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B336B1A76DA
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 18:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724868287; cv=none; b=JOqz81E0FlEoH9xG3OtAQwDfJvNMnEnRH/7CzRkH8HrhHhmqqL/siSKOqCQfa/0HjTQoZB4E0eUOu654vUUk6I076Gdu+oUeL5j1RXuvuidRoJAaN01pGXqmtnvTEkQVroEjT/q1es1Tf9nobezP5voYK5C2rsxQvYSvcB9KeYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724868287; c=relaxed/simple;
	bh=7LklAEbtnglm2QqbJRXoOdk5le0yekVD8FpktvgUQ0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wju8pyx7SDxs6NyodxEHJLSanFLjsihfqk8RDrjrZTZMh1bsU9Zw1FAqGpiHq2dIylHFQr3Errlzdl9+mgYxKmvjmg4my/Pl1mhLrWxul2IdJK2nCncOBdYIhwu9x47qs8/MnQMnyqEk4gq2GYO+qRY3pRRI1iS+aDm3Tqzd/5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=XUozOeqh; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="XUozOeqh"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-81f94ce2272so259579739f.2
        for <patches@lists.linux.dev>; Wed, 28 Aug 2024 11:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1724868285; x=1725473085; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D88RxHw+gLXI+BUbdOUTeiFUlCwvolVuRzDJ5llIRd8=;
        b=XUozOeqhBIXl9NURlIuxEvvOBtimxr6hyTMDxNLdpDJVg55KCXqYWjDs8U1JTutbxQ
         RJw5dN5MiwLC4lPVpyOahMQjkuNHckNrbLP+Pq0Jaeq7BKFSDTZsbqoh6HNBEJAnad+/
         XlmPS3xeopSHsdkawHcn2fEFSWLJJu8+9fxjU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724868285; x=1725473085;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D88RxHw+gLXI+BUbdOUTeiFUlCwvolVuRzDJ5llIRd8=;
        b=LfCVDZBwndWHzjZwVd8SvzcikxQlMgLAvS+k1gT4W/rrfgO4SUjoSPvpMgUJsMdvVF
         K9oIhrKlwRQ6zJWqfRVAolDVDqLHVr4BiL7RkWvmAeZ2vzqHZmWM0dhx4ziucFo8HkwX
         XBDiBVB77Y4QdYPJI/xy4KUmJRKYALsFgXo8PYwiQapEKBk/TIh0xOY/0NtUhv5wtT8u
         BjdHRHHenQkPA4BpDat+o0bJW5K7lvgxFE4NxNF/ACUdLgMIlFwybtXCBimuK6ACc4Dm
         oz55HsgQ2wSnXl8I/cZYJngxI1rI9WmAdy7yFFyXag3okBYZ88jH0BdmDomGmMveqFzw
         tUTA==
X-Forwarded-Encrypted: i=1; AJvYcCX5t4X2oCowASbeSIWyGfRZt8TAizauci+DDwOj8UyJmU4l8C6fgU1Sb2uoOn7+n6tOJRsDkTU4@lists.linux.dev
X-Gm-Message-State: AOJu0Yyxdp7kWFMj218YPHwvoHiYhQDFnSGqqiXK7tMaDVif0+C5/FNG
	aOUYjrsfTFTHXCM2WUs78JPV7fN6hvfksCosylHuPI5GhbwBKOLCckKQ4RWN4A==
X-Google-Smtp-Source: AGHT+IFD5bWw8dwybfSsYbERZ4OkMGlI4FfFSwejbt9P+LhXubeZLqrOlKHFBCJir/bc35aQBU9JSA==
X-Received: by 2002:a05:6602:1487:b0:809:83e3:a35c with SMTP id ca18e2360f4ac-82a11036779mr46952939f.7.1724868284479;
        Wed, 28 Aug 2024 11:04:44 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ce70f1fa89sm3123229173.16.2024.08.28.11.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 11:04:44 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 28 Aug 2024 12:04:42 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/273] 6.10.7-rc1 review
Message-ID: <Zs9mus6WLnij725m@fedora64.linuxtx.org>
References: <20240827143833.371588371@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>

On Tue, Aug 27, 2024 at 04:35:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.7 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.7-rc1.gz
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
