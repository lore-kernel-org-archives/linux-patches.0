Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F43425A2AE
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 17:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751564213; cv=none; b=ThbLlxuXwKqgaKiPL2oDBUCdh1C9ddUKDbSdZb0ID9R+P2Zl7uhOEAuNpZAuJcDfNIAc9IQZv9lvorv0Otrby4t5tOqevzFLRHB/7EZknQd3BZtRd2N91pXqFm90abmCr3c/d+ziaFbKHrc/AzCq2BM89t8fjpFkWZV1yfPbVFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751564213; c=relaxed/simple;
	bh=gC5oxC05JYMnHdkqc1iDIhgZs86EWHCHEt5NMMKSsfY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aqtTnFnmKPo5C+UGZAr68ntJ6TdgtPKiLzTALax5eFBiHH1HnBVI+2mTFfpmbUPvb4T2SgE7hOzoBIHQTU0WIh0erjXy64DELHOa9Mu6cO6boYKpRMTxQIkF21wjErmW6cHRTpIremRXJ5NiWBrvdqoP53zexEKozz/M0hxNGcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dJ2kN24a; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dJ2kN24a"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3138b2f0249so210381a91.2
        for <patches@lists.linux.dev>; Thu, 03 Jul 2025 10:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751564211; x=1752169011; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Kfdgrwoaedf860rN7B8LGcaFfwnl4UwNfcpp+jVQ3QU=;
        b=dJ2kN24aLYn7z8TcTt3XWoOWlIXIqKYdeOOcQayOEq9+ocJLsNjUlbyn3P8qFSn6MQ
         RM7w7y0+cDiNuJH894hLszxJfOmNaujqmiSs3nWg+6pPPuFL/k6TQ2FUlPyDPK1MVO0b
         FeZwx7HCUF77hpHTfzfXrx/jZc5flbzpAjxbsIcBsTWLFdT41JVSXwAtB+g8TJ0eM7+7
         BgETNLul7iVGlaLRjhcjJJXgzCrWtQPv9hJv0ykS8SSejhaInDVJHSUYkv5KtCuyrnCm
         b0MZSM0E6rgELeZzprprxUuOrFYSo/x9BlD7JJBkPeePSH+0MOoTDkaCYj1YzPjvRzeO
         YXrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751564211; x=1752169011;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kfdgrwoaedf860rN7B8LGcaFfwnl4UwNfcpp+jVQ3QU=;
        b=rCZxMiogTFM+V92cGAKpipgLodaRP3YtAkFCTu3UZI8NJfTjW9qB0Iw7e8eGAvxkWp
         PrvJY0o0m3ocAFcGsclI/6QNUFTRpXiEGBsoPOw4y2gpdKNAexYCvOE4ziU0LGv+5DSK
         25BcjNbLUGgUpsWWKvEkXahFkTkIwFQGQupoaExKNEkiowPblnDLYWBo7pnrNINhV5tA
         82ivylkCgcQ3ZQ3QXRIuD2o/vE0Is3uXrcdkp92NE8tHz5qqmpS3NEB04kkf4yMnuYq9
         7jz8eXcU/qrv1s56eBP+O3Q4WQ3x2HHef/bOeU3YzlvZz+DCw65gPGA3QL7mJIRqec8P
         ou+Q==
X-Gm-Message-State: AOJu0Yw+ubGRlbhqQ7bBHROA2mJGE5lmp4uVvX+yE94abZn1q5+D/T7p
	i2DR3JWygpk5AJwJrBMdVpfEnKeWpgxI0/bQNkaBwFB0lfo5kblIop15
X-Gm-Gg: ASbGncvqQ8bj4X6L71dgtX2XIpAYikPaOJuFfzvRBFumsJ6INN1saz2Zp/xX01bW3Us
	1bsFjlbbJpFqA5HhAL1Tnqg1/nGw+Am8ibb97HURE8T6858/ZbkNkCNVivSnDJ+vy9WT1dR2m8k
	TQBhoL5hPhqgPuAunNPzugy8ht0Xs+CdbmWLsJIp3vbKdPhDWMI6s1GqooHLVpe2bLR6lOeT7qJ
	4CRlCqVc0hsLTOUCdmohRuEN8z5UvjYlMTGqti4LgvvqxsUVRgclKf5RRtjnEHWKIGWOS54khHm
	DsA4K9BhScewIbDEmlZJEdz5RlokXRiB6mB6f7DO2KQzQyLnTrl31jZNA1DmBieSlRXb8SvQaUV
	Y7xUtnWr1XLWIZA==
X-Google-Smtp-Source: AGHT+IHwGgt7Bg+h9xyatF0LD1ghP4SHeSyGYJPL0pxhSBY1346SnGty5LqaLn9PN7gN4mJ5k+YUAw==
X-Received: by 2002:a17:90b:2541:b0:30a:4874:5397 with SMTP id 98e67ed59e1d1-31a9deae2fcmr5197371a91.9.1751564211338;
        Thu, 03 Jul 2025 10:36:51 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31a9cc4c7c3sm3036573a91.9.2025.07.03.10.36.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 10:36:50 -0700 (PDT)
Message-ID: <0d727070-5e23-4f28-a45b-70e7e869e037@gmail.com>
Date: Thu, 3 Jul 2025 10:36:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/132] 6.1.143-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250703143939.370927276@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/25 07:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.143 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.143-rc1.gz
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
