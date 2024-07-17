Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A6117F50E
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 15:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721231878; cv=none; b=WF589iq9z+NXC1O/n1Ng5RSOWiYmq/JppkYhlH3ej6eHx6X5DxfmUifQ7mEIOuOG69hukLko9wjeU28EGE8wuhCY8HUXz7vbCyqwZgNjzUZBoqb+SDHm8fyEaei72t6k2zakxXQkj4CFDmEieeZESGThrZa+KK+59954fPc7M9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721231878; c=relaxed/simple;
	bh=yEDShaU33yVXfWVbkz3WINqO2ujZDBlOOhoSKKzNAfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lvnTIBxTEvwSeDWgR90+TJmHlm/sTOKNcpZgm3tYY+GKRE2vcF/a9dGeaaCUVVsybReMEM1H4/yenl15UZXNKw1bE37cqWpK49q9RqahXtktC5xXNWNu8Ypup7U+zLmdveSEX0inH9Emc31EoBoUCqU0Q9YENynaf4zmzq3ZBEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SU8MNL6X; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SU8MNL6X"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-810ca166fd4so2414239f.1
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 08:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1721231875; x=1721836675; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hUZhzpQoP/EpenvVywEbKuumx0D3/HwN7bh1DfuNzEQ=;
        b=SU8MNL6XANUm8uBsiPRXUYzbODTdT/iSdgl5bHUwlKxMDAt3qnbyGRXw9QEkpH7Ovd
         5cn1Nnohehlh9wYUZ0a8rQq7dPwZshNy7BuaEdMRKKsUfhXWug4c3ln/g0am5KLZQk5O
         2vSprHeC5mwxJLl+9raC2b+av7hXgiJRovD94=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721231875; x=1721836675;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hUZhzpQoP/EpenvVywEbKuumx0D3/HwN7bh1DfuNzEQ=;
        b=fuPElZya05VWVsMrvET2pfAwPEtz9U/H7tghkMwWZnKrO4PKJl8CKfa8ewlMxFPYbu
         ZWgjbp5DBvvDZHciUxwREVm4+rd+jegI7M6dD9UmwcKX9Xfnsh8iGkA0DhPw9bIVdv7x
         FYLtchvDQXrlCDzdvkdW0liExsDtNjyvK9rh22O3NI0srg0JvYzW2S+ciKdvzelc6U1C
         MQxCCokNPWDDn4gFV7pqV2PL614FtcSbxZQpfik7ErP67/JF8x7g3wH8IMKZ0Vurnw1W
         awXo4vtrXUMNDocj07TbHmwZXIiq8ESQtggstK6wYOzkzYM3bQcjQHTjwuHIQsgLK9Vp
         pHuw==
X-Gm-Message-State: AOJu0Yygwq66bAVNgTdxJH5wHX4aTLUqWEuCpa3+XMMtluQ48v8c+Uwl
	LHY9m/0ynsC0SSVKJL5am9rzMi4M78idoxAbTWb99jNu7kwEed9SfHIlhRlKRTE=
X-Google-Smtp-Source: AGHT+IGfKcUu7NqZz/2YIoRFXDETVLn01TPyAgMyhSeV+4aYuxcyraE1hyGbvp3rovCi+c5AXMIfcw==
X-Received: by 2002:a6b:6302:0:b0:7f9:3fd9:cbb with SMTP id ca18e2360f4ac-8171022db8fmr142626739f.1.1721231875485;
        Wed, 17 Jul 2024 08:57:55 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c210c2db85sm766984173.38.2024.07.17.08.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 08:57:54 -0700 (PDT)
Message-ID: <67db8d9c-c7a6-46ba-996f-5fc06888fd05@linuxfoundation.org>
Date: Wed, 17 Jul 2024 09:57:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/66] 4.19.318-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 09:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.318 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.318-rc1.gz
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
