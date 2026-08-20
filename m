Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEE0391E4B
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 18:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787250517; cv=none; b=sCsw6xINr0WUEhiVIuY02GiFeaK5ldRpJ5s9as9N1Mzsvan31agsLZ6IJWfpRgP0hjYrID5f2voDlBM1ms+4iWos3Pmdu85r8KtMB91qw0Kga5sAxD77IlKcgH/YJjEpKf2+ZkmCpH5c7GE3yr/ZHlY9gr2xco9bbFL74XYHepY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787250517; c=relaxed/simple;
	bh=K62eQ1yWB1U2ESSd/iefWVhvrDEsPea2Q4oOaQaWyCQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YqPa0rq8ynLlkmxC61QXsOUi21OlA4W5MUfh30x/VaLj1Gf2yrT1zzotpEjLD0AxW20Q66WLIBOV0OSYZ/cT9mF0JEFW108t8vfDEb8/YlWSUQmawCVLThifW9lpecec7MYiUwIXwHhmtLkD3zOpmEZJrbngpHSl6J+pU8iwOHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eAoH7tlu; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eAoH7tlu"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8f186025973so2340506d6.0
        for <patches@lists.linux.dev>; Thu, 20 Aug 2026 11:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787250515; x=1787855315; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7KHPib1wqWSdOYjSbO474SAuPKQRkPz+9y+jPIA9olg=;
        b=eAoH7tlu52awTu8HWjotriCihwHkxPm6huIP1VTphaVKDk57CBQH1OneBOYKdogWRI
         RDFREk3A/B0xmwwLK1juIji7PU5PmLAUx1JR8ojBGfTn7otgs1yLlPrZ3SF9ZYqRG6lz
         1KURQM2s0ZSt5gdnXEEzqRrlRgZ3QkIAUUBa6JWoHcjwd0mzf20LLlKQKGmvtBtsH2ef
         Tq8vNSSVBI2Nh+KE4tLZoLfImwSbsoXe+Hy2ycjPjE5WZmDjxVT4zUuddU6Ri/A/dkhs
         0q4mxLWz1A3ce+WAlOqm3kY/2MpWLE8b6GbVCeitMI78kCcdkwUKnto1st6CKxeApIP/
         E2iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787250515; x=1787855315;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7KHPib1wqWSdOYjSbO474SAuPKQRkPz+9y+jPIA9olg=;
        b=YRNZ9FLoPz+7bV5AWpBnIBnT9cnhvps7VsY8FVYk1tHfwdNjCYVgP1hNtPofXzgtqz
         3ZBULnHJojXcF27c2RdaiFNjC6+4eeHL8bVf8dD9tfban4fEY8TrgyahiZRGCsXwDatq
         sBqHbS31a8l9E2VNrEjSdScmfVCoa67r4Ex4qEwKVRi0ssmJGKUFLnpkHihd4oxwby2/
         nygjzEbURIvafa6sWJOjl5rLAqoBCPvHZfFmDxvGMaaYKdD+QVtpltFXlwivLMyRDTu+
         3WLnq5K4BX5XIJ4TS6e02kocdBPY58uPtzQPP57ewBArh2CZ6dghw9twIXuUNLhh1Y3P
         SC3g==
X-Gm-Message-State: AFuF++kt8UlF/X/lf27o49o3nVZgfIhixH7aKEfpv9XWjsLRnMr9qgf9
	XXUm64lXmJVQuHNUIEsRCg3yT4Ep2WXWUuZ/aDjC1dNZjHY8mnykxPNG
X-Gm-Gg: AR+sD139GvLZiaIB98ZXrNTb8IiVNT5nV3HhRzSMxbIQQFIbny+OFmsGL6lbyAYzNMx
	U1IrzNwTdcKwCw+1TCR8rqrj4mFDvFQhBxfwhquUdPmLUKhO7HSaxl1aqC7WdVCWhSTeP93WwgE
	3w7QiS8T+ZWKTg6r/cOOZIz5bCns5Yqucu06emhO8i6VzzojDtdk0trYH0hkFO1veYMXLoC1swP
	WVAIwdoFsW0Fqd1s5KDZCs4RSVL5bpmjYvYgEZMJeiceUonAZgTxXkNGB8kvqneL647INm94AUc
	6PrIYy4ldLm+fLfyz/MNGB8wyP2VNb758IdTzBTs3kVg69X+/BL57hbYAJENBWTf+DQuBUb+tU3
	JpUCZZgMA3Oa3iN697L22FpWfRWRwThL8JF7c75AYf4UGqQ8ZDN/psv2nq/CAC4CbemsFe59nOs
	xLyrSQuqLDt4ABqjMQLdhx3mkMxyEP2IEDYyUXpIxuDWUTzZk+sXDaxTlEYETuyRU2OdXyMwH4S
	hPGhePTFrgrpWw=
X-Received: by 2002:a05:6214:c49:b0:8f1:d3ee:a8f5 with SMTP id 6a1803df08f44-90c80df8b32mr1076996d6.26.1787250515072;
        Thu, 20 Aug 2026 11:28:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5f2b5ccesm44072686d6.46.2026.08.20.11.28.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 11:28:34 -0700 (PDT)
Message-ID: <bc48a982-e8db-49fb-914d-ed8751570c5e@gmail.com>
Date: Thu, 20 Aug 2026 11:28:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/303] 6.1.184-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260820145253.200766705@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 07:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.184 release.
> There are 303 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.184-rc1.gz
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
