Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F1730CDB7
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 19:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756238146; cv=none; b=XOiZxEucTKn1BXzMIKbLNgT+1er7a2o69s5qDq0p5JepI38q8zA0rZwdxS4oSF+36YmcCncWKdU875l09CAo5zNo3lw7nqns42FqX96NYP7F7PhG3JsZAhuJGeBJmMxucTq3uxAeuSTR6A+U3rc9dUL6P7TmcJ+qyqGRWKDYlVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756238146; c=relaxed/simple;
	bh=Vpfyu4NPdnzd9uqNThPbF7jiacLNikWVgUA0cpZAZc4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lWy4LeF8ERi4R1yVUSxLtCQ+2eFHFIGV8pzHs7H0QquW6SbyMNTSNYu2nXhCuhrzbg9aW2NuN+vF4cbHVRtO+/UP9w6Yj80PMWeOHQ37FMDbKM52fXNbpsN9Cz28jZ59N0jSYFKP3UmkosgqZglZuwlC61uaaD4L9I/Evk1nVZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mfAwz/PY; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mfAwz/PY"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b1098f9ed9so44022931cf.0
        for <patches@lists.linux.dev>; Tue, 26 Aug 2025 12:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756238144; x=1756842944; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UVH8JQ7MGDoKY9UT6JkPsJuZOOfQY3APeyp3CLg8ACs=;
        b=mfAwz/PYjJDKIwJm8/3PrlVY7FY/fMrB8x561Kjb1Z/iVC1rkPAIIF7TO7zz40HAju
         qdXUMy53WpA2byHCNG5vC3IxYBLc2Ptoq2JJM1bQ1PKaG2AolfBgSsmcj0ntgZDBcIZ+
         hBuPoKe05wJJSfZ8mPkoqM7q95a8PtZlVIO8vpqLypKnOVMy0yB22B4tV902MtGfy72s
         h6FDF8e9OkXN1FDX1EiYKuDJK2280B3e9aQDOO94SUAPh3Ww47/QfAatxQ1yNby677Lv
         sr9ICpHDBGedxMcJgy1Gt0UR4INyBKSMTt+D9QU362MOSR0Z+E5XU6J0+cRjGbVS2oGv
         fARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756238144; x=1756842944;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UVH8JQ7MGDoKY9UT6JkPsJuZOOfQY3APeyp3CLg8ACs=;
        b=SOfiXO8fRbnD662Zv02LnbSNEPqxuMB87ZSr93MYYrksJcry7OWJ5EaJENy9AB7HaJ
         PvBbAX4/CYoZbAI/IJG0vcH1uDYpAZwWcrXuj9rEp7LL0Ns1COV/82xq0xBqXynbg5XC
         d2FgKJQUxGT4JuaQvBW0dgeyfpC2ldeJ0C9JQHiXCPg99Hj3YYXCkCAGDN1RpzG98QVX
         FqM2BDa+uw7twNpg+kkgbHKNk4W11hGGrBDPErjgZSYazh6DeH8H24aV5org49opHMrA
         GEy+ay7bnGG/u6snamBAgNWk09jHbBr6AEM8vFycLaCyYTAtuM52svPbUzwOR1x4QqLf
         wELQ==
X-Gm-Message-State: AOJu0YyJ+0p8DdUjMh3HTe0hLiUH3kJcahLJAFqJOusig+oyzvpzqwMQ
	J3yVizwkb1C555d7VCYyX1IcCudEgKGc80/S47hXekkEz+AcI3myVvxj
X-Gm-Gg: ASbGncvfMSvruTsHh6CrPFm57tnYzJF1EFV01vV3Qrf0IDsKBzjWxeNGkzAyXejrgee
	bXqA9jj3ZQG60+X5GBWhGbhFXXervjvT5IXlk4h1gq+2P4t71zGW/qqAyPspmYpRJmoy6sdC5Ic
	zWgXZ10PLIJksNbHNpllboV9Ilche0SMCfeWiRpwZ0RRP7t+TyelK90X1Y3hrg/XMcRtTLKSYrp
	R/nTNOu5J9pfGHtyXjwI2mCJNebnXjVTapfWXjeEx6yHOEOJjMIfuHGUsUj/7bedo7s+3G/Tc9j
	moui9B3jsCpapk+96jahGvqxZmLGK4ELpqG5+uA5J1O7GpPWkQ310sUbfN6xjYpaEjlvMyX7lbS
	APaEGJ1eLSvjA4iMug6mzJNw2rLexZRNU5uyLZZj/R/qvm52Gf8drw7f/51bh
X-Google-Smtp-Source: AGHT+IGjmrGHQ3/F4QIMSDClatJx9+dntn9vE+x444jydG55BysUGK2+aizCRI+SQPY3+J/XVWrjYw==
X-Received: by 2002:ac8:5e10:0:b0:4b0:b7d2:763f with SMTP id d75a77b69052e-4b2aab20bb8mr207016831cf.47.1756238143872;
        Tue, 26 Aug 2025 12:55:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8e70fd2sm75011751cf.57.2025.08.26.12.55.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 12:55:43 -0700 (PDT)
Message-ID: <70e96b60-f449-4455-934c-8447f968ea7e@gmail.com>
Date: Tue, 26 Aug 2025 12:55:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/322] 6.12.44-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250826110915.169062587@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/26/25 04:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.44 release.
> There are 322 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Aug 2025 11:08:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.44-rc1.gz
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
