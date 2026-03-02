Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCA230DD22
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 18:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772476550; cv=none; b=LvPjYKHMsGVriJOgJ/OR8FeP6zKk1Sa17FcLOUsDK65htTJvr6IQz/QFc8KeaE5hTBtV+YBPzfKX3chk2+FEQ0ClrSYzMBRbYZwK7pnPC/G2EsKsvukzeBu6GeGLRho5FHhr0FgYsub402gCO4ha8e3AG+NIqv9lRm0MSTKAIhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772476550; c=relaxed/simple;
	bh=2GOT22Az5eN2ZgabxgUYSIFjxuWVaCdnROj8IMw8bGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UHWH0VjvpVhqSzjYzcZ3FafsN3ffAjmiYGyOuNmEzj3aEtfRF9VugtyrKQCZhVXiZJe+EN8GVMJL6Em90T/e2satiQgYct/NkDPIyIm2g2iRF7MQ3tkiKFv3h9Hgc82DL7I72rDO28syWuGClWqUN0iQwUGQSGxQwHkk/LCxbQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cN9DKkmw; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cN9DKkmw"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5062fc5d86aso44221941cf.1
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 10:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772476548; x=1773081348; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=quSkEi1mQq0UcBslufuyU8hzVY2CrrAMv3rCqHOKUos=;
        b=cN9DKkmwAdK4hV5rSeZ6f8OplgEqVV/M3wv0aC7tL++0QiptPaPOA7mqy/ulRIIM5r
         8V7IkcEsAy0LhvKZqAs+8OFZCiOB0+mRYVTVRlRf33Rof/drGhHAReVUNW1rHTjx0BtQ
         WLw51P6G/z202JkpO0LO6BleEIQJWm4L9rY07ahLMZ0qU57xdwqLjwbaq0tZ8Z2laubX
         08DWJGVFzjC5kd93Ei+VZ5sFVCMi3a9sJgFwmliie127cFHXOG5YjKcCRqt4xsYv3aH6
         TX6WbOI5HHknUtBb4uxDkJvWsKX/jYXyw0TPZXCPa6N+WKoJLmzclp7EH8aEyNhAmCxS
         0ATg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772476548; x=1773081348;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=quSkEi1mQq0UcBslufuyU8hzVY2CrrAMv3rCqHOKUos=;
        b=CXQF/69171zc/kUzBLAFl1Ln4UqjX3SZ0Z/n4ulxcrilxqhGujUh2jpYTX7tkn5qnp
         dq5gOdV0n229j6/JR/72w/AqwszBzpyj8Redu0CuvrIQRdNc1OZYfZ2ESgUou296IhNt
         JJplxhkLeY61nufcSK0DiT2Tu2Qjnzx7FzmC41IWSbSzjGUiFJy8NZJxdwR0IfpyOnIv
         VehAsVCK7uOxrD6p/tHb26pwoLKWaI1hfi0Vu1TNLjtQA8Jno/MnUVwuRWXU9zF0FqwR
         4emi8yowuumF+hi8+rJjx5itN+UnERx3MFRXf7q3UCA8/DimF7wmJhKRxyf0tQ63jPLE
         9hrg==
X-Forwarded-Encrypted: i=1; AJvYcCVEs/xcK9eDGVGLTh3ugYIvL4tMTzAQb3n7J0HurnrbTZVt0Ae7remr+1oUZ+E54GUmHHIGJJdc@lists.linux.dev
X-Gm-Message-State: AOJu0Ywnz2gVtozOyjg1fs4h5eBFRRF74W6XR4/qjdogOutZAA1/1i41
	N/EIcjSEN2NIOx59CX2NjldkqfxbLCmZQxH0SrzJXTJlref86cEYaaq9
X-Gm-Gg: ATEYQzwDl5Y5QuvP+oU5xF8e9uo2QLiwUUnOnvKETzPdPj521C4Tvfbyam3QJUG7vaa
	7g76dR4lsCRddxdrpYFuPL6UaPuevPSzb/EwUn/R9a1anC5FhKhdrr/b3+sGaCsoSmShllOjWk4
	7A7Ve5sijBpOT7jd0LXYWno8aBJRbm9ooBONBgzniAP74eFjrwUdsOioSvcuHM+V3t141iPzpxX
	fFhw75Ud5tmwIGug0rRpbNA1VRwlnkudzAaMmsuV2MXRELEIqQm2YcHIKAoIsUUDHRiHQoSb13C
	palfEycy2UZyExnjWJ9PFmTwhVNCpqPxvty6lbhpijzS4Tl1oIa9Y8O7XntM6s2D0T9AcdmFu/7
	Qf93DO+X82OqukB1PO8XJv45gYp3RLtt0nrHe7TTce1IohSwtFqZfO3fuoohV/kzds0u/QzCRrv
	TeHrRB7UMeI3YOVjXhQvGdhM1sbUj7W3j0Z8nAoKC5/OMxMr0Qhg==
X-Received: by 2002:a05:622a:1988:b0:4ee:197a:e809 with SMTP id d75a77b69052e-50752886490mr160353761cf.75.1772476547995;
        Mon, 02 Mar 2026 10:35:47 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899eab5cf2asm51032266d6.13.2026.03.02.10.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 10:35:46 -0800 (PST)
Message-ID: <1bdea3bc-1028-497a-b422-c14c3de6f129@gmail.com>
Date: Mon, 2 Mar 2026 10:35:42 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/334] 5.10.252-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260302161007.2523181-1-sashal@kernel.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260302161007.2523181-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/2/26 08:10, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.10.252 release.
> There are 334 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:10:05 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.251
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 
> -------------

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
