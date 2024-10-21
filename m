Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF7F1FBC81
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 22:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729549997; cv=none; b=lSa3a27z0QccwGdqwQ+SbtqUywj0N3fSod7Ck2un4ewdky2qQjhucvA6vb9fm+DieAGi8qd4+7m+YqR6I+wbiX3CL41hJVZszvEm3fs7czn3rRJjNWSBRMN3oPeG13MqQmquzydIROruB9XL8XphyZj+pJIz080s/2tgNA4Axz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729549997; c=relaxed/simple;
	bh=lrwrnJ9sxyVS/b/WeRQ1zGC+n8IdJHwc/MYSyhOj034=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=orw+7IKxbEjpIYtgT7BqTH+ldbligwWjQBQJA7IDapQyO/vqyxo/L2UT6Vy4/9/ZpfTmG26L9mKw1kxyKNmcKD0JL1hRZt50h2dhsSmeCzVshjbj2rmNwf7CvQY2Iu8JV1J+dmRUuu65mnhux+PKo1fecCjoouN1wLaEbyuEnbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhAemBQd; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhAemBQd"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a3b63596e0so14682625ab.0
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 15:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1729549995; x=1730154795; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uml1sKj+kvUwOGLK6/8asmpMwnvEywtfjt6wk3MU/qE=;
        b=NhAemBQdD1oFk8Qk1QHecVGWha6YHKwZOkkOpK3hXPRnMiwFmF0yal1HlDXZRJaSdg
         ZZ+6sFVp1BnSA+v0tydwJGdAsivQ9Ez0ZGMsBzkVSMLst+Uxa16YaFshQY4AaLizHrcw
         h+T52RJXpsTieXimE+SxNSk/QRIs7WCkn07pk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729549995; x=1730154795;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uml1sKj+kvUwOGLK6/8asmpMwnvEywtfjt6wk3MU/qE=;
        b=JlM/NyHm3cehcIgQFUa+VtiE2THlG0fCuLorymwGKPll21oIu5BEcGmopeqUgx+pEV
         LHEs5OwcrO8av8Lfr3KS9kVU5tH/jcp2XLecHDXtNmV9/uN82TU84YN8Iu4kScTa3h20
         TqZ7foKIZoi8Nrt+Mw8ejXI3ttJrTo5BARcqErrbGMdTD6DlmRl01rXGCucUWtMRoEm3
         pJJsbxXrBgSNJe/+8j8ZPh2h1+b4X4XZ4bvS1r5270f58b8O2NS8Gbufk45+V+JspXBu
         ZswupZtUCnSab6m39Nrb9FY+RGzjs0kliYYC0zTG2LeJblZWb8SxpgCeSyUdP9TadKYK
         mXUg==
X-Gm-Message-State: AOJu0YwyT4U1CmCRrfcB7u6quapHwZfU33P+PstFHZgpHaroYs7pW5Gx
	yqTe4jgLmNWXEkY0peVXSjq7SaMOsUkuOENX/62B6Zq2aXo0feCboTpK46Esmbk=
X-Google-Smtp-Source: AGHT+IEJprBi/nPg63JepMRPm5U+FNcv/3C07TNfOCy2tNezSx/w6E0jpGj3z7mxPWwwP8k1cseGRw==
X-Received: by 2002:a05:6e02:1e07:b0:3a0:ce5a:1817 with SMTP id e9e14a558f8ab-3a4cbe359demr8268155ab.0.1729549994578;
        Mon, 21 Oct 2024 15:33:14 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a65c936sm1258671173.157.2024.10.21.15.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 15:33:14 -0700 (PDT)
Message-ID: <86e869fa-4435-4fe6-a669-4b7a6f1f78cb@linuxfoundation.org>
Date: Mon, 21 Oct 2024 16:33:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/124] 6.6.58-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 04:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.58 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.58-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
