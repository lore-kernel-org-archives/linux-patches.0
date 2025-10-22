Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF47F15CD7E
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 02:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761101264; cv=none; b=ho6TNlAG8+5l2Wp6F+iZF5vO/VI2vUC1muT+WQFshcxAB7HujXOzOKRBiDDeelpFJ3wzptAIH9jNDs+q5rqxEAox5BqJ+sHGIRyBTy5zmcjzrGL25S9Z6VHLDOtFWdTo1FKuTMxqyXrcuw/uONgzDzNI3t/FLqqEt6s6g26toX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761101264; c=relaxed/simple;
	bh=8wXGKm6DUxI/W19y08JL6KjPHN5Amq0Rx+ianN8ybZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NHNL0l7QiaxD37GZFJMVHmQRUqSAXlCRPFxPTXVnI99kEeLnPy7evWiQYXqpmhDwbCpA6SkjZgzVGYwMqreujeY5g81b47+Nf8w+y/ovtT8T9Zxo9i/nPUmvagRltzUfkUgVVNdD/sczeA/ltOFOZ2zxV32m4IeJ15iHfqg1MZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AHt3kzrN; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AHt3kzrN"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3304dd2f119so4971276a91.2
        for <patches@lists.linux.dev>; Tue, 21 Oct 2025 19:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761101262; x=1761706062; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Is5hZBe95ARo9o9vNbLjG6y2uIXewO4LIaE8nuciUpw=;
        b=AHt3kzrNGD4+AjLttJHopn/YJ6PNUMqnWMnVuw8gBoIWGPnLrYI/zy6UVAIPqCVPON
         Y3kJ73gRY1I58AGzm6UPH4+x9iAyynCaLYD8cguSh3nf0rocJ0yvXFC5b2DpKt2y7f8s
         pN2E1qMpwdU22kIqvgZv17E4bwufqoNtuPMGka/xSvpi1NJFIfYXyMn0jdom0yXMaP1P
         awBAZxzdVZeMa6FWPIhtxm5iftB6H0SwkeInNvo2zodAa94xyTI+ENgAKxuLMIeY12gx
         W+N5Q6vrj9btd457R0mt3SuJWDeYCkuWI/UnAtL9tT6miHRq28Iw2n6+U0QgkXIy37S1
         swiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761101262; x=1761706062;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Is5hZBe95ARo9o9vNbLjG6y2uIXewO4LIaE8nuciUpw=;
        b=M3AkQXAZMRsEUh1UuzHtfKvyVRnUWyCg9ZfMyrpcE9CseOREBGYNUhxOSNwflvqQ08
         udWgcI8+WwiZ+AL3v8QrV9kck+12AZN+WDntd2ktzDbuBwTRfW3VtY2vDN5Xz2LGlVIN
         Auc3ymAKw47dP4gN7ge/k301mwPcEHjgkLOL/wVbph8c7+ncr2Kbsui1QfEqZmIrNSTi
         4SuHa7yKN90ZEVIGs9xs4UF0yJ/ULsYIOGPw2QnyvKb2QaYyLbm1yhVK5tmhhNG+bN5N
         XnBOJEv8n5f2qTC9iAvy5lrhBH0k4q9GmWt1K0u6GhO0g98ZiOkmnx7NJlDfbTtUJxDf
         Dmjg==
X-Gm-Message-State: AOJu0YxcaBQQ7wi2U8tHWTDfMuxOCbo7Jj+0bjLS17vXvWD9zCT8KbNq
	zFW/x2fMzq6DE+YBGkG6EwrFFXZ3ve5e4Z6u0ixfAd86/Rd4qnP7PM39
X-Gm-Gg: ASbGncuLoHieKC63YdSswKcynLQQ5IdvL9Do9hu3KbWF3l8VexeJBpO6nB6iGVXF0gC
	bNDkGQnJLXX51Eu8OHQgs60L9tn2Q6+qPA4Q0L3Pgimn8OR2IIe9rAabOmpPexTtLr2l9mB16Qt
	+VVx6Evvf2clti2QwWw5XB+F5omWLK8RBBKXUDZb37z8qN60+e3W6/CvDlvT+fnGcL2IWPzZu+i
	DVaYVOj2aI8978CzazwPqV4qWSWdeT8Q5dhr1gCmxlHx2OVFqI7s0FBuFvpmSA38/qbtRBjd5HH
	jTf9xf9m3P7WsAxkiH/T7pI2R/evLv3+iF8KHxuUdakG8uQXJLGi9QjItIjuPK1CpiduRlLHz6Z
	PQuWLZI4n1Fhc2gk8hRNiZblIJlmQXp6w10aRzu6izzeR2POa5i/885FpbGszHOWsoCPSBg5exq
	Wu3IW2ieEUz4toI8fTS/nDYHMbzK8tTbyQcMz2FA4VlsF6SzxpXaqY
X-Google-Smtp-Source: AGHT+IFavwVqCCJX51O/QL9n0GDxtahmjbc0ecv27WqJFcgjvOksegxUDTtOpcgnKqBiINrdJt0TZw==
X-Received: by 2002:a17:90b:1d0e:b0:330:7a11:f111 with SMTP id 98e67ed59e1d1-33bcf9222e2mr28788633a91.35.1761101262106;
        Tue, 21 Oct 2025 19:47:42 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33e223c7e19sm991944a91.3.2025.10.21.19.47.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 19:47:41 -0700 (PDT)
Message-ID: <c6090593-cead-4a3e-8380-615cd055f2b0@gmail.com>
Date: Tue, 21 Oct 2025 19:47:40 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/136] 6.12.55-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251021195035.953989698@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/21/2025 12:49 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.55 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Oct 2025 19:49:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.55-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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

