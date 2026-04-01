Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189593F23B3
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 16:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775059764; cv=none; b=M+G8gf9j4FcLVAPSRgrdgyheSs8MXP3D3YduigzxIAA8fWwCBYdi1T4Swj1Li5NTKvXeXGu0AV2XxujR/60sejQEmAtfGr/PAdtue9ooROu2ajPd9gVjEAPnE9fUrv9PFaEfl9daRcnrkgJnX/zCki/YsuJzZQY7LOddxxIWkio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775059764; c=relaxed/simple;
	bh=935BkEE5lr0zTQrtS4U25NRhKMY58Nq4atDR1BxUcik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jtg6yTD9KfE2EiE1xdFmTrfOnvyPbqLJr2EdhTC4NRceT1OvzdA2iVwFL/rmbyQDcI6JtdOol0g1NYurcBwa2kD2VzyMQuMdnzkt6U6xfT5TUzZGXgFTkAPkzZ2nDWGCYb+kfShzUG/BbrB+n605Cjc5Ds0LETmqhIA9MeqoJ/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCfFrKen; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCfFrKen"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d9d929e27aso5791674a34.2
        for <patches@lists.linux.dev>; Wed, 01 Apr 2026 09:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1775059761; x=1775664561; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/7W6WBNC0sNqGoPP+a9+blf4M+1VWCeYjcBMnkhHmWk=;
        b=HCfFrKenkWsyfqvRttVrWQoT3U1Ek5WsAXzrZDlcAOU9DL+B6mGKbzG1sTsGbS/ZGs
         YzQVjW0md5iwW1PIQUHpHWiVpNsOt8h+ePrYAJeMjNmcakinsc4ZuWYZmPgpsqoYl5GD
         +T8WpXuhBt+QNhvJlqhgntLbVVOvT3LNYc3YQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775059761; x=1775664561;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/7W6WBNC0sNqGoPP+a9+blf4M+1VWCeYjcBMnkhHmWk=;
        b=ql6sAumvYgcYhQ3JDYYyxbZ1RrWPaxB2kdCG/uQPmllIWb9xY+wtWIXMUvb2tQKxDj
         fxuzjSlajdpwHmboKIfmd9ZMlEAqj0SzyjDpJtu3L7SvnlWmW9WzmTWf07nBvUzn9cYX
         vNLOsoEjwb5oCMNAuji8sGXS1Nq7fCZH0/ekaA1C76Ne4Nqk9r6tCmNlT7wta3I6riRi
         wFY5jbKO/w2IITR+ZiU/Pp+wbxowLzu/gUaPIC4qBXSsuUnr9V0WS286xW0JHZDfyJbm
         NU+Ss5kpZmWdp83EAamO1Jozd1TOPIcT3prfFooNn6ZiH5BM3nDosPMmcD1AmHNN/nZU
         owwQ==
X-Gm-Message-State: AOJu0YzGPJCaKcd44h003Ul0xmaJdC4IOkienV5J4N8Y1s9aSC0wrMAJ
	GIFbxQXkS6Eq4pbj1d2TpeaJVIYbd18dCYwNZkfpHn0IWyUSirdxQ/HTfHWniGDmBeQ=
X-Gm-Gg: ATEYQzzp1ud/kJ16uFV9NnCDpQ/4J5/JR1/4+6hVA4VMnf+GYNwknyGseJ5PW0BXBv2
	NWzFGfrfLBeRltFUsHUJzsQC7b+bPu7lJ75KVnQQXOcCI/mr706bZ8nQXYzULtJdPS5i7Gn2KJf
	hYCVQZFNMfAMFV6t0guLdG3Vzuabe3PDtgcA29mJZEj5wFg/cgmygAHu5LUD6vAj4CMy5G+k2eo
	BAzZh3w7tXqJ/rfnIk5tGzx1m9WhiTXovtB/ipY855KXX2XebOoaRsrt1T1YlfGoD2bqVBf1L+F
	0lOFezbDpe+Jfwbs4I5sJy+BVaoDTocb3dTb4Q+CpAp1m0Vl0gG7RUnGUTbIpPSP2GCFofxin81
	VpJHWFyIVpCXg7m2IHQ32ET0rI+5MsceorhL+jT0fTWXDoriXSWhsyYT8/LYSWacINq+VHJzapQ
	ikwGS1Rl1q99+8OhKd0Q63lN1/242NQRTtQzQ=
X-Received: by 2002:a05:6830:270b:b0:7d7:d524:bc88 with SMTP id 46e09a7af769-7dba7d3aafbmr110974a34.10.1775059761076;
        Wed, 01 Apr 2026 09:09:21 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dba73d8126sm138538a34.27.2026.04.01.09.09.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 09:09:20 -0700 (PDT)
Message-ID: <dcddcbb0-e4f1-4fbf-83c5-a0af92794238@linuxfoundation.org>
Date: Wed, 1 Apr 2026 10:09:18 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/342] 6.19.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/31/26 10:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.11 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
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
