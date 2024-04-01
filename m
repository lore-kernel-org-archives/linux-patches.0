Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771462E822
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 23:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712014617; cv=none; b=qlcyfatmy0nDU9IEHIbANzmwbyZGO7EzWN/L2mNI4p04HK/nwzXkpUo/YVkbmJkZabKpIkB8+cyeMLwxWGXoQj+tXLGBRsR/JigN+2P7V7ZI13ZTmBtrJOR/s/tGCSCZcE0SV6VaOzZ1NnGUbLCRegIgsex7W5GYc7tDew50hCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712014617; c=relaxed/simple;
	bh=CqfeARlug8+zcjr8pia+tcq62XchzGu/UcL4fzI7plM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SGTxG/aykEtNZc1NnIHOpIVypKz0+0upGd5J2QE9tN4LFKXxa8Puv0uXhLwM6iNVgwHtXc4qJlobXfoRnBVUHIvysLDeoA4F1y80IXxvgakP801gjSXUVV8jjWUUVctu6acLYKWHSGbsZbHxfkJx+/wmxK708yk/HyQ5PkANc+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hztT9iy4; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hztT9iy4"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7d0ab7842b4so33495439f.0
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 16:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712014614; x=1712619414; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RwQzHTQg7aKASMwhwisC553WH/Sq/sNTw6BLGLLQEgs=;
        b=hztT9iy46otYADqll9/iekKGqwhasJJA97CAmsstk6T9lWXmE8d9PBHz0qf+/vyfZF
         NqLT5OZX984rDitx5PHxTpsfgB72ecAiQ19ZVBon/UQQLVUXEMbYthf6+ZViQ8p79CKj
         zQSvIn0052nE7q18S9Jv/jY6hX26J7VMCtDqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712014614; x=1712619414;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RwQzHTQg7aKASMwhwisC553WH/Sq/sNTw6BLGLLQEgs=;
        b=a5xKyyF1LMBxxzWctdr3E5Sn8Q80MF8L6AZYPuRKiz5lYeB18WpCn5/vtz7NbP2MzK
         RGbeDKarUoa8D7z66iOft8P0qHYtj3lYtRlvZgFNbssrnOqBgE3DQPLP4MRV2/NWdwYK
         FTsQE/sICxtp72G5RohwlngldsLKkl8Bv+HdNDSMyOWVgJdU0SOSgHDNmMz/LkDqzhf7
         bpPjHOAV7urI0B/q8t+Bcq9rlbsh0Um1on7dFy/l0vZgbrUVy1sJLqWpJcL9UdM9EP5K
         ptcsZH/1abgEzi3ZYIj+TtiEi72idUesRgKhLvk2AgHE8GsP7tZwvyUjYylbz/1GChTX
         fhjA==
X-Gm-Message-State: AOJu0Yyet4YgV7LJ6UTNufnedcJfmfK7D+UYzDK8AV7tEpkRk2RyVqfb
	UNWX+L0HB7q13e2lygNpFqXBoBO6rpQgnpIsquGFiBJIIvLGoMM+x5hmg/sK8EM=
X-Google-Smtp-Source: AGHT+IF9VDrAkw8zM+JlSY1VR4/oU7l/OgNtFNLNupYNJ/J4MEr7YxZTlgnNdnDmkWerLIX7U/KH+g==
X-Received: by 2002:a92:cc46:0:b0:368:9b64:fa7a with SMTP id t6-20020a92cc46000000b003689b64fa7amr9893308ilq.0.1712014614629;
        Mon, 01 Apr 2024 16:36:54 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id v2-20020a92c6c2000000b00366a9dc823dsm2959187ilm.55.2024.04.01.16.36.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 16:36:54 -0700 (PDT)
Message-ID: <92c40e6d-3db6-4cbb-838b-f4c875e747ea@linuxfoundation.org>
Date: Mon, 1 Apr 2024 17:36:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 000/432] 6.7.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/24 09:39, Greg Kroah-Hartman wrote:
> Note, this will be the LAST 6.7.y kernel release.  After this one it
> will be end-of-life.  Please move to 6.8.y now.
> 
> ------------------------------------------
> 
> This is the start of the stable review cycle for the 6.7.12 release.
> There are 432 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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
