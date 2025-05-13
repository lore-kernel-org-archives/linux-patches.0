Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A61B645
	for <patches@lists.linux.dev>; Tue, 13 May 2025 17:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157542; cv=none; b=EMJkjJiTKB4Hrd5RB5B3uiCVIDAdCtKU1Hg4WOvA/v1mv5ig44qFib/INrTTFTZk5Z2Q4GeSERneJb6n8XFylC8xzwDKyh9WSVFjancQqnEAHcnAKo0Wckai67SFMrrjM1Op7uWDjQwHEhjnzbxVzL6IYHA8q9IYIqMK1uVaoEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157542; c=relaxed/simple;
	bh=xkx8Y1zm0IbWHQo28qfYmM0rx/fAXJplkL8G5rh9aeE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HTz09EKFRniS+u987sBDwyaW1fVwp+u5vGv7GqpR7tzzZTvnpqbC8DMhCXcSyvmKEZJ00mLbLCwNlV4TXkVYACIOURk3lY1MWZS6SLdepIT/DK8bOFYBxvigINMl2juxNeyHha4oQ0qurVAWuV7vnS+onFXzCVbOwrwM8apCnHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxcbId7Y; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxcbId7Y"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-85d9a87660fso612738839f.1
        for <patches@lists.linux.dev>; Tue, 13 May 2025 10:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1747157538; x=1747762338; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E+MbZDnbUPKSUoUZsaJjBizYbNkZOWSQfb1Bn7Itqcg=;
        b=TxcbId7YTOrd8fLelubnaBqWVzX5qC5Fr3W/oBgd6vGcaNmlF3xg6PCHGxkjIfblxw
         cN01WsIvqpmc2r1IpXVhSOEXhePeGBw0NOR+5qfwSmLJL8ClBeCuislS/yRx2PYEZgsK
         wnw0CWwJ4654zL15UZWf3JD5J/rvlVhRM7RmU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747157538; x=1747762338;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E+MbZDnbUPKSUoUZsaJjBizYbNkZOWSQfb1Bn7Itqcg=;
        b=rm1jaDwWSMjwYN9pBN9RKO/W1t3EA4DgzhfMdZ+W/JtlVwPdKOI+Lu5eUexE8HC2ml
         DpnhBA398H/IT2uqwBLs+QpVZHF7cQ4+8txrNljoZNPbjFzmph1Abic1piWnw3JMtRex
         UVtFBaAYado+kqQMK68JkliE8I/9VObIaejZdr+I0rK1AMPcwMy2PPzwykD617YJz1ty
         qmeE+MVZ3kgUnf4kgIVhtpX7LKW+wEduCeJDLDXsYDOLqLq0CNvoEtKieom7rH1zTfy9
         Y2Yi6UP25zlcOdw4qX8VU2vdauIqzPpvchih/6aJhMd2Qx4Cie13YvcvzPRR3jPAc/0V
         8Lbg==
X-Gm-Message-State: AOJu0Yy4tKk9Wv66fcXhylbFFvn1iqAqLN2zAbiLjRSqK6xQg9nn9K+m
	izTuaIZ59HM57UFYiJIk2sjSfpYL3yclu0q8nJR/xlF1pX3T+DgMvdF28xY4Mv7R5v8vhQiMOnx
	c
X-Gm-Gg: ASbGnct4WlKV9ktlrXuyGN1A9qX/0/4FqUjWEuOjkfOvnPsr/Ys3CYPIWGXTyFNGx+I
	TEi5CAwV1avdeZ8F4fTSPc/g2LGIitf5DklvM43xaXCN/MOwDku8bM1e7PxW8lwRb43ySizuJVX
	QAewJ1QUj5FPtf6//XtQYcCap8jMl94gryo47cMAO+Xv3WJj4urYBHO/jx0TOFDeudAqx/Cl+4R
	o5d8pceNIxLOzJeu0JBZXgoSWvEf6dLcX+94ZeUtc/5GzRqkwvreAwFl7sNIxxdoNo9d1Ru391X
	3Wy0gWoLGnBTtRZznDivrOZ1psITfj0+LwS9KOb8Y4DTkhc+0O0cICvqYE3ONjDQF1o60vun
X-Google-Smtp-Source: AGHT+IFWdHjRRXf8QVQEUR5t3ZnpDNlogFJNUICkx9nlc80riFRqz3gqNSj0dPMtDWrDfIPLhITPkA==
X-Received: by 2002:a05:6e02:178f:b0:3d6:cbad:235c with SMTP id e9e14a558f8ab-3db6f7ad141mr4886995ab.6.1747157528157;
        Tue, 13 May 2025 10:32:08 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa2262d462sm2229617173.84.2025.05.13.10.32.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 10:32:07 -0700 (PDT)
Message-ID: <50ab86c1-4b23-4ebe-ad87-7c8f3f90e7e5@linuxfoundation.org>
Date: Tue, 13 May 2025 11:32:06 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/92] 6.1.139-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/25 11:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.139 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.139-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
