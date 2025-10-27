Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511D03254B1
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 21:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761599411; cv=none; b=AQpQ8P1A+tSOvfni1V97ePw6KF+b/zIRYDNlwwxQ78/9G3K7iiqBC9jOIYTMF8nvqDs+l1dCAhmZr24Wji+ZVWZwPu4QzLghkz5niFNTVyEjOciFDnws/Pwtd8fNXqS7w7sRLXEsKy/Y4lotRR8Bt7T9DcreIk5IcCKq4N6WMEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761599411; c=relaxed/simple;
	bh=DWnX1zOzPhdonNNHjblxPaHF1bDlcTCehEAK+AuBlz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bYNgzjLeqzqxJMXWbrNasLxiAuk7c4ojXhZCjdYPB+SOEckXhV0LMl0nNfCvHQZDgT8HHIcU24DZyG8jf9TEluOjXh0HZpEkHfDwjWMCYgWvVfc7ZpyaaY4D75UJrgaj871EZbTO1K6bYQg1f/NbpctAZ9US1QQVHD8Yst2UlO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RbvmvQ1E; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RbvmvQ1E"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-292fd52d527so52055895ad.2
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 14:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761599409; x=1762204209; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2e588IPpQNnTE/fdefFVwu578KcqtJc5SaJtmTlNKd4=;
        b=RbvmvQ1Egal0XAnQm4WEylDhge7v2WSIb0tARudLQ+PLDMbDBBQKzM3F648NGsppQP
         2hAVqy2PMiMfuxWYmi5FabwQONmioPp8Ufo3MQVOLIFRK5VMnk1WtGFEmbRPKiGbyKOC
         8HMbCVfBuNVgg+kTnUtZ3duk+DVQhz6lSfSAH8PJMlXCmXFbyxXCM20r16WO6dVizw/P
         q92t0v+pBqtxn+RRgnVJ8IuwE2S4PqQclhVzCfiw9OfwvFIgp/JF516zkFm+AuwPhX6V
         Q5nxwd8DivtP5BEaaKRooSpKIEkxcvXH/7WuGtaVJnetXCNeFfrazwgbsPfpgLC90vGW
         GERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761599409; x=1762204209;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2e588IPpQNnTE/fdefFVwu578KcqtJc5SaJtmTlNKd4=;
        b=Nd+X3DEOw2+5LJFVfSkTwofXQDJ850uj/w+YwjMoPTMUZXoqtmYZphxIqR3GOEfnv1
         NjlUbur9RDvuNA81oT5wOktZHbSqg9j5Hg7s5cogzqsyWnQU2k/T9LlPYUmA4coEOuw/
         GEz92CP1zZ5mFIlYDWCekZ71DrZsnxPeIryzLjggQV5jPkAXYylM3VrKPPq79DkG2kBd
         G/U4mLEJ8PthiM6rhjxgAWNYUXXC7oQqC3yfz9wVr2jdfLNctb6PbJLHtTKc9jYNUvp2
         5pN42rxlhA+GMS04Mmtx4FKr/uKzbfNIKQcUf8ZIgqxeKeMH0YnNjbMeBshr8SSKSh7l
         gPLQ==
X-Gm-Message-State: AOJu0YzoZnsSq0lbgGyRl6Cndq64coIwjV7J7hSV/b02HGiY9/qSM0ZJ
	J+P5oHLoLmyXWwsQ3vDPrSQn+JYL75X4YcwZjJRwZ/fT/MuOszNSfqsB
X-Gm-Gg: ASbGncuj6dKuGxS6ylly3B6rhgId7Ocn5M2NnunAG+PqgMVyJAvEYchPbcwMqD4pVPq
	nV8keB8OKY9+rm4sTA2PD3AGNt8Cgbj0n/Y57OFVvi58zDrukzI6Iofe9mZ3i/2VIIetHmBYB7r
	X8T9DzgQ9BwJUcOeE7lYKCCGqUO2oghn80wn/7oouCVtI0uZ1EAi9RE62ksNCDYmUGSc/wKUVOF
	WKeqX+3D7sbtbRh05Wh7BKCN+7sQwInIkFFPy0KeuHLKbEMoXQPUEt2OR/pnvaQqytZPjtX7GQQ
	UYtBooRZLLULBazL36DlNEGpprLfrmVFI5HJtmkcCGQnVNnzPV19D9qC5ubxSzTNwqBk4nAxnzY
	e7S+UR/P142JU8wpnIsHRsy/UCaZ4WQyJRVtTG5Yt+1yJoKQ/R7HlL1f02Zu79dQtLlpWuKoHRU
	X6u/gjJF178ZIoY8+VOzAFpl06b+w=
X-Google-Smtp-Source: AGHT+IGAcXx8rnRjjfBbyvkfw7eeVqpM0QJvdpLkgNwEN8JNPyBVKydtR6Di4SIU3+wjvCHp1ZaLog==
X-Received: by 2002:a17:903:32cc:b0:290:c317:a34e with SMTP id d9443c01a7336-294cb3dba25mr11873225ad.25.1761599409461;
        Mon, 27 Oct 2025 14:10:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e9f9asm9559753a91.11.2025.10.27.14.10.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 14:10:08 -0700 (PDT)
Message-ID: <70c3a401-3fa4-47b4-b8ea-a8e5ca75dcc6@gmail.com>
Date: Mon, 27 Oct 2025 14:10:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/157] 6.1.158-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251027183501.227243846@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 11:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.158 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.158-rc1.gz
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
