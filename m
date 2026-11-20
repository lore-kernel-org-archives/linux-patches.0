Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795166449;
	b=GWoXazn3vR3scOhqSXaAr8Ay48PiHTLaz4E2PUYWeRH4GwlIkijx9A+FZcQdjN8w2M3K
	 plu8Wm1wA2SnSUvFZF3Q14wtAp6256Z3fSrdeR6LeHME7RHOMMGqa+KeGRqSgTiKmtZUs
	 FJAgVzL+6zMsBdynDbmSCluTq3p9VGr2FUIpsDfoAlZp4HpP5HOQRORZRE9FkMrSNQxPi
	 Yc/Ouy7lTr5U+zfr87PKMe75YJZ42M/vZFMaQvk3BB0oqn8cV7YuZ9wBIWE7NI1LQe2G6
	 JFhjp6LOaCMsY7a/w2jMEpYxOLqRN5/yixw6RFvzpkxoadrJiRl2DgTfvvrwoV+6B9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795166449;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=czHZiY+9BKHvkt45mR1YoRXSRAiRq1bqN0SePSnojIE=;
	b=Kp4IZYMNuPTpKBGXMPNl7dxnAMSZm2OsFSQcECQZBDeuWjCteb+OktzbAYc3KzdnKF9X
	 yT/FTNNxGDbLaLsHC0jmEs3gPwiQKMFovqWGeDmrWjHs0ubxFTDrw6YtDFCsUFM512agX
	 qnz5jazaAXnBw2y+UFJ6Hq5QjIBm6IWN3wO0dk86XDPTtUBIBXggWeqSaM3QXMGilBDq8
	 HPC2ieR4ymd0T3xE9EzfDwJIrrwwEQRbTSlCw5PGwu556rn9b5qiOj3pUbcdscG2FZl5t
	 fBHd/LdLHk3SXct6QpsUVkPAsv3GAO5WAfm3g8t5SVvU7O4TZDRaBuB4rFwq2eIdvXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BSoiR928;
	arc=none smtp.remote-ip=209.85.214.177
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FD560A2606
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 09:20:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3FD560A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BSoiR928
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2f0414c1062so3724425ad.2
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 01:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795166448; x=1795771248; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=czHZiY+9BKHvkt45mR1YoRXSRAiRq1bqN0SePSnojIE=;
        b=BSoiR928FYyJl1eTfruFy3Vt2zhlySkFzQJWiT7Z6BftUGSKSG/SCGzGsBJIl9qheO
         wRncDf2J0qMI3WcmXPrM71GIBLxnoPtT7u12tyuMOyBRwSDkFbbUWjvtVAEo+6O0Bvfz
         IRFFcIW06DweSRPeIsPorZBP5a+rhdQDJYufNzzufG6P/3o6Old3HWdc6ArX8m2g5CYQ
         niwZ8KM9G5yUcxMyitDVLV/IbY3NWB/8PhKNd7tLz8XKgzEWRHiQ9h8T6i8ceFTyy+Db
         Bf6yvvs3Ikj+QYlQaTemp5dBYwqu/bQ8f1koJOPsksHCWIlo/ebF1nw+F+w3lciZLLPl
         toqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795166448; x=1795771248;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=czHZiY+9BKHvkt45mR1YoRXSRAiRq1bqN0SePSnojIE=;
        b=vQk5k0wm2gLoa+J2TAjYXnB//OvxKnuSOMSTjlsCWxqsvErptgqnJIadiZmRQkQCz7
         ML5lezsXCsJS4Em94TCpds+goReKPgJeJVpiuOkffw5PfSe7KQXWvUDJVXAV+ltcHIb2
         z2wGWOqQpSE+Xt/W0USYmMR8Us7JzgkBwiJFAXPATAy6ioEFlgKe4wNQAVc2BtAZhhU9
         QVS8ewdakw+5oGaMFxASBXCASqhYpLyqSWc/25NRuxg4xqavpUCTbff3WFMoYU8/9QAd
         nFK2QpX9+ptO15dtg5gOHXZDLP7SDOapkwYLuMrRlsHIA3G9J/fRvJ0gHs1q/PnY2vCV
         +Tfw==
X-Gm-Message-State: APuU4Z85ztdqAqJoioMWMlWTCevi1pZ1LHgt554lrST+oJmzUKab84y1
	fiLvuni+FQCVBYHiDAKtsIYSx9JNyqVnq1R6Fk5MZNMdDszmHN0ekgwh
X-Gm-Gg: AZFdTZfFdq6m3BG3N1Q5wPzDXKyD8ogLwvw3lFBuTCNSSDtygioKv2akerruAtRfpT1
	bacIJZI6VC4bjUGOClvLNT269uumwgGayqPzBn/nLQEC+LXBEURXq0o2avB90FhLqJddJyuSGuX
	NXkxMboR8XcH+7PnUcXwX8k+RGDyKMHW5punshKVxaSeQ2p/4+zRnZ+bNar8aMoGl5w1/6+7aHj
	KmEfL+yKHt6XTkjbxjLD4ypD3/JUKteIiXI8xgMPWsL+yj5zUdXZYDbRQuovXkvgcDCLDwFJxpa
	//ybGQ56o1XH/u2Vyr8yTiTMNxZidmyJb9TNEWz2p3mV+NQdUOLOU2VJuj3wFeUZ5MM3Ciuzi7X
	xDtwrFzGjcPA2Z9s+PwhRapEtXWoPck3Zj7P9vCj/TBD7aPBHznG68pO0pDapMaGL+kUeldXqev
	guVoqFtnMy4FphblP23hOR7KsVcC8P5AH7NHaAdFCXq62nGcKFTO9DToLL4Cuc+eVjp18olFIjl
	Emou1ukme83iH8Vf5E+MrD+FcOqYPOWn/KpOhhDqWMXSxAJts5wyFT/my/GDCunesygUn2bL1ze
	SN7Nf/MbAvMlpCIDCfYXjEtrn1s9QmYAGn57hYSpaxhTO+SpAA==
X-Received: by 2002:a17:902:d54f:b0:2ed:21fb:e762 with SMTP id d9443c01a7336-2f03f118afdmr24187105ad.12.1795166448218;
        Fri, 20 Nov 2026 01:20:48 -0800 (PST)
Received: from [10.222.1.82] ([59.20.222.202])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0dbe86sm11689635ad.32.2026.11.20.01.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 01:20:47 -0800 (PST)
Message-ID: <6c7d8900-2b68-4431-8599-527fabfef882@gmail.com>
Date: Fri, 20 Nov 2026 18:20:43 +0900
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0000/2144] 6.18.65-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261120055114.182757740@linuxfoundation.org>
Content-Language: en-US
From: Joungmin Lee <leejm516@gmail.com>
In-Reply-To: <20261120055114.182757740@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/26 2:58 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.65-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Hi, Greg:

6.18.65-rc2 successfully built and booted in my system without any
notable regressions.

Distribution: Gentoo Linux
Architecture: x86_64 (ASUS Zenbook UM3504DA)
CPU: AMD Ryzen 7 7735U
iGPU: AMD Radeon 680M

[    0.000000] Linux version 6.18.65-rc2-myllvm-g7e0638af5322
(user1@gentoo-zenbook) (clang version 23.1.6, LLD 23.1.6) #2 SMP
PREEMPT_DYNAMIC Fri Nov 20 18:08:46 KST 2026

Tested-by: Joungmin Lee <leejm516@gmail.com>

Best,
Joungmin

