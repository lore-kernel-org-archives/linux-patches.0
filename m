Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B5D38085D
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 16:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761149432; cv=none; b=vAqcnG929FEbc62K9rzSy0oIXBCHnroBJ+58mO6tm3E/ajX8J2mqvIeJrxxcSRNlh8zTWKmFR8ixszSJ/KDjLUAPOmcW4wHkorMgNpdiG+A+arSZEicIr3RkyZ5NIrFTkh6ctNv5uTLEHcgKA6j4Ce+VQjWizZ+Av+De4ng0pA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761149432; c=relaxed/simple;
	bh=KKrkK8RpkI2SMuDE/cHHahMB360eSTnAZDbrSoI4o58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n3hbeCvtwQYXJvzh2LQGeRUC9uWHs2wLM/1NnvDPThoXOlQaZafZkM/DFVqVug6cqH5BvZkBd4q4vVe87MDtjONpovuG5U58cGnSYAKY6BJFcWZ0N4gAzUMbTD0BE6ll0m3cgJQHAO+9+N/9l3hacHK19T6+ZrqP8+qroL4FIG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnZODWp7; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnZODWp7"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-93e9b5bafa5so172459639f.3
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 09:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761149430; x=1761754230; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/fJk0vLG7thkf+LY+zE0uqEbWMzbuwo6FawmPYnjzlk=;
        b=OnZODWp7X+7qzPLLR2qgGpfPQ7lgvM+Ffw02/AmyUZa8xuZd4fYtl/Ro7xoV5VlJ+P
         b0YiWdKI0ufRemSGGoTfMtnd4JGa4fXcQ0VC47pOEgHwOuo6Pa2TiM4q55WGrwy1O+Pb
         ujJ+kkl/JqGOl+jAlR9unfRRao/UXtHGCDecM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761149430; x=1761754230;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/fJk0vLG7thkf+LY+zE0uqEbWMzbuwo6FawmPYnjzlk=;
        b=DCHQzXLv3OBGPyOJBFxuDfELZ2QbqYNU6GX/O6euLUlg+ZUlwsMpIkjtawCsV907qv
         rVHz3h8MR5Yg/vFoIh4xyCbra0zh5ZFTdc3NCXZBI+no4VhRve41x0KsjpRJd9vX6uuR
         2jgzWtKF8aEwfGNEjx5G7lLvbUcWJ3Km/XQMJ1h7B0lkBEXEsqrux3Hqvjw8tgvjiQc5
         j5jnqaHYgjV+FAf1vgK8EjqrfKsQy9hFrcuWRBhIDjPyskd9Qo+KXN2V9CfJdpPuOy+Q
         Z/xp8jbvtKyzQWKNQyaFqPqRLnEaqH+djlqhVVqvpRYxckQMxwr2SjzO5Jv/FCpusI4a
         VtRg==
X-Gm-Message-State: AOJu0YynwsOLL7jTuhRBJDIL9wpx3Fd2yKXe5x/iqc3gID03koWfqdRj
	Xi7RjdQV6WjilojYC9T4yIJEPrNidNskCpTmPHkqpNsuqWobL3cgRSs9MwRAPmFG5A0=
X-Gm-Gg: ASbGncttKM2RIgUi83+4L++2+aXd6iNoRfbgupeRApdAwz0VOA8t26bilc+O2YRwWMc
	tj8SOIw4avzifhSGlo//o3mZKM3Q9KVLkQfObWNx/Ac6L7K5syi+CAF6Q/hqCOCBsBxvVprJXkz
	mvr3FgTYg6+jg/ckIUuT+YacG2wSQnu/cgjvzgR+xauMpp58o40/WAo4CeBo4/gQqC8ipQqWELa
	t1cCZuLmIikBOcU2+d80zLSsUtBFBzlnnOUa6hYE4Dex8N7evzGkuoPN2GoCfyFudyOhMcHqzTc
	Peusg9nl83OY/bFOYfJWV+H9MjL1WtQkbbETC3oh7nz8jbxp/DvOx2nNiPUMwpIfp0+7les9muU
	B7MBhMdrtvjceiboevVN6lmra8/iDLB2JAahkzez9KE3z4IxifoDNgIq6ebmkU8oVXjH3YWVCLc
	BYT7axRPFQzE+gY3nn48Amx9c=
X-Google-Smtp-Source: AGHT+IF7j9Lnn708nVHmf7dGCzAt+5tww1lpkvS1+R+l8hRA+Mp02MiCzDvJ4Kqgi3VuqK5H3C3cwg==
X-Received: by 2002:a05:6602:2dc6:b0:940:d157:afd5 with SMTP id ca18e2360f4ac-940d157b1fdmr2126994539f.17.1761149429575;
        Wed, 22 Oct 2025 09:10:29 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93e86645264sm488502039f.10.2025.10.22.09.10.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 09:10:28 -0700 (PDT)
Message-ID: <79b7357c-332d-40a4-b8e8-c521b6873099@linuxfoundation.org>
Date: Wed, 22 Oct 2025 10:10:27 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/136] 6.12.55-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/25 13:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.55 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Oct 2025 19:49:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.55-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

> Mario Limonciello <mario.limonciello@amd.com>
>      drm/amd: Check whether secure display TA loaded successfully

Verified that the error messages are now gone with this patch.

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
