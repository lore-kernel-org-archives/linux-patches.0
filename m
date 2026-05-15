Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D61A413D80
	for <patches@lists.linux.dev>; Fri, 15 May 2026 20:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778876653; cv=none; b=FtLjlhzxUwMON2HS4y7h9HciVX75toibOo9JFYFhdLV7M4Pt0ECZFG12+PqbnMSBc80LnHgwtA09C4FSSJNGp3bRvkIBgGa/HpYKW8vgubPUxVUp/UyodeeW2Vd5wgkovnVzFg9hWPf97kxSJB9eNS1P+4/LrPHahFJj83qsaaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778876653; c=relaxed/simple;
	bh=2EfSqqEG3Fz2+psCHccxGbWRmL3fAYGdlfh0z5C/l8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C0OLUB23IFhjFeGkAOPBdqUPQoJqTUi8lYbiHblmGuxaEWKmNOn0YNq+YdIuLOSjJ0JNxJTcX+ZEFYyy/Be4IJHR93nYmIpvLOmprbD3yGrWKMhHXn0gAbUXq/tImhxJ+DNP90e+pY8NuwNelaM1XkxUocfTQj/02xL6LEpopuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Os/Ufr80; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Os/Ufr80"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8b3fe2f19a4so2489216d6.2
        for <patches@lists.linux.dev>; Fri, 15 May 2026 13:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778876652; x=1779481452; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5iTrJvmIZEOAFJlzqY6SOA6UlAvDU1qENTjhrg7LHv8=;
        b=Os/Ufr80CZpHoTvFmhbHyrDt+2JfByva734MBHvmQ7yAVPM6CHQtZB4fMBy2nuLTIw
         KK0muPPnsNy111m8SeazzDl0pvBFhGuYGMLCfpWcA++8Eb6QEl0xP7hvQgtk/hP5qQ/B
         iKdeVgQc/bOuEOjSLi1jtU2s1oInRZ8DEasPbIAdF/2bkFM9M/LbpVJDVhm1wOUAYEVm
         xOnFeYDLIuvUOoYePSCj0fHXlf9rbmhblmki74jQIdi/qDUacwCw8TSW/T5gTzLB9uSy
         6FiW0JyyjctHBrQCSXySl1SV7Kam5+XPfGkVRBA+RpJV1uuYtgOm7BiqytjdPMVifVRn
         LL8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778876652; x=1779481452;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5iTrJvmIZEOAFJlzqY6SOA6UlAvDU1qENTjhrg7LHv8=;
        b=f9ISHlz2bad+MUGsVrdDkNzpMioe69kYbQ6dvljTDL+50DUeSyN/j7TJVxyNJxwGwO
         CQqlu8tCPR5KI4HSNH5mUcX36Dvx5KVRXFfxbhghauTuwDDtlNR4K5VTZ069k2y7cfBF
         ULGOecoHm8cTQ0dqwmZBbI6Xw2X6gYK1F9mDhxbR9p4pWaf/xF7ce5k1GmmUtFT6p65W
         tHNqSv9nqcsckBQBbyZ10l717xSSYDVUtTYy0SDY2VGcB08RfGwscstzc6owddbFAos1
         vbUY9gx4sbFg/SKqlUWOOsGvVMrm/qKH8icNkmlOdXiULPivaBLhgEkkBgVZsn6VQYuO
         SuKQ==
X-Gm-Message-State: AOJu0YwER2TjFxLjMW2/ebkB19jVR+DM7ZAsFRk9n0HsADYWmLJQxaJ0
	1GVd3Nsp6bfaHWBgyRreUpeFxxecGRtNLuyr+29gqb1+6PxPht4OOPSzdW9kEg==
X-Gm-Gg: Acq92OFW5mUsDe6rkJUdLpu8NQcIdbAHlTCB/oeVPC3qwQ83DGnQskHmxjpKc0fY3sX
	4DMyD1YXnLxewVfdk1Bb/pWsCmV0YZrw5hTQaUMAgAYEBxoeVC6FlnUEel1ohXwQd1WJaEV2sw/
	l0gsTTma0nzG5R09M8Po+oeWnqASI9tqnrLu6PKBviC0mbUU15JwonCZXs1CTgLLob3TwrIQA11
	ptcrillJgLbtt43fnPfWkpjjwYfbIKD5snBKtmhAOf1wfWnoTfI4Qu705gllTa+loSotKVDnhn+
	/7l+Q+dqC6kVDTtj/JE6MC/Ck1e6pfA/LJlBK+FQHYxZ3f38pC/WiXS/NFwyIXhLOqoroiSDwgM
	tToXfTXOLy4snZyKZCg2sR8IlxeaAKdHPfDXMX9E/qn9FgVETD//bEiR9KuQwtBJmSXE9/iWQ47
	G2nkWGxu6IqmaS7IP1fjKZOFVog74f1kz7Z20S3fM9Uq6gbIsZAWR+drpRp44J
X-Received: by 2002:a05:6214:4521:b0:8b0:3904:596e with SMTP id 6a1803df08f44-8ca0f69e77fmr95208156d6.25.1778876651591;
        Fri, 15 May 2026 13:24:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90b3d0bdbsm60408486d6.24.2026.05.15.13.24.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 13:24:10 -0700 (PDT)
Message-ID: <45bce069-654c-4970-ad54-f07e6f649846@gmail.com>
Date: Fri, 15 May 2026 13:24:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/188] 6.18.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260515154657.309489048@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/26 08:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.32 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
