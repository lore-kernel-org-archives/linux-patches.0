Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D66D13BAF1
	for <patches@lists.linux.dev>; Wed, 20 Nov 2024 23:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732144790; cv=none; b=YVq4gtSd2ELtFFqXnCbbO38EPojYMdHjSeBjsbL02fCztikQrtAdEvxv5S6t5yhb4//seSOllFTIQLW7fDUwK22/pr4gsSZiIPl01Jn18rGXR7qH6oW9jouDU2AMUPwxc6Jeg4dGYsyqKJdHL9+BqSvjjBso+EgcB6UkGp6P2nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732144790; c=relaxed/simple;
	bh=L+1vPU8iD+DS0o0p4K0V83tfmB6n4Px8DPutjFQDicA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OpPYNCz3DX3cfRUpVavZ1RN5pf2+PEvN1TYq9Jx8xqV9u7ymSA2Th58+iXWlWyViUdSv0WX64QZ9PqVa398zlZB7oMyrQxvS23dldoGXlpKEKaRuTeKnekvTleiu2n7i08C9Rbzr8GBdpHkJ4UgpjM3GR9z3NqutfnvVavAPt74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fdx4ZOiw; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fdx4ZOiw"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3a752be9f4bso903175ab.2
        for <patches@lists.linux.dev>; Wed, 20 Nov 2024 15:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1732144787; x=1732749587; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+giK/ELPAcyHUjRKfZAXji3lVew14WmyxLefpLGtglI=;
        b=Fdx4ZOiwQ9UKVWlOvL4erIEzAtkDtSGxMRiXWuitFO+5FtPpVwT26FEnqf+G2fRdZV
         3IDtGgD1jCCyR28WtmpRa8ef7yTbQy4MQ7AXVCDSu2PfGQ7V1j4fPRSunyD2D32ZpkVa
         xKR9G/T8NXo3ZfmPbAxPsfwiloH5mZaJWjSu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732144787; x=1732749587;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+giK/ELPAcyHUjRKfZAXji3lVew14WmyxLefpLGtglI=;
        b=j4kcG4G4ZNv+Nt2jFq6mULcWUG7J4SHiP27tJkXjJblpYy0wPRoGsJdrfzNm0udYB+
         4IA3NcaUf1lvyc8LKDDLWQUth1ISgFqXUwuxwPb5UA5kBO9uQsCxuEZoaPC44MxGoR+G
         D06Apy8KAu69TfFUhUV0FRK4+LFoNcxAYKAgkGyETqnU7WaSTn+7iLnprxhdRg5G+jOB
         pVh6d/ZdnFmJmQz9hI4c8ZE1CLGeFTMULFra6NzFzq1xCd/ISmiK8I2jDVYyxq2EbXgE
         S8cHdpuiy5fYaza8FlmYIUHgcCwjszqGttypu2321+RZujJnZZ8dohJcNIcLueoE8SMk
         qB9g==
X-Gm-Message-State: AOJu0YwgohtF0eWVtHzawYVFyKlKzy+/umnqhc4g2bBfdDy9t3jk6twg
	C5HEIUoLrX5n8+C0ba1SeUqMvlDp31A7YiXyNuqL1CtohVBdHH744t81OUF3fqY=
X-Google-Smtp-Source: AGHT+IGtmIuZiiAkhRZ1DYVcTmSOeSFCial+bj0SazLudqMOLZCZt1tnwDQnoatujtj0YTJ4Q9UkRg==
X-Received: by 2002:a05:6e02:20c9:b0:3a7:8bb5:3fe1 with SMTP id e9e14a558f8ab-3a78bb54052mr29359015ab.12.1732144786685;
        Wed, 20 Nov 2024 15:19:46 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a748091bccsm33805385ab.46.2024.11.20.15.19.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 15:19:46 -0800 (PST)
Message-ID: <b1465833-d406-4011-a733-f86d4145e157@linuxfoundation.org>
Date: Wed, 20 Nov 2024 16:19:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0/3] 6.12.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241120124100.444648273@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241120124100.444648273@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 05:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.1 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:40:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.1-rc1.gz
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
