Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C8A7710B
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 19:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714505386; cv=none; b=Bob1wbv0PoSOcBcNYJf8Ta6q7fpR+l5wLQyg2XRssO9q37YXxnSbG5eC7yjZBZJzzbxoPJUcoXZDCbpDP97YeveHbauXRPtf3gsn1BGBvAxxguXTvABXPpIw3AW3PM1lTiD/4jAMlcSAcuFfIKebw0jBMBa70w5DQphARmvuG5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714505386; c=relaxed/simple;
	bh=Cc8rFrKqFjUh9vE8MaMOVmsRSThjBVNwQFIE7Xfqzz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LMxhc7bbliaYAnlCYi6gGM3ZpGu0lMe+hgDA/dlWIS/v2gfv351WlJS8p9qK6vTEtMh3DQmZdOkxZVUB/1irFwZ2PySJYdyftF4Cw+0QHECC0OpRq90WpISPclOMoaycTf5sVaOdi+/jVHylBrKCB4C9oQqTf2crnZxMRih09Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QPTLTStV; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QPTLTStV"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6ee1b203f30so1885074a34.0
        for <patches@lists.linux.dev>; Tue, 30 Apr 2024 12:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714505384; x=1715110184; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jbqkN4SGmwkA7nlxDTa0QrVcWbknDTvNN700GXIjAyQ=;
        b=QPTLTStVK/lCvd1zQ66IZkq1fBZAWrwez/ZH/erDqLormqpd6SzkQa0dlsu2U91WXZ
         VX2b+F20qAcjxJUDjsbpCCded6XyCAim5wiiRvHqGmeOvot32ZSiVwh4ss3tlnJn3Nyy
         8IoYnJqHe5IXl263TSA8o3iim6bf16yphQUrCP3pFcGCQJt+yNYV6uYwIdqk6zpg//uD
         Ya+aveIkhMTbVU92oqjqmbiQPfcRDhSwIunTKgahwg7uscSMvx/BjicTv9oSlzVWxLom
         FY++DLPl8gfWavPaMV3qz+zylbrrMqTWmkoXos0N3oURQpGk3myOAQWa/4qOp9ZoIncM
         5BIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714505384; x=1715110184;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jbqkN4SGmwkA7nlxDTa0QrVcWbknDTvNN700GXIjAyQ=;
        b=E2xrM/duerJgGMnYTpCCaTcOEolMuF305yFlq6g42VY3dE4i/+cyrb2vzp7NU7hMJ3
         E74V/pDPQzKHiPlcv4HbScqd6t5idm9Ze5lI2bH265m5XbPAeGKuM6Hx08pAQ1i1gKry
         TaoWkGNaIeTvpWAqjotDKYGZFPjtM6cEsM/Ea5nN06kn4MWOBphWAJTdvBZgDguTiKHj
         nDiEFGrv3PcPXjbEm6Qqm8oaM0+pVZHlX4M6ooErxgtfBi4T8CXinFNZYtZ8Y0GNA+ZC
         qYG9ZJY0xROuPLJkXSxn2/ho4u6DLMFEBDeQTRWfbbd5UU4X7wV8k7xJpTq/fWoVkiqT
         6kqA==
X-Gm-Message-State: AOJu0YyGbSRW7ReSg9ZLQefOnmJcMd7Xao1EkNH0pHFKyuIFdbEY4fQV
	TL45+RijOMHicOJTFW7g5uR4oKMJb8qjpInFegRwKLHe/iR0qIH1
X-Google-Smtp-Source: AGHT+IHgEPMNSqehyh4pZ+KsgWY4amN+6zFG+eK2Dl/aF4k8boTtwcXDSBN5LzsPKP1DxDNZ4kEMKA==
X-Received: by 2002:a9d:7a41:0:b0:6ed:51e8:4d0b with SMTP id z1-20020a9d7a41000000b006ed51e84d0bmr515661otm.11.1714505384024;
        Tue, 30 Apr 2024 12:29:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n66-20020a632745000000b0060fc94219b0sm6410479pgn.45.2024.04.30.12.29.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 12:29:43 -0700 (PDT)
Message-ID: <3defd0f4-2883-413e-ac82-3ca298dea005@gmail.com>
Date: Tue, 30 Apr 2024 12:29:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 000/228] 6.8.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240430103103.806426847@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 03:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.9 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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

