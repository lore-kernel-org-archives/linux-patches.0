Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCAF30CD86
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 22:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760480352; cv=none; b=oKX6/yLI6aGPSKn/k1cGgUmkUOV1cQgEhXYzeId2ke+Orb4XuTNtYAZO93ukRQ8k9ZW9s1wSNY/FD74DdSO7gWQe7Bucx+rErkHPMyrgbei/UTdYGk8Bfu6KA4vVmawwCn7rJf1LYxa48aCTuU1WA71NLxd3nzqUjsGAiX099gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760480352; c=relaxed/simple;
	bh=d52ol5jDnCqNM35j5xvJNRzYXDEU3WfnARQ/CVHCRFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fx+3RCj3TxvDlclufje/n5bPHJRaYd0gIOhf6ugNxRGXziwkiP9s873HhCnTOM/G2OHltX2YUomv78vgf4/MGOA30+3I87hHRBQk1PehtiyTnNKgQjfiAufqiguQ/SRLOx4hBxi9qfgTNf9VbTeanVcu2NjZV4FBIG9XmWezf+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=EmYt/bfM; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="EmYt/bfM"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-27ee41e0798so93404325ad.1
        for <patches@lists.linux.dev>; Tue, 14 Oct 2025 15:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1760480348; x=1761085148; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=alzbq4xn+X7BhpgLRSUY/BiUcuSjAW2A5dveqJOGO40=;
        b=EmYt/bfM/R6V+Cfoa+MrLqe8gw9pKs9pUadKNOlMpKIs2VX9bwiJvP+PeP7eyBK/D6
         D9eQYX+uNVSf2nTctcCQUy7oL3aS6h0sVWPhaoZrmt2geF6AheRAYBKioxbmfDlQfKQO
         ODA1DTzVY/GyCYFGKMhRdi4FG8YhkcAiz+ork=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760480348; x=1761085148;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=alzbq4xn+X7BhpgLRSUY/BiUcuSjAW2A5dveqJOGO40=;
        b=BYoktyYcZlIUDK/A5sQOpidd0WvzcQjHQFN/pfoLcE0O4jOHqCSbWsQnE7Y3Lr3ezP
         SeXH23XdzNLsCfJHd6HR8DFxGqULWJLVzuAqxCbqV1KnVVdRwPWx6dMQWZp8Ppv0YlvA
         1VDH2bf+8Vwwz/6xP5SUn4Yls7Rzomhw2zOehSgo6zuM7odUYkrV+3yyw2EJHEBhwYzK
         jQpHJxxqgR4rUc/pzJ4dm0kdBgGrpTlAyW1IeBTAkx4RAB085S2LP8mbdgg6zyTwsxnX
         UNkcBQT5//nEEcKUz9KFXiOSpAxy4D8XvZ4KMgEGWcJdR4F2XE51O+HoUyk8N5iKfWhC
         XZig==
X-Forwarded-Encrypted: i=1; AJvYcCXN/y+lTRQDwDREOehSW9kOz3by9Y2a2l7wvUD3YOdI8L0HJs0SNDCPSlr6P/QO1P9rXugURMxn@lists.linux.dev
X-Gm-Message-State: AOJu0YzNEpO5Nf7AitdsFRNDH+1UMp04GIOGMSIMuoaGz4d/7bTAQM+3
	ZtDl37/Sg2OmyeI1f2etOLjqOEEN0EjEkd6S0GdVgXOmJnfyEQuLwGUO4S2xGLCdYg==
X-Gm-Gg: ASbGncv09mAyptaS2CXh7pzP42uVqN3jBAlcQ0knW4/NCCBQzEOBidxIo35237Pl+GF
	iMo763XyGSzBZaaVS7HeskNcjAob2B8nTHQGrja6ULFMtNHB1I74RuS0WXxPEO4nd+xMPDZJwdV
	K/d8DsQ7w/ov7rp5iFWlF7ajBHZt+dkrE15Lzr8P/8V0G9TPJUxXUA26nuKk17qIDuQuT+0eCta
	balliE1sgfb6SbSYOucNLyqWidNuyVNkMk2jpI3Lr+TRFGAJgKX0gjY35Z5zf4yvSLni7xKzPuk
	sclCZuakLMxq2eHVw8M4Uc1Unesd6q3uCtKfaWmmk0e6Pe9vgtPhgt1NysRQADIegOzxOICgafo
	bOKZ2Rb6sNKAHjgEf73PBMyoYyQ5iFF8MeuGC5K0xAsyToHHPwE61+WgOhWxItiRTu0muUvTs
X-Google-Smtp-Source: AGHT+IHdeP0YjbJf85NTvomIyM0+GVcr7Wo5mJ7Nfb5UdYxRTyJTMFJyGm2BssQ8MnxvTKoUs9ugRg==
X-Received: by 2002:a17:903:2ac3:b0:281:613:844b with SMTP id d9443c01a7336-29027418ecdmr328650695ad.52.1760480348537;
        Tue, 14 Oct 2025 15:19:08 -0700 (PDT)
Received: from fedora64.linuxtx.org ([216.147.127.80])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f93b71sm175405965ad.114.2025.10.14.15.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 15:19:08 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 14 Oct 2025 16:19:05 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.17 000/563] 6.17.3-rc1 review
Message-ID: <aO7MWRnf7Pk023jU@fedora64.linuxtx.org>
References: <20251013144411.274874080@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>

On Mon, Oct 13, 2025 at 04:37:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.3 release.
> There are 563 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
