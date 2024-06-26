Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53D917F51C
	for <patches@lists.linux.dev>; Wed, 26 Jun 2024 12:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719404344; cv=none; b=QnliBWwOpVlDvRBxZfAnM4Y8V847YXq7pmTEAs55HOwHm3G4crWP5NiOiyVKUvKXOdQ33vlrMX+Frh4oRpDUvFChhitJpLjxUg+waw86L6rOXqScE//JtakvK7sAimoX0+ZueUMSVmUtygZNejiwVUAYg3i9AmkhBSAotdEJH3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719404344; c=relaxed/simple;
	bh=56dkKsWwS6gT3chl9n/33P6uCAEWaG+N58h+O4G8UQ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XrrXG5wDpxkD9wkvjeglZJC3gaOFAux59dVjZS2Nlv0SKvEQxQheDQANrKxgFd6wDVBNNXk1GlmBth5XOFTjADZCD2HK6elTjFfxgPsTwW1tFn3Fmmfe1obmSwtv9GJqPyIbO+kLAPTX4246GGob2qkilxBxjUQ+Rgo8hnS2DX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i7KoBmDa; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i7KoBmDa"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a6f8ebbd268so92006966b.0
        for <patches@lists.linux.dev>; Wed, 26 Jun 2024 05:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719404341; x=1720009141; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cEiETu+xNt0IYUh7HRwOgMHLEPTYFNW00L5a7FsgGcc=;
        b=i7KoBmDabgaVxX6kN+EZrSaF1Ig8rBuaBXuuhsFO/IMD+W+pMtIC+1ixdsGwFOyKWP
         hIVctEYmjCm8eq5n4EHumVxecDv1jJHfAnBZGkOGuFP8kvCCBzHalkp3gjsNYswd/YkZ
         8Tydu+f/0Ae2yrWJ57t38BPidtyAeDKURYT0BQc453UK9clLvPKXzqZtjn43RxJuDv09
         1Ef0lr4lpucJZuaKtX6r98f/HCSLgyCUmKpYL87kN90jgpyUHInjSkxyknVVebzBHb96
         4znGKY/fBQWoLwgHnAQ8NmxhyfOqw/DD31sPMDUohnwTZ8Fyib9V/BhfjYWZHvPr6dIV
         ic7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719404341; x=1720009141;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cEiETu+xNt0IYUh7HRwOgMHLEPTYFNW00L5a7FsgGcc=;
        b=tf9AW3WFYpwvAqUDYJC+cY3FHtoh10F1/bjNs/5uJYmcsguGdtxO6/X6iWXqLjKDmV
         HJO53BGJaME81K0ARsZW/GHR8t09F6kox2ChrYFkTF5Ce8X8CNcZ+JyaOiFGwIHO6Pzu
         WLfUkjVInGIbrg/Iw3YZ0v2zplVl3fkEXVnCcKyQG1x3JLG7mra2bcs24P01KNsVppAH
         +hnrdMoAJetobX1Nf4qeEK5mruIKU4irB4dWKyEXu9/+q61uADW5LUJBxCFvdM5TkChI
         9zVdDIV7zvUu1lXE32wmvyUOTyPxcgYyaXtKf3uXZTFv57ZdeNiv36eA1CPZ+96g49ce
         SrmA==
X-Forwarded-Encrypted: i=1; AJvYcCWxOJdMQJc2SEAycb6IE6xeM+EIpZxKFEIbrVCzmqls04Rvwn2lwhfkGHy7hp9ETdyPJFuM8euo8Ce1CDsP/08AYhTaySlhCA==
X-Gm-Message-State: AOJu0YyZ64Y/3DrU+tKzRmMFd1JGhVDrS+/vefozAJ4PfJ9Gv+7h8gBJ
	yB2EKg2Ix/e/txK7jo31g84RAWdbUIyHpPhrO5EucV8SSWziLikswkPqKF5+IQNqMwn/wt3QxSz
	iNnUiMxFRn3d5RQEeITgKfPC7yxw=
X-Google-Smtp-Source: AGHT+IGSQHt/2tK0iZI5vAD3vfe2hzBW25voA5HAWCa5f2Gvd2zcJJ0FNmsRkR1DGpgP2T3jsjGeOlqYW45SOJTprY0=
X-Received: by 2002:a17:907:d506:b0:a72:7a71:7f4f with SMTP id
 a640c23a62f3a-a727fb4082dmr230132066b.7.1719404340670; Wed, 26 Jun 2024
 05:19:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240625085548.033507125@linuxfoundation.org>
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 26 Jun 2024 05:18:38 -0700
Message-ID: <CAOMdWSKFTJa-Q=OMV_50uPrJdgQHCdYfR7uT27_9=dP3B3YzFg@mail.gmail.com>
Subject: Re: [PATCH 6.9 000/250] 6.9.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.9.7 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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
