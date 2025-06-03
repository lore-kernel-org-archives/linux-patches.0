Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911A21B0F0A
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 17:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748970613; cv=none; b=XXZBo2NYKgaql57wyqR3sJ4NzDsHBIzsv9pYvSLQeBvv8Fmjpd7gAKMbhCarAUEFQUn98r9vX25sJca6seaLmI61E/Ee/ksC4VAhcQsyZUIoNssO6knmkCeKi9k7BWcL3mpvkAGZa4R4SaTaAdeoiV7hJAahI8U3eoY8oRAb5Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748970613; c=relaxed/simple;
	bh=hOOfI2Dug98p149l++sUktgtwoAOQeQAHNLd9hV4PXQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y1KbuwVI5XlByVM3LSvSM12rNuFLxVy7qiCaTfFOioMWDHFCBZem4BmKFLFd4ivoWD1dq6JZZujyWRhTF4CQ/Q/+c86hwmo9vhehSstF3VWZ5qIDNeZqK/JAvLgQMeSh3VKGxVmijskCmRFmhmVKeZi+GQhJVyTbaiSqRXdzKjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CIcndFqW; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CIcndFqW"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-86d013c5e79so369942839f.0
        for <patches@lists.linux.dev>; Tue, 03 Jun 2025 10:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1748970610; x=1749575410; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A+PTJ84mgFgcvQUel6fKqwS+aPNdc2Y0X4akYmU/33Y=;
        b=CIcndFqW7bEkuiNhq7olnJcoew9rF5gsP5DN/O81aO9FmOPzqzaq5CgCq7+EvYXXQH
         198wj2dR8uLxrnmHeFJXlv3HGHd6nIoNrdHdeYH1XwCm7zPOh/3FJGzLAdo5JZU9iUln
         Jhvc0COKAaVGiVOAIqYtfpRYFGf4baQrugl6A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748970610; x=1749575410;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A+PTJ84mgFgcvQUel6fKqwS+aPNdc2Y0X4akYmU/33Y=;
        b=in7ySR5I87sN3gNoTrbzoo6FUrQzo71m+q05NqMNxSLXUwPnS/X3eDe7KbQj55+UH/
         UEN2lA/8N2XyVUs6Af6XkRO1zw7kle6p8R5KoV7Qa2UjQHt2LVpeGdt/SofJUy5vxJJO
         ygO39889qWwEZAXFi40deawgtZw2oZ5XvoFrRbmsyEuGQEFAM/A5j3HLwgs168tIeEJY
         oDXjjUdMtGUqVB30gC7fyfGOsXU7ipBvETTOp826hSMPzWfh/AEpyI5EvshRQb37M/bZ
         tJjRDOwazoXeooicbU/QVfpjE2wXb9RC2jQaxTyJ/zCS0jSKdXTz7t/Urokoju1Q+oJF
         Vusw==
X-Gm-Message-State: AOJu0YzGipC0hJM5EA9XOwhLNKbwIbYjyiqmdbDZYdmmMSXsznKc1Ir5
	4+PwhYP5nuCTqOWEuxyiFYPLp+emluRD1vW7qALg2cUXbtncUw3Sw9Rhrrp8PG1o+ic=
X-Gm-Gg: ASbGncumWR+Aif1ecU6QVNmCqwXfSBoLfLshSn2eJuBkc7EjXi6qyDmw2qEMp8dVW4s
	fMB3874jAJRb79psHfqVqz7D+PM1tjEQAuFT76GqQEdNZnLRNhfZKEzjmq8gOewhP2WcZlxh568
	B+hP2zE9f/xVftP1/GrQoVodyI4rNEsrcfQPYSUlaTIM/v+9g1+jvJa2p0VqGk4/FAEFqYePIne
	tkeVjcQ3lrdx1F9pJHOPmGAGcwJBiRlEpZn0Tu2xs/mxSyGJOiA/6SvTTWB6ne8flCiGRZb5uUe
	XnNF4uSU2EKQTxKVyiAi5jZuhphlv0YAhhLfqjnADPE+pBdR9JyCLCgMnsNNfG5ca7NUZ8/4
X-Google-Smtp-Source: AGHT+IG2BbeVXOuf9sjTCAwtxddMMI9tpH0ti7rh05AzQMoKV5AwNcYiGuPTbl2svFjfDk98wBdrpQ==
X-Received: by 2002:a05:6e02:258e:b0:3dc:8b68:8b10 with SMTP id e9e14a558f8ab-3dd9c9887aamr196505085ab.2.1748970610548;
        Tue, 03 Jun 2025 10:10:10 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7f22536sm2407800173.134.2025.06.03.10.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 10:10:10 -0700 (PDT)
Message-ID: <a6b019ed-a143-43b9-9ca4-7cda56f35568@linuxfoundation.org>
Date: Tue, 3 Jun 2025 11:10:08 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 00/49] 6.15.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/25 07:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
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
