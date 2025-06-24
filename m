Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD76E2D8DB9
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 17:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750786677; cv=none; b=d8WJ02OYg2lYG3jZcYzhXEBAj5QXU8LzBz2uvQuu2+LDjYwtbM5mvI/OG/ox+jk/00nUhNWYUnZRBwfvD/F1iAmr12K3UgaWWtbRSbrULXqkHpdh91tY68s5CyZ4p3j2IAoVk1YZgqqxa8mgR6E45DYj+k+60DzYFl3b+pnYgMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750786677; c=relaxed/simple;
	bh=ukmnTODouOFjPUParCF5o0rMy+sxb6HlnqGiPe85+To=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RrwBLkZm5F6T22PbWKRbSgwJRVN3nBYd/em3Xjxq5Gwvt8lz0QMeQOWhDQz25Z/eRQ4/nSysSx1/gFXzyYpsQ4QZSh5sMYChPtiANlf5Z53CDFR9x6UQBHOu9VBh6YIkjyLexfD3wqH2ksDhpOL2KQ974vCslVQUjC8KxQaEqzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RbZab/Bt; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RbZab/Bt"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7426c44e014so339904b3a.3
        for <patches@lists.linux.dev>; Tue, 24 Jun 2025 10:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750786675; x=1751391475; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=aek7AfukVB3w8z+c8ayab+lJztJVDxSWIM4wv2o679c=;
        b=RbZab/BtqOAYvUYCVuXg7TiWqwwtqMumsdHeUeZQzvGYUWOYaOab3kbssv9iY31irr
         FfBm3zyzZEp8WHvKew+0sZwjAMC7kCS4av8VPx7AXGW/VqZ2Pa8dxZnvZVXjW4kWfWJP
         i5KgJeJtpNT67c3Z/KFBMYsQ10NdtbSWexOzvFUStQQnAwCHFsPxOp9od7ZzKVmIRLSG
         2ghkQksMPAveKpDCbw0u7bH6+CMZxMkRtJ0QpxCvUP8dBmmsLaThpueMf3MrFNMWdbIH
         lde+8lFYxkZFlK5UdvAkuLFRZxHoZa4jP7luugujeTKyoa4qEeXvwC4WfP2aCI0H6ILG
         LPoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750786675; x=1751391475;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aek7AfukVB3w8z+c8ayab+lJztJVDxSWIM4wv2o679c=;
        b=uQJnpZe4ct+SzGPqoPbUtw9n19JU8tsw7fiaXnsvNBOCM4KEaMk0OgNuzt1tgxNcrh
         2R41EDRfrwBHWmAUJ1Qr+HOBDEBpEDeugjN772zLnwaDNFfvDvPytsRvmnLAFLcVgp0t
         Gu3560kAvJBS1uZ9EBqXjJD5TlfbNu3TD9x/yw6eNfF1+0AsFtmYic4+Z2p0VtBecP2m
         kDmdYjqJmJTL4wIOsQm0DlgQzMdiSeUGW2bY/WG92rDOymW/IGG9L/kSPjFId5Z1n75F
         qLaeO2QHZVYweTrSIFQPTQeKxS7KJQrO4eWN3y8L1ukX/y+ngvug+WgpXj+OtTzcILGV
         gveA==
X-Gm-Message-State: AOJu0YwqvfHi4oMWnDACORYSEEbFGa/F+xSbEQE81J63otRMsdtcoxYA
	rnfDwMkQRlgVTfGTNPpYrPsMXgZu4UudI/6oXq+HxBKPNk9iczaoayM8
X-Gm-Gg: ASbGncuerRfd6SWUo7kR2nmFcgF/BERfr84Mn5Az+xCme1kxsCTqc/xXzODmtcU91wO
	9isyFF+cLnRydNLcr0adeo570u4stozBpQ1LnnWhBLzjorLbvwcUCNiERfW1kOz1D+KYTn7NYwN
	eZM5T51x1qeQAva3BSlOBfbKFeSOyBgzQ608x6hn3WTYJelag+DNRLT9lzGIRUHM4yNeW4zDw2L
	+SNoPkPyXmIfUdBNzZU9+EKtlCzmw5GWVOLQa6MhIUwkOaKpE0qKSeQMWo6iB+KUnaA7KpAaHOM
	y9uJHHaQ1cl8QwR+SNVqGJoQXsAw9L6LNVJju948sz/QP5nSjmlk+mMFrDZn4nEyJ1nNv5i2wJ6
	h3GxpmJulp99V2w==
X-Google-Smtp-Source: AGHT+IHDle5XI/EZff4+1+7+lpJPC7D34r2C4A4aRi7/ONzVB8eo26lB95DtEE3BuCBhWNHQSOCXFA==
X-Received: by 2002:a17:903:1a0e:b0:236:9726:7264 with SMTP id d9443c01a7336-238245455demr1377075ad.5.1750786675103;
        Tue, 24 Jun 2025 10:37:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d86d5efasm116834965ad.208.2025.06.24.10.37.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 10:37:54 -0700 (PDT)
Message-ID: <6a86e89f-3786-44f6-83e9-05ddfe7e6ebb@gmail.com>
Date: Tue, 24 Jun 2025 10:37:52 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250624121449.136416081@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250624121449.136416081@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/24/25 05:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 588 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
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
