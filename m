Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAA813C918
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 18:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771008834; cv=none; b=GgC+TCFD/nZZxIqcYUOPiACyTDOww1JnISyz/YQyKLbz5XCSe/H6BWe5Ttk5V+sMVsjBSH8P0JbKd5Xo84PCIlBwJBq74dhrf6gTzb7izkS+psM8TVBgo3odtu7fAY/IDbUcuRB5AHOtgBKVyDGsobQRjOT1GjcTnmc478DfXIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771008834; c=relaxed/simple;
	bh=6J1JGPqdiiuqTduUdf2hg07JnTUTZ7naH5Odbxz0EmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hoZhI5P31pSq9d8d9Mu/vVuJ/ikDIhqzr6oNnUbcCWQw+BFMIFpIqe9mtHLl8zyQNunQd2lm9XS9kgbHsP8TDULj7dcLWonpdXd4qJE4nMfTtYWK/hdih8wZZDclNz6g5u0SBiCl0PjE9dKaLkvee7HmMDf5wzt7flVE6fNIGkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CHiC2MmO; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CHiC2MmO"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2b6b0500e06so1442777eec.1
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 10:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771008833; x=1771613633; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MMg2FXtQsGlquKwWiDWYXGWQkzM+56kQI9PsYm8ol3s=;
        b=CHiC2MmOR5Y6uhEs/Z/Js/d2hjUIc0Aq48Vg3XugtzZeV/kjCj3127yFlSKKKV/7FJ
         oL4N7ggjo2md+934yxpdK0kEVAy24xGuJFmKt0CbIs8ujZ4ERkdjGjrA9eBqt36YeghC
         BgVpocnCVhxq3oRwhGuEyz5Du51/PaeVHFQAJOpS82I4aytdU0OMUSGnkD59OJq6dM4v
         +2T14/oBcUmHeeDfzVeZCXQ0YfdvG28v8bsOji+srixGrWtcw7nQkIyREvB0pKCWhWJ9
         gW0Bekjt719KKGr+XYyBOT88uUY9Z8fNBFIB16K5GCvGkUBcf5xMGZQKcpoD2apbTzfO
         rLEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771008833; x=1771613633;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MMg2FXtQsGlquKwWiDWYXGWQkzM+56kQI9PsYm8ol3s=;
        b=v/4Zol9ZCN3IlBrKdfUFnpYKP1wIsgcTHBRWbekrDwiYNzafXc23i+Ha3FF29KWzCQ
         03rQ+bVyxjirpL4vZc7heZ/kvj9EqgucgQ5vGhpMXqepVmuT+5zYHN+vk5wkA2/08OBe
         jvecH/w/eKD0DDaSGH95lgVVXabdkBOs0bIbF8kBuupl4WGszk2iCopGA3dTlnnyrmQA
         AEnSd3zLzUwWETwwapUkwRJs8Ze1e/xmiq8QiCyeb6j8PbXkGeB4IRghEughxL+RwzZr
         YQAHIu0i11ooBS1kRsfsIxemX+UhR4T5bD049SQUREcoQ5O1al2bBRMR/YsS48sSl6sW
         +YTA==
X-Gm-Message-State: AOJu0Yx31bfvtmy8hDefLVgDZVDfZTFlUlFAhkZF0wQMTwfcOFu8VKZM
	/5tORuyF/6zQgad+KgmzzH+5VCH1omTo2vCoSplQ53aSS044jYNFNi4c
X-Gm-Gg: AZuq6aKYYAqwGvhhzHeyar2x0RxXsBuRWg6b669RObdLZoX6Iybw6Tm3v3y9quQaQiV
	gh9jeuqfsoudLURVjmnYc6CRAwkBrB3DYv+29e2+sv7rfDprEYrlvRa7J5/BSEChjoEPSBX5hlC
	3Tx2vC1WSUmtsrfeEN8HLBeXynjimA53Fz2JIG8GMeJlDkKnlGl9ns02u05XTDoP/qLRmq8gpIu
	eXoTvsHzQeZGc+qHKp/15au0NkbOEVomHuJZO/nsw/7K12r3zSpKkw82dhbp7gFpqwMisoPMsOl
	ALoPxkq6UA/0P2GSBWMYvouBZAjL+g1ky+IjFw5rDUcwNTsDc7IOiGIsmjqlw+BPJkcCPdJ8yrq
	HGHSnOv+f0+RBHnjKyb8MKWY0Eies+c1q39mRT263d7uNyuU66zC10QUkKdqBItk2nO51bnPWm5
	QOGKL9znh2mcfgskXjQCHRA8r8hSNLAObgrENZEHylJasgmZMWCmHYRL952Tnj
X-Received: by 2002:a05:693c:300f:b0:2ba:8706:d022 with SMTP id 5a478bee46e88-2baba071d26mr1431947eec.18.1771008832673;
        Fri, 13 Feb 2026 10:53:52 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9dbe123asm7244089eec.13.2026.02.13.10.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 10:53:52 -0800 (PST)
Message-ID: <35e0503f-ca5a-4c87-b069-1a97c06407b2@gmail.com>
Date: Fri, 13 Feb 2026 10:53:49 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/25] 6.6.125-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260213134703.882698935@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260213134703.882698935@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/26 05:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.125 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.125-rc1.gz
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
