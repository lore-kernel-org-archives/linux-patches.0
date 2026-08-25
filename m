Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278284908AF
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 22:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787697183; cv=none; b=sMsSSiS4rRFMYy7lKiGQbx2fqcTidAXQbM7sycI6qtIoqZN1NW0FSJJRJCjMgTCMUDNqQK9n5RjLMZP3EmBM3WiCFWcKlVHUvjur6tBc5iD2SMIgKuG2nmioDZ1IM5opP312sKWz5wA1x+D7laphtkmZdxb6cXUxlAn9lT5qECs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787697183; c=relaxed/simple;
	bh=hkS+ij/4QIUn/eSjY2s1BHYyQ3gtrdbmnSZQZskWohY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ihcEYPaQQT/XG+qgRAUKf2siyk3PUtDMzmGUlXuPoqBdNlYV5zwR14OIZaXHSV5wvgIOIOdTCue34+6tjs2DGVIlaWmSCEI1Wcto+JGWku9uNniLad9mCtKM0cYj1A1g+5VRGwfCGRLExRivyAjnRrD8NbMGyTdUWgNyZeXhESs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WoHUc8ge; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WoHUc8ge"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cbeea240819so234189a12.1
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 15:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787697180; x=1788301980; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TJSb9WBld/1/tUPNLwV+CZNLUqE0Mha7foQadGzvq8o=;
        b=WoHUc8geXG2e/MLDO8xdwHCpw06Y1gctD2FO1XeARF2nkh5GVF5OyK05k+sXBDfT7K
         yu0o6lJmOOWPW5mgRcRgt0s5itxAornx7kS/LVtDKq2CqNJJc+0yUyjyVdPCiWcaPfDo
         3iVzoRocLPGy98oIdEfRpuTd1Ksawzc5yQQca3WnyCrGwK+/T8vSW8dSzz5ywKNK3uOz
         y8AFICLXPAF2IUCDagPs5apQujo5P0MaWEMPWZlMXcYCz5a/LIUYIxIZW3thYiWRpQJl
         Q081XgpnG/4xUWbfZktx4/k+pruUxxSR8wyjfuzOLlHFPjSFzUb69n8Cme19Xeuzeh7r
         uRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787697180; x=1788301980;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TJSb9WBld/1/tUPNLwV+CZNLUqE0Mha7foQadGzvq8o=;
        b=mvcvocOtxOzQ8BSm8YXqqNmAA60mZSu1KakGpfVIwd+VFcvARE5WOfmeNdwzw4Ji75
         Ojnw0PxH9elEMz9GuGCj++3cmzo1zdplR/cGM4eD5HGO3HQqwlfwIoR3aiu31G5xmdk9
         z/deB90a00L4KGweHqVP8Qreu02Oqb/9daPHPFepRWArfjY7njJIxgVjTB2uVG03Nldj
         8L50YuniNRAv5tSJrmNScadH0/TIFVEN8x2nsXDiQIBi3WQ6R5UrbKxT2I4Sx4rNqY2/
         q7pi6c0zM4jpuIijJLU9/xSllK9Lf+5CAxWIQy6+7YMHqn34/i8ShhNV4KCXdn/fNvkK
         6zSw==
X-Gm-Message-State: AFuF++ny6QBI3IpQKusGIStPXnAVKCUkoI0MXzZd7YO5yvKx8zyZomFE
	iUOsIqP6eIiRq3Cq0RLixI6f7uqCFQxFomqhk48ar7MFjCgTo2sNKYmR
X-Gm-Gg: AR+sD13v8/bVf5ut8h/2GCeqFwJaKLHVBWT4AX63H2tYKgQ0n6UpQVjBdUaNDjFndoL
	vKDjqCiQdfqwBAGGhL7lFiw/1rUqcaoSMrnZG6G3NDOV/OSwSQmwN26gUcffxKUAuqhoUDp4ijB
	t87Jc4okw3Tl37pN68H/AQDDn3rHgLKoEpA2nP1M6mHaFKpakKHlYtwi2l8v6ZTX9P85GHGiwKE
	yOnVfSr+uCIEgnyVFG7MMeVLfjNgPcI89YyhlEnJQOVD7c2ds7JDEM1rDhlgQb5lAhM+E69RSuZ
	TmuyfM0Eg8avap7j7GUdaasEhP8MAtY8vBTXkI/RlOwAS84kZVVhNp0jsdM/4b6oiVsORkwjBwM
	OnNBJEwiSRQQWiJJUCMr5uvylWz/X5M7yOR3PgIz8CT3jQP7w537Q7+eX/M5CaJOmN53qkk4UvW
	sVR4yRLEtEsofjGepfPG9CfXQKtoqWb68M48IDjlyAgoOoipVC0k7LLAMqSLTVEBL0uy+Y7pFxv
	vjB2eNMPRgfmws=
X-Received: by 2002:a05:6a20:728b:b0:3cc:feb8:ce34 with SMTP id adf61e73a8af0-3cf85670603mr2849349637.17.1787697179842;
        Tue, 25 Aug 2026 15:32:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141a8f20095sm2319217c88.6.2026.08.25.15.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 15:32:59 -0700 (PDT)
Message-ID: <5b991549-d202-4989-9e2b-a6a350f1997e@gmail.com>
Date: Tue, 25 Aug 2026 15:32:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/77] 6.12.106-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260825132541.580275153@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 06:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.106 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.106-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
