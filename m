Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAF61D68B
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 16:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OdsI/FbG"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7781bc3783fso320262385a.1
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 09:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698163492; x=1698768292; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ig+7+uPCUCps59Bni0g2YN72fr9TY5plHFKORuybG5Q=;
        b=OdsI/FbGsm6E2IOBLhhy6i3wV3LkK9R9upLcNd6AqevydR3rHAJa9ZcVvveVuhVbpT
         JwgyERzcZLgg7T+kqNmZOkbH+jT+OTM1EXZgHfKujclS1VJ052gT6zk61455gjAqoJno
         3wIsbVJ17LjdM2PsDB/MyQnyAqtuoMaI3Q+cqcLbY+Y3lKWzp2Y9zx1pJAOTgG3S7f+w
         MzoeY2OEolBvn93sMEnTajTQcq4f9cu+XJQeUe7MHxWkVdI12tkq6/adw+IJ8zXROSbq
         +WE6fECq8PJalt8j2P5E7f2u3NrH6I1XfnLwVl7jNT3akGGxyjg145mcfKAVVpeAOCXk
         /9JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698163492; x=1698768292;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ig+7+uPCUCps59Bni0g2YN72fr9TY5plHFKORuybG5Q=;
        b=qIKP0o6obdnxl0mnk8FYdHNQe1AkfALB3uNuTOYpGMGA98fp5le86dLZEc7Gfgt52O
         Js5rxLWy6ZW66TkZzRayT3UCpVQbdvYdVhEvKZ8c7dSBAFrzySfaX5mJJlXMwKSR+OCt
         KKkuvBFcl2Hxzt5qjm8i1KGg+t6K6eT6A/fBZvLnSQ4je2kDZdn81YoZZCv7t+vIQ5+b
         RHEOn/QnP/dy/TAclHAAar3yYEmE0ROOtNZpKif29a2Jxx79V7kKh03NyMM9QNDDRJ7M
         XMbnE7aBDiHsnz07nwxEKQhVq/tSi8E1oJV0H/Zoy0Y9uEe+KKBXZvpu4EsthLbVM9lS
         wHiA==
X-Gm-Message-State: AOJu0YxKs9bjkFEE2AFxHXeqtHtF4TV3o0R1qZBx5Ceucgt0CL/oTMEx
	m0gbrqMY74ZErsvQbO1miS0=
X-Google-Smtp-Source: AGHT+IHD9IORUj+giaVfWJ3qnW9pjv2yoTszCb5asRsFB8qN4e+DsALNO3sH3Av3/40jsW6toIqX2Q==
X-Received: by 2002:a05:620a:4248:b0:775:69b4:b4e6 with SMTP id w8-20020a05620a424800b0077569b4b4e6mr12523329qko.7.1698163492282;
        Tue, 24 Oct 2023 09:04:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y9-20020a37e309000000b007788dac6b24sm3543683qki.41.2023.10.24.09.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 09:04:51 -0700 (PDT)
Message-ID: <c14c7f3c-ddc1-401b-9866-9d07a1b1ad00@gmail.com>
Date: Tue, 24 Oct 2023 09:04:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/135] 5.15.137-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231024083327.980887231@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231024083327.980887231@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/23 01:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.137 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Oct 2023 08:32:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.137-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
  --
Florian

