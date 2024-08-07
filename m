Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA84D12C53B
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 21:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723066488; cv=none; b=j6uPOzb/YeRV3sv9/5+oncDsjIuVKKwOfp3J9dGRNS4mVft4Wx43spIbqmXaCIwVJNZAHyQG6rtvYYo7O0nPMtoG4Ix5nxIDYDlmSBs/Qq3vPQIXhrG+FVxn4u6DPBH77Uuc4C06m4dMJj8Yrn1UB9yp9NcgdVGREjMj/3P2+cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723066488; c=relaxed/simple;
	bh=L5D6Da8d8PDLUP/fPT/55SXNoHUlfgsys/gI4OIfhvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YgmsUU8cj2TH9CLk8/5MYZr5PnMlMy1avkDGBFejkDqPrvQ2A4F+zK6sS2nCQGS09VR6gBVKrt2wwwQxVkhVeEB7tHKEAUKgiHyi+2n+CXnd2S+JMAHU+S6F9uJRZUKev8/6w39o6hL23l5LRtkDV9NWqmxr4x3Jn1PTulzQ3Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLIbayrr; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLIbayrr"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-39b3c36d429so203925ab.1
        for <patches@lists.linux.dev>; Wed, 07 Aug 2024 14:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1723066486; x=1723671286; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JzleT9HD4xqdpPEYR+tWtbUQCAn3f2oq3BskLFI5XiQ=;
        b=YLIbayrr6j1Otmf5LKLwYb1f00tmxy5+NEj2TKrvxYmVeJ3v4930NQRE7JcCY3HEkc
         lLS0naXzeAveoShjviJrW1DVqbKmL1sy4c2lBq1xSBVuD87fwie00ZpPehdP56jS/COy
         +/r5/admKq/2Z8AqBkyCFrTOYPkTvrOq8Gnck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723066486; x=1723671286;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JzleT9HD4xqdpPEYR+tWtbUQCAn3f2oq3BskLFI5XiQ=;
        b=WFANJWxDNLGQCylAVvZTwCEvl2nM8ujW/43e1zkar0mOYaMTmQ6NfhUomE1HcaTsGb
         zZTXCK5EY042HGMfVYypqcpJ4vI+nBvkWon0FQizvXvVKBJo9XnOndD6gyoQr5XpFJGR
         vV4qHfHbI7kXPtFm4hVbPThWPezKOSaCl6rUkoid2YQ0MnfBJhc6hHSRxbr/i+qfype+
         SEAmEsjOrfp9OBKk3JhQGYothUuzGgU/9NV7GmKeTaTh9wOFL9Nq+IzpiQfm9bRuyq47
         85J85p/iVznLUA+YjzjlCPFnNfkLzSFKspGk8aZmz1TXro8ghmjOjYAb5oUnBGz3nvdz
         qz/A==
X-Gm-Message-State: AOJu0Yz6dJOak0Mq+g4HIN9rDUSeLe7EcRZ9X3XSHBmBgFZa7Fvbpds4
	VwA5kKXN/iGJBt1XPyZFtBa5JMiysZb0Xsq+UuQEYU2nX0VhJVZga30Dqd9PIMI=
X-Google-Smtp-Source: AGHT+IE/iAvs+xq+B9OSJ95PcWTsUGdNYYT6r7pEyPXJdr9sdk19BaDRTg4HhsAlyDZFSlhat9MsbQ==
X-Received: by 2002:a05:6e02:16cc:b0:39a:f2f4:7ead with SMTP id e9e14a558f8ab-39b1fb5770bmr135522395ab.1.1723066485702;
        Wed, 07 Aug 2024 14:34:45 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39b20ab4f73sm48137485ab.39.2024.08.07.14.34.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Aug 2024 14:34:45 -0700 (PDT)
Message-ID: <77c85a59-c9bd-4a04-a325-e205aa2e1df3@linuxfoundation.org>
Date: Wed, 7 Aug 2024 15:34:44 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/123] 6.10.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/24 08:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.4 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Aug 2024 14:59:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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

