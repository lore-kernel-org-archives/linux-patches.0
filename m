Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308601E498
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 23:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726010458; cv=none; b=T4W+7i3Qhrfe0I6OYtyPn9OvASEb6ZMqtRxlMqliM/I/ZDPRzO8wfBBg9Mbk0F8bDTCX8y83+3mtpISaG1hPBviIKRjDrHqJqF9Ipq66MxaxU7thL0nJ0oBZ0f9sybqxn1zMsG8bjwo7pNl7D0n1uoUFTTNU9KSTVvoyzp711PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726010458; c=relaxed/simple;
	bh=U4EAbY9M58DyLBeT3V4uWlg+wEurSR1JCXjx/kPTLJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EHBRGwBs9pnbTZ5XAYssgOXr3AZlTCb0Z4QWl5yguREb1VrwUGp1rf4Gg6YwIFAydVFC08AAm6KKNj97Pfe4WjxSiLJzJUqKMJeQc3Yjbcf6GcxpsziJzcfaK5Uh1nnbGCNxJuxJBLD2uJ7ANiT2PFHsKoMjVpUVqX9r/PR2ZjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/yQYZoW; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/yQYZoW"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-39f539a83e0so22135125ab.2
        for <patches@lists.linux.dev>; Tue, 10 Sep 2024 16:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1726010455; x=1726615255; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nP+F6KQXB41yOMLPUcFAdK1CUArMESt6YLkIllFzb3s=;
        b=I/yQYZoWiAaNW8bHsk83Hc+CmG2lTmKy+YTovhG15dTcvgItMcUO7Y18m55YNPVBgH
         4D6A4F5yfr/GVws7HR5XcfRhNTkwVjH8Pse6y/9BJW9m4c+jNxLWApKeqorRNwWoQ2Mb
         QgYr3vuls0f9RmFwHqQpjD6HJ474dvH6VDdxM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726010455; x=1726615255;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nP+F6KQXB41yOMLPUcFAdK1CUArMESt6YLkIllFzb3s=;
        b=YfteVxmN2rzqerlXbV53VUKU7hf4FzSdlftkGPdyNxeIJVTVqD8E3DtdoGy4dq5Nio
         ZFa9N4dqFnkO215Xyro3FXz7FrI9yfksETNb5otrp+eOTBC86YHayeklADZQcZsXcidc
         EkRFC5MLCgFG5vBxBuNOQme+cwGH49Yx6UW5sn/h0NiKCjadpRsbCDgr6BLyt55clBwN
         vK/EqD7t+ZDpUkoUxaTJmD7zCP3b+HzzXrnI6h9YDox/krNzU4H1ASTgC6PMn5s01sSu
         d6OJcIwu3/KA2WujUCnB3fD/xnQaN01FvzSMCX5R8wi3/A2KxfOcMVIM8nswHv2OiiJd
         AqrA==
X-Gm-Message-State: AOJu0YwLnAPEmcYxq6o0FGFsoGrBXad4HfmW7mBIHnQOoowxQEFPFX3y
	Oqt78GfeJip2UPnVEPVMshoPJqNLlsUb0IlosJHK2c/7XBIN0mdMEKhj+FcYQmY=
X-Google-Smtp-Source: AGHT+IGc1C+Rskz8tPoGBdLeCU3gP07CCcQMmJVw6yyFBK3nzwjbHotz3iB3nLtNKvPCfRADwwHUfA==
X-Received: by 2002:a92:ca4c:0:b0:39b:2133:8ed4 with SMTP id e9e14a558f8ab-3a04f0aa8e8mr189561925ab.14.1726010455190;
        Tue, 10 Sep 2024 16:20:55 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a058fe55d8sm22621145ab.45.2024.09.10.16.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 16:20:54 -0700 (PDT)
Message-ID: <48690583-7fe9-4edf-860f-7372983924b8@linuxfoundation.org>
Date: Tue, 10 Sep 2024 17:20:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/269] 6.6.51-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 03:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.51 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.51-rc1.gz
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
