Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E97EC5
	for <patches@lists.linux.dev>; Thu, 26 Dec 2024 16:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735231759; cv=none; b=fj2VX4OuSrJDyH+42ZPq6JTjJhXxgF+XXZzHctYz4nMvV4WLD2UwsdlSmT0VFqDWROcslap6T9f8W3AdQECrff0SxAhPmgmEXQ1uuVoSwATo1ivh/SUcpIHZSJ+eTmE1ioPzQrBO1IMmgNlqNIlBJzqSDrGSB1WLHp6Dstf3Kwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735231759; c=relaxed/simple;
	bh=L+cBLo/DSzgj2MCwGGmqKWP3pKu2xdyjynZneTk5mFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UvvR4HTH5T/85PIjQ4tXk/qkumivg4rG2/cqmHVSoNhrT/+6CcYsm4JjTJQhiETUyDip5kZsKfjJX6gylh92tyRyCb1Wnee6ITlWqxV9Wcx1YBtGkXY1W2Mfz2FBR1eBIqi1ZbnyaodkckghoW+FvjbMg9AG/WGAFmGLVrHuXK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OmjC6/o0; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OmjC6/o0"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7b6e5ee6ac7so517211685a.0
        for <patches@lists.linux.dev>; Thu, 26 Dec 2024 08:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735231757; x=1735836557; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+dKjpTzluOX4sYgZaMCYyXG9mQUoSmGwseybG8AskV4=;
        b=OmjC6/o0sGLK6e8M9Dij31sfpfVQi6BhjJ2otUuxy33/uxb5Hzz63t3xQV3BbMksnv
         XYeFFwwpgleGgLaAYi1MwrjZvkvL5ZNQUYmNZufR5nUnxDD6+HY2FoWcAJ+8mb9HgcW+
         cybwTfTzouhYBkN4YjUDNEOTmYuX7qlpZ3BJKz/dpORZeeRjszm0jq7s78tNWr0+7M/U
         rVGiK93L5VqGUNgXU3WymXQkvDjrWHuAymn9bEVgICJ4IanyUS3fmacJoEz1eI3EKjL5
         tAtjQgVSTRyGyq6UFrkGNbvix1ClFrvkNeexO0gsqRaU5JIGNAWdq4iTxmVB7wR/9hu6
         vHAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735231757; x=1735836557;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+dKjpTzluOX4sYgZaMCYyXG9mQUoSmGwseybG8AskV4=;
        b=bSzn18Cu8KLoz0R/YjDyRVzphJcTTa2NQgoodrBNMR1NFGTFOMO1XjDR5NOQd8rcCc
         06DR8U2mS95DrkgSZ4oM+4DLh7ZvMkMjgh8MQjfLr4/NYfoRBmc+aCpx/g2aY8u05pGa
         XVeZzoadzwb0Jb/wcYfuW9OTnUrUVyXK85W4Fr0x6rjWZqR//TyJ0i157ClDSKXE5+pk
         jYc63YzxXgDk9E9ngYzgaQ5dAcdRgtYqsbSjP3BDUBeilhz5vjbFUcM1zKyQNANe0clr
         JqEaitW2QCsI0ZCZYVVK/QcJVXPfhwsluAgAqHoGZGSZ7K74pfgo8Dyvk+wSvIaheR4K
         RMbQ==
X-Gm-Message-State: AOJu0YzRAU3QK/SjeD1flHbKdxE6vjnTchmJkb9WUZmjIZXnccT5qe47
	r4jFjpmoqn6cBqgyGQ5Wy2rPEfHVnGtlLLo79hHN+W4TjAWMMP7n
X-Gm-Gg: ASbGncufZDTX2E1agazfcmlUnOyna6OyssQ0h0/KssB97SaoohM1QlTa+fDM/DbyHex
	gw/l2tw2Phr69FA2XJ/chr7k/vOpACTfng2UTsaiaN09GBWFKvwX+Q6BiHmUoMTuB3BN+TQUNDU
	gBBujqnKiDpc0GNUS23D/EBAp7AXj+RTStmdQARz/C9AtqLJEmFFoJdG32RlU++XHhP2NqJvQHa
	4GE17ba60sbOdfPtzfDVVlg1Odsw9boH54/ZQVn8ch9FgO+83GIWf+dWrXa1SdkjNyu20kJkmaY
	qzWwHWSbs1sQvxBXByI=
X-Google-Smtp-Source: AGHT+IGwM0VcOmTyuNkkCH3jDngDzlNY4DYmQMpWUwi+u5p6nJwCC+N8VfHpif9lV2IYuqrv4x/yOA==
X-Received: by 2002:a05:620a:24ce:b0:7b7:5d6:37fa with SMTP id af79cd13be357-7b9ba7ec006mr3847569185a.41.1735231756798;
        Thu, 26 Dec 2024 08:49:16 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b9ac30d319sm631532285a.55.2024.12.26.08.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2024 08:49:15 -0800 (PST)
Message-ID: <899378ff-9960-4857-99e9-c39dd4ebe8f5@gmail.com>
Date: Thu, 26 Dec 2024 08:49:13 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/83] 6.1.122-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241223155353.641267612@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/23/2024 7:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.122 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.122-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

