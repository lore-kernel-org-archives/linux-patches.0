Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AE57494
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 16:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722011333; cv=none; b=eCimFncte2on1bjbwcBGhZJsN2CzrxZNW9vdPKdD5mjuXtT1QdY3gHQyK0f90+cF4KmoTToOWW1hfEdecY3j8FLEkiU/gQMqVz3pBGqDw8goojTyPXGUJv2kUXRloo6s21a35UG1fbLnWzAMftlI43k6bn1SZFcgHqtesQtXEM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722011333; c=relaxed/simple;
	bh=mquU6ywnjz4JDQ/DDkE2Uz2Wzsol6GCYyxCGq3HowUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oaFYEifobR9pdX2bPBtlpgnBXlqpkhMMvYb1VnYxzzUTfUCn/JuKFaGLO9aermCXzS5gB0938qZHuiOoHUATmCZzcaGVWgUlyjOj829davBstJzNBsDenVAHRowYcH7UToyDLYb7nuHAk7dGB9WzSzbQunowIguW0+Snhxegt3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atwVous5; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atwVous5"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-81f8add99b6so7147639f.2
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 09:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1722011331; x=1722616131; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6LSLb+GcNXv5+p/rTuMG1Nke3iHiL3wBoVAeG+q1+uQ=;
        b=atwVous5jK2E1KfvzdXrMSQ1MmZOjr1pO0hecjbVVBH08KKe6PVuNNdHD8QtoHqzNY
         7knqfUjFNVRWDTA8GobC0manEl79TuZXlHDNBLjh92450RCEE7JIt6fbHFjdd8//IYY8
         2Qc3B6xxEXoOEUzAo8wA28SEb4TZtA9Vy2pT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722011331; x=1722616131;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6LSLb+GcNXv5+p/rTuMG1Nke3iHiL3wBoVAeG+q1+uQ=;
        b=lKxeIZPMp7Wmu67Ku+7bio978bMQGQIjHcATAdJAw9R718byWa0tghFBxB+dq70db3
         Z+7op8Cd81BMI4AlKyRh6KJYAJrwItMXgCLXozK8Ou+QQBbiXPcJxIDNv2f5/HdjD6p+
         baeUsF2RTY32SosDesIM+0MHEL/7J2v+AFhTGVb3lGbxnKsHey05hXxfysfKyzTXSyRR
         2svLW00oAQ0Tr373TAzadHVOWHLRcLc2AIa1ZoRTwnRAQWnU7jXhjOwfsEtahgyorMAi
         Z5AxUr0iQ35UjRPjK6Oi134gKGNkNgQTFxlM67CtEA0HaNRXLkZkcNnKN4NbRB4LPxAJ
         /DOw==
X-Gm-Message-State: AOJu0YxHcy4r6e6BJWLG1IZZL15mCzbQW1pqi1r/CZtcfxXyNU4i0kNV
	C+s7FZ6SybF1bnSPiCXNXfU0fWT7sYqJTGX/25KqMlnHEeek1z57c/namxZg2gM=
X-Google-Smtp-Source: AGHT+IG36a6KJseR67jskiTVIquUkz1PMahA2GURB1GVgedlRkR4qMbhMAV7SV+PVwv0fsN/5IOfpw==
X-Received: by 2002:a05:6602:4f88:b0:81f:8295:fec5 with SMTP id ca18e2360f4ac-81f82a54258mr357558539f.1.1722011330710;
        Fri, 26 Jul 2024 09:28:50 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c29fa40509sm905994173.7.2024.07.26.09.28.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 09:28:50 -0700 (PDT)
Message-ID: <bc28c629-5710-4fd4-b477-1fb9eff21cef@linuxfoundation.org>
Date: Fri, 26 Jul 2024 10:28:49 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 00/29] 6.10.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/24 08:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.2 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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
