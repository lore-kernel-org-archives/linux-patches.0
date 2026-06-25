Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000BD3446A3
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 13:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782395068; cv=none; b=j6KPLCbFMAED6bOOzs7QaJW192mUOyD7w5rUUT1m+r4KyfxtWuJ3h5Yv1muJo31ssmxS1qGrmiHXl2IfPEMM3kEvXFy5Uw1kgUOWPrclBkUiEGVsUVMea5ji8dFPMruj9Prc6otFnxx5fVXkyRbsMQQAkVS9XRcRLR5GvWtRYqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782395068; c=relaxed/simple;
	bh=O7q8146JQm/YlUoowWVTcwGJhw9So7vgvY8LErSP3pY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FKvhy5zDcc+hmWkx38HmqLDUHYP82ObyWhL/Wh5tsCijnju4pWXDZpw1Qrq86qkgwQ4lYmvPk4AaAaVK3FK4B4asGs0zs+MJFVaGbk3Vb+cH8x7KT6RtUYNzHMRlzJ+v6qQ+VUI6sM4CQ3UAqcEHs5EusRXjlFgCXGeyWq3Zq9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=csW43GRr; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="csW43GRr"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-48d6c621a67so1263979b6e.3
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 06:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782395066; x=1782999866; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BsZQ8NEzSIJcyszQacza8u1NaEbFRoBwhUpRkv25OjE=;
        b=csW43GRrSmb+8FJgtZHDd+N9TkqmLvU9XiGbJlQIrL3xSxCPA+3lN+jG6ei022fAEk
         B6vZLn1oKnYleiSFrtx2BvyXk/tumdCjaBXwDtoJwrgS00H7QnHNHYtPWO4BIj9efVG5
         szjMA05Yh5mHmzLMcHpvzntW728ek4/m5cdjFTZZC0VesYe5RzXEppbp4MsYoBbJUuPe
         /jepTi2TFREPnTcuk8Q2YGhHvtjRmOLJJOnO/v2xoRLntlRE1JJ3M43EPbLg8obRqzJy
         F2TbNaWS+JPPCNGV3e9i0gbA3ck4ic9TRBPU/KIfbtEcDoULaMXEpmHivME2oSBjA46+
         hfJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782395066; x=1782999866;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BsZQ8NEzSIJcyszQacza8u1NaEbFRoBwhUpRkv25OjE=;
        b=Lx/RUm63A74EhY7D8P0pHTBxrPhfpGmc7rPyvs8QIKr/RrAxv5c/jsLnZ3YDBlDG/u
         TXDjbgKj13chf7lx9ydExsPH2DsTnq8/nFBQg8U67tOaccSa2jAZjWjXIFtpljMEI1Jt
         jWE8sMBBfsUvL3PlWCrxKkP/KHgNgECii++H77U+1fRppYmqPimjgLfdnuZYWrn00g+s
         Sjq2+mxvq+2Jh1XLDkFt8XhK86wQTWDOsdJ5knHi6NyLOOBmU5ZAQmHdl7HwGCss8PKE
         WeMjkl72yxT7XspZjUy7uwrcuk0iduYEuXXh6fgpDLi6p5YSzSiaCehtSueyEquZ5F35
         mdRg==
X-Gm-Message-State: AOJu0YwDzUlmEwsnI/CYflQ7fWm8dVGShihQPQ5IgKR708pDBsVepLcg
	niymf+etERYRNEnwKA+P9QygB/mK5CVhvvn+Um5bFbUM6iFhVhoCpkpu
X-Gm-Gg: AfdE7cm/WlPRmi9pzdlXWbRZWq7B4KRjdXpNTzKPR6Y32pfmaiJ4bO+0Asz3y738nMK
	9YUhsb0/SBykpDJ7emvc/WrJlZN5GEz/xY1+9bqn6EpYWyw62JctCR3FYugKc3WiixsyGT0Krz3
	/xuS28Kt6wCU+ZkkFWYEgoWxTNRgyGrjsuBeeSxIhmWdLAHnQVS5zou3gl10B0MQBIS8RKGJ+Pq
	b45d0nkwi//oa7Y4DUg66d4oRQtiLgN+HpjCRZM168yI4TSxOIMXWldVeP0uIRJgtgVP04ICtFz
	piBk0f0ui22Yx4kvuFchiIffgZN6KB4fDDA8acsU73crEKbwsmRSyn65bh7ifUkG6jeCDKW1mwv
	cC9h3qa7WND7sV9xGx9Agruxs5rzJch3xcOyvXDNTN6toUoTqGWjtSnvLAeTxaABo8jpO17M+fN
	shcTL1w/IyqPzwEDZlD5XnPeUNbSOCew==
X-Received: by 2002:a05:6808:4702:b0:491:efc4:1a33 with SMTP id 5614622812f47-49216e35940mr2607437b6e.3.1782395065712;
        Thu, 25 Jun 2026 06:44:25 -0700 (PDT)
Received: from [10.178.4.71] ([192.19.176.219])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e944069d22sm13834919a34.10.2026.06.25.06.44.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 06:44:24 -0700 (PDT)
Message-ID: <11f22aa9-b353-419f-94f5-2a7bd70bb737@gmail.com>
Date: Thu, 25 Jun 2026 14:44:17 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 00/49] 7.0.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260625125637.527552689@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/25/2026 2:03 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.14 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
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

