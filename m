Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936C04501B
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 21:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707858936; cv=none; b=JcjpVgdJvgSbLj7WUs5BI4AlmOGwXxXCvJc88K74e8NvWlk0lZxou7WGxMs9nT2GVQA2L1HJdNM2IBhdyEXoubLb+JVBSewcU/avdanp6fSsJRVNY9EuZXyUdNoOe/JAcgtygU90jwSfzJpGai3PqtLXsD9IDTm/dqIp+fgKDQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707858936; c=relaxed/simple;
	bh=EbEBam2DPhvqop6UPMlhU9nHqFEE/WOYvpjAwdknIyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BfluEzzW0MY0q+oWfYmdTkn2G1ZHPGvFB/Xby/6t2bNVQOCkW1Yfw45Wh2nq1tbxiqS7f6jwPk9zuRtYwRmPDQouTKwMqIgvB3hJLgnHcw552yOXr/cD34ME0B8DbqcER8lDwmeWN4T/zbqPH1p8wrdKo2Z85fzBRnQG8HIrnIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GacVvenu; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GacVvenu"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e10303de41so765701b3a.1
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 13:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707858934; x=1708463734; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xCH4mpJrtdkHcy5Gp3rBryy4KbkaCk76Oc9ftECoQB0=;
        b=GacVvenueYYLvuJWQrd5JY7JSULFTY4l1gajXhBvijg2HDFaSXL+VICbU7TntgYqNw
         5sTvf1ghSxAM+unBZrwSNQrYzS0QuxWLxCBQQPJzOrUHO0opIrWvMHE5aJ/8nYCUujwF
         BhZTxNS6xtwIlS8vxwe+K/RxM6zGg7a6KiMHXyor2mahUH5arTp3LfrZjYs6eeym8El+
         /D1qdNOpF3TrtOF8hq2e6PaKdtVkL6It2fVUrpxFCFxrF+iFZehQpfkacP3U7D3XZgQV
         gDDjpx6UaF0fi75KhV1ESi2g64Kkqg+Q3I5EStqlC1lS2GrDjQW3hkb+1cuU03zC9JhW
         K3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707858934; x=1708463734;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xCH4mpJrtdkHcy5Gp3rBryy4KbkaCk76Oc9ftECoQB0=;
        b=WJBKOJNRfjOWj5vsVwhYe209wW+SA5Gcb9ZPOr9V4q8KJ+ZTHMXRjwgPukSY2st+bc
         KJi7zqHPN3CTjTN9rWb+Xu4Z0dXRvZZZzaHWTa2PgaTvqL9ha+HO8tXM9rN3nwE0mI4o
         ekIk+Na5oE4UsDDa7aKlRXHt2KvmgzbJjlfZAXwjYv7FGpxL45U8vo6/UnT+SwWTB5XN
         4JWHO5vGN4eRR1+vTFWmbNJyQaXx4SkutviuN/szhTOMwCWCXeWf3Yp4QyX2/UHQTx4v
         28J+DYakknakTV4aHklhRICKFEMqAVRx/jL+ExsPSuFsoGGuW3DY9GIXEqi7Yh+ZVIA5
         aIwA==
X-Gm-Message-State: AOJu0YykFQduuQEEWzxWj9ZwBxGjUlbFwN/FtO6xx/W+MxswSw0pDiSk
	KINPRGf1MWilVmNGAv1QMrGrHsvS5yLArKhEOe9VnsKNsPAKUYsG
X-Google-Smtp-Source: AGHT+IGMozuO4ZP0nMkADvUX4ufkSliK3mf9oJHd92aYPZ65CwU4TZenkgsud0N4B7N3eB0WZm8/YA==
X-Received: by 2002:a05:6a00:9381:b0:6dd:da40:948d with SMTP id ka1-20020a056a00938100b006ddda40948dmr545635pfb.25.1707858933002;
        Tue, 13 Feb 2024 13:15:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX8XUpZd/YAPzW6iYQ6tCsx5stATh8kC0YbNlBIcaDgobZPKh2cA1T2EG8lJU4QutuO/nhD8Mt+huYQP19ha4iF4sCUIa1Xlk3OLK+/L1lWnEIYGYMinF4+RGT+ET5R/WFU0UVLhCNykVM9GYZTQxOsW/lLeTnER8+pxGr8Upg57yc3JHyA0L279wZCQAAAETRGKSMI2vVFm0NGRR7nuC75FzzXW06J40pM3RYQSrmPRNDohtMPCpe3KWignFkC2t9BKKXt3NG5/YeXa5JJbzUyxpJ6OykYZo7Gyhyrc2GKE7guaafmYRUzXG4+3lrS7r7LnzIQQ6CVnMaxg1U2/xTDkJnoz8abMAUmj/6CgfflwOUQ6ACdpBDV0yms88DVuxEUrUkZBzEBi+bU+DUFMtt6mqf6Sa0Z6CwxaIRf4QC18PiPHuPvFjnW8Nk3IEJBxAfUIANl/zKBRDNz/2kjfPddO9PTtPThK5SQjG5I285XJP/x6WYo6tg1LkNGSOj/6rVqv/9EbJ1K
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q6-20020aa79826000000b006e07eb192ffsm7838008pfl.44.2024.02.13.13.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 13:15:32 -0800 (PST)
Message-ID: <bc81f220-8e88-47f3-b8a0-fc4ea23284df@gmail.com>
Date: Tue, 13 Feb 2024 13:15:30 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/64] 6.1.78-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240213171844.702064831@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/24 09:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.78 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Feb 2024 17:18:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.78-rc1.gz
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

