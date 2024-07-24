Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FFBD29E
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 15:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721834423; cv=none; b=unVurqqnCA2tF/95qHLUNir+FAWTEcwtij7Zx+fZn9nbaXslS/EId0DTdQPhNbOVjqNGdG+QM6nWZO05XyJOtMmbD27PL+kM61e8IyAxWIxFrv/g1a9CrUGW9nWaDqvvy904WT1g9zbcjmEMNest/JMJIy+KcJLWoxX50m7wOP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721834423; c=relaxed/simple;
	bh=hOiV8755ngc0sIs6g41+2/lS4DWadZVscPT7P0F62i0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FAXptDeOlTkcSP3de9Y+mJE5+GvyOySeKQj4zZrYasavAskfe/z7aMAH5vpsmOVkk44pVpG8P+2r9Tfg+D6FLBJ6Lng+KMVH0FcGXYuGtsJoPvx41U83Qv6c1j12pXcUhlDHKj+k3+0BQHQ/q+riAmGOiEyGMlROXpHRwdITY4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2iLdOAL; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2iLdOAL"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-805f8db779cso38739239f.2
        for <patches@lists.linux.dev>; Wed, 24 Jul 2024 08:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1721834420; x=1722439220; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=82dy9mZKo2zcgFYmuz7GnMY2lJ2OItmiPUYNnGgMWCU=;
        b=N2iLdOALyeild4RLAuEh1kFdSeTD7hiPgp/Y1kH2sLgAIH0UcgJjf7mVYt4dXH89PM
         dNZ1YsrLH2uhMP3T33LG0IayPZpeCH8IGMAraN5UFFZfe55lTZVq1dP8/ceXFHxrMo/X
         eoON+lpms7o4XiMjO800EEIv44k9Kc4FbUzyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721834420; x=1722439220;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=82dy9mZKo2zcgFYmuz7GnMY2lJ2OItmiPUYNnGgMWCU=;
        b=c6WpyEMGB81J4CAe9CcgAcgSebQWXd1hfYXUwsE7F2h4Uy4LcCIdxgTtNX00HszAm5
         1CAp1LRQJa2tAtLpW1D3eCC7KIGrCQNd4lZcAaEJ6O02JbsEidfQa5bAARDJ++c1759C
         PFCNPGgumF7z3gbS/fe8+4uPkkbKDKiHkyCM3pOHB7cn0bDQvqQkjMZ/dXtDPvSO9auz
         l5RPHco3bzri54lHcXTw5NOWcFZOIr3BobD7TpMkWwSfCwy6dgy23B8xyjnmjOR+Bpzg
         IsiqZMs7lswan810ZcBGvb147hqLkvk/M8jHpMZIyHc4YrNY4z3koOQuAd7HYF9scLp9
         Fa3Q==
X-Gm-Message-State: AOJu0YyerkGp4j1UCDt3W/8CiYPHc5pLE/jgBBQvWJZQsFpwr4fIZePW
	Dykdqj0WlCPlLsRyd2K52mLNBGiWU/A550qk0YxpoqvLoISjugaDmO82ufdfYJ8=
X-Google-Smtp-Source: AGHT+IFlqZ25PE52Kwlz1STx1vDkygQoeHCGfiy+yguaY9+XTj2Eb/g0CwlJmwsN+B8v0pn4jmldEg==
X-Received: by 2002:a5d:9396:0:b0:7f9:444e:4918 with SMTP id ca18e2360f4ac-81f7be6a8f2mr11152539f.2.1721834419757;
        Wed, 24 Jul 2024 08:20:19 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-81f715eeb73sm53776039f.38.2024.07.24.08.20.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jul 2024 08:20:19 -0700 (PDT)
Message-ID: <35b1fe1b-d062-4fce-9b9f-a74c84466f00@linuxfoundation.org>
Date: Wed, 24 Jul 2024 09:20:18 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/129] 6.6.42-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/24 12:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.42 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jul 2024 18:03:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.42-rc1.gz
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
