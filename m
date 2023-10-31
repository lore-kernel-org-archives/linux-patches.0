Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B38362F
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 23:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zx7PyxSQ"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-66cfc96f475so39826406d6.3
        for <patches@lists.linux.dev>; Tue, 31 Oct 2023 16:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698794697; x=1699399497; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SDESU+0pFHKDRbJM8m3kaLz68UPQM8PiOfH4nRsFFEo=;
        b=Zx7PyxSQy2HTujP3EKeEJy7l62Qzd/r9mwkrssyBRytFPy69mXB72tldV57KiBGV68
         y/bKsl6ibTgmVSEf2zUeRBG/y0IjavaSlURZ19gXQ6DACN33kMBnPPPo0cf3wI3yLuEM
         wxbtunqDduH4/pkmblRYMTJnrSqeCWe/Ut5FlvSoKvZKcftB/1+nSUt5UnqKMYav/cip
         nQjeJA6MGPhwzOW9frE6WwI9ZAep7UsEjM5KtGreJbv7d5+L7RwrPRikGX6256KOlbSU
         ofYQCgwiK439CSD2mRXnSaR/mdTOCanTMkzA0LGJP6v2QsxN3v+kDd+bKNwGxqSNf6+/
         eaow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698794697; x=1699399497;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SDESU+0pFHKDRbJM8m3kaLz68UPQM8PiOfH4nRsFFEo=;
        b=g2JcXAbXlRPbrg7Rz84TucQPKG23jgpFl9k8kcG3DBxq2y+nuDATb3DXE/9ma6D3ha
         DDveewOjJdLLznZ229uaZdwSEc0D8KXMKOtSluNbngiasHa4bJYgImMc36M6anLAfz39
         o75Zn9pvDea/7Qs5V87NxMYQgt3KmqfIbvk5TtYx4aqez9r+xKTPWbxpOJya14ruXx8m
         /9mIfDbMGRWzBgZ54nKfxJ6Vc9OdCkbEoFS41M+bobufjl8I/xEvRNdW133+TRlekupR
         HDx4z/VnRszyixYToDmfM7zRSBiyI11RZRjGVCA97W+7SMh6utLUg8bxNP8/4YiD30iq
         hMtA==
X-Gm-Message-State: AOJu0YxDiYA/k621ZQOnUwpd5bq03LQDoX005b0hXtDfNhHpi3stbaos
	JR9Y6SxBgLg8mFr8djU2QKc=
X-Google-Smtp-Source: AGHT+IFHo/AJFjlo72eI+SRjYj16ZaiSwrTUmzEVxbrNGknpE4MeJNX7h1SIVL6IWnpdDNp1NM5HFw==
X-Received: by 2002:a05:6214:4103:b0:66d:1624:2200 with SMTP id kc3-20020a056214410300b0066d16242200mr19108430qvb.13.1698794697271;
        Tue, 31 Oct 2023 16:24:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id dw13-20020a0562140a0d00b0065b13180892sm947489qvb.16.2023.10.31.16.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Oct 2023 16:24:56 -0700 (PDT)
Message-ID: <9834c735-297e-4b70-9440-ab47a9118698@gmail.com>
Date: Tue, 31 Oct 2023 16:24:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.5 000/112] 6.5.10-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231031165901.318222981@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/23 10:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.10 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Nov 2023 16:58:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

