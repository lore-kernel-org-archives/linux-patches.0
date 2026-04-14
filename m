Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9B61E834B
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 19:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776195435; cv=none; b=LXrW0E6Bmjx6/xabg3D+J3xrpDi1iGPe96as7jHe9WR9gD6jSsO0DehPJvuvFxp+5ezmumb/35BQWsTID4m1c8R1oNZmVuxnrgFyLIFMyK8nIJcWzzzC9gkeWA956SsnXsd5tHEF00mDl87+dy9zd6efmiaB01x2Yigy3YL3pAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776195435; c=relaxed/simple;
	bh=zGSNTWJTYjbMiGssao9p1xIyMc+rhrZek7a0GPsDJ6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M+BG0JOV9I/T9DS2UbuiGbz5VHeasSvnVVvu1V+DIinWn5eSKRU3+Akxjm4KhSs9cAf85OpQVjxfp7mrigufwEc4r9EhaAxF6p4hle1BCX6+F/tJFuZKy0MawRsk399HEWzaYrmSF9G/UKnG9Pjl95BLxxNePi8pc3u9GcwXXDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=bCTKTGap; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="bCTKTGap"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488af96f6b2so79043415e9.0
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 12:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1776195433; x=1776800233; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wDeSAiwIMC4uRwXkLzxrSw2LWZMPVa4L0Md9dCJm6PA=;
        b=bCTKTGapBc0jMk9St90QdkcQjDtri2wDNJzuleqZqRYKoNpdgRyAdvPSwrt76LE5LG
         b9fWOoRZWHWveu1IqdHP0vQawftVJlzziDzoSLEDQCHDxUS+v5TkwXNEtFAVbp3mpAej
         BJRa9phu6dMMLx+GrLdwHgVQuMPndSamsttrSQ2kR24a78QO98eQRdXkLu0aJIWGNsfY
         Kc3tNI1+tAYxQftWtnDRHyTXyo5VHHylSJzJgMXEqTBCGSdHAHXCLnNHBNfza7w8LdVi
         XhwgsyJ/BTcTE6dxtDb3NnfgUwPTCFswyZM+VJ1pflZk4HYYyk5ogF4kiDUE5zLCggc6
         B+jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776195433; x=1776800233;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wDeSAiwIMC4uRwXkLzxrSw2LWZMPVa4L0Md9dCJm6PA=;
        b=LR+7N965rCAYIGsPLoAz8hRtJlRTd9hYnBfhodpIaFt4ObJmv7gulM6PZXNV8lgBtO
         518PwTpece8YUfGTB6CejjIkws1iTK7gZbFjv2Zx0VmoTGLoUVQfHuS6+NBdcZ2Z9PrC
         oiIy7klnC0tHKVvcs4XrA8Lf55SaISgmm6iK6DkXMSxJdYeRreFLHYX9IhTVbnCAifpm
         i0cgzrcrt+0013j+3kXTf2whodFVvqyKcpeagxxvdwsZva8HpBolaFJUj20t9PcpNRu3
         bwet3wR1CEhrGECsyMOK8N7PX+lC3WLVvY9J60EvYkeYDKJ2eB0GYo4lI41T+qOIA9oq
         CZMg==
X-Gm-Message-State: AOJu0YzvNQV26Xj2cSYZGBsWUEC78yL/YT/cYsuFeE79uRDp/ISXctP/
	tWV71zYwyxtfprGQTLw87n2bhJD0QUanDIfEk/rKOpj/ThnXBLFIEcg=
X-Gm-Gg: AeBDieu9bfNmqebULOjaPDlzUSIbYQaY6UBVXHtWes6di3LsKc6AjHP5S27+u+mPDh6
	WyhObJqp+lWEhaTNO8X/+SKXEBVO9QzZNhmrHNssVLS+3tg9xB+ySEEMPV8tTFqI83LQygGH/LB
	cK8Z3JTxxls/q2tExAKYrVaXqC4Hr19qphdY3fGnUWxVHBpKszpXB6CuZRBeNDSMVieNuUce5Sc
	7LOovNUDgYo0guijQuSsZ9qcaBtl+vwyT6kbOcT04pqz1R8bgCK9Ym9R5RI69/cfR6exBc7ls9T
	XwBl5JieaspMDbRn30Cy8OpvaPdxzLTw6iee8IswGKspn4Q3hy/VITf7wRkxVlv2yAlY0eN4ND4
	qNkcDNfZlUryrBlPboJBn2WUXHLbgxAIimGbqODjHq10hjXbQlbrL0Q/8o7cBgqXyxpi4pwTZWe
	dTLp/f5+UqrWWxLP8tvyup/l3tl5ZYJFwtSLDAiIyYEQFG+FSpU09WQDdHiJ1kTSa7Ljgt92t8G
	A4=
X-Received: by 2002:a05:600c:820a:b0:488:81b1:ae36 with SMTP id 5b1f17b1804b1-488d688688fmr261645175e9.23.1776195432464;
        Tue, 14 Apr 2026 12:37:12 -0700 (PDT)
Received: from [192.168.1.3] (p5b05757c.dip0.t-ipconnect.de. [91.5.117.124])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488ede1e826sm143417485e9.6.2026.04.14.12.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 12:37:12 -0700 (PDT)
Message-ID: <554e6039-c7eb-4d1a-bc14-2c84bca188c7@googlemail.com>
Date: Tue, 14 Apr 2026 21:37:10 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 00/83] 6.18.23-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155731.019638460@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.04.2026 um 17:59 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.23 release.
> There are 83 patches in this series, all will be posted as a response
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
