Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E1033B6D4
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 19:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768591282; cv=none; b=phg+RsS6FWkKHSeoR/jWY1o4Tv1avTzp/0WFKjIdHzAWjNK5pGO9fUugFqaTwfZR2UsaDf+j3pKejI0XF8iKKs9FQ//JGZNfm0Te3GHEqE9oGynSpX/aCvsLv3d5nWFRfk69wUjxwIahvyi3fwi9fFGw2b6naLnwwJ1jWGWiWiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768591282; c=relaxed/simple;
	bh=mLblJY/WfcxVHQPwGPf+iIsaiqpV8ySLUYA74U3WKGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NUOljeX1F0hP565x1rH5Hw78UkC4iVGR5sC6Qb/Bs6+0e5qCWqHlRxcG7v11svP3IAR6wHQCeKmiEgu0vwB1Nobpme/YLQbwnT2Xk2zGeWHtdAEcBiPt9uCzoihyCvdiQ/04GPrxmYLMg7eE0WpOCB1qd4CiybMOfbzmQtSQcf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OlhhJS+i; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OlhhJS+i"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8c5386f1c9fso380440085a.1
        for <patches@lists.linux.dev>; Fri, 16 Jan 2026 11:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768591280; x=1769196080; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T6rxTSuFAQ+LCY7I/oFIqogqmmEKdbPz8hlQA5YRb58=;
        b=OlhhJS+iUkBgQAv7mVhg23u+l3M2XPOKn2wzLh84EOMoxaPjN9KTCovq30sqYPohVx
         8b9aMW11yW1bnRzgLLPrqzRF6dgdoEcCLRQf+bWw+idVZfD7fGz3YeRpiq1zCnWlTb3b
         dwPNJDFz7egPV2FiofC6Zk2kQ4wnZBeKLjo9byumd3wj27RH8WG2kLqYRQQ713ztdR8p
         8PumJstsyolhP22ahJt4PfWq/PZeXuwDQXGXGN8aXv1RjE4k6EKp3PEUrjwmo11fV6OK
         9nElYY4sxaiwkge8oAnHGU6GnDW0h7nNABOiXDSaBbbsek5w8Xf25pj3id42bro8HPU7
         Ae4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768591280; x=1769196080;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T6rxTSuFAQ+LCY7I/oFIqogqmmEKdbPz8hlQA5YRb58=;
        b=SWqOymBhDEqBy5I+JN72sNlATanPW+fn1LZ0F0R3XEd6jYgRKmRz5ptoCfk0lI2Mdy
         aokenmtt1+NoRwpBrXWqNKl5Ekm/eaLohUxOq2D+AIOmfodHjVWSWeGHJPlW4c0T3iuY
         yUVen5R0SW4KDKbfsgul0E6VZfSak3pKPl1iD5fjiFg0Zw0Xnz3FCT1f4YcX/J9Whl5R
         Sej7Iz/oyThgJN8rBRmfBotDYbfIgxT6KfEkzNEeVJ7goFZzMzAlcFWAtAiLAiQ+7lvp
         oLLaJs6acmbVB2hQ7510LMWJJ84cBdnjNjY+M5R3nAM0tD1ym3v/j4qe6RSZKkbXN61a
         oIcA==
X-Gm-Message-State: AOJu0YwnT56HWmDLEdsiEbVVeokAcFkdJDd+S3C5KrsY1/SRRGGXMDLU
	LcxmW5em821nNUyBimrv/4vUAHJZVdkLe22eGvK2OpsnDfIpA2DkFwfM
X-Gm-Gg: AY/fxX5t1Hf9Yd2VWq0APmKC32hrvg17DRKoACCr3zUEIgxdzSyQ51IfBTyR9/gbKBn
	aUobTF9QkG7qNNH9A8kIirCvwUdu7/+qXNePeBBrEprxDDPyB+oypKEOROTI0aYoJIem0Y+PUDg
	imIGsssQntNwhwqIymgV1VJCDBmLS7yORoSG3K53BojTlZrOn53XUpVZi9zf32tpvnsV8jp18Nq
	uJAnEFHyAkAJaC3GiC3pDtC/Hle5i53dnWXBhERx4G7cPMgRqXhHqI7BzAbQimZYDvFE6Ev3YXQ
	m8/7hwsjJ4CU8Yz8ABkKN019pZY5icPjkGTGZajmvOYrp5PVTGUV5OVstqz2IBFAQnrqX7FfGMH
	QMxFmezHuF+I0ZZLeHKaXGwx9zGlc2Q4b+SgbApJNryzqKMtkp2rn9lHuYE7GP7UcVL3wFVWKyP
	HScFVhzgx3Rrt++440WvOQSh+OhB9RT/NPaaaUuQ==
X-Received: by 2002:a05:620a:2913:b0:8c0:cd96:9bd9 with SMTP id af79cd13be357-8c6a6979feamr541813885a.90.1768591280240;
        Fri, 16 Jan 2026 11:21:20 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e6c9a9dsm31150616d6.43.2026.01.16.11.21.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 11:21:16 -0800 (PST)
Message-ID: <83adb8d8-7b42-4e28-a447-49b99544d85e@gmail.com>
Date: Fri, 16 Jan 2026 11:21:12 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/551] 5.15.198-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260116111040.672107150@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260116111040.672107150@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/26 03:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.198 release.
> There are 551 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jan 2026 11:09:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.198-rc2.gz
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
