Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC92199B9
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 18:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709664782; cv=none; b=YUigZURv2xkmYEF+4wIcX33QeXl1asfcvhhSHxKD9JQnCgNc7lU8+zni9t6/ngMX6CPZG5Tpo4NIZiuVag2pFdgGtatCjJsxzQcwdJcb8IK3jz8heXPmxSSydBqyjNsSNkc9hw5sUUFf0FPlY4PA1iNWxnrES/zksX+rr2d22JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709664782; c=relaxed/simple;
	bh=M/226HSU/VUf3qLvN65ic9RPPkGkwgft5YY5sbbm7gc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FjWzLPMsaUrwbeoMJRIDJkiH/IVn1z6XeCOh8/de8DxV6NZ6ppET1o+XD8HvqCvWN5l98blIxTZ1RiF10DAXx5Z1Q4v3QvfDMk0oQuinuk6W3us2nqU5pjPbRy0My0ZrAGrflEEVYK7goQC7bkWkKOXRP9SplMsGzDyJMpCDYOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXZWi02E; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXZWi02E"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7c7ee5e2f59so64983739f.1
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 10:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1709664780; x=1710269580; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MEpeeM5uDTk2y22FrTqvvuOsQMUYfWSmy4vGTzbuVno=;
        b=JXZWi02E8qfuv+O4hsDtn3NCCnuGR01XAdU3iVMZAhJ6XrMcXkuz+Kj4/arDbFzQjY
         mHh6kfCAXzS2MQeXJ2MpSMB4eqgIcI9qsPc4L3wbAHrhZONdakdfluj2rbnpr1MFEHoR
         SSizC0nxiION07hid36CoDmyiFXQPmSHu/dRA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709664780; x=1710269580;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MEpeeM5uDTk2y22FrTqvvuOsQMUYfWSmy4vGTzbuVno=;
        b=VzC/FonsvbMW+5LV2TbpsEFJa1MwKYtgRC3FYIftleFaTsxliE/n53Yns1rVrJwB78
         sD2VDcTHS25TQwJQQNOdRWbtYMLMjaKbR+VS6xhYF8h6G+23gPBERws1CllxBCPrxy1B
         JMo9FFw2k8YJLZkq1cHfIXFHPKfRG4BgxBglHGS9VkWo/v2u2leIO3lxtUM3Cpmg6Aw/
         XUS7ZLK12HwTBkglXQcDDlkMKyKNRUL305F+F0ZHua2vzegBQrlEx9EKPg2Vxb87h9qL
         DGzQIaIbx42UAai86mI4Y/1xnzHCrMiX3wb0JbQyRxkK/K48jb16LjSGH2/6ZhXZBLTr
         gj/Q==
X-Gm-Message-State: AOJu0YzX1eaq0lRyz4KEkY2iyJie6Hdnkj1y+KFFa8eDda29rWc7d5d3
	bq7SkWNTaPUJda8LE//fESgP2jBQ+TRirqMFv3UcTkfRBKdrp2QGgbXVtZslmbw=
X-Google-Smtp-Source: AGHT+IFbzWXOeIi0fJ2CcuZDZeGAyPP24qF/5v6BY/JvvzLzUHWNTrD8gyMXbXDyIPy+7NnluYrAjg==
X-Received: by 2002:a05:6e02:2164:b0:365:4e45:63ee with SMTP id s4-20020a056e02216400b003654e4563eemr1378458ilv.1.1709664780276;
        Tue, 05 Mar 2024 10:53:00 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id b6-20020a029586000000b00473e9bd8308sm3045833jai.124.2024.03.05.10.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 10:52:59 -0800 (PST)
Message-ID: <5e9ca92a-ba9c-45d8-abcf-5bbd37a7546c@linuxfoundation.org>
Date: Tue, 5 Mar 2024 11:52:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 000/162] 6.7.9-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 14:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.9 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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
