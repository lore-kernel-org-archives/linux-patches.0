Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B7E3AA4FF
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 17:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773421356; cv=none; b=RmdSQgpwOOpUNAOZu/ig7fYFF+MxnTagf6tGDjKGy33/wJ479XzLHYeLWNd/jDz40o06NN4vkiYn8UgCDFUkbx+26ER21UpWM3eARaXQ2ZguBSx0+skatEGRxlIKOXCysShBPhm2K+IZgKE0WQf4jf8uBs2vvk0bQaxUfC7XkAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773421356; c=relaxed/simple;
	bh=w5AlOwFdnlULwQcESRQdoCOJWsSJRnMvGEX4ADD7jng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z24AIrEXKO0QBwJHuSX4cbgrKKgtizGrStb1bpasOwBUzm14aaAFD/6Qs47Ik7UNRB3sj2zoECMh7mNxjD4Md09k3+dYcfcYRu1LOGKwRUnl6ZxX5/NVzp+zLCQBhkA7tFpEoR/YdW9yf62hvIwvY5RnodWFHDvs83O8CL2fnsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I8axHFZn; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I8axHFZn"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2bea8a1c040so915857eec.0
        for <patches@lists.linux.dev>; Fri, 13 Mar 2026 10:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773421353; x=1774026153; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y9a17dPzIDqIL4X7UEpxgCYfEwk+WmJdSdSzwqIhoGE=;
        b=I8axHFZntJNFjCCrh62IzOdHusmznW6GsUEXloV+wWWpOoudXXaDuOREwnTOdsdjMB
         sZTmIKqvP3Gd8h4hOJ6gPTASp3NGdNjABu2t5J/XvbiEjxA5Y/Yx/sPJtt5idBp3UZv3
         wOPY7N2QpkuLTSozLX4B9EDv/q8dVb/WJu1CH4jw9PxwT1HnEBATyHow0ou91eYau81m
         ycQSyKwzyq9o2WBo+To670mj8ULY5sDkXooOF+v8pSnXQVre3UZC9InBebH5fG+MoBxS
         yMLTbVU0K5r/OG1Wi4fObz22EkKx5Qf9OP1IqUm5X2z5y13PL7Z/pR/kjXNR3VqF3Ej6
         2MNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773421353; x=1774026153;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y9a17dPzIDqIL4X7UEpxgCYfEwk+WmJdSdSzwqIhoGE=;
        b=jNBYPTY6hzfYVtYyB5Ld1Og2OQKaIREZik2z1MCX7waQsIxD8g8yEHTY/tHJHPEqyh
         HEvCgCTZxP59bClvUXO7Q1nAufZgPolyOS4f+qb5j5ERqu4xnKXYd6rQxwswJ/npE9OO
         pnm1FiFNoWLR4YdHsDzAUYozzhOjaRg6EjO7yTFJ57JVmnTWIKvXhsM0KgCVFV2hSCRh
         9AbRBGAwJa7w7CoUSecmR4YHdYdrm5jkGqF2OhPGOgWMpzCToOlxT38WSBO3d2bbTSOw
         /MPIaWp39kv/RM0MCbOi9Wy+D+lkrBrkJMUfRE6yb52iW/tkUKzqCCtGerhge3CChGlS
         1trg==
X-Gm-Message-State: AOJu0Yz2dsxj+6U/1qzXyaPejAJF05nEuGzo3Yiw/h4nwqqu1BiK5s/k
	iMsMR4N3kvO4jdTqHTXAlGssFl/nV7Vfw1qB2N+bZ+hpkqSYCMD3g0xL
X-Gm-Gg: ATEYQzw37YKnZa0pljZjXBr8Km4J5EmuuyoHNqf2q6piJtOTFEuty6VWd37iuJZRRDV
	lkhEeuWZCzVLvWXEcZsiXKZljiyzWmaTbHpH7Ie5lf6fwATMr+oYFVx+DBucFK0MqS9xLLdCtHQ
	xjKbTgKqnRxCvHsbgGrLFeV2Qa0fTRSMCU9Ox9aTnVToHwuDOyXFFktg1i5UWA/vcLzFusjGubr
	Pask2AYcIdgTdL+66bUUDJmGQFoTcFKjwSB7RmU2mVE+M0P9vQpByzJD2rhrEHAGBkOu0PjgsjY
	O6ix0fm8M8AIlXiZxfLqxQNFNATA7XDBim2ZsdKWh0vlnZMFODqY99LfbzKvwjSvT41+3WFJ0wB
	mFQQeG8XjLD2wPOCHwiGaq2m3Z0EwH1CqYAdwiIeGB5yM+68IioMmkPDe8mjPM+w3LWwbMBq/6D
	HN9j5b5neguD0u2S0XQiJU3yMrHJnv0tvP8qkvL1h5zhwpQ1NL6fvIIybXPkYU
X-Received: by 2002:a05:7301:fa0b:b0:2ba:6aef:697a with SMTP id 5a478bee46e88-2bea54df24emr1749497eec.24.1773421353131;
        Fri, 13 Mar 2026 10:02:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2beab3a0b3fsm3463739eec.5.2026.03.13.10.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 10:02:32 -0700 (PDT)
Message-ID: <c8ac11d1-3e93-477a-be4c-721579382fbc@gmail.com>
Date: Fri, 13 Mar 2026 10:02:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/265] 6.12.77-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260312201018.128816016@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/12/26 13:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.77 release.
> There are 265 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Mar 2026 20:09:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.77-rc1.gz
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
