Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532EF285C9B
	for <patches@lists.linux.dev>; Tue, 22 Jul 2025 21:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753219449; cv=none; b=SRT8ZVcDejOmRuHCOr83YYb+pM+LrHnG6lpiI2dwdwRBqGAQCgxcToJMRaG9IrUWnS3iHm9/LgN6RcuwbqR9w5ltml/+AH9L2J4Z1K8oukcj8QbrON6x+xegkCiKcJ3IN2jrKYAHdnEzUKgd54aPZ7jmbITdeDPdK2MHDrTqT1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753219449; c=relaxed/simple;
	bh=eYL1o47Kleefpqy0F6S/ozw8zz+oDdKbrjvaR7zhri4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TlYNdpnIKffpT00tx1RZgtflTdZg4z3FQCYJXDDZ0F2YdNSfkv0LHh6TtG67KwbXY8PnXNobJy/lIKGUGA8lHgNxkAoxLpp1DVvbvph/wV8DL3F9c4YoHo3QeBurg0LKyJF3LwXrmqcIDB+oMHJpKvy/cFjlyjNr6LrBF9o7pBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFMPqocj; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFMPqocj"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3df2f937370so23085165ab.3
        for <patches@lists.linux.dev>; Tue, 22 Jul 2025 14:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1753219446; x=1753824246; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qHBg2rMZuWIVzQC6BiR69k3jKDmsa5yJmHZY1CaYlic=;
        b=eFMPqocjE1T4RvQj3twIyUVXXNzTBoNYua8ThoQRaUPVtOAFCVR2c8DiB/aJ+V5tmf
         /N2kwozOLyHrYzX96SH2RBy/RmgmioFQ+1IMrPAG4ELjIVy5wWPHeSUuPKRC2afbBTwE
         00Tr6UPetb6lk0rLB0eAfrySKS8EpH3JK2qKg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753219446; x=1753824246;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qHBg2rMZuWIVzQC6BiR69k3jKDmsa5yJmHZY1CaYlic=;
        b=JbZgdc8a59TDodPmoJwvlxE/14ZMRPMMj8AqVDTbQH/ICe9n7RrAuMn94ELWUFsHPU
         a6b0db7B42AQDpxMlXaBvmM545ft5aknC71UbNJIfKNJq8KlMvstnB+ONooQrn6zoMxn
         hTCMgbstrTFjTqFI38VLTiTRWKg7k8LNI5o8eM6/tSPzC5ltqbWDUX1JdEvcpv0l5khi
         o9D+vizzNpY1X8QDgQzyQieYzXZ30murZ35Q+IEu+aF2ynoQ9+rRHoXpfgA2YSbBQETh
         NHGazXPZyhc9L9SP5wdvn47EcEgUHp+do9fcqoUvUbuqBMVCMbqmZWhFH5DN2MpH3FuE
         PxaA==
X-Gm-Message-State: AOJu0YxuW/zive3EyfwWwjuqxijkqz9931trUbtvfpCIrImT1rtWN9RS
	8q8x4WoeChcZ0UMzXnytinGltpglgIR2Tdu9I7QnUCW/nluJ4CZjmw8a01gSgqoNkRA=
X-Gm-Gg: ASbGncu1kCMucV6VabcFm11Wc4kOjzNDhzWiOwL+Y4N+qeXhH9tlo/9VLS/QC4neVqc
	tJdjJ5mQafHb+BqovbRzOMIzZwE1SgvPLQ7eyVCb3OIN0ZwpF6+WO87EgWtjAeEs+Zkom/Ia2Qp
	LLBBElzJDkMYjDTWqZTt2NkzeCQZaPx33TIIbcbRlxhBEESa3/eenHI3J3InJZldBMWPnYNN+vO
	ZdoJeDUjge/2kpZdCEfy0u30++9+8s+qawkkRKkmqhBVY2/vimB/9tnc9lh2sgNEm3uAuDQPLDd
	P+7X+smRRtxpEOQFn6MP/KFQAaBdWkQLVvqJwrVlftGFMgbEJNQDDOIYoXeV2Fw5MatH9RhtZ/K
	uk5js2+tauVTu2bxNRDvzPQkO9HHXme8VmQ==
X-Google-Smtp-Source: AGHT+IGf2Vg6LS2KrJKv9TjiWcHOJsVguQEuNaQuu7hVEhq6SSyxnQbG7sJ1OKFBgaprLgEFn+Tfnw==
X-Received: by 2002:a05:6e02:4404:10b0:3e3:843c:9d16 with SMTP id e9e14a558f8ab-3e3843ca037mr2668115ab.12.1753219446313;
        Tue, 22 Jul 2025 14:24:06 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5084ca03da6sm2781182173.100.2025.07.22.14.24.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 14:24:05 -0700 (PDT)
Message-ID: <c1c09085-afdb-4b1b-971d-8428993a6364@linuxfoundation.org>
Date: Tue, 22 Jul 2025 15:24:04 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/111] 6.6.100-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/25 07:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.100 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.100-rc1.gz
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
