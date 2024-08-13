Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C48A1991D8
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 17:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723570404; cv=none; b=m4SwNTx4Zi27yyt2t5ZbhrQH6tACRfmmt+RJO/b4+DTShqFQypCp1k+JTPC33Wh6DKnWiQZecaR7zyejhGUQ/QiPm4uD042u4LC66qJfx059Fw65yEeyqASN4+EJjLgx4KAG/O845P7HUu+Oc64UeG7aAusE/Gz3q8VJOgdIXFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723570404; c=relaxed/simple;
	bh=NippkUP8S8P6tmv9MWO/YV21PyZxIiRkf0vTLiatWHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r3fnRUEePV0h9sSAHaqmjSlbpQ75h+8Ut20m7robjGRR02dpJVeNyEp8yxBrd0Cd2t6I6wIZ3E5EsMAItlyPNfIovPWeDILYCzFRUYW6lFYMEb1PDVDT14r7H/3Mz/Mrfjj8ot8h11kbh+jvKWX3XvCbUR30erpXtD/p9Tlahwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ne43y0GP; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ne43y0GP"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7126498ad4cso416869b3a.1
        for <patches@lists.linux.dev>; Tue, 13 Aug 2024 10:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723570402; x=1724175202; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1HHxSyDfeWbCkXYqvZXREN7pKpypD1FMvFzppC390k0=;
        b=Ne43y0GP49U+1+8mWItzPiDBkttaKCszyXpcoc/WJAC2EDA2EFhurGRIEu/3Bm+mSr
         SV4LxWKFPolVcXjIYF9jD987cgzaUmok/eVd5q//qnPw8Z/ACOhIh6qw1pSOXRWbauLz
         KNZQCs7QP73BKFA/OhVKBpBy3iCfO4m3KE51L6+TaJ+deS+UTrXtLnnFgYM1wp4RWZ+8
         jqM9VVL2fOM/MkQYKC2hNI3obA7xA83EGlxeYT6JRHV1fBUmN/DCmhm8qUCCXE4ZQ7/2
         P69o2AvSRiUGl9+jB0Gd//GzbGQkY4P7AdYZQkcjhH+5b6ij6DlYGKtBqkTH9Rjid9sB
         koiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723570402; x=1724175202;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1HHxSyDfeWbCkXYqvZXREN7pKpypD1FMvFzppC390k0=;
        b=PnsUw3iTMMGHcymmp+IFOImwXdwJ/ASR4jMiZjJpAPXWAQVI/4zhEjTOy/HlR3hRwB
         Z52Mg8xzeHwfFFF1aP6TA5g0rsSJzhG8cA2Tr9Gw6cbARjvKCPThlHP4tI7J6XEVHWuI
         vjbCE+O3lspPK3efDfa0jQJ5e2WM4f1SjGJ4ws+nEoNgzYuZO8XJMeYdFpujV9HiQkCs
         OToqs9g4NkroWkSxHn06nszVGVv5hiizqsWpLeMwexvPaJkcUDnn8ELf/U7yW4GFFsVo
         bKoXUVSLqMn0mxef5GawWfkaWrduuGfHbFK9vQhMTFekrARBf5rCwAx+NHufHr9SE5rr
         1MDw==
X-Gm-Message-State: AOJu0YzP9I/ubm9uXo60/QyxafjOHD0vDg2K6f/LIoGS+mytkjRj2L0y
	rtvSPkY1lK2fcbLgFdEq54X3alj82+X9FjMm2NAFuUuQOgZtAnKR
X-Google-Smtp-Source: AGHT+IGa1SaY3ln0jbsWCZAx6W6HgJvu5yyS++HH3R4q3AxSmm4MUhbWEhhkRTsOCJ/F6m27oShQaA==
X-Received: by 2002:a05:6a21:3a81:b0:1c8:b10d:eadb with SMTP id adf61e73a8af0-1c8eae81196mr594808637.17.1723570402320;
        Tue, 13 Aug 2024 10:33:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-710e5a43948sm5986814b3a.122.2024.08.13.10.33.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 10:33:21 -0700 (PDT)
Message-ID: <e2f49750-5b64-4adc-9989-e9155fe2a729@gmail.com>
Date: Tue, 13 Aug 2024 10:33:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/263] 6.10.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240812160146.517184156@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/24 09:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Aug 2024 16:00:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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

