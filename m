Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A503C3BE9
	for <patches@lists.linux.dev>; Tue, 10 Mar 2026 19:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773169779; cv=none; b=eSpJCWRFjo4Lc+qnnqUpIzgPmoEovo8A42Y9o626FWnx1xbGSVYE2Ujpo7PUR+w0XM4bP2lyLFCXY9YWW82dSL1/HzNYiLYTrdx/KrRoccL4MExGJRKIlHUDS06zIv5S7pUSXiveiLx/mNjh/iu2VK4iaeLu1iMDJC2JaHIQIbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773169779; c=relaxed/simple;
	bh=d749lpuLw4bRFZtFGAI8iFScaeeBX4y/IVQTaRR9eoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qr8gCO3zl56jpdevcoSIyqjp/uRWlS+pysq4Kgjh62zhtrMrXO268zJE+zV9TKTqDuf3lhB+YNq+FO7oRtRmm/d0QiGRgz4iJe3U1prK56OsxtFOyolhytnbKgsPiby+8wGutuhq8jHHMA4pkmMGof3/LrjdldMMvYkIv3PqyOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jOgdWmmO; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jOgdWmmO"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50912a097b0so15278051cf.1
        for <patches@lists.linux.dev>; Tue, 10 Mar 2026 12:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773169777; x=1773774577; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NAykrKz2PIIorfI6OwgxhSO9QOnVj+7F9gFJJXy6oVw=;
        b=jOgdWmmO8IGvO1+5KgoHGG/IISUwrTIcALB/fbeS1j3gtfcrN1GxVcinz1AmSzeiXt
         MB6MmeG8VKZpIbrOgrPLJZ5pSjYYAxHB9OpPgZ76D8EVXRrB7PU9wvmDr9jGsJev2lv6
         FL4RSRwk5hlv98oI9Pe60wUTP96rggPGDm35862hMFzabpqxFnAd7G5lo4MVKwynBNLY
         w00yrKcEjQ1tM0qHVma88Rsnth4KhyVZcK88k4F7kgmoUkJMc9exPlx3oZmiottB7agC
         pukrl6Huk4qnFHqh0Jx2+26+axuIjECc2fQpChTIRti+uYh1yFSQQxFVpr/fuKuF3NDG
         b/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773169777; x=1773774577;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NAykrKz2PIIorfI6OwgxhSO9QOnVj+7F9gFJJXy6oVw=;
        b=EZmGVyE5f40BRbIWUwkU2d0EMVxH447txVHo50lOmrN8xhuJtasqQCZFtnLOUBwOmg
         OoAynC+EbeDMaz8V7Ytk7t6N7TRl3tA7udqODvWulXcgpkniAFGXS0D3P4223Fu2KqQh
         JCuUWYkOf1FbbSzU/ee/ksqKr4cAHCflRIf0f2SUrw+btKdN5N8dI9Vzowm3l0SatI58
         eyeoQF2YHrh6m2kty+OS9N/Gyuulb8lOq5qV/tdBkxLUirD5IMC7WJz7O98MlUjVnJQa
         omMSRQJce+tv+zeqgQSAcJot+5yPbw3RYHNarfTrB5oPVHNtpDtYI7AZvRqjmwA42272
         Hg1g==
X-Forwarded-Encrypted: i=1; AJvYcCV9Z3cPirfZp+TUsZoJ/FrNUJv+0lEsnjecb2riBXYoeNxguMGkU8zkARzLnOo40+qNINZ7S5TY@lists.linux.dev
X-Gm-Message-State: AOJu0Yya8PEbXeQK/t7ARpbJnJSNKvD/FBTizouyJUVu0mC9H9ajM6N7
	eVdFlpkmyPy2B7LvGVBt/b9FAT0sDe2vX4Hc0Ja3WiJNFkK1Ogq3lGAd
X-Gm-Gg: ATEYQzxMC/NYtBRcVAiGz/BiKr6HcMWvLIs0KBzIm/mHclvHJztj6WcCBODuQSgyWSe
	TwIdZ+RQSEV9ZptKCnpvGti4fRxeiRHCeIwFy8jdPTLkTSC991Ej3Ybiz7kFLw8ttbD45TumH+d
	+Z0QXFQZTsi+PI2khFlvoZ4YC3PgwqLCzLUGfz9sUqMdQ5msKNVQHoV6IYdv9M1zo4lRPAY7k8F
	eHlcmFc06yQWyyGd71QTBQdv0WZB5QX3IDOccaBfgdvA8Z1apQoSsKA5FOihzG1by+BoyZkts80
	zycOtExR1Pu3OVkVhC/tY9Xkrd+QoIxEtn2/zyuOfsu/5q3kTVzzrRHmZrqgd7VH9xLm36sWyFO
	YWflELZVqoGv2rueX5LwLUwiY5pq/on0wv68rzRWaj6N7Hi5ZkpCTK/BFAPhMrKOWJQz8CyDiNU
	lqLF8p4JOqF7eb4ts4l7ahUNndYISpn8ToWrxcQvd+7nA8hiQr7w==
X-Received: by 2002:ac8:5fc3:0:b0:509:3025:ff4f with SMTP id d75a77b69052e-5093026145fmr28324041cf.16.1773169776820;
        Tue, 10 Mar 2026 12:09:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5093862bbc9sm1602901cf.5.2026.03.10.12.09.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 12:09:36 -0700 (PDT)
Message-ID: <75302bf4-3f06-4e9a-8d05-1706d60f44c6@gmail.com>
Date: Tue, 10 Mar 2026 12:09:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/311] 6.19.7-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <cover.1773140654.git.sashal@kernel.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/26 04:05, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.19.7 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Mar 12 11:04:16 AM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/rawdiff/?id=linux-6.19.y&id2=v6.19.6
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 
> -------------
perf fails to build the pmu-events for all of the freescale SoCs, I am 
not sure yet whether this is a build environment issue or a genuine perf 
build system failure:

cp: cannot stat 
'pmu-events/arch/arm64/freescale/imx8mm/sys/metrics.json': No such file 
or directory
   CC 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/util/maps.o
cp: cannot stat 'pmu-events/arch/arm64/freescale/imx8mm/sys/ddrc.json': 
No such file or directory
cp: cannot stat 
'pmu-events/arch/arm64/freescale/imx94/sys/metrics.json': No such file 
or directory
cp: cannot stat 'pmu-events/arch/arm64/freescale/imx94/sys/ddrc.json': 
No such file or directory
   CC 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/util/pstack.o
   GEN 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/pmu-events/arch/arm64/freescale/imx91/sys/metrics.json
   CC 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/util/session.o
make[5]: *** [pmu-events/Build:44: 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/pmu-events/arch/arm64/freescale/imx8mm/sys/metrics.json] 
Error 1
make[5]: *** Waiting for unfinished jobs....
   GEN 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/pmu-events/arch/arm64/freescale/imx91/sys/ddrc.json
make[5]: *** [pmu-events/Build:44: 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/pmu-events/arch/arm64/freescale/imx8mm/sys/ddrc.json] 
Error 1
make[5]: *** [pmu-events/Build:44: 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/pmu-events/arch/arm64/freescale/imx94/sys/metrics.json] 
Error 1
make[5]: *** [pmu-events/Build:44: 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/pmu-events/arch/arm64/freescale/imx94/sys/ddrc.json] 
Error 1

...

cp: cannot stat 
'pmu-events/arch/arm64/freescale/imx8mm/sys/metrics.json': No such file 
or directory
make[5]: *** [pmu-events/Build:44: 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/pmu-events/arch/arm64/freescale/imx8mm/sys/metrics.json] 
Error 1
make[4]: *** [Makefile.perf:770: 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/pmu-events/pmu-events-in.o] 
Error 2
make[4]: *** Waiting for unfinished jobs....

-- 
Florian
