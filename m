Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5811D1A238F
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 19:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740510915; cv=none; b=K9rAO3+19CT1qJ57W9DB9uK6LFSegTa5UcVD47DsuOPaQeQc4rnYojd+uCDbt3/F606jJF15DF5Hwm9nlGOi5aRLdYqp/ZP4af1YGcLxf5SvMx5dY4IYM4Cw51vMEflC/kLnllQVP//zhhDjndS90tO4WkQcbwOwfr0mjkUtOJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740510915; c=relaxed/simple;
	bh=DSDcuexA9NRCJPkhclcocfqW/i+zO3L62puQ9zsDF6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n4PiC1vOgP6QvHjB/kjY+rqwhdgy37t7wcwrjCppT7xJDpwlSUBdOtlNoOv3sYkRKkxV1BrF+0wz9eqJ0knhCwbFHqQlEUa5kxnA8P5M+2thGzoPzOwKLlkecfSRX4QYJflqGVTkMgU9x2197+EvX9oDvOk4f+gwPxmGd1lohbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LQwLu7oV; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LQwLu7oV"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7271239d89fso1754638a34.0
        for <patches@lists.linux.dev>; Tue, 25 Feb 2025 11:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740510913; x=1741115713; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9nCmpdiWwybHJ5Or+j67rh5Tqf2Twd+jvO/TNbWf9bY=;
        b=LQwLu7oVFVcsx4GraiCHb6epnzJdToDUHXJx4OGPEqdWCKAYTHA7qgkKQ7g3jEoHDS
         DLSLy3lOO3uyaaeibGKRCFzRc1sjZL+q/05oy+b1ndQEN1CIq1E+6QjfpcO/qP87HrRF
         h13mXlC0Dr1Cuhr9g7WOABBp3krTu+82d3eFyEokoo9dCDsj9HvJfre5dZgopinp7luL
         xpSkd7dF1jQ3e290gPi4d72MusXlK7wnEgtgmAJU0lrpQV7vgYAbLYiqSbLyiT61jNde
         fS7aQRBhGAMJLtQjnQp08wKLz4QDOeDC8WK9om4XgsPWD5StX4/XMbYAal34KlfGiZ5g
         o73A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740510913; x=1741115713;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9nCmpdiWwybHJ5Or+j67rh5Tqf2Twd+jvO/TNbWf9bY=;
        b=SmwDrNiW14Wrdz3AjlruCXiZQyR+jTE71ehvmDNil6o1+XUEXJeq/cXWiHTaus1GLx
         cdJ66bv3jy11NNY+prV9TIw0oJAO0ZHXD0TTufjgX7aa4It2eF2v1E1M613Qzf0CXsLG
         abKbt8eUt9aHq7VYAKt8jmdH2POJupPHXhAkpz1gftVObZYOd3CNzZTSb6DvdrgRavto
         USCMROQml/giP08cm3IomlVCGxh/07fjuoNUvWh9W9HPQ9FjaW12v4xwh/4I3IMDrFQB
         pqHzLPPOf8SPEuTKQp9BIRBPizT0vLH+W/vDaLyb1BUazLIGZjK1i5ac3YAmFA7GnWwh
         0iQg==
X-Gm-Message-State: AOJu0YyGWVjdeGgH2omR2lSuApYBZpQKT0PYXS2XAe3WIZxC0aQVOmyj
	SEFeAkpmrNB5wzz+ka2POhTxKb+BTjJ9OLNoEC+qbLwR5tLSqSio
X-Gm-Gg: ASbGncvOkVX0VxDCtpZEy5jMrFZjyNQhxcWsqQWM3UuVTHCRzFWk/2vopYuOYPupFre
	KF78eNi5h4vPLgsZVRRDtWLvJL1RLJ6oA30YkJ5PaW6juoB/b3YDZay7fgOWqCCOJdTI0Ywfvng
	9Hcm/Mka2BGVNf7VdaB+AQc99xDQ800UCanRQSAiudAJqiuozrQC+tTEAbgpLCr+v4D7nZ7Xrv+
	FWr5iVyMyp4REn1EZ2VeX7K9vhG3487v0GWOstPXrJSkGB2KAD5MOjgfjdPqepki22gm32txw3h
	OgCmGTE5aEJF+BN5qzMZ6dF1bVG2FSpszH/59iAWoA==
X-Google-Smtp-Source: AGHT+IHxK9HSJkQGHeaKwTTRSQTnFChvfSwiDjnkwf7FjH5/sXmwBWDELznEqDVX/UCCANo0lOb4mg==
X-Received: by 2002:a05:6830:6e8e:b0:727:2252:226d with SMTP id 46e09a7af769-7289d0ef003mr3197396a34.1.1740510913290;
        Tue, 25 Feb 2025 11:15:13 -0800 (PST)
Received: from [10.69.73.201] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5fe9410d291sm403460eaf.5.2025.02.25.11.15.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 11:15:12 -0800 (PST)
Message-ID: <1916f14d-03db-4644-a68a-dea428070fcf@gmail.com>
Date: Tue, 25 Feb 2025 11:15:10 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/153] 6.12.17-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250225064751.133174920@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250225064751.133174920@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/24/2025 10:49 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.17 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Feb 2025 06:47:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.17-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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

