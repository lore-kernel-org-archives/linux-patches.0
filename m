Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D332F446A1
	for <patches@lists.linux.dev>; Tue, 17 Sep 2024 21:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726608571; cv=none; b=jsg+2yELIl0ME26HKuHZZqm8vxQWSmHZNObBM35J8H7DE3q0H/4lhHDP2WduX7027uEq6wADOr6URTkWPCIFS+AiUhcTM4DQ1HqTY/vAx/AXvosKQGpSwCfZ3qCUMmHGOKRB77vIK0QMItykEWAPcXFIVtfYD2iYSXE7j8yWztM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726608571; c=relaxed/simple;
	bh=7wDJGEiuzOEoyKjEz8laAx74B672WrDzeZlpmIj2yrg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=AR4JPFapWjEFmsDHBx7Tq0Szd3tWEh5iySXLGW2LX1cLv9wNmWY/IBmn6PqV5bpU39v66KUmdZi7igjnx1H+cTodwhA2WoofQEI9EYSeHpQ7JMhbFk1Ojh9dvXTQtiZWKK5tw1F4N9EzpwcEVnSVr3ZThrPapQe5dylnCBA7cZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FEehZytL; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FEehZytL"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-42bb7298bdeso64248165e9.1
        for <patches@lists.linux.dev>; Tue, 17 Sep 2024 14:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726608568; x=1727213368; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=C0fiXrAh0T0NirGCSMPm2oNUpzalmlLbt5hKTzf6gFw=;
        b=FEehZytLUUrIq6lwTOWpYN6Sr5xWssKfY0jVXr8kYMNs9Bo4I91CIxc+vEDbxKo48B
         R8JCpPnTCKZPQbXOp82Kuss2SOKKj3Mf1UmksShK2gjEBFCRXymHSuIb+wUxuQ53TFFF
         tcPwzfZi7SiCx3gOk6iyXowDr0rVkxSsxAoWVyejPbGL4DpzzgBA7+xowWnY6d1mtNcK
         VED7a35G9iJ8YVadRg3Qzw8dvbM+3vuBvHk3p+APA+hHZMG9DjmUKWN/ezka4Ks+E35P
         q08ev2QkvNBfYZ1T5lionbePXjeUB/gQ/NkxVgDawnin3QIh+HhNItafyTjjCxOhhdnS
         i0BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726608568; x=1727213368;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C0fiXrAh0T0NirGCSMPm2oNUpzalmlLbt5hKTzf6gFw=;
        b=WkejN6jhIC8+IjvFJElpKra1ME3OWm314fAES0iSpuv/3bt08D4jYO0VKayYGiF7Q9
         DSaGBui0pJ9qUnd8hU+IhZPqldjQeFXyeqH3AtbJyWG9JP3LR1MuoVcMUqb5KXAkduyz
         e1mWkGapTyI0JAUe5NQQPEPl5m/JeSt8/0T1HIfZU64PtodYUaQ5gdB3xvjPz98TPV3E
         h6mirRsKsqng1g4nR07fF3TjgWwS4vz7N+3Jhf9hM1YdSHONE64sgm3q0cg9/caFugnl
         EWEpL9Sgp+6+OLODKHep4YBgI5dehzL+zaCiSB6zEvUsqiQH4R/TLfT8UUHIJCDm1qC5
         0vOQ==
X-Gm-Message-State: AOJu0YwdTIMbwWtH8lfT05+U/q7xzIUL4wx8KYeBvhPct7fPlncD82I9
	PR832p+KA/eBEYwkMEPusuuUgqLZ1/fZ1WPXjTfmefhBxAuYFCBU
X-Google-Smtp-Source: AGHT+IGtj+wglGTSG7Zjlv7rgBfqYnVp1mbr7Zutvj2l+RBqe1JJ9XBRQdRRx0UGULBl4NqwyNt63Q==
X-Received: by 2002:a05:600c:1c9d:b0:42c:af5f:c00c with SMTP id 5b1f17b1804b1-42d908315a6mr157949655e9.21.1726608567602;
        Tue, 17 Sep 2024 14:29:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42d9b055018sm147828765e9.10.2024.09.17.14.29.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2024 14:29:25 -0700 (PDT)
Message-ID: <b3f6c4b4-bbcb-4e3a-8a79-e9056d13b6b3@gmail.com>
Date: Tue, 17 Sep 2024 14:29:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 00/63] 6.1.111-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240916114221.021192667@linuxfoundation.org>
Content-Language: en-US
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 HGuUuzv+GKZ6nsysJw==
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/16/24 04:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.111 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.111-rc1.gz
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

