Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF3E3F076F
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 17:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776188553; cv=none; b=p/uSDu846gTHMFuwlxMplDbwkG73E7N2YK3cNNDrVLVAzLVbktwAEkrVs1PJtcRwhHKNM1YzsECRXzhCdJVVclP8JR7FpmX1dz9CAVDh7QHyRq04cQG4JKwHIGmfvA5bUUy8StvInJH5zp0wkGskXK+veTp13TbBnnJ6x2GGy9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776188553; c=relaxed/simple;
	bh=Ois9b2YQKSdls9G3OnkB8Ik6CQNYIVLdA2Q5RNP8bwI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tj5G1oIlIAtl/rRoKngKCEhxpqvpVDHIDbBMPsn8xCC6QOe9MKe/ZGkRpaSNsz5IHcDsS5O/gm7BAzvYYfrRBWlcIAdHpM7UTgeISbgOhGGaAAwnfp2+WweUKPqoGyNAvVs3e3ZztgjalE7kgbK8z2u5L3oLVSDQo4Mb8RU0nZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOQJXXs0; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOQJXXs0"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d7f92bde91so3638641a34.1
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 10:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1776188551; x=1776793351; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/N6CFMaTFFsa0f3fHbBuhGxq2igKNglB0pB3FZXpIs8=;
        b=gOQJXXs0FNylVQpUeqmkfDPpCNyYCMCFv/vKsZdyVa2NPc1iLx9zlylDGCIXDoL6Pj
         MCalz35kvlSjARDBS/8guJPzenOAT2WDRyaL3qqHym0biMZdQ89vmey41go0mgQDR4fl
         f0CIce9aKVQS3OsRTQFq7v4OLghCnaf6uNm6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776188551; x=1776793351;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/N6CFMaTFFsa0f3fHbBuhGxq2igKNglB0pB3FZXpIs8=;
        b=lqShZFa3lgWXXyS0Otlm78lP3MSzjcobq9iaFW7cB7t59o102TMZYZFE88NLRTAdOG
         yWnjOyhXhM/Xe3ITS71ubxskRUHRX7tf7mM8lNgFUf7WA20vP6TcSBWbwz76lIwxkdRi
         bnW/d9bVTeSBT7dSBOuN5jJtam/2VqkcWbeDLB3wNtA/HdRTa8z8YbV8FSjv4EvozeZl
         IS3edurMNwbBpeu7L2VWZoebdDDEQcmNHYpJS6Tsqa7GqSNrsKFRCPIqBtpYxQ2obKSU
         GOJl7ksraYv9hx0hMBXJElekY27kTz0dVWxiXhH4ittraQETDw5ArGlIWjgLVPqNLiHA
         XRgQ==
X-Gm-Message-State: AOJu0YyCYC1WSEiAm6d7hsihL0kgl3DFIs7/Yo5oppxtmd3CnOBw5rG4
	con0GsxEX2K7AHP0Dq19w5qHLw1gRhJNsi8WUjqwLFhJzHHD59KXh+a5oS13GSUUg2A=
X-Gm-Gg: AeBDieulEup59uwkwfFPn+wK1kBN2JjmDVB923E62T6Tc49w54ZxINdEXaCmTL+ghuQ
	DQv6Vsyfoc3zWStSv+2Fy8T3J+Nx6FosqXTdPA9qMS1pqmB3ibzboZ4ZyBnvgS9cuehmUz/ugMn
	xuODKnQ3gosO7kOF6MjpbKSj16SFTKQjRUj+8YGxqShNL8uFih5G6OyXx0qQhUvTmWr6awBiSQt
	+MpT7zu8vwsk+Eb4vX8Q/mq3Pbbha57TXZ70bTFcrJpEc8SC0yJX5Y68JkutpvSyrepXsYvVdF8
	lA28s9lk14/USmmiKZGg4fNyIhzHyK6h8fyjMPQSUhdYe5ae578Uz6gUe1WqFHBQHhaTQlpB+OV
	utdYa9onwzBSaduj18kraJfk0jUiXnA4hmE56OPxOX1S0cAbCRRn9VMBc1/FomSqVEVBqaLYsZk
	CMbbstZ1HN7SObPJ0rVq4pWThLtQdO5uA=
X-Received: by 2002:a05:6830:829a:b0:7d7:dc92:f73d with SMTP id 46e09a7af769-7dc27cd6fe4mr13403744a34.9.1776188550879;
        Tue, 14 Apr 2026 10:42:30 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc26573350sm11449418a34.2.2026.04.14.10.42.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 10:42:30 -0700 (PDT)
Message-ID: <6c721566-f20d-4606-93b8-944674d471db@linuxfoundation.org>
Date: Tue, 14 Apr 2026 11:42:29 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/83] 6.18.23-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 09:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.23 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.23-rc1.gz
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
