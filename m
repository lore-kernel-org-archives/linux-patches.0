Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A62335BAE
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 12:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757421878; cv=none; b=q0jWU97H86kDHSGmwWcE9FipxePy/RgJ4S4EpE2CF6r5Cxw2etG+pdhfaAaJsTvna46UBugSHACMHZY3F5LUc4QhyIL6Cldk0Rh5QF+1Ozvgs+MnebRwsjfb6kdZ4/z0b/RcWC+dciB5SDa6wXOg1Ll8sb36veDHoXngAiTjRXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757421878; c=relaxed/simple;
	bh=GOhkJEeymfMf6qrtgq5+BS/JhhLjKijUfD83vqgz2mM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=grDsDSOgGE6sMTKMumBy2FJWCJo3ddI1yBl8oGSMgcCb7o56/+sXpso8OIq2RBaXHF9QvvY+fwu4HwSOI8neJHcf4gMQybi04AVnccJILDDHerCCJxbORnM6uWSX3ygfOh5Roa31OU5oRsb/Voa+487ZEMmQdTyPkB3SqZQ7bPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=PrNL75tI; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="PrNL75tI"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45decc9e83dso5654885e9.0
        for <patches@lists.linux.dev>; Tue, 09 Sep 2025 05:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1757421875; x=1758026675; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UQaDHF+OqdVZFz6Y2By3JYrIbz3IYU9PimfS5JdBTVU=;
        b=PrNL75tIFkuGqRaJc91Q3PocjMo2lLGLyQeMQF/6hzsBX5Gx2PCiJc7gy1uwoRd4WJ
         B/SA8Yo0i1lLmGP1r8AN8ElPuxMJ3S+gc5XSlxEPRGM3pYlMA4THj/fj+MXHdIFu68s8
         sXda6iOYPk3yHDI/lLGAl0nA5lqtq6RMgX4YqOcuHrEw8svhQfqOgqAuY0hybqPHRFEv
         YdvQhXWt3KabigiaoS5jGCJtibYz25c0X5phU2lo3q5sz1tntpv2UQzOXd5RNBY3pWk+
         PQJ3m82PYhH384uJ8yEVCduXAgourpUclPGCp8h4DwP06DGTVYAUwtgLAs/WSAJARr5n
         uyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757421875; x=1758026675;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UQaDHF+OqdVZFz6Y2By3JYrIbz3IYU9PimfS5JdBTVU=;
        b=V3sTZ082axvoJc/NObhmrXAL6jxNDjEnDGqjfxgbC5OD1YPilvK8Zg3NBCKQZ38QpL
         mlIC3HdDdU+jCLvQ/UibzdBB42VikAbWONDBsqy0pRejscfCsrw4KAI42HINMlZZF69L
         EOyJBiqK2Z8zOa/ajF8Il4vZUa0FixRb3g4giIAhSpwxIFQdUpdx7770vAMO5g4Bwkbc
         trpgSPrBWcjhFV6wLN9v1c7C3AZGK8krd4Bk0m3vPUIsmQJy+2TEnLCQuSgfnFXRSrWH
         S/kw7gepFvOOAiyNd++EdqDJlXGpU1VqlEA+ZkgNWj248GczUvy3ycYRrFTYqPdpJuZ5
         +v+A==
X-Gm-Message-State: AOJu0Yyjl8HJnZlm2atiCf93Y6KpBu6vLf5zfoZdtEaw0qlpoCiYLu6U
	0Tg4sxY00I2tMNsQQnB/IZsSiXq5CXgQljLiYD/E67Y358vbtJzySGk=
X-Gm-Gg: ASbGnctr3cbaWngQd7y49+FEc9ReBnvDyWBjAvOUbJugy7IbizblQPw4GE+gpjNDvDa
	GzSidZlWloVwZGRAafRFXfBPPoJD/LryzZ6Yoawu97x/88VKSziBFDcZi9NAH8qnS7IPJpZFfOy
	iKtoEARPmorcuBIhHJShiHxM8AVEn2y76MMMe1UhdVl6PAfKoB+Fq1ls9Iu5c+cgHrDPYzfoYdE
	HYhDQYXFh1FLZvKQK/kKJdyYAea7vx9VuTnV1uwalckeCBlTVLUoOnkmZWJcSk6TzMHzPBfZ4Dx
	/FxHWK0Sl/7C+fA/7wLZwh+mjTLF2QSJPoYI16jj4pjcV2s2mQo+xwzsb4oaROkqNrG9RleZafh
	GRICxXVP42QPLHHG05UfeX8h445bN5KDNkMlrq0zYhk8hqsC77JHGTZYMtxHRINR+XVALU4KA79
	vGCDJI38Vf
X-Google-Smtp-Source: AGHT+IEsx7Xxj+2lRlWFeshLEPV/hPgQbvNUMtQMttEiRIzCxZzOP6ON/5bvIiUPG2wAblUV+ecYAw==
X-Received: by 2002:a05:600c:4f47:b0:45d:d903:beea with SMTP id 5b1f17b1804b1-45dec7992demr37367755e9.30.1757421874469;
        Tue, 09 Sep 2025 05:44:34 -0700 (PDT)
Received: from [192.168.1.3] (p5b057250.dip0.t-ipconnect.de. [91.5.114.80])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e50e30asm490545475e9.24.2025.09.09.05.44.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 05:44:33 -0700 (PDT)
Message-ID: <5a3ee5de-0b95-40e2-9bd1-f0b544b70530@googlemail.com>
Date: Tue, 9 Sep 2025 14:44:33 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/101] 6.1.151-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250908151840.509077218@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250908151840.509077218@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.09.2025 um 18:04 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.151 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or 
regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
