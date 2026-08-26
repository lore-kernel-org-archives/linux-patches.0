Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592D2EEC0
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 00:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787702635; cv=none; b=jQc5G3XeoYM8v2nxjTOI/vYKK3v7A/5bTW5a28UDorQE/BjVftFiK/XJyAgIbc3htXSezxnTl+b59BJjYvLUwyPCBHtSf654Xv3e9CGiR09cXwjI9QvagHCgwYtN1iuILKCXO2Qz6LtpdEiAhSsGEGd+bwjEApw3HeSiWsVxJP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787702635; c=relaxed/simple;
	bh=w2/uO/cTeYECpLmwJDgqE1Jw2x+04yzF1cTArErEmb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JSLL89wUGcaXf26KL19lYthKK+1kn3n998fwoDAzwbcX2ESRQ7JrqZAD3oaYmLWXL9SdXghNL3Wr/FaQZovFCn+pyJ4NYOLBre4QbMH2uKSET2gX+PlcAnKNyvqU6Ghjp8JH7Kb6Qa/Yeb+jjz25hVCZAaYXmmrMC897tzbjFIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hLdPE7oj; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hLdPE7oj"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7e9fc3de7ceso267813a34.1
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 17:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787702631; x=1788307431; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qhmLvkFw7q4r3BkfihpZ0flMtMPEKt7IofeSWV3ehe8=;
        b=hLdPE7ojiJ0LBZz3LMu4Xi9TWjwxWH79VGHHoGz6/ptID6JPoJ3HcXBJZoF6tP/0JA
         lepkpvx6IEpeGUr29BDXDeCgg4/K7WCbTdj1mqQQbfQxKwrLYDxCFEYP+YTleKgbTmmX
         DeEnR4ry4UlbVKIxXnL1YyQJQa9XKDkzPvk1w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787702631; x=1788307431;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qhmLvkFw7q4r3BkfihpZ0flMtMPEKt7IofeSWV3ehe8=;
        b=QAD5xXeU7xtW+urK1M1wwdRY6qrVCB68budAKMscoAvOzBPU07vWsduuLAbsPWWsVU
         ubuGgHvtheIe0m6PaxWSe572VLXZLris+LJHwPTAJ7PFothu9uGMoP9Efr4vrSxAqhK2
         wIScZ4kTbF8WwH84bPjZMzUCMWdWjHTIEB6Z2v84DsmcbGHws70HgAfhrx0tvkO+Z62K
         ktB85KcAzbU9qoUNoGbIgecoR0NVH/zuw069p8xBgmKljtsuqJPv1/v2TeaZSSCL8zvR
         9WlBNXjoIE0BDpbckX/4pdp9yQ2L/Xmi1g/LpRVLnA/TLFybvHXQOKmKkMQD+kCIwpJJ
         pxdQ==
X-Gm-Message-State: AFuF++nFDF8A8/mgbMN8hd+4LR+hJcieyKUAxC3bM5Z5nEBoeUH15qw2
	BUxQLTswBRxf0MtOmNffB+zd+TZ4WuLBw5YDaQxEM09Ua7bAucBuJH74ErCuNQPw664=
X-Gm-Gg: AR+sD10JTV0dVk7IJJ1vYTcJWGasZLugK1m1xG6zxEnbxBjYn0ucObDEbxhmIsbSAb8
	XQl08Tj2dcJ0HOrzykX3Ed0hBSJDCqaKTbkTRJMpFilqxK4oQsVG4tpouOXvwFCFZleFYFC5Jla
	dpMEQTGxzyGu3fb6hLrQhQTnXoH6yRnc+TIZCG/sk6CuEHcoY7BNNsmBsjZdeU2ah8mI7SRqJi/
	ol8PYXfCzjv6ttznGba1CzN34xWZpBL4g9Jt/R1EvLA1jBUIBffP9BI+6IOSromfao5Ny+kEtYS
	uAhtRL4LYGfUGnhdZetiWyQIquCIFC47YkHposQXCl66KcLW9bkZrB1AzBiiMFD3deV/QKY32UO
	S+J2bLNAreGHORffbOYw5lVqzrEzs6ZdAj2JOi8HryQV1UojGe3CGO6EYmEEdiK5DcmijZVPwUo
	gS37gHxLk+d0cO93RwqbeRjRrf4GJ0ZEGt1tOc+IUXobcKpj3ZB88uJy3lbvd3PWRokuv1ibc0L
	oPBobhE
X-Received: by 2002:a05:6830:388d:b0:7e5:6c74:b295 with SMTP id 46e09a7af769-7f4c4fa8b3fmr2735293a34.14.1787702631068;
        Tue, 25 Aug 2026 17:03:51 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f4c842ac28sm293745a34.21.2026.08.25.17.03.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 17:03:50 -0700 (PDT)
Message-ID: <d26472f3-03df-47e7-ac4c-ce0afc41499b@linuxfoundation.org>
Date: Tue, 25 Aug 2026 18:03:47 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/101] 7.1.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 07:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.11 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
