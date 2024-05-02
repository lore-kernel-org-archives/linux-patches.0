Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA3B182DB
	for <patches@lists.linux.dev>; Thu,  2 May 2024 03:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714618906; cv=none; b=J1pdE24wGMGbvyfJGuATkCPxrzyXF76LU3K0ID1PD8DiOP23jlP24GqtK+1joKvRFZAT11mvmHyzDo1/QmX1RFvHEsmmaO6rKWcEo3EG2Qc8pDgekMK0cDEGOgmsScuR86xx7QswJMqIXZyHp9ux1uTtSKyC1NDrHgMIUBIVrzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714618906; c=relaxed/simple;
	bh=BkZwjGi9xHFmiL4nfLiT+Ex0R1ixPTG84Y2Wyym36rc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=scELnbPx7lbJcXHXTV3NAFCYTPgAMmuDt/35uKf8QjmTbv972JvAghNu2wzC3Pj9yjMIJNEV3nbroiO2A3zz6/gQuM6r9KJp0G6f55TmLp4kuhO7LaOFeN+vEouqy7Wop/ng2t/N15j8AZ/xIQ8CCBJlE4R6NsECiB1YET+eN3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5q6sxmn; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5q6sxmn"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7d9ef422859so57045639f.0
        for <patches@lists.linux.dev>; Wed, 01 May 2024 20:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1714618904; x=1715223704; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kEbLbPrNhjOiBsrjmUYUubkruoX+8IYozwRGt3/a5Dg=;
        b=V5q6sxmntv3xvc6oUXY6YrlaBZU/ELHKmRDYkc4tMooT2epfZVlCNcnOw2scQc/v1Z
         ovdfAODa6bbdu8VApCWv7466MhnUlMCny1VPu+0S/bX3kEqcW6Sm7jJdTTAQ+6bC8k9M
         EDZ/MSgPNibiQQZ09mIpDTnuJIpEWz5yNJpuE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714618904; x=1715223704;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kEbLbPrNhjOiBsrjmUYUubkruoX+8IYozwRGt3/a5Dg=;
        b=DmkNqRfplP/R8neP7RsF1rk4KZ34+HgiuYsizVPJW/i80TrqhleKMYqpFxuYZkAy38
         aX0KL/LuYg0GcF3djUih/lGgX/x3BqzXp2kH+T6rgh8dSPWjMX/K8T2YNB60pLp86ldf
         xZA1OjNs8jAA1rDyExoLGDsYprKejWh1/ryagE/154Pt4Ong6PiANXrTsJ4IKCGHH4gd
         JOy/gvMwP91FA6VV2NIwjnBIpG9YLoEHSYcJqdOl44oqm9tid4f4JhItrsRnRrj18LHb
         rCrLxx70QI8Xaxrv/jmungOAEkUt5v2hfnJmvTcQJyeItlwOHp/NfYwWtq47P+aGqk6G
         7V7g==
X-Gm-Message-State: AOJu0YwrRDyG3cHB24NqOA+zUnwEKPhc9R3vJnIdxNkVynQS4FK/g1Ur
	jTsRyfEHVFLTJX2H7K3CFNL2RrePySCL4R6F+y6OOIgq+p9EcdqJiPZL199a3g9AWa+MabhIeas
	PKS8=
X-Google-Smtp-Source: AGHT+IHjgrfimqrsDqQVMZXl8hehMhT3txq7RWm8puN/VGmrCn5LcYRp8OPwG462EjPGbVuGDuF24g==
X-Received: by 2002:a6b:3113:0:b0:7dd:88df:b673 with SMTP id j19-20020a6b3113000000b007dd88dfb673mr5566655ioa.0.1714618904091;
        Wed, 01 May 2024 20:01:44 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ky4-20020a056638940400b0048805115ed7sm968194jab.79.2024.05.01.20.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 May 2024 20:01:43 -0700 (PDT)
Message-ID: <d1f1ee27-4606-4a84-85e0-284936e453d2@linuxfoundation.org>
Date: Wed, 1 May 2024 21:01:42 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/186] 6.6.30-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 04:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.30 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.30-rc1.gz
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
