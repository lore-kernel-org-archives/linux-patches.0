Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1B7368
	for <patches@lists.linux.dev>; Tue, 19 Dec 2023 00:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxft64uL"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7b714a7835cso46339339f.0
        for <patches@lists.linux.dev>; Mon, 18 Dec 2023 16:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1702944343; x=1703549143; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2ASVO3g6/SUkBVBnev9A1RPubmA9KlOdv0JVABQZqVc=;
        b=gxft64uLzWeqCPPcHnDEsxP+l7kDnOJhQ0zXXt70bRvyxt+jiZLkEI6Gqip0EA5xmU
         0DjyUxVZgN3vkOisQPDjf0zA1RtSWPyhJVJLgfeXYV+IxTmFRSXL6egsHnAApTxJ3sLw
         KZaEjNlbtHn57wPRkLXP42SfAiV4e8PfD6vvE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702944343; x=1703549143;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ASVO3g6/SUkBVBnev9A1RPubmA9KlOdv0JVABQZqVc=;
        b=IUVTt3k5jPZIM9K07kvDItuyZcczI2gmpeOUhlHr9b6JRR7bjHuO4Bzhwlf4UShi+Q
         Gj8iFP78Irzqyz09744UACIrBI/qlSWi98bUBdTBUz+jVHx3KSYoBDp6BGb2GxD/f1Qg
         VVD/Xg2VN0KWAzJjH5Q+mSuqjnDn1fU7O46kdCXmkOkoYlfqZr2Y6o4IThcLuk2PgUqM
         5wsqY8CQiNOBepf2OluGb40wB2xK8s0KTI1RGFjYWAlHWVIj7h4f3y75hHd4inkqIUHN
         6E8WYqeYUnF09mhnTvus9/cNnpCv3ENsfVRO0saKiRPzH8RfAl+c4mJca4pG/XE7z2zy
         tsVA==
X-Gm-Message-State: AOJu0Yzjfn3qqsLh177KteSBKI6Y59K2Wi0g770nVeCjd+kC3Kt+MvFD
	M1On8BxB1X4AJNCUj8qHyqhlwQ==
X-Google-Smtp-Source: AGHT+IHX+IYcIQTYnX65LVEa5z67GrV2LmbPR3MOFrcjtLCdraPQGV1DyNYjiqydFVLzbDh5RfA02w==
X-Received: by 2002:a05:6e02:1b08:b0:35f:b559:c2c7 with SMTP id i8-20020a056e021b0800b0035fb559c2c7mr3484991ilv.3.1702944343011;
        Mon, 18 Dec 2023 16:05:43 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id x7-20020a056e021bc700b0035f73763259sm1977748ilv.69.2023.12.18.16.05.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Dec 2023 16:05:42 -0800 (PST)
Message-ID: <e112680a-2efe-4c29-96dd-0b8261bb72b1@linuxfoundation.org>
Date: Mon, 18 Dec 2023 17:05:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/36] 4.19.303-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231218135041.876499958@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231218135041.876499958@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/18/23 06:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.303 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.303-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
