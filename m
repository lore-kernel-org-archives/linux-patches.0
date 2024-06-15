Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1883C6FD0
	for <patches@lists.linux.dev>; Sat, 15 Jun 2024 02:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718417401; cv=none; b=u3C59bk1Joy3EAAm+uWBzO5ysfm0EwGsT9TirE1aJ6dgT86WtRZb5X9DoXmjR4CB+mMde1rDP5cEaOurV9uf5kAn9hsRyciP07q0CMAMue3Xb3zS21PErVvA/3Os7CNRlly1nun848Q6SDXmXamvylixEgdwK8b2dn2540SMowg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718417401; c=relaxed/simple;
	bh=jR+r97LLsEqhIqDp9F3OWwf82Sf896rmRh1nFDKfm3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EddAQKFJKAPiVVuBalkBJ2dz2pt8TYKL23dc+22bQ9U0S9WSOPFKDavaSV8R/C3USCELnizXCSjzgIBy5ufDuNzUrzlUKKzybh9SIrIukMpfWRps87tkSPHjA5CXcLW2lnCevgXCTNpe4U5Ue6qHIUQTboeV5ELp+23P1WImbGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/9ZDBxO; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/9ZDBxO"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-375deacb3e1so766895ab.3
        for <patches@lists.linux.dev>; Fri, 14 Jun 2024 19:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1718417399; x=1719022199; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cQST+bZ6997ZNOp29xtPW0wBoVz2OQgKR9aErdb1d1Y=;
        b=C/9ZDBxOilCLQUt2vIql0FJnEfYVMQw6oa3BvoF8ImDb2WIGBX8NFr+h7x0hJcgXJL
         p3QiYVFyP/TWeTsK6TrWLGD3q4b6QYbYJrMv1KEm35qIQx0wVFPyuk39t1EqmmcdysZT
         YE5TCba5Ao6Qolb8LOKzHf6XMGLqClxLCjF+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718417399; x=1719022199;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cQST+bZ6997ZNOp29xtPW0wBoVz2OQgKR9aErdb1d1Y=;
        b=WpF6b3iFEq7b2Vy7x9AE6Hi4oIoWTtUcq/sfQiOVeRQeQwyPuq09+iV8zVeZaF9vmR
         96+xOyRq/OM7gUNUhgQLgpPf8tHTzAIq3TDr1FXLDGbcQb7wxgDFHUNvtxPf40hsmhv8
         30a+jv1NJxKWXO1eGCzsGNp6gSsGs47rG1chfxcvAo5E2zWi7EloTaTL/p2Yxct6Un4U
         qMaXckEN/Wy8ozyqolpCIjjFSr2KomgRKhpWxDt4KASa6R5c1s11oa2NjdVMeBsI+mu1
         T+vntW4MQwkMVemdzdDc1OCz4uUBjqD3jdJTKJYaI/bC5cAgTw3LSemIDkq/sYm4kNzo
         zxWA==
X-Gm-Message-State: AOJu0YwtProiNTjnYZVrHR9fyNucZtjIk0//z8YDlpWQbD8MWRlaTN1G
	51059mid4CZgkXAnPwG+GWUViUMGyqUKFZKJCufuGr8JfizA7XVjrav82jRqtSk=
X-Google-Smtp-Source: AGHT+IHYtGoZlwHhsJGiLGXfjFPL0W30A9job+FyKsORYagIgYgv9ouDDpE414yAA9UwHCTtvrucVA==
X-Received: by 2002:a92:280e:0:b0:375:e378:1008 with SMTP id e9e14a558f8ab-375e378111bmr35038535ab.1.1718417399105;
        Fri, 14 Jun 2024 19:09:59 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-375d866e324sm8883315ab.2.2024.06.14.19.09.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 19:09:58 -0700 (PDT)
Message-ID: <52466fbb-f0a8-4162-9e6a-d48dee94ccf2@linuxfoundation.org>
Date: Fri, 14 Jun 2024 20:09:57 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/85] 6.1.94-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/24 05:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.94 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.94-rc1.gz
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
