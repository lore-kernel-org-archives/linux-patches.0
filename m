Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146421FC7C5
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 03:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771386166; cv=none; b=kTNfrCvSJWQP4lsVkHODlpkpA1BJ3NK5Jp1g91dNmciAf28Lsr/gkLuP2BSiwiJhQbL7DPa7i0ntnv5bKBReyJgjnOXkuxoz9PHZtWbR/2Nq2UjLQskwpGlb1hwejID+xbh2cT/ALrPjTepF8jXYhPqQaRcfOw1fjDi8iR0ly7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771386166; c=relaxed/simple;
	bh=XFKjx+u+/hhOhQe7X6vTFITiHd1JDcT2vygR8cKPNRw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gvqBgKbKlfDoRp9zZyN4A2sgS1lqStgtiddQpgYSefHHD7CUI+xwYLuBRrQlif5NvxKLC8aLNHqrvDfUBBE46wuKYcdLpm/KHLo1Yrd0+1AkhMxEn+qc2pYGrayt9MHUmXMkSsUQxgIkE8zqGYRg9zFyCXIYwIPK0aFcEXLWaoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RhXCLsC3; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RhXCLsC3"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-503347e8715so60537431cf.2
        for <patches@lists.linux.dev>; Tue, 17 Feb 2026 19:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771386164; x=1771990964; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rnK88Mv6cVbsLGduaxNFiB1ZInYoTTpuQX8qgOf+0q8=;
        b=RhXCLsC3FpCyUhWnWQGIBDt9Wx8pM33Q7ciA2umRHF6lJKiU7I9SLvwCsYaU6i08BN
         pL7yFYA2ge4lQguefp+d2cCghMJCyDSINYTJKm4OUcyGCOJhvnflYHWsdaXR8Ym1ElTw
         loKb3aB+PocZqNcHNRPEzZhUVBINcZyIe0UzQqLuA3M9qOpjb0uMG0qxbeA296xrVmiV
         vxbmo7JnxApGBqDCcjM/4Ad6Xar8coGrYdbiyHOf8MZviGAnARoaMthL/63rhhF+KiSY
         2dvwGj2HMmBybl5t4f4IJW1bo8NrfMBamSfPPKKRHH/GpTKz+xI3Px7PUUue/OfilkeH
         I19Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771386164; x=1771990964;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:references:cc:to:subject:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rnK88Mv6cVbsLGduaxNFiB1ZInYoTTpuQX8qgOf+0q8=;
        b=O4xSCgUI5eoTh31lUlPJ0wYJ8O6GWjbIhRl8X47EW+nT6qz3n2X+16mFIklD1cSvsq
         4HLN4fhXvElq5N2rZopGIBqk6Ug4/4Bb4uLa2FZG33+sJpKltFHVKI3Pkq7GaPnEuZyB
         mkwTwziwGUk16ORpsxQaIkseqxVCq5+/+/XlmUv++LTmfbG8gLBby9lXdWIRP6/gI2H1
         zSJh/3mcB2Q/n8iVv307b4aDNPWvmVuZzUXyzwGzuxUHsp4E6vwXV8JK+3N2XbH2yxpw
         2MAS/s30dVhG45NvGCfOtTDeaEQ8G6diftjcaThHMeEEyr/ixDV0mFsKs3rNJ3cBgVp2
         Nyfg==
X-Gm-Message-State: AOJu0Yws/7b38D5GbUprHh6Bt0w+WIKwuar4C9BPSIOfxAHt468YtYiR
	4PSO3q+sU/aYr13CqIKOt0E4LAWImt5MrmES5mFNdXk1sk8LZOrdyUs=
X-Gm-Gg: AZuq6aJsQuE8BvfncekuYjIpr9f9Wu8QkT7I/jSLWjFVIv90J2Tf887oZX9t2/O4P1W
	rAIMgm4a+IHbV/6r9vU+KSexa5WYRX/aeO8KHS9QiW+RfHatNjRwCbcxMticQ2Ulot7UelIDMpf
	CUFjiuYEgwMMhC+1u5dplTRmAHC49L5b0ObZm5NKt3NEQmt9FW5Pg0WrF4V+dHhCP4C1C11qcLM
	Y0ipncXXW5u4QJKFYfwWgKGeQXURlDtjU8xDE5nC8yWMcvVQszMKfFc4d1KnAEhZVBIy7uiFj69
	4fGoxnBAewTeEXt4iMGa9Py3CcHvuHzLaFOx8Ad+416oDVhPFw2qdRY4x0Afz+lqaJyo7bPL0kk
	iiwJERqNbxtdn8ApTDpTofM4hSUPW+VVU0eSBFqe4c04GdBI4R7VxYLFXrqP66tCe5KGrEWERGz
	IOv+ULqRQ7dTnnty9V7CUf7xBqpWvnylRLgwn/DYuisOKHptw5PvY=
X-Received: by 2002:ac8:5a11:0:b0:502:f26f:136c with SMTP id d75a77b69052e-506b403bbd3mr177443651cf.78.1771386164012;
        Tue, 17 Feb 2026 19:42:44 -0800 (PST)
Received: from [120.7.1.23] (135-23-93-252.cpe.pppoe.ca. [135.23.93.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50684b94f33sm168088641cf.25.2026.02.17.19.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 19:42:43 -0800 (PST)
Subject: Re: [PATCH 5.10 00/24] 5.10.251-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260217200000.708219618@linuxfoundation.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <7a867e86-d5b5-0ac0-bba8-d38240b7c090@gmail.com>
Date: Tue, 17 Feb 2026 22:42:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101
 Firefox/128.0 SeaMonkey/2.53.23
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260217200000.708219618@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.251 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
>
Builds with custom .config and boots OK on an i386 machine. No dmesg 
issues noticed.

Tested-by: Woody Suwalski <terraluna977@gmail.com>
