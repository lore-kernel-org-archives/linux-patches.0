Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A0138DC3
	for <patches@lists.linux.dev>; Mon,  8 Jan 2024 18:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AfPmVo/z"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-78314e00337so166878185a.0
        for <patches@lists.linux.dev>; Mon, 08 Jan 2024 10:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704738952; x=1705343752; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T93foiordwiOpdmkOjUmX9XqbUurxK9wPfflnhu9UqQ=;
        b=AfPmVo/zLVdMrwwlALe64HdN1XU9HOHV7G9Cg0BJI2hEb4GT6+LgGuC+t1RUbe+3pt
         C8Ndc3leTdYjz6sb0Ot6stz0GJIVI097Me8RyFg3PVAmwjhUMpNX6sNwbH9KSnHn18X6
         97jLdxeHRIvdaCTQlGrzGKuuHz3CGaSUzUdt16p8STfC8t0d5OlDdFlPOAlEnBKUuDX5
         Gpqp19DL7J/yzVX8FKHcdK3Ldm4uUk7Hgr6WK9Inm+tGjrmx1DkYZxPVtv69PRg/xvwU
         BrJrh8t8htH6wB3hPRjrTtECDR/FUjx8KcXNZo8s1M2mWxHo6kf7WNqIuZnN6279XUvX
         iutQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704738952; x=1705343752;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T93foiordwiOpdmkOjUmX9XqbUurxK9wPfflnhu9UqQ=;
        b=POBJZ7U8vsD+rXXCsLiDC+Z7fveOZ/K/FEhQjaFmu1tGYCz/SlAdiHHNOn6tjyQpNm
         UzUmMlO+kOytN9aPV6NojHjyGElzH5R+Dr+9XvSrElOM89X+48ULGXO4Yj6Otuuj9aEd
         ZY9yLx3tRRbaGvbJrbXWJs6OYE18/4Gc38FdeYDAuC68qH8Lbl8+d/lmDTY6GLz8NpN+
         ZlU59NAf8RzLZTXz3hUm9WaTXz4ZcPQIJqtOqNt60xvXQEZMXeFMCX33AgjT8N2TLtNH
         2cIF5SjMCNtuOE8F41fOLBtCyHniegTNp/BrExplm4SjBrepf1c6S4a4EtA5shdiFDOY
         QLZg==
X-Gm-Message-State: AOJu0Yy8opdnybW8sjPsPsdsAu4aRBwu6eAvzj4PCAk5uU+Nzeu8Vt3c
	BOfnu01VA9XOt6/0RAs1YwU=
X-Google-Smtp-Source: AGHT+IFSQ9XY71v02bodO/WFjv5hAgW7/NbDaMC3uP7Ffkxdg86MrH1cwXgASC6B3oqeKAwRHkCLKQ==
X-Received: by 2002:a05:620a:2a03:b0:781:bf72:609e with SMTP id o3-20020a05620a2a0300b00781bf72609emr4171164qkp.90.1704738952367;
        Mon, 08 Jan 2024 10:35:52 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q11-20020ae9e40b000000b00781ea9404dfsm99087qkc.90.2024.01.08.10.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jan 2024 10:35:50 -0800 (PST)
Message-ID: <5d8dcb46-5c59-4b8b-8aef-fb1e5f826aa9@gmail.com>
Date: Mon, 8 Jan 2024 10:35:47 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/150] 6.1.72-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240108153511.214254205@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/8/24 07:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.72 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Jan 2024 15:34:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.72-rc1.gz
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

