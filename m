Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E42308F2E
	for <patches@lists.linux.dev>; Tue, 17 Feb 2026 22:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771366935; cv=none; b=Q8HukfflBZenlCTeg4tL7INVtM2z75xo+9i/g+zy24i2ix3BKdO4M5PejJNTuLdyAiEKu+aE7dtjurzGjdwItogwj7arXTWrL/LeCDiXeVAoaSHwLMPSqJM3UF36aBTVZlzgzKb1WONjv4c4z29n6pg0xn5cFZc+P/23z+F5Cvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771366935; c=relaxed/simple;
	bh=4pSsJQI5kK7F9RTBEsjVvW4cGYa2TNW9h6ZRUVNEcj4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V7WziZnozAFeFPYxshpTEeBcoQPynxcK/ViJpQkJPqccnT7geDmfmJnbjjLHavW4iqmz9/alfhEeuNQ9C7ZoD/4LFNoOPRo6yfWgnyt9+gw79e63LnwBResUDs871vOGnFKiLdfMRzOi5ljmhpT7uUJzDLV4Mysn7TjGEmGTvo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y4z38gfM; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y4z38gfM"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-126ea4e9694so814784c88.1
        for <patches@lists.linux.dev>; Tue, 17 Feb 2026 14:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771366932; x=1771971732; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6lAc0oYjOpDfV76/LRGYzzkMGR3mISHKce2UjflqzxQ=;
        b=Y4z38gfMh6Ru86sfUNlPquIJMrDaNMVCrZI+xrdH9CdYor2iyx+2d9Tx2W1VkPS56D
         ana1nn4Y42h4fXxq5wEgC3oPZ6kMB6sTOnFKchttBpAFJLiXIXEjRPsM2Z7Awjoumkg/
         0b8KJFZ8o5A5lzCL0I71IWxdylb8eyeckk7s1R1B1xnpXr1PLaGBWuukTh/q33YbIUC7
         uw4mmncXOsauoZfBvvxUVfPIumxLmv0ei3qNcG4aWHMS28eZOsjqdF3x5hnLilxEwUGp
         OelA+Zvq1HM5yLKXDXkQilQbhELxceV3dr//01O2CZ2IdTi40JtdTFmEyqlncmAPA3Yj
         AXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771366932; x=1771971732;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6lAc0oYjOpDfV76/LRGYzzkMGR3mISHKce2UjflqzxQ=;
        b=I79s/YH8RbE4WBGfRE4EWh6cLc6GMP9AFpVL5wksoo1sJQwV/dkPvafElwjMk2MAgV
         RHpTU234YT6CoFSLczlfjWa5T/9tISWxBgOkK5N2sdTP0SGCTUlNb9RfA5bOrZusv8s6
         8iAV2pYuPkf/k7Z2xGacq8T/S5HvVlXh8i+Ribpf7PDqDEvXyMsJPx3uuBC0A9y+38de
         /6TcNxLVcAkrk4u0VYb5N9a8yvVrabL6Ekquir53iojyWA54LGVkEfpWGOaUJDdcqYRh
         fz2ZkuvPPKuhe84bm1fsO3rCyU9iuXb4DYBGILAG7mtXERK6KqRmPjtE5p8mZzQ+fo82
         srbg==
X-Gm-Message-State: AOJu0Ywww+0iMoRfuWOg/hHOIoIdl10fedpUfuIMEPmGAyPn8oxXQJsB
	YDjs9dVuMuXCE65D4hUOQPW1ERnoTcIW+D7Prcj8N1NwxKOVytb0W6CC
X-Gm-Gg: AZuq6aKkIjkF7pJgyuzfm29ooELaptsXKchQ6IKT4b+ZSsZ1uz7p1dHHvEZ2NF3Nj/x
	CGwRVTwy2dxcOkAtE5R21axu19CVLljZsu39fZ2wLgF1uo8mE8QOtGqSKyeg9TsgbawaPjNb7zg
	JJkQObShapQoRkrZh55kC+OID1HGTTxsnNqR+STNA9jD89QaIuxDoYKczw4PBe3BFtR4BkD4Ej4
	/4Ou5rLxBdR9LZYMbRatYr4CwHeISOUpWM5Kips9p8yTRFFrx00eQW+lN7WBiEep2hg9rvS+TJ+
	9u3INePlbd3537u3i42/Yobxps7Rl5ENe9pTqWhm3nbMLxNUed2xotV1GHvr2+PkUiiOWrVVlNS
	Szs0AMAhD3iHD+PG+n9OMi4yn+Tk6dq1NqjR8rsQMwx7ixQZekEgMwjchAR53HaXdihUJHatk0C
	GiHNJJNO4uYlYlpe4fhb56s4ks7sF79xUkRbtU1HhVezFb6FtSYysYI9l1hZKP
X-Received: by 2002:a05:7301:2f99:b0:2ba:7033:533b with SMTP id 5a478bee46e88-2babc47ff16mr6278958eec.32.1771366931836;
        Tue, 17 Feb 2026 14:22:11 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bacb67b638sm16215305eec.31.2026.02.17.14.22.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 14:22:11 -0800 (PST)
Message-ID: <9e904b11-7064-4a3d-9dd5-473e892fbf38@gmail.com>
Date: Tue, 17 Feb 2026 14:22:09 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/39] 5.15.201-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260217200002.929083107@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/17/26 12:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.201 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.201-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
