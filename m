Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB0A521226
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 21:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788556105; cv=none; b=MBcJdNq4t7I52YeG3awLGRKxPJvmm6CAFHcPGN+vz7w/CoHTFiIaOZBv/xyMCqyHsBo7AtviNA3e+3k/BB1LQ9WCKpMWe9d66oTmMzSDCHUSx25JEMSVDLxAmBIdVy1Kx6rbK7FvhcJrCROIi0Kb6t8j8GC8C6lGQrYVNMmdEvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788556105; c=relaxed/simple;
	bh=TLbkhy7UhS98+n2pJ1BtGLZtz1S+VYaSrwgfIluJQvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EXtoOoRlNUdEDaWkRv9RP28gjNL61HFgsri4vlpKgi6Nlk72Bqda94WQZqGSB6ToU6wYRW3Z1uWCM175EjSHiZ2QK7uzs5mPyQkiwLZbZnLzEpdxMxPclv8zmCorXvj/KYXExoB6k/JdEdo09Y17rDmz/fgnlSV3vycMed+FxUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HhE9JAEj; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhE9JAEj"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-4b28df1f600so1283870b6e.2
        for <patches@lists.linux.dev>; Fri, 04 Sep 2026 14:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1788556100; x=1789160900; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WBcQO8IW5vaft9DEnj/gUzJmSXgNK0HzXFdKXlnG8Tw=;
        b=HhE9JAEjyYAdWg3sQs1hO9izkkab7NMD35UU5zFsMMvmlDW/DaazNaTxWG4WX15N09
         oq7rhfPGBziZtUncbFed5KyTPyyw5ewMcnnf/IyQ7YzvtMB5/CaIM2HXn9vqKG+rnK6/
         qQfDBbles2M8QN4n1s+gPgD5aoR2G0DQ0BHp8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788556100; x=1789160900;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WBcQO8IW5vaft9DEnj/gUzJmSXgNK0HzXFdKXlnG8Tw=;
        b=d3tpABXYyroFklqN66WS/rgDnyuiLLAooG4obtekzfsE0i1+N+2vZCkk4acY7d0qNV
         fEq3L0ihr5WcVi7IKOrr86sfbw2ODbB9SncIWEagiI+YhldbfiMhETW832ZYyAX4sv2k
         AI55UmguphqMzJ01oOCN94S2MuwZA487lykwbxw9LVgF2OE2KlzHkzFddF4CyCbKS4vZ
         TLU520nXq2dZjHTHKw7Ok6fFM2g1FPjssu+UAftkhfSnUSlLLcHNTl/8bM19UWsiqg25
         VxWdp1Kxra5pKmAvA95EorhLw1SIKPete83A6n3pczC+ZIXGL4hT1f+V3Yc2lNdfHqtt
         SqAg==
X-Gm-Message-State: AFuF++m3fwXaZfzfcxBpAWTU/Uq26QYtV17a+BlYjZdXGTV8mB6JX7zL
	Ao9yPez8RoDYaocc44aYfFgLhUlJE52BFmdjG7LUZiolc5lwSVRFYyY76Yq9yupso4M=
X-Gm-Gg: AYBFou0p5adsOE/qH2tCFN81TVkZ9pR+1VMogt1lq77tmkXKeZFMGYad8uAc6KziMSw
	VYdcvc0S+9R3es6DH7sLwbl2NhxlgQdM1B2voe+J/t1BhjdYT+i4FdREkIkjOfHlxqwNOnIxWzi
	jwuzCsdUe5sqGVEr7KfBAX5QsO9eLCqSzW8DEBvJjhrThZ4raq3bfC25q/o+UX4/lg/13DtFf3r
	g4DBRagGrkQJifqFIOoc9Xkp5EMFuHtQcTSK7DouDa1FkyPhUPb4gvDs6GmKzMzEdMqpNAtU3JC
	CRg5rFe4yyo5ceIbuCUINA+ok8d8ov0bxKGGBBKS9whVXU6s70W8OpClFY/UiZ8Qv01VwMdBam1
	BrWrfwrGA3lWy1ldrGmGqf66/FIEpWH+6D5dFAzSYm2R50WMNN0BqELgiOp0g6UWiNVarnKxqqp
	/VWdtptzl9GofDU01n7x7jXjHH89mpvmvdIhQtN65oFyv9oLecGBND3J6qYiQltTB6yybl
X-Received: by 2002:a05:6808:23c3:b0:4b3:7efc:e970 with SMTP id 5614622812f47-4b96026e6ecmr6951990b6e.5.1788556099903;
        Fri, 04 Sep 2026 14:08:19 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b971b97c72sm3487810b6e.15.2026.09.04.14.08.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 14:08:19 -0700 (PDT)
Message-ID: <fe373fd0-6577-4f5c-8285-d8398d867797@linuxfoundation.org>
Date: Fri, 4 Sep 2026 15:08:16 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/713] 7.2.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/26 22:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.4 release.
> There are 713 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Sep 2026 04:56:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
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
