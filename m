Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB37E1CDFC4
	for <patches@lists.linux.dev>; Tue, 27 Aug 2024 18:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724781783; cv=none; b=huKdFZ49D/WG15g02tNCChKCTuqh0OE9fawwX92Opu1R/fTeIUD3WTtmM0IFAL3D98COL8kLm1kkFVilkBqrjQqtU8rX8j9yErJ3m5u+zlVnlQXv2aTZIuM8oJCOKJlVLikudg4Yd8uP3h0dt0Hev4VmuX6BTyiXHH2igb0QTr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724781783; c=relaxed/simple;
	bh=uDSRe4+ypz3TK5ICKGKQf7MdUR2fS3TzFqfb5D8FN50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l7DbqNqJPqKmLuEZeOiDZWYwd/QkDHyN96t1uF6QcLfu7SpE6+t31nNU1jowcOjNJc/K5KBsjrt7IkjaBRfKO/RJ4BiWWgQIVMLUxYBHVMHD+g3wR8QMmOiUau+hIHWPyKNkwZb7TAquwE7ZGnz6Kv9qNQ1HDmWDCVVqUABMwQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kIg2kg0A; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kIg2kg0A"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71433cba1b7so4328510b3a.0
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 11:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724781781; x=1725386581; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FZcFyZyRdSFfHxupkjJyrWOtZv+pT4JWFFLO3DW9kp4=;
        b=kIg2kg0AihJc9CNvS3I5Fh670Uje+cFokG2TZaXuf0rx6sG1hfGfFwDrk1N/vBL3mc
         wCyuYkmj3cyKAjJ6ZhkbrDaV46n3mGXY1KN2J+j3M9zBMJJyRyDmtEGwvly4wAhCfCny
         CZnoH97pMIqRZYKltBdLPstfjB4r9NxHYbtNpQ0R/JkMLRtwBd9AVqdnjnw3wWuTJnf8
         aP0fyJd5yuFGtlUlvNinBzmH9wFmq5B8XcALUs4OdXezSTEUmgPTXtduh6MwVSCpiD8n
         ymRhXZaEPJm+Ai+CK0tTx5kS+XVJSz14TEFAoApuRtzZR8WsTZPL7ci0mwAUKwEzcxGS
         sVeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724781781; x=1725386581;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FZcFyZyRdSFfHxupkjJyrWOtZv+pT4JWFFLO3DW9kp4=;
        b=d3aqGYT2HhW0So4pOZQ0xah4w01iyREFiqkxPy8Liia6STfmyzP9DFur9h4b2bLL1o
         8eAduCAd/ShTG0SK+ERYo6rrUpjobXmtN95GrAQCzUo61ulp0agheORe/U60oW9xIL88
         6avRk7Nrm10SmTnjdQDiVJJhzbwKib5Bh2od5fcPr/UVFO6l2TVSeyZFpMxz/y+ml/Ju
         sq/m7o2QDUbGplvHOnzlnFqcNEJPM+urJyDvQkf2Lg0JmQNNrCE8Vw7R1FG/xA7gDhxk
         UDGEuTmb0xU6W/MxoIadcDXNe9eOgYMhCzbRaE3SRUoUdc1pHIznaqjiZgNv7Yh9E3Gh
         fCfA==
X-Gm-Message-State: AOJu0YyHvQYQ3JCxdkeS8SfpDjp0p1o3RiLrX5bThw861IU9o67ixHkn
	hqcryuS7bKbD4clAUpP9QWxRYPLhDnoHuXw+Sc1NsxglxQ6qmzDYXlskyQ==
X-Google-Smtp-Source: AGHT+IEm2yR2cpxVil+mWKoSNbqIrjenA9TLxT322rLBAqYECbuk0pTTEPLg5nnyzwL7snZPOq8AYA==
X-Received: by 2002:a05:6a20:9c8f:b0:1c4:bbb8:4d02 with SMTP id adf61e73a8af0-1ccc099746bmr3997304637.37.1724781780891;
        Tue, 27 Aug 2024 11:03:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-714342e2194sm8827604b3a.126.2024.08.27.11.02.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2024 11:03:00 -0700 (PDT)
Message-ID: <cca42eba-8b09-4552-ab2a-395cf28a6b24@gmail.com>
Date: Tue, 27 Aug 2024 11:02:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/273] 6.10.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240827143833.371588371@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/24 07:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.7 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
o--
Florian

