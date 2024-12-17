Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFC81F8AD5
	for <patches@lists.linux.dev>; Tue, 17 Dec 2024 18:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734461536; cv=none; b=bABm3Nlm4U4Z4R1/RlEAYX111RE7XFmkJLfBrt8CYqsOdz5QUMEAhTJDum1nrvoE3Yl/Xe5dCiNzWzVQgSe+lvmfuBivHeDIeN6IEsgWmIpnvygmvPlVc/UZj+EKhZFtzhBjEwQsKVifajBlianLks9veAG+Ga35tFNmdc4FBhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734461536; c=relaxed/simple;
	bh=/etiGLYb6+MfQgjoNA9IYT1CsKUnL16ygRaz1c8zntc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q7dnM9dupSmBhL9i2A0reYHzXkKIJwrRNXCDMi81gqtq6hCXIkEgRYOUkQzPl18VvS604/elCYnVXupopOVMt51gxfdwvjoJbPi0w79U0Cd9YnqGWxs5jrNbv19DpU6kCL3eqochvuVorp02FlmWjgh92KF5Dx1rPtnxc9ITHbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C+23GCxn; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C+23GCxn"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-725dbdf380aso4565328b3a.3
        for <patches@lists.linux.dev>; Tue, 17 Dec 2024 10:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734461534; x=1735066334; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bgIpkDqzo5LovdV7zOJn2TkrWt3t5KenuSiX8WMCjDA=;
        b=C+23GCxnOLdMCjwsSvAY54rQYjz3031qPbdR+pAS4Kxyy88USAg0ISEgFw1BoWmy0c
         akbyCtSP4Z1VxfKM6+cRI5fZb+AsbQzZfNhwxkFp2hGt8Q19zpLwkpg5rFG7CZCCcyZX
         qb2acbzbKj1hFjq/JhgbxMeNXY61SDsY51gtgQdmwRchpb3EF+TTqOtXW9+m6O5+uiuK
         ZxTe68latLmAyXINVq+7mKEa7fBXTcp+sB08hCOuBPJLDPkDtMgEodWHJX/V+WSCom6i
         RyY3zNdqDxhyn2qcnRGeoRiPufXz245A6rh4eUlSAqzkBUQn47vZP5nf4E1t2cVtzGKy
         SlKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734461534; x=1735066334;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgIpkDqzo5LovdV7zOJn2TkrWt3t5KenuSiX8WMCjDA=;
        b=d6xph+WmQsodBz2k/nsSb/Ieym7fX+E0oYPLWYalNkvhf5/MjObE1a7rNjmQEk9TKw
         nGndsYzYv2Em4D+e3IXy7f1WncDRZe4cWNmU3tLQZoexAxpVwyg98OZOO9UPz8kCBkR2
         Lj+HJzq16CN5PBsLda7693D/WoIBWQj6Eerie3G5pXjUPsitSHC3TOpw1EtIFg2bHhDB
         8pjk4rd3K5ine5+DdWaEvZ5H3UybSlLF2/2zvZrKd/eFyhIZMty7MUnaVJsRqXpZq2yn
         gAIAuK8lut7Pl2jzWQG/DRHrghRgzs1Qh/BOLezhxMXkq90I2FNFk6tR3CtP8yJ6tjqJ
         Mj9Q==
X-Gm-Message-State: AOJu0YwpQEy7eDyS4nX2+UyHoJtAxaDlIDQ8TICNBVvhySsfrBL/BHFb
	T17mt6Qh9wETi6rsFwOund0rX65y2jfSWEJ/QVZ9R0E5IScsi6mb
X-Gm-Gg: ASbGnculWRWu9aFi6sl0IC03VnaNpBOyT+iW5b5wbyU7Bj8IOrhJ2xdoigBYC1x0Qpk
	bEeD5yrEjPmoHeQ4yw358ZwgzLV1zOwT4fzZSOmaN6alJsskJbdMDvF8b0iI1uE0qI4kEJXacUB
	mFGNW26onPD/VoThOhjPqACFDaK14vou7TLKM+oooc6/llJwzBJxnCRrJXkPnTpOpqv9Jm72I9B
	4dkHHvO4ktxn5l7EwyqsVyHRho/cuPQpOjQ37IjARVRFo0qM7+8D2rMVkfHGJ7TkBc/hP6RJnZ8
	LZ9bNakG
X-Google-Smtp-Source: AGHT+IE9hqmgSAulIjqksU6FSJulmX78oa+gvTLKDjBvUJrjZ2I//IhcH3i80HSHr5i4VGLPdVvQuA==
X-Received: by 2002:a05:6a20:9f96:b0:1e1:abd6:ca66 with SMTP id adf61e73a8af0-1e5b4822a81mr190595637.24.1734461534472;
        Tue, 17 Dec 2024 10:52:14 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72918ac5258sm7284782b3a.20.2024.12.17.10.52.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 10:52:13 -0800 (PST)
Message-ID: <f50b26a3-21bd-4e6d-962c-4b971a15dddd@gmail.com>
Date: Tue, 17 Dec 2024 10:52:07 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/24] 5.4.288-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241217170519.006786596@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/17/24 09:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.288 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.288-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
