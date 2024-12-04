Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417FA1E519
	for <patches@lists.linux.dev>; Wed,  4 Dec 2024 16:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331192; cv=none; b=A3wzkEjfQpf/1FPoPK9XOheN6kb1GCq5ajhU+EbRrD3bWkyl8TanzD5QxMa+ivgNezqJ6VhBu50pmxrsFQSX7Axo39UxF2EzzU7jro7jMhDNCKipP/nUW/u6NzFqh581z8zV4UU83SS+tKQPWgpnrN/aTYBtqe+w4TNKD5GizBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331192; c=relaxed/simple;
	bh=Ps9s7adSYlhtclfFUDgzrRDE3aRhsegiFXOsPBfWzN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IfTEC0CLNwuQ2GrruOhu4sy+o+6yjXBLwNjQnQHY3gxxKh4owEaV9g6l0Kzvxtpgd/BthdAVsXwFz21MaGLwt1ZeoJVZid9axGjYoCLKneys9yrI9bBXfhouaYcvNwX4c24oa3e5KLnFk+3vqCQGvqIcuG7otecmT3AML0WuE2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqDPyUgz; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqDPyUgz"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-83eb38883b5so241809139f.1
        for <patches@lists.linux.dev>; Wed, 04 Dec 2024 08:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1733331190; x=1733935990; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tWcaZI3k3KA80/qPmq3Cb8KETFjDnLzZkyHlk3Sthqs=;
        b=DqDPyUgzF0EFkDEgwssnsx2eekqbydv5t7AwmO2zfUaYfcCM5Vn9InoSpGqnY9HkzU
         IMYiWe4G0jOIBowdkvmm4odzoXXInpHN6RvJXwPwMzMEhY6119tj2v+ifMFhCegEqrt+
         u0/olvgs1fNOg9LfC4/7lEITSx74KswtSqhjU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733331190; x=1733935990;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tWcaZI3k3KA80/qPmq3Cb8KETFjDnLzZkyHlk3Sthqs=;
        b=gGNKOHtfULUNDNF1w11B4myGxk/Ridkq04dAU3Z/TzOqA2BmZV2HUu+cXSsom0PHcZ
         /QmrJr1uaImrS6TLo3lwwbIFigfMX4xg/wdVIIEpgQl9uACAik54HCO/7c8GNe/JYSI9
         GQb6OgCfrgJHMR0CkAHB/jiY1fN7qLXgl3FIBtqQjfl4sqQ91bA5jqqD+PKo1zkRh5kk
         VNNfhYYJ5SJqXPj5RyMeavF/hHKJz6psqJeGTl9G7lQycMGNITWIwAS1k9StvTL8lfnT
         O3kl4rWuVCbNS3nR+CBzO5c8qiM4rziWlMnWhecyoE9nHMbhphyhX76uQXqfaNmSC/tG
         DgiA==
X-Gm-Message-State: AOJu0YyZvGzZQyWX3uxp2moWcG/usrv1XId//SH51EYvm/QDtkDpUu3J
	FFlYoZfbK/pK0pwxGePx6MTMO639kDZ3SsnL/LpoDqFNotCNA8eyVIQXCn4Rums=
X-Gm-Gg: ASbGncu2bWT5Shy+RaJ5lKxCdbsHsbr4rtmccT2UBcZxVu3ejveEf4bqLpL5mB+jv4g
	couNHVA8lXTzP68rJJQsHGI6fL3thD2cKCABJUVPB+yPgoWrudPgo5OgikshBjLj3ZluKn7zCKz
	e2yXdkVb1DRrxongdiRMf8p/deAPMroaRvGPPHmOY2n+Z8rWwa8j1GMKfbbmflpO3Kda0E/YTnr
	SpNHZycIPaD9b4afXknLDD1GdBGGKcbs8DOVZ168vJnQR7VAmnErXfPKszROg==
X-Google-Smtp-Source: AGHT+IEA87B1w0H/p+dtmlOvBnj9D7/7N3X7qqndW5CFH7T9gJxVsQjS87Kn1UsygAlxcq0il9aDEA==
X-Received: by 2002:a05:6602:1649:b0:83a:a305:d9ee with SMTP id ca18e2360f4ac-8445b5cb7cemr763081139f.12.1733331190410;
        Wed, 04 Dec 2024 08:53:10 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-84405d1128esm321665439f.0.2024.12.04.08.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 08:53:09 -0800 (PST)
Message-ID: <2ab51fd3-2fe3-47cc-b692-67f9dbe87513@linuxfoundation.org>
Date: Wed, 4 Dec 2024 09:53:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/826] 6.12.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/24 07:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.2 release.
> There are 826 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2024 14:45:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
