Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E882F156F25
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 18:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712688340; cv=none; b=VGdHZlD6RbyfwA1OP0tP2mMC3MZGrA25Y7/w5zcsRjzpdc6IA+ZXMF5qE8IPJ2jnlqeKPc6lZutn9thuChmtgjKByDpf9PRHxF41EUi4aIIm8rd/XQeg254SggWKTlTg3t/iky7Bp0AdS10+Yfo3KsnWVAzMTCkxT6prkK4n9l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712688340; c=relaxed/simple;
	bh=aNS9kIqluXJjz4q/1vM5WvxRYcJ3Gjql5Ytlgs2X2rA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vj13nB7d9UvIZtC/pcUQ/SSx/gmcQLZBileqgq/Oby333EH32kqQSU07AW98x8W23d/FUYQrAnDBYNlaQit743CUlc2+q6YMkJi2UYPwRsukjBAgmOyXanpEcvnXAfvxv1DcKMXlZtxSVu7H3MSssoqjX6WOn4cb6/m0GPuozPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iECtMQuV; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iECtMQuV"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-78d735b0756so62278785a.1
        for <patches@lists.linux.dev>; Tue, 09 Apr 2024 11:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712688338; x=1713293138; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b7IjqPDA7JLGylYObYo4WBmijPb/Bsi4IHv5IPatn7w=;
        b=iECtMQuVW5h2WccD/a9CuLkNvA3T/MaGlDav+wyfpddgdRfl1EB2KHSVJmj0fBkKC4
         MCHaVLTohGwFjNrEANDQK/JUMCY03m6xB9Sk8DGAJ+ILvqm3kbwW4J+/dRKqoff8rMvN
         eKfnlfcMjBchFMmCk2SSG03ykwtTh2YqyqEAclA56lXJKFJVp/bi/68hXb3/OqfXkGsk
         2KL18rV3sVzWEV5V1zaC61B9k/SQWVNRQM/y06J6mo1I8NsfCVJjFu9IrtokZJUzsaAJ
         Ft+PkLakCCqyo8Oj92CXrLptFxJs/HTn0uc1+IRRB9AZFGje9FUZeZx8287hDuwwkPVW
         ypeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712688338; x=1713293138;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b7IjqPDA7JLGylYObYo4WBmijPb/Bsi4IHv5IPatn7w=;
        b=fz8ftwjVPYpmRGXzMpwfQkMYCCEFOvemXuhh9wm9xtIKyOz0dQPdJT6gUCF5eoxC/U
         FLdkThSpcjEsVEcSb27hsSUFx1YBwbpk+lM2APtAaM981jqPhs3M/BAnRELahfUdjxuw
         lbo/HvsCh4WBTNHJEJS3CI7+j+XM+MLs/kJfgOuALuWqb4lekfxRy4OV7Fk6KQdofPSq
         OdKLcqRAXYJBIR072Iks7mYx4xAGs7149aMkbfJY9WKQOPDDD1RBDKFTgf7zbHfj06xY
         9u1uT0+vDnJkIYQ/J+C6j6Oc6S6qXDnX5J3wIFu1pTqvFtgxK9ek/DJSBFZv9yWhO7Kx
         H75g==
X-Gm-Message-State: AOJu0Yw4QB/jMZWHoXEZxq0t5j8aOEKwZ99QoEtcTjlreiOBRYiy+Dox
	9jTShDbR0xhBJ/7RNNPWeOzUiH7f+MRlZNmJujTcfgkx/S4NjFon
X-Google-Smtp-Source: AGHT+IFTNJFcm/AbtMmQopn2FsGx3oOyU5YKw8xMOrSNNSt+8hcWvgmnGvlaykxLNYHML+N4/HtzDw==
X-Received: by 2002:a05:620a:2a04:b0:78d:627e:1aaf with SMTP id o4-20020a05620a2a0400b0078d627e1aafmr1028849qkp.31.1712688337747;
        Tue, 09 Apr 2024 11:45:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id de14-20020a05620a370e00b0078d73533196sm586903qkb.76.2024.04.09.11.45.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 11:45:37 -0700 (PDT)
Message-ID: <5c6196b1-4c19-42c7-ab23-133978f9db77@gmail.com>
Date: Tue, 9 Apr 2024 11:45:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/697] 5.15.154-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240409173628.028890390@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240409173628.028890390@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/24 10:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.154 release.
> There are 697 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Apr 2024 17:35:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.154-rc3.gz
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

