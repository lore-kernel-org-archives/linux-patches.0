Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936E53EDAD7
	for <patches@lists.linux.dev>; Wed, 21 Jan 2026 23:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769039855; cv=none; b=ITNkHrNmLqJjzQklraAV38jwnxFkVTo8D+FLuropZiQQbZCmMyoXN9pCRwqzdybmcrPJFRnsBPIbuW7FumrUHGzLIikiUvw0MSyzt2+g4Xk/bM7365yLMxQksivJA6KvuZWzRU/egyE0IhInGqbYUgpXsJ2hHXeoba2YSiRpc4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769039855; c=relaxed/simple;
	bh=71JdS4nMo/FS58NU+6GP5reojeLKtDF+/Zpu5qSEMUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uLmgbrZnkRL4bkHW+2kppUqSQ8jjvwTlqqwydw5G/RR81rJfKKP7pSuobFMx3jIvTIJZ/HOJLp7PHxH+z+KpWgoRe773j8N9a7fmY1p3HX1aJGDcwPvmqR+A5GpuhUnjA4mDHYGKBOBk2W4s43sZ09M/xisaCZdYwFXplBFvg3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TFXCHWW2; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TFXCHWW2"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2b6fd5bec41so751466eec.1
        for <patches@lists.linux.dev>; Wed, 21 Jan 2026 15:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769039852; x=1769644652; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KANMVHhWuIaqormxj4ZjkLPh9PtQL+9rIhglDxqvv1o=;
        b=TFXCHWW21ftGUC6CxgIxBbseL3nmOA+ZSTF1NrSX1BcVSDeKphIr53jkwxHr+PkEHS
         JVs1kjd1VGASodXTpTMnu1ktLDNG4q4l2lyzosx2sovBTCBqfQVAvZyXmV/iWSwsHuo6
         PbRsyVXlgpu4EvothfAbBwAuey8IDD810kFkrzBI4WTYOSSSU5Ie3gLmYsuZz0Nysd1P
         0YUBxErNNV1nZF2znY2h1rxZ5RDwA+v/0+d8ozt3mg7+MOli/z7DMQ7xKmqHz+/uCJVs
         bSC/1KmEQmln9qp5KDOS1GCJ4jfoAWYxU7YS2Fnmn8DzZJhzfvKhGbcvel8xIGhMNFXz
         P04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769039852; x=1769644652;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KANMVHhWuIaqormxj4ZjkLPh9PtQL+9rIhglDxqvv1o=;
        b=SAEFuDh9LLOzuSjBGhaVt26omjVDEzavRmmurw5nEHOP2dPXEhgqWeXoxmkTyEEAYh
         cD9h7LmhJlsg3bBo0KmqFTDOsltZrosXtYmigTVMw45i4O490S8kPXGJouTMtneyqkKa
         qCZx9RsRBPU2fVrau+UQ5g80AROV1oqwZT3fO70IW95MPEYPPs2JgKYua5iieOoWztmX
         k7zzr8mDpNdUYFF4BZbOXlXyqhtKabcd5BQLMysj5wIatn4TqasrERPz4p/OEokhU0mX
         IqPVEcbJ35VYqQeFPan85MCzY0CPXbVVrHpMxnvscZTqRmNdbU8sEPC12m6SPWwo1PFx
         DX0Q==
X-Gm-Message-State: AOJu0Yy+HtZjzSLPN6cs/+EmbcO4tphbc0jzVKvaiCpnUpVDkQpyPOKk
	ZFMpPN/TImrZSGfEVmhOynLaGWNiiF37znqhXRJ9oD0BmQXpMu34oRVq
X-Gm-Gg: AZuq6aJCGGoZJtTpcaCFLq3FYXD1RRbJElJQmotgQfVTFO4L1J12VN/gXG3m0qgjj+D
	FRXURduedul4hJI8FmZblhbN/Bs6e5Q4qD7TAO7HwlyimfcOiJBcoWjNa3gxOKmguLRGpYIMOUT
	spP+Zr+SWUptqBBRNVjZblxXLfrhgifjAJo2w3WwrYnmy51BcOxLIBWwVPwzlW/omBiL9fCe3Ph
	zDlQPV65Nb58epNa5m+FDeYmScC2RB+9vxaj9WwUuKso/cdPHYXTkfeDvGD0UffJsymdKEf/vRO
	HU6j2BWcLrMKDyK+CQE4hdMOPAdziXztBW3MoQoCnPvtU9igCb1NrvBLJrZhOWoW2OFRXJyUSRj
	33jzolIymP+98fir9V3liHWEeLXhMAWhRQbjEPhiKtCv6if4Bx2WJrSWQt+jH8FggQo4OI9uOcF
	CDmTFuPH+0HatAls4tHCFyCfEHZKNVsTnTREv1Zg==
X-Received: by 2002:a05:7300:e7a3:b0:2ae:5ffa:8daa with SMTP id 5a478bee46e88-2b6b3f13a00mr14244651eec.5.1769039852012;
        Wed, 21 Jan 2026 15:57:32 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b3502c91sm23030014eec.9.2026.01.21.15.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 15:57:31 -0800 (PST)
Message-ID: <0d06aabe-94ac-431d-a121-a7b935037885@gmail.com>
Date: Wed, 21 Jan 2026 15:57:29 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/198] 6.18.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260121181418.537774329@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/26 10:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.7 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Jan 2026 18:13:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
