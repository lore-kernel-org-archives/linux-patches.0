Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5591805B
	for <patches@lists.linux.dev>; Tue, 27 May 2025 22:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748384162; cv=none; b=Ugbb5/RU63IrvCp6oqrtmawvKlPjLNnTLfxxXUx5n8VoAtWSBYFVV2b9oReNwImShkWpJ0/CBcPEagiPAtRLWHisZB6qKK7ZCIvsRpgMUD6v89zTMtWQTmMU6k51mXIu7vcWgRUPXOwemEv4F0+thAdXKEkeCD+/mA6//jbttj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748384162; c=relaxed/simple;
	bh=LwspOpz/q8M8FYndGmv1U/jrdz9q+/K4Pl8pt+T3NVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=enkf4ww/o2xBoq7LHkNA8ljcrkcGneCaO4xGzTOc2s7v+ULKp0LbXZIVLZPap3zGdsNpJyOfO1C2iNMlFBXniYY+VXuDi3Qt3C4tI6JIfujnPLS2WlPHN8H5Ahm67R+sjYxVLJno+Fq/5jTXegZ+Df9RRZXMQyGYmaqSF3ZT9XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFV9PYAa; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFV9PYAa"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3dd81f9ce2eso1120845ab.1
        for <patches@lists.linux.dev>; Tue, 27 May 2025 15:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1748384159; x=1748988959; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8wuJpTcAx5O0GZhvVZEyTNMJ0cZvEH7zszqLSKSVXyo=;
        b=CFV9PYAaGxN1GOChx0iFsVQmUawMLTtmSn4yKdmF2EGobYrcuIM2H5tA6mf4BJSklI
         rkkatrY+/+inSMK/XmVaH8HJ5K4owo01HYa/GocW30WE4SjnCvslImD0v2Iu6+Tqp5+d
         nXTaTl40PAXd5fwDG4ssQpS5pou4fCG58NfJc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748384159; x=1748988959;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8wuJpTcAx5O0GZhvVZEyTNMJ0cZvEH7zszqLSKSVXyo=;
        b=TRXBTByvQdJ3m2xirzxRZVLGCGcomGjrBuihCIfzKpk79/FhbE1mJkvte7Eas4Gl9g
         PGBFuO1Qw6ryJkP3N6JQevkMzcjbY9cYN7ezlECAmSKfuJBGspx6Rqn/zyrWxDz/gd6H
         aBDF7/4VuNdRtj2srwAqERQqVv9kZDQwc1uiDOsr4X7NCU5vQu7v3Ju+3IpJk7oBufbf
         /GvKVWpKCJdafkb4c1p6u0z7/roHIKZEfJiroQ3z2eE3uSJZDLl2QaPASWQ68dxCfE0x
         Mx1fO1aXsA19f2QplN4/KQApw6FXQXOZVjv3/Kp4ueGl62T2+QK/1K27s/l4DqvXsxUD
         cPjA==
X-Gm-Message-State: AOJu0YzjFiBx4YySDteOnbnUqUOkWU5VZEsRHPobY/jUOa3u0nL/zY0S
	Kyj/dPO0G3/p4aNHq7rDHd4dI/Rk6TihJrxmBS3bPk6oNTy30A4o1ckq4D6zSAwwx3E=
X-Gm-Gg: ASbGnct0qeSKfltvPRkqYOTwon5PvpdmhWSWqmncsPIstOWXqjSmnq2QVSMTFdhmiv/
	FBU3zGvvKVM86MHLwLD5GWTZ64XZo4sDYlI82EGbqlolbQvsxtYBL6eoQRPJrGfQKswYhwk8/ue
	3l3640zc0p3A8ops6pWyNNpB9J40gBeD+Mv8zw6UVLH9mjKOouJ0YrotdcEvcidVMxSofWg3Mg4
	mViMWUUDJWXjRD8Akmwx5OzmPZLCalauIn5V1fjbGO5zi5W+ZFwXWcXBi00Xspyg1VWnI9VJvhR
	BLjgAl3UisUMU7aR7p8aYr1wAng0mcAzBLGkb4IBG9sVbMfjHbqwuKfwM18iNA==
X-Google-Smtp-Source: AGHT+IHbTz9EFncYF8rjj/KzAc3qGEa/ILP+C+ivpNQ25TSNUWFF1L/0Lxejv1TK90rByVWMwd61rg==
X-Received: by 2002:a92:cb50:0:b0:3dc:9b89:6a3b with SMTP id e9e14a558f8ab-3dd8767decbmr21819055ab.8.1748384159428;
        Tue, 27 May 2025 15:15:59 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdba6ac283sm64592173.129.2025.05.27.15.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 May 2025 15:15:58 -0700 (PDT)
Message-ID: <85e05d82-08ff-4c69-a6bf-e8d697c73faa@linuxfoundation.org>
Date: Tue, 27 May 2025 16:15:57 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/626] 6.12.31-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/27/25 10:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.31 release.
> There are 626 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 May 2025 16:22:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.31-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
