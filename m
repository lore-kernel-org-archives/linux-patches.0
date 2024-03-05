Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940CC5C5FB
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 19:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709665517; cv=none; b=p997nBTsFyHuGc4LIGmbIdOBNlt/nILrCyRPEKwWKszzrQPME8HID3huGwiE0QG8Bk15W+H7Zi5hjbR/u868DOi6Y+ek+8Mkyg4Ge+VHqiAPY97+//S2JnoNYGMB3Zly2z96atzIVvcgCVz6HU48vhCcM99gX+S5GC6NMoPcA/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709665517; c=relaxed/simple;
	bh=pLKs2o9mN+L/TVn40Qf5nbTSPRtRFjwhZXU/y/3HgyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T1xg21Zdq/uI2qRG40VZcQqKx7NCdH4L09qL99K21tTEVAUeEPxMPz32SshGsMIM2fRpVUU4ZVnxC/Mc2cIUYRpIe7f3pI0r/xpveNbVKWXoB/JiUpk/blQ47n/omHO3+yQbfjD46qKu3IEmw8eVVYwk1Pr90vw68BNHrfeEMdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxrXDzDo; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxrXDzDo"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6e4ea48972cso757542a34.0
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 11:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1709665515; x=1710270315; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Bv6g4mYuzY5a2DeNIRGo0Wt9Avb45ARXee/OX48tck=;
        b=NxrXDzDoCdMcOdLwrBTzOU+YbzUFXrykJqZvRIhy1W2/WS1bOFUam2up4nnzyPzV17
         hvdFThW63Yt8fAhWsHHlWOLq6/C/MS3DiLbpbByKbS81nJlM+2ooXGQ281QQOr22gLFi
         WJJlgNHBOYJ4/UhVnXGKLtEEirhCFHf/XMmQQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709665515; x=1710270315;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Bv6g4mYuzY5a2DeNIRGo0Wt9Avb45ARXee/OX48tck=;
        b=EyXMEu3OW0fGALQozIUcahB2hSAyC2sCKwwn5ENFoReZN8yjLQs/3HbKj+cN7RcAa8
         vt8IWJOfVEoAG1bNMUPbn9n39YGZHR0r+6q53N6KM3A5zVlcYVcwnXtjxzQ5b5WrCr0k
         RFeYvPVfKbACpBrap/eVCZ+2YdO4ucigCxBbVGqEPzoa4X1P1NHvfrAIeMHhD21QdxBY
         1SfoNRYZ+AD5WEK4/rgLJ3+gQn5eAyiqtqJqZSdr3dxQwFK1BLdlBlNUsqDpW93O/cpi
         IxMtlbpNamSYzQ4OEtNyvqwZKUVPnFAlxbg9kWh/xA2pzfxohTPJNSxehjVLkvHYWLNE
         qfLQ==
X-Gm-Message-State: AOJu0Yz/motkG3cquPbXjvcGSHf1s17zapeYvjVxpd+myjnWFgG0c/KF
	Dj4tiLUaoDqwpxDhPlhE5FEYRjMdyo7WHjmofWcFKVbmLHDQAOk5XOnacfdQeJU=
X-Google-Smtp-Source: AGHT+IHwdrcOWBop+MehQAntWBGU3qhsJDffTHndvFcz3FuvKd2Tgbqpv0qQA4VKJ+ctmFsK1hWS1g==
X-Received: by 2002:a9d:4710:0:b0:6e4:e0e3:55d9 with SMTP id a16-20020a9d4710000000b006e4e0e355d9mr1456409otf.2.1709665514706;
        Tue, 05 Mar 2024 11:05:14 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e3-20020a05683013c300b006e4b446439dsm720336otq.70.2024.03.05.11.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:05:14 -0800 (PST)
Message-ID: <51239853-ee9a-408e-8328-7e74748e8b13@linuxfoundation.org>
Date: Tue, 5 Mar 2024 12:05:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/84] 5.15.151-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 14:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.151 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.151-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
