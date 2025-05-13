Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F330239E6A
	for <patches@lists.linux.dev>; Tue, 13 May 2025 09:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130210; cv=none; b=XU0W0CRSTVRB8Ueyn4Y7NI0FAJFshd4xX9sBg4JiV/1PNMqS82R0DgMq8GEIs+wtH9qp6x8uDCQCqiesKGrkw+honK2UnZb813eo2IxH74himRzt34NylHuejB+MEUa+OCQU1GFGVJYa6/9e0Iasy4iiND8/JESpXywxyg/tEEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130210; c=relaxed/simple;
	bh=n5gTUq2A3cCjXQBJhBdlD3VabhPk0+yoS1TtRQ0hUB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nwJdB8Y5ul+sn4bbwNHetlTt0vHu0PQl/25vt8SoowJLVGdegu1RaaIe0OUGvSnDPTdLl0QK65S8UjUYInx9n2PAWk986ZZ9xsZnbGIFS85P79VCv47OFg2P7XFK9xU33WDgDcT4zRjhZnRegk3bWoEe4mMuJ92Uq40dsoSrxDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZxfraZ45; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZxfraZ45"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7415d28381dso4431722b3a.1
        for <patches@lists.linux.dev>; Tue, 13 May 2025 02:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747130208; x=1747735008; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pki/EgZscy894vyU92aEAzZPOJKRmJJ4M9eubywYQm4=;
        b=ZxfraZ45Vfb2V7AcUMRei8yYfHAN1i/ESt5a6+scJpUF9tCggCHBArQSwhxXOnOMIZ
         Reyh+QFghwue4NQs7nspSkf8nJ2jhuUZz2pdKrLRNLS8gCmDBWbtpN+eu0ze0IKf7paE
         EV2e46MioMScvsmlOIkpyZ214j6gju06oNQvD8QQCwL/6kcah2/M5FXhlgNmSqC3Qnmj
         3mJ7u0YiVPT1r/UAcpYxRI3ZeyCIiOcc6tb11KIt48fgcEcQdeEkG/wA+mrCQdrMvEbt
         UB7YdTF4VapqhZL0absBQw5YzY4endJsC4h6PJFBSGEFEgkC50tCc/21yvrm3JAhFeld
         jmiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747130208; x=1747735008;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pki/EgZscy894vyU92aEAzZPOJKRmJJ4M9eubywYQm4=;
        b=U/KgzOwNSX9434K5RIou/aG7av9QSlncCzC3IAwjSpucQ9u++Xk7WZqyp4PiujYcqC
         cgFN0blq+bpqvaZ1LIcLf/f/0ATRV7yz2I4Z0wLCk/1fiF8PUiJwYB9moczVR0Jkes4a
         ph8ip5sqtDxsNkMx/X8irPBIQXovTMNRa6hs8/esXyxb2HUh+Wx/iM8Hvhcs0gEnl1/i
         kvqFMVYRub4QJrk1JRTr/hLIWcKlrUAoZEgBfEbxVVf67RLe+U90bYPwE8rKWoi4J7Tw
         L8xTnguER04YgFu9PSVvqAEWtRQomKQbG9NQpuBlknb47kLkaerGhGQDbdVpWQsTUG8i
         KVtw==
X-Gm-Message-State: AOJu0YxBfwbvGK+01vmPoB4E4Phfn/Qm00Xw+Nclv2hl8fZ3c3bm+fRI
	+dqVVEiHykWXfhGkzQCzf6NyYrdCPbxIZap+K+gQp8Kanczlrdg4
X-Gm-Gg: ASbGncsSHjqDB0zEfMK05tS3U4XUHG6UaUZJNZUK+rwPQ7zeqPk8M0uOe7MMYP5x3Vl
	pyQKheBuY1NY56Bm2gNdEjsSkS8r+7DzCN/M41U6mLXH0ggGDUJACQTaGfgIAKe5/EzzysAu32h
	OxEcGDnoFYg+XTajjfAyv7uBd1/g68PrMX5h0knMPlNxdDoO9g5/Bp6ZSZHPRU/Z6No2vLCjPKf
	j364v8bxvbQGlb/R0dKTPN0Rh5YkGzNH9DFgocKe4x48i+EqjLoG06aJFCRykURDqk9F99tqboR
	kVrel5OM8o6OPLPlG+cwCeYaribxtsChkzw2MmvghemZLMiHi7plkcGxfe1ySNi6d/M6hUZhmQe
	rPg0oKErYIsPdkBCSI/4pPVTmClOK2mLsbBl7vA==
X-Google-Smtp-Source: AGHT+IEXzU0Vx/0rdbja9WuSBpVoF5PK9FD9hf3b/6LWdghcq63a3ypBuFlWSuRDrVVgU770i0qL+Q==
X-Received: by 2002:a05:6a00:9286:b0:736:5725:59b9 with SMTP id d2e1a72fcca58-7423bc1d5e9mr20468110b3a.2.1747130208537;
        Tue, 13 May 2025 02:56:48 -0700 (PDT)
Received: from [192.168.1.24] (90-47-60-187.ftth.fr.orangecustomers.net. [90.47.60.187])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237a1149asm7347062b3a.118.2025.05.13.02.56.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 02:56:47 -0700 (PDT)
Message-ID: <ecabdcb7-f91a-4ca9-93be-e2162f4d48b0@gmail.com>
Date: Tue, 13 May 2025 11:56:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250512172027.691520737@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/12/2025 7:44 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.91-rc1.gz
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

