Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6001A304A
	for <patches@lists.linux.dev>; Tue, 13 May 2025 17:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157506; cv=none; b=rBE+rHUSbxWZzfi+DspaWt9Rm7esxw5xKwUZ5x5pOBibVovsuB9II6nB9IJeQvf3wiLmXtN9qTUnwqWL+6NcifpaAPb0UDk3qV8i2O+37wxAMnH2PiFkAswyIJGjLzLEY1o380XID2nnmXXfDcZYmA5V/tfqDiWx79EsWpd6pyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157506; c=relaxed/simple;
	bh=SxZIwTrJ62NdlaBYSELFNzFfvVHXOji3aJBLXzgDJCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YcCpQnTCJhQTsyjVc1I1KGRAssWxPfhWBf0U3a5zkmTspVDfn7g2Vc6G+8TsRK26iUF4HvPrqfUT41BJb2zV7GQeP4NLgufLnOhQoJ+EPopRDIKpH48AytuWlRFVK0+ubLQoS4lR891syfzenvVFhifEtn+hd6WNV+gx+LAtHuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKhI26A3; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKhI26A3"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-864a22fcdf2so3897539f.0
        for <patches@lists.linux.dev>; Tue, 13 May 2025 10:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1747157503; x=1747762303; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nG0XYUWg69EbLL/G8YlTfCVljzU0GFu4+p99ldKTo0Q=;
        b=aKhI26A3380GmXU/VAPzNDO8roh6Esf+steWYWbm98gHevo212Zvkfz61JgTOATIx8
         40zzNrltncPVko7ytZFq6jopHsk7fPmKmo1cO/lDfPtp20Ope/4mn7iyBnooTfYkv9id
         nxEfrBQ1xlZtWYoKrmqs0xf4TzO5SPfD2J4K0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747157503; x=1747762303;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nG0XYUWg69EbLL/G8YlTfCVljzU0GFu4+p99ldKTo0Q=;
        b=Q82+m/hVhTcxX1xhUwumKctz6jo0TzhOcqDq6k2hA6ywMHd1LUv3hH2nL2a0e0U06N
         kDZg6S56XsCaBNyAi20aNF89MuJG6c0bhe6KTgksHf1fdfT2iAaebUs2BLtcPvVKXjyo
         r+5gEDwDgKpeqyVIjn1Ikuui5CaAyWTeQuQ6ta59VG7bwRJCKcGILbzqOQq6iYS3EkoI
         tjyO/Ge7gwhHVb6Mq+qSVu5m5ww9FGl96NtEApOZp2JDajhcxxkvx2ZQUYNyi9mJChMW
         AuWUJFNQfRwrTsXSWGGSSX5nG97LticbZlmMxt3o/09N0i3Bm2hL4395XpeUi8s5hk5h
         Gvsg==
X-Gm-Message-State: AOJu0YxQ93RAi4I3sKkxvzn9JFRaj2ysRyN7IZQvKLb3jrDLqV7A+awe
	5YeFwX9Zz5S8nZNjak1biACxX//0q2BqUOsbHtV94FvTo5Uknz3xcVBtdmQK0bw=
X-Gm-Gg: ASbGncuHSYtgcBus3g+xs7bEsdMOi1NP6B0v5RQ9nmXf5gmCkl35/V866cMSTDuupje
	fXmUzJWVBg7+JMn2kWmr3q/OpLxQgTGmZ8OE1AxgzMocAgTAb+6W6vDnDAJ/1cXfH5RP+RHs0sm
	hTRcWn2pGLZZghd3pkqehyW4HxmskV45F7AxnT0aSy8K0KtABJ7wBk7fNl9d9R9EqzovkY6QuG/
	vU521dky7Fa46cKN4WcHL5nxg6nS06KtguhkDhub4JHSgfds7rDOOwU4QDSVpHtd5iU2kqlfQkg
	cHfgI8WeV7WPMFQuDhM1z+HvOaII/EprWbyM8Y5wkM2Ht+5PAzVJ8oeQLSvARQ==
X-Google-Smtp-Source: AGHT+IECJgvCVtWlq+g4QK490gTQzFPaDnyF62/GyTgHPBrHCrk7yeYlgj1ujylYOHqhp+zRxL5rvg==
X-Received: by 2002:a05:6602:3b86:b0:86a:441:25ca with SMTP id ca18e2360f4ac-86a04412a9bmr205433539f.6.1747157502707;
        Tue, 13 May 2025 10:31:42 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa22685251sm2212186173.138.2025.05.13.10.31.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 10:31:42 -0700 (PDT)
Message-ID: <ef7e1312-83b5-4635-bb8b-edbed0dc20b3@linuxfoundation.org>
Date: Tue, 13 May 2025 11:31:41 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/25 11:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.91-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
