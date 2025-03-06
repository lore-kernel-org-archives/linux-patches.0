Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E7125D541
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 18:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741286649; cv=none; b=pcDwys+F/bfmkFTSyblHeIkP2VX5xRC1chkg136PrHY60p3pzKthIFqRfKrs9ygWQYq1T0mM7kPkRQtQP9LtZNXb2e57ydqnr8p3PqjNcyLB/g/GzXqAagEudGSyTljFxja5OUQzRFWxDK7RknA4rUBrjAI1UpZ0YEUx4VR/0bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741286649; c=relaxed/simple;
	bh=VK5KC+x1pv/lq7ntuIGz6PwD7O044LcrlelG1xAIMxc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=G/XJHBRWS0VD6AwXWk7QLleeVbi0u3O0yhp5seKfjj4M/gna7layl8dHdzJKMMz7/4NQIB7kuEkd88+rfAvyVUIN3h8FOgQP9r+FjVXjsQ3BbpGg3twYsrs8erUc59bHYIWDoNj/Syp3dud3IhsvKpk7Ytm2q40hcxOTEeKEXao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aDaT9W7Y; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aDaT9W7Y"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-2bcceee7b40so729433fac.3
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 10:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741286647; x=1741891447; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vVpug70gfz2HOif/JIKANwhTW6xxPDf4IUYvwA4URGE=;
        b=aDaT9W7YJgm5d+Zjs2q+ru2NVEQ9/EQBYXfTjsTL2WfAycGHlzsLT9vYcCJFBNmZNd
         GoY/ZEYUGCkZg7xENnq0Zd/GTg+MKknPOHChLM3CUkOTOky6RRGw7aEiKwLp9snaJcag
         YorQjmUWnhaBvEhNG6enkf2D4Y9uJg+cylqI3l64rSA9y4Msdw7vug0k07jHmWDO4yw1
         qaG+yAySvtgZrTzQy//05OIApOQXqnrWjo0LJ9jgsll3k1Z6yggqc6omoIynyErytEst
         9MyyIdNUmNbn3/lxYWMdmfXr852Z25/R2r5CNhMcibvV5/0vAqZP2MKqdjAQc7u5p6Uo
         QI1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741286647; x=1741891447;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vVpug70gfz2HOif/JIKANwhTW6xxPDf4IUYvwA4URGE=;
        b=f6atwbXyfM/hoOSav7xl2qS7K1KFP3MgQlY1xmwJYqkWxlhmOZXWjNXGV2CAoq9Z5T
         9DhZ/qGZ/XFDyHOxoQ5R8+FOJGevXiph47S6SdnlRVJl+t/z1lRTbgnNnGKKS5OWxJLB
         UyatZ1XGe7aNFSh/VJG36MvOc3cmb82Ao6T5p3TxCMyGFGtFcRyFK+W/9XYiNDIjLn4z
         Rg+EHDtItYVIiHGPAbteF3utcLZ2JC1/FUrWbeFkl4A/ethMZ2uVHtlV4CNWlov/Jwvd
         hKix7dqU/N7awdbk9O8D28Bcg5qi7e4oo8XiicccHIm1bWRfjyMj8plL6dG/cKcihyo1
         Tkvg==
X-Gm-Message-State: AOJu0YxxmtcBtvgozET8OhdGVw86/PqwSvVFLGD3d4HQyb+RtFa+WFl9
	q2CLPydPluhWLq4FsoeOqfzvmlM/S3MKjAUbx9MVInCZi8EePis/
X-Gm-Gg: ASbGncubZ8TMImKotoo4a0sNd66c+SdZm8wU9c+QIEGDDnRsqpGBoOnxg9sifRJrDv8
	iRVOM7mwmUadDeCcooYU7FdOWkCy+YgQjC28D+zJiqb5Br8/yoe99//9Yh6REKGC0gGzHt0DvcZ
	ep/U7/3D0Xs8jZIVsRO/UL3R9H5c8nhTZW2xGktkCqZGFpd5K+jYWqNSvzAMc+Y9xZIWr3aIPPC
	35TRE9pC0tP1UWUHRwjgBGFZ1QBcwakfwRMG6w5b/4sZ2cFfw8K6Ha/qlr2H1NhR2k832KZpkWo
	PuC1NyXXZ7zj6WxYONPU6FIZYMKVFwuDJ1HXRox6yjgz5iYfR9t81/qd4TauOzD+96xFkgRu
X-Google-Smtp-Source: AGHT+IFnenMncEl3AoHYxDb4oauoKUdwdgpZOBfioXbP9pBj/UHxG79JLgSMCFzC9WqQiNYVUhIxzQ==
X-Received: by 2002:a05:6871:110:b0:2b8:fab0:33c with SMTP id 586e51a60fabf-2c261132f0fmr222255fac.23.1741286647379;
        Thu, 06 Mar 2025 10:44:07 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2c248de95b9sm342545fac.46.2025.03.06.10.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 10:44:06 -0800 (PST)
Message-ID: <64d11e0b-e964-4c55-a0ba-d3227871cb26@gmail.com>
Date: Thu, 6 Mar 2025 10:44:02 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.13 000/154] 6.13.6-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250306151416.469067667@linuxfoundation.org>
Content-Language: en-US
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250306151416.469067667@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/6/2025 7:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.6 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.6-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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


