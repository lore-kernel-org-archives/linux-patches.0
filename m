Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CB918DF9D
	for <patches@lists.linux.dev>; Tue, 30 Jul 2024 22:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722379250; cv=none; b=Q1NIZYOvessYBa+R0en7KuvUY+Cb0XUYWZ/k7Gi45vfcyy3OpzJvEy24xKydERJmsoqZFVZe0bwhY6BmBouyjfZcIwz+LALfaSKKXmYWEQar1c8Q0yKqhl6ILKJg+DVctPPELf8oRRBgbJrKKhzKyVH47SNmWLKaKl41jWaV8Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722379250; c=relaxed/simple;
	bh=n1oety/HXkXrrdiFjXUbok72gHTpJBT9M6nVGr3yB0U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sIvJ72ZHuFhiPn3a3JRddKix6ZFrjlV6mr+zcf4ELgz4XvDbNlIM6/okY2EIaelmcodQrgd9wHrKldxeNMKgKXHPFod65zteEO/H1I6tlW8rxRLhi/8eVC9ygeS9GRRqv9Y3XGRLytAWO3R7w8m1xwEr1AMrHC+Loct1fKuhKVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f3eIlfMV; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f3eIlfMV"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6b79b93a4c9so3172746d6.1
        for <patches@lists.linux.dev>; Tue, 30 Jul 2024 15:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722379247; x=1722984047; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lh9GVDD6OoCtr0k7pBMipRKv14eFzV2Gv2WBzW2ndOs=;
        b=f3eIlfMVjK3X4WVJ8PpUGo5KcDcHTHsRHLcwPiEPiFf0hpjfhZzPOuUx2bTDji0R3L
         nKf1gW5iGFzvmYgWH8tNRbl29OFoPqLJv0EcfHYaGwb+TtOmLXpvgXThfm3+D6kknW0P
         /zEpAMHyHlqL3KbfQ5jtEZ1fDdbkQdPOk+0NF58LM2eL2Rs+ZOScb7pquIj+dTaV8Gzc
         i1C8ClQ/w8MDRQsShBSXUlT4pA8DFdaP+J1cZFZoCR8Skqv0HCvWUTq50+NIhQiHDSwj
         xRZJxOP17TGG4YcBRUM2gFo4/pS2SLotRiEIWFCiFGqLywsD9gO6GUmFagobPFArVleK
         Dtkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722379247; x=1722984047;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lh9GVDD6OoCtr0k7pBMipRKv14eFzV2Gv2WBzW2ndOs=;
        b=VwJafWJb3f5jEVgAj2R7uSFRioWO53u5/3cjzbHIvB8It9IDpvu95mDI6bQbjtmzsx
         b9c5S1n0ifDvAucBi4OJgnL4X3V2TWuPxCIxxD8/eGGazMbDoleCf1Zfim0hM66dtzFo
         fRCQ01sx22u/Sk7Xx8IHDXMysV3gO1Nt51hHB29l2HsLQ5fJKfq8PIRygsbKYBVY179+
         yf/cM3tvJW5IqJ/zBJr7SGj4rbjL7vPhnHJoslqtXLAJ9z2iJIfNf01yQOGvNcpQXfji
         rlojM2L3ncprUK06eXJNKdTvzjRWKgDhT6xikJ75DwzXbYB8raTNEA/w1ICmacJ5CANk
         C6uA==
X-Gm-Message-State: AOJu0YwakLZe8LDY+mMt+YLhYtme6f4+YGvr40xwTjItco4dCP1jXOoh
	lSY7sX1zcrGM7yEn9bHy19Anue3v0yvXiV0KarrBdbskxe4DyID/
X-Google-Smtp-Source: AGHT+IEz03OTW0OWshfpq6CgIxXtN2wnx4Ll1uuIScwi+8LcsE+ExMs/fDgCHXc4cOpe+gu1u/GQ+A==
X-Received: by 2002:a0c:c48f:0:b0:6b5:2de3:32b0 with SMTP id 6a1803df08f44-6bb77fb12b6mr57670756d6.7.1722379247499;
        Tue, 30 Jul 2024 15:40:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6bb3f9122c0sm68194166d6.56.2024.07.30.15.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 15:40:46 -0700 (PDT)
Message-ID: <5f22c1fe-40ac-4a08-9645-a14c348195dc@gmail.com>
Date: Tue, 30 Jul 2024 15:40:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240730151615.753688326@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 08:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.103 release.
> There are 440 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.103-rc1.gz
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

