Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1FA16A395
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 16:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734107976; cv=none; b=E9lLFL963h15bG1F4i3EVvt6quxLBRTGGgL23dWJyooWKn31gaVoLxVm9PKDrJbHKhdS9m/bxzFgMotigD/e2jxJ5NzrdE7olcwdTc8I2bcIzsCUSaADcje5DnAqQThtOGuw9BGK1abrWn4jk+x7lKHgWDpatBam/RF2krqU+FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734107976; c=relaxed/simple;
	bh=PK80MB2a82ILZwjtwJVBex8AuectZtBoackRA09LVys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LGhvGWc2uhxyio2mkRRs6kXfOiWnbnT4MgdIXFvdhZPytuKl8xwcjsWB8Mrmnxb9FiD+ZCILatl1NakhdNeFzivxzlc6i5nd2s1ewo/URY1p3js/05O551Ob1WvuWUq0w+kbEluBmDWeGyVn6uUubuVuGWVEk25ZZld3pdrgZqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaD1sGWv; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaD1sGWv"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-83eb38883b5so64699539f.1
        for <patches@lists.linux.dev>; Fri, 13 Dec 2024 08:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1734107972; x=1734712772; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QXrSQne7C8l3nSEcpBw0LjVsuhj/QlI2zejhfnriMQM=;
        b=HaD1sGWvZ0adOfivHFlW6QO2mkuqp4uQ8j0mxPElAY/t4s+bn0oX5qahU6ZngMHVmd
         IjeF1m2gz0KT+jZrssXP11G5ndbRr6jc+XtGclCjVUGPoHXM6aRQzp3juxdyno2RW1/k
         ZsEvzf3QCYacIu4TRMrjKAXdbDVicgpJsZ52k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734107972; x=1734712772;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QXrSQne7C8l3nSEcpBw0LjVsuhj/QlI2zejhfnriMQM=;
        b=DPnOC082Lxzkqygdf7MmBEw/YAI1qyGLKBKBoveL6vIYYFHECYNwRB22OAvq47CcLx
         LoxDSj0tO/gORcKHSmRvn5dPH7bTX1/FcqZJIHZvTUpdHz9s4cm5/XvjFN7rADppsqzW
         Znk+wwU/npwM3ujbUF2lDbZ9Jjjm6izInSCnnVEGvQVvdn5cAioVpWyFNA1nvOyB8knr
         FQyuDwcTFsOg7t/ORh38HAM7fK8R7cWIlHh9dGHVk4t6AxNnvJzMXnz/KV6HCdWPE1zS
         OSmW2N2w4KhTnaAo1pD2l+wZakBOFXJ+bKewen/ApXahn0f8/BVEFucrSd5dtVmPhCQl
         AuXA==
X-Gm-Message-State: AOJu0YwFycmAs9tU+ijfGtYK/f0X2IWbwfLpO4UpvbySaz60Mf03CgVz
	b6s9EzofwjmgWaR+z3cYxVDkZkDs1gp4qyhd77A0OlouosXzZtc3pgUHiBWY8rw=
X-Gm-Gg: ASbGncvadsg9iAsVe7wBTT9bNWOlRnRXqBuLkwj22qY+JdcThHh9u2F+Q204KkmdGFC
	8upep3Z3cj5acoURgX/2YsorAzq1ANOt2oTSnR5LxkSLfiMYneVk9p6CznGYA0Qlt1dy2j8EtDF
	xB0eQEX7Ql0WocA9h68KnCdqqjKfMw98HFfyKA38QhdKrCJj1TmiefaG77q62xbt++fd9YsRUgn
	SwktHWFrlGqFcdZged6ffqPOcyviCIahcQ9QdWctl1JGCGn10IneOdrW7zMEwwx2DzC
X-Google-Smtp-Source: AGHT+IGa+E1ul3LhwNTm5aeaCTcqWfKGT88TI9k6GZ1imc1TnoEYMDqfzRAhbIePITnmYUeDk5M0Zw==
X-Received: by 2002:a05:6e02:1a8e:b0:3ab:a274:d73 with SMTP id e9e14a558f8ab-3aff53970f9mr32030275ab.7.1734107972634;
        Fri, 13 Dec 2024 08:39:32 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a808d8fa7csm49208315ab.8.2024.12.13.08.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 08:39:31 -0800 (PST)
Message-ID: <26e5acac-0732-4394-9efc-da91630a0a42@linuxfoundation.org>
Date: Fri, 13 Dec 2024 09:39:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/466] 6.12.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/24 07:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.5 release.
> There are 466 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
