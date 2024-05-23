Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0BC42067
	for <patches@lists.linux.dev>; Thu, 23 May 2024 18:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716490216; cv=none; b=JoeW/QkSuhoE1qV9EQVeSLeWhD+6nDNnDZqQHxP9+Wlga2WLJeiPFjVzMVP4jyNr8KM17ITUJAd3Zie20Wo/rCMG4ZsE5hVC4K9t5Zs8qkIdNIXklogHn9XTPzOThg8IKJwFZujGJtcwNGLh2FbvrePuD2XBPa0sPYfHNKA6Hr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716490216; c=relaxed/simple;
	bh=kyE+MwN/uIjHh3K6ejdqz58qWZ5WZfIAknWZx2NbxUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Aw5oDjCVqGZYBBWT2U/BDImY3QU3lJvsa6ymaSgSRhxZbeQqES3vcuo7RwXVVGSnlTP1L/9/q3DgxblovJcmy9XbDCFn4+Oc/7Y/andmutEUBG6SZIxnOIzWBukdqM8PM22YPkngucKqzDKaG5nteQ83RE8m4ZSj2yk/cASSotQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eFeEy4qd; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eFeEy4qd"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1ee5235f5c9so122955395ad.2
        for <patches@lists.linux.dev>; Thu, 23 May 2024 11:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716490214; x=1717095014; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T5jWOQ5e4KuXtG3+BV+nC19AzmmlYRZIw5wGYbugR1o=;
        b=eFeEy4qdW09FJCC2+bdHqrTiYDzSVK98jwgStiXFoqEIZ6XjDiRFxPed0WWzD3e8tj
         NdRghoz64I4DpeGDxwYfblp/0QTc5R2y8XiKZm/8xOtEUeibEEVmW1eOm8viigNi11jB
         gT9l8TZkQq1JRXTg2OdEgXKiLeSI33yniAiRBTDA1eigruql32ot4oZksIkH98r6y9JK
         v4UvaFkgmW8Xmi6R6AtZxsYyUAIcOt8bgJRQdGYWzfNYrfT7oXGhs/oFeflgWHaUp8wA
         YlJnVajlx4dVTbkSyzZMX7LCQ32R2GH7h8BANJy5f5MEdiuTCi63aunxXEcvYTXabOxp
         /YCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716490214; x=1717095014;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T5jWOQ5e4KuXtG3+BV+nC19AzmmlYRZIw5wGYbugR1o=;
        b=b+RJzLvxW2KX/MFWip7XQuN5RPKoru+G0czF5r0Mua1mS70yXpvRsNuLbnqExCxW2e
         DdnXcCJNY+WIlmMFLdp6WWrv1Zm7sY6w/p8AYfBc4Mem2HnvtrNWhghLy/B7zKnVQSIi
         Hx2pQcyLYbkgoHtffAuLCdjtoN02Mcg959wuZ3YKKvOab9A6WYIEF2HfsTM9hC2BR40B
         HNhu24VVbnr9l+1AcsjzwKYk1IlRIcSsnKiFKkrFVgKlzQNSxGQCgPD0d1G+yAuy4zNP
         JUguK8xB5tY83l7Ge7xs8c1DFgbpbIM/pcKFQxjoJUTbzjAAxToDSccB0KoPECflWzZ5
         CyXQ==
X-Gm-Message-State: AOJu0YzP8xjGpOuC8+VALeOIdekJ/rUw8ml49Tmi/VWCbhBOPd/3Oeia
	jsNrK3PI2dwD4+C3oG0bs44jAc19BAV3JURvy6Egg2Qq95GSdmFGk/koZm+6
X-Google-Smtp-Source: AGHT+IH8TfXPmp+k2+6BFrZp7D5q+d4zjU2H10O3j9gFv9PYr2beC6QHykVOAGJXFo/xesXdoPw53Q==
X-Received: by 2002:a17:902:f987:b0:1e6:7700:1698 with SMTP id d9443c01a7336-1f448c266e3mr1967485ad.35.1716490214038;
        Thu, 23 May 2024 11:50:14 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-1ef0bbde9d7sm266512825ad.106.2024.05.23.11.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 11:50:13 -0700 (PDT)
Message-ID: <19753311-98f5-40af-8e53-173e12e83503@gmail.com>
Date: Thu, 23 May 2024 11:50:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240523130327.956341021@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 06:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.160 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.160-rc1.gz
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

