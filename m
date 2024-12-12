Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3222F2F
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 21:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734040322; cv=none; b=iptY2rPyyFzX9JaVLVeZx+dWbXHIM1CEx4Bj5ANsoAle8Be2Oyljpl3NU7XXWqEVZE1pD5TlHXwHN/tydjy4nN2gt+Uy5fLV1KoHwSZ+jaWSE26ybYuj3BBpsKbapPjh556kx0GbP/ZR89Q9GCkwE3m6W5tjiqf7EiUd0oOTgsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734040322; c=relaxed/simple;
	bh=s/u+S5fI0oxWThrySGDZ+uQ39fhjMr16rI7bxXcKSos=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q8zQflsnXkh+EJ2rSy//+F2Ah0w5t9X72gIN4fFzF9/p6/YOhKEu+Fe4+hqqJv2RLPVTRApp/j+ClsPwxOrCWLjtKHQjnEV/EZdfOCi9yXEb1SSGe67BOlfa9LxX3oDRA4hMJKD8oBBF1TqMhtJcMO7kfq0D305Kqrhwhm4yZlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OfZTsE8m; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OfZTsE8m"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6d900c27af7so12763556d6.2
        for <patches@lists.linux.dev>; Thu, 12 Dec 2024 13:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734040319; x=1734645119; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kcFzdw8H1Ecuj/czdwp7a4rGtX82WZQz7xnDKzwYtFo=;
        b=OfZTsE8mQ6TJ/cz3bL1HTpRvmQlBnP1KDUkT8iMLxYMCowWREnWCgQclGyuUrrNuQ8
         fTeojqD2GO+qUsYIRGJqfUOtFqzdvmAZxPwZAZHRDBd/Z0JhL7CWS9/+MX9/PBhA2QMV
         HYKrZ+ftI9ySUfgASGYbrta4fizMT64LQG9MCnsX8CJAGC51RnE39mZzZzpL+XHPwPN/
         8ZaudC0L9+ZoqpfiDfvUD+inWBmqDLTAbCPH0+YvRVQzwRyFB0cRnC9IePTUVdT58XjC
         6TVCiEUetp1d9DUDVP/na0GrVDzA+NbeOHiMW1ZPPRE2Hju9IdbRrNXsEuZnZp9XI6Gl
         TA0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734040319; x=1734645119;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kcFzdw8H1Ecuj/czdwp7a4rGtX82WZQz7xnDKzwYtFo=;
        b=VkMAvtHH5IYl/gRPzw3by2hiJjorsWB3rymkvm510p+IGRVV4gA9bpUs5mFFtOxPMF
         XlLQyaaJUJ5NSDcMCZUL56z2LmHZhLb1SLbLaHtV0lz8fZ01utjgYsxHmDEPuCQyx1hx
         vA5dMjVjxWhLiKgNuMyJ8eHQPTunkt4ZGLfa/TxHurH0UULph7dHNbi7KS9Mk8xUcqf9
         Jb1yegoiQYk4DSpLYMgRSDy5ON5Ldfi0za2UpEJrrHHY+mgWTGLDHS3Osoh4IbSuWKAe
         wF3KgKDFU4PfCVehEoHiA2cK2/h1TnU6ZwVA/STR6lfFEN/Os1SV7APkXH2QDSJt/dxO
         HaYw==
X-Gm-Message-State: AOJu0YyseXULRUzjN3iI0Kh98xgf5THiYK2EGAQvTRiO5t00SBRiR4P5
	MZLToS6cvrJDA5keMqwtCNF1AtMfm723bzLig3FkEiqEo4A1y89Z
X-Gm-Gg: ASbGncvC+a7ErKPPJ1bcfUiIbmWY2FjJMUNHKJbg0bxlwi2KypvjTNPrFm5VfDNFtay
	Rg2wxgk6elEtyboUOruPt2rjNtiL4ETrzFjpSMqmi7uh4687lUslzzw38b9Xmmx+vc759USV3eF
	3sxqTaFsrFgVLO73qjOjMiWCbgfmhIdHTrvWsxMkBkTKnscErOz6Ky4tZh4FvhuhBtyCRCs2Z3O
	LvKjYItKMkptlnR2W9ZHybjudlhbp2gf3wiQdGVJg+I3RhIK23zoi6/J3lJeibWUY++FRb+0OsF
	86MoMV8O
X-Google-Smtp-Source: AGHT+IHSNncV1f+Wme/w15WeQyxDzjdA9RpMNoZ9Ddx7t8zipCV2Pn9kbCK4gbcqRNU2l9lSFZCtbQ==
X-Received: by 2002:a05:6214:e47:b0:6cb:f40c:b868 with SMTP id 6a1803df08f44-6dc9684fad3mr2270066d6.46.1734040319601;
        Thu, 12 Dec 2024 13:51:59 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d8da565dc2sm87298316d6.0.2024.12.12.13.51.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 13:51:59 -0800 (PST)
Message-ID: <8f9941a1-b1dd-4ec4-ad19-f6b2a5d035c6@gmail.com>
Date: Thu, 12 Dec 2024 13:51:51 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/356] 6.6.66-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241212144244.601729511@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/24 06:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.66 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.66-rc1.gz
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
