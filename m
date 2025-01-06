Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84823597B
	for <patches@lists.linux.dev>; Mon,  6 Jan 2025 18:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736189927; cv=none; b=EVR/XXbk6Td7r3CmXOGyymHeaAroqg7c9ouW+/CC0fRgr0mcPwrdyQoLSLbidfdIgZSwhAPW7Lo3J0xT6CG6aefjgAiNWM8V1FTfpmWvQeSFwB9CC8768vgjokOdzy8GlerglLpNv/RP92oCloQjbtIBnfDvCPBJLu8clKQxI68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736189927; c=relaxed/simple;
	bh=xDhhnqK0fO25WJKHfypvNfKT3ED7OAAq77nfThEGZHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tn5J/KNxSUB7eIh5UC/BiL9RIMgbk8apfJFU46ncwXYC0/fN2KGD7atqcaUARpVtAx8b/W8N3JJ261PqOt53QgAyEv59rRiC9dnLQg2jOz23rEs7//eXJt6K9TSYJfgQkJuNa6lxYZc5jWVn3nhagT0+2FhiBoGsr7i10NQvVkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VDv0+XGg; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VDv0+XGg"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2f43da61ba9so17226048a91.2
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 10:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736189925; x=1736794725; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ieL3bDpo2mTMT/caEa+eoPiSZz7Ur1JFNT8c5S8RrMA=;
        b=VDv0+XGg7p6Jep4aUC0UdW8fegtLXtvO1dfkuvNOEoeZXD7S7Z8DLC5eEIdjYUTRkC
         0w5my0ZqF37mLxP/zSi4141xCDh2Z1lwGayh+DtTcoG3GLBGh5o7xo+/sV7AyfddUv+u
         sjx0USeUFd4wJlCj6aq5oQDAXujwtquTwn1ltT8BIOEk5dfkiys01UXMH/26UEejVDc0
         xspo2MWvDQRSp53UqBoVP1PTJmALTuPLvyLaxAF8m7u0XZtEDrp1/zuzGFnfnB2jBW8A
         lNcINxFb2Dx7r1JpyfNKK54TEVZ9mG2kg/djFckwlKoWr8yl+abY3HdbXS0NbRXph75S
         6EnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736189925; x=1736794725;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ieL3bDpo2mTMT/caEa+eoPiSZz7Ur1JFNT8c5S8RrMA=;
        b=JMK0U8Itdc7ufBAe97pIDPTUU9N6xZrg7Yibt8Ag9Yaf6jfAFDIGiPPV3BmK7z6CG0
         I7hm8MQ8WY9Aua4yqPCbfJnA0obey0cx27t0TQaRtiDvnWDdJjv8FCO3m9jGSBU9dLdk
         y8j7kJXtvPjzV80WGzzyzrClR3t2mZ9gYjDsG88D/p5Bvs1RTUN/OhFqQHWHIlZQRrZi
         Ov2Oob3F/QGpESw4IriJrsCC8ug04b7hTDfy0ui9oJFeCfF8MaAmDTLHsMW7EOex11uL
         gs9fg61k9vLtxQw5O0ERmCcHj8QaEY7T5cWTto2GCd2ya9ICZ8BgS4XLFQ8wb+TMYK+c
         rttw==
X-Gm-Message-State: AOJu0YwzgsGy8s2JFZfr+WBjG99+BmzOYuv5BAKCiHwT69BFaJA5AK0Q
	8BoXsJ7u7Hz2J4ZWvJdWD9OfgySLEqz7AivEPjqAVXTwwGipQLW9
X-Gm-Gg: ASbGnctK0Kv8f3oR6WTc0VxI5dE3YwWHNuhU1fBSP+QAy4RG1Qyfm/ln2I62bQxTXwu
	jCulJqz6F4D5At4qLigTXG0v7aZRzP/resSzeesjlGITP3g4S8L7vXs/6b/wuH/7TfAMrcCovNK
	aMiNP4LlnzuvBRfxHEltVTckwEPTd7Ne6oG938eDfnnyVjyhR8vSJJWxe1BuQtzUikOfMSNbSPo
	MTRPSFvlWOkOzgz6NSeiblsWcWS48ZzmCJ1iP+5ZnZT/1KAgOy7QJaMKAQWYqgKUYiPNr9fn8fs
	Rx/lpbIw
X-Google-Smtp-Source: AGHT+IHQaNSOO9eP/UWTVnnd/mFtg29iE7A5RcbZHb2hbaLyRfELBPX7ExgRit9uzlaF9N6HDttEzw==
X-Received: by 2002:a17:90b:544b:b0:2ee:c9d8:d01a with SMTP id 98e67ed59e1d1-2f452e1e54fmr84478794a91.11.1736189925014;
        Mon, 06 Jan 2025 10:58:45 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc96eb40sm296404185ad.86.2025.01.06.10.58.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 10:58:43 -0800 (PST)
Message-ID: <e630e160-197c-49f3-ba18-5af1e6a82bd9@gmail.com>
Date: Mon, 6 Jan 2025 10:58:41 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/93] 5.4.289-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250106151128.686130933@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 07:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.289 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.289-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
