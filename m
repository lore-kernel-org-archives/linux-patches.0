Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939BC23B602
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 20:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752006446; cv=none; b=oUPUWfCLJs03cW9JvNWcHGaLPeKF91rD+yzR/QekGpzfoYZXmkx2gRKNfDcIWrrWCGCtSt1uchcfxkTjs9zzkZtOAazgukLjojSUvHe08Fm2VI23YRu5bMsA05lXLAAtBRupGhsR9yxwTLSU+N3UI7WoDtbSS7pXBsCb/DZbJAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752006446; c=relaxed/simple;
	bh=D4ZFY3zNZ2GF0aoUA8v03uP6Qb5ddMrAwH4USfqLWrg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PnNRTEbYyxAMMiCuV0IRbCS3qPzNi983APKVJTcxVs0KYqjqxzpEjnVGbCA2ZAI+hzcDMdZxdi97pcEucXYIw54SO/MWShUhDW47CRhkvT9BTP0ebf5ha511DX6/hQLJJgcCOooDVMJB01mbETBYco/+sVS/aJ0XXsBu31ZlfCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=boCb3wTY; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="boCb3wTY"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7425bd5a83aso4206938b3a.0
        for <patches@lists.linux.dev>; Tue, 08 Jul 2025 13:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752006444; x=1752611244; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6OA7chRA16WBdPr+40vvzWEefIHpoFhkr8uztjCaCvI=;
        b=boCb3wTYZb5WBh4uYOPa8AtHJ2FkTZpmfiJiDdq2hd7F05VP4rq/HBXVC4hP4/dwPn
         vC69anvfQFnHkKYMO5t8epmevw55inBtqqixR3vTsmZMT03Wjq65p+BGdos15L2a+nHE
         wShp7KVrrc7H2WZyKI8Y08vN3WrXkU40akD0YMt0/9HEukVjjSDOywq6mQqnRiz3g7nI
         CTcpm1teRwoZYFVTRSIN/vGHFsvi6Rqpn0Pzy+jzFHJ3I+iuyw+SvdECH613j0t8+Tut
         KY/+1APGBVxWlYnU/wnYuvQ3mV3s2TH95zhA6jh8GnmIJfWAq/Zrv+TH3KGZYQ6lKFU3
         38rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752006444; x=1752611244;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6OA7chRA16WBdPr+40vvzWEefIHpoFhkr8uztjCaCvI=;
        b=WXbthBLwjnVg4db5wid6noA0nxo7WxCavxyEfvoSR5NijvSWaV8sEzYI943yuhdc7j
         qVb+AS0IEH3thMGuD8ExQQivLbmSLpe2xfnBSbMw1bMQnHIXXZz/6T959eVJPpkGUv5R
         dmbjSizk6DRvmiE252UbDFaw4NYv5gtqphSPWHL3xA9W5nJcB/e3HHSoZ53gc5Y4FMv6
         waNH1MJpwlKNdaT3jfr7EcTd9m7taWMlknAJ7EhdxxrLNz1KZuW7CcEDRz1DVIwGVKRY
         8uZMGkQWc124tB7rzH+SSoWlp2UHm/xAaluhGOz97rQyQ+PChH1Qv4qwX+4GDIXAVCGD
         yCeg==
X-Gm-Message-State: AOJu0YzRsqDtSmrt8rouR4FtAmdTQ/Hwgjy9/v5ftJSyjA3kBZGi9x1J
	GltLsISLxVXkMTFih06LABdl6p1vZIecL9ENBuqNOESbOUkUb+ti6ceX
X-Gm-Gg: ASbGncu9QFNHgdllHWTwFdhGWLkrvQ85JcT+7lGjPuAHU9+h+CbO4h2P3NuLHEifksD
	KJAk01HRga9P0t/V+K2tJvw3EVtMO9HhKNAH4f7B04oRDIlb1z4m6/roLoIIjETA1X4zVIC5OWw
	p6wAuLMpjPA9n6F76R17+4meoAHrE83+8pwHhoN1spUzTEg4atneoM67fLGLdd/90yprEC3kWaA
	UcjonEghun/NumMTVSX/K5wpbEcAJFh6jiThw5aPKvLTadGs5QodB8rs0UI9ieZmyB91Z0awuep
	O0dBHodZbXpYDt25WIydpa2S29BYp4pLhKDLklEIV8xFw8nAT7yhc03HJjvKLxmhK3qV1y8cXtt
	IKi7aLyVm4qdA6r+/
X-Google-Smtp-Source: AGHT+IGPcZ6ZQX5aQ05IyNUFOv25G7y4nEJ1Ysw3rs3xMJGKtJpoTGjGVfDRig/USeGjqzb+aah0cw==
X-Received: by 2002:aa7:88c5:0:b0:740:a023:5d60 with SMTP id d2e1a72fcca58-74ce8ab1346mr23777663b3a.19.1752006443600;
        Tue, 08 Jul 2025 13:27:23 -0700 (PDT)
Received: from [10.230.3.249] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74ce417ddb3sm12865567b3a.87.2025.07.08.13.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 13:27:23 -0700 (PDT)
Message-ID: <73bcad92-f211-4a29-8cdd-86026c54cdd2@gmail.com>
Date: Tue, 8 Jul 2025 13:27:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/130] 6.6.97-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250708183253.753837521@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250708183253.753837521@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/8/2025 11:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.97 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jul 2025 18:32:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.97-rc2.gz
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

