Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CB386AE3
	for <patches@lists.linux.dev>; Fri, 24 May 2024 14:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716561289; cv=none; b=dV1bhUCVANDaxYIGC07lJntb86+wAmvdpqzeSCR+CsLGJoGFnNaCrRSAG9aTZu0fZW5+8yCC0XxpcEcmRbzpgwC/z1rnbTSiAY0k3KOTwv2UBJr4f4xBauTyHAU+FT1qdV1trHVZwgVcu7NlWbEufC8Ytn0CRAm1FiRXGyqzjf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716561289; c=relaxed/simple;
	bh=1DD7UAPSGWhJO5GHaawnU+uPBfjRKH6R2/isM2cFwEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j29JvMcdDWPyrHzJyHfjyTJCn7Z1ZS/x1cnE2+MOUNPFDuhRal/CALhPwTjKOvKaexFnwtRV8SGm6efOXwLQStHfktn2UlFVIRUKb77rWWkK0oPK1ngi2rwjA00hMzIJB9q7ZUf3BE/k2NpDqAkD/dahkSkdgh4/1O5JGswdJYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCoguanN; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCoguanN"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7e1b8718926so51111539f.2
        for <patches@lists.linux.dev>; Fri, 24 May 2024 07:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1716561286; x=1717166086; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RoFzHlSPjkXYNbJlOVt2ll4nOjdL2XVhikUa/6nwY0w=;
        b=VCoguanN/+pXRjzb7IZpiWIlnEHq/t3sIC7TtFD/p+XCQ09Gy6A4DgScsRBtyVCL2A
         TlhlkEKg8MGbsyGZOAOni+Hdik0/9sMseVj1AOQsVNV7UGTiQQ06eANHY+7ZNc2sw7Kk
         imqSNHCW3vAv5eZzZipSF1eWBr/rMWotwlrr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716561286; x=1717166086;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RoFzHlSPjkXYNbJlOVt2ll4nOjdL2XVhikUa/6nwY0w=;
        b=CB+b47cJvGoGRR8Eyrgwa64mcRD2ur9wwXOcuuZ+bECRPnQ9R5wLIirCIl5QHjR6uU
         5mi0dTkbgzZb23Mj0TJXGcTA3kr0gU/L1hAKi0vt+BJZRBxntw3i0zcLnNffakZhWEev
         ezekZXakrD6HZ45VPrbu8rbAYFMowgz4MnJ6KdYXH+WDOWI5n68kOEXDjUc5IO0CBB8B
         eOdoCPYlx+NH+a/CdAaXIO6ZEaNJIVZb32+f2w76SJWzj4jISWKFl6dl98wX2Ppls4QA
         oeVMlFMKZoKozSpDJAAvBTXSvyBeFaqjJ6uOaFMiJf/Pp0Wl11JCqrEsPvgoqk9NuG0V
         jo8w==
X-Gm-Message-State: AOJu0YxCpmogHZd4RR9wdjPZ41TOgwDPNScgA5jLhFXNFERBDvZB7OFy
	AuQZkqprQlZ1Przyhv/FTV2oKv0O6Sn9rtRKuuG0MvuAZi0VcpYWNtTS6xXagoQ=
X-Google-Smtp-Source: AGHT+IG5MmuONIihQqWnSSKPSxcNAZPcu8epoB+/zUWt7iZIYjsQWJWxkDtGuMf3gKxoQr+OuWUlKA==
X-Received: by 2002:a6b:7d43:0:b0:7de:e04b:42c3 with SMTP id ca18e2360f4ac-7e8c1adcaa7mr293181739f.0.1716561286570;
        Fri, 24 May 2024 07:34:46 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e9042dec6fsm38761639f.18.2024.05.24.07.34.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 07:34:46 -0700 (PDT)
Message-ID: <fb55ae97-9770-40c3-84d4-3b714702612f@linuxfoundation.org>
Date: Fri, 24 May 2024 08:34:45 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 00/23] 6.8.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240523130329.745905823@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 07:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.11 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
>

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
