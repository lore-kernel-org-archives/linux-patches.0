Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BD71E4110
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 17:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734109596; cv=none; b=Wo/zNX+RwnFrAOQJqHoY9OLkLvrEKEd0rhErDBGSZfWZ1EKSUgg0Mq2oroZdGIw7E+KQrWIjSijWuPYnn9Tzm67glU9vq7FVxarZSmRoyNMGRWlnbnLbQSObUoHjhdYX53kt1qBt+vW/jHkbFXWZW9Ox483/hn36XNciZdCg19w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734109596; c=relaxed/simple;
	bh=AoRSgPzS88JecR+l1uq6Q0y3fbBaioBqex9uux9/veE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j1s5cRkDn+hGlSO4C3lBad+wg4FBl1ytDxAfnMexLnISwwLbRG/0GMTfTLzW58LKAncKZn04whnvEywNP4N+7icniAEGm6NphQvFH6Fg6T12iUk7Owjm4kVm0C/AdttRaaS8IBOWEx5VrQDDBtMj1gtnRpQMHtaByJ6HaHVZz5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A47DifkP; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A47DifkP"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a9c9f2a569so15079465ab.0
        for <patches@lists.linux.dev>; Fri, 13 Dec 2024 09:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1734109593; x=1734714393; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5b0l10Xxg5NNZ17JwEtHgXQTuzkIvYO2hORgPq2G1Ww=;
        b=A47DifkPVCro3biBNmu7Ppcy4ABT6gtDTmRCmS9h67vKm2cGIJs3qUbjPsULI/c0Og
         9y7JC7gFJGc9v6SoXXh0ePA/fETEOOQV0J8jkMDh+jVaMrbVGpvqvoH+jfNvakMIBgXn
         0ewyEpRgVyeU++0HloyCxCxwKq1jVVymTMNdA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734109593; x=1734714393;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5b0l10Xxg5NNZ17JwEtHgXQTuzkIvYO2hORgPq2G1Ww=;
        b=in36CwtPj7SoH/SblA54tk41iltUn6IRu70uD5B1HQbs9VUOrQqwcW/cBWxNPxIRhI
         fFrTxSf7ZSMSaD3Ir1IDZULDNSNWzROhoti8eKCXwletycKEPQlMULCXc+xR/dTnzpj4
         ahNXogMF3a0HJgXPnmPATKfVNITjcRX8sS+DFn1m/h3GUTEeIV2pnIELvzww+ajvySHA
         8ghN/fYTbNNdekREexKJHvQILqnRfPIi7talK+2OEJQYiHIA59LdL2o3+X9IgIlckX7/
         aGDn1ltzumpX8sqGNqoDWp47rQasn8ZoUw3XIphbIKS4w482LXSUc8nZhQ0A8HvjlKYO
         XZog==
X-Gm-Message-State: AOJu0YzEiXosnExK1ghvZuLI/GkrEpWuC0IvQVT37CWf1ugHRi4RTa2r
	jBW6FCbEPLHs8QYJTjXlXROr6E7BsUsM7XqhNoT4esMOf9SNz/T5oOMs2rc24HRq0c1AJKdRdoO
	O
X-Gm-Gg: ASbGncvZRRuFfroPP6FAokuT9y3aXTXMJpavrezu/fzGe1ZvPa262E607pR/Y6u6ZkX
	ajMQ05A8ZC7dsbDiB6xoRSU3e50JLlhp7pxkoV9jZxSxxT88XmOc9adnQxC9+2fo+T8TnfLxj+p
	9+y1IBh+LrzGVrXGzITQbVc5rtkbUmp3Urju+lcfg+En39V0WkM7tSJ/G64EcLVAZfhQ15oM2yn
	tlD35X2JE5PY+U0G1brwIi/V3nbRjrPp4Y1U9030GxWOLuyAH0KihdSyPnc68hb3ILh
X-Google-Smtp-Source: AGHT+IHTYnff3TXKfRrpX7mWJMSvmgfa6oVTcS7rebuH2nCEbPNkW26SkILtniouEw0a8sW8t+/LWg==
X-Received: by 2002:a05:6e02:2169:b0:3a7:7d26:4ce4 with SMTP id e9e14a558f8ab-3afee2d0367mr38502285ab.9.1734109593520;
        Fri, 13 Dec 2024 09:06:33 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e2e08d5cb1sm1227854173.6.2024.12.13.09.06.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 09:06:33 -0800 (PST)
Message-ID: <f52512b4-f50d-496c-a831-cce2d2644615@linuxfoundation.org>
Date: Fri, 13 Dec 2024 10:06:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/772] 6.1.120-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/24 07:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.120 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.120-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
