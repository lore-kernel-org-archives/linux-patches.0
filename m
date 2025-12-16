Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C8F33468C
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 21:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765920894; cv=none; b=Qyx2dHQpGeyXIxvXHdMgqHZRucFjaSiIvHQG5flf/7gXc6L6wwuNyKfx9nKvEM7pJMvbxmBVwvWIDfYebxC9WII+Xo6kWGGTzz6arDe7aNZaOuET7dlaK05n18X1OOaWmg5MF2JuhfnIXCerJMF1Y18VrPZxZ5X81vCIYykwbpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765920894; c=relaxed/simple;
	bh=q7E9hkX0pCOvDlEdHDkmL32xzrZFQmSe0NB8Q2GY8i4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mTq7AnSjRZaP+HdDISzZAYrsnDGQCXM46jl2RLdco6l+RrNi+kYCd7DOp82N/kkRCZ5nE82JC9BWnBoEVXyH3wrqG9I0TNttHZ2VfoFTmQVyHIIqU2dYXEQPuAknlz/fan7rUoPVd3WZPG0gWPPlLiCCRNSk1cvWEytK5hVSXCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SHhldGrB; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SHhldGrB"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8888a16d243so41709796d6.1
        for <patches@lists.linux.dev>; Tue, 16 Dec 2025 13:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765920881; x=1766525681; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y1iIRZq+upiNqQgm+paIoFiCtt257xmNJ+NMW/SquYE=;
        b=SHhldGrB+Qv2ILWoWyMaBqYE0ptwSG9kHmWhXp2653edwA2XvANbFTgUgyp+VgLAIh
         iZpK/PB/HN3BvKzL35DpLdce80Qd+e+dEvWrGY3UvpwWK9nD2Thiu+HBrh0iUvxaMvwq
         6RvbqEe2TzJeeKLQW0qri7bfQ0UCIOAl3fexibvB1AvVo35I4c1k17h6B6dAp5J4rURz
         3akv4UdF48OAqXlvS+KEJA6DKiovkjFBGj5H1ogDRtQeXo02HT1DmB4sPVWfYJbbS/Nv
         +kNgZ8ZDcG/1ht3xKT4i13QctA4cih8H4zdhP7uspclBkXZY/J9t8EHTarlay2HrMIG2
         Mbew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765920881; x=1766525681;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y1iIRZq+upiNqQgm+paIoFiCtt257xmNJ+NMW/SquYE=;
        b=I48p0Hn6ot7z3wsQm8a4Fp1rTkbye3n6TYx5/SobcDeYTO6l32YM75E7xAcdr/mrp1
         l3ptVPkYnGEJmEosua60fv0WUEtVGEMeGwiMx+xA/FWA6ig9jLCGV8lTw0DxfNdlprCg
         MwQiM/YTO7/Ds6gXwtjPjc/P/v8aYwIixGgU8bX6OO8gaTgISZ0XQdrstcUI98Qq2h/h
         6mlpf5OU8R07EySS9JPPWH4f0rAE4Lmr0V/vDkNxnSqbQnYzkEhK86YSxlylRaoNYF7Z
         pK5oldiOacRzfGBPd36MMWantBwqPj4E8I0ysfXSWB4JRigGyAFXVebYOkWlq3l5Jrxr
         BopA==
X-Gm-Message-State: AOJu0YwfKWRZ9KHtm/nhG0FrOk+m4XZZVLY3IX3Mo1e2v7Yd+Hx9kMlz
	1emsblCpb/LKssZn+cB7okWtDnjYCkxx6ulN9dJZbUTUK1njN64bPTEx
X-Gm-Gg: AY/fxX7ulO2sXeA+S3CbdzqrNfpOMM1OizeqtW5JkvHEAL65hL9/BDAfxluUVVtUfUq
	xmQiVLZoJF5h83k6nO5T8XFFB0c4abhpQmcyJc0yEv6o0KhO7dR+i1pPZPMDSgyDYx8tcJmnxhl
	sejs449QlNSY5bYZJlxtWXRDucErKd1ZVr8/d2m0iQG1tW4roZ/kHIWWDNsXEQHPKuopga+T9zU
	Otabz2mjZzFfTBXvKKLzZkx760ImDHCbTSrv3lv1AbrD0GtRHqJM8czfCORcO10+dGO7pi56qx4
	gNawvF7VNRT2ju3TLQb+D31J3uOPBbNepVSxfONAKKFH8pcA9axLTdFIZSAP/sJQwVzZbCGxJeL
	5DVsRkF9sqDYgZomzr574Rkut8BxfFozXTC1C+R7Eom3ZN5f167MGP8VPjaDcS2r94kx/usa+hx
	jolIyDFZZBnl4yJHPp5okVMMouIvs+gYlcaxz3Zw==
X-Google-Smtp-Source: AGHT+IEnVctkK/5qXb4LERvLEpNDkc1Az/Qnh/Iupgq+brP0HMKZ8ypeugbYEC1cjCmcZG9Puwm+2w==
X-Received: by 2002:a05:6214:1311:b0:7e9:2697:dc63 with SMTP id 6a1803df08f44-8887e15ab17mr251027136d6.48.1765920881257;
        Tue, 16 Dec 2025 13:34:41 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88993b597f7sm84031066d6.14.2025.12.16.13.34.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Dec 2025 13:34:40 -0800 (PST)
Message-ID: <87182669-6ae3-491d-8d65-40d8baf02683@gmail.com>
Date: Tue, 16 Dec 2025 13:34:37 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/354] 6.12.63-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251216111320.896758933@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/16/25 03:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.63 release.
> There are 354 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.63-rc1.gz
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
