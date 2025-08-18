Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CF12D2481
	for <patches@lists.linux.dev>; Mon, 18 Aug 2025 17:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755539317; cv=none; b=MkwOmMkaj47TbfUg0LN5H0AhyHT14tXfJBJ7ajLrsQNMwkdansWymqA/49ehGZylOk/a5vlx/QmyJLsTgJG4hl9iJGTrY7P1Cc6vZ+9An3FmK8X9BUWI+ZTPEQ61sjiOtTLdPj7UCm7J3H1aAzTCcdxiDsXP8uRkUibE4jwckiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755539317; c=relaxed/simple;
	bh=sWMqAvKl92t9P4XWOs/9MD+AtJ5R4Y6BJACPvbLDQhw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M/yc1cmzz1kselCFKfAMKbhksUARsUy0OmCxSeMHD3EhOFmybz20uEhqxOjK4VQ1yeGHf8pWaIwxKR0qRBKYtsFjIwv0KQ3di+Pg2p1uB3X7PZB1nEsr0MTWbjmLI7XkW1pQghc0GW1NEyUIKps++bmc+53BDOB5tcep2g+KhT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jS5T8hR/; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jS5T8hR/"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b1098f9ed9so28588321cf.0
        for <patches@lists.linux.dev>; Mon, 18 Aug 2025 10:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755539315; x=1756144115; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0cuPJBk5sGkDgFsoLQEzIJEyWXhsR2QY0y/FBEqj2BQ=;
        b=jS5T8hR/dXPot5O0b37GmsfPEfu3R/jTXL1ukIrkVcC6ZQowjIBwTcAp7Z6MHWyzWa
         beKNUoF5bu+nIXspUPP5AG1Fxa2BIFiYraK+SK+JUh54QdmHl4P4eYjDTOAq+9d/OW7S
         UZXx3aCUxP3WscqCfTd8RBI4XV6h+Xt2h//L2YgYzd2UAXyJBUZh1DRb9f1LjKvtpMKg
         qsZzqzvTzXSy/nV9B9mP0O+sjXxElZFPB0ahhlWp9XVJ4HGtVWTsf3M3xHivnsv24Y1G
         BQ3aufyf96LHtLUhpruusWpb3D8crCgGfOJaB5zAnlpJXo4G9tX880cgtqPrM6zif8wH
         YqDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755539315; x=1756144115;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0cuPJBk5sGkDgFsoLQEzIJEyWXhsR2QY0y/FBEqj2BQ=;
        b=w3t/Wijk3a0hmKbO5aGrvzpEEdBVJ5lg23/IPWBGPmY0LNDCQYxS0obiC2yBkjn+d2
         mg2KXp9IcKi/t7KwguQHCQs3nJf4KSdMYcKAcrfSMQmM2/U/SXDS6mPiTPP2oWs2/O3P
         G/UPMAw6WL59DZcdimkb6bL42XKeRevDYUrJu7XxzyaeMHMYuhy03WepCTLIzl0UQejI
         Po78w8ZwSvR6PPbaqFMqkLMlu7jcN7bHNTr4ja48PuVUIt1VI99zYBFJ9anws3qldpof
         y1bM69udFykApWJCqflke8NYLUjEVQuxl6e4IdEu6ipWsuv4dJPwl9f0J4yc8AbJsAja
         /rKw==
X-Gm-Message-State: AOJu0YwH+ZZCoIgNmCXO+TPBlQIrbWFQXFlsAJ8HjDxblnZcbQJVVwfe
	DzkQVLo6M4TfpY5MU3LNh7MUitrCRPCnQ0byIfoEffV5jfsX497aCQpF
X-Gm-Gg: ASbGnct5lyHGx9qxpN9W6zjZUiVJNXwSbXZsyJ9fQGAVT1BH5WLdjBpjKeNvTOTyGWX
	Ksal5RssymefyKAOq4O1khvPEQrn+shMWToP7SJFGBWbw9QCDb50QAzPo3nHo66UZ/pmFRS8Zva
	cCeK9+P/yxgHWQoUw18LS9sOetBn4097ujAXOFaE+mS7xsoQ7/gX0h/77hT35su01WCQJ/b8NRl
	IqxDc/jzXbep5rC1kH0z31EyAJHl2+FwNr3VtgU7qvbhW3i3XuISH45YRzSTFR5+umQJoP0yWI6
	imBH60u/sAGLPjL7vNOsOVlQb1D1d+j1UpfsFLGnEwZkaYWshWE7BVt+gpLZaPodrZyh/1fzf79
	cCua+UdZFd3+Qyl1LMA+PQKACqlpiWwjnodueS/H38R/oULRLYQ==
X-Google-Smtp-Source: AGHT+IFTZ0OzZbAII1mBXaoJKvZBiOFfLDxC/Wh/xqec0/rK3zAiEWmhYFPdxi2rpBpWO2IsiMThvA==
X-Received: by 2002:ac8:5fce:0:b0:4af:21e5:3e7d with SMTP id d75a77b69052e-4b11e23cab3mr167313151cf.38.1755539315005;
        Mon, 18 Aug 2025 10:48:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b11dc1aa56sm56032301cf.7.2025.08.18.10.48.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 10:48:33 -0700 (PDT)
Message-ID: <50f89267-5730-4bdf-b028-5847b4b621f0@gmail.com>
Date: Mon, 18 Aug 2025 10:48:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/515] 6.15.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250818124458.334548733@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/25 05:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.11 release.
> There are 515 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Aug 2025 12:43:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
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
