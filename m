Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5239D42049
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 20:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768595634; cv=none; b=f2szkt6QLgq2g7r8klW2GN5c/vF7h2Hv5adYxSt+mL+cVCt2NM29X9MeuJVjK+UWod8Ok2/QHWMwemmpwrRoSRdmexQFt4qur6R+aPexQtGDGmS/mWQKeG5qgKTzgslEgUWnlZ5X2SDcVwPodrALx7ijj366MnBC2TjMyTTossA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768595634; c=relaxed/simple;
	bh=u4fF39S7Us2Q3vQJAPNsEZLLzA9mGZ7GyE76NaJoRHI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HBQt3VXsxBjO1w2YTHEglCRYFjNyVGc+ie7yKHhUqtG+ITl9WYvYmhINh9MAHpi1qH5AjLFd3fHCWoJHFLNBcRFCI4yLkcx/Jbszucn6DpVKSymFC9EWvqp2DUJ7NPZ7gYK+du4VQjwEaEpEOm4nj4eRxLWTRvDatDxWAjLBhmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWRqEN1l; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWRqEN1l"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7cfdd3146deso787281a34.2
        for <patches@lists.linux.dev>; Fri, 16 Jan 2026 12:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1768595632; x=1769200432; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CbhrvKb7Fr8u7hAx3MxjikhAp17dM7W/k6oJclqAYJw=;
        b=XWRqEN1lfe4QpMByOPYiAxHimJ3qyqxeA/Ej1PpSl2SzXz+GE84hLwznAcb/yN7HR/
         YARtpX4igVW0ykyWsUxjv7UHHqsO+Z3+3JJvomIUHgsusmv22iwblNvLSXb2QGeLQEmq
         ALuLd+OSikeF7fg8o8VZOaVMfd2BGPpzQtuA8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768595632; x=1769200432;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CbhrvKb7Fr8u7hAx3MxjikhAp17dM7W/k6oJclqAYJw=;
        b=K95QIww0ke676BVK6wlMsUyd/VbBcV2TyXRSXeeRXco/8Pju2cR4yvwbIwJ2Zl/5Y2
         5JY9RedVIxmWFKjYaoA4Luxz1a5/wJuCUeXlYyUQneWNCIsHQRlrNZ3pLYRsG2ZyzVhM
         2p2bqpN7LE7YOXPc8EZtuO7L2ezvULEy/ShSTebgOJSX7RYWGq/BaGN/G5YgZssQZbhi
         a27DxypLonsq0pPtnq6xRPfGWfEFXl14BGGVfJUPB8+nKM8lVE9GHZ1800BvzINaEf0y
         kkS6fk2fTe/f1ngGkvfu53PIU3EeQZi/xNKqZzshDd49RlEy8+IRkFU2xZuNMPXvqGpw
         g55Q==
X-Gm-Message-State: AOJu0YxCmNjlsKzTcaKy1L9ORZWyTMLluuX2Hfucg7vEBAaBJqmcNiFU
	IORROmtidkh/5SkH2SG2hWuW19kvVP8eNgpNNFk10b8Sc9Qr9BvR7kXR1c41cDeXrTGFSxgVAhI
	8DPuA
X-Gm-Gg: AY/fxX4ipPkSCjOAXDKxrkaUV2zicTMdgCjXxSs0131cW2vCe6cfvlrYSvUNUAfUFg0
	H7M12c83neF7XT59OiQrCmXQv4vTD+Wz0v6Z6Va+9YhW/u/HVqqMaYsaw3sp0v9sW/ehrbA0z2Q
	sVCNT0dIUuHXXu8nNdk5iR6qvb9aNTKow+tqfe4gRWNyj26VJzKX2TChVla5JLHFvX3C+szucR6
	SzUMrRwLI/tDshPpMMC3ccOcRYHziXKq3rn6BGmAdOC64J+K7b5GQ2KMPgUae8ypnADS0+z/Pg5
	ncIlf4jk95AfxHjLjIIgkSIQS4c3Y2jmkcUYx/OxPT4SoUaDNpSEptnN8mAMWiZSTfz8l0ffWxX
	mZN2nYkSdT7q9ELwap4ZTXlRpyvY9K5MLXhF4lTtINelIkEN1ac5yDhHipFqwlTzuOilpzNIXP6
	qcKPO2nozi61WwfUmjCbIw1AM=
X-Received: by 2002:a05:6830:3bc3:b0:7c7:da3:ed22 with SMTP id 46e09a7af769-7cfdeeab584mr1781007a34.32.1768595632233;
        Fri, 16 Jan 2026 12:33:52 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2a5f02sm2255511a34.25.2026.01.16.12.33.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 12:33:51 -0800 (PST)
Message-ID: <f1ea1fea-a804-469b-b3b3-a25ca693eecc@linuxfoundation.org>
Date: Fri, 16 Jan 2026 13:33:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/554] 5.15.198-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 09:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.198 release.
> There are 554 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.198-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
