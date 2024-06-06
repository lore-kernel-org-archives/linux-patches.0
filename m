Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25DA4594A
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 21:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717710796; cv=none; b=sxP6e/ksiz8VpeyEtSYy9vPUpZjFaXQnQgai8wFqQiK+noafCwSML48fO04mHr93wjqpk3W2tLnZJtFm3VBjciwMurhEBZecMHF85r6Xvv4c6zwBnspsnQA9bFyqS/x1cQy58QPnKksZaMdnZQUpRNceLv0vQKomkWVKmYpBdvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717710796; c=relaxed/simple;
	bh=8woO+mZR1xTpJNj8Nrq4e42rr8a1sNp+Kie6Ej/VHqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T5YH/Tv9fiVFWbcp7hDRNZF1y5ImYWAFupoo/09lM07IQWiVfyoa6U82etQxLZ7qKgl2eVulkts3qgM4nrkZHfWA4p1gdNIKoPGFiMWlQTOUEb0JVZ6OtfnRgB7JuJRujJTK6jJ6AsUh5xClcmzxf0/cYLVrP3MRs2tRfkNxpcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJfql+2+; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJfql+2+"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-37489a3651eso951145ab.1
        for <patches@lists.linux.dev>; Thu, 06 Jun 2024 14:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1717710794; x=1718315594; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V3dOqHDmHQxZBL9d5fs4BncxmYPiNSY28Je+YxNNlSQ=;
        b=VJfql+2+rRoIpPwRDhqBfiBFsMYlMP57hysWZKQpsLp6dysUvA9Ba0Nul1WlceDHLm
         xybtovtI6ncWWUP9Mi4QWF6GTiuwy9igV8/PVRfQp0m03cvfuP/wUSjqJiPM2ilMKlW+
         v2zWX4fI3sR51xSxfLhdVzcwmZJJbQkrzcfhU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717710794; x=1718315594;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V3dOqHDmHQxZBL9d5fs4BncxmYPiNSY28Je+YxNNlSQ=;
        b=knY9zpbXn16Y31EmCok48hOasAQULMCGcJ3CRAeMAOZpwg9L9aVuw/dovnznOg4U21
         I9NkiZC9GySHFF+C2uR9QeywmZXkRyiFCfqwO3gbgjA/XTznRcrABOaJhm/n4Hc/rwJj
         9eQUao4yEWnxUO4i02/hrdlue69aoGf+Z6IQ/tv/MAntSjXTVnCROS2/3f9IrAhkQopH
         LtqZhULWsElTNOAyuQVCQwVxKwy2i4ViZ6ZA6RNvzuxMOIWYaNqevenbftzybruN39LL
         o4n39bW4L0rULKn1gJT4DsUj5qF+rEep/aeWqtM2nsrmbhGQF1nsOs1KouArXNL3vKO0
         4n9g==
X-Gm-Message-State: AOJu0YzZf+pT5tvWmsEsHtY0J6YALpF674VCg3NA6gn0hgjQIWNieDKG
	5dGxt476XLgb2dlXMDYSnKLO0LKtRo2+pRZgzB4bo9EVSehshWnfLp4fazdURbk=
X-Google-Smtp-Source: AGHT+IFj2HoC+T28HWLjKYBudaMNCDAlgyHTQ5/YpVyf+pPLuqyyDLSSG/KG7Trpz82Jw9W+uV6JMw==
X-Received: by 2002:a6b:720e:0:b0:7e1:b4c8:774d with SMTP id ca18e2360f4ac-7eb5712cfafmr100909739f.0.1717710793990;
        Thu, 06 Jun 2024 14:53:13 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b7a2212f33sm528175173.18.2024.06.06.14.53.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jun 2024 14:53:13 -0700 (PDT)
Message-ID: <b0c7ef44-9617-4fb0-9ea4-e30493d3a609@linuxfoundation.org>
Date: Thu, 6 Jun 2024 15:53:12 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/744] 6.6.33-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/24 07:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.33 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.33-rc1.gz
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


