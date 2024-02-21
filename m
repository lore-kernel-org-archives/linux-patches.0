Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80DD12BE83
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 23:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559036; cv=none; b=f7scCygupKudfgoL+/7B8+06T477au6J9pYY0qhM6pBox5n2mhKhq9VQ06FaUKBsdYvb7Ug5ZYiB7yeOUbjA8iiQEYYkoPLeoX9F6vd+tw3T4TlStAw1634FwcXdNxmK1xNsicFYWuYZx7Q6/H7OkFPLbboE/W39TDFkvkfwXHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559036; c=relaxed/simple;
	bh=izhq5kbtt0E2GDvdNjtl4p/OrqRO7ylffD7YEBfaC94=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pHCJ0Qv3GU0hjeO7wu/XGOK+A+dIOSA85IpfyQlhyB+EYyjP34tDak/uz2H/kKldB0QUCYMOE50Yx9GbtQRUBYsUpk5XNJfMX5lCd8vhMUro4yALLeJ7NCn+vgb5BjgB7RlJNVCLzsF/YHbqUmkf3MeMkcFrSjKgF+Vy05UddeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9YC4Hxh; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9YC4Hxh"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7c49c979b5dso120539239f.1
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 15:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1708559034; x=1709163834; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UUJnSIPTMCvPPD3P+M+IMvy1Y/adsahfRadjAt5ZUzQ=;
        b=P9YC4Hxhg1EjfDcloCgf3afnxB1gEVw1UqeCE1sdxX77kiRnfuibCjve/rzmwvKmao
         q9i2YSPUHb8LvwHmcBrNkzPQuEGYpYwnXsCVy5u4R/q26iUrS3lIu8o+4hwkDbCIkvtu
         ZXvxAC/sP82j5lX4hXv54ElV1jkdhsO6k/1TM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708559034; x=1709163834;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UUJnSIPTMCvPPD3P+M+IMvy1Y/adsahfRadjAt5ZUzQ=;
        b=DZd+4RDg3Ss2wcgdFPp+KV06Wn0ihqiJK32W4s5eRxqBSnqwtju6Z2PIlwjz6qI9yD
         NWCywuZqSOxCR20jnAId2rotfYm7jt/HBOrvMMr3MMaBXn1EXnbOaBYi/pLf+zJgXj8H
         cE4oZy8fpxdRWe79IktsKikhSC8raliU7ov/qnTUTFUJQi49Y9aVFI1jOijcAjsLtHV8
         vNw8CF6q7yHGyNgksFqxU2EmW74R2NQzyDKxnyWvRk2uYebQdVRBMrZuZL3lTGrhSGGG
         Ng+fXMAmmF4HSfWLOQtTChgFBNSik3P5+ND+763XX8ovJKk1LeqCESNUScOTVYlPjJy8
         +iyw==
X-Gm-Message-State: AOJu0YxxUFBmS9xyH5Meh0p3WyRSGt8MPT4QSNFCc7SwDeS1hUOOAp6D
	se7YmywVA9oeS4sCAliLvTEoossxmuSEKODgsnqYw5NCq01Qcbkbcawdo24Jqwk=
X-Google-Smtp-Source: AGHT+IEtUrvA3B1IBymiy547pK5kT58ah7a9oEbpT3JrqGJ0gP1CK6rxJMySRIt2X1VUIz9rI7Pq1A==
X-Received: by 2002:a05:6e02:20e1:b0:365:1967:e665 with SMTP id q1-20020a056e0220e100b003651967e665mr12362408ilv.2.1708559034103;
        Wed, 21 Feb 2024 15:43:54 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id y11-20020a02904b000000b00473cdc58012sm2932344jaf.134.2024.02.21.15.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 15:43:53 -0800 (PST)
Message-ID: <928af94d-20dd-4c44-b73d-e48833413056@linuxfoundation.org>
Date: Wed, 21 Feb 2024 16:43:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/476] 5.15.149-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/24 06:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.149 release.
> There are 476 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.149-rc1.gz
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
