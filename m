Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D55D1C69A
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 00:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727914651; cv=none; b=fbjxuOkNm5yaF3mMxAUfssS47QMiok3xi58S1/Ryz8LatJMV9RP/Vv5IKLiqArjO+xN3KdfbHK5hLDmiHpuQCB7gpePRguInINsuFXncwlwOJ8eTx8XofiCXAE7BXRYHXkBwcKu8TM3+bu9tb6/rK0xkroK2hS6ESXrjX5R01N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727914651; c=relaxed/simple;
	bh=AeZplv5sIj1kXLIBoCxANzLbS63O5jg6wjEtDTCyqD4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AgbLoXGMCnusJIbb8G2d0IardQwAlXvd1Hw0GT73+i7gFr/niRU1BFJtZA6W/frN8e6AFQ3jv+xNTytGFotSKX+VQJBUJt3+b1eont5E5Gxoo/a7DEGxpjoz1i5TzTCDkm9yBjvSTRFyeIYBHtLwDkr6n/Zw2DfkhMSHdkrqKM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7ELe7o/; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7ELe7o/"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3a363feabc6so5085755ab.1
        for <patches@lists.linux.dev>; Wed, 02 Oct 2024 17:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1727914648; x=1728519448; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ax5xOdilh38TqtVkwQbid1kOmPXA6/vzFRCdYgx7bg4=;
        b=B7ELe7o/2hQqg9a3uQKhYovtwGoaNSmjxkAowV4EI8bf6kDuO+fJ/6jpTieLn/hsBO
         BnJ5ZtW0dgP2CC2Umnnix9JvnRkjLQWtRRJTfMLZt9/pwDx14s0x8GiCZVQ4VxwIsuFc
         mCIxgl2zlJhXyfuNCIFgIxJ95/RnIyXIBb3sw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727914648; x=1728519448;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ax5xOdilh38TqtVkwQbid1kOmPXA6/vzFRCdYgx7bg4=;
        b=O47qdNPMCTEddf1kUOy+v8VWaIN1RUkWO3D4+zv3Vl2QmmDiKUXc0D7TYFTpN43Z4V
         hwHGq0B/YXX7iy9lcsIARBnKr+bFSFdVQ8c2r+ZHyu1Y1BuXwtKVKWQdNQuf4rDqbM5i
         2as2+45HRJb7193bls16PdWp5pNf1Z6yrjxsScgxbnIrp1PYXyojB4RO78+WoFMl2L33
         bdorXy25wbk6FhRLriEeaLrohuHudFeajK4QKE6NGzljuBbj9ObUZRI/Q/XY4ZBAnkJ5
         lkG8/VhfvXxULY98/EAjL997CqFUEjiWxTw5xPLfBVizpP9tf49Xb55WRCBdNyh5zPb/
         jVzQ==
X-Gm-Message-State: AOJu0YxBbyWI+82raQEhi0oZRe6jskSmCTxuKDmSd4xv66uuHlIWFWQn
	pw269kacy+ub5dKXfs4ZLJylhEPlEZd3eZ8Sna6lPdYTHOgm1DY0ojhPygtbSEg=
X-Google-Smtp-Source: AGHT+IFlUB+UhDu8AeilI1lMi1HA6k1HRPe3Oxo9gmhCfAeUkFS86K6LL8sFxhk6yBXLam8yHWP3Iw==
X-Received: by 2002:a05:6e02:b41:b0:3a0:ce5a:1817 with SMTP id e9e14a558f8ab-3a36e1b9fc6mr9998495ab.0.1727914647710;
        Wed, 02 Oct 2024 17:17:27 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db55a63ff4sm45738173.94.2024.10.02.17.17.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2024 17:17:27 -0700 (PDT)
Message-ID: <340abd79-d3ec-4669-86d1-d428fcfe628d@linuxfoundation.org>
Date: Wed, 2 Oct 2024 18:17:26 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 000/695] 6.11.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/2/24 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.2 release.
> There are 695 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Oct 2024 12:56:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
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
