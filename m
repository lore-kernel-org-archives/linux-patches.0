Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775E014EC73
	for <patches@lists.linux.dev>; Wed, 24 Sep 2025 00:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758673798; cv=none; b=RCI3AufBuYl0JEimkZGs+FOULtG0szXus+hz3h7p/mrEs9Cr6RB4xQD+SwQuF9Rw/nQmo54wBEYzfVkLKj8/4pOCS2iLQniJFSjuSQ1suQDolWKAPM6pi1T8eMKc1BYN6Rmtzucgt1C+sswsFRZ6ZW3hV9Wk7Q/PYF6yNKX7TCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758673798; c=relaxed/simple;
	bh=naM04PjuUlO+xdnHVfVxnmrRbVNoRT3anIgfuBPTHfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ghyWLzT526gcyN9sPS2jH1wftbmehCUK7OQ6b6cV6cEqkYmFh+M6KtJPzIAT5rKcbgIsjxvXI/4gXqZ2yUdU74syL7FtMh24FcVdp73kLFJNWZcnegMd0bFzcy5lgxFYFmjm+l/jssfLXGU1g6IIyGIT5YdK8nn9ADExwEhwavo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaH65206; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaH65206"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-4257f2b59ffso2433435ab.1
        for <patches@lists.linux.dev>; Tue, 23 Sep 2025 17:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1758673795; x=1759278595; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WWZ9/JruCDlDknEZ2K8CsMBaKtIxwhOiVHBk73OP1Ik=;
        b=WaH65206vHxZBrcGLhhnTtjAjYClEH8esdVmOQOM7TgLHw1S53NJCDsDkzQC6+qU9N
         H5F6pVuaZ04Bj5jBFTUH1u7IcGQFwKmLda0eY8nJHfp2lQt/B20wxb65sdZyM2LVWdJ3
         jJeC1gGCbHrbd5xrOp5zCxAN8YERq7yKDFMTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758673795; x=1759278595;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WWZ9/JruCDlDknEZ2K8CsMBaKtIxwhOiVHBk73OP1Ik=;
        b=onRGrUepqmVYh7KidRi2uMQlKaoLsKI6sQQKHRt2ctDJkNxgW8GVGUXQXVZKJ/T66N
         /aRdzLXG3KCTfsIsKMJ5XmZKZ+IZXfQmDYoOepZs2yZA5bIsHFnonx11/Kkpx4aEZyyJ
         bAOG5j2PdTctdVacL0czM6AJDk2pXDu+vF7xHnnmu+gIgcwgrCeBhDUopvmcERfIWBFt
         68vNDbin2/kq7fat1t2PfvZv48RpJiz5zatDJysv3Blyy10tl+Xw7ziFJ3Ef+3gRV+RP
         AkyLdnOJtU5q9JRU7Bd6nMZlKlRT5SEbLYizOadpLPeaBIOuXGR9aS5RXUMEPwETx6wW
         8IJQ==
X-Gm-Message-State: AOJu0YwhSlfRaFhss/YOOsamMq/DlGvJyNewkn7jyvVk/7sIOQ3m0F6V
	roM/G+52Ud2mS1UGH+hVW0H6wUFbT99cfkKf5yqoPR70p+H/XhXUlbVghxkcbjsNckI=
X-Gm-Gg: ASbGncsQ8HZF85CudDUrWwa1VNMuXbGy1nljbJEUXW36iuYGZ8QG0OVS53WV8y1qObU
	u+yhWs4erakobHUMVJ586mhIYl5mXqZVdulaCVRhKWHkVg326bff46+nrV8vHS2qIiw+/dciD63
	IJiK3X/J0xDRbg7kMxBnOVub8PfwqvYQXFuO84PLLpA4Hd2JWLSn3rQ8NgkKapi61Q7dhtwY+Vl
	AhXDZMYLZrgHHpfn445AwlTO/kfq+Lnimy6kUCwNpTD1W9ZTUCBQzxtaWchdRCeZb6ohCLDAQJZ
	rXMQ5Hid6zCRGRjv1YeDno9On3Z+BepAPSLEm9KxIgrFu4df4p/t+uydWicwjQXy5QyzX1MTj7F
	TcpJbnC/UYCnR0ZL4KUmGzTKiQmh9aFfq64A=
X-Google-Smtp-Source: AGHT+IHhU+JZu2aqGQA0/LLnFJk70f/QV6Wcnf71guu/RWN01PgptATucxSvf33EjWlyaZRLKAvMrQ==
X-Received: by 2002:a05:6602:641a:b0:881:4b5e:fa9d with SMTP id ca18e2360f4ac-8f543776c01mr106084939f.0.1758673795487;
        Tue, 23 Sep 2025 17:29:55 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8ee5e2af876sm50376839f.23.2025.09.23.17.29.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 17:29:54 -0700 (PDT)
Message-ID: <9c0b57b1-e749-40bc-8c45-0658a8b5c960@linuxfoundation.org>
Date: Tue, 23 Sep 2025 18:29:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/70] 6.6.108-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/25 13:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.108 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
