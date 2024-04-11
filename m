Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391B239AF1
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 21:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712870807; cv=none; b=R1lKH+6VNjPzHOKzTQ4SDDeYdZ4bOCLwwEqg72MikpozBZY4miSX0dzXRs7iXnNiBwcvzg2vR4KvJKNYhXpxeXIgHhl52BNfb5V3F6bv2EHrn9EooZSRGGgYYOFkqIuqlo0+c8+7k8liOehK40A6QbBd3rQWa2qoe4VBkdLdDeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712870807; c=relaxed/simple;
	bh=dTe7FkItBUZI1l41myPu0rwtwFhiq0cNM2woC0XI+Mc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=gEy/WXwd5mQlgLS3ySl4TMKo6KYE/zup0rlTes+Vux3xm//FtkTD7Z1EsBMKuzKQXX3ft2LO8E73ieV+lFJK+zw1g0t+VJApgDLyPW5H2gs9Sqjlf9S5n33F39hxZgWBfNmnhpXh8aN7NyxZWynRrKo/C82Ctyu90zZ2+bWY8d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QUOGLQqS; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QUOGLQqS"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6ecf406551aso262250b3a.2
        for <patches@lists.linux.dev>; Thu, 11 Apr 2024 14:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712870805; x=1713475605; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Gbf/39brftwXwA8DEazWrbnV3/FuPWeJ2MAkVbGs5+I=;
        b=QUOGLQqSIOMiho/S6uEShnbVUP5qyOWn+9+36GySsH5jiCNXzjeKTgjre/sqS84dsb
         NwoafpoK5uULlLP81zmWkTRh87S4odNOEel3rmfaBOtVn3u0EztDMw22oo4azGEhyElu
         9Pq/0IHfybTIhblm1E34uFBdSNg17j6mG974hyvkjyGKbzQFrdVcNM/BPYTDw9iKnQWR
         FdIuKNGdRfU3IaquoYBZyB9kGrHrJqIi4DsRYtHc2+YrUsxCja+fFY7bk5QqYrELpGhY
         b/lUST6xwHOc0LYTfHKZ3v9YmaMadHekpCTeSJdSs7duFdxKTLoUymYQGGMvixCimcsD
         Kl6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712870805; x=1713475605;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gbf/39brftwXwA8DEazWrbnV3/FuPWeJ2MAkVbGs5+I=;
        b=h8AxYPrcMHwbmjc0+yIZJUQHTqsktOS0evqRKEmtkqBcZexjOm/FE9rR07QpL6g+XR
         XAmdr0pPYEO1xKP8yoaUkkMYclhpEOyE0l/+XAp0h20FADso4f3qk7ZQ02Ug14UMsYrz
         JlOay0Npx93EwffkZxcAFi9gz0jgcTwksKnNfyvXVf0yPk/p4zPbMOfVId1EnghEU3Nm
         N+JE2Vj3qw9Fy6Z6hBBFvua/CkqgST41qLlowOhLmg/LpHO3PKt+naxBIlYu3CwhfJid
         2u9zsn0oO9YiyMBSJkdxi74kEk3r8SqqQ0qVMxu+tM9dScI1VY+bMHiE1vgMZI9wfNAy
         eKcA==
X-Gm-Message-State: AOJu0YyFjwkj02nNoVFLeGP/HpAmW4Hl7A8roRchDDCUTSrinSbwM0fj
	SL/GIGj5E0wKqRy7v1vOP25hTGJQ0cQtflu49zTT98LiBYIsFI1P
X-Google-Smtp-Source: AGHT+IFEjsGMBmJN6OEXD5BFBpztYTefinZEo8eD5PTbhOvhMO1g6CNKipz396gcfmsNN60L1LKe1A==
X-Received: by 2002:a05:6a20:de91:b0:1a3:ae12:e610 with SMTP id la17-20020a056a20de9100b001a3ae12e610mr1003741pzb.35.1712870805378;
        Thu, 11 Apr 2024 14:26:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u32-20020a056a0009a000b006eaf43bbcb5sm1614913pfg.114.2024.04.11.14.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 14:26:44 -0700 (PDT)
Message-ID: <4f1d0cc5-6673-48bf-be4b-7b7978cabddb@gmail.com>
Date: Thu, 11 Apr 2024 14:26:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 000/294] 5.10.215-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240411095435.633465671@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/24 02:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.215 release.
> There are 294 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.215-rc1.gz
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

