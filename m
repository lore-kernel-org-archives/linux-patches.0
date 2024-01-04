Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9549A210D
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 00:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsRW5trq"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7b74bc536dbso87658239f.0
        for <patches@lists.linux.dev>; Wed, 03 Jan 2024 16:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1704329815; x=1704934615; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F0aOFxnS/WliN0SOxltC/PfrXfpMVs8czZrG52PYpWs=;
        b=NsRW5trqBLJcflPgAX3xFj6iozkloe+M1ZOvbv6B+AwowhmANi+pBX2GlGy6qiLsVS
         ioV6lKFdqaIYimVYTznRSHG+fvAroJWK5efc6LWcUzPBvOZSC9S+oUezu6eRtcHLCHTh
         8U96auAXydJP8dow1+jP5WmLfa/N/RiKwOGEU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704329815; x=1704934615;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F0aOFxnS/WliN0SOxltC/PfrXfpMVs8czZrG52PYpWs=;
        b=gv4s51XEyN2WbzTI3ccnewg/6mFNf7rTDH97/KvbX3R7A50i2SaZhVuoVRvTyixb7Z
         g6zU++IGwhoE780KLxe3kFRnT5AdR4V+kpatEJ+/pSk5a/2xRn03WTZBeIAMt3ic/b9K
         jH1gycfjUluzeILOklk7OkTW5skl47emvbXBPMqBIQ4Pjh9WMRtC0c1iNiQQKy8NeL2o
         Qm0fSyjgrwe/axZhTWrBriwt8av1HF0e2EGTS0x25JJDkisu+AOq90Vg6F8BIFahtTrD
         Y+33DEKprF659kqtsQCG8g7E/4TsIW2BHipoC/X/W04Rtxi8CQBkfhEjDs//0mo9Ajkd
         N8tA==
X-Gm-Message-State: AOJu0YwGnjuR7ofWj7iUpZ/cpdkxTL5kx8jKPxb4PBVJ8WmRROgUhRvL
	IBFE1yjpJye5mvZyXGAFSLBSpCGlopYA4g==
X-Google-Smtp-Source: AGHT+IGzRDMkCIGaSX3ZkoCjX9C9btmWKAPBfa8Oj5WOXmDfPeE99rLQLkfg8ETQ98GXfXoGRmbf1Q==
X-Received: by 2002:a92:c548:0:b0:35f:f59f:9f4c with SMTP id a8-20020a92c548000000b0035ff59f9f4cmr30811397ilj.1.1704329815670;
        Wed, 03 Jan 2024 16:56:55 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id dp21-20020a0566381c9500b0046c10057bbasm7722443jab.126.2024.01.03.16.56.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jan 2024 16:56:54 -0800 (PST)
Message-ID: <22262131-d9b4-45ba-85d7-d42c08e6b4ce@linuxfoundation.org>
Date: Wed, 3 Jan 2024 17:56:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/95] 5.15.146-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/3/24 09:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.146 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.146-rc1.gz
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
