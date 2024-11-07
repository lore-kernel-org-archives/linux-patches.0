Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0C2CA6F
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 03:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730948463; cv=none; b=D/NnHtte0Sl/wampYYwpBq+0SF2xGtUpw634GJcMM+dKoXGSsQINBqJkuG3ot/QodMqX1NS+w+c8mtBVcaCp/t9sdVjfTSMj8Z9bZdCRJkYohcswbUdsaP0Vq7GnmO3gylRpyTWRbW64Ria/Cdyb/OPM54V1uyF+jQLgy6j/kb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730948463; c=relaxed/simple;
	bh=jrp1FFd7zEuBg2O8pmsB8OufTaS/VFGCioZTR7Xt2nc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GaCYQHINeEY2KjHo8Jg1HjtnWkb4/jtErQFXxA5go3DasC0WB4Gx91PJGKFShXkfIMRgCubKbR63HiFOC4F01nwlGjbmSJxMWVoCUGUhvpl75CZ+y/pG0gogArQ4qjHx/ks2FbP2gvxLi1tXUuxUxKlu0WjVNScZf5ue13ydP6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPUBZ2yB; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPUBZ2yB"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-83aba237c03so20804439f.3
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 19:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1730948461; x=1731553261; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QO4VEl/tyS3zWW+lWJR3IT8/UZMsZLq/FqWmN9Me+q8=;
        b=YPUBZ2yBCQEmjQpMah/RFuDARfzlHed+hAkYL+/SRRcid7fZMh1sFCBgB0vXwX942B
         A9DmQ9caPr1uWyPheE7LNUdJkx6g7l6xvGkoW3CKxSEp2ldbCOq9K8V3qnLQfZsuIy7D
         L45SJIpmC1EetwpZ8NLa1b0cDtmFiJl0erNjs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730948461; x=1731553261;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QO4VEl/tyS3zWW+lWJR3IT8/UZMsZLq/FqWmN9Me+q8=;
        b=m6zp02UZAkJX+PjwjV1IbGebNdPzNfBViVa+VLgIIKFageeIByUNj87fnBueMO+//c
         4TZitcTbZWVmz3yzwb30Nfn6GO/9bcmS5tnSBiKKOLiNRodwb8HAOnxz6Elj+4WcZRcO
         LC0amJv+ep1uM0LtMop7M3OGMj35HiUPNS1z5aBopjtl1g4yzPMJ2G+r564D1+mvWKz0
         F7vJk9d16yX6WEHO5tZgIuSgc5EVgG80fRxxd1+6SWVMMJa7d+hx2CIgpjMT/GsRI4PT
         3Mee38FRn8JzJfvsIcNlAm3psN5DHuWJlNelzJet0Q+JA2h1iNeEnzMWkNp9H62wnRr/
         28LQ==
X-Gm-Message-State: AOJu0YwM4IynHEHIHGaiRW6GvHWOW8GIcSMF8BEduDXM/KfPtLw6zKWB
	TTE4TyT2M+YdGbngjFn0Xbs/CeTXIPYw3ll+FgM0fYndK371tK09P8ytv9DhYqQ=
X-Google-Smtp-Source: AGHT+IG/K/QSHcRVbeZN/O44C4X4DS5NZPSupMVXJsF++kREMfSO45/VPQbs0eqsj+3v7cJlt9IpbQ==
X-Received: by 2002:a05:6602:1403:b0:83a:b364:ff10 with SMTP id ca18e2360f4ac-83df58b64b8mr90628339f.9.1730948461219;
        Wed, 06 Nov 2024 19:01:01 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83df5039a01sm11191539f.14.2024.11.06.19.00.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 19:01:00 -0800 (PST)
Message-ID: <545d7c6e-2a79-4cfd-a0fd-696a26fb23c1@linuxfoundation.org>
Date: Wed, 6 Nov 2024 20:00:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 000/350] 4.19.323-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/24 04:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.323 release.
> There are 350 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.323-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
