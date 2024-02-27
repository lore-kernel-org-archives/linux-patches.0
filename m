Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93CD51004
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 19:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061241; cv=none; b=Uh3qLCP8YlrlKuMDsiLr1X8OPBFdMJPo2ySILt3eW2G1PDe0KaPh1ZsLsi+6WVXCgaDl5OiVrTCbtNXObrH77mOn4yPsWHN19sIOtYICkKatA4yg0A8CSh7xdZV11h/oMoR4/wt1r4jI9UZxHMckSqlsWXlq6Dq2AC0vIK+GBNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061241; c=relaxed/simple;
	bh=7QK+qRGhKALwTIL1s8MwpXOMEdAMUmkicv3LmVkCxfA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h1tSyGrriu6pYHD+NxbRK4SyAZmzLpAoY+bqoSxXwy8I/MxxbauU9qCYMvrx6PgWMUnMsCxxZ/mFnP3lE9x+Uy2JZzTr0EdeB3ZUef2V7Mk1DaBX3xLhlakiYCL/yh1pEMveZn+UCcSi0hilhZjk2UGYp6gXMtpdsePk9beYaOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dePtgCxi; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dePtgCxi"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-21eea6aab5eso3250182fac.0
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 11:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709061239; x=1709666039; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5jkcY+3vqHfqa2M3gpdilByY3cOfOEet9u7bgowP6xs=;
        b=dePtgCxi4a530lKR9e7SQhZed1NR4W3md0Mg/4NeoIYRsQvsw+ZQhkPMgRMiQKd/Bp
         aaHMjdBiI1dVgAlSS4spHbdQOF5T2XJ7eicMybsOGj5uG+rXtJ9KDOLc/6CASnn3FP/q
         5SRtXc5erFdyRVhL66xzLiWB9+dqN+N4pQx8p15vzX/h4ney//9Xzk4Sgfju110Bt9YO
         Sj69UpBSJWf+R++RLy/xscroZveXiNfjlTqB6hMeezDlVaNkHRaxqkoInCbpxMp8cnNb
         xTDc/ModR2l+4DdWj9dCacp8+GQhNUX6YWp4cy6LNNlz/+3KKeSM4qqWKPw+zNKbiESt
         IlAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709061239; x=1709666039;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5jkcY+3vqHfqa2M3gpdilByY3cOfOEet9u7bgowP6xs=;
        b=mR1rBBk63ZBmKaLz5dhTak00u0AaE3u1IEwDS84uId/sSPAEZKLorB6MT2dqcuiFv4
         EY2ByYovwC+DfUB9nL/3AYgmGgWwo8Rf+bXE7uC5nJ+oZhze/cgeuI4xN2TvLCDARR99
         5X1B2gIx53fSWmxQCatnLAiHqxTdO4KdIec/DyUpvW+tRAPCDtUv/vtWJzY4TqGW03mi
         RPkSo1+ULIQmvHXThDSzM0Dt9/O3kIfhKjjk74Z4w79VG17Kk+9NEaalzA8Jw9xLQ+LM
         4F8diSAOY8hmJ/urmz9BngFp7wfjhhruTvcpxT4mCdfubsYs3LbQBAlBz+jJ1fSqYNzU
         x+SA==
X-Gm-Message-State: AOJu0YzYC1wD4YRh0ao5TEdduXniA/9bE1SQvHLDeHVSU6eKDIBQYa8S
	wYiuE2NdyxsxCJCAZCyYivWkp5j4fEMoF7vvCXYvqxbIHNdUvOnP
X-Google-Smtp-Source: AGHT+IHOKJCEZ46w94XMxDehR4BP6w61b1FZhIF6WatH1NeU8F8IaplbBjBnSt6osYY4USyHbckfzA==
X-Received: by 2002:a05:6870:2248:b0:21e:bc5a:963a with SMTP id j8-20020a056870224800b0021ebc5a963amr13926749oaf.34.1709061238624;
        Tue, 27 Feb 2024 11:13:58 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g26-20020a05620a219a00b00785d893a692sm3851374qka.27.2024.02.27.11.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 11:13:57 -0800 (PST)
Message-ID: <896ede4b-8dbf-45b6-b5d8-7be364feec51@gmail.com>
Date: Tue, 27 Feb 2024 11:13:53 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/245] 5.15.150-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240227131615.098467438@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/24 05:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.150 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.150-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

