Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A57243149
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 23:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gaSAMt7X"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6d30d9f4549so119613a34.0
        for <patches@lists.linux.dev>; Wed, 15 Nov 2023 15:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700090765; x=1700695565; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=axWDgASU5kx8BQUPImQQJLs6vIRAi23g3L1V87kq5xY=;
        b=gaSAMt7XW+6SycC5Drv7klqADE97AnSWJlZMZp40d6bPkg8uHg9HJ+mRx+IYCVF5by
         VRegjwxUPtL5st8HWI3TU+rOQEfWC2iTpEkJlISNyYpVhfpOIONsrJwjMtB7A+fG+Xyn
         GNkXI0bSu6kzXCdiY942n0Rffu2U9APLBnW8ufNaj/AUUnTWfZ3yUwVdTCafIaX+sAaq
         mwy/7Gyu2k19ciRF7SoP9tCqXkcX69+lADsKaOWCiQM8aFadn+7vS2J8aOKCPvr0KVQ7
         CsBPp1haBO4334DN6NyUlODdJSLCmaZ/ed+FKpxSqWzHRkNdPdJ2pXsQNsLH7dJbGnZD
         tyiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700090765; x=1700695565;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=axWDgASU5kx8BQUPImQQJLs6vIRAi23g3L1V87kq5xY=;
        b=F2RzKj11VmMGDph6FH7Q349vytD/V8q2q1DsKhQXPk/e3DwXsGSP13cQdy5YknW36y
         f7KUlga2HofS3PQdvy3hNleEucXMMIywfOe1W4udL0mVIMg6brRWWoAJwA3VetDS9ySc
         zbg2BpuAGpCNt0k1JuU3+lPVBN4h5PEY//f/TUwIHGG2/1kyGy4160lClXI3S2qJ15EL
         Ao8njmIXI5tXGRhHfedhcRZPsnCUYVHqf81E6olZosBDpnHWl9xyIKg6RwJf07jt4lDb
         ANN/zWqLxSChSTmtnuNjPZXgjYJ8EaEd55qQoP5i4tn2ZLTxDf5zsCLVaSsyPkg9BwAy
         Ro0w==
X-Gm-Message-State: AOJu0YzaQjUpAOjOs/t881DFpwo/qa2W8Uz6vQiqPoUV3r7vqTCNs+np
	GFpar+7zkL8zCsj7pDnZRv4=
X-Google-Smtp-Source: AGHT+IHCpHTQOm2E+/WA5JSn/AVuL9HHYRjwTZkx0CxsodNCQQRz3ZAcGcEGXuLeXtUXaaSuNKt/jQ==
X-Received: by 2002:a05:6871:53c6:b0:1ef:c082:ec98 with SMTP id hz6-20020a05687153c600b001efc082ec98mr18826139oac.59.1700090765265;
        Wed, 15 Nov 2023 15:26:05 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i126-20020a639d84000000b005897bfc2ed3sm1663081pgd.93.2023.11.15.15.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 15:26:04 -0800 (PST)
Message-ID: <5c9d34e3-ad31-410a-a46d-ac585a4d4e58@gmail.com>
Date: Wed, 15 Nov 2023 15:26:02 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/379] 6.1.63-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231115192645.143643130@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/23 11:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.63 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Nov 2023 19:25:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.63-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

