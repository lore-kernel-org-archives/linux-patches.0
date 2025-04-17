Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD65220408A
	for <patches@lists.linux.dev>; Thu, 17 Apr 2025 19:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744919635; cv=none; b=sWfnNbHT5BxEy5iYgBWqFwIWBMLR/Aj5SG6EQ5nwnFWOzkZ9cajEJwaa2bTNhin3W4OQ1dPUZEW6jrmdJhvvd46zTNVFY5Exv/0pTETd0MIcgVD3D7rdkAeppnC4ZjOKmFXkwbYRF4d9Oue38MZuV9QnCVNoAqfAtbk2TIefhWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744919635; c=relaxed/simple;
	bh=GM5sE9B4p3aRAM0d4hLD/EXxadnObV/5wdxBEq3CZfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q7m/grFzZX4UVMgOcEcOP4T2hFK/eshZNCOYsrVTkc44IbmBoMNr4IYusBzv+uz4O98+n2Awvh0CtWUggW/picyk7r7MiHO3CO1AcwLnOxkQhJiJurD7a9tnplBRqIMh92FeuYm2UNOp2RwC3BPJO41dg0uHiRkPqZ1tHtsFC9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N8qYhC2C; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N8qYhC2C"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-72ecb4d9a10so694372a34.3
        for <patches@lists.linux.dev>; Thu, 17 Apr 2025 12:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744919633; x=1745524433; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=l4tQL0FUtZ/N01lfGzTVUTJbNpVxe/jx5kfHGdamRj0=;
        b=N8qYhC2CaiithzihtkUUxRyilAxgVpLEjnnY0q/x1G7EpN9cpds7FViaOXtkux+xsE
         qSAlgdfiSxv4WrI8VIAXAD8P5qJP6L2bsArCAHvi+AtJEqyjFH6cAckKIhn4zRjo1WeW
         K3UtPxttxcIJf6zlAW8aXzE94+kSyLlosO8Khs1vU/Lq2ZyFlkXYAdEOFWy12TO3Q5So
         m+Chs6jVjk9wAfzg3IGUZBeLefVcsigY6h6QqIkRe8LSH1wO5tzo5cw6/hJW0Tca0AXK
         vZhy0b5/ArLm4i1gZMaOd1wRi5rU8+RK7BBki17EyCMUR9SdiLoofeHPPZpegR90oxR/
         fXLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744919633; x=1745524433;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l4tQL0FUtZ/N01lfGzTVUTJbNpVxe/jx5kfHGdamRj0=;
        b=ZThtja+51pnJD/eBL1i7A5BneRAFEErDfi7QlXMQwBGvtgqS9uhdnCJhLJas6mbQtO
         yZ4cSCiY5SUc/VQEinpmfhSl/ogpfFPoCTty1lCcB9oRFmA6Nl7bduc/MRkiR1ApfUc4
         CiXj9PE3w3gtzqsMf7rovrLVLTXO7mYCcZWJ8PS37en1R2gdVebsQP5atPI4tgtv3h04
         QHlhsLxa9ABMr2X1FzwteTdz8MCoYld0ImmtrrykmqTfKYKuJRoP4/9T6gnYs3COczxu
         v5eOIlhJEJPhI5RYuaeWvG4I+6O5IOrA8EtnneniISqsMrJIJtXdcdG9BiMwUEyRoK6u
         iucA==
X-Gm-Message-State: AOJu0YyKRFKsC0qckeOekBVFhlF2LxatgXuh0gNmZw0R0BqbrvxaXPNA
	+8jO0npnR9IKdozlCB7XndO8nu3G5HJ+4fi8803z3YF8sPsilA42
X-Gm-Gg: ASbGncvr6z0LEVOyAMwqPib4UsHMhELAI9xmIv8c108Awuu7oi4MrbegnYt6UwETB2M
	frFD5HPK3uUujgp0oOH74pBZYCDZTCVpHjk2gLnYWInbzVYqR0mT3z48VhPPsjnzZ5ZZwtacfRY
	YmBf1JQMcOplPOiZCUJ796NND96Em7VhUwVfFT57iy5OtoSjdexn3Z0Nd9OhU713XPML4kySCg/
	gvOKN6FII63Sq0LW86ifgbQ5oG+xg/sQBXaOZuTwZYph/ikTdyWssv8GfyNT+OKXfWZu/LItNxk
	RxZhvhATycO5ku7BhlBOtFhtoYvaUaupnbOmn9p+H9hnQWZAmmPkrQRKVsYLuU80zGgH
X-Google-Smtp-Source: AGHT+IGZLEh8f1QmvjSkPRGr6L+UglPnkK9I0BprhZ1+K7zWsuoFVZeKz9/m8cBDlEDLTb5lFEvzdQ==
X-Received: by 2002:a05:6830:390f:b0:72b:9d5e:9456 with SMTP id 46e09a7af769-730062291d6mr8016a34.13.1744919632763;
        Thu, 17 Apr 2025 12:53:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73004884892sm67740a34.55.2025.04.17.12.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 12:53:52 -0700 (PDT)
Message-ID: <c64839eb-1beb-44e1-8275-75fe2874e2f2@gmail.com>
Date: Thu, 17 Apr 2025 12:53:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/449] 6.14.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250417175117.964400335@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/17/25 10:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.3 release.
> There are 449 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Apr 2025 17:49:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
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
