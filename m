Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24781F4C8E
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 19:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767986797; cv=none; b=i8MsAPikc/iqko/jscFd9qGeqXhWHjkZSscz1tEru2WGhmiJDKygbqTgOhDO54wQBeCEul9GswGcZrZRud/WGEpSe4aVP3YADrhvn+2huNIVE2aEu9nnNQrEqxpmvho+YMU6OfOQ94/0iz593BZhxCbNGWgHYCrYPVyZhb3yYfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767986797; c=relaxed/simple;
	bh=MRrKWrouY5OMvtZsZD9GJqZsIcogUe7S+ngMcXQaLB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lWQwWVZa7eoMC38eWiR+32OVZkt8T01NrPEZ59zPZJqGfOFMU1Kg3tnH6axZ0lsTmLwDR2Eg88Lfu3W9FnfCQuM5ytNSDGcU/Z3KVeeuX7qX+Vv5JCaQCBqmz2u8/YofvE6HY0kbX8zW8fWXF6LOqmXDO6rDxDAn+Q+op8H2v2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MVVCtR6e; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MVVCtR6e"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b2ea2b9631so521729085a.3
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 11:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767986795; x=1768591595; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zPw5pV7xaN+jU6WOQnRGRkHDBZo/niYwQtqpgOhc0f0=;
        b=MVVCtR6e2VCMDxq5pdh9iYVsTrjLmRICSvjTjsJCmHYzGfprieTy4SFXyv8YKVHsAE
         +8rmy1SOMlxs3XvocdzSZHogfuOAq5c87j0gfj2mX/JXj5iArZUKZo6QSpe4YxF61ssU
         p6swDDhXMR0Q8sVld0vR4YWlBZKR36FLLaOv82L3bcuXH/Qp+AVHTsR8iEitQQRK2424
         jrH0jE6d01L+oE0X1J7YINvg0SoaMrcvMjvZJtp+XoATfg6ObXsRCd0uXVcNfR5hICZQ
         Sktgl4Y+ZKRRJS3pywCIBZpVRgFo/8P1a40j2hX6iC3j5B8vqmVoA5OYzmwiGj7YVTMU
         ZcWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767986795; x=1768591595;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zPw5pV7xaN+jU6WOQnRGRkHDBZo/niYwQtqpgOhc0f0=;
        b=VCnqUVcxRO+VE4Z2WNy95wORnni6vUdN/+YXXDv5WcnQr+qTxnrr71Ts1YWXSTzCny
         4NrxMg9tVPob0VGm4tNpHbhbclPf5TQZycKIZbBhxRvTmSOoEOijQV2MtEZnQ9T1HMrO
         cUA+KRVNI0zhNduR145gtXuli9OyH2+N+9aRowoS0JRW6y7NZd8xhL4S2Wtr1W3d95tn
         KjR3gAx9c4+aHl3b5yZrOacbWgzfo90ud0A5c6xQVJTbH+kLKG3FWOP95o2M+yGOH4xT
         bsQ455apguyZ9b/cL+Q7HgpoeWleSOg0FmT0lKaIBCj5k3XCi01BSeq8tQ0IINwqRr6Y
         Pikg==
X-Gm-Message-State: AOJu0YxDCmq1kkGFzEMcybRqQqxjjtt4KXFFGqq/oz7VwR/6qY01JISh
	6BBhRicjakuVKiyoGdA9bkrKIRNAASu3MlEhoKSKfMxek7YwfBesXFie
X-Gm-Gg: AY/fxX6TlKr/AnSytCmR+tcR7+TjC+np75q+e5Pnu0LgKOcxaECV1stOwnadgzWRVpn
	o8n9PldZWy1PBw3uPYWE8HtLi6ppDWs/YtPmZn2vDBUjlZ5CVDTCH+hmZlKAEZB0VH75g5+WBkU
	M5M9kQinxoIGUhu87J8omgLRLUGeJ+BnqsW0PZNz4FTga5cxyQ/nPpQY76jc3ZNyC2pUHShsc7E
	0rZ65xA5/Zf30DWNz45h0sql2MlGnPz/Y0CwNyYpuFUeCXe7XjX4ki0ZHt6QJCN6Guc/igeknJj
	aIXFl3f6KuHLs1YFa6UJNNyHgd8oxsO2DS9EyMV8HyBQpexiZbgZSwMgKTz+csk6tFWM3mNsS1k
	vIuGFsuvhL5GnQy0CFJya80jri8ybSVT0qcvpDX/UpWhm8WRA6Tyzmvn2EYDv25yJ6m6L5O4onr
	+5DeFF2WqhimWF6bxvDj9l38Npta4i/U97rlE4KQ==
X-Google-Smtp-Source: AGHT+IEpSopt1fa78qKdz4xtY6yAtTulMWKWceoEJ1Y8Nn/xW67ar+1tYva0HhufzicD6a+WA/63kQ==
X-Received: by 2002:a05:620a:29c4:b0:8b2:655e:52f0 with SMTP id af79cd13be357-8c3893840fdmr1522956985a.22.1767986794877;
        Fri, 09 Jan 2026 11:26:34 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f51c05csm880145885a.30.2026.01.09.11.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 11:26:34 -0800 (PST)
Message-ID: <28865e60-dac4-47ec-918b-d2a69975a36c@gmail.com>
Date: Fri, 9 Jan 2026 11:26:30 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/634] 6.1.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260109112117.407257400@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/26 03:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.160 release.
> There are 634 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.160-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
