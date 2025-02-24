Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238EA19C54E
	for <patches@lists.linux.dev>; Mon, 24 Feb 2025 23:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740439892; cv=none; b=UoEQxWUHTl5eZHh+wzIO+cna6eXgJN2H0RUWnduj10b+fwe2Pog1LIWpiCCmzmyvofskTDW8s9/YWEclmlcHwMGZ7ao6pxLlti+bc5jdK8wBo2ddGnS+1fDDP4RvLdH5wEOOdmS/oQs9aCjglGR/f8BANCVbqHIKTFZLYiYRNfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740439892; c=relaxed/simple;
	bh=F8UT4UMK4QmeAK+GaOuaql6of5z9HYtWyR13pd9pBfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HoTdAcaw0o4k6rb0mBapzgqHm6STA1cQGu5M1AtnrQsxZaMgjvxOhRX1ze2qjPPKlVhX81z0g1jZowE6mZlAtDUyPjFPJu/6QS6wuzFfe6b2Onap7kVXxjIZZwP3zIaU3vPUsyX0pRSMiQE9401rOkgrO5V8jhbU8Y9nrRCmkDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvbrYL3e; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvbrYL3e"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-8553e7d9459so153132339f.2
        for <patches@lists.linux.dev>; Mon, 24 Feb 2025 15:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1740439890; x=1741044690; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VuRSt/BHONOE6HTRUiUSM7fHedYhfmWMvn29Sp24F9M=;
        b=BvbrYL3e9RS5Mgzk1zGoJSB3azmW+Cw6K4tAuCAoWDC6FZ/yOG1x4dzT4bNZgw0Z9p
         nwx/44P5afd3CrwAat1+Rpk81rb9NMaURox1mKBCJL0nM+AT75kCDNoTrrrcJAmlfPcf
         U7LBmigkD/qINZFiiBypeNcMSFzaMxRy1i+vU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740439890; x=1741044690;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VuRSt/BHONOE6HTRUiUSM7fHedYhfmWMvn29Sp24F9M=;
        b=XetHrzBcMgU2W79eQh8VdUYwFJQMRjEPa909VrxEZM0H3dtiyUKjKeGGLqduc1IKaE
         P/g/uTUzbVHqBTWYbs98DRrqHkUeZ7SlGRhilEy4k6Z7l1Z3SFDNUVf2p+QDQhAvfX5w
         ouLTr1Jbl2kdizHBkXBG3FNjTm8U1I/se0TtK/Qiie67/0sh2AkrHwVao6voA4T+4WG/
         f4zDPpmHmxWbGTNRv682cLxSJvfww5UYwYQ7iOmPucqC9HB449vv3vsgrgxAoRdt4jqI
         Lclh4EwgfT8Xal3a7DiQQlVBLtmHjAqR6Yf7kXW3LsBX6rwmJHmnIl4YtR4YSvbr6W72
         qv/Q==
X-Gm-Message-State: AOJu0Ywrc49AILh0aoG80zX/o/KDiNQ7+OL5ZOoDReeJOWQYRVwhmXrQ
	Cw4X4p5vv8HqPsIQ3RdHAt36/f7YyPCG4aTPmkNYgKZVxHQ6kjscVfH4q2KVKD0=
X-Gm-Gg: ASbGncs4A8wzuScleYlQtFGiHbKE/XNnnKYywCKBRyfF9sWTo+3z81/Tka+rCt/3Mre
	9NfnMpq6SES4hNP7PaeszrLMj9KY9aitBShPdACEaGtOOgzfwnDNO7WMS7Ogk/HUt9OSeWApmyF
	SRpJCCVpyfP/x/7TRJMFjEpQ+OZSftTUmw53ljcLhcgzl6gQeS2DAx5hK2eWi954Lp9qOYmqBb9
	tAE9u7CtMoWP5iBDoNzMHC/BSY4ZUIOPR+z/6gMWmp+CFEYZY4wyHzfuy5McRWbYzJErCOu8g0o
	9Mv4K3xlCAgS+WO8UbTs5nwgsG04nYjndc0S
X-Google-Smtp-Source: AGHT+IG9gf7nMvoYHQuZUgZkRuJLv+urEXbaqRvetCRicjL4lLP+FRGp47rpDpRCVcbY4jajLs3q2g==
X-Received: by 2002:a05:6602:3411:b0:84f:2929:5ec0 with SMTP id ca18e2360f4ac-855da9be5d5mr1898313439f.4.1740439890143;
        Mon, 24 Feb 2025 15:31:30 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f047530437sm126053173.116.2025.02.24.15.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 15:31:29 -0800 (PST)
Message-ID: <a3c8ff01-c9a2-4d1a-b479-a18cbc510023@linuxfoundation.org>
Date: Mon, 24 Feb 2025 16:31:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/154] 6.12.17-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 07:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.17 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Feb 2025 14:25:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
