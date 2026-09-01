Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC323C5832
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 16:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281047; cv=none; b=LJRs1ys2zObykC8qkw9TcZOEAlKeeTQGftfae+NSP9BFToCyYckz3gXOH9EXWCY3wCOeGkaZ3H10X3JYKTuQzgqlz7UG/eYKV7srf13GpK7NYpA2aXvlEczEfY2YwpXNJpw4BI8sxfdayxhmq9FwXJFmDZy3k1GE30C7ul90B7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281047; c=relaxed/simple;
	bh=lBssdOL4h0dDqyFCQ04Yu5KOZOoreuzJ9iq3r1VKZ/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gkkg7pRINVyRXHU9TBudZbmVWpGSUwn9H4SQEerFDZX5pCDoFjuL3wIalr2OegCLIRVnr+XN/Yzl2UeQYgkgL9GzSth3+4x2Nqw007ZRIUN4y1xxhhZlULUi2I2crGn+6g4BcJgtdX19ZGEMGUqzKWE0dpLD9j5366TeW/VUuh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDx+VnAZ; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDx+VnAZ"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-4a4cb36ae00so63479b6e.0
        for <patches@lists.linux.dev>; Tue, 01 Sep 2026 09:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1788281044; x=1788885844; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OKR0Q5O9wNc6TWb0BqTKUYLMLU6iV3p1EeGlnxaUPrc=;
        b=ZDx+VnAZ7+suVaJsy7FNNXNOwN1xF/rn5CRG5DMjFYK40RBmp3Wq55PUZZdX1Pqzly
         XvxM+KGzfAIA45DQlOHgznrUzUqbRv1mgr07IN6TEZOXeLuMVsvV/FqBumIhLr1bYZfK
         pdPwy63vl4Zz7wlZ/HOso8qkwG4S0PULJ8kgo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281044; x=1788885844;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OKR0Q5O9wNc6TWb0BqTKUYLMLU6iV3p1EeGlnxaUPrc=;
        b=p6ExQVRj77ORpfYiSSuguTo5HXHCqdkc6qhUnwa9AEZkHpimflAAkcY4YOYrOt9AP7
         9Ufo4vqokfAqU0pc1hfDOk2UgnNPvg5q+76pIGN/u9YvZfuTJ7kZ5eBKucjKUoIBDdjT
         02/jOzc2Gxyo2f403rnfLwYGiiVmHZjlCbWVrx2qL8NqztW/AR0VeqUZ0jo/brNMkPmM
         zsijAdGhb8FJjPZk0TLAjYp9UrFYihDVRd3/hO+7HEhbVR8ktLeYgLnNVchF6el3FvCe
         Kfk8WQRlR/rp+1r0lXLP0En14uJoJmcpR59oUaAd5SvfQWFJ5t4f7yoDTjJ37rs6Vo+p
         PySw==
X-Gm-Message-State: AFuF++ly8czv9vuqAzE+8P2IhQ9BKf5cvWf6lBZpP/H2mrcYuXbHaa3u
	LUKRty/qe/bk6O74l+i/Xl9apuoWCBu1PxhgCWaGDPhsFcFAUyy+jOaLWoqoac7A6Xw=
X-Gm-Gg: AR+sD13/F02t046lP7Aj+uFyNPLUssRuUCKDSJ7K9gRFq2bUmK7XZguGQsrub+HhUZB
	gRhjtDDpwhey9rDi0xTsPDsVNuMnl8Y/kRPNo+w/uP4CwYxiGoebEu6YH+ZV63uqpA/KzCK6Dus
	DG66qpslvx+ofQm89RwX56Q4I7dGhcE6Hs7x1AymJX2rNw23v5zz6gbfLxcByJz5klhCfxCIe+1
	ZqtkwrODBDAKfPi1HIBwyS+QY8AsUI/BfDTu9WmiJ9VCk2OfLEShuOewYMTGYkeODHmJ4J4mKey
	kkuDmdXaEv6iVCpispn88VeCEirljO1D+jZ4wA09SxSb1nheZ5zM0pD5dZgb6R+C7ZiclxWeims
	UeXVFRXsK2rWdGw7cQdGY1pjeGkLcQQF3KN/qAiBE6JkfuP6naaTzgsgdYyLSRz2rk1FrJGk+JI
	OqSv0IWSjvdoCq4bIXWS1FejIP+ivZ/2jZ/bMZyxw7hvlmSDZPq7urUkEi9dHecbgVU1jrZg==
X-Received: by 2002:a05:6808:bc9:b0:4b3:7b31:8df7 with SMTP id 5614622812f47-4b39824817bmr35286429b6e.14.1788281044022;
        Tue, 01 Sep 2026 09:44:04 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b3a1995f2fsm11396298b6e.11.2026.09.01.09.43.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 09:44:03 -0700 (PDT)
Message-ID: <58e592ce-3354-4165-bf7e-93fee744339c@linuxfoundation.org>
Date: Tue, 1 Sep 2026 10:43:56 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 00/71] 7.2.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 07:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
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
