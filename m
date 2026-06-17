Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A499E3630B2
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 17:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781718079; cv=none; b=kgpZ/vbZR0GTIGPtxNPz3QfQiR2M7J3GC6pbrxhrbyed6rvEd0N5seMx2TF/yFq+A7KL8KETgw9p5Rp64Qt8iOye8K5YE8LyLFZGqs5EXxyVcTGu6Kx82gMJaUyaXgnthKSkIbhdrQ1idf61NnCwk1626eHmJ/sw5X5iNie7aeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781718079; c=relaxed/simple;
	bh=LILRFxSYEoi268hL3OSZ138XRa0ZaBP07waWon/0rGg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JmNWsXDb9yYhbD9RC+Yz/q8UlhClInubRr4kyihaHuDpOYFwEJOSED57zNJxvfh0/7lcJucCndCbBTQcD2ZyDTpuuEd+GD2YpQvoqTYxo1Ke+rSFSeJ/B2ex/d9qLnhvaiLM41sBuvn2/z53P9Mi5tBV1qOv4eIo4JLdXU9oMbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScKcfkRx; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScKcfkRx"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-69e2c792289so34944eaf.3
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 10:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1781718076; x=1782322876; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=igyxVB7fmZZCgjWNvoj3rySPp2JuIhAo6gLty/VDFpo=;
        b=ScKcfkRxM0FCRZoRG79FhFGe/r0TTjfeBfX7iD/3UYvO1WdZ2dQ1d+ev0cs1/VWGZk
         KUsKuAG5bHswXoRUIQiPMn/a3kuDHpVZM5+qu8KPdcda52gBXkiPJJMcsQ2wyFjrc5mT
         k3O8Czv64lMF4G3W/rvqZDNChI0nglPvBUBuc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781718076; x=1782322876;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=igyxVB7fmZZCgjWNvoj3rySPp2JuIhAo6gLty/VDFpo=;
        b=oS6wSi1S0CAe38tjzPnLbpTrtJBg6hx1c/429K0hgagwNPPWWeNIJ6f6pWhWXgvlR9
         x29Io2MDf+yBgjhPqhDs/K8Tmk2LTo2aveFpyB5Dmwc4MbcpaZlfbu9CTBJpXulWHncl
         psDXP9YW2/hFJbXzMyF46mNSfyuCHxk0TZcnczQs+iS46FiwvL1ZQXb5ogT0T76Vztcm
         tvaoHDR2dOn+h+dssQ4DOaOZQTA/BbY0fwUlim/txAN1XZng5bwuizNV80lk39PusDZK
         PnUJBqpFy/uklBw+qJQG/3TOcoGUiFMtJBRS9Kr0SBEWK6emgPFHUZsP53j+3LVMIiV5
         SyZA==
X-Gm-Message-State: AOJu0YybiSmwrotjso9KU9jroAjj1BGgl2LkYbHhg35Gh9r22xW2RxSg
	x6q2yKV4QDcF4THmQGkMlyUUfO9sYTdRjtmf4umkP0Gi4e3Ncrak1fuC5zg8BW5ymmRbON/G18z
	sn+sx
X-Gm-Gg: Acq92OEU3ckBhZSilNbDWLONxG7j9VdvYmilaKTvGKEpovr3UaeYw3Baj1tgwfZB4fT
	s6P0SA+/0HxRfWy8WbZE1gD9BIAB0Ye5M8EWQxLnewIo2MgzdrfAHZMoXdiYK3U7b9/UmhPatsN
	XUSIYQqBBIhmpfUGDsYHMmAW7Hg5bZLl4AuLh0mmEiZp+82Au1xCBu9F7yMa8C+kMdng/rpRes+
	o5O2l/86x0vuUI17PbeL9hJZ237+57dbB4JJVJgB0AE/jXxy1EqNbHCvhOfGLcjUcS5YC2CXDvR
	5tyDyeokys6qonogb5KjMBbZjx2/ikAMOPEH3vbezZD5Nqti5onBDHY0LZUPoFrIcxdy02j89XE
	wWU/p0oqvJDSQMuQ0wpRZIHlTnyBlcuYbdGRseRD9V8V7T5j2l9ac0Uz6b13DoMDuoCdRGGbwrw
	NXxLYYnLWI7ae/ByB7kQSY
X-Received: by 2002:a05:6820:4d06:b0:69e:36c1:8fa0 with SMTP id 006d021491bc7-6a0b619686fmr3355888eaf.39.1781718076578;
        Wed, 17 Jun 2026 10:41:16 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69f00edacdasm7277086eaf.11.2026.06.17.10.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 10:41:16 -0700 (PDT)
Message-ID: <0733960d-aa94-488d-a4a8-7ec07d5bdfa2@linuxfoundation.org>
Date: Wed, 17 Jun 2026 11:41:14 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/411] 5.15.210-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/26 08:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.210 release.
> There are 411 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.210-rc1.gz
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
