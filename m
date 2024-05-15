Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540A713F422
	for <patches@lists.linux.dev>; Wed, 15 May 2024 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715785579; cv=none; b=ge5l1zepwUIc3j2eZw0JMOnoo5NQxJGuSavafRmlidcxT1LBbv83d1x8UfrFNJYYjll6pb+uy1nLlp6sIN2AodDcIcpCppQYfIQ4uE/zK5sdAFCu0OyG8iaqrqEdiB7DPvL6BWwpJ6smQxmkX/wQbCkU4LSD7DwlgBvy1YHllw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715785579; c=relaxed/simple;
	bh=dkhstp4krRRf/IIrV8Jp0PkKghXhVUPm8ooq1NqISAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZOn/udYAuY6WobdoN9Kt7YuljPlZmUEvfI9lLBSgXoDQe4sMaWRTP92ofhi7G8ndxYpAfzR28wiTE3jkhlKZxlFHjR3VeCCeQvPf8mXj8iMUy5kj4URf05KmX1dMXs+vOfW/wvbSnDlQwbD0teQtsp6SYwoCYtkRIazMTrek10w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKMzmPGU; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKMzmPGU"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7d9d591e660so23682039f.2
        for <patches@lists.linux.dev>; Wed, 15 May 2024 08:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1715785574; x=1716390374; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tcxeZUXyQkyFLx7KMiCTRsTvFYAkwjKOXr0GkPeu54A=;
        b=DKMzmPGUcTYjlzj//ypzp9Z8sjK16JVpNC0vcXSjY8pplWlaUKknR1VPeUyyf2DQHd
         yQeWpy0pjAzkS2QEmi4IafUZhRkfZQ6ktlL1fwVhjc+fWQss1E+cCeI315IfawU3gq9D
         god03H0CvurTRxh/uSSbCzX+6594OeLckdXNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715785574; x=1716390374;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tcxeZUXyQkyFLx7KMiCTRsTvFYAkwjKOXr0GkPeu54A=;
        b=ezhJbt0LSzkEs+VTOo4NACQz3qljvGV5UIJe+q63EYFIPYzOyC3Ei5eX9hQt9CXkT0
         bvPnpHEq/0dTlCqq9PEXjNp5qIJPBKT+nNilVV9lfjPFxYYBMde/9hEBmVtI9d1+pJyG
         IXkO9djttSBCAd8YVw+yi01MQVzIk8srfFZiTgFPN6cdh8QdOSM8L4gBNb65S3DVwh1V
         mlCt8qrZ5J9NbKg4mbdQbX+1RBF6k6eTzLiVkA4fyepmEvZ3sRON6dqchNXrZidRLNSS
         Ht7UZGzI16uIeNimhl7D/Bj8YpyFl18E04eOTN/iYmli7Ev5ZsYoIVHUAn/B2IYRbTpt
         cp2w==
X-Gm-Message-State: AOJu0YyiHYZ/cqPvhAyJf15/PsAoA5hj5cpHRRlbN7JFXbPk3vET8fgt
	lh0uc4jiurEw5cbNt9MzUO29ETwNhcLAXP/jgyslyXr7LaTHiKDmKj+3gWf8JoA=
X-Google-Smtp-Source: AGHT+IFos5E0NRF0v047mDzN6VC2lHuoSvXNmQBtmU1xGnoWZxhdOZ3kYeOn+XxmLqo5CIB6hHhWvw==
X-Received: by 2002:a92:d3d1:0:b0:36c:5440:7454 with SMTP id e9e14a558f8ab-36cc1444bedmr159110175ab.1.1715785574464;
        Wed, 15 May 2024 08:06:14 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-36db80ab36dsm3707715ab.67.2024.05.15.08.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 08:06:14 -0700 (PDT)
Message-ID: <39e1c8dc-ad54-4c47-921a-0d8d9af513e6@linuxfoundation.org>
Date: Wed, 15 May 2024 09:06:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 000/336] 6.8.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/24 04:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.10 release.
> There are 336 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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

