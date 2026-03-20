Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278313DA5D3
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 17:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774029541; cv=none; b=U4Qu4tzyHe2oe7DZ1GVdLIcDfHjX+bWb07FkehKGuyXDIuRbxmidBU8hr03aIdcIekG+zlczG6YnoGR0J/URAA+Zxat4pgVVgmQvQgCSmrVYwXPZCT1hncvcAahmn4QqXx1S6rzsQtIPenOhQPYXjaE/kH2CukFwOrgUy0OalIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774029541; c=relaxed/simple;
	bh=yhiJdUN2FxU28TXhrBvA1ERxsv0Vg9I0vpZj6n+I4Dg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q1kzjyh0BQ5YjEtIFfJihG2iJt+/NEJ0o/aN5EN4GLCIcX2wOlnWipM2/KZz09HFAclIS+m/ZUhkeGFFQlhXbIeOkMv2AE0Igz7xXq6SxoDQ1bQIWWvK8gPUhgTSRppOXsOJq3NCuUl6eXbey5j9/sU6g1Tear8hMvoNl3gSUP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N/yUIqF2; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N/yUIqF2"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8cbb6d5f780so95862885a.1
        for <patches@lists.linux.dev>; Fri, 20 Mar 2026 10:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774029539; x=1774634339; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+zTfmuzfsBQZHwA56zgqETuUGa6JX1SqvHIJanpZSJI=;
        b=N/yUIqF2OxQewIcg30YsKsmLvh+zO0z/0Rk372fJL6fCj5nuQHulJapANonck/PNI8
         06e6Rnt+YqbWDAczvPKAx74Hc9rwoBkZL4DXZ4IwknQkMD90W0epyKSqhy0sqviiGUsE
         jgc8mTi5r5mKAMP23UB1Ps6H/P/UirjkLlZWkhs7foga03HPpxECxYJSzGVQdGF2yUSn
         iBHoBgRV03nJ5PHmWkIBPlWHGZDSv+m3gP50kf10A0IJMcLsXSqPF94I/+wANp06qmxz
         c4gSRrM3aKzR5L9hbsPOvhpwbSf9gpJTr6VXzjiP9EQvphNndgJtvYJSii8qrk33J5uJ
         V6lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774029539; x=1774634339;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+zTfmuzfsBQZHwA56zgqETuUGa6JX1SqvHIJanpZSJI=;
        b=knIkqCe8tJU9/LQFy+8LqPSqQfaND+GRpwQFdHKPoVuaGV0j5qJRW2lme+1yGaGcIW
         ZcqECvWZSTxh5IfQMABKfUyS3ABsxYmihJER6lX/TPduLqW/yz2jYdntQmlOeqbJXJo7
         0coyDAjhLRAxhGfipf5O2H0rC8DSIi6W1DqmC4k3N50oO7XUN/JBCDM8B+7A1RXTRz7h
         6rd1hH9UjpHnDaqP9ro5Xoe7fETSbvm0Q8LZN5nfnghWKuWkmFBdAMAYvKt3mt2f4VU1
         7ih2hT+WW7K9vdcD6X2HvKbqj8/1XF94nQIOdqdnQE5lJSOcfiG07cAAGBUbzrreMODq
         x8FA==
X-Gm-Message-State: AOJu0YxBC6U5TlwKoReJWNMKe2yIMPHfzVx+Q0APLueIy3HCXgnh/b2u
	EXBRzgxkteRxdobHqgW13E6/4u8BRT0Vx8AL17/SgZRD7C8CpJd6zb/0
X-Gm-Gg: ATEYQzyUWxLHZvzBi/JLErWjYkpqt3wFwCSW5+STZKGXt03gRMswhs9sdHgWWxhdWie
	/Wz2Hp5KZ3wU/wh4IebhiVHWtsGi03ToE60SUr5nZQ8XVLHBuLRfgtd7ZiMgczOCkZNYnFsAfdV
	AvZWp1qbGs4hlgxQx80eK+/K2fLvxww1BJzQFBqWE7s0Z+YlMUvlPMbjikUC85i62blQ1dG39Vj
	3Vm5Xi52JaPL0aM8dzncKe6BUEYYHDUpYBge/SBlq59ZeGn8M/jb8/5xXEXXE1EVsotIknqdPtg
	B8R4eA5LabX12Esskyqjm7WvaYWjoSv4s2KqtsOrrPuDUlLPISZf7gooiNXp2+X0m5deejLXZKe
	dcTrvIYhpPOQgkUJaNyBa5HR2M1zorklnHDvCv9uYWR6y/RJvfrVWsqg1u90DN/tJJYJH+SyOlr
	NrYAhfk/7rVACl9K1hi/zpBPmYxQGL8uvj+JzSGPQr4wIeHQL70Q==
X-Received: by 2002:a05:620a:a50d:b0:8cf:d1fa:7b3d with SMTP id af79cd13be357-8cfd1fa7c8amr263080485a.10.1774029538860;
        Fri, 20 Mar 2026 10:58:58 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90e776dsm244807285a.47.2026.03.20.10.58.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2026 10:58:57 -0700 (PDT)
Message-ID: <f0ece061-13a2-49c8-b4b8-ab57c70952c4@gmail.com>
Date: Fri, 20 Mar 2026 10:58:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/379] 6.19.9-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260318122547.233850204@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260318122547.233850204@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/26 05:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.9 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Mar 2026 12:24:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.9-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same issue as previously reported in 6.19.8-rc1, commit 56111d7a464 
("perf jevents: Handle deleted JSONS in out of source builds") causes 
the following build failure:

cp: cannot stat 
'pmu-events/arch/arm64/freescale/imx8mm/sys/metrics.json': No such file 
or directory
make[5]: *** [pmu-events/Build:44: 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/pmu-events/arch/arm64/freescale/imx8mm/sys/metrics.json] 
Error 1
make[5]: *** Waiting for unfinished jobs....
-- 
Florian
