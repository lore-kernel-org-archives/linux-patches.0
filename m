Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331C81B29D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 19:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T7i1P7GO"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1c760b34d25so1139885ad.3
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 12:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696449289; x=1697054089; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ax4y6QJVKxvgErG0DcGbU2UbkVaUc5zLXMuWEhHo+wE=;
        b=T7i1P7GOYRjLXt6mRyQS9UhnOwNclA6pJT2LW/IA0tFKYkPjRE45Ppq2cXZ1ddIxh0
         T92PRJbhEQGHrBvPAyHs7bDnVq72S02zIB6EF8FeaLRaCnuIfh/F9uVlKg93ji7UgLvV
         GBXjJUtQInB6RqbwSr0KbIDxK2ziADXkYN4TEMKq+a1ye6kSmvTODZkfrfYetlLkRevv
         nJNpbbX3x08KeF3osdFj8XUYVn1yCeD7NwYzw5odEqVrU+S9JWuIPql+mRS7GVHor3Dk
         gKAgk/wtDVIbNxQyZUBWHcA9mEQKVeffLRScg+KuhSqQnaKk9CbpCaKW17YiTc8foVe0
         JtRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696449289; x=1697054089;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ax4y6QJVKxvgErG0DcGbU2UbkVaUc5zLXMuWEhHo+wE=;
        b=OXrWpKvN6A8JRQpFHKejTZzXUDKl66xspQEH7aKUYDoeoit/fxB2CAguMe2bmAUGCe
         guS6sK80Cdt4KqULkie0KNB6vsWV0n9ZrcZ/9KbBH6DAuG8uNvvhX7KppkxcS4fo+46P
         /SFZNDmoAczN0pCpCKIX8gJdBVbu5R5xyAQLhHqs27LHahfdYYI5HTQsFG56D/0+gGw1
         kDEOs9RAHrFL3/uG60P45VfvQMXXq/3ygM/nxZe6hRG/tj0uNNqk8aUQdOTF0vRkQq2g
         95xrvWGOit9bMiudMcaU/wIvuzvufljaAjfAzLVtQ3ZBzrjNNtQYNo7eRCJdVn1DRoJa
         s+fg==
X-Gm-Message-State: AOJu0YyXeQ8JsbOYIhFXtu3THObAqTbRWo0vxe75bhBA98yiNYUokTNY
	tAFR3bkD9gMcOOa5Vns9Grg=
X-Google-Smtp-Source: AGHT+IFDGw20JsiHFnweDS0H9QrL7hlk239XyTciYlW5aXJgPwY9fechyBtZ4MubexABIoLuFfh92g==
X-Received: by 2002:a17:903:246:b0:1c0:b84d:3f73 with SMTP id j6-20020a170903024600b001c0b84d3f73mr3861334plh.53.1696449289213;
        Wed, 04 Oct 2023 12:54:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j4-20020a170902c3c400b001c5de42c185sm4108203plj.253.2023.10.04.12.54.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Oct 2023 12:54:40 -0700 (PDT)
Message-ID: <6f182be9-c7e0-4ed7-a1b0-a431f3906eff@gmail.com>
Date: Wed, 4 Oct 2023 12:54:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.5 000/321] 6.5.6-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231004175229.211487444@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/23 10:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.6 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
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

