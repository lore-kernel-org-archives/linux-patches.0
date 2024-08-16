Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F76F146D53
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 23:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723849361; cv=none; b=dIQE54slRWgP0R5BVgDzW14tU9Sy1xCmvweYkYU8yVhqegEiigU8lml4UnrOqwkcNRm+mgFjuGiARRYOnpLME+6/r5whbNmQfMahQGyqeyyYhSJYPmayjGhOu88X0LshZ21MzTTMXIQE3HOsp0e2Z5NnutEcwoxPcod41e+T704=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723849361; c=relaxed/simple;
	bh=psHNo8QoRwpPrz4+9QQcykcs3VY8ieDSbYRlAPUJTAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BHE6PuBm3pASekVdEPYSEZJK8iKQvQdAQP+J6DbhyQZRlmHLssYzvkuEE3cSjR00Pr639fZPtFuR40O+OI6+RVtKo5arlB738ckbjRlmCmu32u9uWhikRg6WUEiGjaqrw/hyL0iLVk8yd/rTmDiHXysWSnaLfAeMy2cegMSGEeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dy1PExFR; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dy1PExFR"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6bf705959f1so19807566d6.1
        for <patches@lists.linux.dev>; Fri, 16 Aug 2024 16:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723849359; x=1724454159; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DXeUef4pwUJCviTKsFgKHcdSlWgkeHOfkWAHMZvvM70=;
        b=dy1PExFREEdNauxzymcYyQAaMABCS7oqhyj3eMTj63KdnxRz67YU9GaCb3NSgrGYoE
         Sk8WoVyYEtIu3OKcLzu3azCT9GcKHpkUnlHcjFUKWCJK+ve2lsb0l80swKbnb1orc0Bk
         AafaBcLFEmEwqNBt2kvm6pr2s3Jtgkuw67ec7tzkJG7NIUyY7c+15pUp/QMGInDYqOmb
         G/EN16GInYjAY98QvHloZtU7wFfM7/lxHaMcbiRuKtgsx0GaaaZco+38Eq6xI0execnp
         xMB3tAQ3eLgGgUrk4RqjMTMmd+729TkJ5I0wpP+XgfwUqkcCTt3UM0lp+109dUT2shbB
         c72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723849359; x=1724454159;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DXeUef4pwUJCviTKsFgKHcdSlWgkeHOfkWAHMZvvM70=;
        b=EB5wGa28IgTLrscy7IqXWoeAgM/kZOgmCjMfaY5V6EytXVINTpECQ6NmVqk9cX2wEF
         SKXtF4mblPsI37hCXQKdTQkTrc6nzxOHRBweg4Xl9te8ZA6GGf91zllWqAxGUOTrm52S
         GEVZjLL+aN1zbjSsXD/YLf6pCb3bDs58mWVts2c0924D02Cj5JjuNYu9ImOd8k8HgYe4
         pk2vm4QM2BxeIHLfTlQVCjH32VIMmc6W75MPCDZr3RAWZflUJGEFHzM+FFATyVzBkqCX
         CDjMCksQunhmdDo0fMQb5TV2BBJfry6xdCNaDiF0vPCU+HsnPNMN2bfa5flU4Q5lzMnC
         PfTg==
X-Gm-Message-State: AOJu0YwegkzxutZY7ow3y14oDr0g9b6AMlp+q7oD6EZM2N15Zy+R9O9j
	sTjSDsj4wF/xOgIrmJ0iTVKjEuK2/UEin2ggXwbXFNMu2qAyvKh7
X-Google-Smtp-Source: AGHT+IHpH6p4F+lu5E8z5j/cQRTdIlpEuUxrF8Oe6HHWv27/V2l9lWxwjQZgoT5QSzAXVf47Q+jV5w==
X-Received: by 2002:a0c:f40d:0:b0:6b5:2f57:1a63 with SMTP id 6a1803df08f44-6bf7d5b11c0mr72745466d6.21.1723849358814;
        Fri, 16 Aug 2024 16:02:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6bf6fef7079sm22479926d6.126.2024.08.16.16.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 16:02:37 -0700 (PDT)
Message-ID: <f0aae4e7-80f3-492a-a43d-aa8c3929c20b@gmail.com>
Date: Fri, 16 Aug 2024 16:02:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/255] 5.4.282-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240816095317.548866608@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240816095317.548866608@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/24 03:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.282 release.
> There are 255 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Aug 2024 09:52:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.282-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernel, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

