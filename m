Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FE1184D
	for <patches@lists.linux.dev>; Fri, 17 May 2024 00:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715905763; cv=none; b=kCu302jvxFpHpCdM+K9mx85SWJFUZvr8Ndrbl7qgaqcFG/rBiBdUWCQGDvUG3uman+twJMb/WjR9MkmD4X9VjVFaZB6tNbQqu3R4EyStruh24u2RlhaA9vgnqW4RyG3AKkW7a7yLOMTnQooHJ7aEyyz5avX78tByt3VjJb5wYYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715905763; c=relaxed/simple;
	bh=qpRGtEbcpdaiFAoUh1L5jAnGzbs5qHszLJd42Y9C1J0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ji0tOSavIz370L1Jizq+dOpEssVMK7x8lX06akTqd6U7LfP/6wp3GN5IsTItIct9+i3ckl48u4Ay3oBECinXRta1d7qAzEPoIuDjEreEIqZB7GQPfADahUcUAdLvbqZygwp4EWCyXV2MmACCy0vZ8BFtQM3GKgbODZgodqdaVtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RqEmA1qO; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RqEmA1qO"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-4df97a50d1aso53857e0c.1
        for <patches@lists.linux.dev>; Thu, 16 May 2024 17:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715905761; x=1716510561; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UcA0xx5hZvyYeOO7QDNErhgsJFWGZEi2aPcF1osbRvE=;
        b=RqEmA1qOJiiNnHA0kdz8Zn824Ny+ZS3crL2FP2oBD4pLpQvwfe/ra5hk8WFchvJFpd
         y3JvSdfkRbJMtWxBKkvttZ62n7BmMzbObNjByasoLEW3dHiuKXCnQgnUPGX206afjVAq
         HwkQi85Z62lSJap07oJKjed0b64fJV90NcaeS/xOAsO4jEx2MOMkyZNosKNynJ2FXbxB
         c5NdGkYB31w17Z8QHifs52+9DM2LauS4bhFORYH6M6dAMA+MY8MuhWjsUGTfIiajv4cS
         DJT1TvFF+KX3RJRGhaOnz+PJcV8D8LG8OIbe8LtCvZzG4+4paG4cCjyS9FGtYyg5+nJh
         ZLDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715905761; x=1716510561;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UcA0xx5hZvyYeOO7QDNErhgsJFWGZEi2aPcF1osbRvE=;
        b=tcxxtO0WTNn18owjRYQF94Thz9530lAJhfD2+w49fJ+4B6VGkSM2q0nM+63DfYoPum
         oY2vgvZY7E8tSsXwlxSNHBalxBDhSBMHT/VSm61IzS/gKpsM9Px8GMnB2VBKE3E6vcDC
         BDlXoTKzxnswEdzbaDT/K0WWZo9KLnX3Skww1JhVZ422sp2RPZ0J9W0j93cvirG7/t+7
         gqrSv1lGhVOZJ85xKSTNTC9nYVQ96wEhCulD6jKh04F556EqRVH9pNqj2lPElW6nJW+J
         RQeEiKsJDKxHwsa1yTaLgunMh8YiLVYLkU1akdog5k5+wDHv3yUiajEk8XxPxNYQjsre
         rCiQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5RGL6GVdOSzfEHlx0ro6NuvYa4LWDhjVQa79ggpxL+b/sJvRNQZRtGlEhRM683LEtZTq/1JU7pQIUoQOfeeHD6TRdYppb/A==
X-Gm-Message-State: AOJu0Yy8hWzPDCPZ+bWHgm9qzy6/8s+S79xvPskBJ57KjiPhnbP6RtnJ
	haMVZz0RVVEI11hoWvvc/lL/vhA0m/Ro3fWG5E5D/w/tL/PUymVbKeiW5Gc1BM0dariRil9zlRl
	GAjT2Vf9fgn3wAQh2fZr++WnZgzI=
X-Google-Smtp-Source: AGHT+IGBWv2RO7UvUkrIOEyvNrZPRRwCwnMeoLbFJHWoecfdbq/BpcqbfupXycmKxAjvQ1hAwyiRkTW3CXYeTRzTduw=
X-Received: by 2002:a05:6122:d95:b0:4dc:d7aa:ccf9 with SMTP id
 71dfb90a1353d-4df8834b383mr18148990e0c.12.1715905760942; Thu, 16 May 2024
 17:29:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240516121335.906510573@linuxfoundation.org>
In-Reply-To: <20240516121335.906510573@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 16 May 2024 17:29:09 -0700
Message-ID: <CAOMdWSJ01-cON80thPRnoCdDqyNwo0f-HpF=PaScytwLUnuZyQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/308] 6.6.31-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.31 release.
> There are 308 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 May 2024 12:12:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.31-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
