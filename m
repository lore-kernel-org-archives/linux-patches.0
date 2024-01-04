Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B3636B
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 00:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbXAwcgf"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7b74bc536dbso87379939f.0
        for <patches@lists.linux.dev>; Wed, 03 Jan 2024 16:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1704327499; x=1704932299; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SuD1D14mJpZxgunpN2GoPeJomdi3lVYstSMBtTROq7o=;
        b=FbXAwcgfprJmhbdm7jhdevNuaZ+DyYtQtV0JeVkdYK27DBxF7/gBWYnNANmo2/cYyk
         vduhkmllqMMq/IsARmAe4QywJZI5ZeRdCegTAoqlY9kvdcxsc1xe9wM4CzL60+d4/MvY
         hFaHFZy6DzcvPY6+aHbp+A1TfRA6QFggCXeU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704327499; x=1704932299;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SuD1D14mJpZxgunpN2GoPeJomdi3lVYstSMBtTROq7o=;
        b=NiheOUYHOT2W0JR2IIWaEx0IXufhemUWG200pmGitCvFTPOUQCnZ6IZMh+rPU8p9KT
         dYXO9lCUbtkXVz/xxwqBHTqZcmA++F0t/w+9dcNbnTbOPO5Axrie7ge2tl04N51gJucY
         fJqBNDrngpBc/JHS49P/+LpxpBzntahp2n3dfIqKJux6JIwov5F6St7Io2kSQrOWomF1
         D9SSBZAGgcl1A8GP5oTJRtG6gAaoSnlNUGFA1ilqisQRmFikbWY+/7FLnXnHRI/Wcw6X
         LnuJaZoYQQtO9xD0ulbo/FbserQZkilPCDIQOM3RNVM8O8OdBoCDU5aagQYVcSU43ISC
         pUyw==
X-Gm-Message-State: AOJu0YzWwg68pSvxcCGGgijO7us0PBodyYIYd1y1txchhoNS0V3QMN+t
	/rWjxsAG/n4WX5ykIgiwoUIwMbuTCPzsPg==
X-Google-Smtp-Source: AGHT+IFBl+paPAGn0wPchVPzxKzuWnrgImKUlT+cEf0osTlbByFRoRzHPU245Q7vGRg2ejxjDhiaRg==
X-Received: by 2002:a92:cdac:0:b0:35f:f683:f76e with SMTP id g12-20020a92cdac000000b0035ff683f76emr27999742ild.3.1704327499572;
        Wed, 03 Jan 2024 16:18:19 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id bg11-20020a056e02310b00b0035faf00c555sm8776442ilb.31.2024.01.03.16.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jan 2024 16:18:19 -0800 (PST)
Message-ID: <72d36089-147c-42aa-afe4-5b3fa681dc65@linuxfoundation.org>
Date: Wed, 3 Jan 2024 17:18:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/49] 6.6.10-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/3/24 09:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.10 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.10-rc1.gz
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
