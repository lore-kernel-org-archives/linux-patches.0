Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E738D2AEE0
	for <patches@lists.linux.dev>; Thu, 26 Dec 2024 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735233477; cv=none; b=uCudMgrOwE4swE4hWLV3VeMGwAdj2Ch4JrxFl4m4bzWbMDbv5Def62eLKnyesCvjqRbhA/GSojygRZgXk+rHvLtugZ7SJrXlYRuWwN2flq6JzHrzZOsegjsgtqgUr7H04DAsPXyTBcy6jR+idoI2pqd41Yb+y26001cDcSDSgks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735233477; c=relaxed/simple;
	bh=ww7W+rtOj6vI3FcKydZmdcipzAf+fOFg2f8HWEOocgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A5E/Or38yz4pphzJXeuXB56C8c04xzLwhC8iPV57/oOkNJDU2O7HfZLTRZsJYO1jJSEjuxytNWZxHKSW4hDaQGEgEc4YLjV9HJqabip7cZkz1qq5LI3YUKsB7AZbMXOlWZAM21wDyBKwbHkYUo9o3/aj4O3j3XVkZ3O5VLoQVHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q21avxDY; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q21avxDY"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-21636268e43so6592625ad.2
        for <patches@lists.linux.dev>; Thu, 26 Dec 2024 09:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735233475; x=1735838275; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N2JS7KIcFGoRuhDSIr5OUV3yQoO0oPRPWcrr0Aps2ug=;
        b=Q21avxDYcndSx6TVBerGS98IS4GiKPSI9B9ji54uCYQsW23Wr12iuxtYs1TUMCEZaM
         ATcEMZrGDJ6gwaRj4BR/PrK3Urry0vdlRShANs7E80MsbWl7Sc45QU0vQ8PaYVMTDIpW
         JFIHG7n8yKaHYhUcJce6/3ygg7NAimjIaEBMNYvLNpjJrKU7tgvgC9iZXKuDmFEN++UF
         z+Ag1sMtjUVWuF1C9hpfqtX3UE8YLcO1ITwmTkQVUjqNUklw/7PuAsUfoXQ/s1PJe//p
         oWOMiGYMmrRC2qtuaoeZKAj6ALkQ95DW0WvKZAOc457G6tJ9EBzI74m/OwKPFGv5DKLV
         XD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735233475; x=1735838275;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N2JS7KIcFGoRuhDSIr5OUV3yQoO0oPRPWcrr0Aps2ug=;
        b=spnVSD1POhReu8bbNHK6BHkyF3PdZ3wbclsaZD+7fk7X+luTn+RlKvduQqLTnF7R4S
         v6L2sF8npRI1dQU6uyzI1wMn30/ZuSwW6cFoY11P8+dcXNEizdXyqGJfDHR75xmNImcw
         Yi9EoMlZwfYy57H7WuKdY5jdBvPeVC9OrjoFfeW0q3HBWs9G+0Ib7Kh2ZfoF4aYrqHn2
         TTcUONoV2ORNW7k9n7mSGI5sEX/LTmxtFwq22XJz3p07J3aqIuXHzRoIjCaMUi3heleL
         c7bLymNIvi2mnaOui5K0rp/Szi7I4Ajk4U1RGmYYUD9WJriWHVKnyB8Pr1PwVrtdtJqd
         M22w==
X-Gm-Message-State: AOJu0YwcuuOWpQS0oAHle7vFxoPeFYQhOUuS1LqgI1BqlorOjtr0JBcT
	Jtjkwh9loILhMUhDlC1evhPo3/w1X5wmWY3xofQPFDR3NJLvXkr3
X-Gm-Gg: ASbGnctqsuxdv0Bs/jiiqZ7TjIrIbgj5WzwEnw5QT7nzbqpcQUX69CqeJdJpphs6W3k
	f5L4Z/WQCGcpKnB0UqUpx0fNsURdkzkHGE0gzj2HjEG9MHD3wedtcnbCX1ilpNVN4WzeeoePpdZ
	eVFGDm4xuEOck5n42k0MFonByzwgBnANj6mIXiqYkwgbr3+NQykY+3lo+6N5xBVQ1wodB+hcZaf
	FrxiVqL9sJEb37BhhV7rF6472g62EbTeJcfTSATrdV7DLez0SrWDQN5X0WRjusSWHR+kanmciXG
	3e2Ewf9ZlhZe1q70OQg=
X-Google-Smtp-Source: AGHT+IFvTvgkZFJMiJIZRSMsJE4sRMVjtoqtMI1ZfNdqvb3f8fv3x0IsAx2GK1OaxALqD2HTYM+vTA==
X-Received: by 2002:a17:902:ec85:b0:216:45b9:43ad with SMTP id d9443c01a7336-219e6ed1eefmr305861575ad.34.1735233475269;
        Thu, 26 Dec 2024 09:17:55 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9705ccsm122014735ad.92.2024.12.26.09.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2024 09:17:54 -0800 (PST)
Message-ID: <da01ed2b-8d7c-4b11-b565-966ce66f4653@gmail.com>
Date: Thu, 26 Dec 2024 09:17:53 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/160] 6.12.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241223155408.598780301@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/23/2024 7:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.7 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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

