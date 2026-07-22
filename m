Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01E13793D2
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 18:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746397; cv=none; b=JYTWt+v81zYnw0VbmR/RtaP6iaZZe4f4DvQ6K0j1hbp/Y48jc8E6O1DOBa+nJ0b6gUtPgFgdHUj71dRrRztm0hVjNskcpkizbllyIUmuBiLk1p+fBU9FUmDjy+0M0Xr2hUesHhChzq39FmrjKjPsM8UlpQ5v+9c1QwOwPab40Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746397; c=relaxed/simple;
	bh=xHX2A4sv2rM+2brXiOgKVJbKrjsMa9e/4o1mUzXCf0A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PX0FTb48Bvm/B4dvtB62Z7dx6/DcCfLHOiqXZPBlAVc3JqjhawdLl9a2l9c+d6lE4d7LsyujUUEt9C7XqicEzoolM95hQ+oiBFN3pBMqnxEYxAe0UYMyr2cMToMw9USDxprHjwIACKn8ZbjkWpl0BfMTo+bOXpq+YMhrMT/hB50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nZL8TRIC; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nZL8TRIC"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84e27035206so456448b3a.3
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 11:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784746391; x=1785351191; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ya7nSRZ8mtp6nOk3koQyFUTx87xQOXf2E7S2pN7kN8A=;
        b=nZL8TRICzFrZuDkvTwj6gwTbi4PDl6yyGWnWPx29j4/yptXyKajsCQ0tpys03y44Cq
         Ds1nEIWUecM9zvZ+AArgS5M1uHdJGCYFWMeo3uxs1oHXB5ilLpBj2RDR6Ey6cCiK8ds7
         am6UjeFQqjtLSTbXLaL2jqzBjKWJVIXVJ6tpjd9EWVq8WvCDAF8nGE2M6d+HGX4yLuVH
         d1OhCqcUVljKj23lyAKRX1PapAKWZSxYv+5tIQdF0fQRLWIPVFkIvQijNEsdJPCHE0O8
         gzbPLAOG2t80Pz4bpgnV0sprjnUxMvV6JECNo8P3/gX8Ni51TWvnDmwTB80J8pH9lEEQ
         k3zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746391; x=1785351191;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ya7nSRZ8mtp6nOk3koQyFUTx87xQOXf2E7S2pN7kN8A=;
        b=JH+0//EvL/ebo7S8/6x3cpV4dQ6cBCgTHMq6gXxPwFlTTUY5xJcMkpKCvQuUCm7z2s
         EIvaRyxZooRh3uo1JKUoEM/QvkV4T281bYZdHnSHzr9j+FqaSWquFmZd76lJfFh66v7H
         SFcpoF0UM1dIL969PqKs7Ny2y3J+nsUXRmgZqm7rt7RW9Cp+T8W6kNz8hScRe46sXrY2
         1lEQTyJSTC0tMQOqmGuQctmbLQf2Kan+qglZAI+L5ZzRpgOpOaFDeO2gA/dUK/HI3m7V
         b+Mj9d4hdy/0fnLB/+VeCFTaYu9S3RWT2JjEgbf1rbDWOtulSxwj+KayCUzHe6pt9bcg
         c6uA==
X-Gm-Message-State: AOJu0YxkMmM7WViTuE4WwF8Jmu98yjACAjFUrLKG4SHSNXhVFutbIwT7
	B436dmv3J6raAgHbLh1QufCUGx/oTVNjaULSNWabIIl/ReosjUAyPKNiC4FxvA==
X-Gm-Gg: AR+sD10ECq6n5ulHqsB44nd9LnWZlzTEnrv7pwy5DdDelMDOBoWXOxleF1M+/sLetqT
	EwUtzgOr5CIl85yS83Vzk8MCvpimexNErFBuAbmXqprjkcTfr1Vyo3FrGqeIcKPAPoNeaYvbPjw
	yXmxlTq9ogVBwdUBsS0SFNlMTdMqwUOleAGiN18emvcS8I+K7TeqN/xp6RoZ5j3SOpZEvC0b3zK
	KS0FXztHODl8JbET5uLiFiqKlgZ80JGvEkUdKZpNnTg2R92oTxykrCxKRUKM55nPn70U5KiOPjP
	s+/mDVqVOS6udcOi6cij/Se3Ivw5OEIfZP9DRvbxCbPN3zeyVUT79qaRSzZFe431uUwsQV6NzuO
	S9Vhbe4NcM6gA4i7F+ZcfRt63R52MBUlyNqpp1PgXGfi5eYIWRfVvB5XzRqAdO0s2uVTe30fpBm
	VP+hDuFNP82yAeyuFuFcvnQoctj20pb7ctzgoB6N8=
X-Received: by 2002:a05:6300:2289:b0:3c3:a546:12a2 with SMTP id adf61e73a8af0-3c3ad975d93mr25752726637.52.1784746391374;
        Wed, 22 Jul 2026 11:53:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147dc8b0cdsm11500673eec.11.2026.07.22.11.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 11:53:10 -0700 (PDT)
Message-ID: <32ba501f-d37a-4868-bae3-e0c402c35fd6@gmail.com>
Date: Wed, 22 Jul 2026 11:53:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0000/1624] 6.18.40-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260722142910.893804136@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260722142910.893804136@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/26 07:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.40 release.
> There are 1624 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.40-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
