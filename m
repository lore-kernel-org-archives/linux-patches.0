Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFE52737FB
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 22:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760134901; cv=none; b=UpiytAgZaKC5ZU7CVS7MHoheA3gTSrVMme/7h1A8JRptcrq7tjaztw2V3Yhz+jThLKmIU3c30nWfgpB4Imv5CAaO9z4dyTEqB3flu5LKS8/FM7Fr1aQDIrlU9c5wdGg4RrlqaOICjxWBTEqTkD5UHiPx4UDheCNZT4AueJMrBkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760134901; c=relaxed/simple;
	bh=XhP/COLjObDz+ZGPI9jHrKcT9w6Zfqb+6aYc6UIknSI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lrVMLtrhHaDItGKxN4Jb3NDy3zJ91BPbcIiae/2Soq0xMlKPMlaYlyurnS9EwZ6P6Fxz4RbdqbzJbrOs3cRyWfSqpbotPYBFUtQ2U0LcvaK1PFoNGnpCEOSnwtbJZVItHB9EFBNEFFXvlHGk0uw2Oo/PRCGnXXRt1PdidDZogVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwkSRhLS; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwkSRhLS"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-424da17e309so25412285ab.2
        for <patches@lists.linux.dev>; Fri, 10 Oct 2025 15:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1760134899; x=1760739699; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1XN8BJ2wM10+ueceH639Pxl3TfZtOWY8UGM70jB/ZlU=;
        b=PwkSRhLS1rAzJedvhtLbyizyA37C3E+nxAmOKJpZVyj4Bd2YCGjdslpVmZSZZfE3sN
         KD6b3CzQ4OOhjSB3DRB0WVVs+mpXkXdrl4K15i0IHQXVBNZM0zDprLLIOjOr5V3omySx
         mokKqxseIYie1Z9RO7o4M1xGad7nOFS4RXwfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760134899; x=1760739699;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1XN8BJ2wM10+ueceH639Pxl3TfZtOWY8UGM70jB/ZlU=;
        b=JL6IUAMO5ynNRp1PY4UGL2vZLrfuopC0tcj0zIKgVifR4HEuSfjuTQiVRDahTAdq5U
         QxDbqGhXj0eGxGgUib5TyGQNFksnWeWCzVsUpQ19oEZpPNoTxQH3cZc8uILcWcfkaad5
         R3I+MIXMOGrGfYmeTHPjvPlQ0CHcAAlZd1nrx9s3br68ATuKKcFPEPON4Tcv79QyYJp2
         SYNG8CP3xnpTAyHwhzAf9O89b5MIUpjJzrmXoLYamcTsVzx9anTiKnobxTwiQikp3+Fi
         JjK89JvLQcPYvykrMNKq4AmmlLAWsA7eAYcs95UAPzzsjYQxMhaVqG0XBOYLdtgrVP31
         4j8A==
X-Gm-Message-State: AOJu0Yx0xOiWCxpZlRZE8gqwhZTVgy/duiQFJ/cTxFtg+9EM0TxfsVEm
	k3coEIEmTn2HIyTWUA1wGQiWvvZ0CFmTnwOX7vBJsJRScQzwWBwEKAkUQO5bF1V/UuQ=
X-Gm-Gg: ASbGncsx7BuAbgs6BMW8TA/Ngapns2cvaAA5chRyNd9Ey8WIL2XzGk9hyaH2k4LMW/Z
	GIJ3vi/dTpjCzTh+moW7ONxiR3CxI0BNfgJxsrfdMa1Nv1KxLgCo7qAxOIHfwI9rQRp5WymB2zh
	pkkg5bzSMddQZOolsbBirU2Kp8dv2VdNCTKsyMRHOMxxclfifs8IHf62W0xi+RsIPRZVIBDSMEM
	EEYEmEdKkonnbpDA+VnMJeGooLSd7ox/SGhcO5DP/SVWZeCgZU+TCQXyAjSh6VtEHMAHBE4irKj
	6YnY2sAS0ssFm1jl4Nur3UsxLnTtPVQ4Tq+pT6WwbJ4vElgR2bLGmcclcRV3lnh8/pfuY2vnYg8
	pRGWSTcm8RF9+I+0uOrdxY2/byysK38xtWI2HcDn4o+iTowkW8VoYxQ==
X-Google-Smtp-Source: AGHT+IEaOdM6AjtKS6UO4o7mdcrBSBEqizYrTv7AtuOpOFMXKvh2X+ICbaotUhVQZwNOfyX/mRTl/g==
X-Received: by 2002:a05:6e02:2286:b0:42f:94f5:465f with SMTP id e9e14a558f8ab-42f94f5485emr99584845ab.29.1760134899305;
        Fri, 10 Oct 2025 15:21:39 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42f90367296sm23828295ab.30.2025.10.10.15.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 15:21:38 -0700 (PDT)
Message-ID: <1c714af6-fc9c-4de9-8f8e-347c3ca14b34@linuxfoundation.org>
Date: Fri, 10 Oct 2025 16:21:38 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/28] 6.6.111-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/25 07:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.111 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.111-rc1.gz
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
