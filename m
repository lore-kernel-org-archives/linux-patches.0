Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E09A2D
	for <patches@lists.linux.dev>; Thu, 30 Nov 2023 19:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d6F/r9GZ"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-77db736aae5so63874485a.0
        for <patches@lists.linux.dev>; Thu, 30 Nov 2023 11:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701372056; x=1701976856; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zMF7VYY19D+eQIQZfWXe7V4YN2em5TdIIdXRtsbpR4I=;
        b=d6F/r9GZsr4Ba3oFESkVGiywWZfruRi/M8clSEoi18r2N0R2llJhtdO1A3laBlBo2l
         IwmOXyrcwBTxrPSpHiVIS0mYaELEKKPWh8NaHkSbCzQ9hCakRD1bW14jxD9hHuG/lvZf
         hDM64FYXbwQo7EvevkbeTVpBSDHXW9diZRCdn+cLP+qRmuVWwYkeGhmH3/2rGebT49x8
         d5pFmE+fF9/j+7BnT+SFd5huaysFgtC4FADKYE/pI7sD12hy7B/EaPTPhrt1oDN/wEGN
         LlqEPzgUARXFNZrfWvBBuCk3uLQUzPHE/sRU9oJhNp3ukZPEfhuKu1yl1dOYMeAYeNCK
         sohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701372056; x=1701976856;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zMF7VYY19D+eQIQZfWXe7V4YN2em5TdIIdXRtsbpR4I=;
        b=pKcrnjG5ltwrUyVCB6iECl01PZ4aXjzgFRmqLvrAZdWZY3OM0k3D8fu+M4Rne5AB5B
         /sm+VNTBP4SXiPZbfj59cvfvddCLeCDPuqz1rmXnVF74841ZmfqENyx5HdKAe/g5u8Rr
         vbNf7V6YzFK4qJokSrdNwp9HvuH1KwYPg3j5UsFItymKMEBX1zbWBRVuCdXX5hQIg4S2
         OeWp91tO6Qp70IXfiKMfLJ+/hxp8UuYv6T8HGX1z/pudQ3CGZQ5OKpDXNHh4AhFNCrlf
         p0pU0JWawsJjbAqDiPyJWjNgvbze+fmN0Qv+kRFhLpOkur4d7BnPQNswaFBCC6HW+aH3
         mzwg==
X-Gm-Message-State: AOJu0Yw/u9dqr6okuwbdB3v2d7ftQDBj690tLp0I3p3QojrexSUHW6k9
	XnAyxFo2yZQSWiYmF86vjxo=
X-Google-Smtp-Source: AGHT+IFxLmHWM3NUzIFmoQzZlN929a8bl8rPrUilhkGpBTMEF1AGJcDLaYs+MZJsH0llFk4AFe59Eg==
X-Received: by 2002:a05:620a:3d0d:b0:77d:ce26:beab with SMTP id tq13-20020a05620a3d0d00b0077dce26beabmr5065261qkn.63.1701372056036;
        Thu, 30 Nov 2023 11:20:56 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b12-20020a05620a0ccc00b0077dd098d0b6sm756877qkj.109.2023.11.30.11.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Nov 2023 11:20:55 -0800 (PST)
Message-ID: <9c78fd82-d984-4426-84f9-957db4cb9971@gmail.com>
Date: Thu, 30 Nov 2023 11:20:51 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/112] 6.6.4-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231130162140.298098091@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/30/23 08:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.4 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Dec 2023 16:21:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

