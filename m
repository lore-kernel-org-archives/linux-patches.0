Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40C9357A4A
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 12:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765975902; cv=none; b=a+BF7OIRVQu1N6UKs4YBFnSOUswndDg93a0zjQbDMhkJAVcssCdKXMH2n5cn8PCLOkrhWSt6JyLuTiJoXrkUkVKeqgDSPpRbAIuocjXTyf1tvHXjC3dvpPkk5SqE7e88kfm6zFHTdJmOHsj/7o4mOpwl2O7/EaoIT1mwo2uzGO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765975902; c=relaxed/simple;
	bh=Q9NfrQgzON1NuA55ZAdPznOu1JV5p8tSPAcEDlYLfws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ae/mjCsFLcmb0LslFWD6benI8qzvQIpAeWzSdc6OLYjoELE+Errzung8LWLJeG9pc3bxPqBPsGWM9CRapeItLbJwGglrEMteTaWBdMoHGtopWccqmdtL+86wPI+vsJisAOJbqyj0JlWQrR1Jk2+OvRAtzMs2h50suNui+F8jkTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=bVxpINMq; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="bVxpINMq"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a09d981507so4547395ad.1
        for <patches@lists.linux.dev>; Wed, 17 Dec 2025 04:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1765975900; x=1766580700; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w4zvJpq7zSMNXdeKKVv8NeDTBYC9vFAr+5L+jpAMPxk=;
        b=bVxpINMqFw9D0fGFvZ0aMBCsbNvIRYXoLXfux27gamK9Y4nD2S5JQbdupRSDYPbBoJ
         oCDsM2sEz2RG9IN9SMA3b8ib1b0MGQkezFqvvIU3sc3eIKQaD8xA1nQIc7WedH7tQog4
         a07lJj5NvsTumqo0bQh2bHwwQlaB0UV9xpCH0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765975900; x=1766580700;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w4zvJpq7zSMNXdeKKVv8NeDTBYC9vFAr+5L+jpAMPxk=;
        b=DQOs58uqUQZDe/0N4nzL4uFb/Yyz4MbXoqQr9+EpbXRkyq6r0C1h0nXM/o66hN9j0i
         mZVTpjSF/3yPIIuGiWBljX3+e6K5qY3oDa/tHdP3DY3mXaNRlOO780B5eXHnaq7/wHzT
         XJxlHVHwulFdCnfc0/2gJKEh4qooa02XcqSeFbWYVk8pqOqIRrjZxLKRlgu/P99kDeTA
         ny8Y5ao/10y/NyXmcr0LxoNvdkfQ+LqTk8gMHspXDOcIOAYZlcnrrm9rcDYw0J2iiLzX
         eMDK3L8tKwSlMHzxstYqcPtvUMX77skmTnIWVVDPetjHXVxGrsZ0bQBBSQrvsmcyV3Q2
         rlpg==
X-Forwarded-Encrypted: i=1; AJvYcCWPYF6fChEyvr2H7q2ndtJp+g267wrsVHidgSoO0y//OjoLNv/CWdnak62XAFESdW8GdA8eoLKh@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1cym1OWCuXAuZbywOQKKsxf7cyGSlDMZio6Z9VSQXeJfWeRNn
	iE5Xm1NzlBMfyE1qOzJGhEZaoq/Vwxzdjf6QOX3+KH/lV3OjD7b2VHzMFOo8+5YAJQ==
X-Gm-Gg: AY/fxX6zjFP9bwcFjmFA9dtfOr9losnzQFGHpGuUIlJeS6LEI+EvsBTOgqes/N+onqD
	ER6tQ1TSYFtc83sC9SM2KFHsxIN/z0za+2RFp8QrYMxaGtFCMfzRmR424Ft7ioTPTwc0s2dy+Oc
	G7alkBhDgHNjppBaYVnmOkTDIx3SgpeAOr2w1C2gD7fMYIRqhe9D6J1JurrRIGdvYfB0W9hTtCB
	KTaK8lwnKYf4V3OqE6N0BFTeAbbNkn4G0dCpRUxbvFoSEM15i05bnqt4PBx3U7b5yrxcsK9Kf3V
	GOUHbPPX4XpaGtD6wNzMklhAKydQGKRoX4S1FrxTQxbtrDR+zMpkCJqPqQfb9mR5iEWUIhdjE0V
	E1DF4kjGqtNV7Dc9rGsfx0F7JpY9t8QqzqQknbbr1Vsfxmwufy21394LOVIaOt7/3e+jvgwn2yd
	xnpnVJllPswHY8Q8j7vrs/PsAGkRsRHaMv1ODTjqqZGw==
X-Google-Smtp-Source: AGHT+IGdmnKF+so0f4dwJeJUBGiJBJF63KwEnnu1wpi/N9ykFrnmhiL7CUwyqzjCGjHF/UYJzFv8CA==
X-Received: by 2002:a17:903:2ec3:b0:295:4d97:84f9 with SMTP id d9443c01a7336-29f24eea3b8mr187391935ad.26.1765975900147;
        Wed, 17 Dec 2025 04:51:40 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.123.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a0833e24easm143335795ad.100.2025.12.17.04.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 04:51:39 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 17 Dec 2025 05:51:36 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
Message-ID: <aUKnWN55-QaIfqrB@fedora64.linuxtx.org>
References: <20251216111401.280873349@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>

On Tue, Dec 16, 2025 at 12:06:07PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.2 release.
> There are 614 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
