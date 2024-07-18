Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACBF2F877
	for <patches@lists.linux.dev>; Thu, 18 Jul 2024 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721321726; cv=none; b=FAVfSQRJQeQhW7w4XlfJclLFIr1uTdnGPbMCLKtHn6jhYZTz+ayE3TFY5wyKBUbBob7liWcWQ1y6pJF1xv2QmNzZ5KbIi3b9iPbBrz0VKlARmBmVWC5etY+8kXQmN5dttZfJqZPT3cPZ05clSVimORpIriUsE+2moADFSH2B7iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721321726; c=relaxed/simple;
	bh=L704YxFv6WxS/2XwbbkAAHUe+jUXMMPapu3Jvt8nbqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VIqa1bbMphw4tusSJwdfjAnnt/IKyFXpBghixwntGKPZX/paFynXuRkFRuW3imGS0j8zDAFPx3G+OkSh0ELSBaAFTAKpJdZh6dtBO8G0UyYmW1o6W9/lcMdD6uqCSqtl8spiDVXkW35KOLcCFp7B20+e8JrQXmu8OpbM+CHFm2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RlPJdRkw; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RlPJdRkw"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-48fe7e1c6feso264976137.3
        for <patches@lists.linux.dev>; Thu, 18 Jul 2024 09:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721321724; x=1721926524; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ebmgK7JnwwSSz9YsrAOoF0dr35Ecvk28jzs/lLa8vlg=;
        b=RlPJdRkwUoU08VC7i7pI4eMs077kW3jXB1QGtnVGLdqIvta1oam9nkHv9sMnxrJ+v2
         VyZTByYC89THhQFuvA6E3CSeTdtxX0RTZLSNFeHesEzlCcenciiAqi9yp2igNDbVOtrM
         lp9nzbbtQ/oZ0433J+FN3flegNUd07OUtZdjpqrsR7PIGSpHwaOiddmtwXro++Zf6WYs
         so5K4a2KFSxbZ23qYuOYYcf+8MqYEui+vuXQZnSmnnzEBBNOOkgDCYHkthhmaHyXLpsG
         Q3sgIMABiGIaJ3PDpwJhhgJ39dOQCXUkpRG93FdpyK/ezRWGGOH1JXcAUHtSMzR2C+zN
         i9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721321724; x=1721926524;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ebmgK7JnwwSSz9YsrAOoF0dr35Ecvk28jzs/lLa8vlg=;
        b=d+B9GFVFTS636WMCKINCzf26+gH1tu4EXDo7HQsNEnr7lJmqQpQLT35jawber3j+3k
         IFLFuusd7fIAZqS4ZGaq4CIQIiLZ9z6PpzpIwv9wjUe9fSqiP8YWoH90hgSxvMmGspPo
         E2zv5tULvM21lfC9VFfw5hq+z73LToNamXgPRlgjHXUh4yig/WY+5fwm+UVjO2EwW/0U
         Qe93yL5DygWpfrYWhzWaR8bQ0HlyBfyAh4EZEKCpevQGPBs13s6dTf8RCOu/0UG88pex
         54MWVGrbL8o1iWN3RUO1LU//HqUYkqmR2SXm4DkQeNl4MrCPaau7goyCRMvFsGdB0gWC
         PSwA==
X-Forwarded-Encrypted: i=1; AJvYcCUyeT3ymkaHJu+NEAXL1HEwK97pBuEIiJuQfY+Ug8mPVH6iHi5D5g2E7GODeA7B+6R8WnqL2wJl8lPSCUC/Ol5Xu+/PRcClzQ==
X-Gm-Message-State: AOJu0YymTDSNcip697LfPdAYXyqJ6PY7SHUeG9atUvUuV8gSfoLx3J6Y
	159MWhsRBSHLQjgV68uw7sMpKmakPaDVLoXpkd61xDyKUrXq3c3YZ/gntYnK5PvNZqYyDfKXdCO
	EnIccCKpdPG8Vh430gqMtd38dPKw=
X-Google-Smtp-Source: AGHT+IHymPvqbtbvbeckpfoFMmjdZw1WhewvBshIjDm/V2E6daJTQ5YMxzVXkrZ1CzwHSTPGjJ7z91XAGmtMY3t9GHY=
X-Received: by 2002:a05:6102:159e:b0:48f:cb62:231a with SMTP id
 ada2fe7eead31-491599a8db2mr8253335137.23.1721321724502; Thu, 18 Jul 2024
 09:55:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240717063804.076815489@linuxfoundation.org>
In-Reply-To: <20240717063804.076815489@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 18 Jul 2024 09:55:12 -0700
Message-ID: <CAOMdWSLLpy7=A-Qqg8vCvu1qOOG+EMZpqkwhFg2767WZ7n6tmQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/145] 5.15.163-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.163 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.163-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
-- 
       - Allen
