Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EEB5025A
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 18:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712858948; cv=none; b=ckkEi6RCt3uBssOm1bBgxzrJ57KHbjXfcOo0eeyvRdNGqFNfxGiMpn15ohI9Cfoz7jKo7HHAifBctOnRLSU9TB/m2w7LXxDxdQgm7f9EUp9e3CjYUY8qsuMPeldSwUvAyBnT0thK3nA5mkjoOPR0mFxXmiq6rdLeDSPh30l3yFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712858948; c=relaxed/simple;
	bh=ONRK5DPl6tc4wVC9RxuPEeSXQSFGntQviOc1GgrtZyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hC05nxp+orm6RKH+umyNeKk23tmiPbYZOlD5rOYmDMtzYVCXmZ7VIWJ69jzZYzNmlpc0u20Tr0k1DkMJkF2biexkR09+K6FVgl/tK3Vlz/DIsn4ZvRDwcKbZd1pAJ0ilIPecdTsRjKOyMR2dRqpfFRdYIcqWfvv6FMG9AX8KFMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RQJfh+io; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RQJfh+io"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e2c725e234so8777695ad.1
        for <patches@lists.linux.dev>; Thu, 11 Apr 2024 11:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712858946; x=1713463746; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aW1fSwpFf3nS8PmtpMueULfzNf99ExNq3LAfBfqw9a4=;
        b=RQJfh+iorYMV1bWEtb4Kzt2KPfTYBk3YsqRH/7nNuF7TWi0paBcV+PBVhqf+X6jl/n
         35uh0kAUc70CQMOBJUHE1OUalnv2vrRdD2VHy6dl+MnUx7FIOEP2bHaTbV49Kcn+Sm7X
         BNfN01EREWk04K3A+lot5fu3uUrqv1QORKjyzO4bZHOPrVkcAFa1goLnE/ca9ZNUKDYA
         mus/Imy9VhRshlGljqLK6h2Qg9+bU2rjB931s/stBNmH9FOCy1ljl3qJ8aYkvJHfBge7
         Z0Iw++AmXtlwhknwEP70YsGb/ayEQYKreqhLMCAG+1Sf8WhS1FemZaE4Dm+5bjGe0SQd
         1PtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712858946; x=1713463746;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aW1fSwpFf3nS8PmtpMueULfzNf99ExNq3LAfBfqw9a4=;
        b=kBGik9IAWHJLUGzd1WEKMzslxFPfewNj+QaWlOvL4j37oMGshrwWocO37LgaPyRsNz
         GAKjl9EXWX08IbDbW+4z0daNnSLiDJnY+1cLzcBL8lLJw4Zk3QHTwy24RIVlfPzHzO5v
         IcHHsFQR0HzGEGSwYCUzXyQwicOxJnaEf1/2qHGNIAUpTMJ4X1Vz0OVMhGgYCmvhlAcJ
         vXKCaCj6EbkyIqXNNeKpvmY+3mLCVHMjetmvFshFH0bOSwt6sMYSRIzATUPEuuEdKPa+
         9lLiS+jLSVZAg8GJA6XhD5Kx+TVMn6JUE+Dxg37DtVo2fVydUQW/EeTaz4Gj429ac02E
         EWlw==
X-Gm-Message-State: AOJu0YxSM6ts+h16LcmSieKYkVkJMIMPNHM6podCey3EbS/hjzdzOH6l
	Q7l/gr0suVRyF/OnSeL28zZgKSehV6rBhdwn66JLzP39PJ8Wncf2
X-Google-Smtp-Source: AGHT+IHVoasH+42WFyT1KotUPe1aBvKRDCaQsY6emb8nFvCsJqJnMKmtJEB0WBmRNP/p7KeZzK5nEg==
X-Received: by 2002:a17:902:f651:b0:1e2:a61e:47fa with SMTP id m17-20020a170902f65100b001e2a61e47famr738899plg.15.1712858946386;
        Thu, 11 Apr 2024 11:09:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k3-20020a170902c40300b001e0afbaf49asm1451945plk.278.2024.04.11.11.09.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 11:09:04 -0700 (PDT)
Message-ID: <2265b42a-d2f6-46a8-924d-262abb53e3f7@gmail.com>
Date: Thu, 11 Apr 2024 11:09:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/215] 5.4.274-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240411095424.875421572@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/24 02:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.274 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.274-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

