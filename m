Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267B548167D
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 16:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281230; cv=none; b=nw9M3hvJVZjToEDSNNsfLeUHQV0fRRPEi0HUOG8BMwyMj+5PoCi+MmGiVi3Qc6XWCT7Iq50hAU3UQTd2AJdNAnWRYeMsgbJwnaWGxgJJIBvz4qangx3KB6kc45L9nV3i66iFRMWIAPiBIWGCUNLwYibFJ7SMkvgKn3bsZtMXiZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281230; c=relaxed/simple;
	bh=bPsnUJ6dQf379tAgPrkAWtTN/5CZ/7hAUIkD66QNzTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m3lGscC70Aa+eqxE3CmlfTnJ+Rz9ilpv7SSJvzpBFcFewq+gSLg2dJY07WGJpud0BwIYLtRIMn6/lNTmH81xIeRicJRFxjSy2wPQTAB4BEofSfpDgIyIgKEF1lHgySwmoLd1PvBe9/l1Q4kYWaHzmzTa/u354uVZGd9UavudlRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Un0Z8BTR; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Un0Z8BTR"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7f64ea07036so3205757a34.0
        for <patches@lists.linux.dev>; Tue, 01 Sep 2026 09:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1788281227; x=1788886027; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0UuquAVnKS8MT/Txp2C9I3pztBXGTrckd91hiHPlo0c=;
        b=Un0Z8BTRP7yndkgNA9uCjKUqew1QakvGeXzpbN5eWstnLr5OFxSm0pq2ZDQWkOlBiN
         vt3Q4HEAT+7P4Kd7M80DeZ+/hkAqEPfIrcnVNztOPhOb/ca4tYYG5tMIEs2GNfLZasek
         fVpAeqV770pRgDHMVIINQUZnacVPlwtuGhugY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281227; x=1788886027;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0UuquAVnKS8MT/Txp2C9I3pztBXGTrckd91hiHPlo0c=;
        b=SwlCs2fR0Bt4ZmPn3H9sIgO6bJK+FgWIt7pwivj2SD9NNn1FOYfc0DDjsCN5YIHZ9s
         dJU7o5YAN+2AOPd1HpTFjoXmeY/7507WyCWRPn0Bh2d+fcRY6vrlUm3DmhT8Z7DShacp
         TLKYi0OAMg5HADr7jwst4y6vMrhReLHaUF1mdC4Hlr9qh66cDfgHBPnv7dTjPa6cf2ZS
         2GsDs1dlWF2+mwCsmqJ8x/cTaqdtsC47dKCTM7yul3CJPfo6/2iM3V5q/Zt/TZFD2PJ/
         rVxRPss2rTuAd1IpoT3g1xCQFgL2sju3+dvxNqgmZbQz8zEa5AuuGDwPt02kbPzh+6q+
         MlpQ==
X-Gm-Message-State: AFuF++n/K6NU4XgjnaDMAlD1MZ3d1KWMm/poerSmtlcEpx8aH3OQBuR7
	WXI70sOnzgJRxWCzxq//t9x6Y7UiSVrZwT1JRWLU5FVdTAosQrnU29I1sPWwwoFF188=
X-Gm-Gg: AYBFou2NnnwrW4P3YOHXRbfHBGJXKMPcdzkQxT9mK33zG9WnHDgkVXtwGecak5CwaNN
	elNDKhANwEKlMsQij8KnOcuVQWOePjMIlMgudlkN8W9Oyx45crgExxTIqhK8bPGCRv4iisNMOYs
	qfuIkNF88Aa/3OMRfgChZQ8aBKBvk4SWPSzmfv8F5wwR8M4ZlwUYK/AFNqfeYqdRFNsItLHFWAR
	CfOIas/o8UZVYvL49qPuE+qSGT2af4iOSmJof+Vx3KJJqclu1vyay36UY8DLaMMxff0uSgt4o7a
	RAjKpNLckB2We4XLuL9dtxRJ2r0575nSAZla+4EqsB5ApR/7maJcbcfj4aXVlHdJhBAmeAOes4I
	E4zEdgPSlhskJvSIt9zZj+CI0uL5thSz7tPqL8oxi9D93ITSxei0ANfKkH57M7xHuGH4xuoLpgN
	yaST6Bcip0f229EmKMihdefTdvA7SWLHNHGZbzabtsQPOxdBWlmz97OLTqNVhTwPM+rVuC
X-Received: by 2002:a05:6830:4491:b0:7f4:eb7e:c8f7 with SMTP id 46e09a7af769-7f4f2365bb9mr33007715a34.5.1788281226907;
        Tue, 01 Sep 2026 09:47:06 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f4fa96ce0dsm11170515a34.13.2026.09.01.09.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 09:47:06 -0700 (PDT)
Message-ID: <a804f5af-6716-4f2d-a87c-ccdd4116c4ca@linuxfoundation.org>
Date: Tue, 1 Sep 2026 10:46:59 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/92] 6.1.187-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 07:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.187 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.187-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
