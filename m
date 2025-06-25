Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174D8260563
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 13:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750858174; cv=none; b=iKTUC3X4M6ozSUSwnzBtSl3tzLqJJMk+8QV3Cek3Rt5j5IgjPunuw5YyzyXbtfuqdBOqQ3rtteBXzAZFa51TvrTWkty+IZ4MpJKhBLCfEr/rZTRgz1EmAL/d2Wo+f2CtjXKYO6D9Jj+w2jWXKMcN4+jVAKAtDcSQu59C5vd0MiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750858174; c=relaxed/simple;
	bh=HI9la2QsxuOizkMwcoaS1bXXDpyUXSLfDzTpd/RFD+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHJVkaPvEmVnd6SWJp98/WPY2FNu67rst1Tfe3Q1hkpxzC3vK58kOW2Pn8r1sTDaZFxacafAum76OSXn3+N1CgLjVnQGBA/IXNpu+t2HCs/L2zzHkXMwst1JuJzT1tFQ3Fr8zRNHa8lCOyc1eU2znlI6kDbTfU6NN64TCNxHpYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=FPcLvvAf; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="FPcLvvAf"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4067106dd56so4270597b6e.3
        for <patches@lists.linux.dev>; Wed, 25 Jun 2025 06:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1750858171; x=1751462971; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yeGY/v5lQOSYimAG1TJEUl7+krFvp4WYJspcjdIjkl8=;
        b=FPcLvvAfWPtgrc4D8ssAT5Txa5acAHlldUH0eYNTpRaQt2iq27hzxugL2wBepGB2Mr
         D8RU2bgbUO8Fa22bP0dUnablIsmEtl6KCDd0ewv6QfId7tG9TOMdw8/mQNT29yC3jmUb
         TjgobT1Q3mdQIFs8eTqS7qC5ZKoTDPJmWjcPo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750858171; x=1751462971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yeGY/v5lQOSYimAG1TJEUl7+krFvp4WYJspcjdIjkl8=;
        b=nNkEu4d/tTw0HnAcow2iR76kPy2IBNnMCSdvd/QIJba+o7ujHSgNpUx9MCFCxqeZoj
         UJacx8IIRUd96hQpJl48nxz9H+39iJ1mbmsIvFthXdjzaYk/EgelqwEOSH2/QNMkjN5O
         2f7w84Ngc0Vbzw9/KhexUjVUccjQsCyEN9dLIJ4eMtdR0wv19nW+enFYUo6vyjw8fbbs
         kZgR+Dzwp8APtONKrgikQpk3Tsbj9Ph/OB4X0xXGOJxlUgPWiWAMYPQPM6I/5774RNov
         kGUHxZPHILerqnJhPsuD5hgNRH7JMBDeUeZ7w1f8U5hAjBZtWjspPyjJPWZrcf6sNiy7
         yKJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlS1g4LnhrEBxuNaYvpzjg6NlA4m+ApsSMvAF6GLqulzkTe7iL9ck2Oet33RjNsMGTS4qGw4p3@lists.linux.dev
X-Gm-Message-State: AOJu0YyO8Q/DK4RMyEFQhNfBaJZ+wbXJGqRKmB6hwdpghkZRXVwlYkFE
	CSirHsZFA8fxToc3yT7J1trL3LRqTg0wAqnX6mrJFu16fe0hYFeMwE0AuUupINMl8w==
X-Gm-Gg: ASbGncvY8x1YoDgzzoswW8XhfU4E82J65IXEdvpTPn1B03ci6Y6MhWKmRuEdT5SACF/
	EOtyUds7oERlaGLLaRmxXmRHIfFm/VRLnkWPAr0ve6nPVGoz/wxvoTjR7ED8iUOGKxcyEgZtAhx
	j5gHDVwCA6L9eS63hMLuYDouDb3jFQ4LcCDhkwgNAjsS6nVy8BGgqkScjUhwsGepMuv87fWysnD
	8ivKdf7SsseIQhI0DviZvfqEbI0da8NA8CE28UMfgRgQGW0q3iTkU14dDbQKZAZpT3pZ8p9/+6Z
	Y4P3PXCo4VvqWC5hx3vL5D3GnflIRvCdDm3gJkx+Bum5qf2iqmTMCrCNY4mKDnL8MUiAWI57tni
	VQWk=
X-Google-Smtp-Source: AGHT+IG2FI1jDRFQ8TbABRF9Bhv3qaEH5qecJjomLNpJZJ+9FLbz0XOtMMk41w+LNPolSsQ/Q935Kg==
X-Received: by 2002:a05:6808:640f:b0:401:e8b5:4e4a with SMTP id 5614622812f47-40b0572241cmr2882440b6e.1.1750858171060;
        Wed, 25 Jun 2025 06:29:31 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-40ac6c13330sm2150599b6e.4.2025.06.25.06.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 06:29:30 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 25 Jun 2025 07:29:28 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
Message-ID: <aFv5uPHCceTAbx9I@fedora64.linuxtx.org>
References: <20250624121449.136416081@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624121449.136416081@linuxfoundation.org>

On Tue, Jun 24, 2025 at 01:30:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 588 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
