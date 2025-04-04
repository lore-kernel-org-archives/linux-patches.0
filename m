Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145B56F06A
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 17:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743786071; cv=none; b=CiyMttPk/kGeJdddEPsK2XfFXkritI6b+acbx1vDXMeK4fYEAHKDeBWiZr0HkQacd7wOUlcXdTkkGQcyhZjTiwMIzPNoIcRnpCbkYNtHZVE7/arXuhL/FYM7LTo85+dNpRq1OcPfHU4RXd7V9L/O+OIVI7HXm88hGDynrQE4ORU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743786071; c=relaxed/simple;
	bh=Eey/maLP5t3GfmoMy7Epfg/3yPZrQ3AoX73XYqCw1II=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bMsuygGukgqpFOLK6pOQdJMF4GxcS5+R+TG3arOZ6aZ7zNOzlbdoLzNY/wbxxYg2JJiyuSNN2+Kjw1dIzM4ObV2ykwyXFeT13rLAMb8RInToFgi8dHwMakVODkE+/PWbXeAIvcCWbLC6oN8hcqAyN1TNumg3kf0VmDpLjRP10NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S2PMNbXP; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S2PMNbXP"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-2c1c9b7bd9aso1263148fac.0
        for <patches@lists.linux.dev>; Fri, 04 Apr 2025 10:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743786069; x=1744390869; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JksFRRTKNUNfylutjBDAGCEzbkNldEBZJuwSZCc1wT8=;
        b=S2PMNbXPsfElAgcLPazf0Oc8gM3g4+cCVe1TU7Uo4uhIhxq2yf01WWmTJMyJJSQxE7
         R1/ZLlhimhtHDegbJsNsSkxMMZsnAYPA9BKSZFow0MprQi1tULpfqCev1gN1PqIPHTf6
         fw3wCbR7L1dgaewgIKEyO8jBtCmgGKrnhglKzBGv+xhP2L2k4xNRSZgR/o9GmPDaHy0o
         dsFEH9gyVfc1D0oDUxNJpBKR1sUSrUEN6SD5F+rG8SMczswtjxpLmJNT6Q+mkeuthF3S
         EFhBTihHCu9H53aoGk7QelnTVYzlBn5L8ts4qVBsBQTyMqUI+oVabkl1AqbkvXa5MZ5x
         C9cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743786069; x=1744390869;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JksFRRTKNUNfylutjBDAGCEzbkNldEBZJuwSZCc1wT8=;
        b=lAXrcSAtieeglX7cOlpNTYEsqISNwaBNBMX5Eexa75YakSb0qWl7FnWp1IxRNySy1/
         z9/1FdYxdtrG6XPtOfoi6C9DkVisB2n6GzDVSZ3dlXznDZL2CNuS+Yd3ACuaDcA7kNJx
         EVp7cRaJOnT9aqKlPGMUuJu67sUm1gBOkXPYzN8zSMi9JnHZrHjc7JfEmd6cwfOzmrZi
         +wGF9R1VslJK0xTbPem4KIS1Ps+0n4iV8yIxLsw7w79IAPQo9LV7PY3VRUU5PbmWpozg
         HqPGs0yZ8Qh9FGZ6qKsUtP+YWn93GO/zCu+Ivy63kS9oXhnMVmTzSkLZM0VrbpS+cxdl
         Llmw==
X-Gm-Message-State: AOJu0YzfIJxmcfYTv0fWxQlI3eGxE1KSqQb8DBZaY1P+J9qnEhVMpP10
	zsPzzewa14SmK6jGfpyeFmvlgR9xMKvv/9iHZp22hXJ0KFIYweAY
X-Gm-Gg: ASbGncs9ciLpMKtNraAd0bM7jsQEiUCdqWdXvh3Dw4WRwGGHLFA4YA2JZSdWLOffVWN
	7gpJ8RWcywalMpc8yjzGKF5JHJcGaxyVuPv9ZOI30PTCqY0XvmbRycPrrYJa36nNErKMn/mVTiQ
	aFFSOcCZsBvbUCi6V64tHmWSTV9OaYe/uHoqMexY9bHXpXh2DsQBak91lPZ6xKIqzAUYeoWk0fX
	r8BYASvAuy1IKK8uUYMaxu7Rbw1S3MkDGYbqJGGDDOjTwFVehJV2eS1zv2EOOimyxluto0Gxxdn
	KV3dy0QS+3amU6g1bHYGZrLnQXspUhLe4T7Wmw6zrqkI6hCaGgOFNBYkd/90h2V9G21F9QQV
X-Google-Smtp-Source: AGHT+IEEV78mhJS4Zh/Uy4Aa3TIaZb9tAPCVkb9g+HYyAtDg1fY5c490dSQeRm+stMXN2Up3i0EfXg==
X-Received: by 2002:a05:6871:418e:b0:2c1:461f:309a with SMTP id 586e51a60fabf-2cca18c7d0fmr1962290fac.8.1743786069034;
        Fri, 04 Apr 2025 10:01:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2cc845c99f9sm793344fac.16.2025.04.04.10.01.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 10:01:08 -0700 (PDT)
Message-ID: <5cae82be-7244-43f3-a009-045580087f08@gmail.com>
Date: Fri, 4 Apr 2025 10:01:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 00/21] 6.14.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250403151621.130541515@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/25 08:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
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
