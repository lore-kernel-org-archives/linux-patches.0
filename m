Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9E1541E64
	for <patches@lists.linux.dev>; Tue, 13 Oct 2026 19:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791920845; cv=none; b=OPNxuIqInTFFjSS6HzzQQqfwXBri57sRG5lV4HxiLbV4xZNpP6nTQK8nIfRWAv7WY+0hrleX6Q/bw9ig0LWxSLA/AJRO+RZo1HM6OUgvgrTLGYTSFvNhphgC6jqfyIlxR5gSFLspXJ3y4VSMNH7aovoUtlCUT5XmM0K9L1dw6cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791920845; c=relaxed/simple;
	bh=xkNdboA04KFzUV3kNY2lng94XpmmiyHm8J7T5ogGRxc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Be7ZL/rJHbu+PfM0gLCZh3cLDW3VQhSuz2ji5nBq8Sl4oykxlIbQqtBlSW/OA+Id0xa270/3G3fB5Ibf+1d4jQcru9UBirl8el0FSzTAKnsbc5xHAauNMQx7JU07N7lKPvTYmRHMmIRQzhNIHhj65s90NHd1UMOzET+6Lxk8p/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZMxIHgby; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZMxIHgby"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93e6f83f0bbso310560985a.2
        for <patches@lists.linux.dev>; Tue, 13 Oct 2026 12:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791920842; x=1792525642; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NTjEEqSqe2isomaMSLDVTGf6TgdKb/jqa049850vzw8=;
        b=ZMxIHgbyhSptl1CigVjBej7zzxV5dY2Cw9lA07kQ31TQ4R14vfD+27c4k5XTFmDtbu
         Gjwq96YUhBKzE98mF0sRsi67ZbDDkgNOvA07ngYc+iffITIHB/Qb++2tLeJkIoEkOcFL
         3NC6+Za2QUGyT5H9pPr/AsrrETHeigAloSMgOquq1uZrtkgKOQJIQIIHF9RVFx9OSDOd
         SKnNasxk7csoBPcsBhKRtO+OEx17zU5oLPuxbb8Yg4pDHwbrYMx1mn80U1HL7WedN8Xf
         WfueKtcT1JTUuvVwEB+VqChagsScxrIKOp+jiDVha1terz5jzuIh+o0J0IGeUuFpoAZl
         MTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791920842; x=1792525642;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NTjEEqSqe2isomaMSLDVTGf6TgdKb/jqa049850vzw8=;
        b=U4gl7Bl3SduWF1AKddcbu4+Cgr0m8f4NHm2gCE3iccyKP8byC6Pf91wTyW49oD5wBy
         KK0zQdqQDobsr664sZ/jrLdA8bpi+619Wq1VMlou/CT7X0eJQg3hO/LOUXNpHdtmKylN
         3V15oqa5k90XukdXmj6JklvK+JHl5pNhyev7dPGM2FKI2zC0GQ89uBNtgUU1FQxBlvGN
         xAZl1UhTTIBMh+pI4vRdGyJx3mLkgn+VYUC+1Od628uLRcVRPKc06yAU7+3JZCH0rbd1
         mT++3HxG0IxAj8ZRos4X2maJS7eICQlr8dumle5yCqmpQNmXGRnBBDjxPTCP3n8xeox3
         kQ3Q==
X-Gm-Message-State: AFq9FYKkiv3vYzn0dQufWiV/GlmsnAY1XOFMDao+mPOZRCBSFmsQa+J/
	l9pV0qSrb1lPENsv0dwlFHwX0BKqWT0UiQK/6HmvdPRDKZxRX/e5I90F
X-Gm-Gg: AYBFou0ejVIAZow1DHZAuYiFeR+stBuw6OorB9zCyorj/GjROebuDCTa9jCkY6AxL5x
	vmuRqCzcZBjg/DZGP8wt/wlovNW94yMq47bl1gKqYor4SyRJDacWOtwUlejW4WamBH3XmHLfmuS
	Ib3QhRhBlVQm6890v5E2kK3WmOUndHEBsdLPbtoCbwr7EXlIAzR77igP+CFM3GJr22GbNUTva/2
	NtRC2cldFSXp8FbTSKjM5buKxboYHpGqc+RIcF8wxhO5q3GmyznAJorI+xcsH7sl4a1uNe5YDIX
	p1v2XQfDAuKPsMNZ0/Y3l9Fzk9upKVrQTm48fzssP8/YZo5Ij2egRZzssyxJQKv/LyhDr4f9Bkw
	9uxtp6CIqasBvKGTQZ3ZHdzMjK9LVs5Y/uPMZtOY2NqZNNiQcf1o1f0qoJxz1R6qWvhN2JaISXb
	wXV8ZFPbTcy2N/XPIavuvQ1HNjPdPmTAOTCe1n5Fx+th5Q2c1WTfsoXCwtnjuO5E4ZY9fT8MNzJ
	GEXsTIDq6qfV0bChQPavcND
X-Received: by 2002:a05:620a:40d5:b0:93a:f9:614a with SMTP id af79cd13be357-93ebd21ffc4mr2195060185a.34.1791920842369;
        Tue, 13 Oct 2026 12:47:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef5090050sm312910585a.40.2026.10.13.12.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 12:47:21 -0700 (PDT)
Message-ID: <0873cca2-2f48-42bf-9297-e543981161b3@gmail.com>
Date: Tue, 13 Oct 2026 12:47:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/281] 7.2.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261013112855.045212108@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/26 04:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.11 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Oct 2026 11:28:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
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
