Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328066FCFE
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 22:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BWb10iUV"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3b84402923fso2051825b6e.0
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 14:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701814916; x=1702419716; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Cm00+NsimWLmQhdVNiamoI86kNbnX3twGr4LUKJDhM=;
        b=BWb10iUVs52N1dMv506y3tfhpTnAKEwWlDFa2lvBXUowu3CTp6dov6YHFXqSfLYJ6w
         IW8t0BvUum/nzlwBD2yWEA1lJKaCyro+oc9A4QhX8nUUDYSI34/36+7DYKKzcxEtlXrB
         NyE02dTUzmqlkkBmUf910UwlCaU12+9gBcrxNLxseGOjZ86hYrmcNZtcgOgTmWwYIVMb
         DhYt55rOWTk4UiTr0I7jiTjwo6l1vEXl2Sa9w3cmXlPa0cBnCzaHPGQGEen1zNjqwUT/
         UWr06tc0dd7MPMAnxHF51T8HH7DifhlUhEa0cYbhbRR1txkM/l9JmBqI6fjfQG22ljnc
         StAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701814916; x=1702419716;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Cm00+NsimWLmQhdVNiamoI86kNbnX3twGr4LUKJDhM=;
        b=bQZT06ADtf9MpTu2FxNUFd/0bZAE3oAMQ0BWlYBhxhFlugcZc9CLrHt7TE3TNts3Kq
         NegMgMYvgjfHp0p3Ew68nvl4XAjSaTQ0GRec8QtQ47LXmHqH9r2W7wUoaWFRbTbJWUOC
         DcqkAHEGcRUiBkdA51cBasSqSYHzW2c2kpoONjEEIXsBLR8tdePTidGFjk86iFKYZ/zg
         P2WPQaUs8qaB6rH6FmTgNzK2RlFvj63dE0YqT4SANG/qKI1jnIDOfCMSnjbloIsz8TJS
         c9CN/Cxw/eAL6iHH4i7Fq669kccLhUfz2zTo0+YZrWxfza3LY+Bhx3KWYJa6Cb8mnVF8
         8Vig==
X-Gm-Message-State: AOJu0Yy2TanzsTyD4VMJdIag7ATvikNUi56C84DM/n8yBRleVK+fw1O8
	vYonU4+g4SARrdKMY4zFDas=
X-Google-Smtp-Source: AGHT+IF4bbGVePAgZJY4DL9eEdSzz00zGPhOiVdsVZDaC3YBbOyIuRcnhDp84gZ5xB8AdhJzkfis4w==
X-Received: by 2002:a05:6808:20a4:b0:3b8:b063:892e with SMTP id s36-20020a05680820a400b003b8b063892emr4300608oiw.60.1701814916133;
        Tue, 05 Dec 2023 14:21:56 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g5-20020a05620a278500b0077a029b7bf1sm5433609qkp.28.2023.12.05.14.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 14:21:55 -0800 (PST)
Message-ID: <96e7ce15-bcdd-45a4-ada6-bc21a37f2279@gmail.com>
Date: Tue, 5 Dec 2023 14:21:51 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/105] 6.1.66-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231205183248.388576393@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231205183248.388576393@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/23 11:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.66 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.66-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

