Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456A0155738
	for <patches@lists.linux.dev>; Wed, 15 May 2024 15:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715785495; cv=none; b=UMKYafWlY5dD1v6AowYJpaAYAx2E6BdcsOZ7M20XwrTBEfE+rLEk/8Idgo5Vg3z4quMk+HQF6vegXJCewvJHCM5RSqI822c8Gbzopn8KDm4CiA9hCJWnvXRT7Ce19mIOXLfyw5JljaukBc/WpKW7f44M5DSOMgA6fBTxe2SwMVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715785495; c=relaxed/simple;
	bh=KflAjJacvHjs1RVSIHnQWp2/DStGL16WtVDIhgf6ZbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m+kFtTgWSdEEWwk01XktwXapb8Rcbo2BC7vinFS9hFjjzkpfuyqeUV9lJDcsL2Gf6pdFbp4VDf9EIjXDIHpe09QyjXZtQV7D9528y/kL4n5qZkklsGBS/6D0OEPZbiluL6+kNOzA3hmvq//YVchH36IdqFoCm91TONhxUaiWfgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LERN4Vxc; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LERN4Vxc"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7d9d591e660so23670439f.2
        for <patches@lists.linux.dev>; Wed, 15 May 2024 08:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1715785493; x=1716390293; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ARNv4myOiz34n2955O0D3STgOGbvJhvrIoPTodeqsuE=;
        b=LERN4VxcLo7tHuBQYQpQs/mNSGExKtN7tIc5XZzuqsLJVDu5YVgmAFyzWIM5Z+TnXk
         7b5uKWFhlJqRlYp2i0rPZtbieZiENxAQdkwA52UIgVYyQoyoglCsEM5WSaZuZALM9xyq
         M+I/2exoH9GA6ge6nS+E1s/ITbOZFE+hc0XWE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715785493; x=1716390293;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ARNv4myOiz34n2955O0D3STgOGbvJhvrIoPTodeqsuE=;
        b=RbWOXy8y2em+RT3Kot4FilNfTkq7GPgFnzO12VZCv5d5FOIHiCj7NpPISGRCVexo1i
         l5ocUBQkQrBlmjXAzlvtTQczGLzT5S0ZjN8DWVTfBw8kYYdeYruN4FfI47fdLo6QqDcz
         qczRzn27SFWtU8JJdfEbULmskDwpsogmcenq+4altyANuwDleezenHJr6k5xyKLuagHv
         zhzJcAxTGYPuG3u7NXujhQvJfWJpHsLqwO/xv1ep83CzVf6kpnwX0HUd/zdAmEa5VAt6
         WyULkmJdW6/Yc1x9ka0ksByjsDwhYK0zdlLxUIRGw+DcLkJlE98oISZdkafjP2t3Qu+a
         nnsQ==
X-Gm-Message-State: AOJu0Yz5ByqH5PZlzcUcgXK4JweJcdFbiAyzvGTBYHsZcwVe+Pb3AzK7
	6Zf4mqbItNWBJEWwbZmDYD9HMeJaTzz6opW8n4VZpaZi4XSIQa8GVP4fYYUn7Gc=
X-Google-Smtp-Source: AGHT+IF8hT10bt/12xnGpOweZNoPPER50rWWNs0TSukXJHWHG43ACWEkvi58mLCmBdpT853ZkzCpmA==
X-Received: by 2002:a92:c988:0:b0:36c:c86b:9181 with SMTP id e9e14a558f8ab-36cc86b9470mr143647785ab.0.1715785493475;
        Wed, 15 May 2024 08:04:53 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-489376dc9a6sm3548097173.140.2024.05.15.08.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 08:04:53 -0700 (PDT)
Message-ID: <1eaf604d-097e-4512-b279-6ce2aca79cd1@linuxfoundation.org>
Date: Wed, 15 May 2024 09:04:52 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/63] 4.19.314-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/24 04:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.314 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.314-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
