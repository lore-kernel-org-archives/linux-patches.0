Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A982BFC7B
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 18:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772042421; cv=none; b=kfD/HtXp/KY1hr1vM14ZePlqck3yNoSU/4vEJeD++RxnEYO7qxDvw3OnRHMr2odc97R2P01E9h0rKYKmXWdx17D7W+F6AOeNTH7pN9lVdgJAEtUK+y5K3JOJotY71rhi7Ewb48+IZVuQn2+Wzrf/5BdUPU4gOkRxkqC2AVYEZiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772042421; c=relaxed/simple;
	bh=VFjCPQKjBUlbOeDPZ38h8xTmdlaHE8oTtOtI/o89Gwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BTyJ7R25RQkkmH5Y+qY1d5Qqsoli2vSXcELGVaHkhC9S/sxz5B8/kwvSC60nOnEyLFUBev+4o79jeeWqHRxlYLjPnhiKlMv7f9TTHX/DSvzmkxlCS9hjG9HyoEjD2gVADyc1O3tAMOE/f7t8sDwfN9mzAzxTEHUFbIrcBtkVHo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HTApS9Va; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HTApS9Va"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-896fd2c5337so59968016d6.2
        for <patches@lists.linux.dev>; Wed, 25 Feb 2026 10:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772042418; x=1772647218; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UEXbWlLuprK54ee8WDE/Pj9WkXvpxvQMOi9F11bVzpU=;
        b=HTApS9Vag1IR2+kyzFjIfx+Bsy6qi6ARs+u3SfbTOBUosy6XdKoH0q76vTjPn9cWlO
         h676HvdCBGn4CYIjHxmgqm0JVWONJ/TSspjVAgba0ej0qyJ0ddRJ8eoZxOgXVddbHSyE
         DaC/ywM5y+GeFdSjivAT3yiXvMRbBt3iwt6xiQwmIys7mPSwm3clCaI2MemzFvR0532y
         QU9c77xQ8sYIPMAPmOw8B0UwiI1Pg5CPJuaq+qPmYg6FOE7DEGhM50Jbrq/r4Nz1X8Pl
         3GDGSNf5FvQDOFCXE77oDoZAIXQiug5IFWZAqROrDAoLDpvmZBDrZk+mNPIgFQ8OzwYi
         R1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772042418; x=1772647218;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UEXbWlLuprK54ee8WDE/Pj9WkXvpxvQMOi9F11bVzpU=;
        b=Rh4qf5gi5+rMoPMnIlDgKfP3AmhdprBTDhM13rn0H//W229hfLbJudZ90Jg2wTRzue
         IuFx7zG/BW7SliWAjJHHB65sD6/iTsZgL9Cl4Qqqbn2aI8VNewAMmjzHaz88mCrNz2ps
         UpGVa06WdxRliSg2/xq1i2pNXMR9i8hCmgHQ72Nu9BxL/+pUo8GQ+K5Xe/65jX5Qj77u
         sc9W0jEmC1X5M+6dpjX0dFLCI7wck5ZT/NGpTmmryUzvMkPq/BK3USYRh95DOb6Vjuba
         rpMPx6Rng01odD2mjKflnVg4TkcbDTdah+O9hfb+p1Sq03S+sY8vveCtRIlILc6amXTt
         P8GA==
X-Gm-Message-State: AOJu0Yyk2v4oAVnRUxTe2OnKxyl94EJUVrK3Mr43Y9HGK8Gz44S07rJg
	fhodxB8ETzPZTtrERrbP6CNrk/uyMnjvj1jMdp421p5QB05Qcnxm5Et4
X-Gm-Gg: ATEYQzyGppulVmaLi5wntYoizgssvEmB1m/nHNX1009oQLwHSc5YA7rYDt/TPNf3heE
	TlChm6nwod1nVopA/SzOjGLGdbna+5uHdqBlOK1Yvv/dbq65Jd8bR1kV/Ie4Pd9wxRfqMcElJ6H
	L7/Q4SlY7ZCf+ypFnJMkdZ7mlxYr0xwcPq5LtrM7Vl2RG/gtJ3whnONEDoPIy4bByPRALQUTfu/
	m9D9nFFoJHu2rqPiv1GqA+rG7vB+dBlnwuF5WJKcv0YlpDdsWuGvhCSaNsVqlmjVYq/it0WKhfe
	QgLALwGQyzz1oO7h9XjhPBxHNDSamSXWYcJxvn5fHvvLSbBNuxPz52eKHOuarqyCFBCeOReRqZr
	7zc7P7nKcTkPhCSh2cKqRzfj+WWjfJcmbZMi23/do5+Z7qkYB/B3eId8YS71cq2HOhbYSD+OROj
	k9e8NaJImoSBeUqEoZTvdvhzTX+rZlNIi8m4e6k2gSHYhIqatogg==
X-Received: by 2002:ad4:4ea7:0:b0:894:2f04:eb14 with SMTP id 6a1803df08f44-89979d5a142mr254800456d6.45.1772042417990;
        Wed, 25 Feb 2026 10:00:17 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb8d0eba54sm1468212285a.30.2026.02.25.10.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 10:00:16 -0800 (PST)
Message-ID: <043a9c41-e891-45ca-ba07-1bf215a2288e@gmail.com>
Date: Wed, 25 Feb 2026 10:00:13 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260225155341.094945851@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260225155341.094945851@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/25/26 07:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.4 release.
> There are 781 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Feb 2026 15:52:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
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
