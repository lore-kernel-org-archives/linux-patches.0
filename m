Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED7F10E8
	for <patches@lists.linux.dev>; Sat, 20 Jan 2024 03:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705721476; cv=none; b=NxHzcPH7Hfa4DzjJBGGHLV71NE/8QYJ3C9iz/05FkG8WwmQGcdQSAUGehOiA0592q6EQSxMkSvzmXoPuxD4pPm4OGQFp6jMGo32VeXbZ16jp7Dr/WDagoYRqirZ9H6yK4Kji980O7hrQpw6f8zBiIeKy0GKbCnjfocrjwRPsqwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705721476; c=relaxed/simple;
	bh=LtRSHTJnqurCuuUoeVR3XxOKcKwGNZNUO/DX3pgJzP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OWRjfEgfpSv0quhlv8iZtjNgHXOJ1kVlFM7OL2kP+8pd1mRA8hiXteT9DgaSZIm8PkNBCOPjHjF1e5bZ2QFzPnpcsUXvIO8jJsx5oXZpOOCfqmyShk66l4GIg2gQ3xtDYu71Vmrchi1L95Mo68johRbHePMBMs6DKJZ5Zycurrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=coGUDGsj; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="coGUDGsj"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6dddfdc3244so969497a34.1
        for <patches@lists.linux.dev>; Fri, 19 Jan 2024 19:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1705721473; x=1706326273; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=38qcoDIXRI39KIvBIjufdG8qjQjAnBCQ3jqDc4GOq3Q=;
        b=coGUDGsjDqI5FV5ub8+Yoc4ri9IwzCn/kU7R0jeLTf+7nYMnNq03++OXOr8sghj7OF
         4a5q5Hm6iQoxRFLcp3Hdd2/JTpZQPMwAgMHC38qIOLUrGW3XTCi3k593plf1PEDoQZQ/
         iDE5ivsOSAw1zufiVNH8JHC/QzmBeNwkiV/gg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705721473; x=1706326273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=38qcoDIXRI39KIvBIjufdG8qjQjAnBCQ3jqDc4GOq3Q=;
        b=dXmPAZ2ciVssKzhrZVtqUw+cUhyEUbi/gzZuSbKWnFKjeEERJhTB/gO9IAqPL/lMOW
         7kyJcaWWJuR0lIBs2GfLAzfjp2O7Z8SatQPNYyS3YV2b6SDqxM2LLodvXpYAmT8OIBcE
         mVA52Jg0wx0jH/4rDpnE+22cPvTPnuDabgu2c1iZDnq8N3gTVF9LAgalUDz0esLCAd2e
         ptwmMGkUGRWVDUMo+/Mjb2CyWaJrwft8PjavYH/uYtY0MRiuOefZJXaVyp11a6NAQo/Y
         wo/ol7jSScpmCV1uMXJgtf0aRpOYVO9RoSOw47xHJlTy3U/zl6fDuZVLdJGGVK6kaKYC
         0U3w==
X-Gm-Message-State: AOJu0YzcMbsYBi1nhvp8/BzkHJkdcpy9IXV+eCpx88Nq3XPRpgvxyTbW
	v1vsbNwC0V3E8BLOq7UnH2+l758dadepeu2xUSNBirD8Rg6ssdbCL2dCMaZ0Ag==
X-Google-Smtp-Source: AGHT+IG6smxCiUbNX5DL7lZWey0NojCCazFGjf6HU6iom+P+QCLURj6wlesO8HmUg81JtstOZn80Hw==
X-Received: by 2002:a9d:5a18:0:b0:6db:fb07:91c4 with SMTP id v24-20020a9d5a18000000b006dbfb0791c4mr834524oth.73.1705721473679;
        Fri, 19 Jan 2024 19:31:13 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id g3-20020a9d6483000000b006d7eaaa65a4sm784411otl.71.2024.01.19.19.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jan 2024 19:31:12 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 19 Jan 2024 21:31:11 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/150] 6.6.13-rc1 review
Message-ID: <Zas-f6dPWzwsb6Mb@fedora64.linuxtx.org>
References: <20240118104320.029537060@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>

On Thu, Jan 18, 2024 at 11:47:02AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.13 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
