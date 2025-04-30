Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E9F17C208
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746028636; cv=none; b=vD183WYyND3CydpJFYXNVqQeZkBO1AgfZJ5i2mU+ZpTIkJrfRdM4AbE7sgtY2/zYB65Xdh+JnpPeRGnXLb+lQk/B5ZB0UCuTy6qCtCytKCqMN2riLCw5GsnMmnQQHzu3DzNWBRS7CVoWJ8lewXhRU1pku32PEg+2CSxYotTr3x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746028636; c=relaxed/simple;
	bh=YP0fZeLAlpTBiDWH5wF8m33b8xj8zwDegQm0YdkxX+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tm2/yeI2gB1RM1JIKEvonHa5lKKG3NoWonKmSmhLwGV/0I8BhsmXd45LU2HcVlpgI6imkZSQEKqSjs9krG+yhLcB5moVG7goqv7L+V1MXyJ74lCQOgeZFoyT+rCM3Z6ZO/FOMl/BcHToD7XKoJw4HSGiDlVh02Fe49vqHL1hz6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3qTa50E; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3qTa50E"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-85d9a87660fso710691439f.1
        for <patches@lists.linux.dev>; Wed, 30 Apr 2025 08:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1746028633; x=1746633433; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vbg0k1gnF7nXpY2T7u81fy1ukn3uxWlDYnypZdEAQtg=;
        b=M3qTa50EuLqgFyeehbPPJ0TrAjlaqRVGzNW1THy2++rr2ZFzpoxhpaiFsVDbW8jhAH
         vZzc+k2CS7v6Tv8hp7Ktha9odhM9LMnv4OzEcwvXdPCfHivi+9KS6NEUQmHGbQPTkZox
         CgJ9SvX0AsDzGk20RhY4nLDNrIgPeszV1TNaA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746028633; x=1746633433;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vbg0k1gnF7nXpY2T7u81fy1ukn3uxWlDYnypZdEAQtg=;
        b=GhhdGINETW0CbtG+nUldIxuE5yofTxjoxz6prcpwbFIvXXcDBzLZgwHwQu2hWhYwkG
         PVdvU7dh+E1bM2/sxSRQWsuufXMC7mvJXYJRZrWNI5/MyIevSNcRsMiJA+cqVhggTINu
         G1NNkSaexcWJmDN1I/J+7gzD3yIPdzK7y2TQv66dELRaCfhIp6LEGWdk+ijrPeyMWv9b
         ssUn5fIax9XCMC+Vjcf5FCSb3lVNoQX1xgKMA1pMMKK67zcrU90us0rwfbvKroCnnBuc
         qYBMLXm5ASNjigc2/pn7KF2Obz+4oxJaOJogIhN8WVg7MEBljyg59wZULr0CV43bAzL6
         9E2A==
X-Gm-Message-State: AOJu0Yxunvx292jXI3OK++ksjJDeN5VExU8XqiOHdUCT8IbQ33o/UPeh
	YP7zvsYSvwwF2JumtPhzBMiTUqgZCkExCXkuVWRId/se6cxawntby6xey/WcZl4=
X-Gm-Gg: ASbGncs54/4Nh1WZhCLpOSn8yL7PeCfDFQt5YZIW8mLWFiJrddJsAauKdICqeA/pL8g
	eP+2s9U0Xf+qhYmHoNU+TJgTI3+DuMiDiUH2/g8PG+emYoUoqVtGEaDdMTQfURQZyJPELeIFZvb
	h7uNwXBdpNWMxEW8TJWuFForBgLMbDx5QhRGvIZ439V24WrBt50nGOVErVALDeTh8Bu74cVjwif
	NS7CfIdKQQyHG4h2VtpMAYKVFdbsxpgC1rCBv3SRf/QV/VIZRoLcIy316pYtFg3DyyEIDKrpYel
	iiYdwNFead25DqJN+2EE63Il9djLRJPWzQx1TvqRqZgZ/wp/4cg=
X-Google-Smtp-Source: AGHT+IFh3WGBACndewk4cZtkcC6191QkBbQBb9kKJQqhhi0DpqegJ/d+by7PNLwd/DZjTq7NFYBTiw==
X-Received: by 2002:a05:6602:4749:b0:861:c4cf:cae8 with SMTP id ca18e2360f4ac-86497f4455emr317771939f.2.1746028632896;
        Wed, 30 Apr 2025 08:57:12 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f863149b3dsm795000173.107.2025.04.30.08.57.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 08:57:12 -0700 (PDT)
Message-ID: <e08635f3-bfca-462b-90e3-4c3d23e0640e@linuxfoundation.org>
Date: Wed, 30 Apr 2025 09:57:11 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/280] 6.12.26-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/29/25 10:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.26 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.26-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
