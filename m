Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4091E242D7C
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 19:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760125705; cv=none; b=F2/BPcB92vKy+cpSUwgpj7aPRIZ59/BlxsbXHJkyO+oG4WCTiBGL/Ea/ZMrPTZ8MQhaexbrM3kS/DG9ABS1jYq4Gk69WVKx00GL0jQqteVd9e9EzZd9SfsitsXz4X4F5gTZC9fcnSUdIj1l7hTagC6MgNXUoTIl8sSF7MncCGog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760125705; c=relaxed/simple;
	bh=83wimRLVprbnqmC14GL+S6WE4qbPtRnCGe89nxv9bhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F+6IMvRwlAVc4K8C3PK+wCY2MxylamM/qWLnjOy1e4ud9y+7Kch7yKASWNMcnIk4s5lrJscvrhBCna8sfTTlv5WwWmcQfKIHdzQn9lp9bnBvTH/bdCH9xySpqY9gZ9BW4tRdCv+bpJURHg7tld6YoRRs+/8QLll8v5RVMl0tJLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=GpLl2zxH; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="GpLl2zxH"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7bdfbc6ba5cso1011799a34.1
        for <patches@lists.linux.dev>; Fri, 10 Oct 2025 12:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1760125701; x=1760730501; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=De3XODNHpFwsaVSSqNIM0lQEtYxnx4u9mKva8FKwHIU=;
        b=GpLl2zxHrvguiAGPIEPka2P9NFcVx+F8Et/iAZPMGGLmyLmyx85r1Z0FGPxWZjjYs1
         1JvPip/WysTwR7/0R5nGmM6BaoTVOk/iAqn/BJF9xDKdGfbZZUMdBaZgRBWS4Km7nLOA
         wSxgQt1wAkf3jv+S38cxMrC24pPrUzySqY7XQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760125701; x=1760730501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=De3XODNHpFwsaVSSqNIM0lQEtYxnx4u9mKva8FKwHIU=;
        b=BdTNPkmRTLejE1NZc/X4yMDK5KivNUuII5PYrWnqaul9+a5BK9i7KdF8nHYwOTCQFi
         cWoBZ/rplKtOrWAnqmpaXPMnDLm9p1YY+X5wPkVu4Y3piZUHGDLqGy9TaUdxxg4TolEL
         bnKJCPrxmdbbsxaCGIONBbFsu3MjzsImuIq3aCTQSGTnVu4p+YprCazGBEJflbz/lgaz
         4MXOf4vB+6j4Vt1Oa3/rJ1mc1LCx7Rd4Y8Niq+DRthG7e30KMesV/r3eSLTxVn8rYk8X
         o4Zh4PqGFHAGELvyKNhYglMYUza/9XGPeuAysY0vDye82Jtvts22Henlv/LwvLppBQFy
         twZg==
X-Forwarded-Encrypted: i=1; AJvYcCUaNOPuuwor2oqcPGZ3j+UhJrkw9nUFBRqjvGJM+Py2Jy2OcLFTZJg0ciKAjsvs9XoCrSv9cG08@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1/ysq7VspDmCNSnEZB9QNW7Qj3ewBqQFx/wbcWruugWYn08fJ
	5PCw2IklpQFBsMnQKOhn77M4C+ZFTbn6k0YEPtePx2JrK4+4NPAQ39facuGG5+3RDg==
X-Gm-Gg: ASbGncuF7omOdEZKV5qFRmhy76QPSptwoMQMHHPFa0i49Suqdh8S3uEq+KYbR9Oy9FH
	yoYjpUfuCOauYRs6CmG79uHAtyLwNwF8tJcyORKtumBb4F80zOKo3p+kv7Gb7Hz5zgrONRSCNg6
	XFxgOnL/xcsWEGhBKZvsmBz/lEA/FeXcSjo9ijQ80l04xukJ8jmxhZedOeesOIenefruSQX2bdn
	k4BSfN/UV6S4Ncb7k1MVOM4ajV3aUAGDpyjYHNRiLfmvHHZs/iESLkmxW/mUWud1s7q666+5VaS
	1w+9gVVHIuQcPLRCtdGeqXjpGesNHtLJkLAi5D0X0nyLP9GXKY/IAdYunlBTd94ByhRb5QV1r0S
	FAweHl9jo4/tHo0hdHF57+32vcBikQgmN3IIKlxZnlWtf0HD1mPlfLeyvdGUHz0o=
X-Google-Smtp-Source: AGHT+IG2a/R7yGXvpWUnjwb2SugGnCDZzWLdoueR11HoiEzxPMFcCyVBrmazlF3z2WbJF/PnTfSfRA==
X-Received: by 2002:a05:6808:1905:b0:43f:9c7f:9b28 with SMTP id 5614622812f47-4417b2de937mr6142483b6e.13.1760125701122;
        Fri, 10 Oct 2025 12:48:21 -0700 (PDT)
Received: from fedora64.linuxtx.org ([216.147.121.221])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6501a8cc2bbsm584872eaf.7.2025.10.10.12.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 12:48:20 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 10 Oct 2025 13:48:18 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.16 00/41] 6.16.12-rc1 review
Message-ID: <aOljAhZFwcEiHqPJ@fedora64.linuxtx.org>
References: <20251010131333.420766773@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>

On Fri, Oct 10, 2025 at 03:15:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.12 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.12-rc1.gz
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
