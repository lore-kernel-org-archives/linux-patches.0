Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3C848551D
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 21:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792012713; cv=none; b=d6CpBcZ5sd9nCmVNyQPVrs9KZOnEMMUYOOIRMGgbl14y8KaWmUG2mRBz5Bj1Zsh5NZ8c2SMosZ8o0GemVPhzxRMI9x+Pk1bJg05T8qynLdgXCdwVNDGWba1c0KEx0jrRKQxzNeok/y9cONcX2JMWKFt9w5pGRMJi0l4rxR3dBeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792012713; c=relaxed/simple;
	bh=Y0DvBWI+BZCsUB8TIe1s5HesTMuUsn2dMO58K2fiaZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dfnFhDuwQYMZAu/Yon6RsgdlipikgwSonfbz8kPZH+/geWTxzcoxQd/9XmlNFl0UAt1gb5VvHqjMkIjl8dNLVvs3elxAvZcem8kf+CX2e2eDWFYQ3IzUvVAJu+9vpHvpdM93FxZQ82MVEwxUh7kbw6oeXcuwe19nMKbzGbw4op8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MSJOw9Mc; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MSJOw9Mc"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93ef1a2948dso315274885a.3
        for <patches@lists.linux.dev>; Wed, 14 Oct 2026 14:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792012711; x=1792617511; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZQvRlCYoMMgwjA+XyVsNGaS2zRGK6+FIJmhvRdNh+DU=;
        b=MSJOw9McZBmxG+X2NTmBZhSTtA0qpyDAApduYP2jMo9o0gbgwihwFwJkG1BDHiE0i8
         srkAD2NpRCIwPf7suNHoT2H1FOB3N3aP3jBJJ1j+D2Zpb1FWtt/LL+1HKVlWL0mlXgLU
         0DehAsX85LrO2XTjWMH2heEraOUJUrHvpWmJPcreOFMZaRSQAtnAVFP4jFWbJJkLulqe
         7mxgVEg96CFQTJHh3F2iKkDtmGOOscIjRZkKd5TJTzxKFS3lh+fOKh/Tk7n/gCV54F6R
         tAk2302jZkuPqW+lE0wgF7CLWRANb5vahTPMiJHi2FtR1t2YbRASZtaqFbzu4AqdbD8c
         yPIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792012711; x=1792617511;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZQvRlCYoMMgwjA+XyVsNGaS2zRGK6+FIJmhvRdNh+DU=;
        b=Iro+xdremPzazwt9JzU+X521NwdIFvzoZJtbNH9LajUltavaHoamYbfr5M+wU7SRj8
         oJ1C8cC8+F+/tPTVDXoka2UK81lL5q8GycZWkhNspGcst7FDcEQBB3ixbPJYhB/EZikt
         F5nfOGqLlOtpTxAEsmZJjNxQ4Gk4FyY8spTshhTpz5rXPUJEOAy10SvgpTWwDr+akyMB
         /7EEFxzPyfJuuwoF8q65jAkoOyBeer/JsVwozjft87nqxgGgdHWXwrTK2Mw9igCEL1PK
         gEqv/dzkJP/CnJcRfGQIOhxZpCOl+H3Ide11V18RvXj/TtPzOXfmXrEspFWP9oU670tJ
         KL7Q==
X-Gm-Message-State: AFq9FYJz7Aq8ApV4MSRdnRg93nfWJjk4dzkEoWmGlFJcYBw4wST62Kpt
	Ex9hr5gd2/VJFmvMpH612lglK4FxRVex3bDLRngC8UDOKLzOZukb7l7o
X-Gm-Gg: AYBFou0RDAUlVUMqycy4bdKSzuAMovWQ0V2UzddzxMsE85PGHNZiyKRdTZ3qX6YRpI+
	xiRB3micw6VIY5jgt2rKF/3Fp0VNgnq21ekT3+LdapnG8UYoQkU+W2RRYYAhYCmrl1xOBAg0nga
	NhF/HyCvntfjUOn9GCX3gbG4d2jzfa21PgWGZ1iORBRkfEJJ4OzBwz8XZqCrD85HYyGhQVqfMMn
	xOUzfUAp1kjCgPWyvII9GU0DN8gKEnqJvcvE1sVHbz6WzsUuoEGMQ1BjELaCLAi+dATWroYn+Yf
	xa1UB2PZoUC6R/1/QPt3ZveM5Mf0v95nkN1qscatw66M2OedvoWJw1YuRaZvhwwJ6f2j3h9LkBW
	fEwc85pPbbYeQE13TeoCQU+2Go04ul8AW9WA1GcHV8qnAbSoFSsrxVOMOLv7+r5Kc/sv6UPcJ7V
	PztDM6G0hIcHEr7fGuz1Tu/KkE6c7rRCoa9YiffK5ztxpjEsBEimXgQkH0iBYJDxvFoaDDgMRjX
	mcL95NbQxs1J4ipPxqFQCmh
X-Received: by 2002:a05:620a:4552:b0:93e:5821:2c57 with SMTP id af79cd13be357-93ebd2244d7mr3063691685a.22.1792012710742;
        Wed, 14 Oct 2026 14:18:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef5051c4csm601360685a.29.2026.10.14.14.18.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 14:18:30 -0700 (PDT)
Message-ID: <14d347be-4ac3-45e4-9b5f-9df2fedcf6dd@gmail.com>
Date: Wed, 14 Oct 2026 14:18:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/632] 6.18.57-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261014123820.008483134@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261014123820.008483134@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/26 05:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.57 release.
> There are 632 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 Oct 2026 12:37:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.57-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
