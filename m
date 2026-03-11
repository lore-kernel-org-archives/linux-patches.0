Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FDD2BDC29
	for <patches@lists.linux.dev>; Wed, 11 Mar 2026 02:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773195515; cv=none; b=f4xxEnfWJBoD161KN0mVnL9xGtcxpHZ6eWkSppzVrkmx8KeRospvdVXmKPI7guQZIcTDOrhmuSBBR2MMA0OmhudA4M1wKh//bIKsqwA01OKkXPkpegk0zd8k+8LJHI/3dLXVSArcmWMHPIpeDbwjM3gDGtC+1E/bzs3gyn2gLJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773195515; c=relaxed/simple;
	bh=C64KbYJW+ftJBYI+Ni7BGoCwcOuELdDrOYXeUU/HaHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DRjsJwCtZ2PPob3AbChVmfqvLKy9J0nVERTb5rT95y4o0ETzIFHA/gX8J0m7mojPLovKnzT6mkp+y6WjS81ztA8Za4BkZm1WnyDTFUoo5sM2KTrbncJ8n27FGg3mn2VCwU0Y/IXxieeICb5btcFfzZpLNzYq10bYzPxokhhGSCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=V8DJ4VM3; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="V8DJ4VM3"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-439b7a87fb5so6606505f8f.3
        for <patches@lists.linux.dev>; Tue, 10 Mar 2026 19:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1773195512; x=1773800312; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/s/1pmy/Fni8Cotjp/F4qQ5X9Gx9X8u9ReccvcLKD38=;
        b=V8DJ4VM3GrNsyt7SDy+KIyQyNaU9/FDrgYbUebBl+Ba5OOJ3TOEcUSPL3lDbj2cIR7
         ifrWmQOatqfu/oJVw//zgkpzKxL8ogwCMiKUA6/ZkWUUYO7d8m5NsETcqUF6wJ+KB/dO
         N/+HB0V+vOrC9hvHR783kIm5FOJvsOhhjBaxaQY75SmRwwC4FSB11x5mfst65UjQ3Ibs
         LRs9OA16Qm0Ik0TkNmy3lOc7aAGHP+FZbC0v0hJwZIrud0bcwq9uUpsUHIzibv9rzsOS
         PDwZlB/R56Z4a6aikmobrtEE5s5Kcm/P/dwV7WWtxSE5DDPaMX+RGgsQGuvEY44ULxNz
         MlbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773195512; x=1773800312;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/s/1pmy/Fni8Cotjp/F4qQ5X9Gx9X8u9ReccvcLKD38=;
        b=wYyEBDNvAFEeDTwwKwBTZkxZakvVrH6WIUVw02syOfzNVtakuk6oB4CFqJLsryiFo3
         0lEyu67DrpmoZooprYllDPzrBQm21cZZUk1Hoo8/h4deCVE4yh+Te5GKJ3kvvL3yOHpz
         jSy7+POduHzfAVya+A7/s968fQQeJl2Uycb0VFdR1LzsisaRcyKif9OmqlxMjn1A14nh
         ez5RU742oS0+AZi1ui3YrBM002BqPvt+PJDRMn6ahZ4TO4IR+Ph4HAZ7onFN+QOw4lgb
         ebjYddgJjTxrQ6aPvrU8FYY3KsUpnHd9MigciYRtUQgz0cmRw24Vkt2tGwpaWM+VVOrR
         no1g==
X-Forwarded-Encrypted: i=1; AJvYcCUGzV+B0prFgsr4/JqHuZ88t6G1ZIwpPhA7ucSNfhYy3v3rr2lJ4uSRMEOSTGwnKYCU6vEmmKr3@lists.linux.dev
X-Gm-Message-State: AOJu0Yyy2CCNrwo5UHPAdW+MdNykuT+tRp08hV04MKhkKzfKCRlPXky6
	jTLhniJvmCAj/3vlaXUM/SCP4kgGidq9T3bJgXMpJyF9H0idmhMtjp8=
X-Gm-Gg: ATEYQzx8c0eTTdqxkKrsouhk+88z8R5Ap/KmFd5vuua3qtJswauYTi7dgRXW1C8mN0+
	GY9g3NP6TbFbHO9QmUkni8J3CSa9AFduZtAddDGB3wS+I8q1l+GLfll5XxctrHXob7olWZpZolV
	e6c47lMkadlP+PvJz2nq00fs/y8fCITXTNsUm5up7otTkyByrRZcCtq3YvWzeIOZnDBO4vlmH5u
	qByq4HZaWCXA6MIqMJ5I9DgDXldWNxUKz6BMOnrZrL5+/COQLG87l9yTZ0D82nsMT2sfI2I+Rch
	JOU1IjtRH0eb45W64IB8gfGTjB52uSoqZZ1KMa9BVeP2urrxLjJMK507cUKvD9TkxmMjzLPOvcv
	MBd1bRF11jdROH7khLVwKRztYRZMVdDI70CabritdfZeLjY5KpBzbYrzSyh26HfOOwCRarMbGAh
	dNjkU/VJjWiSHs+2JC8EFLEqRF1JDGXhSq/DDHdO6kFrqst5Ajx0MUbnY76MQgjNm0ltSv/qppP
	ZA=
X-Received: by 2002:a05:6000:290b:b0:439:b8e7:8f75 with SMTP id ffacd0b85a97d-439f81f1651mr1663537f8f.3.1773195511809;
        Tue, 10 Mar 2026 19:18:31 -0700 (PDT)
Received: from [192.168.1.3] (p5b057cc4.dip0.t-ipconnect.de. [91.5.124.196])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439f818d4c8sm2852213f8f.7.2026.03.10.19.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 19:18:31 -0700 (PDT)
Message-ID: <3a64e77d-d314-4f0d-b4ea-2e290809bf93@googlemail.com>
Date: Wed, 11 Mar 2026 03:18:30 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/314] 6.18.17-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <cover.1773141554.git.sashal@kernel.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 10.03.2026 um 12:19 schrieb Sasha Levin:
> 
> This is the start of the stable review cycle for the 6.18.17 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
