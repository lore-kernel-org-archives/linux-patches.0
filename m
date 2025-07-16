Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816CF2F3C3E
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 16:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752682946; cv=none; b=pincL0Twd1EYnFy4uUTit5JBqZDAtxRdfCGQwBpz0JFNtnkfgedBrm6EBHKtvUxKYr6BehIZD+d6kPYcwgcO3aXKKOoqQcaIJHha+9uY8SHCWR2dVJLxCBFeVt34sLkPK4IsAh0QVs0kFgYMUNigP2rO//GZxAGE1Uty/d+NAOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752682946; c=relaxed/simple;
	bh=AEkYO6oYj3n8YvSDi56gQddt6FxNyzr/xpDU2dcuCbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O6jhwvf/dBn06C6kHI/eQApVdOF5hQ7oYaCEidBrCOTJFOm9lKr0n+7WP1lI+YcuyBOz7xAisXveuWkD7P42Fc1ShaapQ9/YtrnZPeevQOpAKXknmD/+HEpjn8g6prWQ9zIoGreY/i7nXpiNv+tNGkvf94NC/ruXHb1YQMkfVYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b4R5gmcw; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b4R5gmcw"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6ecf99dd567so1577496d6.0
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 09:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752682943; x=1753287743; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8JyUIA1wZL/E/w4gMI2RQwwZYPmSniyeepn20poSwjQ=;
        b=b4R5gmcwGAs0wB9dvpxPgsbyu0yf+mTf77dWww1A7plXre8pP3bvsP8pPOy/9olhra
         zXqRjfV3BVBCGlfDms+BeRZAG6d+BJ/eGErfOF1JgXDpglDjDlhUCTctbj3n5Cu3qdHJ
         AaH19qecVW+InsSQz8RPwChtOp6tOXTOTNFl9opnu/vo4NdGlcSTWQp0ahKag8Wowdjo
         8tqdczmMhUrh+esCDKX4pL95jYkorQSh9u1v3fMU2AqvV6iyFJKguBg3r9S9KLCNhOpH
         UG7QVKOVMGzsdKP6W3SryF2ya8S4E8kgGWEHosbeWaqOJqE1WNJvqL75cdq2inmlynRO
         gD8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752682943; x=1753287743;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8JyUIA1wZL/E/w4gMI2RQwwZYPmSniyeepn20poSwjQ=;
        b=Sre8Y7wbkqDr0cR32y3oTYo4PLuua9i3bYsTtC21SI+1P1RPRgMTNXzvkVamtJ8b0U
         iSuYOQ75PaAEZzQCy3gMYS21+AI272M4fxQGn4/tHBRe+vaCDYPGmMzAKyw4Mzy+qoF8
         aDoXCBpfmKeZwOGhJlOxyeztWnPDAqsTbWqgfSp53Y0j+MfqdSYqJGt6TlIIT1PKaETx
         05pxZd6kMG6lw0bIR+0u0u9m41fLt/Ws96O3rmef53T+NzrkTDN51Dx3YRrD586ci76h
         8nCcTOM1aENu+/tsxTh/4IODv6wI1ycbNvBhMtzTHh5kWPBU+JQTZQoM7SJnEBRCvPbQ
         LUJA==
X-Gm-Message-State: AOJu0Yy6T6Kj3O3Fwr1q9HEJVJ1P5k1Za7gEpftZCtNWZ1AJ/yGjNG3R
	KPO4p6fP5kZrI8DIfu/dJ9vLheP/IbrtmaLlWoKsKzXAiTTfYkpIwgmW
X-Gm-Gg: ASbGncv8/wEbg0k6MJR59ffjfJCYyMIzxmH/yjDOk+/9YvGaPkyuudQ5dpXDEHyPUkp
	ocq/WJ56ppBbgiUcDzsimMVIhDAZtTJ0KjjLMYNTjnEMMvaFE+AkSa0hRMiGfMknHZoxV0sLOj+
	R+rOYuT5XZgahuyoT8cxhKCd6bzdWZb/l4PLs0EnWLSXBV/1FYkisSR9u6H7un1LrqV2U3DfLZT
	wjZ+mVgKg18mw/2rkprZzyze684bh9RBZzr/Kih+0VTAZOZRonJ9lHptRkpbuXSm5rn0KDGZdYm
	xRXKRpqdfw+fgbkyqIQJCY/asOVP8JrtPEE1KS0kQzvjRm4Cmd00VdKByKKODBJamSwDsRwV+Xd
	MKeSwfrBwCRezbp71P1+XLFyM9yxA6WhrabONABbNCV33P0FoJg==
X-Google-Smtp-Source: AGHT+IGnq+ZTdn91l5dBQONzf+LTqEAMtSkk8h0S1ZABalUhbOBTvCKWG5dV1L2XaCxeaaYdzTNzEQ==
X-Received: by 2002:a05:6214:31a1:b0:6fa:d8bb:294c with SMTP id 6a1803df08f44-704f6a55fdfmr41080086d6.14.1752682943230;
        Wed, 16 Jul 2025 09:22:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70497d39d1fsm72406036d6.64.2025.07.16.09.22.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 09:22:22 -0700 (PDT)
Message-ID: <fc781703-e355-4ea3-aaf9-50c6fe90b628@gmail.com>
Date: Wed, 16 Jul 2025 09:22:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/144] 5.4.296-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250716141302.507854168@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250716141302.507854168@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/25 07:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.296 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jul 2025 14:12:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.296-rc2.gz
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
