Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0BE1F76BC
	for <patches@lists.linux.dev>; Tue, 17 Dec 2024 19:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734464573; cv=none; b=e4Jx1JOl2GjbAeQm8wcFFm6V9ABbHUld3vAOZwXi4V60zbc0V+vMoYieIevBjoTEz0jfsOP1L3mXEgy2pcHmGWbxbyZcqixS1x2NhR/XUxWkBOjnWC7NU5ZmyrEOVnHqgnIk3RGMqqzg0cUg3gXQGWZ1E0mWGjyCluRBfOw/d0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734464573; c=relaxed/simple;
	bh=grpmLojCHp+hPkhQW/oQqd9Z+Et1rtyJoU2nzw+jq8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HUz/xvs/mnA77gN4BfZiVxJ7TWtJOCYaxgtVqRYuZEk+IADfokjB60UqT69qwX6J1/sDfMwvlccLynELm1bKCxprH5GZyZoeZUVBJf+NKPYXzQwemLNk7TwGGOhttQsY6IRlMtS8BYmNl0XwgxYXdUddLIBuIkeG51vpXJiUcmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MZFggp2d; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MZFggp2d"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4361c705434so41462515e9.3
        for <patches@lists.linux.dev>; Tue, 17 Dec 2024 11:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734464570; x=1735069370; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Xjcy3NvbXADNyBSuuuwaRVLBqtPr7mOCdn9D0nVzhNs=;
        b=MZFggp2dVOzcz/xe/nysWMW6cFowDjlTop+rjWXgATOtO5bid6nBfIiUJ5vRwkLmDW
         hVyvfVz3cm9QKrWxng9cEsCWPf16HfrU96S9OE6pb1z0EREPqbtS+dPcKcPM0xq0KOiA
         XYcq5AxAxSmIghiVQF7sXudl/SoqezuXuOtlH3TN58teYQcV9lMUyPSkHijUXKzlOn39
         Qgp0inC8mM3WdC5wuOVKsgOpdub4CKnWLnBVy+3GlNZ0Iht/Z7rImAzJmyoicH4aNxol
         0iikPQTexZ5ClEWdaI6/SF83mnBjdp+QZr0NvzaPhhK5lbG6OgrKxgBRCmsstH7NLbIF
         Gcfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734464570; x=1735069370;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xjcy3NvbXADNyBSuuuwaRVLBqtPr7mOCdn9D0nVzhNs=;
        b=uj6aES6GvEE7dIsco0vRk/7Rf9PNBKLtA404z890e3MNOCIMRIsq03tPcO+uxqGr+G
         5LpfCdI9XeQypuuD9CadH2r+VzNNvg3MiZdN86u0aoFapxXReD5NdkMnjx2ugfz5F3q7
         vSPc6p/T3BnFPd/eZ/GLPkVZnKoCDWKmC4FPSnbY4VZcBNQYeRN34wnCF6K9ckTPAXlz
         s/i6mMoJQeFzKFblOltVAt31Win0c2kKv7O9J6v7dSDd2vpZPMhdqjEBpyKLoP/rVs1o
         rVCQHWjLmAgUXyaGuyycASj468kmqkMAqX2VFe5DkH0tRgWyFZqAvsubOoDFPwjBT4mv
         aeRA==
X-Gm-Message-State: AOJu0YyyyABGM9UzVZjtB+lRaxc2lE1+Mf+jsNcMn1H6FSrvz4wJZ9ex
	uwwedlp+yL5S7YZfAy+niggAZtLwG2p0EU1aQOX3tr+SYzd4JYzz
X-Gm-Gg: ASbGnct2ORakQiDNqwDqalFaxyKyZHlzAtdBCKL6rKT9Eo1INoO/ZOV4syb6smVoCyN
	jJzzvzj8ttBl30T0I3p9NSrixunmr5mDLN4bkye3a4+fcSgGISx24yl70xbZYoXf1i7Va+cNgfI
	3893L7YWFTdCPkTh4FfkJkCGNxnZJChC63gUJ2+U/RP9tiPpWIkRRqsekevaFaz8WSRZXHpp3hB
	OYBmZLcxzOvq8lNa4w0JPE0qELxwa6pSjpFgllmNVAjeE0cKfJvQsyADUDmFpMy3LF10LDrkusV
	t8ONU1+q
X-Google-Smtp-Source: AGHT+IEDvqJIQo75IpCM8BROExyo70sf/3Dzu8LlfDOb2fRkaAhslobAvOkSQes6CQnFNmeFRkNeXw==
X-Received: by 2002:a5d:5f4a:0:b0:385:e0d6:fb48 with SMTP id ffacd0b85a97d-388e4d2ddb7mr121407f8f.7.1734464569438;
        Tue, 17 Dec 2024 11:42:49 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c801a487sm12235816f8f.45.2024.12.17.11.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 11:42:48 -0800 (PST)
Message-ID: <979e05d4-3fd9-4e28-8f9e-67ce2b9ab938@gmail.com>
Date: Tue, 17 Dec 2024 11:42:40 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/51] 5.15.175-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241217170520.301972474@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/17/24 09:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.175 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.175-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
