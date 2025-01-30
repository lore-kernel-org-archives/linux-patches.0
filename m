Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2050322B
	for <patches@lists.linux.dev>; Thu, 30 Jan 2025 21:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738272709; cv=none; b=stb7AyvHkLy16C6pheoPBotCh7PQ13BSTXzWXoJiRteuVsFyixMfpbIZwhLvtthnChu8f8ec8Mv50+nKZyuF5yqR4KrBTDgwxszfzvIrnJZ5q/9e232H+J/ilsMG9VbkFRyy7Xz+W0pdQbc8gs46n8VKxj+EstG5JZtbJ7VwQfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738272709; c=relaxed/simple;
	bh=V0zt8pNpSVxm3rzhk6TitG9qt6QVSI1feLDgYAggktk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Da/zsFBRluTmx6HtG4fr6CbkqqVEbSp+digakTXPu+gqUNLjE73Kwg78B+2HXZF+AXqEZ4RF6F86+df8n75t0QSnSYpsWhM+7GLIHWysm5+OMcfaZgPOJTkzjy8gaxGyX1Mg0o1Nn4Jj5NBv4KMM8JOf60nA+yf7zyeaMsDext4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jLLkQ4x1; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jLLkQ4x1"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-71fbb0d035dso717219a34.2
        for <patches@lists.linux.dev>; Thu, 30 Jan 2025 13:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738272706; x=1738877506; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6ezGOPK7HRCXcFfaMlxExVACmV+hJUfqNwX+Seyi/4I=;
        b=jLLkQ4x1Pjc30RpBL7kugWec6rFObsl+wLFGURJDsiTza9KzyL16X2GSqd/W9ZmfPX
         vDIt5ACstUHjDr/fI3p5YxhDy8x/Qe37Og3T2Ysvb4gp9d0HjLaTlVcrNEUjVzKfUNg7
         PsF1mXNTYbMPyWQ2JRJevjTF1Kvwg7PQwQ/hIKSRyb/uNjUtwW9F118s+jIxC1UujvLg
         EjKALvEHuafnnqeC2u5f9sp885F4LElo92vkMdmmN/N2bMVSMKFbBb1BAdG44zzP0ye6
         m/Hc9F12/5DpG4pnCaeuwYt8KS1guBnMdW4EArnrzELNsMgzGmZfhJAyWdFjGOji0GMK
         WWQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738272706; x=1738877506;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ezGOPK7HRCXcFfaMlxExVACmV+hJUfqNwX+Seyi/4I=;
        b=T0DtMbYnd7AmrtD5QZrCBQb/WdYcFbxkaRrynWnmIYPach57nBtd13t+vMZsPSniXE
         9kD4Jrpt9RXY8Q7dccZk6QANS12T/XpAa/Ayhq9mII8lwAu/07RSVAZ2L9rhUv25Z+3N
         EG9Bw+OcERi4WGt+JBM8w7L6M4AIeOLcTs/LAns9AN7Vw6oWMXWhrV/WDYiJ5zC8QTo1
         FaB1qWK+dj/Y9Y0fegky+c+mlHRyrc5zFJDCyeN+VJINgp3W/VSRDUrNDfAaOnk7d63s
         BP4emXICfY5szrcuMPnyzQk8GxHQa/yZUsJznUGZjzlAMSOwW9KVqURZ+0H7mUzyyKcn
         +Fmw==
X-Gm-Message-State: AOJu0Yw55nUEV1nFnaOw4GzC/p8g8pkuG0MeciqSTU3QHb0h7/HAUIBH
	l/AgU15pBAuKI+acDNPdhRqtjNdUFSOPr1AexE5xTRaPz34BbL15
X-Gm-Gg: ASbGncuS3UzrXHgKn9IJEQdUYUVqh+Gbd70BDEh16PABfB2tzx38WbFs1WjDQ5GwF12
	/zsHTN8fpN0wU0b1q9tFalH3G9xZ5z5dEDexBAB3DB+MW4VGNvkIjBqyu6UyKALnFuJD/hzhjdn
	VkPV5SkPdANLS2mA4wVXTp8oi2LpNg4g1o471lV3PdZz3Z4nAgfox/avKPpH6BhBxMC5vJEUEeW
	pxbSr4WEfANOlxTyDidlFv+y/H57ZNf53HMTMr06hevBci5oYiqZ5T5uwbxBuQtxaGwWrGBWGc7
	SV9A3Cig4mqA91la40C+/ZW1X1jE7qoaOF6DRhw8dNU=
X-Google-Smtp-Source: AGHT+IFUr1xveW4w10nfBCGJ015z8r5ITT3QydOzpsub58Ot+H6hSWiyQH7L828e1Xn3dhTQX5jg1Q==
X-Received: by 2002:a05:6830:6089:b0:71d:4698:7b24 with SMTP id 46e09a7af769-7265679639cmr6534153a34.16.1738272705983;
        Thu, 30 Jan 2025 13:31:45 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-726618b9f72sm506458a34.50.2025.01.30.13.31.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2025 13:31:45 -0800 (PST)
Message-ID: <ab292ebc-69c1-4f44-b8bd-f761147397da@gmail.com>
Date: Thu, 30 Jan 2025 13:31:42 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/49] 6.1.128-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250130140133.825446496@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/25 06:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.128 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 14:01:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.128-rc1.gz
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
