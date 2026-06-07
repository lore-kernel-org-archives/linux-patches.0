Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBAD175A62
	for <patches@lists.linux.dev>; Sun,  7 Jun 2026 21:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780867912; cv=none; b=XT/UsoEmDsHWli+P1tZFRRKFgh7TkTflU6AhwOfw+35QU3ju2fIT/RNdwHJbtXk9d32X05PXghG5A1QydXtS7dP07L8Sj4U61GDZuu/NoCnQmkmC3HE3uelOgCOj000s6AdexB+HESHe/IquEOL6fhdCGRCl5SUBoDpAgx/98tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780867912; c=relaxed/simple;
	bh=DxO8RqzscgWYf+wIOrGgjSYaWUOAiGyJN9i1tPFtdXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GKhizlyJV2AqOeunPS+G2orZUaO/L3UBeSeENdgzeYbNAsjhApfWCt04sswimDO/rQiC7l0xpl18OhU7CaRQrRpl+nlMUZmJlXQ1O+7x0j/3s92u8c0ves0t4N8emfLI8vaNNnsfjvkAuFZOki4GjJEkI5pvYBXXslx6hr2bFSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=IoCiWQrI; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="IoCiWQrI"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4903d730b1fso41095185e9.2
        for <patches@lists.linux.dev>; Sun, 07 Jun 2026 14:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1780867909; x=1781472709; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j2gcOathGztfrOdVPX6VicT8KCAhQRH0y3mn+5yBJLA=;
        b=IoCiWQrI1P24JNmKKnqBafs/LC6pEICBpXCWyzZLUEqK5sCUBwqIkfWg8Ua1ALilGN
         bY4Ip1MzVsQV+dPKoQhFtdINvkefzpM4nyToP7sBuXae6PvBxyBrtf7pXAU2MUb5B7pa
         SzuOnI4bBXLODbMTrV/i3oQKv0Uw3w1HznYFJ1TCRKN3YUgq4AowCYC1rJJIsSAyitdz
         zh+2skhpV+n8tfBT0PnotSxCq2DcRv5/P6I5amyIfi7uHuqUeeMjgtZg1msg8Sd0ftz1
         MjqUvh+8uHRFCiDR0Rs5j9QZ0L7fHFC1MDTDfnm6Fjy5qraqGTIILBBL9yi8L6CGSQ0q
         k3OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780867909; x=1781472709;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j2gcOathGztfrOdVPX6VicT8KCAhQRH0y3mn+5yBJLA=;
        b=DhB30+JIsUhNwvZEiIkBHWkbFQdRcSWf1AYO6JObhVWGJNL0wrL1JGgejQYgZ2OSS4
         EkJoDifSLdmetnZekoU5U6BpwhRieGIbHX/QnknRmy9sWmQKt9GP6su0HK1+XVsgbAPs
         Af6tNRbVeKmGGXtzSVarxwVebqMPXdOK7uYE7bRLwBnSk2gdjIPw14koTS1MGl6HZtT7
         0XTHkFvGH7OEGZWwhzrFUXI9+QYilnXlttKVFyEDP1ApPWClan60GLX1ObBBTVI0PNPQ
         sK1FB8b88YZhkrAkMnl/4U4CZlfMKuUq/tJd3rF8X6ASyhFnbtfdnUHivpEXv/hIOmWh
         m4sA==
X-Gm-Message-State: AOJu0YzDQqF0Fkk3Z6rOobtZ4sEJQTbCXfqGlvMg9kddWJdFNdAc1UHr
	pzVsv99jpKrPbUf9txpHLja9BMu+iQ8x+QSVEQg9heLGYTDHqYiiEPk=
X-Gm-Gg: Acq92OH7KKWtWH13vKzBfCciWrCQvhiiZgDPHyb3DQq1OtaTnrRySFEKjxQFlNQ70VW
	GeQNTjo4cqVpsUwJxq2JDdwJIE3iMtQ3/iTxDtkBCqpbTXbc7emx8YQv92YuNGiiY/s5WE1hA/I
	hlqoZjMmjdgNKWBBYbRdHXnL2RdFRWvQxegwP0bqBziBY1ANAebAQvE6GmomHf+yCY7CMLYkeXI
	8jQXb4GP9t1arFvmP20kkmxQ1eWUlcm6X+I+a6BFN4uGONuBl2JXuxUfChAHw/FhgXbiSaDHkEq
	7T3Fyb5TnbVGTqQ2OczICWZ0tg8x1c6cwcEuD3BTRIF9ZjIS+nKmyrYxXrCYQr2TKWiFK+NULbt
	c7SEqirlfOA/Jt50k8hTo4YEJ5HPLhmaKHXW8H+CnrSNdv+QyNV0eFBuMjYH9PmiIHERqCDpSGs
	9M24ZhCTumO38i5EiU1H8KIfUk4DrFTcLfoE8/7ddZPwpV+KTjU/I+9YB65p03mWeU4ltWb/Mhk
	4Mgk0zCst8VkA==
X-Received: by 2002:a05:600c:4f90:b0:490:3890:605b with SMTP id 5b1f17b1804b1-490c260f448mr224236665e9.31.1780867908858;
        Sun, 07 Jun 2026 14:31:48 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b48d7.dip0.t-ipconnect.de. [91.43.72.215])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2ed944sm47459482f8f.13.2026.06.07.14.31.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2026 14:31:48 -0700 (PDT)
Message-ID: <44b1d1ab-923f-45e9-86d9-abd235abdbca@googlemail.com>
Date: Sun, 7 Jun 2026 23:31:47 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.0 000/332] 7.0.12-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260607095728.031258202@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.06.2026 um 11:56 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.0.12 release.
> There are 332 patches in this series, all will be posted as a response
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
