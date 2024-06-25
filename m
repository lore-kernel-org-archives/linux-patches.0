Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847FF3B7A8
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 21:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719350946; cv=none; b=asY/RcpmVLEZe89HkSj8Wsz4n9ENifsj45JIQqXWrDga0QIGBz8WsiiLHCiJrVm+b+/LYwVn4BY79Ot1N0jynBUvC24cztcuHcuzL66sHpKFiwuakGn15nuvcYQD6BpewbVEqpZNOrRDMNqFJ6XKSeJSIO+jOz9vF8e1/J/4ZeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719350946; c=relaxed/simple;
	bh=jo7jJ49egeKEwb3oq8bBy+Z+1fNQqN/U1oIXzUm5r1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L/TQVvVsohfPKxzqFpA7Sbm7zAR0Vf2jDoCx9nraeyVbJqUpKfe0MbSK8Ne8Ne2Hm1Hnw1sPTZUds9vRtjXdi+yJeKxcTMmmeMwNGaJBt/f7Zufk9F5vrf7yk1rN4gxlVbNi5knVUQEwYCrmfJcx4DQtxFsyMG/ycaCuzDqix9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ig3JVb6k; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ig3JVb6k"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-375dea76edaso2575345ab.2
        for <patches@lists.linux.dev>; Tue, 25 Jun 2024 14:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1719350945; x=1719955745; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7fjB6d8DPFz3YLiI7wqupsxFA7umSyU9rD25cxR0gLg=;
        b=ig3JVb6k2fEO8yMdoQ+aNqhP39jhbARMISg55+oZvbiR+nzTa7wSfS9CIF91z28mWj
         4Q17ej9In1k+7rQokDpqLmsb1FgLkaUOlnAAke5iLoXC+x1+5HhM+hGR7YG2Ug8AIx21
         05DZ757S6FNOH5DRsRot2uXTSxoyrXKZ+f6s4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719350945; x=1719955745;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7fjB6d8DPFz3YLiI7wqupsxFA7umSyU9rD25cxR0gLg=;
        b=TA0NmKqKb5kWjESerjcBmyWAZq0OW/U5bs8JVJ8+vs4v6+8fH4r20JzsN+TSRITtxh
         2n16qoi8KLu4EH7GAxcuc7fq2DfXc/lR6CpTiUC1LSzcqOj5Lg3eNtz/USZ6BvSlODGG
         8oCHEqp7tvDpmEGkii/wU+mLur6RqaJerBrgEyZcEuFySuqmPD7nlZmK3WzedeulPFqZ
         gn90EbXRUKSv9Tpze5xeY4pwz5MOnARYfBziQ7GV/UCZy9SIcwg6nqBVToa7bCROKsF0
         78mhNExKFFF2HurXfBkIrSF+YVd0rHYORjc3rghTxdCO4INd/hzjhx+XoWuhv3CfYc0o
         p+5A==
X-Gm-Message-State: AOJu0YwMYnSdmrOsvx7RO2KM9djcJhSI4xOE5IqGKtoB9SqQJSLpl7HH
	cigKuzqyEs4TMUmuIzqZN3Hmxb4CXNXvx/vfNSfMnFRAWL8Pj5MgPbWVf/y+ogM=
X-Google-Smtp-Source: AGHT+IFw8YkcVlThTre7WcW0vXEnonmEPs5gY74qQV7xHiIQ1kebkjQ2oXVGTmaIg5oejXENkkQYtg==
X-Received: by 2002:a05:6602:2d88:b0:7f3:9cda:fe62 with SMTP id ca18e2360f4ac-7f39cdb0084mr1219830039f.1.1719350944712;
        Tue, 25 Jun 2024 14:29:04 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b9d2125a07sm2783018173.146.2024.06.25.14.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jun 2024 14:29:04 -0700 (PDT)
Message-ID: <839bc86e-d4a7-4022-8a2d-d9b4f91bc040@linuxfoundation.org>
Date: Tue, 25 Jun 2024 15:29:03 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/131] 6.1.96-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/24 03:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.96 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.96-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

