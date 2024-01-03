Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DF81CAA9
	for <patches@lists.linux.dev>; Wed,  3 Jan 2024 19:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PGgfdvgL"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5ca1b4809b5so3247033a12.3
        for <patches@lists.linux.dev>; Wed, 03 Jan 2024 11:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704309342; x=1704914142; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=THg77ifkb1nWeoB2+qgVSINTgAapw6XOZvKpasqorLI=;
        b=PGgfdvgL42nhu9N919hZHtDST952yw3ZfxnQt7MqIcpgmuZWbvSxrk5diZ6ktgafPy
         EE+awR5y6mZ2OUVxxmMqWQDsbLjA/5se6cdOH/coDABdV/c88675jnG6LijlwXBLmy7K
         I7jkpP7L8qieH3OTxnACp0iKVe2y4K0qLuueLbeSDkeJDiDiLuqGTH0fSFDL3AK9Hkbx
         /+Pz2+Lq4vlEzw1toAcz6n6rM7zvBq4ZHj3sIfKTSatqQSxX66dSlyoNiJINP6LXQODC
         qYsuF9/zBmzIbc24NJXt63VvKlGLnb5CGlTq248V7ppJ1UCYjxmD53Z6vFGt5efaDpab
         inTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704309342; x=1704914142;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=THg77ifkb1nWeoB2+qgVSINTgAapw6XOZvKpasqorLI=;
        b=OjqI+0jVWcKU/jrfvs13MxbM82nmY+TpOUnaN/rZJGo1UfjCkTbJCd5jAHN+ObXt2H
         QBYaK4wr3HhFHpYjum/qsyh2KN4Jv9Nb9cLUvDgBj4f46OaRCwwcApSRNu6JDikJwMrP
         4m8m2GnOsg5U5JA7rZszeX0MGn05C779WnezPLABDUrmZ0ks80TiHeWXRni8lxY4Yghj
         afvZt7m2EqiDX3RmIkhClQp7/BTcEXVAQgXQuBHehIoVNLtkLFoY1USWHga6UT0C+9H3
         JCwXd6s4igIt/7vyxZYQkkdBmbwnKxmSqZIRBu5llMh+3LaCEPW+SGMA+9/moeWr1EQh
         xGqg==
X-Gm-Message-State: AOJu0YzguzvLmjVYXvRel0Gkd6RFw7LWCwEGYxYBXgfqmzN0I9wxn4y7
	HjF3kC5xbF4jOYxwYM3mFwc=
X-Google-Smtp-Source: AGHT+IHa3Md31dvmuaHFAtSG1dwhs2s1EzBoOiqYuNjpKGoKqEynfIKWI6zeugxZ4FTv85lFr45hyw==
X-Received: by 2002:a05:6a20:9799:b0:197:1075:b51f with SMTP id hx25-20020a056a20979900b001971075b51fmr2250052pzc.122.1704309341901;
        Wed, 03 Jan 2024 11:15:41 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id du8-20020a056a002b4800b006daa809584csm3473076pfb.182.2024.01.03.11.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jan 2024 11:15:41 -0800 (PST)
Message-ID: <9b783291-d6ba-46b3-8e91-8deab3f3f777@gmail.com>
Date: Wed, 3 Jan 2024 11:15:39 -0800
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
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240103164853.921194838@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/3/24 08:54, Greg Kroah-Hartman wrote:
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

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

