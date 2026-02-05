Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59158469D
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 00:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770250480; cv=none; b=ezFzUvxKVhP1OaeNh9wYYBIR9TuQOaCaaTnwcFfPoge5OLWZCQRndeakrY+OjJZ3sDCiCma5WRBtGYplv4fonYZ8S53Veow3fzuHta8KXSCBibD0ubTN26BJuIyKXBYZVVG3oz1Ef4/M6EkdDVG546lXNgUhnCLUYPcZ4tlCJkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770250480; c=relaxed/simple;
	bh=uFO4zVF/Hoko0cv5qb6/oBheywm979vzS+61mnbUN/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k3JoGx55+eOJpLIoOdSl1fCMP48wib6sTrV+PU2Vt51UNRakIutZIWSjG6Kr0ijkHPENOxaTSXnKhyg6K9dOuKaN83fGbmE3RguPdycK4ddMuQJyh89Sj2ZMjHwZCfponUhEMthmqtL6Y1MOCwp7vs/i5IS8eb4oMhzruNgQiNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=RrNp6br1; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="RrNp6br1"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b8842e5a2a1so40557766b.2
        for <patches@lists.linux.dev>; Wed, 04 Feb 2026 16:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1770250479; x=1770855279; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XqowFhkd9Numzoj9YJVWPlTlwbbzoHzVE/LJNEUfcK4=;
        b=RrNp6br1aAnSb0rn0qvx+heC/sJvOkSlaILCj+K4ZzRH5lON8lQO/5D9rNt3AlOM1r
         1b+Na5QFPaq14tu7L9EFdtG2UKx1p+MCLOIRO67+zBsYxiQtYN0cJJwSZ479ak6mV05P
         QtftL8yaJW/y3IM93qnc821BzWN2dkvh04XhXzPQj0zSSwB0NII5vA5EqnrGKSA6NR42
         Shvvd7Vy22Xv3sI2fDbguejpR9NtiXGfJ14Z3lBDxhokrPGJW5lB0XcGK2/c43S8xZC8
         t1jsXj+VVJmKywPc/4ZmN2pM60ppHTU9fTbWC1GPKIef6j05hSDCeMxeLBqwIbIdc1J1
         tfIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770250479; x=1770855279;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XqowFhkd9Numzoj9YJVWPlTlwbbzoHzVE/LJNEUfcK4=;
        b=Egk+3Y65NPPBqnsVmcFa9HCa9amBXdsUkmY5SUefM0JvfR8P2U7u2fai5W4ZtT1cDS
         CfeH5IG7lMzOcGLvsdwlEwl8yxHdh59zBCYPY7DSLeGQJJWbK6uvX4IEAc9gt3odsmtT
         vDivsv6O0wA18CALfrfqOMBd7J9nA0Zp3qurSeUaCTHs4lPpykjvYj/xfBGQt/5NpAfo
         5QtGhMMtcX9py2vfOv/Pazv2bsss614HCGVZQoWRrdQWFc5RqS9AJP1bwB706vhZnToK
         up314mkpBH5cAfFoVzKaQYitajzPx41MredMQw8A5W4+cRJOFd0D9FmGoB6x5X8n1FV1
         reGQ==
X-Gm-Message-State: AOJu0YxuqV0hiGjeSGt8XKV1+NNvKIrjsEC+kFvghyVu6iwa4QOJvG7G
	dBRfyFaO0ijCTUtxOOBe6N1yPr1+d7rUbj93HCalKwOf0NGUSQEP/OI=
X-Gm-Gg: AZuq6aKFFsvl36r7vmzX2pX0/T46gxSUOUv63DPEnxJKJMm78NtlrPaIIZCgzRQm+BN
	vFAoBIjDwdTEeCmjP2e2QrSM1kk2csohW9LC9TAdyBncKY4FCFszWIMrLUIiS8s0Y0eKcGrzqg3
	i1uiM93iZAz+bvD64NjgjruPuoFIO7IjBIKfwyQd2NPbsJsASJ2DpemmuBPkuqwqGpvvYF+84tq
	8IHlgE1ExaRy96ZdYXv0FpQKiWUZsOgojKENuL5/BFsIqEvxJ3ePacEzWfrhDEGDveBVnnNUPSY
	QSoNzV3QYxkO4vKMVznr4P0i3R3BQulNssLNT8VaYU+RFfyW+a82nVOcvNDYE6/9sLm2+gTHjLs
	O2hEdU7o7aUrurAweM+wVUOlcGAzk7Cn/KIEsPD0O6KjKVLbl4y84Fx+YgtXyUfBNO3PtmT8q2p
	eLInI2AmYqQ5mQnGeuTDV3lBSliCabcMXA2CjhYFs5Lff1juEtaNozy8sbQaBA1vojc/fPz+cu
X-Received: by 2002:a17:907:3e25:b0:b73:667e:bb29 with SMTP id a640c23a62f3a-b8e9ef30c03mr308075866b.8.1770250478447;
        Wed, 04 Feb 2026 16:14:38 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4d5e.dip0.t-ipconnect.de. [91.43.77.94])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8ea001eba8sm169483766b.48.2026.02.04.16.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 16:14:38 -0800 (PST)
Message-ID: <c19e958d-baec-4c42-ad04-03e163b39363@googlemail.com>
Date: Thu, 5 Feb 2026 01:14:37 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260204143851.857060534@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 04.02.2026 um 15:39 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.9 release.
> There are 122 patches in this series, all will be posted as a response
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
