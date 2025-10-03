Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F7B2D8783
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 17:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759511637; cv=none; b=uNpJdnPpQKabqBdygVkw+aoAwtOD1sa+P0/d30PkCPY6wzY/wL6RyeAA2M4yCy5G22XORT1CkuopJBx2pCmCmMLCtJEnaVpCYDsmMHmq8c+63Lr7menszpZ0S4d1DxBmfWeeZe0IEAbfyrmbxMpu4TEq1vWq9lB6h4FGCDqlDfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759511637; c=relaxed/simple;
	bh=V2yDQ9t5WRaCCFVniNPFFtjcU+Z93008Qn/4tgTMN9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FfVEuQ/xNAFx72AevdFMjLmDsJU3C2WuPZPFHbjppHhOUR6XUL2UkW/GaIr1MKN4ClV5u6F520AGNfReOJOOYwVuu6aTm4j9JADfPTB63ka+j1RS+kyhXiMsmL0khIOomErKQNDqwqfAkPn6HLPKpqEIjEulm6cBoQq2aMbFntQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WgJLuMpQ; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WgJLuMpQ"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-78115430134so1750678b3a.1
        for <patches@lists.linux.dev>; Fri, 03 Oct 2025 10:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759511635; x=1760116435; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g9aHct2AGSJyqUdy/hqfaZO5vGD3Tcs42UjzJUIOSD0=;
        b=WgJLuMpQtfn9sOcxAeg3D1j6Mz+thsOR55QL8wVx0F43JhD7DlfeLFQeCs5ynwBi0M
         J+aSoAqXOLlCZH2QsA1AYW0Koqn7d/3cVKHVmUQs4y402CJzzb5NET5DbEXfIqzrKArg
         YZr0CYqJcN5plIwSh/kbbYsPHqtFph2WxHtWsiKC+ypyd5AdmVlf0ZgwqQhZduJTyYGI
         0HNJM074WcHT9SfPAprsGfD9SZU6w+gWQnU1lo/zmGhxFmEnwlQlRRTvH1PKciNcnrZS
         otbdy7dafwE2CZuG5NMhjkhtI2exuwEGb7bPHcwt54/1Tf6NHlnh8n/aUW74Kg3dX3nv
         ldkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759511635; x=1760116435;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g9aHct2AGSJyqUdy/hqfaZO5vGD3Tcs42UjzJUIOSD0=;
        b=Yp5wSkUwNeDOWDXsSK1r46+6JZar5gjZKnF1kAR8OK1kfkH03Opy2pB3bFgH32WH70
         941v9L8rH2hF0XpN7+KgK5E7P0I611CR9PVtL+As9hOEHeDYnf/UYBfVeAvNHbiwYO25
         td1KCC/wLJV/ezbL1dwvc9VAK9cR6ViTxnasc6fQysoKbCUfbaq7tIil98z39SIxj8Oo
         oSEJSTOd5QviY3OS49KY661jEBjM4ietkHu4ZexkUVqZSs7mkGdPD8Lav/YDhztSccVi
         tWxTOIxhTSMlCg9IjRjoSeEpxmXAtymNHeJRO4Yo2YMvvY2ZDYcHSX3HvVAjin1trUwL
         MMlQ==
X-Gm-Message-State: AOJu0YxCJOwQdMPRbzw+pVVP4Jdi1ufEQaW2vlulD6Yc4aGDSrObW9Mu
	hoZooOyOmSyClPq4PXYIUNoPq89pwKRqvABhKZ9H0+cTvJ7lzEGMJRFx
X-Gm-Gg: ASbGncv1N89UmQ5dTt7pWXC8JOL8C2siGsWfyWKmolv3oXNtsq8W6TD12tmTepcO6ob
	7BVRq2iE9Bh2AUJn1aemTjuNxFDQ/PzomKCwzbTkfJ4Iy9/caKZYmhW7sGPd2z9FIUfMXHp/8Af
	SNuxTs5KETbVRllg2+Da6/j7MxVr4ZdJFNCgTjnN+IjnQ5EcocMEPqO3XP/Od1xWehHxz5xb6BS
	X1jDuUZePV3i2oMUGifD6hjtT3jEhw2XYyo6XSKE1mHfv5v/YWPKXGYqj0z2o7Pa/GJUYqsOmwy
	3sFzyH+GNWsI5eOuN+ws2h/tYx8TlHOl1kHWI4Yv/eQHgqxmkkyZ9JXeb0x+r/kXHalLjhFSI8/
	3Aw5gPziNH63bghJFm6Up+UZcDHHUYUDgWpwAABZy7uBhXEkUu47teCRNvL69tyttJonEEgbpkY
	kh/rQMaG8VXnwd
X-Google-Smtp-Source: AGHT+IGYxcu/7m4cInBmVlBcaknFm26QdLjuVZE24mLFzQf4XQmV94nPh21u2/AfgdOkqw3I9aKJhg==
X-Received: by 2002:a05:6a20:6a28:b0:2f0:4f71:c478 with SMTP id adf61e73a8af0-32b620d8f50mr5346720637.46.1759511635156;
        Fri, 03 Oct 2025 10:13:55 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b0209005asm5517750b3a.81.2025.10.03.10.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 10:13:54 -0700 (PDT)
Message-ID: <f9c844f3-fc5a-4e66-8547-754f73e33af1@gmail.com>
Date: Fri, 3 Oct 2025 10:13:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0/7] 6.6.110-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251003160331.487313415@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251003160331.487313415@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/3/2025 9:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.110 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.110-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

