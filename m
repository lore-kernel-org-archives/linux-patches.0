Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE66E13BC35
	for <patches@lists.linux.dev>; Mon,  2 Jun 2025 19:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748893900; cv=none; b=X303EfL939Lxux3bClIdi6r7e3csJDuxLtfprKGp87bKNVCrfT55mYXM5Tuuzt9Og8NCNBfpMTzqgjllyOIdqADBUCwIzGioizqw9uXAYA12iWhc0wtzw2cotZygmXVHra6oBqPrWsxfWy4Jc6LE6wQfTaBiSxnyZvP9Fp2CgKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748893900; c=relaxed/simple;
	bh=PDxgwHxZ2fv1zHkhlESn3ZqpBz71BeATIeQYdGAevYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t37NY2+i2ucpg8dOP0nCbTvu3USCnT/83bFXQjevj1PJ8yMLORSTiIpi/DqJWQdAfnxMJj0jfdqgVq0o0VbTGwLiIPAvKzMKwAi/y5W3jIZ5o7RHcetDIsk1n4J5LsppP06ZxWcHJclzSMYCsQ1wgTN8ZuNwT3T57hEfPKBjLvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=OdzGaOnl; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="OdzGaOnl"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a3771c0f8cso2944020f8f.3
        for <patches@lists.linux.dev>; Mon, 02 Jun 2025 12:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1748893897; x=1749498697; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FdQH+gYaWiAPPdu29kvcsCjEWq2JnvTRRl0+eDrbZLg=;
        b=OdzGaOnlmQ+nhfBzT6G65nPI6W4IEr+txOB37PhV7e8SIEw5h9wJe8NU4Zg2LIXtHn
         SYqO0yg6oIo2CQkaMtpxZ26rWk3rDK9/5A9BAyQmyxKxa0bVEUzqyL2b+26AsTyBkT4G
         At15m4ndgX3P8OqiGxcSdiXYCPuWf4D+zQuRJ50IzlG4n6jwuIT3FLS96fSIXyFgWhtB
         lJ/VfVsSiSuA2rR6cFzr+scZrCRzvRxadlltPI7XESQwTdBfiKfqxBaB/1eX/6ydQ59q
         /M6+Ay5ua8ldjBWbkw2JvM14AsMFG+7B4QcHbyT3WkmwVpd/ef2Ad8o/t5G9F5erDjtk
         x6vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748893897; x=1749498697;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FdQH+gYaWiAPPdu29kvcsCjEWq2JnvTRRl0+eDrbZLg=;
        b=ZK+hMPi+gE2AdI9QzZfXqUjUwWWSr/RcS9GPcIjWKNEEU2u5/wM3JWVSzVnGVFQK09
         RV3U6Y/1G4dM6GRM9SRxzbPstw2fnJGnR8K1KR2oNxED0QelEcpHnRu4B7keKnW+kQF2
         AF3e5YiKo1xH7m/uejiFGviovkkbW1AsTHHasOsoRVd5MDmIGONL4fFg4wIQ11YU5UnS
         hQ3vEHA7JUV9ZLHGjUwVGKa6PBozjn/yfXLsaU5pSFH1cQQt+Yzlz7kMUxzvPf5/1jn8
         tAaUVEJseG0T5HzYEbSJos8rcj90hlRC7zvDDs7r9WIJFMZalUKCsD7G4O/UdgawRKiO
         WX4w==
X-Gm-Message-State: AOJu0Yyt0xDyLQKGyttqCONvYWFpazUcPy8ovqxm8zBv5wgsGCBRMuyd
	j29P+MrUvLw5c0jTqdOWk4e3jUZhzfzRLRv7UlNDVaBEW60j5JDlvvU=
X-Gm-Gg: ASbGnct6sZN7X4DpyOSN5YMsOKIKEbeQalHk3GOunHeNUr7iF3Fi6AuBaNFf1PyjkfP
	2Bgt2pf5DKMrrBOQEyRNIeF+7J7feCLXuDZizfOgqh7YXQ82HLeHFq/EBgc6/i2TttZTDmCck3t
	7qCYO0S9XYqiDB2fW9/EekHMG0YRYNKNHQbXiBKhZ6fQQFaA1o8c5FTOIsNYOFCL5h78FSopnwj
	4NCJcX6Od9o+JblY0YBOibkoRj7V/Etd6MQpmG2HMlmraXfy7bec87jpLNSkzIKYDVSWRWc9/lF
	e15fpOb3hzZ0ky4IHX0obsN8dAd5SfxcQAUsbf/x0FVCweleruvACEWdTGTcSkVLJscH4XV4Ro7
	in2x6nXCpimNRWqg8x/WgO93vUvQjuz1aYoxQXw==
X-Google-Smtp-Source: AGHT+IEMS/aWQ1Ihl6wDJsvQbfZi5zg23IDKIRWgu57p786dbUitQSIW7l0HnT+yNLwD9jcz02z9ZQ==
X-Received: by 2002:a5d:5f88:0:b0:3a3:7bbc:d959 with SMTP id ffacd0b85a97d-3a4f89a89f7mr10855462f8f.18.1748893896920;
        Mon, 02 Jun 2025 12:51:36 -0700 (PDT)
Received: from [192.168.1.3] (p5b057d53.dip0.t-ipconnect.de. [91.5.125.83])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4f00971fasm15693615f8f.77.2025.06.02.12.51.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 12:51:35 -0700 (PDT)
Message-ID: <b86b9c0f-0a3f-46cd-8f09-a30ba7f2fc67@googlemail.com>
Date: Mon, 2 Jun 2025 21:51:34 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.15 00/49] 6.15.1-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134237.940995114@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.06.2025 um 15:46 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.15.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
