Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BE179F5
	for <patches@lists.linux.dev>; Sat, 15 Jun 2024 02:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718417378; cv=none; b=BhD85WAC2znbqRMPTiPhj2Mj7lKOeyNNQrXYHrGlNrALHcUgUAtzL8o9vCyHyTMyj0u8/KW6G0XhDIEURGdoYRpWU53ZlIJT4dLvktfdnX4WftyxSXbSPxS0h8Cf67ngv02Zucjssqs/RTJ4FkdiICeo+CGDvB52zadc2uH11KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718417378; c=relaxed/simple;
	bh=2rJq94MZ2ecqUa9DEBquCVlM0N4B3BQ+yYzW964DKfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T2c/uzWYqbKjN/IQawnkQCZJWxOXTmAdbKnYd/3ym4JjFc5AkmXX97yEB10r/fJ+8lTleWn12EgLF+V31yI189dmIOz4stS57CriZbNF5ZqSrxUFwGwr9dHs9qQRH45gRJUwQs4Q86hfUb5mwPBX88yestmYpdEh8N4UMdbjzCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acYcoZl/; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acYcoZl/"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7eb41831704so6375339f.1
        for <patches@lists.linux.dev>; Fri, 14 Jun 2024 19:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1718417375; x=1719022175; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PWgXBk6Yxc1BKmHVd7Vm+RJCPaj9sFMDtkNeQIjJSiI=;
        b=acYcoZl/ffS1r7xW0QtBE7CKxCfQRt7Iby2xyLXGsVJVMSsE5jjJO8LipBtxlB8ibr
         BgzsGks5kAzrk7ujRopoeLSuhgq1zwr1RbxJ3ToksVuqcppL7eosavm/1cpimZlWJWZl
         CVkJ9PYgeyeKWdhUBWrYJpSBJNkTnL8tSvA7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718417375; x=1719022175;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PWgXBk6Yxc1BKmHVd7Vm+RJCPaj9sFMDtkNeQIjJSiI=;
        b=As/6E0eb/n+XydOFD8nNtLheoT5iuQxSkICs/mpQIfuSL2suEAkCQX063vS2fmGnih
         CewlniD7obPvrdd770LU2FR4bt/UBreTFBxM6JugRBwAdC1+ifF50vYeYQLsX6TVM9jS
         eFYKR99Lc30Mo7gG99cl6ItbRVs0dggAM3feotho2x1T1aEZ/iJgkYAEmoB9LNUrb5XJ
         BUkFxkqbl8bkO79FVxNi5l45xnwbWbRycl03Ksq7WdJgMbjEj1EX1KhDr5QVzqwtshx8
         JMvGP5b20aDG2QCNTlVfU+4Ilo8ikZkKPtda1mOcckhvVKpmYA+nS+SUcc+cXXv788TD
         V1lQ==
X-Gm-Message-State: AOJu0YwcfZcKhHntm0+Q0e5xzeObuEHMhHJuEPyt2K/cv230YpvA75ko
	ekvxCgQq/UV7LBdmV9L9r6tzbQMHKbMxpFTcNf+2pHLl7qyMYzhfIg/HT1ZwzsY=
X-Google-Smtp-Source: AGHT+IGk00SCYmx4ZxhqB38uGdMi+LqnfHffbXmkoJHJ4EMoATX0OF+G4W1HnEZMnhcHq5plpyP1Dg==
X-Received: by 2002:a5e:dc48:0:b0:7eb:ea26:3471 with SMTP id ca18e2360f4ac-7ebeb51e56dmr431851339f.2.1718417375580;
        Fri, 14 Jun 2024 19:09:35 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b956a1f4f8sm1243193173.121.2024.06.14.19.09.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 19:09:35 -0700 (PDT)
Message-ID: <61781c7a-841a-48cf-9f62-e1d38488e87f@linuxfoundation.org>
Date: Fri, 14 Jun 2024 20:09:34 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/137] 6.6.34-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/24 05:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.34 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.34-rc1.gz
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
