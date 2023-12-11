Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEF851C37
	for <patches@lists.linux.dev>; Mon, 11 Dec 2023 19:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E4fCoJcS"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5908a5d4222so2359772eaf.2
        for <patches@lists.linux.dev>; Mon, 11 Dec 2023 11:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702322245; x=1702927045; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+ZEOt5yTQPrFy3hfdqmgP7F6Z7u2ECJR4HRXNBsOBgo=;
        b=E4fCoJcSK02RP4POIQhvFpkcuJuCC/Y1Wk1TDVfv3Bk4rNUJTt+gIeQxIqJrEYjkwl
         cXv36RGLzPgZR+36SfNJtweCle9Lkxi//pRXxNeCFcOPBrBQmqHmAJ4adMTnZ62o1l35
         cc3xbs8pqsthU6J1JmlL9OAaovu4Yk6Rwmwf7SFx+TkhTTGSWcJKCqxW/rjPDnJUvDoB
         CmK7sNfK/leaugtYPV0uIwatgiW7etBUXgSuZMacauBRck2EqUM5yVMssE71Ixkzze2d
         ct7oBqSInkYK2adedsjNP9ZOm7HVKSvRS4PWDlLntC6r2OYjVYIgcPYtlc3yVDxa/cKY
         gFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702322245; x=1702927045;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+ZEOt5yTQPrFy3hfdqmgP7F6Z7u2ECJR4HRXNBsOBgo=;
        b=HJCI5dBY7xhJOJnmWQrizqB+XLaOkkkqMeBf7zIjmELUU/gLj3Hk2K++FR/IZy6XJf
         AcMGEAlDbsCP22AXvRTo1mWA8vEITWd15yiZtRvRn+zI2lrPu+rCX8egimsUlxVsOJTl
         6agj4aRk7RMj1RG08IikkPu59pi/bZcpwLaIo0riycMPayZFdEdQylLDF0gJlwAYcJyX
         vtGu/pov3uoq/pIp5MOM1FRBJpIifK5dqov5jEzCLACoX6Emoxg+WfAF1QT9j6M+XWep
         ZHYQTCvAoNlOHjr5Pwf7lRZWwl4urmWHuI3avUC8Lq/QXZ4Zi2XknCkYHAFdGVfO1n52
         1w0A==
X-Gm-Message-State: AOJu0YzeAc+1T1lNNoG2JOt4WPUZ6R2w6C6tkbJASQRSZNLhm+bcX6id
	OU/9p4Nz9sgZhwLdDTd2xrw=
X-Google-Smtp-Source: AGHT+IGMffK+4fGed3ByrNcSTaR9TiAU6EQW9eZYutuCQshnUEbfwUwoDjlvUoERbVwB2u3pQ0vzNA==
X-Received: by 2002:a05:6359:5e95:b0:170:17eb:9c53 with SMTP id px21-20020a0563595e9500b0017017eb9c53mr3911948rwb.52.1702322245416;
        Mon, 11 Dec 2023 11:17:25 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o63-20020a634142000000b005898df17ea4sm6712171pga.27.2023.12.11.11.17.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 11:17:24 -0800 (PST)
Message-ID: <ef53615b-cd47-4635-b348-eede25802527@gmail.com>
Date: Mon, 11 Dec 2023 11:17:20 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/97] 5.10.204-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231211182019.802717483@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/23 10:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.204 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.204-rc1.gz
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

