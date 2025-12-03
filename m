Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA56D398FA5
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 19:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788547; cv=none; b=i+K5Tr7s3jR2xQogliRxWdHhYkcMygb+cC2uh0az071l0V3rAwe65dMJQoTN5cDyLUASV3dmVmczFGtTLmDpkdwr7s764Eqj9vpoGcqpJEo1YwPfQDyhkg5NC0zprGzx8eyJIIYy9J8fkRliL+/jBFk7pE0P5oy7htFVxSbQLb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788547; c=relaxed/simple;
	bh=gSUprc+56YUzj8fgsqVZWus/RKQibX8RMFDe6L0cHO0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sAkbt9d9U/YZfBJsULlmrXI6KP02r96Xvqj3pl/ZCDG4q2LEcL9wu9H03RvfiAKVD7kG10/lwQ0oGawWI7vYd8KqFnn0e+l8cX88yR3GLQp7XZ/wnePEym9ly0uRiJhXg9FNEj9gnuD60Io0N7trkf5+gsh24qqqA87ciPDRn+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g8lXTKhx; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8lXTKhx"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8b2ea5a44a9so8825385a.0
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 11:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764788545; x=1765393345; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qo85Dy+/DZbtDoZowQvrUVbRsQBc0NiAo2e3EiuSU6w=;
        b=g8lXTKhxqawNeNo+i820x3e3Iv97cL6imRLvs0Fp3ogNuCSCBHExOORZTpIio29FwV
         eFq6c3NsYM90CQ2pdV9uTcpF6vP2kzhsdLLcaQDfEaLv6QqKtTj2ypmGwFHSzjfxt3xd
         Biw2dNLgLJzNEWNm6YmfXwu8Lcds4632oDK0DlsoFwblcwhLXdAOz60Md1KpxOdH0H82
         ylunWlEV4A5M2mUPlagBEmt4Ct5jGKztv9zIhNIpFAnQ8+ggSrMlQfUHk1BG22gi4kAn
         fxiF8gK1lk8kqV28RwCMZY0InYNPflMifW+zuAwrJD+BMgQvZdZjXpdn+9P2w6uDBErL
         4+kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788545; x=1765393345;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qo85Dy+/DZbtDoZowQvrUVbRsQBc0NiAo2e3EiuSU6w=;
        b=i/jQTjrGCkM9cmYF6yVmdQoSGqUCyI8LObfIKFBviklGUnuwn5IU5RPxy1ZLdMqVc4
         lNzfe8uvJ9H3z424U/a7t1NDVU9gjvrLs3upsqnZfXUN7tg3Y4DwpfMiK//HJsWOcSiB
         7KPf3y4ZAQGPqj5tPxm4597uc735B1N1vxzVXn87wv/PrTMX9GUm0TKmZr6yoGn0x1wO
         k98oEHHRB15umfuaPp/mKHB5fVPDwKmYgcFyEREpY3oOoKI2FEsVo/V5ItyG12x9vc16
         VB/nNwHRsOiuhNQmkbOde6M2UPM+3bP5LzoCeZ+fwK3NfmY0I4QlL5IwDvXDTCoTCWDo
         iWrw==
X-Gm-Message-State: AOJu0Yz5CmO9lfllPUVNkP+Zc+ne3MDYZxYIqsMMU+B2LK3gA96UxinG
	VtdoECG8K9KbZ4h6Q9bil2ceNy6Z7OgyP2ZAVv7h8QEVUn4XNP24rHDf
X-Gm-Gg: ASbGncvyNZPoodpXKHXkyikh07ECjafnDvUEowwRxPoIKSj/+blNfdnTa9BYWiRLR6D
	mMfC6Lus4oPncEyhHu6EGJyPLKyM8hR6f5BOW4Onf6At7egc9MrDZWiux8hlkAR9vgf5mZ0jOvy
	Og7/e43OdP7G6HYM4ZrlzCwUU0B3oBx0lxqpNBFayaR1eBFlWCqcdfZZV4/Zo9DA0doQSuFQYso
	ihC+laSIQRfC/YOLHe9UXuBSdrczIQNBibyBbuf38HxK0t3QcRmbwODKCw/KCt4rqtBW3iLk7nj
	8CHe3R8ZgSqlWkKmiohwwhoXn/jlv/kVJ4t88IRD+FiJKpznddhmG1L8qadYZTFuOEuZ6uzMfWT
	0q6K+5YfnwhO8oiAFeimftlj5Lecjr7wAEDxw8O8OExF2PREZcg+K1mtunVM/3K9V356BN2GvNl
	O2XLbGA1JRsOhKuFusPUmO1ecxZj+R1NUwdhD6tw==
X-Google-Smtp-Source: AGHT+IGZ7M5Ek+9KL7R4MHRIRNdNjbT4XVu7oyAnvEmwQDhAF/XU28LW0FKfaZ8VuQvsS5yo/iOomg==
X-Received: by 2002:a05:6214:2408:b0:882:5e6e:b94d with SMTP id 6a1803df08f44-8882489d2bfmr5970726d6.39.1764788544617;
        Wed, 03 Dec 2025 11:02:24 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b493f3sm132634746d6.31.2025.12.03.11.02.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 11:02:23 -0800 (PST)
Message-ID: <58dc6e9e-f16b-473e-b7dc-eb7a2721c729@gmail.com>
Date: Wed, 3 Dec 2025 11:02:20 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251203152346.456176474@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 07:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.11 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
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
