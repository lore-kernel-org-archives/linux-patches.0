Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493173431FC
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 20:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755636687; cv=none; b=QOnkSsMn++PYg+w2iiRylmPQ/cDTfOceYVqla/41pXCYdHsJyMZOR6ZecC9tU6d8xULk9gW99fcdX3cTgSBMhJaslq8okMQL521CaNRszpU09GlWkbKhjrduoPsNcf4TwNLX+Km7/Hbs2bMdPM7SyiDR+vgomeGivC09ythPFMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755636687; c=relaxed/simple;
	bh=w+I5h9FrVo6GJyf42svnrmSfu80vcabvipVnsOk01FE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B7PiS94mLHyRb+WbuU5bChiGzvuQi9PS0ltB+4JPMYU8KUtegmdu9W1tn6cIv+rHy0tFHURJNNt/ZE12ums3KglcUQvPbKMzeEXdxlWDKRRa3R4zhjsCfsI1MRzlOHKs8V+did9L8eZW5lFzfBu8qFDFAC6OsC7BzOEuVyRyxjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fwkNjZ8w; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fwkNjZ8w"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-76e39ec6f52so5699797b3a.1
        for <patches@lists.linux.dev>; Tue, 19 Aug 2025 13:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755636685; x=1756241485; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XtxagHbraCahR6FZkzV7pKn/fsOuCmexTQaCPXbwYIY=;
        b=fwkNjZ8wlJ45Y5/Doi0qGNEulynjmozryLQEk7M14Ed4+rgDcG8dBLq/eBxetes+w8
         OxqDiMcPmppbK/R+Ejo8+fpeSbghk2ijhdzqU8hprGx6zQeV3xdhHvKIN3GIP6UhDSbJ
         HiGRii5mz1HRgsD+cAw9Hnk+xddMex6tXPca8CVWA3Bc4iJLvVxNoc0cXFTkUt/IWWHU
         vpBjLJi7PFQkdX1rcjQPoJoo3AsX/Ch9ohetv1JK1gXu6TL19cbP+v/L+QPP8mHUWFdd
         CQA/VVIZ11Dln1eMX+ULJnY5D4M1RZUyXHckTEwlFEhn9ZdKVw5p03G0hgNjUhSj/aW9
         9w7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755636685; x=1756241485;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XtxagHbraCahR6FZkzV7pKn/fsOuCmexTQaCPXbwYIY=;
        b=hOVQZBPaa3qq6HL5CS6fBcjSITpJ3Uf2sUYwq2acejWIcEVCm0C1Zx/UrQfufx8YtD
         W5/bnTXRvUC+EKHpZ1pUvs9EgSmKvBEAEioFXn6Y/0rHOjLifDP6WLLSTGURpF/2ib88
         IB47dPc+hPD3BZ0Ucy5iXFGozsulLtrUkd9h7cK/rr9MhefR52tCv4luULpfQFpDKKqW
         n1eGN1BZtsanYzHn2DcfRlyWHaGWPYLOm6SXVz9rWqutI54s2jwHSwOThgWfoslflOL2
         S05HncP54wWB3JHZRClTWjYl4kthmesklmg6LCOVxa3UtCivjS3n8LHd08H7UP1DPYx5
         LnSQ==
X-Gm-Message-State: AOJu0YyDRxHkvKHTf1QUenWcNPPEL9ETuyzp4fdvAE8rqbUQQDywvQdw
	QsFQC62paC+O7AB6kajRB+ftXkf6l3NqqReZvvNz6xMi1SZHV2BL9ygFnuyn1g==
X-Gm-Gg: ASbGncu/RpurBrc5V5KmKABEpktq5U5ANtnnJpgBprNe72BW6UMSgvDw0+hb1ss0efe
	vVTHbT5xw+J37b+1M8+MavaeQYbzJ2IsbPUoun6KHesoZMuLLG3CkZCPglksR8Q54NLHx8rKHOI
	Km8sv+/YwuPOUh0/QBr/fEiq6/8N9uLAYPAYgTPwc1H+hsk6CLKY1h2O0LVmhcqxqvxNpQi2cbL
	9Y2PIG8tQZeXDrbgM4L/TUJL8Ggh2fycAkJiqJ0L5TziGwaeqYcWye/wxjiWe1oADVnK9cG1pus
	DLWP7ma3hJ8mG8xsDnkfRUXdXf+39nkvY0kA+luTQQuuLtBgLQSmMRWUaICFbqXzwc/X28n+C53
	n4F1Q5eL7zyHX042rbAGEKvmju8vKjJTcZCJ5hBISTLvbEVF8zdj6Ag4=
X-Google-Smtp-Source: AGHT+IFzMdg3jlRsNy0AGKdptqmbmqpbyojhjAFG8O2tXO1V/DLRxCVqRPUx2IOlzuQWkaFtgIG3Hw==
X-Received: by 2002:a05:6a00:21cd:b0:76b:f06f:3bdf with SMTP id d2e1a72fcca58-76e8dd0aac3mr791397b3a.17.1755636685549;
        Tue, 19 Aug 2025 13:51:25 -0700 (PDT)
Received: from [10.236.102.133] ([207.212.61.113])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d10fdd6sm3411398b3a.29.2025.08.19.13.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 13:51:25 -0700 (PDT)
Message-ID: <c645aa7c-20cb-4619-b507-a6cb7b7d0d34@gmail.com>
Date: Tue, 19 Aug 2025 13:51:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/564] 6.16.2-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250819122844.483737955@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250819122844.483737955@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/19/2025 5:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.2 release.
> There are 564 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Aug 2025 12:27:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <floria.fainelli@broadcom.com>
-- 
Florian

