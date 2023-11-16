Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214E833091
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 19:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QwDeqfTT"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6c3363a2b93so1119871b3a.3
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 11:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700161922; x=1700766722; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r2cblImVlnKbNpSaIwvvqPSRGRUsM1AEekZ58ABcA3o=;
        b=QwDeqfTTEIGdU86H1TsvaA3BhktmHdtB3We9aXlBazPdqZiu8/0p84KEunRdvl/TGX
         kYwfVYwQYe0lidP/RrNo+4XhRggBZDPcQSZpzxIiLohUIc+kkR4D3tOUZFpHXZnitl/C
         esJQejOET8Z01sDhyGkp9at6lI/tPNdsCX70SiSs10DWFXB5ygj1+lig53+c81eq1Bgi
         6ltOMMrsBsqwuk1eTV/HKo3WenWtd4uPqgW41tpPt654SV1yX3fK5zRT+spfcJeIyew7
         8wMfFmeigaMEbqQn7h9R8Bj5SOiCKnYnBQoOFi23aTPmkxYP9h8X7acqmLQ3U/iZaEaj
         WvZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700161922; x=1700766722;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r2cblImVlnKbNpSaIwvvqPSRGRUsM1AEekZ58ABcA3o=;
        b=kqMlhSmcUjWvQxcpXn62UTmV7cCpsaAWgihIA6FM4D3Ki4y9pa+hN/hmWoGOl4AoEH
         p3MyzXb0trvntA0qFWFsbzDGvlXnIhCXSHVMB1Wp/WbnUc9Vdrt1Xhe6R8Axwg2A1UI1
         lkkF00G17ZVnZaYYZHw0J4btcPkYMoQDiJNzzO1Qr1yFcjzFJLhdW3X8GLW6mQjJxu9U
         zKq6sdbeAfm5wG3A+8zCprBP+csnn5wq9EUTmDBDBxiAXy0u3gIVNqxCO9UWb3V08p6i
         IfU+VuQgxsKZ7Hl8Ef0x6N2Sdjj0FZj28ou0ICq3CZR2EFLnN2rznCT0MoNdWo7mpFKd
         EMXw==
X-Gm-Message-State: AOJu0YxGe+hnkI6sMh+U6of9W52J8UhtwgKdyKHseJ8EQqulGQzO+J83
	F7YuOeNBR7JAURc9C25FBis=
X-Google-Smtp-Source: AGHT+IHljXn8CNIViSbTqu8jUg5uWKAMgIY9NhPSyqrB0LWUb28+6OTJH9Lt3SqhQ2ZX7wtujCOtZA==
X-Received: by 2002:aa7:84d2:0:b0:6b2:6835:2a7f with SMTP id x18-20020aa784d2000000b006b268352a7fmr17373822pfn.22.1700161922269;
        Thu, 16 Nov 2023 11:12:02 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bn2-20020a056a00324200b0069ea08a2a99sm68710pfb.211.2023.11.16.11.12.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Nov 2023 11:12:01 -0800 (PST)
Message-ID: <17487dc6-2c16-4065-8df1-7bb5b7696ca6@gmail.com>
Date: Thu, 16 Nov 2023 11:12:00 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/119] 5.4.261-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231115220132.607437515@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/23 13:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.261 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Nov 2023 22:01:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.261-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

