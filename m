Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD591E4AE
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 16:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743008337; cv=none; b=O0XbalxzCpxZilHPDufbsN2YoIwbgR5eb0Z6sWzpqZcY5Nn1Avu0lBYNhOqfiLvXJDMIpIPOEdb/iq/olCdVI6cBCy/f7QxyHgIXIRZFcpbAcdzBlCm94F6eke+ayZTov5RBYAqhPvu6mDx+TooxDd5OGmPMrWfJ1tN0JK8EU9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743008337; c=relaxed/simple;
	bh=7d7yZS4xo1fXp60PzB8UalJwg4J7mzJAalE9ZDZd7f4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DRvB5Rc++PeApmFHSWEZa5GeA9G4D5AE5ezAXp/7zVgx+MGS6+CbqF6u44JMz1ElbM5Os+wIoZFdGSXEnXHlHNaA+kaLIaBraL8W31fhrFfYtaB1f0H/n/+KjtEIWdVUJCRB9Ac3c5ApfVEcXIpvt+1BVrPU92bJVd2gDOzo7mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CLi28wM7; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CLi28wM7"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3f7f7b70aebso3998679b6e.2
        for <patches@lists.linux.dev>; Wed, 26 Mar 2025 09:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743008335; x=1743613135; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8nBpYBtwKb7TURY3wvZnEQG6HvazhLDmZ9wmMqqOCx8=;
        b=CLi28wM7d42Ucu9dYWu5vX0DNad7KIXnA5VmEuSk2L04SdVVBHW0UMdIFucf5JOJbh
         Vb7KSo7Xrzpb/wVhxvYGS5QxyJ2hN4TUXdtQN8PXgvMV3G7c89yh3j+9xqkMWsLmqG2Q
         Jl2iDA7UEN3EXNjrIR5mYwF5EI7EhyGiXa2jjpklkcZWsg3+WOg7vfvD2nneZRcin4tM
         blZqUPx9KwZbcAYOFfrv/hlvGXMsPInyEgliLI2VsQDOJplVvux0zZRhVQ5e94h/4ex9
         iZF434nwYv3os0EmqtY9LfRd5WNpr73riF5z6slF9pusytUAzEfKBXMvQVKI0X9QM+CH
         BIAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743008335; x=1743613135;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8nBpYBtwKb7TURY3wvZnEQG6HvazhLDmZ9wmMqqOCx8=;
        b=RmPK4m3mIHKMTIPY4tGze7JSgsemxKCMB0ZlabI7OHdpvewz4SHRGZyV7SVpDaRtEs
         3wp8M7jhTV2L7h4EI9nKNbU9YATGuUTA2AJIvXK63aIT2eM28ttDTa7rj7MBckz4MA2P
         e8uv0THiTtv0p7JOXbY0aZl+BqsMq4KYez3IxWW0SNUX5GhCoj9PPSJgnxfPtTL3kTCy
         miyfQ3WAXR2ZDQWexzlrsdYn5ZHOOi9DFkbFjIaxpqaUTHnrmtvpW9rwcLMtjUZ2jDM0
         yW4+DKm/374cZgM1JwTU8gbkhOZfgpn2X67dvD19ojaQT92a56DPiN/9Nw4jlPE8c9i0
         BtIQ==
X-Gm-Message-State: AOJu0YymtURBFBd+JsIPKx12MYAqWriJyl4o6+vvLbIYGzzIa9ilzac3
	DXwpjIsMSo+gSGHAmVZHDQWblVl0elPLjTL4pdFsm8VGjjMBvgGm
X-Gm-Gg: ASbGncsbXPoGANtJkaxXgAOtAjCNOm3MjwxSmp/zfDrTRUW+GfPKt2LhfXwj0iRMlrg
	ON9wdcbLWEyBNJf5VU6cIisV8LNFLrb+eGbZ2Mupm6M2uTEI8T0/WUWoSCQjwvEzriNwr/GrpIC
	qBKk94hlsFHQDvrSD+oak5uOQsIx5EM2I7V3enyjmpor574KVAcwSHI1RpTfvGnOdMs3B4yyjBN
	xCnajCmzG9Vb3ARoCf97KjgpZVWaM2Y/rNOXL0GBkYwe/1MDGNZ0MtuW6dQ4RiU8B/p2Nx2zTYw
	AJaotYFZ5Dt5bV580Zfe5S7mY6W2CuGK+P0yU4CBCCtaVoNhApLtmCO2UMz107oME9p5z7CW
X-Google-Smtp-Source: AGHT+IGHS7bbA+ifSsFMTpiUtTW+9RJ8vabr0Lz8CgszfdsX0Gi5ZLuElE60ZnNvDSvA5WM5R1jIMw==
X-Received: by 2002:a05:6808:1aa8:b0:3f9:641b:6412 with SMTP id 5614622812f47-3fefa63dd4emr134475b6e.38.1743008334703;
        Wed, 26 Mar 2025 09:58:54 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3febf79da30sm2443619b6e.45.2025.03.26.09.58.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 09:58:53 -0700 (PDT)
Message-ID: <5884ba8d-46b0-416f-bfa2-62d5a46afe0a@gmail.com>
Date: Wed, 26 Mar 2025 09:58:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/115] 6.12.21-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250326154546.724728617@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250326154546.724728617@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/26/25 08:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.21 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 28 Mar 2025 15:45:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.21-rc2.gz
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
