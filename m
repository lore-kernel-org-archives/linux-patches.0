Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4392E31CA50
	for <patches@lists.linux.dev>; Tue, 17 Feb 2026 22:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771368052; cv=none; b=lt6d55Wrs+J2kzkD3VibFnXnMG1gKQDdURCvc051/gKosiq6EDyFjdd79DbLigCzybTQPHlJhVA+3n+ILZJqDIQAcXnXD3IiAOTgzc1iXlqGM+cOofQVv0epjlGvAJaig6LN3wz0PJaNGTwMbLI4oXVRo/C0gSG01tXRccLTBI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771368052; c=relaxed/simple;
	bh=QJRisljU1xo3s/9wNqzGNtrUMi8cnr65B5lpCzMBYZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yd78rzjC2ctCbHyXJcpa814Eq7UXiFO3WhsPah+8oAkZ81Mr1lHZjqNDkRov/HJI8pge2WnL5wa2nXUKla+sG+unvGm2UtHRGD8qvOIRxFhl14MvVXNAhoMvb1fFM4pB81QgrB7CvuooCVSMoXgPdwTFMIdoBikGs8NaNsNV3n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mub+c+sA; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mub+c+sA"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8cb39647a70so481196685a.0
        for <patches@lists.linux.dev>; Tue, 17 Feb 2026 14:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771368049; x=1771972849; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a/YWTcywYNe1Bv9Jxo+L991NobexAOv9vtfpRL/8Vik=;
        b=mub+c+sAKZsNjDijzrn0VY7oT/LR57yNTjrsDVTRZb8KhGC3W6J560bF6z3g8O0GNv
         Z1meZy6v/3kXGDu7/psFBTYHsHks27GgJoN8Dhy4Gb2Jo2rIKSp5i5wfjlINalzcGrXN
         TmAd+1hnljWEwHLUn48AMkm2D+L/JTJ2zjc3eIFGIcWRPZbXA/4Ebq+8HymWR9QpCt4P
         Gzs4fcvuJVA6yP+oVcDRTX4PeegGHXRHkQX+sZ7FCfgL+4Wj7s3n7u9bmjUHQdjn7yGY
         oH+0A2TFkg2tbP5+rYex5TetFmjFP5ub+DdeYqLk3hmAGxnYc/LtCGdhvwJO/bzrMPPz
         SPWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771368049; x=1771972849;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a/YWTcywYNe1Bv9Jxo+L991NobexAOv9vtfpRL/8Vik=;
        b=lPUB4Oem/l7xPP7Aa/d8L84QJ8J/6nzI1N5t8JLcRt0Jz99EJiF+JmJzgmIPns2xn0
         Qn8cD866zDfqGBwKUyRIF06fJppbLos2R/HzA1N8Pdd0uX/atsJzRdwEJWLDtcCvqyHy
         HubmZEE8OldtNwCkNmEqA4RCxWtEpHYqxzA8woGQxRwAXap54uHOGC8sBFc1882QfrP7
         pwJRC1ksXKlNyHMXQs5twpor0bTZ4wgXUfGUaq/+Irhqiby4wICiy1WoTK0UPGMh4C1B
         Qn6aFeqiaCxOUmUlX1lE972M/U6S30mJRDXPsORdNZHf8EJIGzN9d79rx1OjuqnxzrJf
         o47Q==
X-Gm-Message-State: AOJu0YwsaAe+Prz6hkjneF6oNHpLiv+rBG4wYOeIoMugLUiYy+YTFj0y
	TBPDN3jZLVaPGr/g+hIuoqgZGl4vlYGTqbFa0LoQUXqek7KQnt/NNTrF
X-Gm-Gg: AZuq6aKuf1DCNPifmJznFpBers/jdYYY9ma1DBHlRrE/J/aEpIGUJw0CNgzlZruk4xn
	EojzdKY9lSnBnVF7/RaduYUR8wkw0oxzOlRNNrqRoTo8JUmSw9QKXvP3JlbkY8SXPADw9K3za1M
	90rJkUvf3TyNX5yZ25RKvcPex83CChdIr9rdjtGVNn4uFrNJxFtZJbxNGM+ZuekyY5gsGqARwQw
	kKIQP7M+eUXwkgF3lCPOWtdTYNhC5DL3ubNkqdEzLZiDjrsBGAJXHqdzKxo9xscmT1sAc6QxsCB
	AfFw/G3zLPwsLIsEEKzSH0l8YVI/++NtjrtDZabPLbU6gIOQgn/+zrlqcRsFYIny7AZzV8nAkdR
	WwYvdtJjQLBxfdDCfItICXxfj4IG7Heqk77r2sLCSGaI35IdfcrBjaPb34MNEnwm/CNzXtIDnrU
	9e5e+8J6jJMOv9ukQWzdcN6A75pVRkSdeA2RWtgzNgXNoHYoAndA==
X-Received: by 2002:a05:620a:29c6:b0:8c7:1156:efdc with SMTP id af79cd13be357-8cb4bfa70f7mr1452762685a.25.1771368048856;
        Tue, 17 Feb 2026 14:40:48 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb2b004eecsm1623918585a.0.2026.02.17.14.40.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 14:40:47 -0800 (PST)
Message-ID: <70d4fb96-0d71-4912-a8d2-64848e683c24@gmail.com>
Date: Tue, 17 Feb 2026 14:40:44 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/39] 6.6.127-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260217200004.221651386@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/17/26 12:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.127 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.127-rc1.gz
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
