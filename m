Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E246FCDA
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 22:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DQdjcppv"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6d9b05bed94so1001914a34.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 14:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701813667; x=1702418467; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7BIl/aKA2ZNDAhecAebxG1OpDsA1pswxzZOP5ytc8JU=;
        b=DQdjcppvKK1Szg0DVgmMArRtxELh1gyN2NhtNh9LviNR1s0FRtYPCKNZtq79NX8g34
         Kf49jM9IWgnmXNx6qjNXhPe5q5kRJI0zBhuq4ra3uftMEyMo8136Dg4euo8kvXJosnHq
         ArJZSBgHllo286+Ol22ysoaDNR203PSBkYzXr4OtOMC8UfKddePwnPyKzkK6d8tqC2Da
         ktmoXAayfuPkIzOX8Zg+/Prci4SSOQaQhP4pc9zd9G0njTatPaCGKJsw+5g/zseodHfk
         SSKhKfW+Jnq55Oy+ZvrcGB52W1Dq4WoGLrFni4ybxNhk9/d7o7gTT3/n+5SUnzlr9z90
         O62Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701813667; x=1702418467;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7BIl/aKA2ZNDAhecAebxG1OpDsA1pswxzZOP5ytc8JU=;
        b=hr0KMsc4vLgDlA1YiqY72FjtIlWpLdk6Id+45PmQbUJPOQNLzoMcrMBPLdG5T69hBC
         zXTZai/iiajMlSGt8e5swWJ7IV2/CiLzbPKJzxLPI5b7yV6F1qpdunLemUMI3oI9LnnC
         369/AK4fAn/N+pG1GWp1Xp/KZaF0mVti9LbTYkdGo61/MQG1UmJBRP7Cy1xP18Sn7Mwt
         +HAf8CBe7Py9e48kTV8FOyPUtHbAmOVtFTXqmnlT+mOw9r6hc1tldsvl1eo6t1KHdUNl
         9ssjZj4sg7Iul14jZKrX6JN4Lf1lmDAPb78K+jYkwkmo+50XotfM6WngHBYRTbPh0rxw
         tqXQ==
X-Gm-Message-State: AOJu0YyPsqFxtFpB1AcPsW3DjUo9rKiE/O30xNpq5RjpAFDpdaOUVvij
	cHWiQWpvmir4ubRyEkeTglk=
X-Google-Smtp-Source: AGHT+IG7st0GLhMIOr+Wll+/6m954fOY+eTkZAdBV6RjhDfSr8IXDFAx3nVYvp46966f/F/R7mF5Tg==
X-Received: by 2002:a05:6830:6998:b0:6d8:7cf8:a069 with SMTP id cy24-20020a056830699800b006d87cf8a069mr5818601otb.75.1701813667175;
        Tue, 05 Dec 2023 14:01:07 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id hg15-20020a05622a610f00b00424059fe96esm4671316qtb.89.2023.12.05.14.01.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 14:01:06 -0800 (PST)
Message-ID: <0f8a55c2-53c4-4d97-b2ad-e0c9cc30ed2a@gmail.com>
Date: Tue, 5 Dec 2023 14:01:03 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/131] 5.10.203-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231205183249.651714114@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231205183249.651714114@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/23 11:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.203 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.203-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

