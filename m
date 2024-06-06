Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C758A4595B
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 21:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717710732; cv=none; b=DInfY145pBW9YuzMGoG1xTaA9/XaWDRKivIskprXfNmStCyxfmLn6eDsXyJrnaKthAx6v5en/dZDXU1uIu/bw62ybNgnMOC5qevxrTKqp2pDTnfUjyxW61EqgaIIwTlHd7JuXs1I6MJZOmHl4lBcoUQ6vtEcbTlT+TU6INk73zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717710732; c=relaxed/simple;
	bh=1wzuCCFG6zJQG4/yIoPNBCKWEOwr1cjoHnLTYAP3xpY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cL//8OdwMG/ojKCnc5Tyhg1kG5K4xC4/1es47L/GPRnbmHFasBsN+PH6wDlL0+JFsDMMole92N2DgleW+9e5J9K+GCEfh0YYmbBN9Q1xqxLxGlpGVmgQ8078zYS3vpFqALXtdn8qNJmO4eTKivvhduQ6GF0bfr/OBm3Tf1ZzMQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FG24TF5P; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FG24TF5P"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-374acd0e045so966225ab.3
        for <patches@lists.linux.dev>; Thu, 06 Jun 2024 14:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1717710730; x=1718315530; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1KDsYqliGZduGqwNg2P/Pec7wrzaXiUOB9FmAhmIDXY=;
        b=FG24TF5PMPXGqXuG9vg/d9uQq0EvAwfkgEnC4FVxjDiVG+5Z51+LpgWdHUfbUNGDxC
         lMknjThH929tlFH1q2901WpOsqbD8X7jtxclWVQGL0XV/OiZUHAsOdHnOQvTKFqZjGHw
         Qi/qE1l77XvPYk5V0lWL8S3XaNAAXcjpzNMYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717710730; x=1718315530;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1KDsYqliGZduGqwNg2P/Pec7wrzaXiUOB9FmAhmIDXY=;
        b=SNG+w2ylsoG6Z0aanP3d4af3F1GNrjKEU2OpjCoHtQk6XfBDJ4X08cC4JeZlHmS+Oh
         N3dEtGFWvmO1PO8OG2JorXvsBWHkRt83U5gghm6BVOPurbYUdp0ihYW5NEl8gYXekVpp
         EOhOk73sLMyj1UAXMW4oH46IOgu5gAI9OG4/N6sLDLY8y8lvUIc0IF4FsfndhLpaa7kU
         bbP7wHsGjaWQ0MDVaQn4WZMp0e5byU5WgdQDeSQvKVnX6aSvS2wo/couRkeILyAs2l+m
         kPxbUnAvfj7UpnYlY48BsYWzNHBxZChle3RfoYG6uLskbnCdqdKw/0EtOm1uD6a7ZA0b
         GzpA==
X-Gm-Message-State: AOJu0YyiABZxuoXvNmOP0Jy1d/utejCxpXYiIAc7pBZ0IP4l4CV8hubz
	eu7gwqN/j6IOV3oxYPxBhv6hxbufFH9lJ7YNkLdKOXx5rzaUBr7lAzcXhw3A8GQ=
X-Google-Smtp-Source: AGHT+IHFAu/m5GExcl5dKYmmFZVcJ+UraGl6QR4X2bxMouTEWbj98AEA6rlHA2Jcl97lTwB90wbSoA==
X-Received: by 2002:a05:6e02:20c5:b0:374:a102:2948 with SMTP id e9e14a558f8ab-37580391276mr10011895ab.3.1717710729892;
        Thu, 06 Jun 2024 14:52:09 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-374bc15dc9asm4891715ab.45.2024.06.06.14.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jun 2024 14:52:09 -0700 (PDT)
Message-ID: <cffcd021-7a8c-4a33-b07d-f0ab21af3983@linuxfoundation.org>
Date: Thu, 6 Jun 2024 15:52:08 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 000/374] 6.9.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/24 07:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.4 release.
> There are 374 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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
