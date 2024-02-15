Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75122134CCD
	for <patches@lists.linux.dev>; Thu, 15 Feb 2024 15:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708011963; cv=none; b=E+46/IMTrLkVb9PJVW+TDBD30iL/xyn7CXAhGrtdFUux3qFt5vaymrnUHeNEdzYf1q+nic3DkPRvnc3VYrSiervyqGgxVN7SfhLb+IilSoh5jNexwqsauQG6tw9PW9OcWS25/MwE+VQZ7GLiJmqhIYg4IvXK8B3IcHijsEP2z2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708011963; c=relaxed/simple;
	bh=OyYvR0nJ9m4/M/6O/Io2rVD4FvPDQMXmtlWBsQVhziI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpaNZRbdnr1STVGxLS9B8HpgEPsZu90h51suEH5Bb3bEzu3J8WGzDRXIlQjC8qDbjUeSuEcBqO/k+vn3rcBYDjD0cya/f8E3nzQGZnivDMMu1yI5y/sh1kQpQ10kl0hcZHL1BYoAXaxgerxTlOyDuIdcckfgKNdastwXWjdQ1no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=SOsD12Wx; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="SOsD12Wx"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3bbd6ea06f5so481515b6e.1
        for <patches@lists.linux.dev>; Thu, 15 Feb 2024 07:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1708011958; x=1708616758; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VHgBe25+eERSHksZlJnlC2Hz2Jbap8NDk0LVkzb97yk=;
        b=SOsD12WxjO7YPa78rq7FTy26KGwrTjWfkz39ZEg77k4vEbBLEuIXBHVTVE71aWxewC
         YkPygvf0+85i7HrgHfnw7R4sPsU71ocgRi2AUHs3vS2PmJ/FukMI3FvRVFRubC2e7Z80
         SUFzcIa3MlX08f1qRSxyWSg/wLOhRVrRIRaGI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708011958; x=1708616758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VHgBe25+eERSHksZlJnlC2Hz2Jbap8NDk0LVkzb97yk=;
        b=FCBJFQL3lUSC8USXlri4VkiMdW2BwLzP0AUbZeGG07ZreJMpEGE9QB0GgKeriNZqiI
         hltlSS5TSgU1XKT5IPL6B3OE9mDYHBomMCpKZ2dwZ7BsCIW4Zrg+ekzgnms+ce+d6nSc
         yHuDF+/BqLwILAMfQ+ddFqjx33rV2hWhzkBeN9D+cNIXm2SPEvVJJikstB95lEUOtQco
         S2mY8dFq675bOx49z9no1MBM9EOlBxqpKq9bahpfbHBM+7SDL/slBGdZJNud/KsU5RYJ
         TK1bnyhSrBX7Nrx4y0EOa8Qpq2wn54FfvWcHlck4SfckR6ZjjQ0lo2QiJ/3IaQr8D3cc
         HcHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgWrgSktEzmvlx5lzHlQo33qaUW6YKgNniFIhhz5kfYf3UXfFlti6x7q1Fh3C/djuyQhbH1m5kTovvajLm1mJCQMEza3izAg==
X-Gm-Message-State: AOJu0Yzug2iVLiQoFl6Dwwwodbs/4B4pAmkBXr6uGLiRrirauYBD6OSj
	aQkOEOeuMjvF1EWkURMlWnQKA0xgImWJ+5NFjmr6iekAmJ4A78oZJVIycozo5g==
X-Google-Smtp-Source: AGHT+IEn/CD+jUYHryIveWJjl5955TfMP6i4py7xzlOW5kREQ2c3KhoyBlQ5B2a7aIT2H4QVAoUOKA==
X-Received: by 2002:a05:6808:187:b0:3c0:33cc:3a36 with SMTP id w7-20020a056808018700b003c033cc3a36mr2386664oic.6.1708011958410;
        Thu, 15 Feb 2024 07:45:58 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id bx39-20020a0568081b2700b003c072ae9b4asm219086oib.27.2024.02.15.07.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 07:45:58 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 15 Feb 2024 09:45:56 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/127] 6.7.5-rc2 review
Message-ID: <Zc4xtIwDdjm_Odrr@fedora64.linuxtx.org>
References: <20240214142244.209814342@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214142244.209814342@linuxfoundation.org>

On Wed, Feb 14, 2024 at 03:29:59PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.5 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 Feb 2024 14:22:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
