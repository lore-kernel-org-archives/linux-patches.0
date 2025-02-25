Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07AE126C18
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 14:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740493524; cv=none; b=BkA9wwooVrMOM2Q9oKiy2++Bs3MPwkv+vNqx/Mmmqsie2rCnvTTVZF3NfMj4yUbeqgSXnlrjb1LF/rERkEXATbUJsPAXfepF4jhkFEVNSlgmR/qCtQ7zAiYk6ZjjMFVY8nu5RjBEKTUSP2iLbFF6Ei+VOORQsLuE/PilKGG9MP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740493524; c=relaxed/simple;
	bh=Q3RJil+VHeqSzKmw90XF0Ub/vSs2FGhiO8M1TWVwjXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MKZh4biwZ1DxlhTKoGROFGZXRZLQ7/yLAXohfvzItqvsz5ATabphmio4vRtG/Bi9+AdOI9PU72pKofe1XHTFk4Ma2Fafy/aPdLYk3JtaoQjWFZXfh977wzp7fuS7WTYallOKkNnR9EdmISczr8u8eqUZTfJeOjwdwmIMFn8fR8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=GChzMWKY; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="GChzMWKY"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-439a4dec9d5so54915865e9.0
        for <patches@lists.linux.dev>; Tue, 25 Feb 2025 06:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1740493521; x=1741098321; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AZf/o+N6Kz1RJg00ifbZNFSz2scXP1N3IPoo+w/Gz88=;
        b=GChzMWKY6LO8rZU5bzLpUwW6sXizdQ9kDjO+gsQlo9q+xTHfjlDu5U6AiUUWY+l54x
         aJ0W8pzJVFUPnMCtmLQbAmQ/Beq7TlpvUrE+nPOS/UElw7pjiecxGXO/H6+1qm2TBD/k
         qSvJVVlOMcromtTm6WY/ehljTNv8p5DHAbNCu7Yvmtrpf+Gi3fGp8r518L1dCPe+JmTU
         VFzT5wLcQ7Ghd4CFUlI9QVP9WBK003s+d+KY5D8vpAGKxJyRthq8z+aaBGYzpUmSUgeZ
         KZvWU1t15BtAXGV1EXVjaa8hcNh0HQKkh6sWv3jjnX9VjD0iVrMn7OhHS6srk4yEinqO
         1YGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740493521; x=1741098321;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AZf/o+N6Kz1RJg00ifbZNFSz2scXP1N3IPoo+w/Gz88=;
        b=I5mDzY1iG/3osmXmS7sB9x4Xv7HPxqz5aCgVHpwofobd6RqtkjcV+OxLk16EQnjQWY
         3XWzbejr+P1ghHDH45C/zJFhfuTVQl/UHxsZX54L6HytRsv2fGic8vMbC93wX/Kd5mlm
         OSGMlW2XM9jUxaQKRjWSbUpOeTVcbHuIFpFkXiQi/PG37LL6RJ16xY9SH1nNEXei2TdG
         44LWaIeTjyYLqvmaHZf35yntgvegBjVewLr6ch62Kope5xSzM5wkTwGZ0yXtlA3pgdgp
         FJfTD/9NFiFjOCMU0V1Ah1Lk7zORR1bZAPRMmLxvEjSIfTjqSloOMwTyV46RSJ3uvggl
         CAAQ==
X-Gm-Message-State: AOJu0Ywi3h+1oronxoRr1ShonBiTOic3/OLK9FB2hTm2c2clnyUfQ3Aw
	3h86LiGak7NgDvxvUP5U3p7WayUp/l/SkwVDc1SDIYFV+XuueYw=
X-Gm-Gg: ASbGnctfGMH6/wOil+G12xiFdyg6o8/wLov5BB5hLHs/pMI+NRP3xzGeMt0g1KTDbGb
	lTdbWxRzAn59mkK4j1VFCR5mURUpxAKJwpDaT9P4K8fdu5hT38/uVEA4JYzLLFGUQZTbHVczP6F
	96ZEVkhhJTvJfMGDCLv5kyrlLDT/tfHOOKKGJapR0ppZt/NK/0xYZCMgPFMsQZn0xvc4+/uEcaN
	xTqTbGjm6bqVKUgC98fOKccoUjYmwGK6KIrp/Q9ytOmOTnV+Ac/H1TePK8v065C0q8v4Ivz7zwF
	ZRuzLkHkYAZRufIiXyZ76ug84Tk2L+fW5un1gJtlngKl6Wi/iYMZ/aSOEhYquO23kGLzz9J5i7y
	tL+v3
X-Google-Smtp-Source: AGHT+IGhdhiXQ4ECqTY9URWLiprLLnF779OXP/tKMzgBk9NQek5Qvqkfk5EpfkDRo1p5zSibaF4ZuQ==
X-Received: by 2002:a05:600c:4446:b0:439:9274:81cd with SMTP id 5b1f17b1804b1-43ab0f2566emr37255015e9.4.1740493520894;
        Tue, 25 Feb 2025 06:25:20 -0800 (PST)
Received: from [192.168.1.3] (p5b2aca7c.dip0.t-ipconnect.de. [91.42.202.124])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439b02e6cffsm142049515e9.19.2025.02.25.06.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 06:25:20 -0800 (PST)
Message-ID: <8301ce47-ce5b-498e-b2e3-412a0741c4a3@googlemail.com>
Date: Tue, 25 Feb 2025 15:25:19 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/153] 6.12.17-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250225064751.133174920@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250225064751.133174920@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.02.2025 um 07:49 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.17 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Like -rc1, no problems with -rc2 here. Builds, boots and works on my 2-socket Ivy Bridge 
Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
