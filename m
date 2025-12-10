Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF062E7BDD
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 19:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765394822; cv=none; b=C7t2fXY/hYnhddUHgBM8JZbvSF2kq2YypDbCO2e7Rlh+ArK63aGH2n187DSm4w8yKhrO+4v26PxrmkaAS3AtPF+iUmb6oLNkbDEroRTi4M7C9oPDgM/xO0ABuJf7AN3iVot/aZuyfxdTEm2UW41ZEHmY7Gkf0w/WfybZHBXU5Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765394822; c=relaxed/simple;
	bh=PVIFrxcI8a6iClue/AecDfT+Cgc+g6BwZWAHt0f7lNw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ZuMZYTrkm8hqSlpxkji/aJvA0cPt9i3fM4ZWoQP2tzcVz0CUHZu6b0aoKE8NHGYfDnWSrpFnf2eN1LLgePe53QOcCrDjSmQSLSv3aCGotGL/4NzPhYuxZIU4EC1pl98YL0jJgyiLrEfvoGoPChrHPjwB7O5CSey5+jEufQPfkF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mui80XNj; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mui80XNj"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8b2627269d5so20165985a.2
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 11:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765394820; x=1765999620; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/q98iSrJdM4mfCqPOnP7IYL1OiEgoSGBl1IkGB/3Aj8=;
        b=Mui80XNj43a2BZRaLUMKWPogc8+AG1n31ETweDK5d5Vv9/Fhi0n4O735p+u0X2jyqS
         wvWq9DJjrNvSkP9S50kBg/oJEVr5h9ghzHLCNWfzvMHK9Usw8DNgBny73yYCJSf46iO+
         WVesZWjVYlLUwN+Fg1qLdPWHgsy5fZHRT0YvbBjW4W4R1bMBL/doW7Y/wQpwbT7oqGRc
         rSq/CyR92nOgU99H0FrJF21uZq0ZiYq5/A2/ndvMuTOci0+xSAQk1VQSl9MF46uJDlHJ
         ibBSA89V1NBfMJUXjbNyd8FboPhLI1Jz0CF4ddM7AJxVN28oyVjwThjyqs/UVKtg8YB4
         ivAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765394820; x=1765999620;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/q98iSrJdM4mfCqPOnP7IYL1OiEgoSGBl1IkGB/3Aj8=;
        b=Sl3nUdlF8FDmPffJcPqhU3rux+1yRpK6K6UFvT0Gwby+c5QHsTHGyDJQxHKZY7cc4p
         jPI7aEZmf4UakNZa/iYQ/0D7D/S8cRnEiMNQ/ehatBqp9PymttmsGR+oTKMzMFngvM7F
         LzvWx8ZgaQYOfY4Xacts/R5qjWe+laalVR82qaz2c4rw2roiMBxjef1cKLVqmmyNC/pQ
         R6b3MqKEFbCx2i+mSDvIUMiKPB2NaWBjQlPe50pNI0jCDlqiNlg7lQLxgeVdXn0bvduE
         DsdGbX48qgkyEZyxuid44pyVWFgDbtXQN0AuaaBwcn6j8uNEnCOIdm0IfVAz3SUVEHgS
         eeFg==
X-Gm-Message-State: AOJu0YwczWrBTeLURrCzxY6SmbW8LJ5iV7vmm7bst3fNBDDYs5Fj01ex
	i/+HKeAwGdQRdXCMxKlWmVrp3r4xlobxbocOCbeoEfe5Up5ZpdWqTe5O
X-Gm-Gg: ASbGncvrJoS/D3gv7KUCMWxTI+KCtGudgXzOekTZ4fuvNiC461UkJaATbr1yrXkKWcL
	WkjouSqTqD2hZSIy/E1+bWXFp1hC2g89ZpzDk/9fPzdwysUs2civ6p5nHZoYtoGuFJtLNoPQVQd
	IYw24/gjb3depJi/9rvB0UUDuGfrJftRwKzHCTd4AfOjGd9FzEzdQ77M7ecnvYFqLIhYOsO8dj6
	dy7KhisaNcBGQsufhItY+DHFxzNRAxgFjMyHrwX1lz7nlea0iQdSdg/6OJDt7jhp6vLUK2dysKr
	awH9oR9sxDck1eZzxWud8ThhQsjiyctD8msMssxPJfGW2uIoq1v2MhnmgcnO6fSeMrUofyDOB3G
	V96kGtZe5MQ0Wt+UDRY24vNG5Q9FZcdirTB+KcuBuox4i11qwiUddxhM9LK4N2WP8caSegN5hC6
	7ofzcB7qA8lh2ZzHRENtNciA39xsnD0CZW6WFrSMLc3NhyZ/KW
X-Google-Smtp-Source: AGHT+IG6+0Kk0tHL/n5UjwxVSbyrFw1tcuQwlM2/4x05hTxL/GrdPc0gIjMHpAINCgx/FcO2tXZQbg==
X-Received: by 2002:a05:620a:6cc3:b0:866:1327:82e9 with SMTP id af79cd13be357-8ba39a2e126mr570904285a.16.1765394819731;
        Wed, 10 Dec 2025 11:26:59 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8886ef1a0f7sm4207786d6.49.2025.12.10.11.26.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 11:26:58 -0800 (PST)
Message-ID: <f8fb8c9b-9ae1-4a80-9f56-bba76e1a0602@gmail.com>
Date: Wed, 10 Dec 2025 11:26:53 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.12 00/49] 6.12.62-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251210072948.125620687@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/9/2025 11:29 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.62 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Dec 2025 07:29:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.62-rc1.gz
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

