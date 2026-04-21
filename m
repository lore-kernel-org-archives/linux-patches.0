Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C6D37BE8C
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 16:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776789915; cv=none; b=MNGt4tUM5y4C8gQ9tgoI9jjMIiKwt4FSNTR15iI05aFvippiAFi1d+jeu8vLnsI05fhN/n/mX9m6ADuEjS52F1dnp9SbyitrT3ECFr4a/xljRx2dgW9HZIABU5O/6dngEuGJOAGV54iN3v8ntVHJPlmKtCkiVL0ii7P3Ohb/ta8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776789915; c=relaxed/simple;
	bh=Wg9l0RirddfRVz7clv+4y691T0p8Wcflwic/0H0PxH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RYhEMrgyUsN3nR5R/EUBrZvaDa0ON7nnFa5VYGRQ45otxZo/pnHEvj6HxU/p1RhHBTBg2px3AbDO/4HRMkyz4ihniLtU2+hKEXCr6DHmUjpdz4/nPTgPFJpqZ0kr7IVHkBDZlKHw8WYDBsX0na2FrXCEGhLqmezWWItvkJ2ihdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDlpiUdQ; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDlpiUdQ"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7dcd17e19b6so957338a34.1
        for <patches@lists.linux.dev>; Tue, 21 Apr 2026 09:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1776789913; x=1777394713; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jgVOVvPTrj4x2yPeEdE0VusRagUUHTAZD/Iokvor/7A=;
        b=EDlpiUdQzk8icJfNC2Oa9q5YJZ4jkX+j3VtA18mI2gIvPf5xQlc56Om8FehayrFH80
         3FcSJdObTFNSx4qp862Hzv/33A+QVhjB0fOXUf3uhC2JAjMMYi2wx0RSpjBdCEVLIkmg
         GgKSHq3jG4jV87YBlrIx/G4znU6yi0R32jV3M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776789913; x=1777394713;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jgVOVvPTrj4x2yPeEdE0VusRagUUHTAZD/Iokvor/7A=;
        b=WYv1CcX6hyE2fMsZmILuMgXjpnZDwkxNMIXG4ryx0vNME9/DupwDbkgoL8diaOse+X
         4PKHnlWg1934JBOPtHVKscxSIx4z00JjdPXNB+Kjvh5AL0X28VPErPJMRrMEVV8dRr+L
         TxHZQTlJJjlTx5XMOpxsHEhk83AuyZujVOdJP6QfEKJOl8g3UDrZ0GxAXv1UuQSxkLgV
         bk3Bg8bDLZ04Bkiy0SCCYidTNfbLDYleUqDbkcHVe/PAxgn77NZATdy3K9Kry5+Iw4G3
         WYx2m4iWgN4fUh+p14cGDXOi8e+L6gWBBJrm53upGjqLIfy/ZXdQdFxPxT6cCn6jXqm8
         YFXQ==
X-Gm-Message-State: AOJu0YztGkAdriMNJ8svntWbidojAtPOnC65KhSAjrL+OZLXGYqsiav6
	TeRBu2K2XOLSSHsHWnNFeilhR5WyV/FYq03EHzgsiYNMHwttfylrt3QiT0wy14+u87Q=
X-Gm-Gg: AeBDiesDoQgiBgwSvhqzkW1sbenfZ5M7Py9inFSNaT+lrZaxC30KOtlXSnVREhmpJcc
	z1FsT9ocF0d7KZK5bzHuXkZE8pxzyDr6pHADGiELZ6N7E1rv2RcWLuFfq1mymLem66NoCrWZRa8
	Is58DdZj7rHLHSGMuDY0YDN4zmaNHm54iqMVfoWggcV+N7eBMJzx8Xtc/Y+3bbPD5X7fZj66Yvu
	7sTISZNRFwClmhWAltqQ52Qq1zra/5VljBBOYTFI+voNMMAy+4Pf5XH3F4ZGhhflYiuPff2dxmZ
	lQdSOFA8PFn2+AMLN13sxvke6XJDs5RXyZ5xrVnZJ/svUD20wVe3fWwXMQjyMtqPU270gJuQ94u
	IBxoiKsq2KMimimxEBky1q+nfnbDwU8VoLOyRIdRxm5jcYPIZIzPoATuMp1ZR5dMPNmk4ktXqHt
	SYkBhGcAwVOqB0iYaqn6TXz0OOe0bzRynsA24SC3ntSw==
X-Received: by 2002:a05:6830:6583:b0:7dc:dd58:50c7 with SMTP id 46e09a7af769-7dcdd585530mr1206651a34.18.1776789912610;
        Tue, 21 Apr 2026 09:45:12 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dcc712b4easm4849766a34.23.2026.04.21.09.45.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 09:45:11 -0700 (PDT)
Message-ID: <b4743129-adb4-4c40-b1f1-69a833ce46ab@linuxfoundation.org>
Date: Tue, 21 Apr 2026 10:45:09 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 00/76] 7.0.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/26 09:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.1 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2026 15:38:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
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
