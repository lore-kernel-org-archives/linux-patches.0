Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8928D5029B
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 23:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712879002; cv=none; b=Z5bggc51TDchN7FrbZFX6An1zd/Wmo9DhOJBNe/jBSJ8FuerreowVSLc8Ne/X+XEU+9uSdL6q3eCSC3tdffytBuTxjTrZbbJ0mdPIlQjwBsRFnPrs4Qc/w1MhpTwPYQR1B8lcbUQLgG36Y30LFxza7RKT2WapJRouEnqCvxCIqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712879002; c=relaxed/simple;
	bh=euNP9GFzTMlL7dk7n0mj6KeWCa/Ukh/qAxFXqL0UvYQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=acT0jS5ejRY0rUewujwkYcLfTnJ4tLAmsjExSkcIjt6lt9QdP+NBZtXCdxuM5XmCGceGd6w337Cra2+5ObxDp896ZgRuTuHWA418oJJcjTb7Jlmhqx2B5MyzpYcH0mDfjw5Sll77ulcErGfm9XK9LNieFJ9d36ejk79G7zIEmis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6MTWFvD; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6MTWFvD"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7d67d1073easo7101739f.0
        for <patches@lists.linux.dev>; Thu, 11 Apr 2024 16:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712879000; x=1713483800; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ftwuYrVcc3eraO9zw33nB+CAyySYVAqnz6ETdM0/8LE=;
        b=C6MTWFvDz+RKjNn3mNBk7UO8B80f1+qryj1ldjwuOohe03i9hrKHPr0uk8dIdAa4sl
         Q9Xof1ESp0bCOEjgWh1ARtBJ9u77Y4KMRPpdfWD7g587WYJsScpKHCbUIHEBtPG7No/c
         p/8sjsaowpZuAJR8nBJtJJ1P/gWWZSaODxIQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712879000; x=1713483800;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ftwuYrVcc3eraO9zw33nB+CAyySYVAqnz6ETdM0/8LE=;
        b=kYjqom4djgfSaXPo6SZyxZylcFrTtt9SWbnd5PW+//seO57ED9XvThNJAiscYVFOKV
         sOEdVGrctn0YlxLWSKGmZnfGdmdT5FTLjVZfpCO/vS8mOoohgnRRn9XSw/RkAUJS5w1/
         01g5XEj3shNcDZtupJ3dOYEj24SIAupgXvc4aJ1NHNm6hj3acXNQ4a7adf89TwkGcSTz
         UOtLrr7aRkVvHe5IR1t4zQ3viIpuReb5wI8mCO3D+2xaTZVAbigMXWiQMzA8z+YJZUnd
         8xi3l/Pv4nDZLpPs43byJTp1FTqEcbY4tX6KRMmgzo/5ANf6n/eWQujRN8Q+BuV0XeIo
         QH2A==
X-Gm-Message-State: AOJu0YwJzB+NKm93mtMNPxhffNIadX/p95zNGYmA3Giw3Go9GlgHnCv9
	OUjZ5utQUEm8LwnQPZeoPoaX00z3n2O4Jcz/wvV1E9Lnh/l4S7qPnC0bdvVvRVQ=
X-Google-Smtp-Source: AGHT+IFi/4KYRs4PuSpmw/VIWvfaUej67bS0cewEgnxZV2DTetbKiVyr7CY3wapXFEqbezkxkPfauA==
X-Received: by 2002:a6b:7b05:0:b0:7d6:60dc:bc8e with SMTP id l5-20020a6b7b05000000b007d660dcbc8emr1532834iop.1.1712878998599;
        Thu, 11 Apr 2024 16:43:18 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id m40-20020a05663840a800b00482b8b12872sm667259jam.174.2024.04.11.16.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 16:43:18 -0700 (PDT)
Message-ID: <cc48bddb-93c7-4a75-9d78-e88a9c6fcc1e@linuxfoundation.org>
Date: Thu, 11 Apr 2024 17:43:17 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/83] 6.1.86-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/24 03:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.86 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.86-rc1.gz
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
