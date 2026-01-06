Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30B2280033
	for <patches@lists.linux.dev>; Tue,  6 Jan 2026 22:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767740137; cv=none; b=swzoZ2KE8tl5r9F1geq0Vz0KZcU3O4AKeqbtpvT5Y9VQpr5jFfG9IbA/HtVXS1utF4z5RD4xtvK85DenCJna2eJaa+JXcxDn5QsAkej7XhVsz87AWJCpqRE1bUmybWTJivxlkHELDooQ9s9CaLcXixsMBtqu423k5/b7r9uZgtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767740137; c=relaxed/simple;
	bh=iCMfYaoWFeFSV9Y0pyjpD0RHZifqrHMwZSJd/TScT3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L/52bVoPiRbGR4XoDg1KKxcQdLmeTbtJ9nl1q3D06Jpeze9u0rv471ojRNg/L2nw1mBqgHKsj5W+n3jwNoUGeY4A1J6TgyjzKDML1bO+GOFnnzN27mO9YYuQKwj7K3xbK45dG2IKOUKo5CsivDykCq+m3PlaWiVKd+/zwhzZyXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL/Y2nr8; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL/Y2nr8"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-450ac3ed719so985114b6e.0
        for <patches@lists.linux.dev>; Tue, 06 Jan 2026 14:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1767740134; x=1768344934; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EegBch+UWSACyeAnsvO43oyJ9/0p41ZTPW+U8w1/Vok=;
        b=eL/Y2nr8F/j38/DQ03YZKTm+0U5aLS28hZSguAorsdURCM9LdsVgqvRC9wWseha9by
         EFQ6KLH5FoG0qsFSJJs2HIQ4s4JfC+i/9it5/Q+2+/tma9C0NCXMVLNfOcsaecCwqCuv
         qJcngDwiObkN7+OLICJNPeeDKV3/LPeGnhq4A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767740134; x=1768344934;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EegBch+UWSACyeAnsvO43oyJ9/0p41ZTPW+U8w1/Vok=;
        b=uKugof7wFq9c6M0CLRaxZn756410QtgycuYz25mu1d3PiSIo65tDDLeeFgPRAPj4Au
         KAB3y/hXrROs6bAzP3zSfEafxCpXdo0ef3usaNaGSqLo09540cAkfQMSRID6Ohxx07RR
         rGgVIDD6MR6PcPBiENxnZX7Nz+niWoPMVp9ecLX8H4ztlUESOPLkTrEg0s0uv37gbLkJ
         BqoAOIGw8FNWFrBZdUFAa71zXi4sNbup73tBM5/alhxidlEAyJrFhvO/cyrcUNdQmvKy
         ztkg8OReSBSfxmpMXM8iKGkID7OIk7GCz+o3ZH+0ewAUrzwGOM5enalgxPYfOpz3HXbe
         p4cQ==
X-Gm-Message-State: AOJu0YyJbg0xw4L0+7xjfgyvqM5RlTvM/DXR/krWQEzktbOxV++Rg4hL
	bfTDT4RRUebD2WWIWrE1qcM4L/HgsCJ7/lB56HCbEJusPxH8QTzIR2RMOiFR3psaFzM=
X-Gm-Gg: AY/fxX5wUPJp0G6NPLwMKmysSPqnSf8m6ZZS/806hHe/SFt3kdhn8mzbg3Z7EbTxJLN
	0rQx6C4azpBEMIsJQefpHVLGfrAvlqLYW0wP0Mm0rYd9kn1Xx55uNnqLXjZw/iVnYGbP1dRO/nN
	41GtjfZkucOwTBf8EpsMUWDY7RnqBJdfsROuisgPXk1YpEWW9uwpas6Goo6kDCQ3CBNg4ImGhFc
	aI4TjimmI97tdA4LK4ztmSdA4ugbrWHTHpfGJ43uZM3FrAdH8JOxVaAqp6BwEqjufIgWNeDz9AC
	gJci92mg5sqHk3IiFS7WmGs4/85WGZaU9fjCRtoh8t53k9sG0FhbcrkJnzYF83qQPGAfkBz0gqJ
	h4VfFwPSpQDwn3555bleLqPOCoXYjPaIGWD9LxEChimDvPXG5kx9fPHZFji6PlAQV/dEB8wTNkM
	tDA/g0LfxORiVn8tXvFNGTItc=
X-Google-Smtp-Source: AGHT+IHaquhJ9jlDTyWBwhE/0CSN8AQ2a6ssqgxNHLwzbVtdcx3wH7bytu1D/nkLFdPudltgI8pLrQ==
X-Received: by 2002:a05:6808:3084:b0:450:d7fb:85c2 with SMTP id 5614622812f47-45a6bd173d1mr354652b6e.19.1767740134568;
        Tue, 06 Jan 2026 14:55:34 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce47801d58sm2311308a34.2.2026.01.06.14.55.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 14:55:34 -0800 (PST)
Message-ID: <2859a466-54af-466f-973e-2d679837a60c@linuxfoundation.org>
Date: Tue, 6 Jan 2026 15:55:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/312] 6.18.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/26 10:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.4 release.
> There are 312 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Jan 2026 17:04:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
