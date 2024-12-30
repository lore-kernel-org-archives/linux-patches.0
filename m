Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5631A1ACED2
	for <patches@lists.linux.dev>; Mon, 30 Dec 2024 17:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735580377; cv=none; b=NpHQ/BqQ+jhsoQNS7zxhqB4rJA4uFOLWzvy638UygXSCdxoc14M3dkHK3T4e2jFUt/jipsvASKhABJ+s3h38qDjZ2vGKEWse1lEQFK53yAa7lhMieWL0nPknXuD+9fxYo+anTDzsNXFrYr38LJxQxHyvIopD5COWqoU/VD0+aEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735580377; c=relaxed/simple;
	bh=R/rFrw1P0qSXzaAQb8RgeobbyTyxW1rmHaNO4bwznVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nAiVyD1U9Waj4MI6z5U/pHocVDN4Kyfl54j4NJKMvMQBxR/ZtUWW8Pr2mBtymDztfWdvn3Y9AeCbRHJdTusQ6Kb/FPHt+YXovEiyMkN83vhCg1gcI8gvhGgFes/73z3iamGOd0WOoI87YyOBF5dSZTFFRNL9c2n2H8oTCC3r6LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yewr8htD; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yewr8htD"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2eed82ca5b4so12184445a91.2
        for <patches@lists.linux.dev>; Mon, 30 Dec 2024 09:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735580376; x=1736185176; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eRNjd4v4g2QfDp9LoTWxtu1DzM2fv4DeraAhhjIxMDk=;
        b=Yewr8htDpdds2h98yqLrVnMl7/+FZYiEsErptSrODff6YhPxfNvmgtevzmyprrCmqU
         MbknGT65hO0Yk5HqGnvTHAOVNWkjYxBOhiFGRcEj2KFHSSQUQagg2y8vTO7nhrp5OARj
         48q0iWYynGYmdxUqJpOn6GQkBTwNC93wsUpwZPEcLxIGpz8AssxulKwuw+PgKIqcuUkz
         1QdM0XWdteW0JFIWcae6TLHqVr4UwlJVvl0a6EuNgcO7oNGQDwrJoQi3zeKBodoJjWY6
         eW+Y914/2E+s/5KWNa5+Dn+eXate+W/eM/Um8k3QBuNRWyR074wV3nPfGCBpRX+MSjWB
         b9dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735580376; x=1736185176;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eRNjd4v4g2QfDp9LoTWxtu1DzM2fv4DeraAhhjIxMDk=;
        b=aMMJtkdQ27zLCCSz4vt0HxTDbu4hDJh6n5ZXtWK77omCQy7WdTNac+1269aTzUupBL
         xrFmzrtlAeBuR9TzEJIdMi7pTKSCx//EKQGJj5DzcEZv8HPhi0KTJ8AlKdJ6HXqatJfz
         SJ/xNUN1/J18ivPEsEohqrPQiun+rKY4ravmQAJ5z6CP8IJuksyRoPPIxwRUhFs9DD2B
         xDmvqX7THTAHotCowpXeda2CFYsXvfFR3EQaFiB6j2GmgiIj+dvRYAstn0RR4wKfqMDt
         8IxDbrOXkv4ZoELQMT3fE3wWuIFL964HPSdFGi65hNyImD7h6MOUgTwgluxLCbPgknO5
         pn8w==
X-Gm-Message-State: AOJu0YzSmqivgTvRFxWNKrzkqMN0cAajteJBs038LE1XjQv6+S8XpS0l
	C00qmsXGos72nj7aupF+/zu1GbnM/AL4ea40DooLcv4FoIcQWqsl
X-Gm-Gg: ASbGncvZgb+VHvGJylEmlgbNMIjByGGguoQNvqQ9SjZ6cIwPJ7+lJOFcuRihIZ5dr7k
	UVQjH0D51JkqGEpRnpBAH5bcmNi/8II0fvNtiz2CoBd0TX7U6wOMUN65gR9aqqvY0W2DDqVFwbm
	FXDkq+gM6Cg0f1mpX4+A7VPuTmJkLaESJxnga5A3YzTtB27rNPM1K0OVIYaCbIIZEhQAsYtgG70
	jzdrPGbvQYVuwRbO0O/8Yqo8INzXgFU/2evd0AQnoDztt/Sdt28BweeQ0c8SHcXvM6DRyMCj8m0
	FAK2nuGd
X-Google-Smtp-Source: AGHT+IFrQfxB3HdGql/7V8HgVRAMiQDLsclWx9AHt89IPyjBG+rNU5xZ/t5zKuT9t+HrCFiu6Ktq/A==
X-Received: by 2002:a17:90b:534f:b0:2ee:ab29:1482 with SMTP id 98e67ed59e1d1-2f452e2ecc8mr56340416a91.16.1735580375533;
        Mon, 30 Dec 2024 09:39:35 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f44779990csm21235982a91.6.2024.12.30.09.39.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2024 09:39:34 -0800 (PST)
Message-ID: <0081dbc7-b5cb-4345-9799-8c9ea63e3bb7@gmail.com>
Date: Mon, 30 Dec 2024 09:39:33 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/60] 6.1.123-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241230154207.276570972@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/30/24 07:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.123 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.123-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
