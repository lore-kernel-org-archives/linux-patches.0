Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794608786;
	b=IuWl0pVpqOqUbJ9fBLi4z1D4KncoLJOXlKXAJd6rgNzD9m1uqwxfG/9G3EtAiQ6jRLo1
	 zE4bjLHg1/5BLrHqmlI7rXPjT5RMw7lMDoXiFzCwo1M6HvOrZqhlWPdC3L2SwXcnTdftt
	 lvfB7ryPSlVp/+TnOmYgvuEepgpsLWtvQhNFkRilcJhE75UZda4Lxe7cKcHx5MjasUeg3
	 KJn+g9E4qCIkaY0PTOBws3bJi/x9p9AGqRZSAhvAC0nSS5TcXXXShoc7HaXPFkaHwLAHs
	 KZDfBdC6RUVzKB4HcAhUz633HqfxwYbhO0tNrZKdm8FnVrj+wStOoU/QKFjBcJxLAeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794608786;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=qN6krYwEOOaADQfooIYZcB5GNu+bZMz584ofrhIVz5M=;
	b=QE5TDU9GbLzlQdZu+Pjm0tv8k9++7Q0HQ6uWAapoLLFatoRB6HIFN9kxLS3v01sRbBdT
	 3nk3bSpTZWQogGc8uVsX1P1XD+rxda2xsxJQsD5cV6vGq4uLKGmVvEugT2vF88NVvyZxb
	 O37Llp63OfzeqLKV/6p+MRL9eAF/B4+noDGHZ1hA/LUjNs25i1Ugl0M8qEDfqA8GzESPd
	 61Axr73OBV3DF7KOKomjTgH6Wqtn65GB9IyUSU/ivJ4ZLBaSxHHgV14H9qL5I4eB3xPiF
	 YrWkgvzFzeVgPMjkfqbF/1peE12d/hK64VSaFP1cHTkcu9C8VwdlhBBw9pu0VnsHwCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=PMKMSgQr;
	arc=none smtp.remote-ip=209.85.167.170
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8E0606A32E
	for <patches@lists.linux.dev>; Fri, 13 Nov 2026 22:26:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F8E0606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=PMKMSgQr
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-4e4a4d77e5bso2319427b6e.0
        for <patches@lists.linux.dev>; Fri, 13 Nov 2026 14:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1794608784; x=1795213584; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qN6krYwEOOaADQfooIYZcB5GNu+bZMz584ofrhIVz5M=;
        b=PMKMSgQrkGbNaP+z4wZuZcEsGgVpXnGQ4txxRGQUZbDQq2CrSfoQHu+GyXmzeLTxw3
         V2a9i3pRNQ6kbIi/XPKnlswac2LuD5IIZC2g24rIyvo55xCgtG2NryEI3aM2aGplAend
         NmSm6JQPqy1tGXkYL2BjCDpnSKt6lHWWnQP/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794608784; x=1795213584;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qN6krYwEOOaADQfooIYZcB5GNu+bZMz584ofrhIVz5M=;
        b=WOqRIQfHcR18spZ5LClAHuMU2TTH5WsL2kSfyNTzNETPaiek8YtnOi01Xy6hXbhvXF
         yfSZHr8DYQuFWj5+QoHC90yMUlqgCLOp+2WUiK2CBVTakKjxNSsGQpeqdGw3sqe0zkRi
         af5j89AHlcQkJ4Jr89R53YNitL52IHq/jjCF5lPikyZ29FivP1Q+DEn2rJB8TMsVTN5/
         kx4Ueb/Fe+frooigimd3z1tqUjlIaDRzkAXgP2Fc4ZqoxpX1NnJf6GTcX6SZXXUExnJL
         XhA7bMd1ZF8RziV1zUXYLwV2zsFWrEkSqsoxxmHvPQazcbp1E8PqO0ZoHm5s7W0bX9Bh
         YKeQ==
X-Gm-Message-State: APuU4Z95TQUpdMEiMMlJgOk7CwvrJt9FL/DUaORDfcmiBrIohLK8frTr
	tf01hPRa2rXk2Y4vn+eKuvA4LUzamS4tOwDS4MRmCOtXDZX1uLtMeRIViSsjCG0+FZY=
X-Gm-Gg: AYBFou39J8r8HNWcrFPqmwDThRjh6ufrwe77RxS9gdcWaOc2oT7Z2oeXXsc6OpoDuPt
	u9/JJn8yfYAqk6mSU3NcSDFFbgKDJv1Qa4YXm1Ek813ortYNjQE/o1dA0P3lUlCRmg538S+tlyz
	RXbo1vrl2bpdTD4XzonOAHMVX2sKAw8wZEFvxRgzcEaIuaKVTfRDshroN7Y6CaoJQEjpiyQYfeu
	Lt0ja+BAdFrTGenK3BW8ZUXnxhU9EJs5EDrseg5NGuMY+kfw5aM/tfyJQRhrC1hGFRtnBfHqJS+
	PidifHuKvY7icZojf/Fg9iD2QXQYFjlmdXxhVPUF9SYM3XJ3RvqvY0XYycRUEuhdP126voFGdVM
	ivbwQLfgctvqzuQRMOHc2OwxRFwMQodkQHR/Obywg/AiHJrNyjMfkdikDDhOQmUmXlfhvrmjkJ3
	1yGyvlOSUCf2bK39TXD09jUXusg+ixRE8iG6j8AnIbJmybvXMXZNskQGj5dlU3FFpoHDIFXC7+L
	c8mF2Nx1vrvtI/k+o6hZLzf3JuqooraVO6w6Nkj2m125FCyMQXFHAEVB1+Mb6nV5NkQe7/LWN8K
	kKQHUMF81UzjxezUj5X08wBNZToWmiMLN9x94gM=
X-Received: by 2002:a05:6808:1520:b0:4b2:8dbf:ffd with SMTP id 5614622812f47-56cd557713cmr4332703b6e.1.1794608784082;
        Fri, 13 Nov 2026 14:26:24 -0800 (PST)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-56e7024673csm3195795b6e.8.2026.11.13.14.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 14:26:23 -0800 (PST)
Message-ID: <695f8bdd-edda-44b7-8cee-e7557c963a1f@linuxfoundation.org>
Date: Fri, 13 Nov 2026 15:26:20 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 000/507] 7.3.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/26 08:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.5 release.
> There are 507 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
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
