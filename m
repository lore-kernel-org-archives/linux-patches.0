Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EDE37BE66
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 16:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776790541; cv=none; b=mnAny+SQIMRMPvfpXaCp25K50vxi0UNQCThXYfeVd5mAl0+Fw5vn3nT2P+jZMu/EUiLx26LpKuNhyiolJeAJajfsUWx5Fmtje7UVCJZL+fpyOR1f7oaNJdA/QHDSLMbVJHcSPakkZHVwzkL8XZBf8WxW81/W1QIb6f7DNQJbcCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776790541; c=relaxed/simple;
	bh=sz/zUddagZdBpM+1x065rCU+wY3xqxGaX8mRfw4d/tg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z7tFG2eY2aU+dc/If96S9CG8+/IvMUeLSGZsthUbAfBATl2yzJlfBPyUkazNLQsbvTECF4P6OYwYvqX3ecl0so6WWboU7ZnOb6O+P6FVdVLCU0WK9uchLEPVXD59o2h6OTEeYo8TD4Xq4pntv9jMN9xR+4EBW67J3U+jClWCfUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VH89USuA; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VH89USuA"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7dca5f64e86so2501632a34.0
        for <patches@lists.linux.dev>; Tue, 21 Apr 2026 09:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1776790539; x=1777395339; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ourW28idMA52G3od4NF/tAMZiEMb5C+2cC4gr13Zqic=;
        b=VH89USuA8zAIWMiIjenQjf1mLsB71OHLjRhZilOoGoSwpXY/og5pnLl8tWLpcjoiCg
         QYygr1xPenTHds+oW/H687YMSW4haM431wxi9pYOKEAY1JnuVDZXMt9YQCDQmDtTV8B0
         22UW3PhSiCXQnYvv3hQRNWvS1Sa86c1FxBNK0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776790539; x=1777395339;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ourW28idMA52G3od4NF/tAMZiEMb5C+2cC4gr13Zqic=;
        b=A9hw4ke9WQIp4kCl71mPJw9fi7dAxvUOGleT1k49PDAKM+fl8Tbmc7W+umL2xQEBbl
         M0D8zeixTTKE2UAQpxwzqd+0vz58S3FDlacG0AcXkzedHSF4jjuRMErsbMEFwqFefZz3
         oZzccvfHhcxJCya2tWVYZE+fFrOXfK70FAtKIJgERlLqlkE3xT/aF0KhwRYCN5ilI/dT
         pxAOOxCTBCJGQ1at/sfQ+TSQrF3t5aDxk52OigEuxPzzFEEf40P2L1vZGz6S2MPhSset
         bbSLKzPYS4N12WoUgwvV1s9c57UnEencxy0eOHeZoxPdZn6ifnyvJjNL3Wbc0IJpQbRu
         KN2Q==
X-Gm-Message-State: AOJu0Yy1qVD5Uu6ZqgQwzFTLsKMACRwcGWYHjQv4JSTB/iwzRUNS96eV
	eNrXflJC33e80A8CUqSd/U4FUg6++IQzf2w15jg0AtkmcoY/KPMS5mOr9FlOrM+t86Y=
X-Gm-Gg: AeBDiespzkGOLo2sLvUr6AFZCSgdfcBX2XMwbBpsN1K59wxxZyDHjUDtp331ybwICoM
	5EB5Jfsg3VpoPBFcg2QF8cAgjJFHkR45A+nZl/u5U3h8bvIdBidBhbGXjyLyWKd5P0tgLRyCl8j
	fwiKjKvkZOHSUqCGU866C9g1dv0mX2DaoXUdmrgoJuE/ajp3Zz8NGEPXwH6Pi21iMnQpM571o89
	aOCtJ3wQaGPbWe0OjFk960PA7SOSfVKlmkvt4758l4VECD5ytPhD6MJTNaIwXvDTYEndNWOMftY
	vxUPAYvBfNtGruk4TJQn9BE8dbFXrtoJ7mTSe9sMWSprKqL0RzEKL+7o5++Yu7yY1GoZAAiUr4/
	JUxjkBeiiKT7HHYvVYDVIatRcZVlG4XVvmrI6dgVm7BDlVheHutQ8qbCA89A9OQdVl8C9l7p+wv
	tOuXfBRNKpKUjnJWoiWank5ajPIrZjBVGgOOTCwzYNpA==
X-Received: by 2002:a05:6820:2904:b0:694:8ad6:245f with SMTP id 006d021491bc7-6948ad62cb8mr4441906eaf.43.1776790538681;
        Tue, 21 Apr 2026 09:55:38 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69464eeee56sm9084401eaf.8.2026.04.21.09.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 09:55:38 -0700 (PDT)
Message-ID: <b09106f4-53fe-4e63-85be-cc048de844fb@linuxfoundation.org>
Date: Tue, 21 Apr 2026 10:55:36 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/198] 6.18.24-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/26 09:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.24 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2026 15:38:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.24-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
