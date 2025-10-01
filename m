Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21F6279DB5
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 16:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759334894; cv=none; b=kOc8lc8bJkqL+0GsyH8k9ODUcdIBWmOZu6lO4h+GjWtGa9pEienJQ4UgB7sDS/Z93IWmo5qIhIGNnO+u7fDWCGssQ9tAfko9i5tznwoJ0VqYuO8nK0MTDq/arQIjcB04r65EANTs7CETkjYdquadvMB+Hk9Q2a4xCNAKOLYnYL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759334894; c=relaxed/simple;
	bh=4zahqbZVB1dViemCcCJZXwgbp6DQIyBEEvtQ06hxhqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b1x3x/NTGYE2L86Pr7kcfTxO4LgR/Y4MyqAIgSsVDD94MhwbrtsF2raxaLhfaCMx/91i3a0hfX1KZJSf6EDOJjUpgEIo7INvLJ5CcFeLd4oEnG4TOcE82fLhE2qbv+qHc49WhhzIPVOpHcYH1gR66oLUS/8JVg8Ry1CzJiVvb7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGgfU1QJ; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGgfU1QJ"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-8c3414ad279so244590339f.2
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 09:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1759334891; x=1759939691; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pqQen5bgeQftZhhWpYC9UuT0CiCA9aQdBdei0IUghxQ=;
        b=VGgfU1QJLqG6RBbWmU4M/4xVK1IxGfEHztb5vyfdSfxBcfAC1UP/pL5taI2J184ieS
         z3JYGLI12PC6AT1/kNLuWDyRG7X4cU0/mq2zgjXP+4F5TEcAyIHSrq8LK+Yol7VF/vTi
         YtPrcrq1q6ZGVaTvpLHeRBV3wUjW+EKfnTCak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759334891; x=1759939691;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pqQen5bgeQftZhhWpYC9UuT0CiCA9aQdBdei0IUghxQ=;
        b=NWjg9qbUDH2+jsliAs3ALs/x3O2nXXI8BVyi2SQtB61VLh4+mC7Pf11+wfUGws+CLG
         6PJlNe7opB5UUX4PBm6V58gzsAsTrmx9fk9X9rFFEh9ZtTqNI7wWs1lda7jDNrc/eJWZ
         XLdRHQc885mVjI8EIQuPKsbFCkLkAJoOvSWOooSJH88uQX7wd839mFNCAUWYH6czUmWp
         fCGm5obzw/XU4ySB/taNFLt31ogQjdXHKMmVhvT2KbvNNFLQtzJc7MTR1vtMWV2Y/RIh
         1YEANXUShqW39RgNAtwYunXuUiF6Ps7hc6t1gFygn2HomELFUSRR7HX9Fb6dRdSaFsFa
         Bshw==
X-Gm-Message-State: AOJu0Yx+T384UCdOePZANgIMgkf5nNcIL3GMioSSK1rN3p4DdMiTg7/q
	z65j+SLwFCrTvthp3x9tivcTaqzcviLO2Adjix+1jK/d9dkal1LGjRFFzAJR64/7pEI=
X-Gm-Gg: ASbGncvRZbedmyH49mHoCYxgOn3nX+dxUodbn8HLtaKv8tELlbxI5cChDxXd7PIriCF
	1edTkOeXrMTz7y5q9BDAxZGx7dZ5Fcxtkd7eEAWlgC4UK4X3nsOx9QjZ6rUmVoQtwNyzJndWM9q
	zcQORcXf6G3DnOF1KMC0yoLzPFog3XXUBgv3GianFhAK1uln4Fvp4a9ozozo5Nxybh2MpIT9fed
	kI7dZ+n4Fc6vhZF0ZzEiZmtdrjkgo38FlCJbXPgrUfLFjPWa2gTauEk6ZJrjBjots9T7w6sZ7mG
	VXS3M8ZIr58EkoqVvMZET6Jg2qnt5cWc2ruN0zV//O/JcXI1vT8no4IuFkmyvXay2qVil+PcH+q
	eMTzL+w2DDejNRExaiAVIqQTj53wJEn2E47IitOtxI/faUS1yHn+yDVChXAk=
X-Google-Smtp-Source: AGHT+IFRMvxEYLeNKDQ1JmK6xJLRr7HtLVjyjPoczJKg+MoqWy9AxaHGv9UkUjU5GqojzD4dh8HSSg==
X-Received: by 2002:a05:6e02:194e:b0:425:7974:fe21 with SMTP id e9e14a558f8ab-42d8167e8bbmr55614135ab.22.1759334890495;
        Wed, 01 Oct 2025 09:08:10 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42d8b28153asm215225ab.20.2025.10.01.09.08.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 09:08:09 -0700 (PDT)
Message-ID: <ec7fbcc9-cf19-4fa9-9e4a-73133203aad1@linuxfoundation.org>
Date: Wed, 1 Oct 2025 10:08:08 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/91] 6.6.109-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 08:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.109 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.109-rc1.gz
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
