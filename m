Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E2C4B0C98
	for <patches@lists.linux.dev>; Wed, 23 Sep 2026 16:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790181567; cv=none; b=Scuqcav2rCZXh7KwmLNg/V5GffCbAspq2K/jJ3lNLQQd0VDZJwy3rviKrTTiyGd6bQru1e2jZQFnQVHG/wGIrdqnMOhtRaLsV2NEKNcm3+JHJlsLP1s5rRxmb9UHjR6VyQppaZXQefOKf8jB0ig981RKlJ7ZkDjR3OM2VGmH0Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790181567; c=relaxed/simple;
	bh=zYxOn8CFswfpD8cee+TTJhFQQ7s8ryaLPNHNoZMqIQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CdJXnP//dGntSAptlGNx/XKaH1FaTTc2HjdpOu4wQCSqVTSp1y2aalvd+GaaGOdIX+lDq53nC+5GbqYHxCP1RidpUCEDBgk/tHh/i+MS/kZukji+aA1k53qhaE0nNxwg2SUG1eRtN8WM4ut8pWrqynzUCajsxd4t6Ig51uyg65o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=jSIeAqo3; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="jSIeAqo3"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485933b2522so956994f8f.0
        for <patches@lists.linux.dev>; Wed, 23 Sep 2026 09:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1790181559; x=1790786359; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8nVHudn9MO9aguepD2cEijWmATUMlOFCYM2H17+Txec=;
        b=jSIeAqo38GBTUGXR8gjIOWo0G7FFgKPNafcjRSNPGi1aXVc1WGEdTwH0oZXKNXmo44
         FZFlNo0X6f9jFFFeJCmSgQp0qcpM80H5sH3eWR5paxblApPLfV+9Hulee7z2BGekIgl6
         HRJzxRv7/a5WixhiwdaHLoe17G5dn2ioNrHx48+QK96fSawK0Sscnb6o/05XP7tzxJXb
         InPtlKUbtvR36ou2NrxlKAKIkg/TKhF2dQAPayRP4ctW1c+uC1rpIG9I5i7q6yGe/Qts
         TqcKPuJYeS90+RwEmMv4IbjY7Xf/mokiTTgIYfpLDE8lX6cqgat9k61xDeeq/GmLNTPA
         MR0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790181559; x=1790786359;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8nVHudn9MO9aguepD2cEijWmATUMlOFCYM2H17+Txec=;
        b=LYknVxL85oM/D9FqADCdytoZBSeAqDHP4m42IOt+bqy+A3tDdtmqqX2uvTRVTRC++6
         AbZualqc/U0UNLf4bLBTk2VKv4BSyBIgJ9OJdled4jV/rAiFrQiPp9i++vNOUTDZ1lao
         HXnaZyPgIPaYgAingw7ylWuKvIVw31Fe9PUqyBM5xC8zCQBLLPp40psdm7x2RUk6WwGP
         hNOL5UiK5HrbTfDsz4K+Wj0YU48ENbi5dme19HumT960a2Y4wKZ1NNXM0eziOG1WAZgP
         wPklE986/rOlzsHgQV2eh5G5xQp3lGXeW50OVbJw4kS/xz+bU2ZURfB8E9qRHvMZon7N
         KRRg==
X-Gm-Message-State: AFuF++nLBnw6Nb+dJfnbMAbO9IANlhtQTVns2ULblcAOdZnwDQLBJv3Y
	iKRmwHyh0zZzTSXNxmRupEIiPC1dZ24XgohGnNQp5hM6v8fx54c99n4=
X-Gm-Gg: AYBFou02xU4hev6mNMJnnFQNYVNjONqEus76Uv9r6cGhNfHKPm4TgvNBXnq3veK0jBP
	t/ZhH/1GDHPvPLACs7HF8z8lHXzpsTsS9E3kz6lCvgd21nraAily8YjuBS6HyZlZGllOvGhmDdN
	pP7iXnhlobbatlcZ+3MtecjQ4CwcJJZbjGmokxBaumV5WptWYfssEmIs0NyyGLCMKc+CX1xoJE9
	sbDJjZOeSkqE0BowcrvVPBnuxxUWTl7kvcQDARuKPRmbuAEUCwHeE5Xe7mD7XD4IWNDJuM+6aOu
	RjfT+GmEv2egDumWCBib824/O7ArZjej6/ldkp2yhxskC0jegaWXus1sVaBxPhpdGEB0KjsTPBp
	+9DN6HWK4pXuB52mNnZXBBPqduX04Whpd/6Mb9Kz4R4+ZS1DrVFFfD5eX2Aty+ac5C4pILXWHYz
	7vhEbAIrqPTJgxkbAJ4nJi+Xnk7uBOXnZBRuX3XhSGEpztCg11NTtco0ja/P9pLv/FaBLeVh5Wn
	q5R8yqD7qyO/Vm689rBRY2stCh67/w9bezAVMGN8/ytlKIO
X-Received: by 2002:a05:6000:4023:b0:486:f17d:14dc with SMTP id ffacd0b85a97d-4886705f8fdmr5813748f8f.12.1790181559089;
        Wed, 23 Sep 2026 09:39:19 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b415d.dip0.t-ipconnect.de. [91.43.65.93])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48868886e45sm8363363f8f.31.2026.09.23.09.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 09:39:18 -0700 (PDT)
Message-ID: <aabce146-96d1-4556-9e30-540cdabc8a1f@googlemail.com>
Date: Wed, 23 Sep 2026 18:39:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/398] 6.18.54-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260923140643.441954610@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.09.2026 um 16:01 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.54 release.
> There are 398 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
