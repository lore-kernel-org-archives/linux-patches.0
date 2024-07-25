Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AAE5FEE6
	for <patches@lists.linux.dev>; Thu, 25 Jul 2024 19:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721937205; cv=none; b=m4dvYfWprvtZHrB0DRuEaCoAxMjMmZOU+NF02QWD2CH42mN6tURIUeM1IQraETQ5VvGXUKaAA27Rd4eGxA0UEkAg57561vhT+x6zuroy8/bxWAcnkVK3+/ScG7ZjTh3g7psoXe9N+rJmDNYO2L+RvJ6w2vIigAUgJU02+bCVSRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721937205; c=relaxed/simple;
	bh=Utp0ONC638uinIa4DYXOLnH6T4EHZPkcFf8PZrONAMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2PcwUfCZ9gRuX2pV6USWWeEeUbKYYdcJlkqgEx7KJQPoq2cXRpGeRuz5vPXd3itotWgyZg+Q77DM9dkY6s+QvmNCB/0VwAI4z1IwSttM4zIZy7n0MC77hsh+3pCHf96MJIxkYVehyL3uLD/3Hcyz5k3Sp2vlkoQGjG7PertIIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=TvURn+FQ; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="TvURn+FQ"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-39948831566so3962775ab.3
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 12:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1721937202; x=1722542002; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aJ/GUQ2tjYnP+2H7FqWVb31mphUxYtPXsZYEwwVMfiw=;
        b=TvURn+FQBEsMC5E6lLJ+ABYrhipSyReZIMzFGwc9ErYspl2L1gWRJYKlf97U8F3CNn
         k4HuXHkyvMxq8UGWpW0XniP50FhE3L4KZAIUC1Bx7tL/UPo/a/io7+PphvgRXEfNhh4V
         FbwmW9MfQIWmACk8nunpgSFj4sx6XddnXJE4I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721937202; x=1722542002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aJ/GUQ2tjYnP+2H7FqWVb31mphUxYtPXsZYEwwVMfiw=;
        b=eR3+gzXtRQt3fAKRm94rHD1CZDc/Yqq2ZftWRxy73Z/C8YtsozXlgi+shNPgDlPKGD
         0ty+xpubxj4q2tG8q9lZisbLdaV106drfnHKLyiNAjB86I9JwNorwN8SoNxxjYxKQ0wy
         vZauggHE/0rVJTwOjoXc7pl1wkW/g21woqHDR1TINIohiLoouAtHOI9dbajk9fj/yEI1
         RjvUIMGjV9fMNezaWvUkOMptASJDD/LUivNtK2KjtICj+9NuYn2UqPpQdw/r8vn/vtio
         7QaprWxWUJtccs0ZYroI+aPZFKUKtbW3M7iPa0rUapxlxJRXzdiO7jYJdkjOFoBxsWli
         zTIA==
X-Forwarded-Encrypted: i=1; AJvYcCUdZ6e/7hMYIsY1qz6NZvoBb5aa2u+Vejj+DATdoFBWXzED02c+XQ5u0wTShcv6w/IsIj+t7yXFhqrtqjJuzNLV/o+J/xFHxQ==
X-Gm-Message-State: AOJu0YzyV3qsJCKl7DznTNavQ80cNH+Ljt9B/y7tXxxsVfR5ih3poBnl
	81+4mrYrjx+5Q7dvwSI1owvzo1YnUsHosJsE5Jchmq3EYZlEDCXzhOuOaK19kw==
X-Google-Smtp-Source: AGHT+IHSPsHUVKUyMsr2WhHJqJNS/jVhb2RgoQIDsE+JBJeCVQ0e+zP5yJW596VfihSYJuRw7xeHmg==
X-Received: by 2002:a05:6e02:152e:b0:398:acbe:d798 with SMTP id e9e14a558f8ab-39a23fa0d57mr41072375ab.4.1721937202047;
        Thu, 25 Jul 2024 12:53:22 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.171])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39a22e976besm8679135ab.31.2024.07.25.12.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jul 2024 12:53:21 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 25 Jul 2024 13:53:19 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 00/29] 6.9.12-rc1 review
Message-ID: <ZqKtL7_yP8lMqAX0@fedora64.linuxtx.org>
References: <20240725142731.678993846@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>

On Thu, Jul 25, 2024 at 04:37:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.12 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
