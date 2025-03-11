Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C7A217719
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 19:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741722087; cv=none; b=WEJzbzSjQo1F+VMA4FAr7ItjK2Zd3PmwWew7m+ZE4bvF4QhAvzu7JksSszKzb9MmZvGXTvK9yMDeMstniS31iHzuT8PCRd2eMZ1S5NT6mywIogZnum8gUrT6IxsYVTzA2cXfxTwTaz+nxSQNnfoddaGOMNZNJfQ/5CJ8cKi/nP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741722087; c=relaxed/simple;
	bh=er+9jjdFTitNlebJQVzJd8lxcEmN5HEy0TqS1l7wvJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kJScIzY7DAsS1GccgF7mZjOX6fy3RIz+BFZ8+YkxMObCB4GqlwBpIH6KyLpJ44xsDusSPKXqmEYM/i9vQB0tP3TqhZKswz87C2BlbLZTv73c+5bRkCgZX6lI1KeIazKBghWCCwYNK0X0iaR1XKdFy7Zcj+tJ03sO6PAkDuGuqu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBiX1SB+; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBiX1SB+"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-854a682d2b6so370257639f.0
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 12:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1741722085; x=1742326885; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ry9akgKcOnrDWDxgZkeI6/C0nkDIdOIWsdgWlSMcY+I=;
        b=XBiX1SB+YgpwU9Wef6uRG38FSPcrE7WG+qGOs9Ywu/5YE9eNCTXoKmKK3FsHsbMBwN
         AxU4lRnkmPw/RtOABUN02jInSSRNaG0TXdNEgP8fmJhehpvkbaF29SI0j9slW473Fj5z
         RR3KbakXGyUdm+u8CsCTgNoIp6LQPZwtD+Nuo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741722085; x=1742326885;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ry9akgKcOnrDWDxgZkeI6/C0nkDIdOIWsdgWlSMcY+I=;
        b=hBZap9bkTnZtpyGw0wOQkB1vI0rPoO6xmF0B9CTx099dyQbBMvJwEQXYMTz2vyClOv
         m/+odbRV+hEYvITrUBBCfSMKBriU6j+2BQewCEVOWQHTWLgLUYIM8RSU888kQRJgWVlS
         J6Co2IPC8sJL1/LMs4RimZega6CrPejThsV6fGqAoyUX1L5xgq8qqutfvusA9sfCmP+B
         rKV7c+U2jJvEUG9q5GYVBZ0cKQXBsVb3zeXltGeIp0zrWi720WyHVGvRTj86qqt47A36
         cbWGQLTj4cNvWO/VAG99J12bwlj4Q1TU2ttBXe+BDyfwUGU6tFzQTy6f4RdInLpG1lRY
         OPHw==
X-Gm-Message-State: AOJu0YxjaWzKRhsuqhwlLcorYXzckwsfn7cDhO5jNGrQKHsGPiUGYtjJ
	XWcanqzbG0+7zmjzzz1Ok8N1I4GcsSa3TvB2x2JRjw6lGl9ftjBgkY3nwb3gBEY=
X-Gm-Gg: ASbGnctQw4k0UrLOFo7q9C9KT90dXgo/+GCbnLtDgeaxIY5F65UamKq17TdgScljUlV
	BTHaOqk0ynLMrTUYWIxH5ij9TbqMcOV8LOw+i6+qgGcL10xFEyTP81fMZJLL+dhiU2IA4UBaShy
	h1kyUmL4REHS0BMYyluiVeN9JhSPdlfZoWO5CRv2VZGc8DaFpB75H0nAGiXfztmpF/cV/N/Jez9
	vZAq6EicvorjR50waacHGJrKGw0laM8jv2JIP9hzbiS5/vyVac8m27IL3RaC4CqvSxZaibkOrKB
	Zkyjk7lgnFY/ALhmayE2Nj6O2O5kpfTILhPcXKQzdld1euUnJ3KpG2g=
X-Google-Smtp-Source: AGHT+IE0dvgigbncy4JGuinRK+9BYgcnzpI1ilanDSCUJgDoIPF/Qbfo09x1YmeA3PCfK6PhoMafpA==
X-Received: by 2002:a05:6e02:1706:b0:3d3:fdcc:8fb0 with SMTP id e9e14a558f8ab-3d44196231bmr217352935ab.20.1741722084502;
        Tue, 11 Mar 2025 12:41:24 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d45dc58885sm10179065ab.46.2025.03.11.12.41.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 12:41:23 -0700 (PDT)
Message-ID: <3d2699c0-895b-4c78-8ee8-ed062c2eb9d1@linuxfoundation.org>
Date: Tue, 11 Mar 2025 13:41:23 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/109] 6.1.131-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/25 11:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.131 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.131-rc1.gz
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
