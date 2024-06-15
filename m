Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AF06FD0
	for <patches@lists.linux.dev>; Sat, 15 Jun 2024 02:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718417553; cv=none; b=kIa0i8oeInEu9O2Tg3DJZYihRoDTVl29bTNOgPTctUm+wOPqVp/Ak022f+aJqJ8e+49IwXssn0kh3K44HteLCznzkZM7KNUEe5+HF3qBf8DGI5qUGD7ZmUSq5LkvOWzAfqs3Zkhr688r2pHChH/qSP3PpEetY09+9gtSBL9hBP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718417553; c=relaxed/simple;
	bh=ZTDzit9m2Jocp58+PuCzOgmogp5H9se3hT/QvozYCaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JHkR3FIcN+xfWiZLdkKQs/0JbZfQWanlDsUZA15dqBA8Mj+jLcrlJFsuqHwKMf5Mch8SUJGd7VnJtRQMaTRl7DImUYrBhpX6NTIuuppV68oeP10uXYrvj5GLP2YKoNZicD8zSxnqbO81F3Oa5XHnBNaIxqtZPlo3ookCw3TpZ3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAcd8OTN; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAcd8OTN"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-36daacdbf21so1129935ab.2
        for <patches@lists.linux.dev>; Fri, 14 Jun 2024 19:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1718417551; x=1719022351; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qzaIS2e21jTfUCx7lF1LxmffBmnXZpD+ytV59MGze3E=;
        b=YAcd8OTNSEyWFhBdGBjKYGZSASoS+FV5THQFiT3i2r0AzwnPqxG1EafGD/OazaJnPd
         JxQxGYPdslZqJHY15tFqD7RYdtUSbKwQQRuYbkQALFRUl6lpra1hdbY9FuiOzA6VMMQs
         TVX2SwaG4HdkHEoMI3041hzxmiJhyriG/Otpw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718417551; x=1719022351;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qzaIS2e21jTfUCx7lF1LxmffBmnXZpD+ytV59MGze3E=;
        b=GT+3aS5zukuwr10PdB7nHYcwpp7LdxXGqO8cj1G/k9s1Hxc5daD5sgmxVG1C4WSXd0
         qMrakKCp4KY4iw44pG+lvbXQHXjjghTldZosliUN4EMPI6Oq2qEzQ73eSrvl6UvgXhkv
         nM4aEuoLoz5DqvaJrvo4n6B1BNeHVZ8bCRX32g73SD/VrC66e+8gGTiqkz0XaWBjPMQ7
         N1+ZlWn5tQv2uT2YmLo9TnL/gGV56cT97NARgGgSLkhCatmbMgXqw/JIxLQZ3YocHVTf
         ib9fvtl/+1qONW5aP53m4X62wAVgo4pIO+dNW9XUcAVEApCTpC6MAHgFsCO8A2oKufRS
         Kgww==
X-Gm-Message-State: AOJu0YwbDAMsx7aJ+003zRZFw2jggzq6NuXlORiqNYIBitJt0ZYXGw0T
	3o5G7dz0zv9SLPwj98ViYSqxs/ZF6hXKukgc0I6Ery5cHTfo1gU9NuHjykCvQiA=
X-Google-Smtp-Source: AGHT+IFRrImpDWCJ30WC+mrE6R+ULQBANeb0E3WYgnZ3y3tWMl89V06RdOLiPBqmflX1FqRQGWXUYw==
X-Received: by 2002:a92:b703:0:b0:374:ac6b:19fc with SMTP id e9e14a558f8ab-375e0e0b4a3mr38441165ab.1.1718417550872;
        Fri, 14 Jun 2024 19:12:30 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-375d86be155sm8824275ab.39.2024.06.14.19.12.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 19:12:30 -0700 (PDT)
Message-ID: <9e3c4cb4-1110-4269-b44b-fc5985ef0d1c@linuxfoundation.org>
Date: Fri, 14 Jun 2024 20:12:29 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 000/213] 4.19.316-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/24 05:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.316 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.316-rc1.gz
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
