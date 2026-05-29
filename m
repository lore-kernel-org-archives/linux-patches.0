Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D1540C5CF
	for <patches@lists.linux.dev>; Fri, 29 May 2026 19:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780081854; cv=none; b=gw0EGVSD6ipkiMaHC7X0UBJbLyUSZoHifYiTeZrivrB6JOBhy1T70vX8KvuRKnCUKanrwqOS1dwrAZgZcVIsMdLlsJEA5JNcvZ5eohipXnxssRf1E8x1MZfxPlTu13HD/wL4fR8Brf4kzrGYMA1gD2ej6Ezo90vL8h3qZAM5L0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780081854; c=relaxed/simple;
	bh=bUqLiUwLNRopnD0xzDZ41C0p/bad3TA53AJ1s780NGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QiAjmWBdq83Z/61zQT4lXkt0S8b0D3Hra9a5+D6lV8sXyiziF5O2f7aQPRZWwbi/MS9YqSV/r9TMpMbXHI/AtijLWRNj6HUir563g651II3PVRInXihq/SDHqRniP3jE0FVbcDoW5faX7n8Lw2pe8V/k3CghxL/zhXWlc6KFQVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jgbmmtPr; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jgbmmtPr"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-132d1b2519eso11186497c88.0
        for <patches@lists.linux.dev>; Fri, 29 May 2026 12:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780081852; x=1780686652; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5xPyKg7zaP0pBO+1bpwdD/4KkNA7AX3vtVBNKv+C98Y=;
        b=jgbmmtPrD+feA0heJuQSlkL2jMTHrn5OuVDs7d2MCle8lYpE5NTDiFD4Se76qPdsm8
         sNDt5wjmQp+tuaG7xnabHXOZtpQeVwuTyK5smiB5zt9TE64pN+0wNFpW9TK6yX6a3kda
         N5BdiZOpAescnJudJq0tFmr4F8wrREy8607363MylQcO5nIxWNmHo8P5lXKd9k9APOww
         +aemZO1QaY7AoVLtQ7lD7nAkU0jhNqkEpwkV1/mJi0RRTOcUGEWwRb1CRz6w9Q+lT/4u
         LuHAqGeY7PgplK3YK/QNYsz2KXWjzHiuHbWHTFKm/bta/n+DFOYaH0CXyQUZauOa+Xto
         nL0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780081852; x=1780686652;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5xPyKg7zaP0pBO+1bpwdD/4KkNA7AX3vtVBNKv+C98Y=;
        b=rFepx9IFstkze0l3UKg0dHM37PXO57ZZFAbD8td32a73ehGq5HDpLcFkM7AvPpqxpw
         UXs6VgVIrShfTYdnLQV8EbKeJJns9N3xbmc7p7W50llMV8sJjZwDx+bCtBAHi80B53xO
         68Yp9PY+ztq99NwYQ9yqpdI95U7mbJ9Z7IdpmpToUWWFCcZXqxj1y6Zj0eaqx0q9fXFF
         aAOqU4Cxmsd3+Hxyw2wGF4gN1qMTPNiiJ444OkQLyDtdLCS/0RAicyTmH4rAC2rxMXu5
         Te97o6tliVkTQQfVHH2bqDWdn9Q/wR/8vSDOtwCaniNy4pBN8daaAo8tjWOEALBZlGbE
         v9KA==
X-Gm-Message-State: AOJu0YzGxGaHdTWbz4eUKmAkd3YwXE8k5UycOn0QuIWilXno/eCuqRQO
	5ZxCRbsMDRKAeZ9axu64i2gI5+FxeW3FyzAzWMtm7YBSydyxRwxTDxm4
X-Gm-Gg: Acq92OGnAnIAUakfc6pG6LlTLpI/gU3RZZXXVxMqbfcKQPj7a7NNm/ICAkfo3TNE2tP
	M4V1CKdTxYLwuCJqPfTykH7PfFG6RApCcikqnmN0Djqz6XmmZS5YMgz3ohH3ys2VUyq+5jJbuC5
	vCO47MWJC6Wm1k+RFNpGiErcrpdThfKKGgLqIDNvpVkTLwpc7ghVWmb8mC4NzhYcQis6QIrI54g
	BE0EpgUZo/uk+wGP8RE0vhMYZYfxrbaZM2Cjk9orqOmckhpl4n8nQjVt0ta+aG33mpQ6YMUcyxy
	/JH3ZdswlgdvGyQ7juPbsrH0k3268MsejfauihtTg+Kw8JRvtytr7Pty5P76c1N+YQC2fKnkImW
	K3aWTCJx7O+UOWXpr9sCIDmFZLX3uUkQqe4NNfp7sHdSTBJEApOppzmO9+e7Ke1/0vylF/jxeYW
	pO09ScgwvtMurBnCqQ8TkfGC2fzsxG9y4CERFLqdXRH7PZVp7QtjalZw4GZ7Vl
X-Received: by 2002:a05:7301:1293:b0:304:d14b:b706 with SMTP id 5a478bee46e88-304fa751469mr465104eec.27.1780081851952;
        Fri, 29 May 2026 12:10:51 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304ed53f002sm2208243eec.18.2026.05.29.12.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 12:10:50 -0700 (PDT)
Message-ID: <33ef286c-5e24-4dbd-96ba-c95b00c3b2dc@gmail.com>
Date: Fri, 29 May 2026 12:10:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/186] 6.6.142-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260528194928.941004471@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/26 12:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.142 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 30 May 2026 19:48:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.142-rc1.gz
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
