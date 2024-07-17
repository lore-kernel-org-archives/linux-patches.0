Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433CB1E86F
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 15:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721231477; cv=none; b=CZJafn+K5svaRGNAa2E4upvOSV6XzUB0q5r0YiUhvV/Jv5MsmgNBIV/JcZhoumsM9BRCbmZ9R8TwbYAbLdtpXiyBRB0OiTXtIFeyzkSHWARuT8n2yil2LNK+w7Kfrt+Ve85hQF/s5hZCaS9ya++LOVCF0L3LsizdCYh2oaX0lhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721231477; c=relaxed/simple;
	bh=RT2E8IgjQ+esWzustcQ79s/43qy/PvDGd2M3admWG6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JYkk6okV/yl8JBC/jG0VhVX9cnTtqogj6DvW0cRpnliMmBXfjK2NkVMhGj0L9P6+Qth9zKreYW97Ndg4g1O0F6uU2r5O7KuSaRTArxPHTjlOzm7oKtP2rMmLSjcPXQr4Ni2wqKVE5QvlNhEVAK1tY8dWz2cwrcw8bJP/YTXHPj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsKcNExR; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsKcNExR"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-389cb8f18beso444695ab.0
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 08:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1721231475; x=1721836275; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jYnYtQtSATBdLSe4GSr9qVfw3Tn84Itp/iiWILaybaM=;
        b=JsKcNExRrE+bJB8/nA57TFfkM9DXWjnAqDTipPhKnQDt9gVlebQJ1mASElJYmABj6y
         qdJF4fTbzfJ504xlSbka8A/pGU/UfhZMhum0q7+amLSoZjI/abxhypI+v7r9l5P5qDs9
         R+Zk8A8nkj3qjpomqsbaO371Vo07NzR3JhbJQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721231475; x=1721836275;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jYnYtQtSATBdLSe4GSr9qVfw3Tn84Itp/iiWILaybaM=;
        b=Lj6SS8Otd4cNZyYeQgj3boBNvlyBs4AuuZ1lYRSh/CdwK8cjofeVmmKLoOICKWVP08
         lQDvj7NSSH0MpCQST/jS1y8T0bIQOuYMg06nw07IP6cFrjrpySi8/wUKVOA73SITOyS5
         xh+3wtz1X+qZfTgUGtfOoFWk0qqMVz0h5GfV37Qdf8RDM2oyhY+1Hm8IZ9SuRhQp16A/
         eCdo8Ijfj2VXuH56ndg//WCvonEKjXsqAEzTe5vHYET+5jWQ5fl3hSyLUXJDu1pr4r3m
         4X8uCRg51gcr6x3BeOK2FSg9ScmBEWCHp9EcHuVjhcZd0r1QLPt/Ev9Zrll1T4UrRiOT
         TMAA==
X-Gm-Message-State: AOJu0Yw/HVNw0GRiSOopeSOp0rEE+RU/rE+tK8d6HY+8zWENzM77cC9A
	dDpY5cM5jpF3z9xId1ITfz7VT8LK0pquYDU2YZoQxRPqX8rvM9eEgizaurdjxrI=
X-Google-Smtp-Source: AGHT+IGbmhAM61xxYTubsIKvFuOrqkQMdiMfd0yDLTqmjOm0hPcVfZqtZOkHALmz0YTX6MxJcCUh5g==
X-Received: by 2002:a05:6e02:1c23:b0:395:fb15:280f with SMTP id e9e14a558f8ab-395fb152a5emr6780115ab.1.1721231475239;
        Wed, 17 Jul 2024 08:51:15 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3950aee02b7sm8378585ab.5.2024.07.17.08.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 08:51:14 -0700 (PDT)
Message-ID: <7cbd02fa-cc6a-4dd6-bf97-2bc6b5e14646@linuxfoundation.org>
Date: Wed, 17 Jul 2024 09:51:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/96] 6.1.100-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 09:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.100 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.100-rc1.gz
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

