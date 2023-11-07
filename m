Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68AC31581
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 15:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7Pgt9T7"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7748ca56133so56754039f.0
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 07:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1699370902; x=1699975702; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sft1C3A6T0DctjsOESWwGHV4ahcDcNNrlDQS0ASGVvs=;
        b=W7Pgt9T7QiNU+IruQWW0m1K84TG7V+7aJcMcRpok1hnmfWYjenLKjAGoHVSoXHrAq2
         iFlHQ6XKNdwbt3IGUMT9Zvt20gdTyPgRDoycjzr3EyvaqM/yPRDmheSgJ/tCBPDKaWmu
         cqnEui2GvpkvxmGLl8DjVNDssmRJ1GbFtWKtU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699370902; x=1699975702;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sft1C3A6T0DctjsOESWwGHV4ahcDcNNrlDQS0ASGVvs=;
        b=ZtQDIbn4c3l2ddaVDZ7f2KRu88dCAUGiFw0+Gz3AlwAnu64cqiW7PJ2+KHTWYTLxo9
         co2OtvMwVIvvv6mUAfZz3B6vnwLNqM0PjmMVeVOajWb+21eBOq+Vd4Kd4RpcVl09O7Iw
         iOXfJcRP2D77zaFsX/vNJVAMRN/V+1PP5d6YQ35C350spCSksh/HbRQtV8ovb4opiDu3
         MRa2Lmv7Q6OMxYC8ju2+KEgMUqSw9oEXh+qyNtWuoiM0JpVlNv/sKEdo0f5GzDlhRC9F
         reh5qnxOi7n/6tl5mrwC041t7xLlqfrnqk4rttXvGQJlXV/Xts7dkYN9VfdsCCrjRii9
         huCQ==
X-Gm-Message-State: AOJu0YziISTLdAgwDSnEqorRr+ytH3TVMz/4hpl3qbffSe4tRrwR5aKi
	4W0H9UekHK7Il/GJCamBC4LiuQ==
X-Google-Smtp-Source: AGHT+IFU7vICgMkTp/5tRvxQt3mPkK29vnkQ3Rl/QuzAD4dk8abYYXL+kDAVSvhUUsnpGOyLf7g1jw==
X-Received: by 2002:a92:d08b:0:b0:359:39ac:a161 with SMTP id h11-20020a92d08b000000b0035939aca161mr18294494ilh.1.1699370902738;
        Tue, 07 Nov 2023 07:28:22 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id db8-20020a056e023d0800b003596056a051sm3201829ilb.71.2023.11.07.07.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 07:28:22 -0800 (PST)
Message-ID: <bc65e6e3-ac1f-44de-8872-13641cfa8751@linuxfoundation.org>
Date: Tue, 7 Nov 2023 08:28:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.5 00/88] 6.5.11-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/23 06:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.11 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
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
