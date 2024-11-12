Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0A116F8EB
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 23:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731453341; cv=none; b=ODGSBDKeAeFXH1PK5zxnpMkAN3sGv7ER2ZagMwStHJcDpR8GDrl4l2ioJF4YEjD/tJqOh4653h3tLgao49ED6I1jpK2KA0Gcx8RJDlABCkxmGtNbqClbdv6Xy5DYSwP+gApDMQyzpeCmYqhhuFR+tzB5u72tC4Ze0zWsQT5LtYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731453341; c=relaxed/simple;
	bh=g/R4ohx7mYN2DbBFxLjMcewmHXuw5CTSU6srdda8FSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YW0XU0eUGB2eXstqt3wTPlxQOMgtJsgVshjxvD7U+1Zi5a25mtpoiEixYYEKphUkZQiM3CY7m4APFvXBoGrB79ibSKMaqUKeKuTwQLzkP678WQxCXv+PIyZzllogHHCU+2uDzrcF3+GNXel0h9Q1/h6xx44tiZTMjJfjWMqqjJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ow8XLfeV; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ow8XLfeV"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-83e190085d7so148231639f.2
        for <patches@lists.linux.dev>; Tue, 12 Nov 2024 15:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1731453339; x=1732058139; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LnMK2dqBVllbxdNe3R5GvuE8xct6oB+YClxSZXO8Q+I=;
        b=Ow8XLfeVK8VKrp+k0socQqEJWF3fOuTMc2ZADkZeddFwUJZnz9g7iwXR0zXV/bjt7b
         mGiKv8luK7vxM+SdD1HSmOsU4Z6+2wvjJ6TQNNtj6gWwoV47KtE0Bu4EsLazjxHr4Rcl
         +hHbFLRDDcQSaev2Ra0CytRtKiG+eKAkBApAk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731453339; x=1732058139;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LnMK2dqBVllbxdNe3R5GvuE8xct6oB+YClxSZXO8Q+I=;
        b=O2aMLTfaUAsfC8zgAgklF4LSo5cAJQs2r/5edRTJVROh4gXaveeSuqe8G9gvuj3r65
         qc0A1lk6+KBmv9mUFTCMHGgsPkXVA5H6JC+iLZC0THtvkHTJ7UtIIbBOa8ZgrPEYk7Vx
         3iRW/UmJ+2FXW2MVeTlcdfrMpxE1CvgUXxqTLuIkWkK/+vM4S+iZ4ZnhXqYzGLUPTdis
         6smmjuIhufiixyL8lTg+uPwngRgO4nUeq38b6hz9gn+knQIyQ0Jb02gb+RDf4HwVJIAG
         yJSutalVYI3tep+tc9Kq1KISEwZUC80dUSjVGGTNAnsJDzSsejC8spKQd9Wd7qa9DXTe
         2UUw==
X-Gm-Message-State: AOJu0YyGg0432qQxSs94Gpll9tDt62T2B9nuUfitpJTbVrj3L6HB54J9
	3srQKQlLXd/ZDN6dOK9ejEpE8weQg2lfjCPCp4Jls5NPet8ccg4pOoYU6O4Do8E=
X-Google-Smtp-Source: AGHT+IFe9FwwfyF1CfXGat4+I6PP+yEv+9tyc7mkPTeM33S6NC5Vw21jNi6/ApYRZEmQ7fQakABBrA==
X-Received: by 2002:a05:6602:1408:b0:835:4d27:edf6 with SMTP id ca18e2360f4ac-83e032b8401mr2284263439f.7.1731453339562;
        Tue, 12 Nov 2024 15:15:39 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83e13256349sm228310839f.13.2024.11.12.15.15.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 15:15:38 -0800 (PST)
Message-ID: <2b93e9bc-e36c-4f4a-a137-f35a5742a3ae@linuxfoundation.org>
Date: Tue, 12 Nov 2024 16:15:37 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/119] 6.6.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/24 03:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.61 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Nov 2024 10:18:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.61-rc1.gz
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

