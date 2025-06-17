Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1D21E98E3
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 16:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178996; cv=none; b=FT0qeqBxytXk06mW30gbqShiazoTXGht2V6A4WMM622+W6asiVSK4J9omqqJiWMff6aV5X0uM5qWD8cLWBvZzQH2IqZLShHadQMuNt41u/M15m6YNahI0Z1WfqxuEp0EYGE8qNqW1AFk+FR2p86bI57m66VWIlPcRMFnH5hiPXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178996; c=relaxed/simple;
	bh=PoMp27oskVu/SCAt5yUxemcUEZfpX08olGOoATzlNQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fahlZzE/NilfKzUQStDc9/vnqq72ZXWr0D+kf/QBV5mMvWLJ3pG1wsgLRq2gfrXAu7vlMTe6m7zkoBQ782Qe4anyOyDwT6zwcgrFiPQhBFSZK1vxomD2mgwh+kfZcs+AjcgE5ZXtPC12pqj/tRmiarz3H6bieDaDe81BIJWTr/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kCJ3XwDw; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kCJ3XwDw"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-235f9ea8d08so58970865ad.1
        for <patches@lists.linux.dev>; Tue, 17 Jun 2025 09:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750178995; x=1750783795; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7wUXb4VopLhdBixP2euU7i6YD3GTNqJ4plwFX4HKrkQ=;
        b=kCJ3XwDwGnk+g9lGu9OqfjfpqddAXwrLwy0+sKiu20snZVmiaZQzM9ChvHb6BF86f5
         UTfIY2bOJ2eK+zPOx2Yz0vnvaJM2IfxLnDyAwh9daYqH/7LxZKJmtoyJKmCnUMefVzpj
         zB/YRm5KwFFC7L8vQEvLi+qnTmz/JsLJugphxnYGE1sPtR4WJcUjUuifne8SyQjU+XsJ
         Ln9C3ZgbmhIXn1SB9z2AxVjFEwKJu1MuX1e0NSZUWn2Hder3042BN3St5eLJy51rGfNX
         LFZZeJTZ+WiQwNntorsiIWo7MzPtsTf5yzfsISblxoIe8zNlo7Q+kNgK/KNUC5Wm3L88
         jGWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178995; x=1750783795;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7wUXb4VopLhdBixP2euU7i6YD3GTNqJ4plwFX4HKrkQ=;
        b=MNkUWs+AAL3t1F2A4jJ5ZpMLvzWmaQ5B+JVOJLozJe0mie4PSGWwXx6qV+ZXpJRVTR
         bORvZi4H+xXfivp1yzbOVgZ4n7ol1kzfUlxCA7HG0Ll8zcH2Mfl8iEObg24nwaF0d+Wm
         CWp0gAPY8NxgF4Tx7QZ1KAeJi7+MOzDXAP8bm5mX6FEbvi2ga8oYw4Y3khWuSI3u+EVF
         8hruBf/LiRFI9rvWIrfCePUqHF0imBAKVa8Mm+C8Oxb30oxHSi1lOgYog0N53u0PRk8T
         SA90DF5pOMyhxkEX5al4VpnUQ5qdKleT/RfHgtP+GHt4JKJbMKW1YBCp/gyXz2PipvXm
         urbQ==
X-Gm-Message-State: AOJu0Yxo03kIjPvyiHuJFE+a+zeVkjNWyeIpvzgFjLjSvS6zVtN8xGYx
	+Evjsy3wr2SOd41zMg8jb1clQpDHdsZcQzuPiKXuK9+pHVxAhyMRlB43
X-Gm-Gg: ASbGncuXhI1bubs8jazTdKlhVW7fPFomwmW/FiEF8ddYfi6iwdao0sxE9o/uD2oimxQ
	8bTs/7Az5h4/XY3oJMu/YaJzfLFNGUQaYIEV4Rcyc37hbGsDziRbJT4kjCMjAN+jBx9c49ZzatE
	UMQZFu1beCvzGxhIeh6kSEYCnPatgxjYIfgEdA6S6SqacRl/mxqmU2OzGwt0ObJwqVRbfwYD22S
	oNpFVV27Ft94DMMI8rVNqf1J8mvnCciIpfF4Jz9Ua9B7gBR7TPFM4gKK7h71/Wf8goKKG8mWGhA
	pQHA/ysIGYRZmz8ejFleDEKMXG5rm4WBpZOA/nRkIHBIfAII/TRT75Fz/kH5J1kke75CVNb2Q0c
	m/0yA75C6JCCwOQ==
X-Google-Smtp-Source: AGHT+IG2AKukAwLRDN3u53uYznYRhhH7+IMkI9gvcbwGrrPaEyNf3Y7ktarcPLqFpvBLBGlv0xNO5Q==
X-Received: by 2002:a17:902:c94e:b0:235:779:ede5 with SMTP id d9443c01a7336-2366b139bb6mr224634075ad.40.1750178994625;
        Tue, 17 Jun 2025 09:49:54 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365e0d1444sm82137965ad.256.2025.06.17.09.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 09:49:53 -0700 (PDT)
Message-ID: <d5eab853-dbad-4336-975b-45b3947ed793@gmail.com>
Date: Tue, 17 Jun 2025 09:49:52 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250617152451.485330293@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/25 08:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.3 release.
> There are 780 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jun 2025 15:22:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMTB using 32-bit and 64-bit kernels, build on BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
