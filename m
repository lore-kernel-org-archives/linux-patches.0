Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563A22DEA77
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 23:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764805802; cv=none; b=f6qth/ni/kGtkKrvJM9mT0Cv6GvwsGKTxgm/uGy9qpjRhMFpihjNQxfMxuCHSgWvPZhpcZOuS/1YsI4/O4lCjkpGQH0T9hSPH48cHGcyS3wqtArmaTEKsLcXLxpTDkZ1O1hkCBDIN5TSJ/mt45THAfYIEeLKnvdc9zm1TR+YfGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764805802; c=relaxed/simple;
	bh=JFSiBs6BnxUnLxmM5BL7ZTG9PV6ZaHk+QzB2RyFeQkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BXZ2hRBFf5XMqGZMf9laCgQfX3coD9VLjsgFDOISvNVBXomdSYuhIXszU9x9HsgIPJwAiuDYMAoDrEdHwzEVXNks38346+S0qNNvac7RzN2wSk3gtoFy5J0bepP5fEsMC6HGU6DbHsNdagB5zMHIVaAi+2AI/ioH9CmWCkPG530=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVj1p6in; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVj1p6in"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7c6da5e3353so306999a34.3
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 15:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1764805798; x=1765410598; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PkOm+9erKjGelb4JuVxNjBpVULkuBNccnXwdNJ0IPpY=;
        b=KVj1p6innFz194XdAR6NjWng6tzuJk1XQpRa0DGyloja9WUl4PNOvpGwTQrb/eUQpI
         MzhWyjhqeLidt4lt9XS9nb/vTEKR0MQx1rCXruGdLMI4+JQ4DGkWEVT8uEj8MMO4SsS2
         aA6msC/UGunfPYAKWReSTFxRo20VE2CUOEJ34=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764805798; x=1765410598;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PkOm+9erKjGelb4JuVxNjBpVULkuBNccnXwdNJ0IPpY=;
        b=XLL7lpU6LdvQFXQC6EWhMP9FFbk2pqSUkA0ZVHUvlT1Mv81s/Hb+eA6JHaTL2/bx7o
         ch79gmLkD88yARvCCBhxypQ5dd3xadOchrkbs10N2ez/Dp/6phKPhvEn/ssTydTRZnL0
         9o0RvOFfCJBwPJ9ahfUTGR5hH/gfjVCEdzDiJwh9wCnirK7lCZ7rqeTWvodzjnz/jNrS
         ElmN4E/x9BoqJSKMA2wJA9pARyYUjmCNqdlOwuOp1IjN6HRL68p1lHPojE1Y8C8L2JY3
         DlugrQehigFyOzAj8eFDBQrsEJExlGQsIxhYj9EAzesOuv29EdkCn4X0S6v1/PN+7mCc
         AubA==
X-Gm-Message-State: AOJu0YxET2jVlLwX+qAE5ahMkzLXQEy3ax7p1CodrvOwc4sbkOZh46x4
	loJ6u0Gzr77cQ5XLsAH1/nOiUaoDHQDjbQcVzFf61U0DfCtChkDVVGba296YBc3jSxs=
X-Gm-Gg: ASbGncv9/KyRxyMbwb5ajBV3hKkP4tgmJAjw3DVJq1VEggzXwGA7VTaiv9yBjALKf7h
	R0cJz6/Y6qeygNZxlm82bPrr/tIb0GtUxCOZ7RVlHVrUkmiquijG8Lj0SDIZV7tGDiCSwCJh9w2
	F7zhwSaAHBGnRwlYntzKBGUlxj6lZJ55EoPP6QKR53xCSL5/sJdYQ0yYfx2ilBCDc48DX8TV3mU
	AJMZWZO+LITMYdek99gzrUfWMKDJrRjJx5ZB8KC8TKPPTx36+VvU2R4eI4rvx3Bk7uV14NkhPDE
	7y8H0i8hswrvUg0BOk47K0+fzOh1TkpzTcwx6IN6NJ3tq1Y7s49hJlf2WwMMFcEx0eb24u2LB9A
	firWvSp0lCjILpzsz1wXseN8VgcNf+JJPKBwP9bkWepvHDrlvJr8Mo7VFyaNF24NXpsItXSiUGj
	jw/DglVqfEph2IR1+HFB2sdognxbFqNP10mg==
X-Google-Smtp-Source: AGHT+IEVH5pEDui1bm5kSi8ZVAF9yVP50iGQz3MX36H2IYxoSbyx18I2RHqLyOnIKpemsOOuqZiz6g==
X-Received: by 2002:a05:6830:448d:b0:7c6:ca1f:1779 with SMTP id 46e09a7af769-7c958cd2748mr441833a34.30.1764805798452;
        Wed, 03 Dec 2025 15:49:58 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c95ac84f1dsm133477a34.19.2025.12.03.15.49.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 15:49:57 -0800 (PST)
Message-ID: <66fe8863-375a-44ff-9b08-328783aca09c@linuxfoundation.org>
Date: Wed, 3 Dec 2025 16:49:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/93] 6.6.119-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 08:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.119 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.119-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
